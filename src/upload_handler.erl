%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(upload_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-export([data_payload/2, file_payload/4]).

init(_Type, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
    % error_logger:info_msg("DEBUG 1"),
    %{ReqU, Body} = cowboy_multipart:multipart2(Req),
    {Method, Req2} = cowboy_req:method(Req),
    case Method of
        <<"POST">> ->
            Body = <<"<h1>This is a response for POST</h1>">>,
            {B, ReqU} = case cowboy_multipart:multipart(Req2, ?MODULE) of
                {ok, ReqM} ->
                    {Body, ReqM};
                {rejected, file_size_limit, ReqM} ->
                    {<<"POST: File Size Limit">>, ReqM}
                end,
            {ok, Req3} = cowboy_req:reply(200, [], B, ReqU),
            {ok, Req3, State};
        <<"GET">> ->
            Body = <<"<h1>This is a response for GET</h1>">>,
            {ok, Req3} = cowboy_req:reply(200, [], Body, Req2),
            {ok, Req3, State};
        _ ->
            Body = <<"<h1>This is a response for other methods</h1>">>,
            {ok, Req3} = cowboy_req:reply(200, [], Body, Req2),
            {ok, Req3, State}
        end.

terminate(_Reason, _Req, _State) ->
    ok.

data_payload(FieldName, Body) ->
    % error_logger:info_msg("DATA PAYLOAD {FieldName, Body} = {~p,~p}", [FieldName, Body]),
    ok.

file_payload(FieldName, Filename, TempFilename, FileSize) ->
    NewFileName = <<"/tmp/upload.jpg">>,
    % error_logger:info_msg("FILE PAYLOAD: {~p, ~p, ~p}", [FieldName, Filename, TempFilename]),
    {ok, BytesCopied} = file:copy(TempFilename, NewFileName),
    ok.