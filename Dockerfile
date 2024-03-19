FROM bitnami/postgresql:16.2.0-debian-12-r8

USER root
RUN apt update -y && apt install -y postgresql-common
RUN echo yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
RUN apt install postgresql-16-pgvector -y
