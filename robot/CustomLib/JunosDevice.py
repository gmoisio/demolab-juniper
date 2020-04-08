#!/usr/bin/env python3
from jnpr.junos import Device


class JunosDevice(object):

    def __init__(self):
        self.device = None

    def connect_device(self, host, port, user, password):
        self.device = Device(host, port=port, user=user, password=password)
        self.device.open()

    def close_device(self):
        self.device.close()

    def get_device_info(self):
        device_facts = dict(self.device.facts)
        return device_facts

    def get_device_os_version(self):
        facts = self.get_device_info()
        return facts["version"]
