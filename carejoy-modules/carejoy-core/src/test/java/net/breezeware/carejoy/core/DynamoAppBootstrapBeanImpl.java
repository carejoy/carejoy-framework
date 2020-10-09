package net.breezeware.carejoy.core;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import net.breezeware.dynamo.util.DynamoAppBootstrapBean;

@Component
public class DynamoAppBootstrapBeanImpl implements DynamoAppBootstrapBean {

    Logger logger = LoggerFactory.getLogger(DynamoAppBootstrapBeanImpl.class);

    public String getCurrentUserEmail() {
        return null;
    }

    public List<String> getCurrentUserRoles() {
        return null;
    }

    public long getCurrentUserOrganizationId() {
        return -1;
    }
}