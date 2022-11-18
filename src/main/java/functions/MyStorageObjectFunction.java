package functions;

import com.google.cloud.functions.BackgroundFunction;
import com.google.cloud.functions.Context;
import functions.pojo.StorageObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MyStorageObjectFunction implements BackgroundFunction<StorageObject> {
    private static final Logger LOGGER = LoggerFactory.getLogger(MyStorageObjectFunction.class);

    @Override
    public void accept(StorageObject storageObject, Context context) throws Exception {
        LOGGER.info("Received {} with {}", storageObject, context);
    }
}
