<!--
.. title: Django
.. slug: django
.. tags: python
.. date: 2025-02-01 20:01:52 UTC+02:00
.. category: 
.. link: 
.. description: 
.. type: text
.. path: /posts/python/django
-->

Django is a convenient python framework, which allows the setup of a REST API and database integration very quickly.
Taking a bunch of content from the official tutorial. Start with install and a sitename:  

```
python -m pip install Django
django-admin startproject sitename dirname 
python models.py startapp appname
```

Note that the `startapp appname` does not include the app directly, only adds files for it.
We also need to add it to `INSTALLED_APPS` in `settings.py`. 
This should use the app config in appname/apps.py, e.g `polls.apps.PollsConfig`,

## `manage.py`  

There are a load of commands which can be run using `manage.py` depending on the argument.
* `̀manage.py runserver` starts a development HTTP server on port 8000.
* `manage.py makemigrations appname` creates a series of sql migrations to run, and then `manage.py migrate` actually runs them.

## Database

Needed based on the applicatoins installed in settings.py.
Run `manage.py migrate` to install them.
The default set are not all needed, so we can get rid of some if we need.

The database tables are defined in `models.py`. 
All models inherit from `django.models.Model`, with a series of Field classes for different types of field.


`SELECT` database calls are done with `ModelName.objects.`, where the method can be `all()` for `SELECT *` or `.filter()`.

Can have `.order_by("-field_name")`, need to check how to `LIMIT` that, rather than using slices.

To access foreign key objects, use `ModelName.foreign_set`. This uses the same methods `.create(**kwargs)`, or `.filter()`.


## Admin interface

There is an admin interface for Django, with options provided by `django.contrib.auth` which is shipped by default.
By modifying the `appname.admin` file, we can add model objects to this interface, to be added/deleted or updated.


## Define URLs

In the app `urls.py` file, there is a list of URLs mapping to different functions.
Where a parameter is needed, we have the format `"<type:parameter_name>/"` where `parameter_name` is passed to the relevant view function as a kwarg.