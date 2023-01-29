FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="www.kennedymutua.crunchgarage.com"

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
COPY ./run.sh /run.sh

USER root

RUN apk add --no-cache certbot && apk add certbot-nginx

RUN mkdir -p /vol/static && \
    mkdir -p /vol/media && \
    chmod 755 /vol/static && \
    chmod 755 /vol/media && \
    chown nginx:nginx /etc/nginx/conf.d/nginx.conf && \
    chmod +x /run.sh

VOLUME /vol/static
VOLUME /vol/media

# USER nginx

CMD ["/run.sh"]