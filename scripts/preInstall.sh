#set env vars
set -o allexport; source .env; set +o allexport;

SECRET_KEY=$(openssl rand -base64 42)

cat << EOT >> ./.env

SECRET_KEY=${SECRET_KEY}
EOT