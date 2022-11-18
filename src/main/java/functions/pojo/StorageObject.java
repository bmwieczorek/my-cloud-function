package functions.pojo;

import java.util.Date;

// fields from com.google.events.cloud.storage.v1.StorageObjectData (java.time.OffsetDateTime type changed to java.util.Date)
public class StorageObject {

    private String bucket;

    private String contentType;

    private String id;

    private String kind;

    private Long metageneration;

    private String name;

    private String storageClass;

    private Date timeCreated;

    private Date updated;

    public String getBucket() {
        return bucket;
    }

    public void setBucket(String bucket) {
        this.bucket = bucket;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public Long getMetageneration() {
        return metageneration;
    }

    public void setMetageneration(Long metageneration) {
        this.metageneration = metageneration;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStorageClass() {
        return storageClass;
    }

    public void setStorageClass(String storageClass) {
        this.storageClass = storageClass;
    }

    public Date getTimeCreated() {
        return timeCreated;
    }

    public void setTimeCreated(Date timeCreated) {
        this.timeCreated = timeCreated;
    }

    public Date getUpdated() {
        return updated;
    }

    public void setUpdated(Date updated) {
        this.updated = updated;
    }

    @Override
    public String toString() {
        return "StorageObject{" +
                "bucket='" + bucket + '\'' +
                ", contentType='" + contentType + '\'' +
                ", id='" + id + '\'' +
                ", kind='" + kind + '\'' +
                ", metageneration=" + metageneration +
                ", name='" + name + '\'' +
                ", storageClass='" + storageClass + '\'' +
                ", timeCreated=" + timeCreated +
                ", updated=" + updated +
                '}';
    }
}
