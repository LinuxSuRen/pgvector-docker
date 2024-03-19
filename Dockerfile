ARG PGVECTOR_TAG=v0.6.2
ARG PG_MAJOR=16
FROM bitnami/git:2.44.0 AS git

ARG PGVECTOR_TAG
WORKDIR /workspace
RUN git clone https://github.com/pgvector/pgvector && cd pgvector && git checkout ${PGVECTOR_TAG}

ARG PG_MAJOR
FROM bitnami/postgresql:${PG_MAJOR}-debian-12

USER root
COPY --from=git /workspace/pgvector /tmp/pgvector
RUN apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential && \
		cd /tmp/pgvector && \
		make clean && \
		make OPTFLAGS="" && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get remove -y build-essential && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*
