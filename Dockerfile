FROM ubuntu:22.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo 'export LANG="C.UTF-8"' >> /etc/profile

WORKDIR /nginx_source
RUN apt update && apt install -y ca-certificates
RUN sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list && \
 sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
RUN apt update && apt install -y build-essential libtool libpcre3 libpcre3-dev zlib1g-dev libssl-dev
RUN useradd nginx

COPY . ./
RUN ./auto/configure --prefix=/usr/local/nginx \
--user=nginx --group=nginx \
--with-http_gzip_static_module \
--with-http_flv_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_mp4_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-pcre --with-stream \
--with-stream_ssl_module \
--with-stream_realip_module && \
make && make install && \
ln -s /usr/local/nginx/sbin/nginx /usr/bin/ && make clean

WORKDIR /
CMD ["bash", "/nginx_source/entrypoint/run.sh"]
