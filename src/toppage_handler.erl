%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Type, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
    Body = <<"<html><head><title>upload</title></head><body>
    <form action=\"http://localhost:8080/upload\" enctype=\"multipart/form-data\" method=\"post\">
        <p>
            Type some text (if you like):<br>
                <input type=\"text\" name=\"textline\" size=\"30\">
        </p>
        <p>
            Please specify a file, or a set of files:<br>
            <input type=\"file\" name=\"datafile\">
        </p>
        <div>
            <input type=\"submit\" value=\"Send\">
        </div>
    </form>
    </body></html>">>,
	{ok, Req2} = cowboy_req:reply(200, [], Body, Req),
    %{ok, Req2} = cowboy_http_req:reply(200, [], Body, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.
