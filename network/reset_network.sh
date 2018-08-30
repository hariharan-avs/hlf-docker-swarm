docker service rm  $(docker service ls -q)
docker rm -f $(docker ps -qa)
docker swarm leave --force
./setup_swarm.sh
./create_network.sh
./start_all.sh
sleep 10
./scripts/create_channel.sh
./scripts/install_chaincodes.sh
