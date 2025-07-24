#! /bin/bash


echo "below script is exceuting with user $(whoami)"
whoami
apt-get update -y
apt-get install wget vim zip unzip -y
cd /home/azureuser
mkdir dotnet &&  cd  dotnet/

echo "Installing .NET from Binary"
sudo wget -q https://download.visualstudio.microsoft.com/download/pr/b521d7d2-108b-43d9-861a-58b2505a125a/0023553690a68328b33bc30a38f151db/dotnet-sdk-6.0.420-linux-x64.tar.gz
tar zxf dotnet-sdk-6.0.420-linux-x64.tar.gz

echo "updated shell profile file so that below variables are available for every session or globally"
cat <<EOF >> /home/azureuser/.profile
export DOTNET_ROOT=/home/azureuser/dotnet
export PATH=$PATH:/home/azureuser/dotnet
EOF

echo "install azure devops pipeline agent"
cd /home/azureuser
mkdir myagent && cd myagent
wget -q https://vstsagentpackage.azureedge.net/agent/3.236.1/vsts-agent-linux-x64-3.236.1.tar.gz
tar xzf vsts-agent-linux-x64-3.236.1.tar.gz

echo "setup agent to connect to azure devops"
export AGENTNAME="$HOSTNAME-$(hostname -I)"
echo "Adding Agent to pipelines with Name ${AGENTNAME}"
runuser -l azureuser -c '/home/azureuser/myagent/config.sh --unattended  --url https://dev.azure.com/v-raayin/ --auth pat --token #TOKEN# --pool BapiStgAgents --agent $HOSTNAME-$(hostname -I) --work /home/azureuser/agent_work'

echo "create systemd service and install as non root user"
sudo ./svc.sh install azureuser

echo "Run agent as systemd serivce"
sudo ./svc.sh start


# remove existing agent from pool
#sudo ./svc.sh uninstall
#./config remove   (provide pat token)
