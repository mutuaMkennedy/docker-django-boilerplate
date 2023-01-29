ARG PYTHON_VERSION=3.7-alpine3.16

# the image we want to use
FROM python:${PYTHON_VERSION}
LABEL maintainer="mutuakennedy.crunchgarage.com"

# Prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# Create our woking directory
RUN mkdir -p /app

# Set created directory as our working directory
WORKDIR /app

COPY requirements.txt /tmp/requirements.txt
COPY ./docker-services/scripts /docker-services/scripts

RUN set -ex && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev linux-headers && \
    apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev && \
    apk add --no-cache \
            --upgrade \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
                geos \
                proj \
                gdal \
                binutils && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    rm -rf /root/.cache/ && \
    ln -s /usr/lib/libproj.so.15 /usr/lib/libproj.so  && \
    ln -s /usr/lib/libgdal.so.20 /usr/lib/libgdal.so && \
    ln -s /usr/lib/libgeos_c.so.1 /usr/lib/libgeos_c.so && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /docker-services/scripts

COPY . .
ENV PATH="/docker-services/scripts:/py/bin:$PATH"
USER root

CMD [ "run.sh"]
