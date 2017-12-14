Search
------

You can perform a cross-dataset search of dataset metadata (including
variables) via the search endpoint. This search will return associated
variables and dataset metadata. A query string, along with filtering
properties can be provided to the search endpoint in order to refine the
results. The query string provided is only used in plain-text format,
any non-text or numeric characters are ignored at this time.

Results are limited only to those datasets the user has access to.
Offset and limit parameters are also provided in order to provide
performance-chunking options. The limit and offset are returned in
relationship to datasets related to the search. You have reached the
limit of available search entries when there are no longer records in
the dataset field.

Here are the parameters that can be passed to the search endpoint.

+--------------------------------------+------------+--------------------------------------+
| Parameter                            | Type       | Description                          |
+======================================+============+======================================+
| q                                    | String     | query string                         |
+--------------------------------------+------------+--------------------------------------+
| f                                    | Json       | used to filter the output of the     |
|                                      | Object     | search (see below)                   |
+--------------------------------------+------------+--------------------------------------+
| limit                                | Integer    | limit the number of dataset results  |
|                                      |            | returned by the api to less than     |
|                                      |            | this amount (default: 10)            |
+--------------------------------------+------------+--------------------------------------+
| offset                               | Integer    | offset into the search index to      |
|                                      |            | start gathering results from         |
|                                      |            | pre-filter                           |
+--------------------------------------+------------+--------------------------------------+
| max_variables_per_dataset            | Integer    | limit the number of variables that   |
|                                      |            | match to this number (default: 100,  |
|                                      |            | max: 100) (deprecated, use           |
|                                      |            | variable\_limit)                     |
+--------------------------------------+------------+--------------------------------------+
| embedded_variables                   | Boolean    | embed the results within the dataset |
|                                      |            | results (this will become the        |
|                                      |            | default in the future)               |
+--------------------------------------+------------+--------------------------------------+
| projection                           | Json       | used to limit the fields that should |
|                                      | Object     | be returned in the search results.   |
|                                      |            | ID is always provided.               |
+--------------------------------------+------------+--------------------------------------+
| scope                                | Json       | used to limit the fields that the    |
|                                      | Object     | search should look at.               |
+--------------------------------------+------------+--------------------------------------+
| grouping                             | String     | One of ``datasets`` or               |
|                                      |            | ``variables``. Tells if search       |
|                                      |            | results should be grouped by         |
|                                      |            | datasets or variables.               |
+--------------------------------------+------------+--------------------------------------+
| variable_limit                       | Integer    | Limit the number of variables        |
|                                      |            | returned per dataset to this value,  |
|                                      |            | (default: 100, max: 100)             |
+--------------------------------------+------------+--------------------------------------+
| variable_offset                      | Integer    | Offset into the variables returned   |
|                                      |            | per dataset, default 0               |
+--------------------------------------+------------+--------------------------------------+
| max_subfield_entries_per_variable    | Integer    | Number of items in the subfields of  |
|                                      |            | a variable (such as categories or    |
|                                      |            | subvariables), (default: 10, max:    |
|                                      |            | 100)                                 |
+--------------------------------------+------------+--------------------------------------+

.. raw:: html

   <aside class="notice">

By default there are only 10 datasets returned. Inside the response you
will find a ``totals.datasets`` that indicates the total number of
datasets that matched the search. Use this to set offset and limit to
appropriately limit and compile your search results. Note that
``totals.variables`` should not be used for pagination.

.. raw:: html

   </aside>

Providing a Projection:

``projection`` argument must be a JSON array containing the name of the
fields that should be projected for datasets and variables. The fields
are specified with the namespace they refer to, like
``"variables.fieldname"`` and ``"datasets.fieldname"``. The namespace is
the same as the key where the relevant search results are returned.
Performing a search with an invalid field will pinpoint the invalid one
and provide the list of accepted values.

Providing a Scope:

``scope`` parameter must be a JSON array containing the name of the
fields that should be used to resolve the query. Much like
``projection`` paramter this one accepts a list of fields with their
namespace (``datasets`` or ``variables``). T he provided query will be
looked up only in the specified fields if a ``scope`` is provided. A
special field name ``*`` is accepted to specify that default fields
should be looked for a specific namespace. A scope like
``datasets.name, variables.*`` will search the query in the default
variable fields and in dataset name.

Grouping:

Default grouping is ``datasets`` which will enable searching in dataset
data and its variables. The returned entries in "datasets" are datasets
that match the query or contain a variable that matches it. Search
results are limited to 1000 variables per dataset when grouping per
dataset.

Switching to ``variables`` grouping makes the search only look in
variables. Note that a "datasets" field is still returned, the entries
there are the datasets the matching variables are part of, *not*
datasets that match the query. This is done to allow providing dataset
details for a variable without the need for a second call to fetch the
dataset info.

Allowable filter parameters:

+--------------------+-----------------+------------------------------------------+
| Parameter          | Type            | Description                              |
+====================+=================+==========================================+
| dataset\_ids       | array of        | limit results to particular dataset\_ids |
|                    | strings         | or urls (user must have read access to   |
|                    |                 | that dataset)                            |
+--------------------+-----------------+------------------------------------------+
| team               | string          | url or id of the team to limit results   |
|                    |                 | (user must have read access to the team) |
+--------------------+-----------------+------------------------------------------+
| project            | string          | url or id of the project to limit        |
|                    |                 | results (user must have access to the    |
|                    |                 | project)                                 |
+--------------------+-----------------+------------------------------------------+
| organization       | string          | if you are the owner for a given         |
|                    |                 | organization, you can filter all of the  |
|                    |                 | search results pertaining to the         |
|                    |                 | datasets in your organization.           |
+--------------------+-----------------+------------------------------------------+
| user               | string          | url or id of the user that has read      |
|                    |                 | access to the datasets to limit results  |
|                    |                 | (user must match with the provided one)  |
+--------------------+-----------------+------------------------------------------+
| owner              | string          | url or id of the dataset owner to limit  |
|                    |                 | results                                  |
+--------------------+-----------------+------------------------------------------+
| label              | string          | The dataset must be in a folder or       |
|                    |                 | subfolder with the given name.           |
+--------------------+-----------------+------------------------------------------+
| start\_date        | array of        | array of ``[begin, end]`` range of       |
|                    | strings         | values in ISO8601 format. Provide same   |
|                    |                 | for exact matching.                      |
+--------------------+-----------------+------------------------------------------+
| end\_date          | array of        | array of ``[begin, end]`` range of       |
|                    | strings         | values in ISO8601 format. Provide same   |
|                    |                 | for exact matching.                      |
+--------------------+-----------------+------------------------------------------+
| modification\_time | array of        | array of ``[begin, end]`` range of       |
|                    | strings         | values in ISO8601 format. Provide same   |
|                    |                 | for exact matching.                      |
+--------------------+-----------------+------------------------------------------+
| creation\_time     | array of        | array of ``[begin, end]`` range of       |
|                    | strings         | values in ISO8601 format. Provide same   |
|                    |                 | for exact matching.                      |
+--------------------+-----------------+------------------------------------------+

.. note::

    The query string can only be alpha-numeric characters (including
    underscores) logical operators are not allowed at this time.

Fields Searched
'''''''''''''''

Here is a list of the fields that are searched by the Crunch search
endpoint

+-------------------+------------+-----------------------------------------------------+
| Field             | Type       | Description                                         |
+===================+============+=====================================================+
| category\_names   | List of    | Category names (associated with categorical         |
|                   | Strings    | variables)                                          |
+-------------------+------------+-----------------------------------------------------+
| dataset\_id       | String     | ID of the dataset                                   |
|                   |            |                                                     |
+-------------------+------------+-----------------------------------------------------+
| description       | String     | description of the variable                         |
|                   |            |                                                     |
+-------------------+------------+-----------------------------------------------------+
| id                | String     | ID of the variable                                  |
+-------------------+------------+-----------------------------------------------------+
| name              | String     | name of the variable                                |
+-------------------+------------+-----------------------------------------------------+
| owner             | String     | owner's ID of the variable                          |
+-------------------+------------+-----------------------------------------------------+
| subvar\_names     | List of    | Names of the subvariables associated with the       |
|                   | Strings    | variable                                            |
+-------------------+------------+-----------------------------------------------------+
| users             | List of    | User IDs having read-access to the variable         |
|                   | Strings    |                                                     |
+-------------------+------------+-----------------------------------------------------+
| group\_names      | List of    | group names (from the variable ordering) associated |
|                   | Strings    | with the variable                                   |
+-------------------+------------+-----------------------------------------------------+
| dataset\_labels   | List of    | dataset\_labels associated with the user associated |
|                   | Objects    | with the variable                                   |
+-------------------+------------+-----------------------------------------------------+
| dataset\_name     | String     | dataset\_name associated with this variable         |
|                   |            |                                                     |
+-------------------+------------+-----------------------------------------------------+
| dataset\_owner    | String     | ID of the owner of the dataset associated with the  |
|                   |            | variable                                            |
+-------------------+------------+-----------------------------------------------------+
| dataset\_users    | List of    | User IDs having read-access to the dataset          |
|                   | Strings    | associated with the variable                        |
+-------------------+------------+-----------------------------------------------------+
| dataset\_teams    | List of    | Team IDs having read-access to the dataset          |
|                   | Strings    | associated with the variable                        |
+-------------------+------------+-----------------------------------------------------+
| dataset\_projects | List of    | Project IDs having read-access to the dataset       |
|                   | Strings    | associated with the variable                        |
+-------------------+------------+-----------------------------------------------------+

Grouping by datasets:

.. language_specific::
   --HTTP
   .. code:: http

      GET /search/?q={query}&f={filter}&limit={limit}&offset={offset}&projection={projection}&grouping=datasets  HTTP/1.1

      {
         "element": "shoji:view",
          "self": "https://app.crunch.io/api/search/?q=blue&grouping=datasets",
          "description": "Returns a view with relevant search information",
          "value": {
              "groups": [
                  {
                      "group": "Search Results",
                      "datasets": {
                          "https://app.crunch.io/api/datasets/173b4eec13f542588b9b0a9cbcd764c9/": {
                              "labels": [],
                              "name": "econ_few_columns_0",
                              "description": ""
                          },
                          "https://app.crunch.io/api/datasets/4473ab4ee84b40b2a7cd5cab4548d584/": {
                              "labels": [],
                              "name": "simple_alltypes",
                              "description": ""
                          }
                      },
                      "variables": {
                          "https://app.crunch.io/api/datasets/4473ab4ee84b40b2a7cd5cab4548d584/variables/000000/": {
                              "dataset_labels": [],
                              "users": [
                                  "00002"
                              ],
                              "alias": "x",
                              "dataset_end_date": null,
                              "category_names": [
                                  "red",
                                  "green",
                                  "blue",
                                  "4",
                                  "8",
                                  "9",
                                  "No Data"
                              ],
                              "dataset_start_date": null,
                              "name": "x",
                              "dataset_description": "",
                              "dataset_archived": false,
                              "group_names": null,
                              "dataset": "https://app.crunch.io/api/datasets/4473ab4ee84b40b2a7cd5cab4548d584/",
                              "dataset_id": "bb987b45a5b04caba10dec4dad7b37a8",
                              "dataset_created_time": null,
                              "subvar_names": [],
                              "dataset_name": "export test 94",
                              "description": "Numeric variable with value labels"
                          }
                      },
                      "variable_count": 14,
                      "totals": {
                          "variables": 4,
                          "datasets": 2
                      }
                  }
              ]
          }
      }

   --Python
   .. code:: python

       import pycrunch
       site = pycrunch.connect("me@mycompany.com", "yourpassword", "https://app.crunch.io/api/")
       results = site.follow('search', 'q=findme&embedded_variables=True').value
       datasets_found = results['groups'][0]['datasets']
       variables_by_dataset = {
           k, v.get('variables', []) for k, v in datasets_found.iteritems()
       }


Search results are limited to 1000 variables per dataset.

Grouping by variables:

.. language_specific::
   --HTTP
   .. code:: http

      GET /search/?q={query}&f={filter}&limit={limit}&offset={offset}&grouping=variables  HTTP/1.1


