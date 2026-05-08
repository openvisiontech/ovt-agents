# Json Structure Notation

This document describes the notation for describing the json structures in the markdown files.

## 1. Overview

The json structures in the markdown files use the following notation:

## 2. Notation

| Notation  | Meaning                        | Example            |
| --------- | ------------------------------ | ------------------ |
| "string"  | The value is a string.         | "hello"            |
| "number"  | The value is a number.         | 123                |
| "boolean" | The value is a boolean.        | true               |
| "object"  | The value is an object.        | { "key": "value" } |
| "array"   | The value is an array.         | [1, 2, 3]          |
| "value1"  | "value2"                       | ...                | "valueN" | The value is one of the values. |
| "//"      | Optional additional notations. |                    |


### 2.1 Examples of json structures using the notation

#### 2.1.1 ULIK SDK component

```json
{
  "Address": { //component address
    "SubsystemId": "number", 
    "NodeId": "number",
    "CompId": "number"
  }, // the string notation of the component address is "<SubsystemId>.<NodeId>.<CompId>"
  "Name": "string" //component name
}
```

#### 2.1.2 abstraction of an ULI SDK subsystem

```json
{
  "Address": { //subsystem address
    "SubsystemId": "number",
    "NodeId": "number",
    "CompId": "number"
  }, // the string notation of the subsystem address is "<SubsystemId>.<NodeId>.<CompId>"
  "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN", //subsystem type
  "Name": "string", //subsystem name
  "ControlStatus": "UNKNOWN | NOT_AVAILABLE | NOT_CONTROLLED | UNDER_CONTROLLED", //control status. NOT_AVAILABLE means the subsystem can not be controlled. NOT_CONTROLLED means the subsystem is ready to be controlled. UNDER_CONTROLLED means the subsystem is controlled.
  "Client": "string", //client's compoent address in the string format: "<SubsystemId>.<NodeId>.<CompId>". The client address is "0.0.0" if no client.
  "Pose": { //Pose of the subsystem's main component in the coordinate frame
    "TimeStamp": "number", //timestamp in nanosecond
    "Frame": "string", //coordinate frame
    "Latitude": "number", //latitude in the GNSS WGS84 
    "Longitude": "number", //longitude
    "XPosition": "number", //x position FRD in the reference frame (usually IMU)
    "YPosition": "number", //y position FRD in the reference frame (usually IMU)
    "ZPositionType": "UNKNOWN | ALTITUDE_AGL | ALTITUDE_MSL | ALTITUDE_ASL | DEPTH", //type of the zPosition value, it can be Above Ground Level | Above Mean Sea Level | Above Sea Level | Depth | Unknown.
    "ZPosition": "number", //z position
    "HorizontalRms": "number", //horizontal root mean square
    "VerticalRms": "number", //vertical root mean square
    "Roll": "number", //roll
    "Pitch": "number", //pitch
    "Heading": "number", //heading
    "AltitudeRms": "number" //altitude root mean square
  },
  "Context": "string", //context
  "ProfileImage": "string" //profile image in base64 encoded string of the profile image of the asset. The format of the image is JPEG.
}
