%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(hello_world_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", toppage_handler, []},
            {"/upload", upload_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}
    ]),
    hello_world_sup:start_link().
    
% start(_Type, _Args) ->
%     Dispatch = [
%         {'_', [
%             {[<<"upload">>, '...'], upload_handler, []},
%             {'_', toppage_handler, []}
%             ]}
%     ],
%     cowboy:start_listener(my_http_listener, 1,
%         cowboy_tcp_transport, [{port, 8080}],
%         cowboy_http_protocol, [{dispatch, Dispatch}]
%     ),
%     hello_world_sup:start_link().

stop(_State) ->
	ok.