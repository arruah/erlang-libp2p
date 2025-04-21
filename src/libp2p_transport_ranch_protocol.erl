-module(libp2p_transport_ranch_protocol).

-behaviour(ranch_protocol).
-compile({nowarn_unused_function, {init,4}}).

-export([start_link/3]).

start_link(Ref, Transport, Opts) ->
    %% Extract your needed values from Opts
    %% For example, if you expect {TID, ...} in Opts:
    TID = proplists:get_value(tid, Opts), %% Adjust key as needed

    %% Spawn your session handler (could be a gen_server, etc.)
    Pid = spawn_link(?MODULE, init, [Ref, Transport, TID, Opts]),
    {ok, Pid}.

%% You may need to implement the init/4 function:
init(Ref, Transport, TID, _Opts) ->
    {ok, Socket} = ranch:handshake(Ref),
    Connection = Transport:new_connection(Socket),
    libp2p_transport:start_server_session(Ref, TID, Connection).

