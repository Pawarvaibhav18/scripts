sudo apt update -y 
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install python3-pip 
sudo pip install boto3
ansible-galaxy collection install amazon.aws