.. _endpoint-folders:

Variable Folders
----------------

In order to organize a large number of variables in a dataset, Crunch
provides a hierarchical structure to group variables called "Folders".

Much like the variable hierarchical order, folders allow you to have
nested folders containing dataset variables. Unlike the hierarchical
order, a variable can only exist in one folder at the time.

Root
-----

``/datasets/{id}/folders/``

Returns a Shoji catalog containing the root folder of the hierarchy.

When a dataset is created without an order specified, there will not
yet be any folders associated with it, so the root folder will only
contain a flat list of all existing dataset variables.

As variables get grouped into folders, the root folder will continue
showing any ungrouped variables in addition to the top-level folders.


Subfolder endpoint
------------------

``/datasets/{id}/folders/{folder_id}/``

All subfolder URLs follow straight from the root folder URL regardless
of their nested location in the variable folders tree.

Folder payload
--------------

All folders types return a similar Shoji catalog with the following members:

======== ======= ===============================================================
Member   Type    Description
======== ======= ===============================================================
size     int     Indicates the number of total variables stored under this
                 folder and its subfolders.
-------- ------- ---------------------------------------------------------------
body     object  Contains a `name` attribute, which is the folder's name.
                 The root folder has an empty string as name.
-------- ------- ---------------------------------------------------------------
index    object  Behaves like a standard Shoji catalog containing the children
                 of the folder keyed by URL. This catalog will contain a mixed
                 set of folder and variables URLs. Clients should differentiate
                 each of the objects by looking at the tuple's `type` attribute.
                 Folders will have type "folder" while variables will contain
                 their variables type.
-------- ------- ---------------------------------------------------------------
graph    list    A flat list containing the list of URLs of variables and
                 subfolders on the given folder.
======== ======= ===============================================================

JSON example:

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/datasets/5ee0a0/folders/",
          "size": 10000,
          "body": {
              "name": "Folder name"
          },
          "index": {
              "https://app.crunch.io/datasets/abcdef/variables/123/": {
                  "name": "Birth Year",
                  "derived": false,
                  "discarded": false,
                  "alias": "birthyear",
                  "type": "numeric",
                  "id": "123",
                  "notes": "",
                  "description": "In what year were you born?"
              },
              "https://app.crunch.io/datasets/abcdef/folders/qwe/": {
                  "type": "folder",
                  "name": "Subfolder name"
              },
              "https://app.crunch.io/datasets/abcdef/variables/456/": {
                  "subvariables_catalog": "../variables/456/subvariables/",
                  "name": "An Array",
                  "derived": true,
                  "discarded": false,
                  "alias": "arrayvar",
                  "subvariables": [
                      "../../variables/456/subvariables/439dcf/",
                      "../../variables/456/subvariables/1c99ea/"
                  ],
                  "notes": "All variable types can have notes",
                  "type": "categorical_array",
                  "id": "456",
                  "description": ""
              }
          },
          "graph": [
              "../variables/456/",
              "../variables/123/",
              "../folders/qwe/"
          ]
      }


Creating folders
----------------

To create a subfolder, clients must POST to the target folder (which will be the
parent of the new subfolder).

The payload must contain a `body` member which indicates only the name of
the subfolder. Note that subfolder names must be unique between them and
variables included.

Additionally an `index` member can be included that must contain URLs of the
variables that will be children of the new folder. The tuples associated with
each variable should be an empty object.

In case the variables mentioned belong in other folders, they will be moved
into this newly created one.

Additionally an optional `graph` member is allowed always that an `index`
member is included. The graph should contain all the items that the index
contains.


.. language_specific::
   --JSON
   .. code:: json

      {
         "entity": "shoji:catalog",
         "body": {
            "name": "New subfolder name"
         },
         "index": {
            "http://app.crunch.io/api/datasets/abc/variables/123/": {},
            "http://app.crunch.io/api/datasets/abc/variables/456/": {}
         },
         "graph": [
            "http://app.crunch.io/api/datasets/abc/variables/123/",
            "http://app.crunch.io/api/datasets/abc/variables/456/"
         ]
      }


Moving folders and variables
----------------------------

In order to move folders or variables from one location to another, their URL
must be included in the `index` catalog sent via a PATCH request to the
destination folder.

The new elements will be moved out of their existing parents into the new folder
location.

Inside a folder, subfolders and variables must be unique by name. Trying to
move a folder or a variable that conflicts with the existing children of it,
will return a 409 response from the server.

Reordering a folder's contents
------------------------------

To reorder the elements inside a folder, it's necessary to make a PATCH request
to the folder's endpoint containing the list with the elements from the index
in the desired order.

The list must be a flat list and all the elements must be URLs that currently
exist in the catalog's index. New elements cannot be included just by adding
them on the `graph`.


Deleting folders
----------------

Subfolders can be deleted by performing a DELETE request on their endpoints.
It will effectively move the folder to the trash folder.

When deleting a folder, all the children will also be moved to the trash
folder including the variables that were part of it.

Moving a folder to the trash does **not** delete variables nor their data,
but only makes them unavailable from the folder hierarchy.

Deleting a folder that is already in the trash **does** hard-delete that
folder, including all variables & related data contained in that folder.


Trash
-----

``/datasets/{id}/folders/trash/``

The trash folder is a special-purpose folder that lives outside the
regular variable folders tree.

You can use the trash folder to "soft-delete" variables and folders.

Subfolders and variables inside the trash folder are only visible to
dataset editors.

Performing a DELETE request to the trash endpoint will empty all items
from the trash, hard-deleting the folders, variables, and related data.

Items in the trash folder may also be automatically hard-deleted after
24-48 hours.

Hidden
------

``/datasets/{id}/folders/hidden/``

The hidden folder is a special-purpose folder that lives outside the
regular variable folders tree.

Variables and subfolders that should only be visible to dataset editors
should be placed in the hidden folder.

Hidden folder membership will eventually replace the deprecated
``discarded`` attribute on a variable.