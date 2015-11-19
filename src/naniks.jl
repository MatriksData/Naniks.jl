module NN

Libdl.dlopen("libnanomsg")
libnn = :libnanomsg
include("nn_sys.jl")

@enum Protocol Req=NN_REQ Rep=NN_REP Pull=NN_PULL Push=NN_PUSH Pair=NN_PAIR Bus=NN_BUS Pub=NN_PUB Sub=NN_SUB Surveyor=NN_SURVEYOR Resondent=NN_RESPONDENT
export Protocol


end
