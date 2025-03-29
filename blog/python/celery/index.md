<!--
.. title: Celery
.. slug: celery
.. tags: python
.. date: 2025-02-24 20:01:52 UTC+02:00
.. category: 
.. link: 
.. description: 
.. type: text
.. path: /posts/python/celery
-->

Celery is a task queue which allows asynchronous execution of tasks.
In my case, this is particularly useful for freeing up resources in an API for CPU intensive tasks.
It works with a message broker, such as RabbitMQ, Redis, or SQS, and can handle multiple queues
across multiple servers.
It appears like getting started is pretty simple.

## My setup

I will use this with a FastAPI setup. For simplicity, I will use Redis as a message broker, and
PostgreSQL to store the results.
Later, it may that Redis could be used as a cache, or to preserve state across different processes.

Note that it is necessary to add the optional `celery[redis]` dependency.



