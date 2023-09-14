#!/bin/bash

sudo apt update 
sudo apt-get install ca-certificates
sudo apt install nginx -y
cd /root


mkdir openssl && cd openssl

openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=demo.mlopshub.com/C=US/L=San Fransisco" \
            -keyout rootCA.key -out rootCA.crt 

openssl genrsa -out server.key 2048


cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Fransisco
O = MLopsHub
OU = MlopsHub Dev
CN = demo.mlopshub.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = demo.mlopshub.com
DNS.2 = www.demo.mlopshub.com
IP.1 = 192.168.1.5
IP.2 = 192.168.1.6

EOF
openssl req -new -key server.key -out server.csr -config csr.conf

cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = demo.mlopshub.com

EOF

openssl x509 -req \
    -in server.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out server.crt \
    -days 365 \
    -sha256 -extfile cert.conf






cd /var/www/html

rm -f index.nginx-debian.html


cat <<EOF > index.html
<html>
<head>
<title>Hello world</title>
</head>
<body>
<h1>Hello World</h1>
</body>
</html>

EOF



chown www-data:www-data -R .



cd /etc/nginx/sites-enabled/
echo "" > default

cat <<EOF > default

server {
    listen 80;
    server_name demo.mlopshub.com;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl default_server;
    server_name demo.mlopshub.com;

    ssl_certificate /root/openssl/server.crt;      # Replace with your SSL certificate file path
    ssl_certificate_key /root/openssl/server.key;  # Replace with your SSL private key file path

    # SSL settings - you can adjust these for your needs
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers off;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }


    # Access logs (optional)
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Add other server blocks for additional domains or configurations if needed
}

EOF

nginx -t > nginx-out

service nginx start
