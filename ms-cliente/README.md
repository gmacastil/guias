# compilar

mvn clean package

# construir imagen

docker build . -f Dockerfile2 -t ms-cliente:1

docker build . -t ms-cliente:1

# Run

docker run --name ms-cliente-01 \
        -e DATABASE_URL=jdbc:postgresql://postgres:5432/demo \
        -e DATABASE_USERNAME=postgres \
        -e DATABASE_PASSWORD=123456 \
        -e SERVER_PORT=8080 \
        -e LOGSTASH_SERVER=logstash:5000 \
        -e FACTURA_SERVICE_URL=http://ms-factura-01:8080 \
        -p 9092:8080 \
        --network curso \
        --network elk_elk \
        -d ms-cliente:1

# Run docker compose

docker compose up -d
docker compose -f docker-compose-db.yaml up -d 

# push registry

docker tag ms-cliente:1 mauron/ms-cliente:1
docker push mauron/ms-cliente:1

# Run k6

k6 run test.js