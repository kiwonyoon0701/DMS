**MySQL5 - lowercase**

```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "1",
            "rule-name": "1",
            "rule-target": "table",
            "object-locator": {
                "schema-name": "SOE3",
                "table-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "SOE3"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "selection",
            "rule-id": "3",
            "rule-name": "3",
            "object-locator": {
                "schema-name": "SOE3",
                "table-name": "%"
            },
            "rule-action": "include",
            "filters": []
        }
    ]
}
```
