WHATAP_HOME=/whatap
WHATAP_JAR=$(ls ${WHATAP_HOME}/whatap.agent.tracer-*.jar | sort | tail -1)
JAVA_OPTS="-javaagent:${WHATAP_JAR} -Dwhatap.micro.enabled=true "

export WHATAP_HOME
exec java $JAVA_OPTS -jar guestbook.jar

