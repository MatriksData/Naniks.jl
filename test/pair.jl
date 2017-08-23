include("../src/Naniks.jl")

const url = "inproc://a"

bytes(s) = convert(Array{UInt8,1}, s)

sb = NN.Socket(NN.Pair)
sc = NN.Socket(NN.Pair)
NN.bind(sb, url)
NN.connect(sc, url)

NN.put!(sb, bytes("ABC"))
NN.put!(sc, bytes("DEF"))

println("SC: " * String(NN.take!(sc)))
println("SB: " * String(NN.take!(sb)))


sleep(1)

NN.close(sc)
NN.close(sb)
