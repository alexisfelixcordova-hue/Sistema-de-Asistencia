# Paso 1: Compilar la aplicación con Maven y Java 17
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
# Copiamos todo tu código fuente al contenedor
COPY . .
# Compilamos el proyecto y generamos el archivo WAR ignorando los tests
RUN mvn clean package -DskipTests

# Paso 2: Desplegar el WAR generado en un servidor Tomcat oficial
FROM tomcat:9.0-jdk17-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiamos el WAR obtenido en el paso 1 directamente a Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
# Modificar el puerto de Tomcat dinámicamente según lo requiera Railway
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'$PORT'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]