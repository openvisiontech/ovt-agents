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

1. Retrieve the list the data topics subscribed by the data topic client, identified by its comp id.
    - url string: "data://data_viewer.apps.uli_sdk/core_clients.DataTopicClient?location=subscribeddatatopics&&id=<comp_id>"
    - returned json string in the format of:
      ```json
      {
        "subscribeddatatopics": [
          {
            "Uri": "string",
            "Description": "string",
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
            "Widget": "string"
          }
        ]
      }
      ```

2. Retrieve the transform from the transform reporter client.
    - url string: "data://any/core_clients.TransformReporterClient?location=transform&&id1=<parent_frame>&&id2=<child_frame>"
    - returned json string in the format of:
      ```json
      {
        "transform": {
          "Valid": "boolean",
          "Time": "number",
          "Parent": "string",
          "Child": "string",
          "X": "number",
          "Y": "number",
          "Z": "number",
          "Roll": "number",
          "Pitch": "number",
          "Yaw": "number"
        }
      }
      ```

A transform reporter client can report the transform between the coordinate frames for a list of TransformDefs. The transform is retrieved using this get_data function.


### set_data details

Here describes the url string to the data and the meaning of the set_data() method.

1. Set the data topic to subscribe by the data topic client, identified by its comp id. If the subscribe list is not set, the data viewer will subscribe to all the data topics.
   
    - url string: "data://data_viewer.apps.uli_sdk/core_clients.DataTopicClient?location=subscribedatatopics&&id=<comp_id>"
    - json string in the format of:
      ```json
      {
        "subscribeddatatopics": [
          "string"
        ]
      }
      ```
    - The json string is a list of data topic uris to be subscribed by the data topic client.
  
2. Set the transform definitions to the transform reporter client. The transform definitions are pairs of parent and child frame names. The transform reporter client reports the transforms between the pairs of parent and child frame names defined in the transform definitions.
    - url string: "data://any/core_clients.TransformReporterClient?location=transformdefs"
    - json string in the format of:
      ```json
      {
        "transformdefs": [
          {
            "Parent": "string",
            "Child": "string"
          }
        ]
      }
      ```
    - The json string is a list of transform definitions to be reported by the transform reporter client.


