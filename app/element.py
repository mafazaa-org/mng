from os.path import join
from copy import deepcopy
from json import load, dumps
from pathlib import Path
from elasticsearch import NotFoundError


class Element:
    
    COMMON_FILE = "common.json"
    
    def __init__(self, path, put_func, delete_func, home_dir):
        self.path: Path = path
        self.put_func = put_func
        self.home_dir = home_dir
        self.delete_func = delete_func
    
    def load(self):
        files = [
            join(self.home_dir, self.COMMON_FILE),
            join(self.path.absolute().parent, self.COMMON_FILE),
            self.path.absolute()
            ]
        
        self.j = {}
        
        for file in files:
            try:
                with open(file) as file:
                    j = load(fp=file)
                    self.j = self.merge(self.j, j)
            except FileNotFoundError:
                continue
        
    def put(self):
        # print(dumps(self.j, indent=4))
        try:
            self.put_func(name=self.j["name"], body=self.j["body"])
        except BaseException as e:
            print(e)

    def delete(self):
        try:
            self.delete_func(name=self.j["name"])
        except NotFoundError:
            pass
        except BaseException as e:
            print(e)
    
    
    def merge(self, first, second):
        """Recursively merge two dictionaries, with second taking precedence on conflicts."""
        merged = deepcopy(first)
        for key, value in second.items():
            if key in merged and isinstance(merged[key], dict) and isinstance(value, dict):
                merged[key] = self.merge(merged[key], value)
            else:
                merged[key] = value
        
        return merged