# Etapa 1: compilar el proyecto con Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: desplegar el WAR en Tomcat
# Se usa Tomcat 9 porque el proyecto usa javax.servlet-api (Java EE), no jakarta.servlet (Tomcat 10+)
# Se usa la variante "-temurin" porque se actualiza con más frecuencia que la imagen oficial
# (la oficial trae un JDK 17.0.2 con un bug conocido al detectar cgroups v2 en kernels modernos)
FROM tomcat:9.0-jdk17-temurin
# Limpia las apps de ejemplo que trae Tomcat por defecto
RUN rm -rf /usr/local/tomcat/webapps/*
# Copia el WAR generado como ROOT.war para que la app quede en la raíz "/"
COPY --from=build /app/target/registro-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Respaldo: si el JDK sigue fallando al detectar cgroups del contenedor, se desactiva esa detección
ENV JAVA_OPTS="-XX:-UseContainerSupport"

EXPOSE 8080
CMD ["catalina.sh", "run"]