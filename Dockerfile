FROM nginx:latest

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY certs /home/ca
