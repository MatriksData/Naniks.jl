using Base.Test
include("../src/Naniks.jl")

bytes(s) = convert(Array{UInt8,1}, s)

const addr_a = "inproc://a"
const addr_b = "inproc://b"
#const addr_a = "tcp://127.0.0.1:2000"
#const addr_b = "tcp://127.0.0.1:2001"

bus1 = NN.Socket(NN.Bus)
bus2 = NN.Socket(NN.Bus)
bus3 = NN.Socket(NN.Bus)

NN.bind(bus1, addr_a)
NN.bind(bus2, addr_b)
NN.connect(bus3, addr_a)
NN.connect(bus3, addr_b)

NN.put!(bus1, bytes("A"))
NN.put!(bus2, bytes("AB"))
NN.put!(bus3, bytes("ABC"))

msg1 = NN.take!(bus3)
println(msg1)
msg2 = NN.take!(bus3)
println(msg2)

sleep(5)
