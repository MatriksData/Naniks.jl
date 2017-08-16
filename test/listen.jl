using Base.Test

include("../src/naniks.jl")
using NN

socket = Socket(Bus)
NN.bind(socket, "tcp://127.0.0.1:3009")

recv(msg) = println(convert(String, msg)

rx = socket.rx
#while true
    take!(rx)
#end