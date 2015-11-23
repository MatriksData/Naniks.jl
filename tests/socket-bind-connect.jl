using Base.Test

include("../src/naniks.jl")
using NN

url = "tcp://127.0.0.1:3000"
socket_server = Socket(Push)
@test typeof(nn_bind(socket_server, url)) == Socket
@test socket_server.endpoint_id >= 0
println(socket_server)

socket_client = Socket(Pull)
@test typeof(nn_connect(socket_client, url)) == Socket
@test socket_client.endpoint_id >= 0
println(socket_client)
