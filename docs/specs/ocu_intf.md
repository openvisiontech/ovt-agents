---
name: ocu_intf
description: Describes the interface provided by the uli sdk app ocu through the get_data() and set_data() methods.
---

# ULI SDK app ocu interface

## overview

ULI SDK app ocu is to discover the assets in the Uli SDK infrastructure, view the data obtained from the assets, and control the assets.
This document is to describe the interface provided by the uli app ocu through the get_data() and set_data() methods.

## Interface implementation

Reference implementation is in the `reference_implementations/uli_py/ocu.py` file.

The interactions with the uli sdk app ocu are through the get_data() and set_data() methods. The get_data() method is used to get the data and status from the uli sdk app ocu, and the set_data() method is used to set the data to the uli sdk app ocu. Both get_data() and set_data() methods take a url string to the data as an argument. The set_data() method also takes a json string as an argument. The get_data() method returns a json string.

The url string to the data is in the format of "data://<app_domain>/<service_uri>?<query_string>".

- **app_domain**: either "any" for any application or the full name of the uli app. The full name of the uli app is the name space of the uli app, separated by "." in the reverse order, for example: "ocu.apps.uli_sdk". 
- **service_uri**: the uri of the service, such as "core_clients.DashBoard".
- **query_string**: contains the location key, which specifies the location of the data within the service specified by the service_uri. The query string may also include other (key, value) pairs to further specify the data to be retrieved.

### get_data details

Here describes the url string to the data and the meaning of the returned json string.

#### Retrieve the subsystem abstractions of all the discovered assets

- **url string**: "data://any/core_clients.DbDataStore?location=subsystemabstractions&id=0"
- **returned json string**:
      
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubsystemAbstractionsResponse",
    "type": "object",
    "properties": {
      "subsystemabstractions": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/SubsystemAbstraction"
        }
      }
    },
    "required": ["subsystemabstractions"],
    "additionalProperties": false
  }
  ```

#### Retrieve the services hosted by all the discovered assets

- **url string**: "data://any/core_clients.DbDataStore?location=subsystemservices&id=0"
- **returned json string**:

  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubsystemServicesResponse",
    "type": "object",
    "properties": {
      "subsystemservices": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/SubsystemService"
        }
      }
    },
    "required": ["subsystemservices"],
    "additionalProperties": false
  }
  ```

#### Retrieve the status details of all the discovered assets

- **url string**: "data://any/core_clients.DbDataStore?location=subsystemstatusdetails&id=0"
- **returned json string**:

  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubsystemStatusDetailsResponse",
    "type": "object",
    "properties": {
      "subsystemstatusdetails": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/SubsystemStatusDetails"
        }
      }
    },
    "required": ["subsystemstatusdetails"],
    "additionalProperties": false
  }
  ```

#### Retrieve the resources of all the discovered assets

- **url string**: "data://any/core_clients.DbDataStore?location=subsystemresources&id=0"
- **returned json string**:

  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubsystemResourcesResponse",
    "type": "object",
    "properties": {
      "subsystemresources": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/SubsystemResources"
        }
      }
    },
    "required": ["subsystemresources"],
    "additionalProperties": false
  }
  ```   

#### Retrieve the agent abstractions that meet the app access requirements from all the discovered assets

- **url string**: "data://any/core_clients.DbDataStore?location=subsystemagentabstractions&id=0"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "SubsystemAgentAbstractionsResponse",
    "type": "object",
    "properties": {
      "subsystemagentabstractions": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/SubsystemAgentAbstractions"
        }
      }
    },
    "required": ["subsystemagentabstractions"],
    "additionalProperties": false
  }
  ```

#### Retrieve the access client record of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=accessclient"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "AccessClientResponse",
    "type": "object",
    "properties": {
      "accessclient": {
        "$ref": "#/definitions/AccessClient"
      }
    },
    "required": ["accessclient"],
    "additionalProperties": false
  }
  ```

> [!NOTE]

> 1. The Subsystem Access Client service is used to gain access to the selected subsystem. It periodically sends the Request Subsystem Access message to the subsystem access service. The access will timeout if the subsystem access service does not receive the Request Subsystem Access message within the timeout period.

> 2. The access right is determined by the subsystem access service based on the certificate in the Request Subsystem Access message.

> 3. The subsystem access service returns the session id and the access right to the access client. The application can use the session id to subscribe the data topoics of the subsystem.

#### Retrieve the control client record of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=controlclient"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "ControlClientResponse",
    "type": "object",
    "properties": {
      "controlclient": {
        "$ref": "#/definitions/ControlClient"
      }
    },
    "required": ["controlclient"],
    "additionalProperties": false
  }
  ```
      
  > [!NOTE]

  > 1. The Subsystem Control Client service is used to gain or release control to the selected subsystem. It periodically sends the Request Subsystem Control message to the subsystem control service. The control will timeout if the subsystem control service does not receive the Request Subsystem Control message within the timeout period.

  > 2. The Subsystem may have been controlled by another control client. In this case, the control client will be granted control if its authority code is higher than the authority code of the current control client. The authority code is embedded in the Request Subsystem Control message. The authority code is from the configuration of the subsystem control client.

  > 3. The cerficate in the Request Subsystem Control message is used to determine whether the control client is authorized to gain control of the subsystem.

  > 4. The subsystem control service returns the session id if the control is granted. The application can use the session id to again control of the subsystem state service and the agent services in the subsystem.

  > 5. The subsystem control client service will send the Release Subsystem Control message to the subsystem control service when it releases the control of the subsystem.

#### Retrieve the subsystem state client record of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=stateclient"
- **returned json**:
  ```json
      {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "title": "StateClientResponse",
        "type": "object",
        "properties": {
          "stateclient": {
            "$ref": "#/definitions/StateClient"
          }
        },
        "required": ["stateclient"],
        "additionalProperties": false
      }
      ```

>[!NOTE]
>
> The client state is the state of the subsystem state client service. The subsystem state client service sends the Set Subsystem State messages to the subsystem state service after it has the control of the subsystem state service. "WAITING" client state means that the subsystem state client service is waiting for the control of the subsystem state service. The state specified in the Set Subsystem State message is listed in the State column of the following table:
      
      ```
      ClientState | State specified in Set Subsystem State message
      UNKNOWN | NOT SENDING
      WAITING | NOT SENDING
      READY | OPERATIONAL
      RESET | RESET 
      SHUTDOWN | SHUTDOWN 
      RENDER_USELESS | RENDER_USELESS 
      ```

#### Retrieve the operating mode client record of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=operatingmodeclient"
- **returned json**:
  ```json
      {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "title": "OperatingModeClientResponse",
        "type": "object",
        "properties": {
          "operatingmodeclient": {
            "$ref": "#/definitions/OperatingModeClient"
          }
        },
        "required": ["operatingmodeclient"],
        "additionalProperties": false
      }
      ```

> [!NOTE]
>
> The operating mode client is used to set the operating mode of the subsystem. The operating mode is set by the subsystem operating mode service.

#### Retrieve the status details of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=statusdetails"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "StatusDetailsResponse",
    "type": "object",
    "properties": {
      "statusdetails": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/CompStatusDetailsRec"
        }
      }
    },
    "required": ["statusdetails"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> 
> The status details is a list of the status detail of all the components in the subsystem. The status detail includes the descriptions of the component, the operating mode of the component, the management state of the component, the number of seconds the component has been running, the time the link test was last performed, the round trip time of the link test, the time the link test was last performed, the subscription records of the component, the health summary of the component, and the service health records of the component. 

#### Retrieve the agent abstractions that meet the app access requirements from the selected asset.

- **url string**: "data://any/core_clients.DbDataStore?location=agentabstractions"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "AgentAbstractionsResponse",
    "type": "object",
    "properties": {
      "agentabstractions": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/AgentAbstractionRec"
        }
      }
    },
    "required": ["agentabstractions"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> The agent list is a list of the agent records of all the agents in the subsystem. The agent record includes the name of the agent, the uri of the agent, whether the agent needs the user parameters, the component where the agent is located, the configuration of the agent in JSON string format, the required access right of the agent, the context of the agent in markdown string format, and the widget of the agent. 

#### Retrieve the list of the status of all the agents of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=agentstatuslist"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "AgentStatusListResponse",
    "type": "object",
    "properties": {
      "agentstatuslist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/AgentStatus"
        }
      }
    },
    "required": ["agentstatuslist"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> The agent status is a list of the status of all the agents in the subsystem. The agent status includes the name of the agent, the uri of the agent, the requestor of the agent, the configuration and the completion timeoutthat requestor set, number of seconds the agent has been running, the time the agent entered the current state, the current state, the completion code, and the result of the execution of the agent.  

#### Retrieve the details of the agents of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=agentdetails"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "AgentDetailsResponse",
    "type": "object",
    "properties": {
      "agentdetails": {
        "$ref": "#/definitions/AgentDetails"
      }
    },
    "required": ["agentdetails"],
    "additionalProperties": false
  }
  ```

#### Retrieve the list of the data topics the selected subsystem is publishing

- **url string**: "data://any/core_clients.DataStore?location=compdatatopiclist"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "CompDataTopicListResponse",
    "type": "object",
    "properties": {
      "compdatatopiclist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/CompDataTopic"
        }
      }
    },
    "required": ["compdatatopiclist"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> 
> The data topics is a list of the data topics the selected subsystem is publishing. The comp data topic includes the component which is publishing the data topic, the url of the data topic stream, whether the data topic stream is forwarded, the url of the forwarded data topic stream, and the status of the data topic stream. The status of the data topic stream indicates whether the client has subscribed through the data topic stream or the client does not have the right to subscribe.

#### Retrieve the list of the clients who are subscribing to the data topics the selected subsystem is publishing

- **url string**: "data://any/core_clients.DataStore?location=datatopicclientlist"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "DataTopicClientListResponse",
    "type": "object",
    "properties": {
      "datatopicclientlist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/DataTopicClient"
        }
      }
    },
    "required": ["datatopicclientlist"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
> 
> 1. The data topics is a list of the data topics the selected subsystem is publishing. The comp data topic includes the component which is publishing the data topic, the url of the data topic stream, whether the data topic stream is forwarded, the url of the forwarded data topic stream, and the status of the data topic stream. The status of the data topic stream indicates whether the client has subscribed through the data topic stream or the client does not have the right to subscribe.
> 2. The SubscribeDataTopics is a list of the data topics the client is subscribing from the data topic service of the component of the selected subsystem. The count indicates the number of times the client has sent the subscribe request messages to the data topic service.

#### Retrieve the list of the schemas of the data topics that the selected subsystem is publishing

- **url string**: "data://any/core_clients.DataStore?location=compdatatopicschemalist"
- **returned json**:
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

> [!NOTE]
>
> The comp data topic schema is the schema of the data topic that the component is publishing.

#### Retrieve the list of the transform reporters of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=transformreporterlist"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TransformReporterListResponse",
    "type": "object",
    "properties": {
      "transformreporterlist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/TransformReporter"
        }
      }
    },
    "required": ["transformreporterlist"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> 1. The transform reporter is a component that reports the transform between the coordinate frames of the selected subsystem.  The list includes the name of the transform reporter, the description of the transform reporter, the uri of the transform reporter, the component which is reporting the transform, and the list of the transform definitions.
>
> 2. The transform definition is the pair of the parent frame and the child frame.

#### Retrieve the list of the transform reporter clients of the selected subsystem

- **url string**: "data://any/core_clients.DataStore?location=transformclientlist"
- **returned json**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TransformClientListResponse",
    "type": "object",
    "properties": {
      "transformclientlist": {
        "type": "array",
        "items": {
          "$ref": "#/definitions/TransformClient"
        }
      }
    },
    "required": ["transformclientlist"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> 1. The transform client is a component that retrieves the transform from the transform reporter client.  The list includes the name of the transform client, the description of the transform client, the uri of the transform client, the component which is retrieving the transform, and the list of the transform definitions.
> 2. The transform definition includes the parent frame and the child frame.

### set_data details

Describes the url string to the data and the meaning of the json string.

#### Set the gui record. The gui record is to set gui data that is used to control the vehicle.

- **url string**: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=guirec"
- **json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "GuiRecRequest",
    "type": "object",
    "properties": {
      "guirec": {
        "$ref": "#/definitions/GuiRec"
      }
    },
    "required": ["guirec"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> 1. The guirec contains fields collected from the gui. They are used to interact, control, and monitor the vehicle. Here are the explanations of the fields:
> 2. UserPresent: Indicates whether the user is in attendance. This is one of the safety critical fields. If the user is not in attendance, the vehicle will stop.
> 3. Subsystemmanager: The component id of the subsystem manager of the subsystem is currently selected.
> 4. InteractionMode: Indicates how to interact with the selected subsystem. It can be WATCH, CONTROL, or NONE. The OCU will obtain the control of the selected subsystem if the interaction mode is CONTROL.
> 5. EstopButton: The estop button status. It can be CLEAR, SET, or UNCHANGE. The OCU will send the estop button status to the safety component of the selected subsystem. If the estop button is in SET state, the safety component will obtain the control of the subsystem and set the subsystem state to EMERGENCY that all the safety critical components will be notified and transition to the EMERGENCY state. If the estop button is in CLEAR state, the safety component will release the control of the subsystem. The Ocu will have the control and set the subsystem state to OPERATIONAL that all the safety critical components will be notified and transition to the STAND_BY state.
> 6. SubsystemStateCmd: The subsystem state command. It can be RESET, SHUTDOWN, RENDER_USELESS, OPERATIONAL, or UNCHANGE. The OCU will send the subsystem state command to the subsystem manager of the selected subsystem.
>    - If the subsystem state command is RESET, the subsystem state service will transition to the INITIALIZING state.
>    - If the subsystem state command is SHUTDOWN, the subsystem manager will shutdown the subsystem.
>    - If the subsystem state command is RENDER_USELESS, the subsystem manager will render the subsystem useless.
>    - If the subsystem state command is OPERATIONAL, the subsystem manager will set the subsystem state to OPERATIONAL that all the safety critical components will be notified and transition to the STAND_BY state.
>    - If the subsystem state command is UNCHANGE, the subsystem manager will not change the subsystem state.
> 7. OperatingCategory: The operating category. It can be STANDARD or ADMINISTRATIVE.
> 8. OperatingMode: The operating mode. It can be STANDARD_OPERATING, REDUCED, RIGOROUS, SILENT, HIBERNATED, TRAINING, or MAINTENANCE. All of the components in the subsystem will be notified of the operating mode.

#### Set the task exec record. The task exec record is to set the task exec data that is used to interact with the agent.
- **url string**: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=taskexecrec"
- **json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TaskExecRec",
    "type": "object",
    "properties": {
      "taskexecrec": {
        "$ref": "#/definitions/TaskExecRec"
      }
    },
    "required": ["taskexecrec"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> 1. The task exec record is used to command an agent to perform a task.
> 2. AgentUri: The agent uri is the uri of the agent that is currently selected. If no agent is selected, the agent uri will be empty.
> 3. RunningCmd: The agent running command. It can be IDLE, RUN. The Ocu will command the selected agent to go through Request, Control, and Complete stages, when the AgentRunningCmd is "RUN".
> 4. CompletionTimeout: The agent completion timeout is the timeout for the agent to complete the task. The time is started when the agent is in the Control stage. If the agent is not in the Control stage, the agent completion timeout is not set. If the AgentCompletionTimeout is set to zero, then there is no timeout constraint. If the AgentCompletionTimeout is reached, the agent will be stopped and the agent will be set to the Complete stage.

#### Set the task control record. The task control record is to set the task control data that is used to control the vehicle.
- **url string**: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=taskcontrolrec"
- **json string**:
  ```json
  {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "TaskControlRec",
    "type": "object",
    "properties": {
      "taskcontrolrec": {
        "$ref": "#/definitions/TaskControlRec"
      }
    },
    "required": ["taskcontrolrec"],
    "additionalProperties": false
  }
  ```

> [!NOTE]
>
> 1. The task control record is used to control the process of an agent in the Control stage.
> 2. AgentUri: The agent uri is the uri of the agent that is currently selected. If no agent is selected, the agent uri will be empty.
> 3. ControlCmd: The agent control command. It can be RESUME, PAUSE, or CANCEL. The OCU will send the agent control command to the agent. It controls the process of the agent in the Control stage.
> 4. ControlParams: The control parameters. The control parameters are the parameters that are set by the OCU. The Ocu will send the control parameters to the agent in the Control stage.
> 5. UserParams: The user parameters. The user parameters are the parameters that are set by the user. The Ocu will send the user parameters to the agent in the Control stage. For example, the joystick data is sent to the agent as user parameters.

### Receive_topics

Receive the topic streams published by the Data Topic Services of the selected subsystem. The received_topics() method returns a list of UliTopicReader objects, refer to the uli_py/uli_topic.py for the details of the UliTopicReader class.

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
    "AgentAbstractionRec": {
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
        },
        "ProfileImage": {
          "type": "string"
        },
        "Requestor": {
          "$ref": "#/definitions/Address"
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
      },
      "required": [
        "Name",
        "Uri",
        "User",
        "Comp",
        "Configuration",
        "RequiredAppAccessRight",
        "Context",
        "ProfileImage",
        "Requestor",
        "CompletionTimeout",
        "RunTime",
        "EnterStateTime",
        "State",
        "FeedbackData",
        "CompletionCode"
      ],
      "additionalProperties": false
    },
    "SubsystemAgentAbstractions": {
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
        "AgentAbstractionRecList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/AgentAbstractionRec"
          }
        }
      },
      "required": [
        "Address",
        "SubsystemType",
        "Name",
        "AgentAbstractionRecList"
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
