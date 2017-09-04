using Base.Test
include("../src/Naniks.jl")

socket = NN.Socket(NN.Bus)
NN.bind(socket, "tcp://127.0.0.1:2000")

while true
    raw = NN.take!(socket)
    println(String(raw))
end
