using Base.Test

include("../src/naniks.jl")
using NN

socket = Socket(Pull)
@test typeof( socket ) == Socket
@test typeof(nn_bind(socket, "tcp://127.0.0.1:3000")) == Socket
@test socket.endpoint_id >= 0
