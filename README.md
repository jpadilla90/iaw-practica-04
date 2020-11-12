# iaw-practica-04
Práctica cuatro de la asignatura IAW de 2º de Asir.

> IES Celia Viñas (Almería) - Curso 2020/2021
Módulo: IAW - Implantación de Aplicaciones Web
Ciclo: CFGS Administración de Sistemas Informáticos en Red

**Archivos en el repositorio**
------------
1. front_end.sh—Script de bash para instalar los elementos en el servidor front-end
2. front_end2.sh-Script de bash para instalar los elementos en el servidor front-end secundario.
3. back_end.sh-Script de bash para instalar los elementos en el servidor back-end
4. 000-default.conf—Archivo de configuración para Apache.
5. README.md—Enlace para repositorio
6. /images para añadir enlaces internos de imágenes.

**Pasos seguidos**
Vamos a las instancias de AWS como en la práctica y levantamos tres máquinas. Una será la front-end (apache), otra la front-end secundaria y otra la back-end(MySQL) y le pondremos las etiquetas correspondientes para facilitar su configuración. Esta vez necesitaremos añadir un nuevo host a nuestro archivo de configuración de ssh de Visual Code, como en la imagen.
![](/images/1.png)

Abrimos las tres terminales SSH en el editor de VS Code. Lanzamos el script front_end.sh y front_end2.sh en las front_end (Diferenciado en el repositorio por motivos orientativos, pero idéntico contenido)

Repetimos la operación de la práctica anterior, pero ahora podremos acceder a nuestro servidor desde cualquiera de las direcciones IP públicas de nuestras instancias, asegurando una mayor disponibilidad.
![](/images/2.png)
*front_end principal*
![](/images/3.png)
*front_end secundaria*
