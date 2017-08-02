
/root/certbot-auto certonly -n --agree-tos --register-unsafely-without-email --no-self-upgrade --webroot -w /var/www/html -d $LHOST
rm /etc/nginx/ssl/nginx.crt
rm /etc/nginx/ssl/nginx.key
ln -s /etc/letsencrypt/live/$LHOST/fullchain.pem /etc/nginx/ssl/nginx.crt
ln -s /etc/letsencrypt/live/$LHOST/privkey.pem /etc/nginx/ssl/nginx.key
service nginx reload

