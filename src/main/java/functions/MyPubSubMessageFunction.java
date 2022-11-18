package functions;

import com.google.cloud.functions.BackgroundFunction;
import com.google.cloud.functions.Context;
import com.google.events.cloud.pubsub.v1.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class MyPubSubMessageFunction implements BackgroundFunction<Message> {
    private static final Logger LOGGER = LoggerFactory.getLogger(MyPubSubMessageFunction.class);

    @Override
    public void accept(Message message, Context context) throws Exception {
        LOGGER.info("Received {} with {}", toString(message), context);

    }

    private static String toString(Message message) {
        return "Message{" +
                "data='" + (message.getData() == null ? null : base64DecodeToString(message.getData())) + '\'' +
                ", attributes=" + message.getAttributes() +
                ", messageID='" + message.getMessageID() + '\'' +
                ", publishTime=" + message.getPublishTime() +
                '}';
    }

    private static String base64DecodeToString(String data) {
        byte[] decodedBytes = Base64.getDecoder().decode(data.getBytes(StandardCharsets.UTF_8));
        return new String(decodedBytes, StandardCharsets.UTF_8);
    }
}
