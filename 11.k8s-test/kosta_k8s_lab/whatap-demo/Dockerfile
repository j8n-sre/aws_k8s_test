# docker image build -t yu3papa/k8s_guestbook:whatap .

FROM registry.whatap.io:5000/whatap_lxc as build
FROM openjdk:8

RUN mkdir -p /whatap
COPY --from=build /data/agent/micro/whatap.agent.tracer-*.jar /whatap
COPY ./whatap.conf /whatap/

COPY guestbook-0.0.1-SNAPSHOT.jar /app/guestbook.jar
COPY entrypoint.sh /app/

ENV APP_HOME /app
EXPOSE 8080
VOLUME /app/upload
WORKDIR $APP_HOME

CMD ./entrypoint.sh
