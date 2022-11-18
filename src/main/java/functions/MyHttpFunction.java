package functions;

import com.google.cloud.functions.HttpFunction;
import com.google.cloud.functions.HttpRequest;
import com.google.cloud.functions.HttpResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

public class MyHttpFunction implements HttpFunction {
  private static final Logger LOGGER = LoggerFactory.getLogger(MyHttpFunction.class);

  @Override
  public void service(HttpRequest request, HttpResponse response)
      throws IOException {
    String path = request.getPath();
    InputStream inputStream = request.getInputStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
    String text = reader.lines().collect(Collectors.joining("\n"));
    reader.close();
    LOGGER.info("Hello World getPath=" + path + ", body=" + text);
    BufferedWriter writer = response.getWriter();
    writer.write("Hello World!, body=" + text + "\n");
  }
}

