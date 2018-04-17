Teams
-----

Teams contain references to users and datasets. By sharing a dataset
with a team, you can grant access to a set of users at once, and by
adding a user to a team, you can grant them access to a set of datasets.

Catalog
~~~~~~~

``/teams/``

GET
^^^

.. language_specific::
   --HTTP
   .. code:: http

      GET /teams/ HTTP/1.1
      Host: app.crunch.io
      --------
      200 OK
      Content-Type: application/json


::

    // Example team catalog:

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/teams/",
          "description": "List of all the teams where the current user is member",
          "index": {
              "https://app.crunch.io/api/teams/d07edb/": {
                  "name": "The A-Team",
                  "permissions": {
                    "team_admin": true
                  }
              },
              "https://app.crunch.io/api/teams/67fe89/": {
                  "name": "Palo Alto Data Science",
                  "permissions": {
                    "team_admin": false
                  }
              }
          }
      }

   --R
   .. code:: r

      teams <- getTeams()
      names(teams)
      ## [1] "The A-Team" "Palo Alto Data Science"


POST
^^^^

To create a new team, POST a Shoji Entity with a team "name" in the
body. No other attributes are required, and you will be automatically
assigned as a "team\_admin".

.. language_specific::
   --HTTP
   .. code:: http

      POST /teams/ HTTP/1.1
      Host: app.crunch.io
      Content-Type: application/json
      ...
      {
          "element": "shoji:entity",
          "body": {
              "name": "My new team with ytpo"
          }
      }
      --------
      201 Created
      Location: /teams/03df2a/

   --R
   .. code:: r

      # Create a new team by assigning into the teams catalog
      teams[["My new team with ytpo"]] <- list()
      names(teams) # Let's see that it was created
      ## [1] "The A-Team" "Palo Alto Data Science"
      ## [3] "My new team with ytpo"

      # You can also assign members to the team when you create it,
      # even though the POST /teams/ API does not support it.
      teams[["New team with members"]] <- list(members="fake.user@example.com")


Entity
~~~~~~

``/teams/{team_id}/``

GET
^^^

.. language_specific::
   --HTTP
   .. code:: http

      GET /teams/d07edb/ HTTP/1.1
      Host: app.crunch.io
      --------
      200 OK
      Content-Type: application/json


::

    // Example team entity

.. language_specific::
   --JSON
   .. code:: json

      {
          "element": "shoji:entity",
          "self": "https://app.crunch.io/api/teams/d07edb/",
          "description": "Details for a specific team",
          "body": {
              "creator": "https://app.crunch.io/api/users/41c69d/",
              "id": "d07edb",
              "name": "The A-Team"
          },
          "catalogs": {
              "datasets": "https://app.crunch.io/api/teams/d07edb/datasets/",
              "members": "https://app.crunch.io/api/teams/d07edb/members/"
          }
      }

   --R
   .. code:: r

      # Access a team by name using $ or [[ from the team catalog
      a.team <- teams[["The A-Team"]]
      name(a.team)
      ## [1] "The A-Team"
      self(a.team)
      ## [1] "https://app.crunch.io/api/teams/d07edb/"


A GET request on a team entity URL returns the same "name", "id" and
"creator" attributes as shown in the team catalog, as well as references
to the "datasets" and "members" catalogs corresponding to the team.
Authorization is required: if the requesting user is not a member of the
team, a 404 response will result.

PATCH
^^^^^

Team names are editable by PATCHing the team entity. Authorization is
required: only team members with "team\_admin" permission may edit the
team's name; other team members will receive a 403 response on PATCH.

.. language_specific::
   --HTTP
   .. code:: http

      PATCH /teams/03df2a/ HTTP/1.1
      Host: app.crunch.io
      Content-Type: application/json
      {
          "element": "shoji:entity",
          "body": {
              "name": "My new team without typo"
          }
      }
      --------
      204 No Content

   --R
   .. code:: r

      name(teams[["My new team with ytpo"]]) <- "My new team without typo"
      names(teams) # Check that it was updated
      ## [1] "The A-Team" "Palo Alto Data Science"
      ## [3] "My new team without typo"


Team members catalog
~~~~~~~~~~~~~~~~~~~~

``/teams/{team_id}/members/``

The team members catalog is a Shoji Catalog similar in nature to the
`dataset permissions catalog <#permissions>`__. It collects references
to users and defines the authorizations they have with respect to the
team. All information about the member relationships is contained in the
catalog--there are no "member entities"--and all changes to team
membership, whether adding, modifying, or removing users, is done via
PATCH.

GET
^^^

.. language_specific::
   --HTTP
   .. code:: http

      GET /teams/d07edb/members/ HTTP/1.1
      Host: app.crunch.io
      --------
      200 OK
      Content-Type: application/json

   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/teams/d07edb/members/",
          "description": "Catalog of users that belong to this team",
          "index": {
              "https://app.crunch.io/api/users/47193a/": {
                  "name": "B. A. Baracus",
                  "permissions": {
                      "team_admin": false
                  }
              },
              "https://app.crunch.io/api/users/41c69d/": {
                  "name": "Hannibal",
                  "permissions": {
                      "team_admin": true
                  }
              }
          }
      }

   --R
   .. code:: r

      members(team)


Tuple values include:

=========== ======= =========================================================
Name        Type    Description
=========== ======= =========================================================
name        string  Display name of the user
----------- ------- ---------------------------------------------------------
permissions object  Attributes governing the user's authorization on the team
=========== ======= =========================================================

Supported ``permissions``, all boolean, include:

-  **team\_admin**: Allows add/remove and manage the members and
   permissions of a team as well modify and delete the team in question.
   Defaults as ``false``.

PATCH
^^^^^

Authorization is required: team members who do not have the
"team\_admin" permission and who attempt to PATCH the member catalog
will receive a 403 response. As with the team entity, non-members will
receive 404 on attempted PATCH.

PATCH a partial Shoji Catalog to add users to the team, to modify
permissions of members already on the team, and to remove team members.
The examples below illustrate each of those actions separately, but all
can be done together in a single PATCH request, in fact.

In the "index" attribute of the catalog, object keys must be either (a)
URLs of User entities or (b) email addresses. They can be mixed in a
single PATCH request. Using email address allows you to invite a user to
Crunch while adding them to the team if they do not yet have a Crunch
account, but it is also valid as a reference to Users that already
exist.

Add and modify members
''''''''''''''''''''''

.. language_specific::
   --HTTP
   .. code:: http

      PATCH /teams/d07edb/members/ HTTP/1.1
      Host: app.crunch.io
      Content-Type: application/json
      {
          "element": "shoji:catalog",
          "index": {
              "https://app.crunch.io/api/users/47193a/": {
                  "permissions": {
                      "team_admin": true
                  }
              },
              "https://app.crunch.io/api/users/e3211a/": {},
              "templeton.peck@army.gov": {
                  "permissions": {
                      "team_admin": true
                  }
              }
          },
          "send_notification": true,
          "url_base": "https://app.crunch.io/password/change/${token}/"
      }
      --------
      204 No Content


If the index object keys correspond to users that already appear in the
member catalog, their permissions will be updated with the corresponding
value. In this example, user ``47193a``, B. A. Baracus, has been given
the ``team_admin`` permission.

If the index object keys do not correspond to users already found in the
member catalog, the indicated users will be added to the team. And, if
the indicated user, as specified by email address, does not yet exist,
they will be invited to Crunch and added to the team. In this example,
we added existing user ``e3211a``, implicitly with ``team_admin`` set to
False, to the team, and we also added "templeton.peck@army.gov", who did
not previously have a Crunch account.

If "send\_notification" was included and true in the request,
new-to-Crunch users will receive a notification email informing them
that they have been invited to Crunch. New users, unless they have an
OAuth provider specified, will need to set a password, and the client
application should send a URL template that directs them to a place
where they can set that password. To do so, include a "url\_base"
attribute in the payload, a URL template with a ``${token}`` variable
into which the server will insert the password-setting token. For the
Crunch web application, this template is
``https://app.crunch.io/password/change/${token}/``.

A GET on the members catalog shows the updated catalog.

.. language_specific::
   --HTTP
   .. code:: http

      GET /teams/d07edb/members/ HTTP/1.1
      Host: app.crunch.io
      --------
      200 OK
      Content-Type: application/json

   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/teams/d07edb/members/",
          "description": "Catalog of users that belong to this team",
          "index": {
              "https://app.crunch.io/api/users/47193a/": {
                  "name": "B. A. Baracus",
                  "permissions": {
                      "team_admin": true
                  }
              },
              "https://app.crunch.io/api/users/41c69d/": {
                  "name": "Hannibal",
                  "permissions": {
                      "team_admin": true
                  }
              },
              "https://app.crunch.io/api/users/e3211a/": {
                  "name": "Howling Mad Murdock",
                  "permissions": {
                      "team_admin": false
                  }
              },
              "https://app.crunch.io/api/users/89eb3a/": {
                  "name": "templeton.peck@army.gov",
                  "permissions": {
                      "team_admin": true
                  }
              }
          }
      }


Removing members
''''''''''''''''

To remove members from the team, PATCH the catalog with a ``null``
value:

``http PATCH /teams/d07edb/members/ HTTP/1.1 Host: app.crunch.io Content-Type: application/json``\ json
{ "element": "shoji:catalog", "index": {
"https://app.crunch.io/api/users/e3211a/": null } } -------- 204 No
Content \`\`\`

.. language_specific::
   --HTTP
   .. code:: http

      GET /teams/d07edb/members/ HTTP/1.1
      Host: app.crunch.io
      --------
      200 OK
      Content-Type: application/json

   --JSON
   .. code:: json

      {
          "element": "shoji:catalog",
          "self": "https://app.crunch.io/api/teams/d07edb/members/",
          "description": "Catalog of users that belong to this team",
          "index": {
              "https://app.crunch.io/api/users/47193a/": {
                  "name": "B. A. Baracus",
                  "permissions": {
                      "team_admin": true
                  }
              },
              "https://app.crunch.io/api/users/41c69d/": {
                  "name": "Hannibal",
                  "permissions": {
                      "team_admin": true
                  }
              },
              "https://app.crunch.io/api/users/89eb3a/": {
                  "name": "templeton.peck@army.gov",
                  "permissions": {
                      "team_admin": false
                  }
              }
          }
      }


Team datasets catalog
~~~~~~~~~~~~~~~~~~~~~

``/teams/{team_id}/datasets/``

The team datasets catalog only supports the GET verb. To add a dataset
to a team, you must PATCH its `permissions catalog <#permissions>`__.

GET
^^^

GET returns a Shoji Catalog of datasets that have been shared with this
team. See `datasets <#datasets>`__ for details.
