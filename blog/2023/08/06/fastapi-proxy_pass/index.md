<!--
.. title: FastAPI proxy_pass
.. slug: fastapi-proxy_pass
.. date: 2023-08-06 16:01:52 UTC+02:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
-->

This took me hours of debugging, when really it was quite obvious. I have a project which contains
a FastAPI backend and a VueJS front-end, which are served behind an nginx proxy.  The point of 
this setup is to start using FastAPI, so this was a bit of a gotcha.

I have the frontend listening on port 8080 or 3000, and the server listening on 5000, but the
proxy should forward `/api` to the app served by the FastAPI.  The nginx config I had was like this:

```nginx

location /api {
    proxy_pass http://api:5000/;
}
```

The way FastAPI handles this is to set a `root_api` for services behind a proxy, so the app is
initialised like this:
```python
app = FastAPI(root_path="/api")
```
Going to `localhost/api` served the `/` endpoint ok, but going to `/api/path` didn't, so I was 
continually getting log messages like this:

    api_1       | INFO:     172.28.0.3:57182 - "GET / HTTP/1.0" 200 OK
    proxy_1     | 172.28.0.1 - - [05/Aug/2023:17:36:31 +0000] "GET /api HTTP/1.1" 200 24 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"
    api_1       | INFO:     172.28.0.3:36934 - "GET //decks HTTP/1.0" 404 Not Found
    proxy_1     | 172.28.0.1 - - [05/Aug/2023:17:36:37 +0000] "GET /api/decks HTTP/1.1" 404 22 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"
    api_1       | INFO:     172.28.0.3:53774 - "GET // HTTP/1.0" 404 Not Found
    proxy_1     | 172.28.0.1 - - [05/Aug/2023:17:37:14 +0000] "GET /api/ HTTP/1.1" 404 22 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"

The solution: A trailing slash is needed in both the nginx `location` as well as the `proxy_pass`! 

```nginx

location /api/ {
    proxy_pass http://api:5000/;
}
```

Now that seems to work, and I can start making actual progress on FastAPI...
