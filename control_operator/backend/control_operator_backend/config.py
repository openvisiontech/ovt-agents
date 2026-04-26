'''
Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
All rights reserved.

Open Vision Technology, LLC. and its licensors retain all intellectual property
and proprietary rights in and to this software, related documentation
and any modifications thereto. Any use, reproduction, disclosure or
distribution of this software and related documentation without an express
license agreement from Open Vision Technology, LLC. is strictly prohibited.
'''

import json

def load_config(path: str) -> dict:
    try:
        with open(path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {"working_dir": "."}
