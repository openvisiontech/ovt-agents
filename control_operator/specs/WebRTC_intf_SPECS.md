# Interface specs

This document describes the communication messaging between the frontend and the backend. It is implemented over the WebRTC, refer to `specs\WebRTC_server_SPECS.md` and `specs\WebRTC_client_SPECS.md`.

## 1. Overview

There are two channels for the communication between the frontend and the backend: chat channel and stream channel. The chat channel is used for the control messaging, and the stream channel is used for the high throughput data streaming.

## 2. Core Components

The interface consists of the following components:

### 2.1 Chat Channel protocol

The Chat Channel is a two-way channel. It uses json string messages for the communication between the backend and the frontend. The json string contains two fields: action and payload. The action field is a string that specifies the action to be performed, and the payload field is a json object that contains the data needed to perform the action.

#### 2.1.1 Front end to back end messages

1) Retrieve the subsystem control abstractions of all the discovered assets.
   message:

   ```json
       {
         "action": "get_all_control_abstractions",
         "payload": {
         }
      }
   ```

2) Retrieve the access client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_asset_access_info",
         "payload": {
         }
      }
   ```

3) Retrieve the control client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_asset_control_info",
         "payload": {
         }
      }
   ```

4) Retieve the subsystem state client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_state_info",
         "payload": {
         }
      }
   ```

5) Retieve the operating mode client record of the selected subsystem.
   message:

   ```json
       {
         "action": "get_operating_mode_info",
         "payload": {
         }
      }

6) Retrieve the status details of the selected subsystem.
   message:

   ```json
       {
         "action": "get_status_details",
         "payload": {
         }
      }
   ```

7) Retrieve the available agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_available_agents",
         "payload": {
         }
      }
   ```

8) Retrieve the list of the status of all the agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_agent_status",
         "payload": {
         }
      }
   ```

9) Retrieve the details of the agents of the selected subsystem.
   message:

   ```json
       {
         "action": "get_agent_details",
         "payload": {
         }
      }
   ```

10) Retrieve the list of the data topics the selected subsystem is publishing.
    message:

    ```json
        {
          "action": "get_data_topic_list",
          "payload": {
          }
       }
    ```

11) Retrieve the list of the clients who subscribe the data topics of the selected subsystem.
    message:

    ```json
        {
          "action": "get_data_topic_clients",
          "payload": {
          }
       }
    ```

12) Retrieve the list of the transform reporters of the selected subsystem.
    message:

    ```json
        {
          "action": "get_transform_reporters",
          "payload": {
          }
       }
    ```

13) Retrieve the list of the clients who subscribe the transform reporters of the selected subsystem.
    message:

    ```json
        {
          "action": "get_transform_reporters_clients",
          "payload": {
          }
       }
    ```

14) Set the gui record. Front end needs to periodically send this message to keep the connection alive.
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
            "OperatingMode": "UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING | MAINTENANCE",
            "AgentUri": "string",
            "AgentConfiguration": "string",
            "AgentRunningCmd": "UNKNOWN | IDLE | RUN | STOP | ABORT",
            "AgentControlCmd": "UNKNOWN | RESUME | PAUSE | CANCEL",
            "UserParams": "string",
            "AgentCompletionTimeout": "number"
            }
          }
       }
    ```

15) Set the joystick record. Front end needs to periodically send this message when the running agent requires the joystick as user parameters.
    message:

    ```json
        {
          "action": "set_joystick",
          "payload": {
            "joystick1rec": {
                "XAxisPosition": "number",
                "YAxisPosition": "number"
            },
            "joystick2rec": {
                "XAxisPosition": "number",
                "YAxisPosition": "number"
            }
          }
       }
    ```

#### 2.1.2 Backend to frontend messages

1) Rsponse with the subsystem control abstractions of all the discovered assets.
   message:

  ```json
    {
      "action": "all_control_abstractions",
      "payload": {
        "subsystemcontrolabstractions": [
            {
                "Address": {
                    "SubsystemId": "number",
                    "NodeId": "number",
                    "CompId": "number"
                },
                "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN",
                "Name": "string",
                "ControlStatus": "UNKNOWN | NOT_AVAILABLE | NOT_CONTROLLED | UNDER_CONTROLLED",
                "Client": "string"
            }
        ]
      }
    }
  ```

2) Response with the access client record of the selected subsystem.
   message:

  ```json
    {
      "action": "asset_access_info",
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
3) Response with the control client record of the selected subsystem.
   message:

  ```json
    {
      "action": "asset_control_info",
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

4) Response with the subsystem state client record of the selected subsystem.
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
            "HaveControl": "UNKNOWN | NO | YES",
            "ClientState":"UNKNOWN | WAITING | READY | RESET | SHUTDOWN | RENDER_USELESS",
            "State": "UNKNOWN | INITIALIZING | INITIALIZE | OPERATIONAL | EMERGENCY | PAUSE | SHUTDOWN | RENDER_USELESS"
          }
      }
    }
  ```

5) Rsponse with the operating mode client record of the selected subsystem.
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
              "OperatingMode":"UNKNOWN | STANDARD_OPERATING | REDUCED | RIGOROUS | SILENT | HIBERNATED | TRAINING |MAINTENANCE"
            }
      }
    }
  ```

6) Response with the status details of the selected subsystem.
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
                        "SubsystemId": "number",
                        "NodeId": "number",
                        "CompId": "number"
                      },
                      "CompType": "UNKNOWN | REGULAR | MISSION_CRITICAL",
                      "Name": "string",
                      "Descriptor": "string"
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

7) Response with the available agents of the selected subsystem.
   message:

  ```json
    {
      "action": "available_agents",
      "payload": {
        "agentlist": [
          {
            "Name": "string",
            "Uri": "string",
            "User": "boolean",
            "Comp": {
              "SubsystemId": "number",
              "NodeId": "number",
              "CompId": "number"
            },
            "Configuration": "string",
            "RequiredAppAccessRight": "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR",
            "Context": "string",
            "Widget": "string"
          }
        ]
      }
    }
  ```

8) Response with the list of the status of all the agents of the selected subsystem.
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

9) Response with the details of the agents of the selected subsystem.
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
              "Comp": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
              },
              "Configuration": "string",
              "RequiredAppAccessRight": "UNKNOWN | NOT_ALLOWED | OPERATOR | MAINTAINER | ADMINISTRATOR",
              "Context": "string",
              "Widget": "string"
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

10) Response with the list of the data topics the selected subsystem is publishing.
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
                "Description": "string",
                "Comp":{
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
                "Widget": "string"
              }
            ]
          }
        ]
      }
    }
  ```

11) Response with the list of the clients who subscribe the data topics of the selected subsystem.
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
                "Description": "string",
                "Comp":{
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
                "Widget": "string"
              }
            ]
            },
            "SubscribeDataTopics": [
              {
                "Uri": "string",
                "Description": "string",
                "Comp":{
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
                "Widget": "string"
              }
            ],
            "Count": "number"
          }
        ]
      }
    }
  ```

12) Response with the list of the transform reporters of the selected subsystem.
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

13) Reponse with the list of the clients who subscribe the transform reporters of the selected subsystem.
    message:

  ```json
    {
      "action": "transform_reporters_clients",
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

### 2.2 Stream Channel protocol

The Stream Channel is meant for two-way high speed streaming. It used the Json Topic messages. 

#### 2.2.1 Front end to back end data topics

#### 2.2.2 Back end to front end data topics
