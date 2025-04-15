#!/bin/bash

echo "Starting with USER : $USER_ID ($USER_NAME), GROUP: $GROUP_ID ($GROUP_NAME)"
useradd -s /bin/bash -m ${USER_NAME}
export HOME=/home/$USER_NAME
usermod -u ${USER_ID} ${USER_NAME}
groupadd -g ${GROUP_ID} ${GROUP_NAME}
usermod -g ${GROUP_NAME} ${USER_NAME}
usermod -aG sudo ${USER_NAME}

echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER_NAME}
chmod 0440 /etc/sudoers.d/${USER_NAME}

exec /bin/su ${USER_NAME} -c "$@"

mkdir -p ~/.config/pip
cat << EOF > ~/.config/pip/pip.conf
[global]
break-system-packages = true
EOF