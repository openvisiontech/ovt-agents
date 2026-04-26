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
        return cls._instance

    def set_ocu(self, ocu: Ocu):
        self.ocu = ocu

# The self.ocu.get_data() and self.ocu.set_data() methods are synchronous and were returning a string.
# It causes problem when await instructions in front of them. They now return the result directly.
# The wrapper below is still marked as async def, whith ensures compatibility with the webrtc_connection.py.
# so that no further cascading changes are required there.

    async def get_all_subsystem_abstractions(self):
        url = f"data://{self.domain}/core_clients.DbDataStore?location=subsystemabstractions&id=0"
        return self.ocu.get_data(url)

    async def get_asset_access_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=accessclient"
        return self.ocu.get_data(url)

    async def get_asset_control_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=controlclient"
        return self.ocu.get_data(url)

    async def get_state_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=stateclient"
        return self.ocu.get_data(url)

    async def get_operating_mode_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=operatingmodeclient"
        return self.ocu.get_data(url)

    async def get_status_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=statusdetails"
        return self.ocu.get_data(url)

    async def get_available_agents(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentlist"
        return self.ocu.get_data(url)

    async def get_agent_status(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentstatuslist"
        return self.ocu.get_data(url)

    async def get_agent_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentdetails"
        return self.ocu.get_data(url)

    async def get_data_topic_list(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=compdatatopiclist"
        return self.ocu.get_data(url)

    async def get_data_topic_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=datatopicclientlist"
        return self.ocu.get_data(url)

    async def get_transform_reporters(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformreporterlist"
        return self.ocu.get_data(url)

    async def get_transform_reporters_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformclientlist"
        return self.ocu.get_data(url)

    async def set_gui_rec(self, gui_rec: dict):
        url = f"data://{self.domain}/core_clients.DataStore?location=guirec"
        payload = {"guirec": gui_rec}
        return self.ocu.set_data(url, json.dumps(payload))

    async def set_task_exec_rec(self, task_exec_rec: dict):
        url = f"data://{self.domain}/core_clients.DataStore?location=taskexecrec"
        payload = {"taskexecrec": task_exec_rec}
        return self.ocu.set_data(url, json.dumps(payload))

    async def set_joystick(self, joystick1_rec: dict, joystick2_rec: dict):
        res1, res2 = None, None
        if joystick1_rec:
            url1 = f"data://{self.ocu_app_domain}/core_clients.DataStore?location=joystick1rec"
            p1 = {"joystick1rec": joystick1_rec}
            res1 = self.ocu.set_data(url1, json.dumps(p1))
        if joystick2_rec:
            url2 = f"data://{self.ocu_app_domain}/core_clients.DataStore?location=joystick2rec"
            p2 = {"joystick2rec": joystick2_rec}
            res2 = self.ocu.set_data(url2, json.dumps(p2))
        return res1, res2
