---
name: data_viewer_intf
description: Describes the interface provided by the uli app data viewer through the get_data() and set_data() methods.
---

# ULI SDK app data viewer specs

## overview

uli app data viewer is a uli app that is used to view the data obtained from the assets in the Uli SDK infrastructure. It subscribes to the data topics of the assets. The data topics are streamed from the assets to the data viewer through the peer-to-peer tcp connection. The data viewer can forward the received data topics to the frontend through the webRTC connection or serialized the data topics into log files.

The data topic viewer incorporates the functionality of the data topic service discovery and data topic subscription with uli app ocu. The communication between the data viewer and the uli app ocu is through the ULI SDK Infrastructure.

This specs is to describe the interface provided by the uli app data viewer through the get_data() and set_data() methods.

## Interface implementation

Reference implementation is in the `reference_implementations/uli_py/data_viewer.py` file.

The interactions with the uli app data viewer are through the get_data() and set_data() methods. The get_data() method is used to get the data and status from the uli app data viewer, and the set_data() method is used to set the data to the uli app data viewer. Both get_data() and set_data() methods take a url string to the data as an argument. The set_data() method also takes a json string as an argument. The get_data() method returns a json string.

The url string to the data is in the format of "data://<app_domain>/<service_uri>?<query_string>".

- app_domain: either "any" for any application or the full name of the uli app. The full name of the uli app is the name space of the uli app, separated by "." in the reverse order, for example: "data_viewer.apps.uli_sdk"
- service_uri: the uri of the service, such as "core_clients.DataStore".
- query_string: contains the location key, which specifies the location of the data within the service specified by the service_uri. The query string may also include other (key, value) pairs to further specify the data to be retrieved.

### get_data details

Here describes the url string to the data and the meaning of the returned json string.

#### Retrieve the list of the schemas of the data topics published.
- **url string**: "data://any/core_clients.DataTopicDiscoveryClient?location=compdatatopicschemalist"
- **returned json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "CompDataTopicSchemaListResponse",
    "type": "object",
    "properties": {
      "compdatatopicschemalist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/CompDataTopicSchema"
        }
      }
    },
    "required": ["compdatatopicschemalist"],
    "additionalProperties": false
  }
  ```

#### Retrieve the list the data topics subscribed by the data topic client, identified by its comp id.
- **url string**: "data://data_viewer.apps.uli_sdk/core_clients.DataTopicClient?location=subscribeddatatopics&&id=<comp_id>"
- **returned json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubscribedDataTopicsResponse",
    "type": "object",
    "properties": {
      "subscribeddatatopics": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/DataTopicRec"
        }
      }
    },
    "required": ["subscribeddatatopics"],
    "additionalProperties": false
  }
  ```

#### Retrieve the transform from the transform reporter client.
- **url string**: "data://any/core_clients.TransformReporterClient?location=transform&&id1=<parent_frame>&&id2=<child_frame>"
- **returned json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TransformResponse",
    "type": "object",
    "properties": {
      "transform": {
        "$ref": "#/definitions/Transform"
      }
    },
    "required": ["transform"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> A transform reporter client can report the transform between the coordinate frames for a list of TransformDefs. The transform is retrieved using this get_data function.

### set_data details

Describes the url string to the data and the meaning of the json string.

#### Set the data topic to subscribe by the data topic client, identified by its comp id. If the subscribe list is not set, the data viewer will subscribe to all the data topics.
- **url string**: "data://data_viewer.apps.uli_sdk/core_clients.DataTopicClient?location=subscribeddatatopics&&id=<comp_id>"
- **json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubscribedDataTopicsRequest",
    "type": "object",
    "properties": {
      "subscribeddatatopics": {
        "type": "array",
        "items": {
          "type": "string"
        }
      }
    },
    "required": ["subscribeddatatopics"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> The json string is a list of data topic uris to be subscribed by the data topic client.

#### Set the transform definitions to the transform reporter client. The transform definitions are pairs of parent and child frame names. The transform reporter client reports the transforms between the pairs of parent and child frame names defined in the transform definitions.
- **url string**: "data://any/core_clients.TransformReporterClient?location=transformdefs"
- **json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TransformDefsRequest",
    "type": "object",
    "properties": {
      "transformdefs": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/TransformDef"
        }
      }
    },
    "required": ["transformdefs"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> The json string is a list of transform definitions to be reported by the transform reporter client.

## Common Definitions

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "CommonDefinitions",
  "definitions": {
    "Address": {
      "type": "object",
      "properties": {
        "SubsystemId": {
          "type": "integer"
        },
        "NodeId": {
          "type": "integer"
        },
        "CompId": {
          "type": "integer"
        }
      },
      "required": [
        "SubsystemId",
        "NodeId",
        "CompId"
      ],
      "additionalProperties": false
    },
    "CompDataTopicSchema": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "DataTopicSchemaRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/DataTopicSchemaRec"
          }
        }
      },
      "required": [
        "CompRec",
        "DataTopicSchemaRecList"
      ],
      "additionalProperties": false
    },
    "CompRec": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "CompType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "REGULAR",
            "MISSION_CRITICAL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "Descriptor": {
          "type": "string"
        }
      },
      "required": [
        "Address",
        "CompType",
        "Name",
        "Descriptor"
      ],
      "additionalProperties": false
    },
    "DataTopicRec": {
      "type": "object",
      "properties": {
        "Uri": {
          "type": "string"
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "ChannelId": {
          "type": "integer"
        },
        "SchemaVersion": {
          "type": "integer"
        },
        "Schema": {
          "type": "string"
        },
        "RequiredDataAccessRight": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_ALLOWED",
            "UNCLASSIFIED",
            "CONTROLLED",
            "CLASSIFIED"
          ]
        },
        "ContextFile": {
          "type": "string"
        },
        "Context": {
          "type": "string"
        },
        "HistoryDepth": {
          "type": "integer"
        },
        "DisplayDuration": {
          "type": "integer"
        }
      },
      "required": [
        "Uri",
        "Comp",
        "ChannelId",
        "SchemaVersion",
        "Schema",
        "RequiredDataAccessRight",
        "ContextFile",
        "Context",
        "HistoryDepth",
        "DisplayDuration"
      ],
      "additionalProperties": false
    },
    "DataTopicSchemaRec": {
      "type": "object",
      "properties": {
        "Schema": {
          "type": "string"
        },
        "Version": {
          "type": "number"
        },
        "RequiredDataAccessRight": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_ALLOWED",
            "UNCLASSIFIED",
            "CONTROLLED",
            "CLASSIFIED"
          ]
        },
        "ContextFile": {
          "type": "string"
        },
        "Context": {
          "type": "string"
        }
      },
      "required": [
        "Schema",
        "Version",
        "RequiredDataAccessRight",
        "ContextFile",
        "Context"
      ],
      "additionalProperties": false
    },
    "Transform": {
      "type": "object",
      "properties": {
        "Valid": {
          "type": "boolean"
        },
        "Time": {
          "type": "number"
        },
        "Parent": {
          "type": "string"
        },
        "Child": {
          "type": "string"
        },
        "X": {
          "type": "number"
        },
        "Y": {
          "type": "number"
        },
        "Z": {
          "type": "number"
        },
        "Roll": {
          "type": "number"
        },
        "Pitch": {
          "type": "number"
        },
        "Yaw": {
          "type": "number"
        }
      },
      "required": [
        "Valid",
        "Time",
        "Parent",
        "Child",
        "X",
        "Y",
        "Z",
        "Roll",
        "Pitch",
        "Yaw"
      ],
      "additionalProperties": false
    },
    "TransformDef": {
      "type": "object",
      "properties": {
        "Parent": {
          "type": "string"
        },
        "Child": {
          "type": "string"
        }
      },
      "required": [
        "Parent",
        "Child"
      ],
      "additionalProperties": false
    }
  }
}
```
