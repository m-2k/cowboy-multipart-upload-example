Cowboy: POST multipart files uploading example
=========================

Overviev
---------------------
* Write on Erlang
* Can load multiple files. Has an optional limit on file size.
* Also can accept the text data from the tags:
\<input type='text' name='somevalue' ">


Run
---------------------
* rebar get-deps
* rebar compile
* erl -pa ebin deps/*/ebin -s hello_world

Develop
---------------------

* data_payload(FieldName, Body) - callback function for received text fields

* file_payload(FieldName, Filename, TempFilename, FileSize) - callback function for each received file

Misc
---------------------
* Tested with Cowboy 9

Credits
---------------------
* mag2000

Stay with Erlang
