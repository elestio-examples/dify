#set env vars
set -o allexport; source .env; set +o allexport;

git clone https://github.com/langgenius/dify.git dify

mv ./dify/docker/nginx ./
mv ./dify/docker/ssrf_proxy ./
mv ./dify/docker/volumes ./

rm -rf ./dify

SECRET_KEY=$(openssl rand -base64 42)
WEAVIATE_API_KEY=$(openssl rand -base64 42)

cat /opt/elestio/startPostfix.sh > post.txt
filename="./post.txt"

SMTP_LOGIN=""
SMTP_PASSWORD=""

# Read the file line by line
while IFS= read -r line; do
  # Extract the values after the flags (-e)
  values=$(echo "$line" | grep -o '\-e [^ ]*' | sed 's/-e //')

  # Loop through each value and store in respective variables
  while IFS= read -r value; do
    if [[ $value == RELAYHOST_USERNAME=* ]]; then
      SMTP_LOGIN=${value#*=}
    elif [[ $value == RELAYHOST_PASSWORD=* ]]; then
      SMTP_PASSWORD=${value#*=}
    fi
  done <<< "$values"

done < "$filename"

rm post.txt


cat << EOT >> ./.env

SMTP_HOST=tuesday.mxrouting.net
SMTP_PORT=587
SMTP_USERNAME=${SMTP_LOGIN}
SMTP_PASSWORD=${SMTP_PASSWORD}
SMTP_FROM=${SMTP_LOGIN}
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