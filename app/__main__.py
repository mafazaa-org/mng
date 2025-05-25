from components import Components
from elasticsearch import Elasticsearch
from constants import PYTHON_APP_USER, PYTHON_APP_PASSWORD , PYTHON_APP_ELASTICSEARCH_ENDPOINT, PYTHON_APP_CACERTS


def main():
    client = Elasticsearch(PYTHON_APP_ELASTICSEARCH_ENDPOINT, 
                        basic_auth=(PYTHON_APP_USER, PYTHON_APP_PASSWORD),
                        ca_certs=PYTHON_APP_CACERTS)

    ELEMENTS = [
            ("i_templates", client.indices.put_index_template, client.indices.delete_index_template),
            ("policies", client.ilm.put_lifecycle, client.ilm.delete_lifecycle)
        ]

    Components(ELEMENTS).put_items()


if __name__ == "__main__":
    main()