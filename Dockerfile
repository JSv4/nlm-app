FROM node:14-slim as build

 WORKDIR /app

 ENV PATH /app/node_modules/.bin:$PATH

 COPY . /app

 RUN yarn install

 ENV GENERATE_SOURCEMAP false

 RUN yarn build

 FROM nginx:stable

 COPY --from=build /app/build /usr/share/nginx/html
 COPY nginx.conf /etc/nginx/conf.d/default.conf

 RUN chmod -R o+rwx /var

 RUN touch /var/run/nginx.pid && \
        chmod o+rwx /var/run/nginx.pid

 RUN apt-get update; apt-get -s dist-upgrade | grep "^Inst" | grep -iE 'securi|ssl|login|passwd' | awk -F " " {'print $2'} | xargs apt-get install

 EXPOSE 6092

 CMD ["nginx", "-g", "daemon off;"]
