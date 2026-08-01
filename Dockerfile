# Usamos una imagen oficial de Tomcat con Java 17
FROM tomcat:9.0-jdk17-openjdk-slim

# Borramos las aplicaciones por defecto de Tomcat para limpiar la raíz
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos el archivo WAR compilado al directorio webapps con el nombre ROOT.war
# De esta forma tu aplicación responderá directamente en la raíz (/)
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Configuramos Tomcat para que use el puerto que Railway le asigna dinámicamente
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'$PORT'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]