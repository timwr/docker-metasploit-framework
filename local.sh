#/bin/bash

HOST=$1
if [ -z "$HOST" ]
then
    HOST=$(hostname -I | cut -f 1 -d " ")
fi
if [ -z "$HOST" ]
then
    HOST=127.0.0.1
fi
echo "Host: $HOST"

# run docker image
docker build -t timwr/metasploit-framework .
docker run -e "LHOST=$HOST" -it --net host timwr/metasploit-framework

#docker run -d --net host timwr/metasploit-framework

