include("../src/naniks.jl")

using NN

const url = "inproc://a"

sb = Socket(NN.Pair)
sc = Socket(NN.Pair)
NN.bind(sb, url)
NN.connect(sc, url)

on_message(sb, (data) -> println("SB: " * bytestring(data)))
on_message(sc, (data) -> println("SC: " * bytestring(data)))

NN.send(sb, "ABC")
NN.send(sc, "DEF")

sleep(1)

NN.close(sc)
NN.close(sb)
