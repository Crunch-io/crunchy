Feature Flags
-------------

Crunch uses feature flags to enable and disable system-wide features
under development.

GET
^^^

``GET /feature_flag/feature_flag_abc/``

Example response:

.. language_specific::
   --JSON
   .. code:: json

      {
          "description": "Indicates the status of a given feature",
          "element": "shoji:view",
          "self": "https://app.crunch.io//api/feature_flag/feature_flag_abc/",
          "value": {
              "active": false
          }
      }

