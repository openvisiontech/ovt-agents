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

    async def get_all_control_abstractions(self):
        url = f"data://{self.domain}/core_clients.DashBoard?location=subsystemcontrolabstractions&id=0"
        return await self.ocu.get_data(url)

    async def get_asset_access_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=accessclient"
        return await self.ocu.get_data(url)

    async def get_asset_control_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=controlclient"
        return await self.ocu.get_data(url)

    async def get_state_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=stateclient"
        return await self.ocu.get_data(url)

    async def get_operating_mode_info(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=operatingmodeclient"
        return await self.ocu.get_data(url)

    async def get_status_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=statusdetails"
        return await self.ocu.get_data(url)

    async def get_available_agents(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentlist"
        return await self.ocu.get_data(url)

    async def get_agent_status(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentstatuslist"
        return await self.ocu.get_data(url)

    async def get_agent_details(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=agentdetails"
        return await self.ocu.get_data(url)

    async def get_data_topic_list(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=compdatatopiclist"
        return await self.ocu.get_data(url)

    async def get_data_topic_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=datatopicclientlist"
        return await self.ocu.get_data(url)

    async def get_transform_reporters(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformreporterlist"
        return await self.ocu.get_data(url)

    async def get_transform_reporters_clients(self):
        url = f"data://{self.domain}/core_clients.DataStore?location=transformclientlist"
        return await self.ocu.get_data(url)

    async def set_gui_rec(self, gui_rec: dict):
        url = f"data://{self.ocu_app_domain}/core_clients.DataStore?location=guirec"
        payload = {"guirec": gui_rec}
        return await self.ocu.set_data(url, json.dumps(payload))

    async def set_joystick(self, joystick1_rec: dict, joystick2_rec: dict):
        res1, res2 = None, None
        if joystick1_rec:
            url1 = f"data://{self.ocu_app_domain}/core_clients.DataStore?location=joystick1rec"
            p1 = {"joystick1rec": joystick1_rec}
            res1 = await self.ocu.set_data(url1, json.dumps(p1))
        if joystick2_rec:
            url2 = f"data://{self.ocu_app_domain}/core_clients.DataStore?location=joystick2rec"
            p2 = {"joystick2rec": joystick2_rec}
            res2 = await self.ocu.set_data(url2, json.dumps(p2))
        return res1, res2
