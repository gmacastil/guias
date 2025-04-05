# Taller de Construcción de Microservicios con Spring Boot y Containerización

## 1. Instalar y configurar PostgreSQL

```bash
# Ejecutar contenedor de PostgreSQL
docker run --name postgres -e POSTGRES_PASSWORD=123456 -p 5432:5432 -d postgres
```

- **Instalar DBeaver**: https://dbeaver.io/download/
- **Configurar acceso con superusuario**:
  - Host: localhost
  - Puerto: 5432
  - Usuario: postgres
  - Contraseña: 123456
- **Crear base de datos demo**:
  ```sql
  CREATE DATABASE demo;
  ```
- **Salir y autenticarse a la nueva DB**

## 2. Inicializar microservicio

- **Crear esqueleto con Spring Initializr**: https://start.spring.io/
  - Seleccionar Java 21
  - Maven como gestor de dependencias
  - Spring Boot 3.1.5
  - Dependencias iniciales recomendadas:
    - Spring Web
    - Spring Data JPA
    - PostgreSQL Driver
    - Lombok
    - Validation
    - Spring Boot DevTools

## 3. Herramientas de trabajo

- **IDEs recomendados**:
  - IntelliJ IDEA: https://www.jetbrains.com/idea/download/
  - VS Code: https://code.visualstudio.com/download
  - Spring Tool Suite: https://spring.io/tools
- **Instalar Maven**: https://maven.apache.org/download.cgi
  - Configurar variables de entorno:
    - MAVEN_HOME y agregarlo al PATH
- **Validar compilación**:
  ```bash
  mvn clean compile
  ```
- **Validar empaquetado**:
  ```bash
  mvn clean package
  ```

## 4. Desarrollar microservicio

### Estructura recomendada (Arquitectura Hexagonal)

- **Dominio**:
  - `model`: Entidades de negocio
  - `dto`: Objetos de transferencia de datos
  
- **Aplicación**:
  - `exceptions`: Excepciones personalizadas
  - `mapper`: Convertidores entre entidades y DTOs (usar MapStruct: https://mapstruct.org/)
  - `service`: Interfaces de servicio e implementación
  - `ports`: Interfaces para repositorios y servicios externos
  
- **Infraestructura**:
  - `controller`: Controladores REST
  - `entity`: Entidades de persistencia
  - `repository`: Implementaciones de repositorios
  - `config`: Configuraciones
  - `adapter`: Adaptadores para servicios externos

- **Dependencias recomendadas** (incluir en pom.xml):
  ```xml
  <!-- MapStruct -->
  <dependency>
      <groupId>org.mapstruct</groupId>
      <artifactId>mapstruct</artifactId>
      <version>1.5.5.Final</version>
  </dependency>
  
  <!-- Springdoc OpenAPI UI -->
  <dependency>
      <groupId>org.springdoc</groupId>
      <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
      <version>2.2.0</version>
  </dependency>
  
  ```

## 5. Configuración

### application.properties

```properties
# DataSource
spring.datasource.url=jdbc:postgresql://localhost:5432/demo
spring.datasource.username=postgres
spring.datasource.password=123456
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Server
server.port=8080
server.servlet.context-path=/api/v1

# OpenAPI
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html
```

### Variables de entorno
- Crear archivo `.env` de referencia:
  ```
  DB_HOST=postgres
  DB_PORT=5432
  DB_NAME=demo
  DB_USER=postgres
  DB_PASSWORD=123456
  SERVER_PORT=8080
  ```

## 6. OpenAPI

- **Configurar Springdoc**:
  ```java
  @Configuration
  public class OpenApiConfig {
    @Bean
    public OpenAPI customOpenAPI() {
      return new OpenAPI()
        .info(new Info()
          .title("Microservicio Demo")
          .version("1.0")
          .description("API para el taller de microservicios"));
    }
  }
  ```

- **Probar API**: Acceder a http://localhost:8080/swagger-ui.html
- **Exportar Swagger**: Descargar desde http://localhost:8080/api-docs
- **Importar en Postman**: https://www.postman.com/downloads/
  - Importar colección desde swagger.json

## 7. Test Funcional

- **Construir casos de prueba CSV**:
  ```csv
  id,nombre,descripcion,resultado_esperado
  1,test1,descripcion1,200
  2,test2,descripcion2,400
  ```

- **Codificar tests en Postman**:
  - Crear environment para pruebas
  - Usar variables de entorno
  - Utilizar pruebas pre-request y post-request

- **Ejecutar pruebas en Postman**:
  - Usar Newman para ejecución por CLI: https://learning.postman.com/docs/collections/using-newman-cli/command-line-integration-with-newman/
  
  ```bash
  npm install -g newman
  newman run collection.json -e environment.json
  ```

## 8. Containerización

### Dockerfile

```dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "${SERVER_PORT}:8080"
    depends_on:
      - postgres
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
      - SPRING_DATASOURCE_USERNAME=${DB_USER}
      - SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}
    networks:
      - microservicio-network
      
  postgres:
    image: postgres
    ports:
      - "${DB_PORT}:5432"
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_DB=${DB_NAME}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - microservicio-network

networks:
  microservicio-network:
    driver: bridge

volumes:
  postgres-data:
```

### Comandos para construir y ejecutar

```bash
# Construir imagen
docker build -t microservicio-demo:1.0 .

# Levantar con docker-compose
docker-compose --env-file .env up -d

# Verificar contenedores
docker ps

# Acceder a swagger
# http://localhost:8080/swagger-ui.html
```

## 9. Pruebas de Rendimiento

- **Instalar k6**: https://k6.io/docs/get-started/installation/
- **Crear script de prueba k6**:

```javascript
import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  vus: 10,
  duration: '30s',
  thresholds: {
    http_req_duration: ['p(95)<500'],
  },
};

export default function () {
  const res = http.get('http://localhost:8080/api/v1/recurso');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  sleep(1);
}
```

- **Ejecutar pruebas k6**:
```bash
k6 run script.js
```

- **Herramientas de profile recomendadas**:
  - Java Mission Control: https://www.oracle.com/java/technologies/jdk-mission-control.html
  - VisualVM: https://visualvm.github.io/
  - Jprofiler: https://www.ej-technologies.com/jprofiler
    


## Pasos adicionales recomendados

1. **Implementar CI/CD**:
   - Configurar GitHub Actions o Jenkins para automatizar build y pruebas
   - Integrar SonarQube para análisis estático de código

2. **Gestión de logs**:
   - Configurar ELK Stack (Elasticsearch, Logstash, Kibana) o Graylog

3. **Implementar Health Checks**:
   - Configurar actuator endpoints
   - Implementar custom health checks

6. **Escalabilidad**:
   - Configurar Kubernetes para despliegue
   - Implementar auto-scaling
