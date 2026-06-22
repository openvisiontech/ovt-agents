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

- Retrieve the abstractions of all the discovered assets.
   message:

   ```json
       {
         "action": "get_asset_abstractions",
         "payload": {
         }
      }
   ```

- Retrieve the access client record of the selected asset.
   message:

   ```json
       {
         "action": "get_access_info",
         "payload": {
         }
      }
   ```

- Retrieve the control client record of the selected asset.
   message:

   ```json
       {
         "action": "get_control_info",
         "payload": {
         }
      }
   ```

- Retieve the subsystem state client record of the selected asset.
   message:

   ```json
       {
         "action": "get_state_info",
         "payload": {
         }
      }
   ```

- Retieve the operating mode client record of the selected asset.
   message:

   ```json
       {
         "action": "get_operating_mode_info",
         "payload": {
         }
      }

- Retrieve the status details of the selected asset.
   message:

   ```json
       {
         "action": "get_status_details",
         "payload": {
         }
      }
   ```

- Retrieve the abstractions of agents of the selected asset.
   message:

   ```json
       {
         "action": "get_agent_abstractions",
         "payload": {
         }
      }
   ```

- Retrieve the list of the status of all the agents of the selected asset.
   message:

   ```json
       {
         "action": "get_agent_status",
         "payload": {
         }
      }
   ```

- Retrieve the details of the agents of the selected asset.
   message:

   ```json
       {
         "action": "get_agent_details",
         "payload": {
         }
      }
   ```

- Retrieve the list of the data topics the selected asset is publishing.
    message:

    ```json
        {
          "action": "get_data_topic_list",
          "payload": {
          }
       }
    ```

- Retrieve the list of the schemas of the selected asset is publishing.
    message:

    ```json
        {
          "action": "get_schema_list",
          "payload": {
          }
       }
    ```

- Retrieve the list of the clients who subscribe the data topics of the selected asset.
    message:

    ```json
        {
          "action": "get_data_topic_clients",
          "payload": {
          }
       }
    ```

- Retrieve the list of the transform reporters of the selected asset.
    message:

    ```json
        {
          "action": "get_transform_reporters",
          "payload": {
          }
       }
    ```

- Retrieve the list of the clients who subscribe the transform reporters of the selected asset.
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
      "action": "asset_abstractions",
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

- Response with the available agents of the selected asset.
   message:

  ```json
    {
      "action": "agent_abstractions",
      "payload": {
        "agentabstractions": [
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

- Response with the list of the status of all the agents of the selected asset.
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

- Response with the details of the agents of the selected asset.
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

- Response with the list of the data topics the selected asset is publishing.
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

- Response with the list of the schemas of the data topics the selected asset is publishing.
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

- Response with the list of the clients who subscribe the data topics of the selected asset.
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

- Response with the list of the transform reporters of the selected asset.
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

- Reponse with the list of the clients who subscribe the transform reporters of the selected asset.
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

Refer to `**ocu_intf.md**` for common definitions of the JSON objects used in this document.