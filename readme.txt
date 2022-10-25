// testing remotely

me@MacBook:~/dev/my-cloud-function$ curl -m 70 -X POST https://$GCP_REGION-$GCP_PROJECT.cloudfunctions.net/$GCP_OWNER-cloud-function-java11 -H "Authorization: bearer $(gcloud auth print-identity-token)" -H "Content-Type: application/json" -d '{"b":1}'
Hello World!, body={"b":1}

// testing locally"
me@MacBook:~/dev/my-cloud-function$ mvn function:run -Drun.functionTarget=functions.HelloWorld
[INFO] Calling Invoker with [--classpath, /Users/me/dev/my-cloud-function/target/classes:/Users/me/.m2/repository/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar:/Users/me/.m2/repository/org/slf4j/slf4j-jdk14/1.7.36/slf4j-jdk14-1.7.36.jar, --target, functions.HelloWorld, --port, 8080]
[INFO] jetty-9.4.45.v20220203; built: 2022-02-03T09:14:34.105Z; git: 4a0c91c0be53805e3fcffdcdcc9587d5301863db; jvm 19
[INFO] Started o.e.j.s.ServletContextHandler@3d904e9c{/,null,AVAILABLE}
[INFO] Started ServerConnector@16c587de{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
Oct 25, 2022 5:14:00 PM com.google.cloud.functions.invoker.runner.Invoker logServerInfo
INFO: Serving function...
Oct 25, 2022 5:14:00 PM com.google.cloud.functions.invoker.runner.Invoker logServerInfo
INFO: Function: functions.HelloWorld
Oct 25, 2022 5:14:00 PM com.google.cloud.functions.invoker.runner.Invoker logServerInfo
INFO: URL: http://localhost:8080/
Oct 25, 2022 5:14:14 PM functions.HelloWorld service
INFO: Hello World getPath=/, body={"b":1}

me@MacBook:~/dev/my-cloud-function$ curl -X POST http://localhost:8080  -H "Content-Type: application/json" -d '{"b":1}'
Hello World!, body={"b":1}
