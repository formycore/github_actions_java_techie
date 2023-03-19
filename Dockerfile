FROM openjdk:8
EXPOSE 8080
ADD target/javatechie-github-actions.jar javatechie-github-actions.jar
ENTRYPOINT ["java","-jar","/javatechie-github-actions.jar"]