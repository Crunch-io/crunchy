Decks
-----

Decks allow you to store `analyses <#analysis>`__ for future reference
or for export. Decks correspond to a single dataset, and they are
personal to each user unless they have been set as "public". Each deck
contains a list of slides, and each slide contains analyses.

Catalog
~~~~~~~

``/datasets/{id}/decks/``

GET
^^^

A GET request on the catalog endpoint will return all the decks
available for this dataset for the current user. This includes decks
created by the user, as well as public decks shared with all users of
the dataset.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/datasets/223fd4/decks/",
          "index": {
              "https://app.crunch.io/api/datasets/cc9161/decks/4fa25/": {
                "name": "my new deck",
                "creation_time": "1986-11-26T12:05:00",
                "id": "4fa25",
                "is_public": false,
                "owner_id": "https://app.crunch.io/api/users/abcd3/",
                "owner_name": "Real Person",
                "team": null
              },
              "https://app.crunch.io/api/datasets/cc9161/decks/2b53e/": {
                "name": "Default deck",
                "creation_time": "1987-10-15T11:45:00",
                "id": "2b53e",
                "is_public": true,
                "owner_id": "https://app.crunch.io/api/users/4cba5/",
                "owner_name": "Other Person",
                "team": "https://app.crunch.io/api/teams/58acf7/"
              }
          },
          "order": "https://app.crunch.io/api/datasets/223fd4/decks/order/"
      }


The decks catalog tuples contain the following keys:

=============== =========== ====================================================
Name            Type        Description
=============== =========== ====================================================
name            string      Human-friendly string identifier
--------------- ----------- ----------------------------------------------------
creation_time   timestamp   Time when this deck was created
--------------- ----------- ----------------------------------------------------
id              string      Global unique identifier for this deck
--------------- ----------- ----------------------------------------------------
is_public       boolean     Indicates whether this is a public deck or not
--------------- ----------- ----------------------------------------------------
owner_id        url         Points to the owner of this deck
--------------- ----------- ----------------------------------------------------
owner_name      string      Name of the owner of the deck (referred by
                            ``owner_id``)
--------------- ----------- ----------------------------------------------------
team            url         If the deck is shared through a team, it will point
                            to it. ``null`` by default
=============== =========== ====================================================

To determine if a deck belongs to the current user, check the
``owner_id`` attribute.

POST
^^^^

POST a shoji:entity to create a new deck for this dataset. The only
required body attribute is "name"; other attributes are optional.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "self": "https://app.crunch.io/api/datasets/223fd4/decks/",
          "body": {
              "name": "my new deck",
              "description": "This deck will contain analyses for a variable",
              "is_public": false,
              "team": "https://app.crunch.io/api/teams/58acf7/"
          }
      }

   --HTTP
   .. code:: http

      HTTP/1.1 201 Created
      Location: https://app.crunch.io/api/datasets/223fd4/decks/2b3c5e/


The ``shoji:entity`` POSTed accepts the following keys

+---------------+-----------+------------+
| Name          | Type      | required   |
+===============+===========+============+
| name          | string    | Yes        |
+---------------+-----------+------------+
| description   | string    | No         |
+---------------+-----------+------------+
| is_public     | boolean   | No         |
+---------------+-----------+------------+
| team          | url       | No         |
+---------------+-----------+------------+

PATCH
^^^^^

It is possible to bulk-edit many decks at once by PATCHing a
shoji:catalog to the decks' catalog.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "index": {
              "https://app.crunch.io/api/datasets/cc9161/decks/4fa25/": {
                "name": "Renamed deck",
                "is_public": true
              }
          },
          "order": "https://app.crunch.io/api/datasets/223fd4/decks/order/"
      }


The following attributes are editable via PATCHing this resource:

-  name
-  description
-  is\_public

For decks that the current user owns, "name", "description" and
"is\_public" are editable. Only the deck owner can edit the mentioned
attributes on a deck even if the deck is public. Other deck attributes
are not editable and will respond with 400 status if the request tries
to change them.

On success, the server will reply with a 204 response.

Entity
~~~~~~

``/datasets/{id}/decks/{id}/``

GET
^^^

GET a deck entity resource to return a shoji:entity with all of its
attributes:

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "self": "https://app.crunch.io/api/datasets/223fd4/decks/223fd4/",
          "body": {
              "name": "Presentation deck",
              "id": "223fd4",
              "creation_time": "1987-10-15T11:45:00",
              "description": "Explanation about the deck",
              "is_public": false,
              "owner_id": "https://app.crunch.io/api/users/abcd3/",
              "owner_name": "Real Person",
              "team": "https://app.crunch.io/api/teams/58acf7/"
          }
      }

=============== =========== ====================================================
Name            Type        Description
=============== =========== ====================================================
name            string      Human-friendly string identifier
--------------- ----------- ----------------------------------------------------
id              string      Global unique identifier for this deck
--------------- ----------- ----------------------------------------------------
creation_time   timestamp   Time when this deck was created
--------------- ----------- ----------------------------------------------------
description     string      Longer annotations for this deck
--------------- ----------- ----------------------------------------------------
is_public       boolean     Indicates whether this is a public deck or not
--------------- ----------- ----------------------------------------------------
owner_id        url         Points to the owner of this deck
--------------- ----------- ----------------------------------------------------
owner_name      string      Name of the owner of the deck (referred by
                            ``owner_id``)
--------------- ----------- ----------------------------------------------------
team            url         If the deck is shared through a team, it will point
                            to it. ``null`` by default
=============== =========== ====================================================

PATCH
^^^^^

To edit a deck, PATCH it with a shoji:entity. The server will return a
204 response on success or 400 if the request is invalid.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "self": "https://app.crunch.io/api/datasets/223fd4/decks/223fd4/",
          "body": {
              "name": "Presentation deck",
              "id": "223fd4",
              "creation_time": "1987-10-15T11:45:00",
              "description": "Explanation about the deck",
              "team": "https://app.crunch.io/api/teams/58acf7/"
          },
          "catalogs": {
              "slides": "https://app.crunch.io/api/datasets/223fd4/decks/223fd4/slides/"
          },
          "urls": {
              "xlsx_export_url": "https://app.crunch.io/api/datasets/223fd4/decks/223fd4/export_xlsx/",
              "json_export_url": "https://app.crunch.io/api/datasets/223fd4/decks/223fd4/export_json/"
          }
      }

   --HTTP
   .. code:: http

      HTTP/1.1 204 No Content


For deck entities that the current user owns, "name", "description",
"teams" and "is\_public" are editable. Other deck attributes are not
editable.

DELETE
^^^^^^

To delete a deck, DELETE the deck's entity URL. On success, the server
returns a 204 response.


Deck Exports
~~~~~~~~~~~~~~~

xlsx
^^^^^^

A successful POST request to `/datasets/{dataset_id}/decks/{deck_id}/export/` will generate a download
location to which the exporter will write this file when it is done computing
(it may take some time for large datasets). The server will return a 202 response indicating that the export job started with
a Location header indicating where the final exported file will be available. The response's body will contain the URL for the progress URL where to query
the state of the export job. Clients should note the download URL,
monitor progress, and when complete, GET the download location. See [Progress](#progress) for details.
If no header is provided, this endpoint will produce an xlsx file.

Requesting the same job, if still in progress, will return the same 202 response
indicating the original progress to check. If the export is finished, the server
will 302 redirect to the destination for download.

If there have been changes on the dataset attributes, a new tab book will be
generated regardless of the status of any other pending exports.

Note: You must provide an "Accept: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" header to
create an downloadable excel document.

json
^^^^^^

This provides a json output for the analysis for each slide in the deck.
Note that you _must_ provide an "Accepts: application/json" header for this endpoint to work properly.

.. language_specific::
   --JSON
   .. code:: json

      {u'dataset': {u'name': u'New dataset', u'notes': u''},
          u'slides': [{u'cube': {u'query': {u'dimensions': [{u'args': [{u'variable': u'000001'}],
                                                       u'function': u'bin'},
                                                      {u'variable': u'000000'}],
                                      u'measures': {u'count': {u'args': [],
                                                               u'function': u'cube_count'}},
                                      u'weight': None},
                           u'query_environment': {u'filter': []},
                           u'result': {u'counts': [1, 3, 0, 0, 1, 0, 1, 1],
                                       u'dimensions': [{u'derived': True,
                                                        u'references': {u'alias': u'Age',
                                                                        u'description': None,
                                                                        u'name': u'Age'},
                                                        u'type': {u'class': u'enum',
                                                                  u'elements': [{u'id': 1,
                                                                                 u'missing': False,
                                                                                 u'value': [10.0,
                                                                                            20.0]},
                                                                                {u'id': 2,
                                                                                 u'missing': False,
                                                                                 u'value': [20.0,
                                                                                            30.0]},
                                                                                {u'id': 3,
                                                                                 u'missing': False,
                                                                                 u'value': [30.0,
                                                                                            40.0]},
                                                                                {u'id': 4,
                                                                                 u'missing': False,
                                                                                 u'value': [40.0,
                                                                                            50.0]}],
                                                                  u'subtype': {u'class': u'numeric',
                                                                               u'missing_reasons': {u'No Data': -1},
                                                                               u'missing_rules': {}}}},
                                                       {u'derived': False,
                                                        u'references': {u'alias': u'Gender',
                                                                        u'description': None,
                                                                        u'name': u'Gender'},
                                                        u'type': {u'categories': [{u'id': 2,
                                                                                   u'missing': False,
                                                                                   u'name': u'F',
                                                                                   u'numeric_value': None},
                                                                                  {u'id': 1,
                                                                                   u'missing': False,
                                                                                   u'name': u'M',
                                                                                   u'numeric_value': None}],
                                                                  u'class': u'categorical',
                                                                  u'ordinal': False}}],
                                       u'element': u'crunch:cube',
                                       u'measures': {u'count': {u'data': [1,
                                                                          3,
                                                                          0,
                                                                          0,
                                                                          1,
                                                                          0,
                                                                          1,
                                                                          1],
                                                                u'metadata': {u'derived': True,
                                                                              u'references': {},
                                                                              u'type': {u'class': u'numeric',
                                                                                        u'integer': True,
                                                                                        u'missing_reasons': {u'No Data': -1},
                                                                                        u'missing_rules': {}}},
                                                                u'n_missing': 0}},
                                       u'missing': 0,
                                       u'n': 7}},
                 u'meta': {u'display_settings': {u'decimalPlaces': {u'value': 2}},
                           u'filters': [],
                           u'name': u'Slide #1 ',
                           u'subtitle': u'',
                           u'table_title': u'',
                           u'title': u'Slide #1',
                           u'weight': None}}]}


Note that the export_xlsx endpoint is deprecated, no longer supported in favor of /export and will be removed shortly.

Order
~~~~~

``/datasets/{id}/decks/order/``

The deck order resource allows the user to arrange how API clients, such
as the web application, will present the deck catalog. The deck order
contains all decks that are visible to the current user, both personal
and public. Unlike many other ``shoji:order`` resources, this order does
not allow grouping or nesting: it will always be a flat list of slide
URLs.

GET
^^^

Returns a `Shoji Order <#shoji-order>`__ response.

.. language_specific::
   --JSON
   .. code:: json

      {
        "element": "shoji:order",
        "self": "https://app.crunch.io/api/datasets/223fd4/decks/order/",
        "graph": [
          "https://app.crunch.io/api/datasets/223fd4/decks/1/",
          "https://app.crunch.io/api/datasets/223fd4/decks/2/",
          "https://app.crunch.io/api/datasets/223fd4/decks/3/"
        ]
      }


PATCH
^^^^^

PATCH the order resource to change the order of the decks. A 204
response indicates success.

If the PATCH payload contains only a subset of available decks, those
decks not referenced will be appended at the bottom of the top level
graph in arbitrary order.

.. language_specific::
   --JSON
   .. code:: json

      {
        "element": "shoji:order",
        "self": "https://app.crunch.io/api/datasets/223fd4/decks/order/",
        "graph": [
          "https://app.crunch.io/api/datasets/223fd4/decks/1/",
          "https://app.crunch.io/api/datasets/223fd4/decks/3/"
        ]
      }


Including invalid URLs, such as URLs of decks that are not present in
the catalog, will return a 400 response from the server.

The deck order should always be a flat list of URLs. Nesting or grouping
is not supported by the web application. Server will return a 400
response if the order supplied in the PATCH request has nesting.

Slides
------

Each deck contains a catalog of slides into which analyses are saved.

Catalog
~~~~~~~

``/datasets/{id}/decks/{deck_id}/slides/``

GET
^^^

Returns a ``shoji:catalog`` with the slides for this deck.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/datasets/123/decks/123/slides/",
          "orders": {
              "flat": "https://app.crunch.io/api/datasets/123/decks/123/slides/flat/"
          },
          "specification": "https://app.crunch.io/api/specifications/slides/",
          "description": "A catalog of the Slides in this Deck",
          "index": {
              "https://app.crunch.io/api/datasets/123/decks/123/slides/123/": {
                  "analysis_url": "https://app.crunch.io/api/datasets/123/decks/123/slides/123/analyses/123/",
                  "subtitle": "z",
                  "display": {
                      "value": "table"
                  },
                  "title": "slide 1"
              },
              "https://app.crunch.io/api/datasets/123/decks/123/slides/456/": {
                  "analysis_url": "https://app.crunch.io/api/datasets/123/decks/123/slides/456/",
                  "subtitle": "",
                  "display": {
                      "value": "table"
                  },
                  "title": "slide 2"
              }
          }
      }


Each tuple on the slides catalog contains the following keys:

=============== ======= =======================================================
Name            Type    Description
=============== ======= =======================================================
analysis_url    url     Points to the first (and typically only) analysis
                        contained on this slide
--------------- ------- -------------------------------------------------------
title           string  Optional title for the slide
--------------- ------- -------------------------------------------------------
subtitle        string  Optional subtitle for the slide
--------------- ------- -------------------------------------------------------
display         object  Stores settings used to load the analysis
=============== ======= =======================================================

POST
^^^^

To create a new slide, POST a slide body to the slides catalog. It is
necessary to include at least one analysis on the new slide.

The body should contain an ``analyses`` attribute that contains an array
with one or many analyses bodies as described in the
`below <#analyses>`__ section, should be wrapped as a shoji:entity.

On success, the server returns a 201 response with a Location header
containing the URL of the newly created slide entity with its first
analysis.

.. language_specific::
   --JSON
   .. code:: json

      {
        "title": "New slide",
        "subtitle": "Variable A and B",
        "analyses": [
          {
            "query": {},
            "query_environment": {},
            "display_settings": {}
          },
          {
            "query": {},
            "query_environment": {},
            "display_settings": {}
          }
        ]
      }


On each analysis, only a ``query`` field is required to create a new
slide; other attributes are optional.

Slide attributes:

+------------+----------+-----------------------------------+
| Name       | Type     | Description                       |
+============+==========+===================================+
| title      | string   | Optional title for the slide      |
+------------+----------+-----------------------------------+
| subtitle   | string   | Optional subtitle for the slide   |
+------------+----------+-----------------------------------+

Analysis attributes:

=================== ======= ===================================================
Name                Type    Description
=================== ======= ===================================================
query               object  Contains a valid analysis query, required
------------------- ------- ---------------------------------------------------
subtitle            string  Optional subtitle for the slide
------------------- ------- ---------------------------------------------------
display_settings    object  Contains a set of attributes to be interpreted
                            by the client to render and export the analysis
------------------- ------- ---------------------------------------------------
query_environment   object  Contains the ``weight`` and ``filter`` applied
                            during the analysis, they will be applied upon
                            future evaluation/render/export
=================== ======= ===================================================

Old format
''''''''''

It is possible to create slides with one single initial analysis by
POSTing an analysis body directly to the slides catalog. It will create
a slide automatically with the new analysis on it:

.. language_specific::
   --JSON
   .. code:: json

      {
        "title": "New slide",
        "subtitle": "Variable A and B",
        "query": {},
        "query_environment": {},
        "display_settings": {}
      }


PATCH
^^^^^

It is possible to bulk-edit several slides at once by PATCHing a
shoji:catalog to this endpoint.

The only editable attributes with this method are:

-  title
-  subtitle

Other attributes should be considered read-only.

Submitting invalid attributes or references to other slides results in a
400 error response.

To edit the first or any of the slide's analyses query attributes it is
necessary to PATCH the individual analysis entity.

Entity
~~~~~~

``/datasets/223fd4/decks/slides/a126ce/``

Each slide in the Slide Catalog contains reference to its first
analysis.

GET
^^^

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "self": "/api/datasets/123/decks/123/slides/123/",
          "catalogs": {
              "analyses": "/api/datasets/123/decks/123/slides/123/analyses/"
          },
          "description": "Returns the detail information for a given slide",
          "body": {
              "deck_id": "123",
              "subtitle": "z",
              "title": "slide 1",
              "analysis_url": "/api/datasets/123/decks/123/slides/123/analyses/123/",
              "display": {
                  "value": "table"
              },
              "id": "123"
          }
      }


DELETE
^^^^^^

Perform a DELETE request on the Slide entity resource to delete the
slide and its analyses.

PATCH
^^^^^

It is possible to edit a slide entity by PATCHing with a shoji:entity.

The editable attributes are:

-  title
-  subtitle

The other attributes are considered read-only.

Order
~~~~~

``/datasets/223fd4/decks/slides/flat/``

The owner of the deck can specify the order of its slides. As with deck
order, the slide order must be a flat list of slide URLs.

GET
^^^

Returns the list of all the slides in the deck.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:order",
          "self": "/api/datasets/123/decks/123/slides/flat/",
          "description": "Order of the slides on this deck",
          "graph": [
              "/api/datasets/123/decks/123/slides/123/",
              "/api/datasets/123/decks/123/slides/456/"
          ]
      }


PATCH
^^^^^

To make changes to the order, a client should PATCH the full
``shoji:order`` resource to the endpoint with the new order on its
``graph`` attribute.

Any slide not mentioned on the payload will be added at the end of the
graph in arbitrary order.

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:order",
          "self": "/api/datasets/123/decks/123/slides/flat/",
          "description": "Order of the slides on this deck",
          "graph": [
              "/api/datasets/123/decks/123/slides/123/",
              "/api/datasets/123/decks/123/slides/456/"
          ]
      }


This is a flat order: grouping or nesting is not allowed. PATCHing with
a nested order will generate a 400 response.

Analysis
--------

Each slide contains one or more analyses. An analysis -- a table or
graph with some specific combination of variables defining measures,
rows, columns, and tabs; settings such as percentage direction and
decimal places -- can be saved to a *deck*, which can then be exported,
or the analysis can be reloaded in whole in the application or even
exported as a standalone embeddable result.

Catalog
~~~~~~~

::

    /api/datasets/123/decks/123/slides/123/analyses/

POST
^^^^

To create multiple analyses on a slide, clients should POST analyses to
the slide's analyses catalog.

.. language_specific::
   --JSON
   .. code:: json

      {
          "query": {
              "dimensions" : [],
              "measures": {}
          },
          "query_environment": {
              "filter": [
                  {"filter": "<url>"},
                  {"function": "expression", "args": [], "name": "(Optional)"}
              ],
              "weight": "url"
          },
          "display_settings": {
              "decimalPlaces": {
                  "value": 0
              },
              "percentageDirection": {
                  "value": "colPct"
              },
              "vizType": {
                  "value": "table"
              },
              "countsOrPercents": {
                  "value": "percent"
              },
              "uiView": {
                  "value": "expanded"
              }
          }
      }


The server will return a 201 response with the new slide created. In
case of invalid analysis attributes, a 400 response will be returned
indicating the problems.

PATCH
^^^^^

It is possible to delete many analyses at once from the catalog sending
``null`` as their tuple. It is not possible to delete all the analysis
from a slide. For that it is necessary to delete the slide itself.

.. language_specific::
   --JSON
   .. code:: json

      {
          "/api/datasets/123/decks/123/slides/123/analyses/1/": null,
          "/api/datasets/123/decks/123/slides/123/analyses/2/": {}
      }


A 204 response will be returned on success.

Order
~~~~~

As analyses get added to a slide, they will be stored on a
``shoji:order`` resource.

Like other order resources, it will expose a ``graph`` attribute that
contains the list of created analyses having new ones added at the end.

If an incomplete set of analyses is sent to the graph, the missing
analyses will be added in arbitrary order.

This is a flat order and does not allow nesting.

Entity
~~~~~~

An analysis is defined by a *query*, *query environment*, and *display
settings*. To save an analysis, ``POST`` these to a deck as a new slide.

.. raw:: html

   <aside class="notice">

Analysis queries are described in detail in the `feature
guide <#multidimensional-analysis>`__. `Filters <#filters>`__ may
contain a mix of stored filters or expressions. Expressions may contain
an optional ``name`` which may be used to label results.

.. raw:: html

   </aside>

Display settings can be anything a client may need to reproduce the view
of the data returned from the query. The settings the Crunch web client
uses are shown here, but other clients are free to store other
attributes as they see fit. Display settings should be objects with a
``value`` member.

.. language_specific::
   --JSON
   .. code:: json

      {
          "query": {
              "dimensions" : [],
              "measures": {}
          },
          "query_environment": {
              "filter": [
                  {"filter": "<url>"},
                  {"function": "expression", "args": [], "name": "(Optional)"}
              ],
              "weight": "url"
          },
          "display_settings": {
              "decimalPlaces": {
                  "value": 0
              },
              "percentageDirection": {
                  "value": "colPct"
              },
              "vizType": {
                  "value": "table"
              },
              "countsOrPercents": {
                  "value": "percent"
              },
              "uiView": {
                  "value": "expanded"
              }
          }
      }


=================== ===========================================================
Name                Description
=================== ===========================================================
query               Includes the query body for this analysis
------------------- -----------------------------------------------------------
query_environment   An object with a ``weight`` and ``filters`` to be used
                    for rendering/evaluating this analysis
------------------- -----------------------------------------------------------
display_settings    An object containing client-specific instructions on how
                    to recreate the analysis
=================== ===========================================================

PATCH
^^^^^

To edit an analysis, PATCH its URL with a shoji:entity.

The editable attributes are:

-  query
-  query\_environment
-  display\_settings

Providing invalid values for those attributes or extra attributes will
be rejected with a 400 response from the server.

DELETE
^^^^^^

It is possible to delete analyses from a slide as long as there is
always one analysis left.

Attempting to delete the last analysis of a slide will cause a 409
response from the server indicating the problem.
