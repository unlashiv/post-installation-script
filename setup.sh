#!/bin/bash

set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/setupLibrary.sh"
}

current_dir=$(getCurrentDir)
includeDependencies
output_file="output.log"

# Call the function to read options from the file
read_options 'settings/options.txt'


# Display the extracted variables (optional)
echo "Username: $username"
echo "Timezone: $timezone"
echo "Public Key File Location: $public_key_file"
echo "Docker Enabled: $docker_enabled"

function main() {
    
    # Creating a new non-root user (Recommended)
    addUserAccount "${username}" 
    
    # Reading SSHkey from a file to link with the user
    sshkey=$(cat $public_key_file)
    
    echo 'Running setup script...'
    logTimestamp "${output_file}"

    exec 3>&1 >>"${output_file}" 2>&1


    disableSudoPassword "${username}"
    addSSHKey "${username}" "${sshKey}"
    #changeSSHConfig
    setupUfw

    if ! hasSwap; then
        setupSwap
    fi

    setupTimezone

    echo "Configuring System Time... " >&3
    configureNTP


    # install Docker
    [[ "$docker_enabled" == 'yes' ]] && install_docker

    sudo service ssh restart

    cleanup

    echo "Setup Done! Log file is located at ${output_file}" >&3
}

function setupSwap() {
    createSwap
    mountSwap
    tweakSwapSettings "10" "50"
    saveSwapSettings "10" "50"
}

function hasSwap() {
    [[ "$(sudo swapon -s)" == *"/swapfile"* ]]
}

function cleanup() {
    if [[ -f "/etc/sudoers.bak" ]]; then
        revertSudoers
    fi
}

function logTimestamp() {
    local filename=${1}
    {
        echo "===================" 
        echo "Log generated on $(date)"
        echo "==================="
    } >>"${filename}" 2>&1
}

function setupTimezone() {
    echo -ne "Setting the timezone for the server to 'Europe/Berlin')\n" >&3
    setTimezone "${timezone}"
    echo "Timezone is set to $(cat /etc/timezone)" >&3
}

main