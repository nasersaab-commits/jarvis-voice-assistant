import os
import shutil
import sys
import urllib.request

import pytest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG = os.path.join(ROOT, "config.json")
sys.path.insert(0, ROOT)

# server.py reads config.json and fetches the weather at import time.
# Use the example config when there is no real one, and keep tests offline.
_created_config = False
if not os.path.exists(CONFIG):
    shutil.copy(os.path.join(ROOT, "config.example.json"), CONFIG)
    _created_config = True


def _no_network(*args, **kwargs):
    raise OSError("network disabled in tests")


urllib.request.urlopen = _no_network


def pytest_sessionfinish(session, exitstatus):
    if _created_config and os.path.exists(CONFIG):
        os.remove(CONFIG)
