# ULI SDK app ocu specs

## overview

ULI SDK app ocu is to discover the assets in the Uli SDK infrastructure, view the data obtained from the assets, and control the assets.

This specs is to describe the interface provided by the uli app ocu through the get_data() and set_data() methods.

## Interface implementation

Reference implementation is in the `reference_implementations/uli_py/ocu.py` file.

The interactions with the uli app ocu are through the get_data() and set_data() methods. The get_data() method is used to get the data and status from the uli app ocu, and the set_data() method is used to set the data to the uli app ocu. Both get_data() and set_data() methods take a url string to the data as an argument. The set_data() method also takes a json string as an argument. The get_data() method returns a json string.

The url string to the data is in the format of "data://<app_domain>/<service_uri>?<query_string>".

- app_domain: either "any" for any application or the full name of the uli app. The full name of the uli app is the name space of the uli app, separated by "." in the reverse order, for example: "ocu.apps.uli_sdk"
- service_uri: the uri of the service, such as "core_clients.DashBoard".
- query_string: contains the location key, which specifies the location of the data within the service specified by the service_uri. The query string may also include other (key, value) pairs to further specify the data to be retrieved.

### get_data details

Here describes the url string to the data and the meaning of the returned json string.

1. Retrieve the subsystem abstractions of all the discovered assets
    - url string: "data://any/core_clients.DbDataStore?location=subsystemabstractions&id=0"
    - returned json string in the format of:
      ```json
      {
        "subsystemabstractions": [
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
      ```

2. Retrieve the services hosted by all the discovered assets
    - url string: "data://any/core_clients.DbDataStore?location=subsystemservices&id=0"
    - returned json string in the format of:
      ```json
      {
        "subsystemservices": [
          {
            "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN",
            "Name": "string",
            "CompServicesRecList": [
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
                "ServiceRecList": [
                    {
                        "ServiceUri": "string",
                        "MajorVersion": "number",
                        "MinorVersion": "number"
                    }
                ]   
              }
            ]
          }
        ]
      }
      ```

3. Retrieve the status details of all the discovered assets
    - url string: "data://any/core_clients.DbDataStore?location=subsystemstatusdetails&id=0"
    - returned json string in the format of:
      ```json
      {
        "subsystemstatusdetails": [
          {
            "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN",
            "Name": "string",
            "CompStatusDetailsRecList": [
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
        ]
      }
      ```

4. Retrieve the resources of all the discovered assets
    - url string: "data://any/core_clients.DbDataStore?location=subsystemresources&id=0"
    - returned json string in the format of:
      ```json
      {
        "subsystemresources": [
          {
            "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN",
            "Name": "string",
            "CompResourcesRecList": [
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
                "ResourceRecList": [
                  {
                    "ResourceType": "string",
                    "RequiredDataAccessRight": "UNKNOWN | NOT_ALLOWED | UNCLASSIFIED | CONTROLLED | CLASSIFIED",
                    "Name": "string",
                    "ContextTemplate": "string",
                    "Comp":{
                        "SubsystemId": "number",
                        "NodeId": "number",
                        "CompId": "number"
                    },
                    "Intf": "string",
                    "Url": "string",
                    "Forwarded": "boolean",
                    "ForwardedUrl": "string"
                  }
                ]
              }
            ]
          }
        ]
      }
      ```   

5. Retrieve the available agents from all the discovered assets
    - url string: "data://any/core_clients.DbDataStore?location=subsystemagents&id=0"
    - returned json string in the format of:
      ```json
      {
        "subsystemagents": [
          {
            "Address": {
                "SubsystemId": "number",
                "NodeId": "number",
                "CompId": "number"
            },
            "SubsystemType": "UNKNOWN | HOSPITALITY | AGV | UNMANNED | SENSOR | AI | CONTROLLER | META_HUMAN",
            "Name": "string",
            "AgentRecList": [
                {
                    "name": "string",
                    "Uri": "string",
                    "User": "string",
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
        ]
      }      
      ```

6.  Retrieve the access client record of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=accessclient"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The Subsystem Access Client service is used to gain access to the selected subsystem. It periodically sends the Request Subsystem Access message to the subsystem access service. The access will timeout if the subsystem access service does not receive the Request Subsystem Access message within the timeout period.

      The access right is determined by the subsystem access service based on the certificate in the Request Subsystem Access message.

      The subsystem access service returns the session id and the access right to the access client. The application can use the session id to subscribe the data topoics of the subsystem.

7.  Retrieve the control client record of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=controlclient"
    - returned json string in the format of:
      ```json
      {
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
      ```
      
      The Subsystem Control Client service is used to gain or release control to the selected subsystem. It periodically sends the Request Subsystem Control message to the subsystem control service. The control will timeout if the subsystem control service does not receive the Request Subsystem Control message within the timeout period.

      The Subsystem may have been controlled by another control client. In this case, the control client will be granted control if its authority code is higher than the authority code of the current control client. The authority code is embedded in the Request Subsystem Control message. The authority code is from the configuration of the subsystem control client.

      The cerficate in the Request Subsystem Control message is used to determine whether the control client is authorized to gain control of the subsystem.

      The subsystem control service returns the session id if the control is granted. The application can use the session id to again control of the subsystem state service and the agent services in the subsystem.

      The subsystem control client service will send the Release Subsystem Control message to the subsystem control service when it releases the control of the subsystem.

8.  Retrieve the subsystem state client record of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=stateclient"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The client state is the state of the subsystem state client service. The subsystem state client service sends the Set Subsystem State messages to the subsystem state service after it has the control of the subsystem state service. "WAITING" client state means that the subsystem state client service is waiting for the control of the subsystem state service. The state specified in the Set Subsystem State message is listed in the State column of the following table:
      
      ```
      ClientState | State specified in Set Subsystem State message
      UNKNOWN | NOT SENDING
      WAITING | NOT SENDING
      READY | OPERATIONAL
      RESET | RESET 
      SHUTDOWN | SHUTDOWN 
      RENDER_USELESS | RENDER_USELESS 
      ```

9. Retrieve the operating mode client record of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=operatingmodeclient"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The operating mode client is used to set the operating mode of the subsystem. The operating mode is set by the subsystem operating mode service.

10. Retrieve the status details of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=statusdetails"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The status details is a list of the status detail of all the components in the subsystem. The status detail includes the descriptions of the component, the operating mode of the component, the management state of the component, the number of seconds the component has been running, the time the link test was last performed, the round trip time of the link test, the time the link test was last performed, the subscription records of the component, the health summary of the component, and the service health records of the component. 

11. Retrieve the list of the availabel agents of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=agentlist"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The agent list is a list of the agent records of all the agents in the subsystem. The agent record includes the name of the agent, the uri of the agent, whether the agent needs the user parameters, the component where the agent is located, the configuration of the agent in JSON string format, the required access right of the agent, the context of the agent in markdown string format, and the widget of the agent. 

12. Retrieve the list of the status of all the agents of the selected subsystem
    - url string: "data://any/core_clients.DataStore?location=agentstatuslist"
    - returned json string in the format of:
      ```json
      {
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
      ```

      The agent status is a list of the status of all the agents in the subsystem. The agent status includes the name of the agent, the uri of the agent, the requestor of the agent, the configuration and the completion timeoutthat requestor set, number of seconds the agent has been running, the time the agent entered the current state, the current state, the completion code, and the result of the execution of the agent.  

13. Retrieve the details of the agents of the selected subsystem. The details includes list of the agents, the clients of the agents, and the control states of the agent clients.
    - url string: "data://any/core_clients.DataStore?location=agentdetails"
    - returned json string in the format of:
      ```json
      {
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
      ```

14. Retrieve the list of the data topics the selected subsystem is publishing
    - url string: "data://any/core_clients.DataStore?location=compdatatopiclist"
    - returned json string in the format of:
      ```json
      {
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
      ```

The data topics is a list of the data topics the selected subsystem is publishing. The comp data topic includes the component which is publishing the data topic, the url of the data topic stream, whether the data topic stream is forwarded, the url of the forwarded data topic stream, and the status of the data topic stream. The status of the data topic stream indicates whether the client has subscribed through the data topic stream or the client does not have the right to subscribe.

 The data topic record list includes the uri of the data topic, the description of the data topic, the component which is publishing the data topic, the channel id of the data topic, the schema version of the data topic, the schema of the data topic, the required data access right of the data topic, the context file that the context is stored in, the context of the data topic, and the widget that is used to display the data topic.

15. Retrieve the list of the clients who are subscribing to the data topics the selected subsystem is publishing.
    - url string: "data://any/core_clients.DataStore?location=datatopicclientlist"
    - returned json string in the format of:
      ```json
      {
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
      ```

The SubscribeDataTopics is a list of the data topics the client is subscribing from the data topic service of the component of the selected subsystem. The count indicates the number of times the client has sent the subscribe request messages to the data topic service.

16. Retrieve the list of the transform reporters of the selected subsystem. The transform reporter is a component that reports the transform between the coordinate frames of the selected subsystem.
    - url string: "data://any/core_clients.DataStore?location=transformreporterlist"
    - returned json string in the format of:
      ```json
      {
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
      ```

The transform reporter is a component that reports the transform between the coordinate frames of the selected subsystem.  The list includes the name of the transform reporter, the description of the transform reporter, the uri of the transform reporter, the component which is reporting the transform, and the list of the transform definitions.

The transform definition is the pair of the parent frame and the child frame.

18. Retrieve the list of the transform reporter clients of the selected subsystem. The transform reporter client is a component that subscribes to the reports of transforms from the transform reporter.
    - url string: "data://any/core_clients.DataStore?location=transformclientlist"
    - returned json string in the format of:
      ```json
      {
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
      ```

The transform client is a component that retrieves the transform from the transform reporter client.  The list includes the name of the transform client, the description of the transform client, the uri of the transform client, the component which is retrieving the transform, and the list of the transform definitions.

The transform definition includes the parent frame and the child frame.

### set_data details 

Here describes the url string to the data and the meaning of the json string.

1. Set the joystick1 record. The joystick1 record is to set joystick1 data during driving.
    - url string: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=joystick1rec"
    - json string in the format of:
      ```json
      {
        "joystick1rec": {
            "XAxisPosition": "number",
            "YAxisPosition": "number"
          }
      }
      ```
      Both the XAxisPosition and YAxisPosition are in the range of -1 to 1.

2. Set the joystick2 record. The joystick2 record is to set joystick2 data during driving.
    - url string: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=joystick2rec"
    - json string in the format of:
      ```json
      {
        "joystick2rec": {
            "XAxisPosition": "number",
            "YAxisPosition": "number"
          }
      }
      ```
      Both the XAxisPosition and YAxisPosition are in the range of -1 to 1.

3. Set the gui record. The gui record is to set gui data that is used to control the vehicle.
    - url string: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=guirec"
    - json string in the format of:
      ```json
      {
        "guirec": {
            "UserPresent": "UNKNOWN | PRESENT | NOT_PRESENT",
            "Subsystemmanager": {
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
      ```
  The guirec contains fields collected from the gui. They are used to interact, control, and monitor the vehicle. Here are the explanations of the fields:
    - UserPresent: Indicates whether the user is in attendance. This is one of the safety critical fields. If the user is not in attendance, the vehicle will stop.
    - Subsystemmanager: The component id of the subsystem manager of the subsystem is currently selected.
    - InteractionMode: Indicates how to interact with the selected subsystem. It can be WATCH, CONTROL, or NONE. The OCU will obtain the control of the selected subsystem if the interaction mode is CONTROL.
    - EstopButton: The estop button status. It can be CLEAR, SET, or UNCHANGE. The OCU will send the estop button status to the safety component of the selected subsystem. If the estop button is in SET state, the safety component will obtain the control of the subsystem and set the subsystem state to EMERGENCY that all the safety critical components will be notified and transition to the EMERGENCY state. If the estop button is in CLEAR state, the safety component will release the control of the subsystem. The Ocu will have the control and set the subsystem state to OPERATIONAL that all the safety critical components will be notified and transition to the STAND_BY state.
    - SubsystemStateCmd: The subsystem state command. It can be RESET, SHUTDOWN, RENDER_USELESS, OPERATIONAL, or UNCHANGE. The OCU will send the subsystem state command to the subsystem manager of the selected subsystem. If the subsystem state command is RESET, the subsystem state service will transition to the INITIALIZING state.
   If the subsystem state command is SHUTDOWN, the subsystem manager will shutdown the subsystem. If the subsystem state command is RENDER_USELESS, the subsystem manager will render the subsystem useless. If the subsystem state command is OPERATIONAL, the subsystem manager will set the subsystem state to OPERATIONAL that all the safety critical components will be notified and transition to the STAND_BY state. If the subsystem state command is UNCHANGE, the subsystem manager will not change the subsystem state.
    - OperatingCategory: The operating category. It can be STANDARD or ADMINISTRATIVE.
    - OperatingMode: The operating mode. It can be STANDARD_OPERATING, REDUCED, RIGOROUS, SILENT, HIBERNATED, TRAINING, or MAINTENANCE. All of the components in the subsystem will be notified of the operating mode.
  
  4. Set the task exec record. The task exec record is to set the task exec data that is used to interact with the agent.
    - url string: "data://ocu.apps.uli_sdk/core_clients.DataStore?location=taskexecrec"
    - json string in the format of:
      ```json
      {
        "taskexecrec": {
            "AgentUri": "string",
            "AgentConfigurations": "string",
            "AgentRunningCmd": "UNKNOWN | IDLE | RUN",
            "AgentControlCmd": "UNKNOWN | RESUME | PAUSE | CANCEL",
            "ControlParameters": "string",
            "UserParams": "string",
            "AgentCompletionTimeout": "number"
          }
      }
      ```
    - AgentUri: The agent uri is the uri of the agent that is currently selected. If no agent is selected, the agent uri will be empty.
    - AgentRunningCmd: The agent running command. It can be IDLE, RUN. The Ocu will command the selected agent to go through Request, Control, and Complete stages, when the AgentRunningCmd is "RUN".
    - AgentControlCmd: The agent control command. It can be RESUME, PAUSE, or CANCEL. The OCU will send the agent control command to the agent. It controls the process of the agent in the Control stage.
    - ControlParameters: The control parameters. The control parameters are the parameters that are set by the OCU. The Ocu will send the control parameters to the agent in the Control stage.
    - UserParams: The user parameters. The user parameters are the parameters that are set by the user. The Ocu will send the user parameters to the agent in the Control stage. For example, the joystick data is sent to the agent as user parameters.
    - AgentCompletionTimeout: The agent completion timeout is the timeout for the agent to complete the task. The time is started when the agent is in the Control stage. If the agent is not in the Control stage, the agent completion timeout is not set. If the AgentCompletionTimeout is set to zero, then there is no timeout constraint. If the AgentCompletionTimeout is reached, the agent will be stopped and the agent will be set to the Complete stage.
