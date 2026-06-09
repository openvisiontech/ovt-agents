"""
Module: process_snapshot.py
Description: Step 2 of the Agent State Estimation Workflow. 
This script receives the JSON Base64 list outputs from the MCP get_topic_snapshot
tool and unpacks them back into native JsonTopic class schemas for analysis.
"""

import json
import base64
from typing import List

# Import required ULI readers from the local SDK structure
try:
    from uli_py.json_topic import StreamTopicReader, JsonTopic
except ImportError:
    print("Warning: uli_py.json_topic could not be imported natively. Ensure your PYTHONPATH includes the references.")
    raise

def process_snapshot_result(mcp_result_json_str: str) -> List[JsonTopic]:
    """
    Parses an MCP-provided JSON payload (a list of Base64 strings representing binary Uli topics) 
    back into a list of native Python JsonTopic objects.
    
    Args:
        mcp_result_json_str: The resulting textual JSON list of base64 strings from MCP.
        
    Returns:
        A list of fully formed JsonTopic data models.
    """
    # 1. Parse outer JSON structure
    try:
        base64_strings = json.loads(mcp_result_json_str)
    except json.JSONDecodeError as err:
        print(f"Failed to decode MCP topic JSON payload: {err}")
        return []

    if not isinstance(base64_strings, list):
        print("Type Error: Expected a list of base64 strings from MCP 'get_topic_snapshot' tool.")
        return []

    # 2. Reconstruct topics
    reader = StreamTopicReader()
    reconstructed_topics: List[JsonTopic] = []

    for b64_str in base64_strings:
        try:
            # Natively decode the base64 characters back into the raw binary payload
            binary_payload = base64.b64decode(b64_str)
            
            # Feed the binary payload directly into the StreamTopicReader
            # This extracts metadata tags, JSON elements, and nested arbitrary buffers uniformly.
            topic = reader.read(binary_payload)
            
            if topic is not None:
                reconstructed_topics.append(topic)
            else:
                print("Parse Warning: StreamTopicReader hit an incomplete segment.")
                
        except Exception as err:
            print(f"Error parsing topic via StreamTopicReader: {err}")

    return reconstructed_topics

if __name__ == "__main__":
    # Example local syntax test.
    print("process_snapshot.py is configured correctly for Step 2 execution.")
