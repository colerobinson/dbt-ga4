{{
    config(materialized = "view")
}}

{% set property_ids = var('property_ids') %}
{% set source_project = var('source_project') %}

{% if property_ids | length > 1 %}
    {% set queries = [] %}
    {% for property_id in property_ids %}
        {% set query = "SELECT * FROM " ~ '`' ~ source_project ~ '.analytics_' ~ property_id ~ '.events_*' ~ "`" %}
        {% do queries.append(query) %}
    {% endfor %}
    
    SELECT * FROM (
        {{ queries | join(' UNION ALL ') }}
    )
{% else %}
    SELECT * FROM {{ source_project }}.analytics_{{ property_ids[0] }}.events_*
{% endif %}

