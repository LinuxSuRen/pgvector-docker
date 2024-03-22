ARG PGVECTOR_TAG=v0.6.2
ARG BASE_IMAGE=bitnami/postgresql:16.2.0-debian-12-r8

FROM bitnami/git:2.44.0 AS git

ARG PGVECTOR_TAG
WORKDIR /workspace

RUN git clone --branch ${PGVECTOR_TAG} https://github.com/pgvector/pgvector

ARG BASE_IMAGE
FROM $BASE_IMAGE

# User root is required for installing packages
USER root

COPY --from=git /workspace/pgvector /tmp/pgvector

RUN apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential && \
		cd /tmp/pgvector && \
		export PG_CONFIG=`which pg_config` && \
		make clean && \
		make && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get remove -y build-essential && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*

# Return to previous non-root user
USER 1001
