---
name: asset_state_estimate
description: Coordinates extracting high-speed asset topics over MCP and evaluating subsystem telemetry loops into structural reports.
---
# Asset State Estimate

This skill provides the comprehensive behavioral workflow for evaluating subsystem state models natively using the backend MCP snapshot routines and the local `uli_py.json_topic` logic loop.

## Execution Pipeline

1. **Pull MCP Topic Snapshots**
   Invoke the MCP Server tool `get_topic_snapshot()`. This function intercepts the latest stream loop natively buffered by `OcuInterface` and returns a list of base64-encoded strings (representing the binary structural layout of `UliTopicReader` structures natively marshalled via `StreamTopicWriter`).

2. **Reconstruct Binary Payloads to `JsonTopic` Objects**
   Pass the resulting JSON string into the local parser module inside this skill's `scripts/` directory.

   ```python
   # Programmatic access example:
   import sys
   # ensure PYTHONPATH includes your current working directory / components.
   from scripts.process_snapshot import process_snapshot_result
   
   # mcp_result contains the exact string JSON payload retrieved from MCP tool.
   topics = process_snapshot_result(mcp_result)
   ```

3. **Evaluate State Model Dynamics**
   Iterate sequentially through each reconstructed `JsonTopic` provided from Step 2. Branch your critical evaluation logic structurally depending strictly on the `topic.uri`:

   - **Visual Feeds (e.g., `topic.uri == 'image.camer1'`)**:
     Locate the native binary buffers inside the topic payload (by proxying to `create_topic_builder_from_json_topic(topic)` to extract `.named_bytes`). Feed these extracted raw image bytes directly back into your Vision capabilities (LLM/VLM context) to dynamically generate semantic scene descriptions.
   - **Telemetry Tensors (e.g., `topic.uri == 'telemetry.state'`)**: 
     Extract native matrices using the extracted `.named_tensors`. Apply physics or state classification heuristics to numeric datasets to identify system stability.
   - **Generic Data Models**: 
     Use context clues explicitly documented inside `topic.head_json` or `topic.data_jsons`. Map logical schema structures securely into active working memory.

4. **Aggregate Results to the Knowledge Graph**
   Synthesize all evaluations from the `JsonTopic` payloads into an actionable final structured Report artifact. Ensure this formal evaluation report handles any active failure mechanisms or telemetry flags correctly, and finally inject mapping coordinates or state attributes directly into the local agent Knowledge Graph (or relevant agent persistent memory systems).
