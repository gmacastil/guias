# compilar

mvn clen package

# construir imagen

docker build . -f Dockerfile2 -t ms-factura:1

docker build . -t ms-factura:1

# Run

docker run --name ms-factura-02 \
        -e DATABASE_URL=jdbc:postgresql://postgres:5432/demo \
        -e DATABASE_USERNAME=postgres \
        -e DATABASE_PASSWORD=123456 \
        -e SERVER_PORT=8080 \
        -e LOGSTASH_SERVER=logstash:5000 \
        -p 9091:8080 \
        --network curso \
        --network elk_elk \
        -d ms-factura:2

# Run docker compose

docker compose up -d
docker compose -f docker-compose-db.yaml up -d 

# push registry

docker tag ms-factura:3 mauron/ms-factura:3
docker push mauron/ms-factura:3

# Run k6

k6 run test.js