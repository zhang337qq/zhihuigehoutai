# 声明镜像来源为node:16
FROM node:16

# 声明工作目录
WORKDIR /gva_web/

# 拷贝整个web项目到当前工作目录
COPY . .

# 通过npm下载cnpm
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org

RUN npm install vite

# 使用cnpm进行安装依赖
RUN cnpm install || npm install

# 使用npm run build命令打包web项目
RUN npm run build
# ===================================================== 以下为多阶段构建 ==========================================================

# 声明镜像来源为nginx:alpine, alpine 镜像小
FROM nginx:alpine

# 镜像编写者及邮箱
LABEL MAINTAINER="SliverHorn@sliver_horn@qq.com"

# 从.docker-compose/nginx/conf.d/目录拷贝my.conf到容器内的/etc/nginx/conf.d/my.conf
COPY .docker-compose/nginx/conf.d/my.conf /etc/nginx/conf.d/my.conf

# 从第一阶段进行拷贝文件
COPY --from=0 /gva_web/dist /usr/share/nginx/html

# 查看/etc/nginx/nginx.conf文件
RUN cat /etc/nginx/nginx.conf

# 查看 /etc/nginx/conf.d/my.conf
RUN cat /etc/nginx/conf.d/my.conf

# 查看 文件是否拷贝成功
RUN ls -al /usr/share/nginx/html

