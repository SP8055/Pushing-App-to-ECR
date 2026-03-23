FROM maven:3.9.9-eclipse-temurin-17 As build

WORKDIR /build

COPY . .

RUN mvn dependency:go-offline -B

RUN mvn clean package -DskipTests

FROM jetty:12.0-jre21-alpine

USER jetty

RUN rm -rf /var/lib/jetty/webapps/*

COPY --from=build --chown=jetty:jetty /build/target/*.war /app/var/lib/jetty/webapps/app.war

EXPOSE 8080
