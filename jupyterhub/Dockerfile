
ARG JUPYTERHUB_VERSION=1.0.0
FROM jupyterhub/jupyterhub-onbuild:$JUPYTERHUB_VERSION

RUN  /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==0.8.* \
        dockerspawner==0.11.*

COPY ./userlist /srv/jupyterhub/userlist

COPY ./cull_idle_servers.py /srv/jupyterhub/cull_idle_servers.py

COPY remote_user_auth.py /tmp/remote_user_auth.py
ENV PYTHONPATH=/tmp

