Cowboy: POST multipart files uploading example
=========================

Overviev
---------------------
* Cowboy example
* Can load multiple files. Has an optional limit on file size.
* Also can accept the text data from the tags:
```html
<input type='text' name='somevalue' ">
```


Run
---------------------
* Type in your shell:
```sh
$ rebar get-deps
$ rebar compile
$ erl -pa ebin deps/*/ebin -s hello_world
```
* Open URL: http://127.0.0.1/
* Optional, type in erl console for realtime recompilation:

```erlang
> sync:go().
```

Develop
---------------------

* `data_payload(FieldName, Body)` - callback function for received text fields
* `file_payload(FieldName, Filename, TempFilename, FileSize)` - callback function for each received file

Misc
---------------------
* Tested with Cowboy 0.9

Credits
---------------------
* @m-2k
