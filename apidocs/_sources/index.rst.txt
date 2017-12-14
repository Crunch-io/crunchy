.. Crunch.io API Docs documentation master file, created by
   sphinx-quickstart on Wed Nov 15 11:37:18 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Crunch.io API Docs
==================

Crunch exposes a REST API for third parties, and indeed its own UI, to
manage datasets. This API is also used by the Python_ and R_ libraries. This
User Guide is for developers who are writing applications on top of the
Crunch REST API, with or without those language bindings. It describes the
existing interfaces for the current version and attempts to provide context
and examples to guide development.

.. _Python: https://github.com/Crunch-io/pycrunch
.. _R: https://github.com/Crunch-io/rcrunch

The documents are organized in three overlapping scopes: a :doc:`feature guide
<feature-guide/index>`, which provide higher-level vignettes that illustrate
key features; an :doc:`endpoint reference <endpoint-reference/index>`, which
describes individual URIs in detail; and an :doc:`object reference
<object-reference/object-reference>`, which defines the building blocks of the
Crunch platform, such as values, columns, types, variables, and datasets.

.. toctree::
   :maxdepth: 2

   feature-guide/index
   endpoint-reference/index
   object-reference/object-reference.rst
