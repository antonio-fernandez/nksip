%% -------------------------------------------------------------------
%%
%% nksip_call.hrl: SIP call processing types
%%
%% Copyright (c) 2013 Carlos Gonzalez Florido.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-ifndef(NKSIP_CALL_HRL_).
-define(NKSIP_CALL_HRL_, 1).

-record(raw_sipmsg, {
    sipapp_id :: nksip:sipapp_id(),
    transport :: nksip_transport:transport(),
    start :: nksip_lib:l_timestamp(),
    call_id :: nksip:call_id(),
    class :: nksip_parse:msg_class(),
    headers :: [{binary(), binary()}],
    body :: nksip:body()
}).


-record(uas, {
    pos :: nksip:cseq(),
    id :: binary(),
    call_status :: nksip_call_uas:call_status(),
    trans_status :: nksip_call_uas:trans_status(),
    request :: nksip:request(),
    response :: nksip:response(),
    loop_id :: binary(),
    s100_timer :: reference(),
    timeout_timer :: reference(),
    retrans_timer :: reference(),
    next_retrans :: non_neg_integer(),
    expire_timer :: reference(),
    cancelled :: boolean()
}).

-record(uac, {
    id :: binary(),
    status :: nksip_call_uac:status(),
    request :: nksip:request(),
    responses :: [nksip:response()],
    to_tags :: [binary()],                  % Received To tags
    respfun :: function(),
    timeout_timer :: reference(),
    retrans_timer :: reference(),
    next_retrans :: nksip_lib:timestamp(),
    expire_timer :: reference(),
    cancel :: {reply, from(), nksip:request()},
    iter :: integer()
}).


-record(call, {
    app_id :: nksip:sipapp_id(),
    call_id :: nksip:call_id(),
    module :: atom(),
    app_pid :: pid(),
    app_opts :: nksip_lib:proplist(),
    uass = [] :: [#uas{}],
    uacs = [] :: [#uac{}],
    dialogs = [] :: [nksip_dialog:dialog()],
    msg_queue :: queue(),
    blocked :: boolean()
}).

-endif.