Variable folders
----------------

Variable folders provide a new and faster way to organize

Rationale
~~~~~~~~~

Datasets with several thousands of variables need to be organized to make it
possible to make sense of their groups of variables.

Historically the variables' order has provided a way to keep a parallel list
of the variable URLs using a `shoji:order` to indicate clients their grouping.

The problem arises when there are thousands of variables to include both in
the variables' order and the variables' catalog, which always have to include
the full list of all available variables. Making these two responses not only
slow to generate and download, but also to process such large JSON payloads.

To get around this problem, Folders were introduced as a new way to orgainze
and list variables under a single protocol without needing to keep a separate
catalog and order for the variables.

Benefits
~~~~~~~~

With this new Folders catalogs, clients can start by fetching the root folder
which should contain the top level organization with a graspable number of
variables and subfolders to display. Similarly, subfolders will list only its
contents. This makes for much faster rountrips given that the majority of cases
only a handful of variables is needed and not to have always the full list
and their information in memory.

Manipulating and reorganizing variables is also easier since it is not necessary
for clients to wrangle with the full order data structure when moving variables
between groups/folders. Since now moving variables and creating groups are all
direct API calls that don't require clients to keep full track of the state
of the orders tree.

Basic concepts
~~~~~~~~~~~~~~

There are a number of system folders that exist with every dataset created.
These system folders cannot be renamed, moved or deleted.

* **Root folder**: The root folder is the top level folder where all other subfolders will be created by dataset editors. All the variables and subfolders here will be public universal for all users with access to the dataset. It is only possible to place public varibles under this tree.
* **Hidden variables folder**: This folder is a parallel top level folder separate from the root folder, which allows dataset editors to hide variables out of the public Root folder. This tree structure is only accessible for dataset editors.
* **Variables can only be in one folder**: Variables can be in any of the top level system folders or in any subfolder of them at any given time, but they can never be in two folders at the same time.

Migrating to folders
~~~~~~~~~~~~~~~~~~~~

During the rolls out period, datasets will need to be activated to use folders
individually by changing its `variable_folders` setting to `true`.

.. language_specific::
   --HTTP
   .. code:: http

      PATCH /datasets/id/settings/
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "body": {"variable_folders": true"}
      }


On activation, the current structure under the hierarchical order will be
converted to folders under the Root Folder replicating the existing
organization.

From then on, the existing /datasets/:id/variables/hier/ endpoint will now
reflect the structure that gets set as Folders, the latter now being the source
of truth.


Enabled datasets will expose a `/folders/` path where that follows the
folders documentation :ref:`endpoint-folders`.


Compatibility with variables' order
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The new folders feature holds a few differences from the previous hierarchical
order capabilities. Most notable are:

* Variables must always be under any folder, the Root folder by default
* Variables must be under one folder only. The API allows moving between folders but there are no means to place a variable in two folders.
* Subvariables are not allowed anywhere in the folder structure.
* Hidden variables (variables with `discarded` attribute set to `true`) will always be under the Hidden variables folder. From now on the `discarded` attribute will be a reflection of whether or not a variable is present under the hidden folder.

PATCH requests to the hierarchical order will enforce the above rules.
