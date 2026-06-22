'''
Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
All rights reserved.

Open Vision Technology, LLC. and its licensors retain all intellectual property
and proprietary rights in and to this software, related documentation
and any modifications thereto. Any use, reproduction, disclosure or
distribution of this software and related documentation without an express
license agreement from Open Vision Technology, LLC. is strictly prohibited.
'''

import asyncio
import json
import logging

from uli_py import Ocu

logger = logging.getLogger("ocu_interface")

class OcuInterface:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(OcuInterface, cls).__new__(cls)
            cls._instance.ocu = None
            cls._instance.domain = "any"
            cls._instance.ocu_app_domain = "ocu.apps.uli_sdk"
            cls._instance._lock = asyncio.Lock()
        return cls._instance

    def set_ocu(self, ocu: Ocu):
        self.ocu = ocu

# The self.ocu.get_data() and self.ocu.set_data() methods are synchronous and were returning a string.
# It causes problem when await instructions in front of them. They now return the result directly.
# The wrapper below is still marked as async def, whith ensures compatibility with the webrtc_connection.py.
# so that no further cascading changes are required there.

    async def get_asset_abstractions(self):
        url = f"data://{self.domain}/core_clients.DbDataStore?location=subsystemabstractions&id=0"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_access_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=accessclient"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_control_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=controlclient"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_state_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=stateclient"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_operating_mode_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=operatingmodeclient"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_status_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=statusdetails"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_agent_abstractions(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentabstractions"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_agent_status(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentstatuslist"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_agent_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentdetails"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_data_topic_list(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=compdatatopiclist"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_schema_list(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=compdatatopicschemalist"
        async with self._lock:
            return self.ocu.get_data(url)
        
    async def get_data_topic_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=datatopicclientlist"
        async with self._lock:
            return self.ocu.get_data(url)
        
    async def get_transform_reporters(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformreporterlist"
        async with self._lock:
            return self.ocu.get_data(url)

    async def get_transform_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformclientlist"
        async with self._lock:
            return self.ocu.get_data(url)

    async def set_gui_rec(self, gui_rec: dict):
        url = f"data://{self.domain}/core_clients.DataStore?location=guirec"
        payload = {"guirec": gui_rec}
        async with self._lock:
            return self.ocu.set_data(url, json.dumps(payload))

    async def set_task_exec_rec(self, task_exec_rec: dict):
        url = f"data://{self.domain}/core_clients.DataStore?location=taskexecrec"
        payload = {"taskexecrec": task_exec_rec}
        async with self._lock:
            return self.ocu.set_data(url, json.dumps(payload))

    async def set_task_control_rec(self, task_control_rec: dict):
        url = f"data://{self.domain}/core_clients.DataStore?location=taskcontrolrec"
        payload = {"taskcontrolrec": task_control_rec}
        async with self._lock:
            return self.ocu.set_data(url, json.dumps(payload))

