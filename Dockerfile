FROM bitnami/postgresql:15.6.0-debian-12-r7

USER root
RUN apt update -y && apt install -y postgresql-common
RUN echo yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
RUN apt install postgresql-16-pgvector -y
