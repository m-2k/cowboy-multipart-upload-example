-module(cowboy_multipart).

-export([multipart/2, multipart/3]).

-define(MAX_FILE_SIZE_LIMIT, 307200). % 300Kb
% -define(MAX_FILES,unlimited).
-define(TMP_PATH,"/tmp").

multipart(Req, C) ->
    multipart(Req, C, ?MAX_FILE_SIZE_LIMIT).
multipart(Req, C, MaxFileSizeLimit) when is_atom(C) and is_integer(MaxFileSizeLimit) ->
    case cowboy_req:part(Req) of
        {ok, Headers, Req2} ->
            Req5 = case cow_multipart:form_data(Headers) of
                {data, FieldName} ->
                    {ok, Body, Req3} = cowboy_req:part_body(Req2),
                    ok = C:data_payload(FieldName, Body),
                    Req3;
                {file, FieldName, Filename, _CType, _CTransferEncoding} ->
                    TempFilename = temp_filename(),
                    {ok, IoDevice} = file:open(TempFilename, [raw, write]),
                    Rsf = stream_file(Req2, IoDevice, 0, MaxFileSizeLimit),
                    ok = file:close(IoDevice),
                    case Rsf of
                            {ok, FileSize, Req4} ->
                                ok = C:file_payload(FieldName, Filename, TempFilename, FileSize),
                                Req4;
                            {limit, Reason, Req4} ->
                                error_logger:warning_msg("Upload limit detected! Type: ~p, FieldName: ~p, Filename: ~p,~nReq: ~p~n",
                                    [Reason, FieldName, Filename, Req4]),
                                ok = file:delete(TempFilename),
                                Req4
                    end
            end,
            multipart(Req5, C, MaxFileSizeLimit);
        {done, Req2} ->
            {ok, Req2}
    end.

stream_file(Req, IoDevice, FileSize, MaxFileSizeLimit) ->
    {Control, Data, Req2} = cowboy_req:part_body(Req),
    NewFileSize = byte_size(Data) + FileSize,
    case NewFileSize > MaxFileSizeLimit of
        true -> {limit, file_size, Req2};
        false ->
            ok = file:write(IoDevice, Data),
            case Control of
                ok -> {ok, NewFileSize, Req2};
                more -> stream_file(Req2, IoDevice, NewFileSize, MaxFileSizeLimit)
            end
    end.

temp_filename() ->
    list_to_binary(filename:join([?TMP_PATH, atom_to_list(?MODULE) ++ integer_to_list(erlang:phash2(make_ref()))])).