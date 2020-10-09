package net.breezeware.carejoy.core.dto;

import java.time.Instant;

import lombok.Data;

@Data
public class VitalDto {

    private String shortName;

    private String longName;

    private String value;

    private String unit;

    private Instant measuredOn;

    private String source;

    private String notes;
}