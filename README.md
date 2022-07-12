## **TFG**: Diseño y validación de una arquitectura escalable en Kubernetes para el despliegue de un SaaS
Dentro de este repositorio existen 4 carpetas principales:
- ```./docker``` -> contiene lo necesario para compilar y construir las imágenes de los contenedores para la arquitectura escalable.
- ```./kubernetes``` -> contiene todos los manifiestos necesarios para desplegar la arquitectura de dos formas diferentes, mediante el cliente de Kubernetes o a través de ArgoCD.
- ```./res``` -> contiene todos los resultados de las pruebas realizadas al sistema, junto a los archivos necesarios para generar todas las gráficas.
- ```./vendor``` -> contiene los scripts específicos para generar el clúster utilizado para las pruebas y subir las imágenes a un registro privado.