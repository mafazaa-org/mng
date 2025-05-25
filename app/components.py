from os.path import join
from pathlib import Path
from  element import Element
from constants import PYTHON_APP_DATA_HOME_DIR

class Components:
    
    COMMON_TEMPLATE = "common.json"
    
    def __init__(self, object_types: list[tuple]):
        self._types = [{"path": _type[0], "put": _type[1], "delete": _type[2]} for _type in object_types]
    
    def put_items(self):
         for _type in self._types:
            type_dir = join(PYTHON_APP_DATA_HOME_DIR, _type["path"])
            files = list(Path(type_dir).rglob("*.json"))
            print("files:", [x.name for x in files])
            for file in files:
                if file.name == self.COMMON_TEMPLATE:
                    continue
                element = Element(file, _type["put"],_type["delete"], type_dir)
                element.load()
                print(f"found {element.j['name']} in {file.name}")
                element.delete()
                element.put()
    
    