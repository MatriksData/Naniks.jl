module NN

const libnn = "libnanomsg"
Libdl.dlopen(libnn)
include("nn_sys.jl")

@enum Protocol Req=NN_REQ Rep=NN_REP Pull=NN_PULL Push=NN_PUSH Pair=NN_PAIR Bus=NN_BUS Pub=NN_PUB Sub=NN_SUB Surveyor=NN_SURVEYOR Respondent=NN_RESPONDENT
export Protocol, Rep, Req, Pull, Push, Pair, Bus, Pub, Sub, Surveyor, Respondent

@enum Transport Inproc=NN_INPROC Ipc=NN_IPC Tcp=NN_TCP Ws=NN_WS Tcpmux=NN_TCPMUX
export Transport, Inproc, Ipc, Tcp, Ws, Tcpmux

error_message(prefix::ASCIIString="") = begin
    err = ccall((:nn_errno, libnn), Cint, ())
    if haskey(nn_errors, err)
        error("Socket creation error: " * nn_errors(err))
    else
        error("Unknown error code " * string(err))
    end
end

type Socket
    domain::Cint
    protocol::Protocol
    id::Cint
    endpoint_id::Cint

    Socket(p::Protocol) = Socket(AF_SP, p)
    Socket(is_raw::Bool, p::Protocol) = Socket(is_raw ? AF_SP_RAW : AF_SP, p)
    Socket(domain::Cint, p::Protocol) = begin
        s = ccall((:nn_socket, libnn), Cint, (Cint, Cint,), domain, p)
        if s < 0
            throw(error_message("Socket creation error: "))
        end
        new(domain, p, s)
    end
end

function nn_bind(socket::Socket, url::ASCIIString)
    id = ccall((:nn_bind, libnn), Cint, (Cint, Ptr{UInt8}), socket.id, url)
    if id < 0
        throw(error_message("Socket creation error: "))
    end
    socket.endpoint_id = id
    socket
end

function nn_connect(socket::Socket, url::ASCIIString)
    id = ccall((:nn_connect, libnn), Cint, (Cint, Ptr{UInt8}), socket.id, url)
    if id < 0
        throw(error_message("Socket creation error: "))
    end
    socket.endpoint_id = id
    socket
end

export Socket, nn_bind, nn_connect


end
