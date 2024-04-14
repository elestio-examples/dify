#set env vars
set -o allexport; source .env; set +o allexport;

SECRET_KEY=$(openssl rand -base64 42)
WEAVIATE_API_KEY=$(openssl rand -base64 42)

cat << EOT >> ./.env

SECRET_KEY=${SECRET_KEY}
WEAVIATE_API_KEY=${WEAVIATE_API_KEY}
EOT


cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 30178,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT