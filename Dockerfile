FROM python:3.13.3-slim-bookworm

ARG RVER=4.5.0

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY install_debian_packages.sh /usr/local/bin/install_debian_packages.sh
COPY install_R_packages.R /usr/local/bin/install_R_packages.R

COPY requirements_debian.txt /tmp/requirements_debian.txt
COPY requirements_python.txt /tmp/requirements_python.txt
COPY requirements_R.txt /tmp/requirements_R.txt

RUN echo "Issych-docker-image" \
#
&&  bash /usr/local/bin/install_debian_packages.sh /tmp/requirements_debian.txt  \
&&  Rscript /usr/local/bin/install_R_packages.R /tmp/requirements_R.txt \
&&  pip install --upgrade pip \ 
&&  pip install -r /tmp/requirements_python.txt \
#
&&  apt autoremove -y \
&&  apt clean -y \
#
&&  echo '--- FIN ---'
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]