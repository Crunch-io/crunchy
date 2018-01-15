Variable Folders
----------------

In order to organize number of variables in datasets, Crunch provides a
hierarchical structure to group variables called "Folders".

Much like the variable hierarchical order, folders allow to have nested groups
containing more groups or dataset variables.

Unlike the variables' order, a variable can only exist in one folder at the time.

Root
-----

``/datasets/{id}/folders/``

Returns a Shoji catalog containing the root folder of the hierarchy.

When a dataset is created without any order specified, there will not be any
folder associated to any of its variables so the variable folders' root will
only contain a flat list of all the existing dataset variables.

As variables get grouped into folders the folders root will continue showing
the ungrouped variables and existing folders.


Subfolder endpoint
~~~~~~~~~~~~~~~~~~

``/datasets/{id}/folders/{folder_id}/``

All subfolders' URLs follow straight from the folders' root URL regardless
of their nested location in the folders' tree.

All subfolders' payload has the same shape as the root catalog.

Folder payload
--------------

All folders, trash and root return a similar Shoji catalog with the same shape
which includes the following members:

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

Additionally a `graph` member can be included that must contain URLs of the
varibles that will be children of the new folder. These variables cannot belong
to another folder (must be ungrouped under root) else the server will return
a 400 response.

To include variables that belong to other folder in the new folder they
should be moved into the new folder after the fact via PATCH.

.. language_specific::
   --JSON
   .. code:: json

      {
         "entity": "shoji:catalog",
         "body": {
            "name": "New subfolder name"
         },
         "graph": []
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
It will effectively move the folder (and all the branch) to the trash folder.

When deleting a folder, all the children will also be moved including the
variables that were part of it.

Deleting a folder does **not** delete variables nor their data, but only makes
them unavailable from the folder hierarchy.


Trash
-----

``/datasets/{id}/folders/trash/``

A special folder, the folders' trash exists to store folders after they get
deleted.


