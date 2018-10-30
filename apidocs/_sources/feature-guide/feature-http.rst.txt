General API Conventions
-----------------------

The Crunch REST API follows some common conventions across all endpoints. You can assume these to be the case except where explicitly documented otherwise.

Successful requests
~~~~~~~~~~~~~~~~~~~

* Successful ``GET`` requests return 200 status with ``Content-Type: application/json`` response content.
* ``PATCH`` is generally preferred for partial updating of resources, though some endpoints do support ``PUT``. A successful request returns 204 No Content status.
* ``POST`` is used to create entities on the server. The URL to the created entity is returned in the ``Location`` response header, and the response status is either 201 Created or 202 Continue.
* 202 Continue is used for requests that continue to process outside of the request cycle; for example, import or export jobs that may be long running and benefit from reporting progress to clients. See :doc:`Progress </endpoint-reference/endpoint-progress>` for how to handle the 202 response content. Requests that would otherwise return 201 Location will still include the ``Location`` header in the 202 response; requests that would otherwise return 204 No Content will have no additional response headers.

Unsuccessful requests
~~~~~~~~~~~~~~~~~~~~~

* "Bad" requests returning with a ``4xx`` status may contain JSON response content with an error message.
* Unauthenticated requests to non-public resources return 401.
* Authenticated but unauthorized responses return 404 Not Found rather than 403 Not Authorized in cases where returning 403 would leak information about the existence of resources. 403 response is reserved for cases such as when a user is authorized to ``GET`` a resource but not ``PATCH`` it, for example.
* 409 Conflict response is used when the request may be retried and may succeed if changes are first made at a different resource. Example: when a user who has edit privileges on a dataset but is not the "current editor" attempts to PATCH a dataset resource.

Deprecation
~~~~~~~~~~~

* When API resources are deprecated, responses will contain a ``Warning`` header with a message about the deprecation and a recommendation for upgrading. Our client libraries look for this response header and will alert you to upgrade your version of the library if you receive a response with this header.
* Endpoints that have been removed respond with a 410 Gone status, optionally with a message instructing you where to look instead.
