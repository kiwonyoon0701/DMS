```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "1",
            "rule-name": "1",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "OSHOP"
            },
            "rule-action": "rename",
            "value": "OSHOP",
            "old-value": null
        },
        {
            "rule-type": "selection",
            "rule-id": "2",
            "rule-name": "2",
            "object-locator": {
                "schema-name": "OSHOP",
                "table-name": "EMP"
            },
            "rule-action": "include",
            "filters": [
                {
                    "filter-type": "source",
                    "column-name": "ORDER_ID",
                    "filter-conditions": [
                        {
                            "filter-operator": "between",
                            "start-value": "7499",
                            "end-value": "7900"
                        }
                    ]
                }
            ]
        }
    ]
}
```
