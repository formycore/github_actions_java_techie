FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:8
WORKDIR /app
COPY --from=build /app/target/javatechie-github-actions.jar /app
EXPOSE 8080
CMD ["java","-jar","javatechie-github-actions.jar" ] 