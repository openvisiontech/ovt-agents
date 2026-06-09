---
name: webRTC_intf
description: Describes the communication messaging between the frontend and the backend over WebRTC.
---

# Interface specs

This document describes the communication messaging between the frontend and the backend. It is implemented over the WebRTC, refer to `docs/specs/webRTC_server.md` and `docs/specs/webRTC_client.md`.

## Overview

There are two channels for the communication between the frontend and the backend: chat channel and stream channel. The chat channel is used for the control messaging, and the stream channel is used for the high throughput data streaming.

## Chat Channel protocol

The Chat Channel is a two-way channel. It uses json string messages for the communication between the backend and the frontend. The json string contains two fields: action and payload. The action field is a string that specifies the action to be performed, and the payload field is a json object that contains the data needed to perform the action.

### **Front end to back end messages**

- Retrieve the subsystem abstractions of all the discovered assets.
   message:

   ```json
       {
         "action": "get_all_abstractions",
         "payload": {
         }
      }
   ```

- Retrieve the access client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_access_info",
         "payload": {
         }
      }
   ```

- Retrieve the control client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_control_info",
         "payload": {
         }
      }
   ```

- Retieve the subsystem state client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_state_info",
         "payload": {
         }
      }
   ```

- Retieve the operating mode client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_operating_mode_info",
         "payload": {
         }
      }

- Retrieve the status details of the selected subsystem.
   message:

   ```json
       {
         "action": "get_status_details",
         "payload": {
         }
      }
   ```

- Retrieve the list of agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_agent_list",
         "payload": {
         }
      }
   ```

- Retrieve the list of the status of all the agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_agent_status",
         "payload": {
         }
      }
   ```

- Retrieve the details of the agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_agent_details",
         "payload": {
         }
      }
   ```

- Retrieve the list of the data topics the selected subsystem is publishing.
    message:

    ```json
        {
          "action": "get_data_topic_list",
          "payload": {
          }
       }
    ```

- Retrieve the list of the schemas of the selected subsystem is publishing.
    message:

    ```json
        {
          "action": "get_schema_list",
          "payload": {
          }
       }
    ```

- Retrieve the list of the clients who subscribe the data topics of the selected subsystem.
    message:

    ```json
        {
          "action": "get_data_topic_clients",
          "payload": {
          }
       }
    ```

- Retrieve the list of the transform reporters of the selected subsystem.
    message:

    ```json
        {
          "action": "get_transform_reporters",
          "payload": {
          }
       }
    ```

- Retrieve the list of the clients who subscribe the transform reporters of the selected subsystem.
    message:

    ```json
        {
          "action": "get_transform_clients",
          "payload": {
          }
       }
    ```

- Set the gui record. Front end needs to periodically send this message to keep the connection alive.
    message:

    ```json
        {
          "action": "set_gui_rec",
          "payload": {
            "guirec": {
            "UserPresent": "UNKNOWN | PRESENT | NOT_PRESENT",
            "SubsystemManager": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "InteractionMode": "UNKNOWN | NONE | WATCH | CONTROL",
            "EstopButton": "UNKNOWN | CLEAR | SET | UNCHANGE",
            "SubsystemStateCmd":"UNKNOWN | RESET | SHUTDOWN | RENDER_USELESS | OPERATIONAL | UNCHANGE",
            "OperatingCategory": "UNKNOWN | STANDARD | ADMINISTRATIVE",
            "OperatingMode": "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"
            }
          }
       }
    ```

- Set Task Execution record. Front end needs to periodically send this message when the running agent requires the agent execution as user parameters.
message:
   
  ```json
    {
      "action": "set_task_exec_rec",
      "payload": {
        "taskexecrec": {
          "AgentUri": "string",
          "Configuration": "string",
          "RunningCmd": "UNKNOWN | IDLE | RUN | STOP | ABORT",
          "CompletionTimeout": "number"
        }
      }
    }
  ```

- Set Task Control Record.
    message:

    ```json
    {
      "action": "set_task_control_rec",
      "payload": {
        "taskcontrolrec": {
          "AgentUri": "string",
          "ControlCmd": "UNKNOWN | RESUME | PAUSE | CANCEL",
          "ControlParams": "string",
          "UserParams": "string"
        }
      }
    }
    ```

### **Backend to frontend messages**

- Response with the subsystem abstractions of all the discovered assets.
   message:

  ```json
    {
      "action": "all_abstractions",
      "payload": {
        "subsystemabstractions": [
            {
                "Address": {
                    "SubsystemId": "number",
                    "NodeId": "number",
                    "CompId": "number"
                },
                "SubsystemType": "UNKNOWN | UNMANNED | AI_AGENT | CONTROLLER | META_HUMAN | PROCESS_TOOL",
                "Name": "string",
                "ControlStatus": "UNKNOWN | NOT_AVAILABLE | NOT_CONTROLLED | UNDER_CONTROLLED",
                "Client": "string",
                "Pose": {
                    "TimeStamp": "number",
                    "Frame": "string",
                    "Latitude": "number",
                    "Longitude": "number",
                    "XPosition": "number",
                    "YPosition": "number",
                    "ZPositionType": "UNKNOWN | ALTITUDE_AGL | ALTITUDE_MSL | ALTITUDE_ASL | DEPTH",
                    "ZPosition": "number",
                    "HorizontalRms": "number",
                    "VerticalRms": "number",
                    "Roll": "number",
                    "Pitch": "number",
                    "Heading": "number",
                    "AltitudeRms": "number"
                },
                "Context": "string",
                "ProfileImage": "string"
            }
        ]
      }
    }
  ```

- Response with the access client record of the selected subsystem.
   message:

  ```json
    {
      "action": "access_info",
      "payload": {
        "accessclient":
          {
            "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "HaveAccess": "UNKNOWN | NO | YES",
            "SessionId": "string",
            "AppAccessRight": "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR",
            "DataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED"
          }
      }
    }
  ```

- Response with the control client record of the selected subsystem.
   message:

  ```json
    {
      "action": "control_info",
      "payload": {
        "controlclient":
          {
            "Comp": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "HaveControl": "UNKNOWN | NO | YES",
            "SessionId": "string"
          }
      }
    }
  ```

- Response with the subsystem state client record of the selected subsystem.
   message:

  ```json
    {
      "action": "state_info",
      "payload": {
        "stateclient":
          {
            "Comp": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "HaveState": "UNKNOWN | NO | YES",
            "ClientState":"UNKNOWN | WAITING | READY | RESET | SHUTDOWN | RENDER_USELESS",
            "State": "UNKNOWN | INITIALIZING | INITIALIZE | OPERATIONAL | EMERGENCY | PAUSE | SHUTDOWN | RENDER_USELESS"
          }
      }
    }
  ```

- Response with the operating mode client record of the selected subsystem.
   message:

  ```json
    {
      "action": "operating_mode_info",
      "payload": {
        "operatingmodeclient":
          {
              "Comp": {
                  "SubsystemId": "number",
                  "NodeId": "number",
                  "CompId": "number"
              },
              "OperatingCategory": "UNKNOWN | STANDARD | ADMINISTRATIVE",
              "OperatingMode": "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE"
            }
      }
    }
  ```

- Response with the status details of the selected subsystem.
   message:

  ```json
    {
      "action": "status_details",
      "payload": {
        "statusdetails": [
          {
            "CompRec": {
              "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
              },
              "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
              "Name": "string",
              "Descriptor": "string"
            },
            "MajorVersion": "number",
            "MinorVersion": "number",
            "BuildNumber": "number",
            "CompControl": "UNKNOWN | NOT_CONTROLLED | CONTROLLED | NOT_AVAIL",
            "ManagementState": "UNKNOWN | INITIALIZE | STAND_BY | READY | EMERGENCY | PAUSE | CONTINUE | FATAL | SHUTDOWN | RENDER_USELESS",
            "OperatingCategory": "UNKNOWN | STANDARD | ADMINISTRATIVE",
            "OperatingMode": "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE",
            "Seconds": "number",
            "LinkUpdateTime": "string",
            "LinkRecList": [
              {
                  "Destination": {
                      "SubsystemId": "number",
                      "NodeId": "number",
                      "CompId": "number"
                  },
                  "RoundTripTime": "number",
                  "LastQuery": "number",
                  "LastReply": "number"
                }
            ],
            "SubscriptionRecList": [
              {
                  "DataTopicUri": "string",
                  "Subscribers": [
                    {
                      "CompRec": {
                        "Address": {
                          "SubsystemId": "number",
                          "NodeId": "number",
                          "CompId": "number"
                        },
                        "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
                        "Name": "string",
                        "Descriptor": "string"
                      },
                      "Seconds": "number",
                      "Count": "number",
                      "LastUpdate": "number"
                    }
                  ]
                }
            ],
            "HealthSummary": "string",
            "ServiceHealthRecList": [
              {
                "ServiceRec": {
                  "ServiceUri": "string",
                  "MajorVersion": "number",
                  "MinorVersion": "number"
                },
                "HealthRec": {
                  "code": "number",
                  "Severity": "UNKNOWN | NONE | INFO | WARN | ERROR | FATAL",
                  "Descriptor": "string",
                  "LastUpdate": "string"
                }
              }
            ]
          }
        ]
      }
    }
  ```

- Response with the available agents of the selected subsystem.
   message:

  ```json
    {
      "action": "agent_list",
      "payload": {
        "agentlist": [
          {
            "Name": "string",
            "Uri": "string",
            "User": "UNKNOWN | YES | NO",
            "Comp": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "Configuration": "string",
            "RequiredAppAccessRight": "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR",
            "Context": "string"
          }
        ]
      }
    }
  ```

- Response with the list of the status of all the agents of the selected subsystem.
   message:

  ```json
    {
      "action": "agent_status",
      "payload": {
        "agentstatuslist": [
          {
            "Name": "string",
            "Uri": "string",
            "Comp": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "Readiness": "string",
            "RequestUuid": "string",
            "Requestor": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "Configuration": "string",
            "CompletionTimeout": "number",
            "RunTime": "number",
            "EnterStateTime": "number",
            "State": "UNKNOWN | REQUEST_WAIT | CONTROL_WAIT | RUNNING | PAUSED | COMPLETE_WAIT | COMPLETE",
            "FeedbackData": "string",
            "CompletionCode": "UNKNOWN | SUCCESS | FAIL",
            "Result": "string"
          }
        ]
      }
    }
  ```

- Response with the details of the agents of the selected subsystem.
   message:

  ```json
    {
      "action": "agent_details",
      "payload": {
        "agentdetails": {
          "agentlist": [
            {
              "Name": "string",
              "Uri": "string",
              "User": "UNKNOWN | YES | NO",
              "Comp": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
              },
              "Configuration": "string",
              "RequiredAppAccessRight": "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR",
              "Context": "string"
            }
          ],
          "agentctrlclilist": [
            {
              "Uri": "string",
              "ControlCmd": "UNKNOWN | OBTAIN | RELEASE | UNCHANGE"
            }
          ],
          "agentctrlclistalist": [
            {
              "AgentUri": "string",
              "HaveControl": "UNKNOWN | NO | YES"
            }
          ]
        }
      }
    }
  ```

- Response with the list of the data topics the selected subsystem is publishing.
    message:

  ```json
    {
      "action": "data_topic_list",
      "payload": {
        "compdatatopiclist": [
          {
            "CompRec": {
              "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
              },
              "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
              "Name": "string",
              "Descriptor": "string"
            },
            "Url": "string",
            "Forwarded": "boolean",
            "ForwardedUrl": "string",
            "Status": "UNKNOWN | INACTIVE | ACTIVE | NO_RIGHT",
            "DataTopicRecList": [
              {
                "Uri": "string",
                "Comp": {
                  "SubsystemId": "number",
                  "NodeId": "number",
                  "CompId": "number"
                },
                "ChannelId": "number",
                "SchemaVersion": "number",
                "Schema": "string",
                "RequiredDataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED",
                "ContextFile": "string",
                "Context": "string",
                "HistoryDepth": "number",
                "DisplayDuration": "number"
              }
            ]
          }
        ]
      }
    }
  ```

- Response with the list of the schemas of the data topics the selected subsystem is publishing.
    message:

  ```json
    {
      "action": "schema_list",
      "payload": {
        "compdatatopiclist": [
          {
            "CompRec": {
              "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
              },
              "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
              "Name": "string",
              "Descriptor": "string"
            },
            "DataTopicSchemaRecList": [
              {
                "Schema": "string",
                "Version": "number",
                "RequiredDataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED",
                "ContextFile": "string",
                "Context": "string"
              }
            ]
          }
        ]
      }
    }
  ```

- Response with the list of the clients who subscribe the data topics of the selected subsystem.
    message:

  ```json
    {
      "action": "data_topic_clients",
      "payload": {
        "datatopicclientlist": [
          {
            "ClientAddress": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "CompDataTopic": {
              "CompRec": {
                "Address": {
                  "SubsystemId": "number",
                  "NodeId": "number",
                  "CompId": "number"
                },
                "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
                "Name": "string",
                "Descriptor": "string"
              },
              "Url": "string",
              "Forwarded": "boolean",
              "ForwardedUrl": "string",
              "Status": "UNKNOWN | INACTIVE | ACTIVE | NO_RIGHT",
              "DataTopicRecList": [
                {
                  "Uri": "string",
                  "Comp": {
                    "SubsystemId": "number",
                    "NodeId": "number",
                    "CompId": "number"
                  },
                  "ChannelId": "number",
                  "SchemaVersion": "number",
                  "Schema": "string",
                  "RequiredDataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED",
                  "ContextFile": "string",
                  "Context": "string",
                  "HistoryDepth": "number",
                  "DisplayDuration": "number"
                }
              ]
            },
            "SubscribeDataTopics": [
              {
                "Uri": "string",
                "Comp": {
                  "SubsystemId": "number",
                  "NodeId": "number",
                  "CompId": "number"
                },
                "ChannelId": "number",
                "SchemaVersion": "number",
                "Schema": "string",
                "RequiredDataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED",
                "ContextFile": "string",
                "Context": "string",
                "HistoryDepth": "number",
                "DisplayDuration": "number"
              }
            ],
            "Count": "number"
          }
        ]
      }
    }
  ```

- Response with the list of the transform reporters of the selected subsystem.
    message:

  ```json
    {
      "action": "transform_reporters",
      "payload": {
        "transformreporterlist": [
          {
            "Name": "string",
            "Description": "string",
            "Uri": "string",
            "Comp": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "TransformDefs": [
              {
                "Parent": "string",
                "Child": "string"
              }
            ]
          }
        ]
      }
    }
  ```

- Reponse with the list of the clients who subscribe the transform reporters of the selected subsystem.
    message:

  ```json
    {
      "action": "transform_clients",
      "payload": {
        "transformclientlist": [
          {
            "Name": "string",
            "Description": "string",
            "Uri": "string",
            "Comp": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "TransformDefs": [
              {
                "Parent": "string",
                "Child": "string"
              }
            ]
          }
        ]
      }
    }
  ```

## Stream Channel protocol

The Stream Channel is meant for two-way high speed streaming. It used the Json Topic messages. 

### **Front end to back end data topics**

### **Back end to front end data topics**

Subscribed data topics.

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
    "Pose": {
      "type": "object",
      "properties": {
        "TimeStamp": {
          "type": "integer"
        },
        "Frame": {
          "type": "string"
        },
        "Latitude": {
          "type": "number"
        },
        "Longitude": {
          "type": "number"
        },
        "XPosition": {
          "type": "number"
        },
        "YPosition": {
          "type": "number"
        },
        "ZPositionType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "ALTITUDE_AGL",
            "ALTITUDE_MSL",
            "ALTITUDE_ASL",
            "DEPTH"
          ]
        },
        "ZPosition": {
          "type": "number"
        },
        "HorizontalRms": {
          "type": "number"
        },
        "VerticalRms": {
          "type": "number"
        },
        "Roll": {
          "type": "number"
        },
        "Pitch": {
          "type": "number"
        },
        "Heading": {
          "type": "number"
        },
        "AltitudeRms": {
          "type": "number"
        }
      },
      "required": [
        "TimeStamp",
        "Frame",
        "Latitude",
        "Longitude",
        "XPosition",
        "YPosition",
        "ZPositionType",
        "ZPosition",
        "HorizontalRms",
        "VerticalRms",
        "Roll",
        "Pitch",
        "Heading",
        "AltitudeRms"
      ],
      "additionalProperties": false
    },
    "SubsystemAbstraction": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "SubsystemType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "UNMANNED",
            "AI_AGENT",
            "CONTROLLER",
            "META_HUMAN",
            "PROCESS_TOOL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "ControlStatus": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_AVAILABLE",
            "NOT_CONTROLLED",
            "UNDER_CONTROLLED"
          ]
        },
        "Client": {
          "type": "string"
        },
        "Pose": {
          "$ref": "#/definitions/Pose"
        },
        "Context": {
          "type": "string"
        },
        "ProfileImage": {
          "type": "string"
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "ControlStatus",
        "Client",
        "Pose",
        "Context",
        "ProfileImage"
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
    "ServiceRec": {
      "type": "object",
      "properties": {
        "ServiceUri": {
          "type": "string"
        },
        "MajorVersion": {
          "type": "integer"
        },
        "MinorVersion": {
          "type": "integer"
        }
      },
      "required": [
        "ServiceUri",
        "MajorVersion",
        "MinorVersion"
      ],
      "additionalProperties": false
    },
    "CompServicesRec": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "ServiceRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/ServiceRec"
          }
        }
      },
      "required": [
        "CompRec",
        "ServiceRecList"
      ],
      "additionalProperties": false
    },
    "SubsystemService": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "SubsystemType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "UNMANNED",
            "AI_AGENT",
            "CONTROLLER",
            "META_HUMAN",
            "PROCESS_TOOL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "CompServicesRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/CompServicesRec"
          }
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "CompServicesRecList"
      ],
      "additionalProperties": false
    },
    "LinkRec": {
      "type": "object",
      "properties": {
        "Destination": {
          "$ref": "#/definitions/Address"
        },
        "RoundTripTime": {
          "type": "number"
        },
        "LastQuery": {
          "type": "number"
        },
        "LastReply": {
          "type": "number"
        }
      },
      "required": [
        "Destination",
        "RoundTripTime",
        "LastQuery",
        "LastReply"
      ],
      "additionalProperties": false
    },
    "SubscriberRec": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "Seconds": {
          "type": "number"
        },
        "Count": {
          "type": "number"
        },
        "LastUpdate": {
          "type": "number"
        }
      },
      "required": [
        "CompRec",
        "Seconds",
        "Count",
        "LastUpdate"
      ],
      "additionalProperties": false
    },
    "SubscriptionRec": {
      "type": "object",
      "properties": {
        "DataTopicUri": {
          "type": "string"
        },
        "Subscribers": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/SubscriberRec"
          }
        }
      },
      "required": [
        "DataTopicUri",
        "Subscribers"
      ],
      "additionalProperties": false
    },
    "HealthRec": {
      "type": "object",
      "properties": {
        "code": {
          "type": "integer"
        },
        "Severity": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NONE",
            "INFO",
            "WARN",
            "ERROR",
            "FATAL"
          ]
        },
        "Descriptor": {
          "type": "string"
        },
        "LastUpdate": {
          "type": "string"
        }
      },
      "required": [
        "code",
        "Severity",
        "Descriptor",
        "LastUpdate"
      ],
      "additionalProperties": false
    },
    "ServiceHealthRec": {
      "type": "object",
      "properties": {
        "ServiceRec": {
          "$ref": "#/definitions/ServiceRec"
        },
        "HealthRec": {
          "$ref": "#/definitions/HealthRec"
        }
      },
      "required": [
        "ServiceRec",
        "HealthRec"
      ],
      "additionalProperties": false
    },
    "CompStatusDetailsRec": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "MajorVersion": {
          "type": "integer"
        },
        "MinorVersion": {
          "type": "integer"
        },
        "BuildNumber": {
          "type": "integer"
        },
        "CompControl": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_CONTROLLED",
            "CONTROLLED",
            "NOT_AVAIL"
          ]
        },
        "ManagementState": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "INITIALIZE",
            "STAND_BY",
            "READY",
            "EMERGENCY",
            "PAUSE",
            "CONTINUE",
            "FATAL",
            "SHUTDOWN",
            "RENDER_USELESS"
          ]
        },
        "OperatingCategory": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD",
            "ADMINISTRATIVE"
          ]
        },
        "OperatingMode": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD_OPERATING",
            "REDUCED",
            "RIGOROUS",
            "SILENT",
            "HIBERNATED",
            "TRAINING",
            "MAINTENANCE"
          ]
        },
        "Seconds": {
          "type": "number"
        },
        "LinkUpdateTime": {
          "type": "string"
        },
        "LinkRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/LinkRec"
          }
        },
        "SubscriptionRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/SubscriptionRec"
          }
        },
        "HealthSummary": {
          "type": "string"
        },
        "ServiceHealthRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/ServiceHealthRec"
          }
        }
      },
      "required": [
        "CompRec",
        "MajorVersion",
        "MinorVersion",
        "BuildNumber",
        "CompControl",
        "ManagementState",
        "OperatingCategory",
        "OperatingMode",
        "Seconds",
        "LinkUpdateTime",
        "LinkRecList",
        "SubscriptionRecList",
        "HealthSummary",
        "ServiceHealthRecList"
      ],
      "additionalProperties": false
    },
    "SubsystemStatusDetails": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "SubsystemType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "UNMANNED",
            "AI_AGENT",
            "CONTROLLER",
            "META_HUMAN",
            "PROCESS_TOOL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "CompStatusDetailsRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/CompStatusDetailsRec"
          }
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "CompStatusDetailsRecList"
      ],
      "additionalProperties": false
    },
    "ResourceRec": {
      "type": "object",
      "properties": {
        "ResourceType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "VIDEO",
            "AUDIO",
            "WEB",
            "INTERACTION",
            "MECHANISM",
            "MOBILITY",
            "MANIPULATION"
          ]
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
        "Name": {
          "type": "string"
        },
        "ContextFile": {
          "type": "string"
        },
        "Context": {
          "type": "string"
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "Intf": {
          "type": "string"
        },
        "Url": {
          "type": "string"
        },
        "Forwarded": {
          "type": "boolean"
        },
        "ForwardedUrl": {
          "type": "string"
        }
      },
      "required": [
        "ResourceType",
        "RequiredDataAccessRight",
        "Name",
        "ContextFile",
        "Context",
        "Comp",
        "Intf",
        "Url",
        "Forwarded",
        "ForwardedUrl"
      ],
      "additionalProperties": false
    },
    "CompResourcesRec": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "ResourceRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/ResourceRec"
          }
        }
      },
      "required": [
        "CompRec",
        "ResourceRecList"
      ],
      "additionalProperties": false
    },
    "SubsystemResources": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "SubsystemType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "UNMANNED",
            "AI_AGENT",
            "CONTROLLER",
            "META_HUMAN",
            "PROCESS_TOOL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "CompResourcesRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/CompResourcesRec"
          }
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "CompResourcesRecList"
      ],
      "additionalProperties": false
    },
    "AgentRec": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Uri": {
          "type": "string"
        },
        "User": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "YES",
            "NO"
          ]
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "Configuration": {
          "type": "string"
        },
        "RequiredAppAccessRight": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_ALLOWED",
            "OPERATOR",
            "MAINTAINER",
            "ADMINISTRATOR"
          ]
        },
        "Context": {
          "type": "string"
        }
      },
      "required": [
        "Name",
        "Uri",
        "User",
        "Comp",
        "Configuration",
        "RequiredAppAccessRight",
        "Context"
      ],
      "additionalProperties": false
    },
    "SubsystemAgents": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "SubsystemType": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "UNMANNED",
            "AI_AGENT",
            "CONTROLLER",
            "META_HUMAN",
            "PROCESS_TOOL"
          ]
        },
        "Name": {
          "type": "string"
        },
        "AgentRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/AgentRec"
          }
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "AgentRecList"
      ],
      "additionalProperties": false
    },
    "AccessClient": {
      "type": "object",
      "properties": {
        "Address": {
          "$ref": "#/definitions/Address"
        },
        "HaveAccess": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NO",
            "YES"
          ]
        },
        "SessionId": {
          "type": "string"
        },
        "AppAccessRight": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_ALLOWED",
            "OPERATOR",
            "MAINTAINER",
            "ADMINISTRATOR"
          ]
        },
        "DataAccessRight": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NOT_ALLOWED",
            "UNCLASSIFIED",
            "CONTROLLED",
            "CLASSIFIED"
          ]
        }
      },
      "required": [
        "Address",
        "HaveAccess",
        "SessionId",
        "AppAccessRight",
        "DataAccessRight"
      ],
      "additionalProperties": false
    },
    "ControlClient": {
      "type": "object",
      "properties": {
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "HaveControl": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NO",
            "YES"
          ]
        },
        "SessionId": {
          "type": "string"
        }
      },
      "required": [
        "Comp",
        "HaveControl",
        "SessionId"
      ],
      "additionalProperties": false
    },
    "StateClient": {
      "type": "object",
      "properties": {
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "HaveState": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NO",
            "YES"
          ]
        },
        "ClientState": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "WAITING",
            "READY",
            "RESET",
            "SHUTDOWN",
            "RENDER_USELESS"
          ]
        },
        "State": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "INITIALIZING",
            "INITIALIZE",
            "OPERATIONAL",
            "EMERGENCY",
            "PAUSE",
            "SHUTDOWN",
            "RENDER_USELESS"
          ]
        }
      },
      "required": [
        "Comp",
        "HaveState",
        "ClientState",
        "State"
      ],
      "additionalProperties": false
    },
    "OperatingModeClient": {
      "type": "object",
      "properties": {
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "OperatingCategory": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD",
            "ADMINISTRATIVE"
          ]
        },
        "OperatingMode": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD_OPERATING",
            "REDUCED",
            "RIGOROUS",
            "SILENT",
            "HIBERNATED",
            "TRAINING",
            "MAINTENANCE"
          ]
        }
      },
      "required": [
        "Comp",
        "OperatingCategory",
        "OperatingMode"
      ],
      "additionalProperties": false
    },
    "AgentStatus": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Uri": {
          "type": "string"
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "Readiness": {
          "type": "string"
        },
        "RequestUuid": {
          "type": "string"
        },
        "Requestor": {
          "$ref": "#/definitions/Address"
        },
        "Configuration": {
          "type": "string"
        },
        "CompletionTimeout": {
          "type": "number"
        },
        "RunTime": {
          "type": "number"
        },
        "EnterStateTime": {
          "type": "number"
        },
        "State": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "REQUEST_WAIT",
            "CONTROL_WAIT",
            "RUNNING",
            "PAUSED",
            "COMPLETE_WAIT",
            "COMPLETE"
          ]
        },
        "FeedbackData": {
          "type": "string"
        },
        "CompletionCode": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "SUCCESS",
            "FAIL"
          ]
        },
        "Result": {
          "type": "string"
        }
      },
      "required": [
        "Name",
        "Uri",
        "Comp",
        "Readiness",
        "RequestUuid",
        "Requestor",
        "Configuration",
        "CompletionTimeout",
        "RunTime",
        "EnterStateTime",
        "State",
        "FeedbackData",
        "CompletionCode",
        "Result"
      ],
      "additionalProperties": false
    },
    "AgentCtrlCli": {
      "type": "object",
      "properties": {
        "Uri": {
          "type": "string"
        },
        "ControlCmd": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "OBTAIN",
            "RELEASE",
            "UNCHANGE"
          ]
        }
      },
      "required": [
        "Uri",
        "ControlCmd"
      ],
      "additionalProperties": false
    },
    "AgentCtrlCliStatus": {
      "type": "object",
      "properties": {
        "AgentUri": {
          "type": "string"
        },
        "HaveControl": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NO",
            "YES"
          ]
        }
      },
      "required": [
        "AgentUri",
        "HaveControl"
      ],
      "additionalProperties": false
    },
    "AgentDetails": {
      "type": "object",
      "properties": {
        "agentlist": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/AgentRec"
          }
        },
        "agentctrlclilist": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/AgentCtrlCli"
          }
        },
        "agentctrlclistalist": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/AgentCtrlCliStatus"
          }
        }
      },
      "required": [
        "agentlist",
        "agentctrlclilist",
        "agentctrlclistalist"
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
    "CompDataTopic": {
      "type": "object",
      "properties": {
        "CompRec": {
          "$ref": "#/definitions/CompRec"
        },
        "Url": {
          "type": "string"
        },
        "Forwarded": {
          "type": "boolean"
        },
        "ForwardedUrl": {
          "type": "string"
        },
        "Status": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "INACTIVE",
            "ACTIVE",
            "NO_RIGHT"
          ]
        },
        "DataTopicRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/DataTopicRec"
          }
        }
      },
      "required": [
        "CompRec",
        "Url",
        "Forwarded",
        "ForwardedUrl",
        "Status",
        "DataTopicRecList"
      ],
      "additionalProperties": false
    },
    "DataTopicClient": {
      "type": "object",
      "properties": {
        "ClientAddress": {
          "$ref": "#/definitions/Address"
        },
        "CompDataTopic": {
          "$ref": "#/definitions/CompDataTopic"
        },
        "SubscribeDataTopics": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/DataTopicRec"
          }
        },
        "Count": {
          "type": "number"
        }
      },
      "required": [
        "ClientAddress",
        "CompDataTopic",
        "SubscribeDataTopics",
        "Count"
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
    "TransformReporter": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Description": {
          "type": "string"
        },
        "Uri": {
          "type": "string"
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "TransformDefs": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/TransformDef"
          }
        }
      },
      "required": [
        "Name",
        "Description",
        "Uri",
        "Comp",
        "TransformDefs"
      ],
      "additionalProperties": false
    },
    "TransformClient": {
      "type": "object",
      "properties": {
        "Name": {
          "type": "string"
        },
        "Description": {
          "type": "string"
        },
        "Uri": {
          "type": "string"
        },
        "Comp": {
          "$ref": "#/definitions/Address"
        },
        "TransformDefs": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/TransformDef"
          }
        }
      },
      "required": [
        "Name",
        "Description",
        "Uri",
        "Comp",
        "TransformDefs"
      ],
      "additionalProperties": false
    },
    "GuiRec": {
      "type": "object",
      "properties": {
        "UserPresent": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "PRESENT",
            "NOT_PRESENT"
          ]
        },
        "Subsystemmanager": {
          "$ref": "#/definitions/Address"
        },
        "InteractionMode": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "NONE",
            "WATCH",
            "CONTROL"
          ]
        },
        "EstopButton": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "CLEAR",
            "SET",
            "UNCHANGE"
          ]
        },
        "SubsystemStateCmd": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "RESET",
            "SHUTDOWN",
            "RENDER_USELESS",
            "OPERATIONAL",
            "UNCHANGE"
          ]
        },
        "OperatingCategory": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD",
            "ADMINISTRATIVE"
          ]
        },
        "OperatingMode": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "STANDARD_OPERATING",
            "REDUCED",
            "RIGOROUS",
            "SILENT",
            "HIBERNATED",
            "TRAINING",
            "MAINTENANCE"
          ]
        }
      },
      "required": [
        "UserPresent",
        "Subsystemmanager",
        "InteractionMode",
        "EstopButton",
        "SubsystemStateCmd",
        "OperatingCategory",
        "OperatingMode"
      ],
      "additionalProperties": false
    },
    "TaskExecRec": {
      "type": "object",
      "properties": {
        "AgentUri": {
          "type": "string"
        },
        "Configuration": {
          "type": "string"
        },
        "RunningCmd": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "IDLE",
            "RUN"
          ]
        },
        "CompletionTimeout": {
          "type": "number"
        }
      },
      "required": [
        "AgentUri",
        "Configuration",
        "RunningCmd",
        "CompletionTimeout"
      ],
      "additionalProperties": false
    },
    "TaskControlRec": {
      "type": "object",
      "properties": {
        "AgentUri": {
          "type": "string"
        },
        "ControlCmd": {
          "type": "string",
          "enum": [
            "UNKNOWN",
            "RESUME",
            "PAUSE",
            "CANCEL"
          ]
        },
        "ControlParams": {
          "type": "string"
        },
        "UserParams": {
          "type": "string"
        }
      },
      "required": [
        "AgentUri",
        "ControlCmd",
        "ControlParams",
        "UserParams"
      ],
      "additionalProperties": false
    }
  }
}
```
