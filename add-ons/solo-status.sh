#!/bin/bash

gray='\e[90m'
yellow='\e[33m'
green='\e[32m'
reset='\e[0m'
red='\e[31m'
cyan='\e[36m'

echo -e "${yellow}Please wait for all processes to come online. It will take a few minutes."
echo -e "Once the APIs are accessible, a message with your target information will be displayed.${reset}"

echo ''
echo ''

summary=$(monit summary 2>/dev/null | grep 'Process' | sed s/\'//g)

if [ -n "$summary" ]; then
  echo 'Processes: '
else
  echo 'Monit is not running yet.'
fi

printf '%s\n' "$summary" | while IFS= read -r line
do
  process_name=$(echo $line | awk '{print $2}')
  process_status=$(echo $line | awk '{print $3}')

  if [ "$process_status" == "Running" ] ; then
    color=$green
  else
    color=$gray
  fi

  echo -n -e "${color}${process_name}${reset} "
done

if curl -s --fail "http://api.cf-solo.io/v2/info" > /dev/null ; then
  cc_ok="true"
  cc_message="${green}ONLINE${reset}"
else
  cc_ok="false"
  cc_message="${red}OFFLINE${reset}"
fi

if curl -s -f -k --header 'Accept: application/json' https://uaa.cf-solo.io/info > /dev/null ; then
  uaa_ok="true"
  uaa_message="${green}ONLINE${reset}"
else
  uaa_ok="false"
  uaa_message="${red}OFFLINE${reset}"
fi

if [[ "$CF_SOLO_OS" == "darwin"* ]]; then
  echo ''
  echo ''
  echo -e "${yellow}Looks like you're using a mac. In order to interact with cf-solo, or the"
  echo -e "apps that you deploy there, cf-solo uses a proxy (127.0.0.1:3128). So"
  echo -e "remember to export the following, and configure your browser accordingly.${reset}"
  echo ''
  echo -e "${cyan}export http_proxy=localhost:3128${reset}"
  echo -e "${cyan}export https_proxy=\${http_proxy}${reset}"
fi

echo ''
echo ''

echo -e "Cloud Controller: ${cc_message}"
echo -e "UAA:              ${uaa_message}"

echo ''

if [[ "$uaa_ok" == "true" && "$cc_ok" == "true" ]]; then

  echo -e "Target using: ${cyan}cf api --skip-ssl-validation https://api.${DOMAIN} ${reset}"
  echo -e "Credentials:  ${cyan}admin / ${CLUSTER_ADMIN_PASSWORD}${reset}"
else
  echo ''
  echo ''
fi

echo ''
echo 'Hit CTRL-C to stop.'
