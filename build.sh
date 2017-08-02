#/bin/bash

HOST=somehost
DOCKER_TAG=gcr.io/something/metasploit-framework

# build docker image
docker build -t $DOCKER_TAG .
docker tag $DOCKER_TAG $DOCKER_TAG
gcloud docker -- pull $DOCKER_TAG
gcloud docker -- push $DOCKER_TAG

# create instance
#gcloud compute instances create msf-rpc --machine-type n1-standard-1 --metadata-from-file google-container-manifest=container.yaml --tag msf-rpc --image container-vm
#gcloud compute instances list
#gcloud compute firewall-rules update msf-ports --allow tcp:80,tcp:443,tcp:3333,tcp:4444,tcp:5555,tcp:6666,tcp:7777,tcp:8000,tcp:8080,tcp:8888
#gcloud compute ssh user@msf-rpc --command "echo ssh works"

ssh -i ~/.ssh/google_compute_engine user@$HOST 'sudo docker rm -f $(sudo docker ps -a -q)'
ssh -i ~/.ssh/google_compute_engine user@$HOST "sudo docker pull $DOCKER_TAG"
ssh -i ~/.ssh/google_compute_engine user@$HOST "tmux new -d -s metasploit 'sudo docker run -it -e \"LHOST=$HOST\" --name=metasploit --net host $DOCKER_TAG'"
ssh -t -i ~/.ssh/google_compute_engine user@$HOST tmux a

