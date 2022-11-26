package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Map;
import java.util.Properties;

// Handler value: example.Handler
public class Handler implements RequestHandler<Map<String,String>, String>{
  Gson gson = new GsonBuilder().setPrettyPrinting().create();
  @Override
  public String handleRequest(Map<String,String> event, Context context)
  {
    LambdaLogger logger = context.getLogger();
    logger.log("EVENT: " + gson.toJson(event) + "\n");
    logger.log("EVENT TYPE: " + event.getClass() + "\n");

    /* Sample App Code */
    String url = "jdbc:postgresql://localhost/test";
    Properties props = new Properties();
    props.setProperty("user", "fred");
    props.setProperty("password", "secret");
    props.setProperty("ssl", "true");
    try {
      Connection conn = DriverManager.getConnection(url, props);
    } catch (SQLException e) {
      logger.log("postgresql exception: " + Arrays.toString(e.getStackTrace()));
    }
    /* End App Code */

    String response = "200 OK";
    return response;
  }
}