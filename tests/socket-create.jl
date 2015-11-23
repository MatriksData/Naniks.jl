using Base.Test

include("../src/naniks.jl")
using NN

@test typeof( Socket(Req) ) == Socket
@test typeof( Socket(false,Req) ) == Socket

@test_throws MethodError Socket(12, Pull)
@test_throws ErrorException Socket(Cint(12), Pull)
