using Base.Test

include("../src/naniks.jl")
using NN

socket = Socket(Pull)
NN.bind(socket, "tcp://127.0.0.1:3000")

recv(msg) = println(bytestring(msg))

on_message(socket, recv)

println("Sleeping...")
sleep(24)
println("i'm back")
