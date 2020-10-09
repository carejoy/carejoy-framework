package net.breezeware.carejoy.core.entity;

import java.io.Serializable;

import com.google.gson.Gson;

public class MedicalAdvice implements Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private String message;

    public MedicalAdvice() {
    }

    public MedicalAdvice(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}