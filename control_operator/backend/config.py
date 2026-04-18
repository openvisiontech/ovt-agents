import json

def load_config(path: str) -> dict:
    try:
        with open(path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {"working_dir": "."}
