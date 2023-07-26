#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "===================================================================================="
cd /tmp
docker pull projectdiscovery/nuclei:latest

docker image ls

docker run projectdiscovery/nuclei:latest --version


# Check if the `/tmp/nuclei-templates` directory exists
if [ -d /tmp/nuclei-templates ]; then

  # Print that the directory exists
  echo "The `/tmp/nuclei-templates` directory exists."

  #update the templates
  docker run -v /tmp/nuclei-templates:/nuclei-templates projectdiscovery/nuclei -update-templates

  docker run -v /tmp/nuclei-templates:/nuclei-templates projectdiscovery/nuclei \
  -u https://example.com -t /nuclei-templates/ssl/deprecated-tls.yaml

else

  # Print that the directory does not exist
  echo "The `/tmp/nuclei-templates` directory does not exist."

    #Clone Nuclei Templates Repository
    git clone https://github.com/projectdiscovery/nuclei-templates.git

    #update the templates
    docker run -v /tmp/nuclei-templates:/nuclei-templates projectdiscovery/nuclei -update-templates

    docker run -v /tmp/nuclei-templates:/nuclei-templates projectdiscovery/nuclei \
    -u https://example.com -t /nuclei-templates/ssl/deprecated-tls.yaml

fi



echo "===================================================================================="
