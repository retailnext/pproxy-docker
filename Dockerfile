FROM debian:11-slim@sha256:7606bef5684b393434f06a50a3d1a09808fee5a0240d37da5d181b1b121e7637 AS build
RUN apt-get update \
&& apt-get install --no-install-suggests --no-install-recommends --yes \
gcc \
libpython3-dev \
libssl-dev \
python3-venv \
&& rm -rf /usr/local \
&& python3 -m venv /usr/local \
&& /usr/local/bin/pip install --upgrade pip setuptools wheel

COPY requirements.txt /requirements.txt

RUN /usr/local/bin/pip install --disable-pip-version-check -r /requirements.txt

FROM gcr.io/distroless/python3-debian11:nonroot@sha256:59f655992271f8db964034a00a53bbb5ddcfe1b8967bfb73519eadec04addf01

COPY --from=build /usr/local /usr/local

ENTRYPOINT ["/usr/local/bin/pproxy"]
