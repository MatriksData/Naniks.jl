using Base.Test

include("../src/Naniks.jl")
#using NN

socket = NN.Socket(NN.Bus)
NN.bind(socket, "tcp://127.0.0.1:2000")

println("Binded")
for msg in socket
    println(String(msg))
end
