import pandas as pd
import sys

test=sys.argv[1]
type=sys.argv[2]
concurrency=sys.argv[3]

deploy = pd.read_csv(r'./{a}/{b}/{c}/cluster-{d}end-status.dat'.format(a=test, b=type, c=concurrency, d=test.removeprefix('p-').split('-')[0]))
traefik = pd.read_csv(r'./{a}/{b}/{c}/cluster-traefik-status.dat'.format(a=test, b=type, c=concurrency))

both = pd.merge(deploy, traefik, 'outer', left_on='seconds', right_on='seconds', suffixes=('_{a}end'.format(a=test.removeprefix('p-').split('-')[0]), '_traefik'))
start = int(both.iloc[0]['seconds'])
end = start + 280
index = pd.DataFrame(list(range(start, end)), columns=['seconds'])
both = pd.merge(index, both, 'outer', on="seconds")
both.set_index('seconds', inplace=True)
both.sort_index(inplace=True)
both.fillna(method='backfill', inplace=True)
both.fillna(method='pad', inplace=True)

both.to_csv(r'./{a}/{b}/{c}/{d}-{b}-{c}.dat'.format(a=test, b=type, c=concurrency, d=test.replace('p','n')), sep='\t')