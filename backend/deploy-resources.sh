#!/bin/bash

# Função para limpar e sair caso ocorra um erro
cleanup_and_exit() {
    echo "Ocorreu um erro. Limpando os recursos criados anteriormente..."
    docker rm -f chatlink-server chatlink-redis chatlink-postgres &> /dev/null
    docker network rm chatlink-network &> /dev/null
    exit 1
}

# Passo 1: Instalar o Redis no Docker
docker run --name chatlink-redis -d -p 6379:6379 redis || cleanup_and_exit

# Passo 2: Instalar o PostgreSQL no Docker
docker run --name chatlink-postgres -e POSTGRES_PASSWORD=TG6EgWY3joAj -d -p 5432:5432 postgres || cleanup_and_exit

# Passo 3: Criar uma network no Docker
docker network create chatlink-network || cleanup_and_exit

# Passo 4: Associar o Redis e o PostgreSQL à mesma network
docker network connect chatlink-network chatlink-redis || cleanup_and_exit
docker network connect chatlink-network chatlink-postgres || cleanup_and_exit

# Passo 5: Criar o banco de dados no PostgreSQL
docker exec -it chatlink-postgres psql -U postgres -c "CREATE DATABASE chatlink;" || cleanup_and_exit

# Passo 6: Fazer login no ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 797977794545.dkr.ecr.us-east-1.amazonaws.com

# Passo 7: Fazer download da imagem privada no ECR
docker pull 797977794545.dkr.ecr.us-east-1.amazonaws.com/chatlink:latest || cleanup_and_exit

# Passo 9: Executar container com a imagem baixada e associar à mesma network que estão o Redis e o PostgreSQL
docker run --name chatlink-server -d -p 8080:8080 --network chatlink-network 797977794545.dkr.ecr.us-east-1.amazonaws.com/chatlink:latest || cleanup_and_exit

echo "Todos os passos foram concluídos com sucesso!"
