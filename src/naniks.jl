module NN

const libnn = "libnanomsg"
Libdl.dlopen(libnn)
include("nn_sys.jl")

@enum Protocol Req=NN_REQ Rep=NN_REP Pull=NN_PULL Push=NN_PUSH Pair=NN_PAIR Bus=NN_BUS Pub=NN_PUB Sub=NN_SUB Surveyor=NN_SURVEYOR Respondent=NN_RESPONDENT
export Protocol, Rep, Req, Pull, Push, Pair, Bus, Pub, Sub, Surveyor, Respondent

@enum Transport Inproc=NN_INPROC Ipc=NN_IPC Tcp=NN_TCP Ws=NN_WS Tcpmux=NN_TCPMUX
export Transport, Inproc, Ipc, Tcp, Ws, Tcpmux

error_message(prefix::String="") = begin
    err = ccall((:nn_errno, libnn), Cint, ())
    code = haskey(nn_errors, err) ? nn_errors(err) : ""
    str = ccall((:strerror, "libc"), Ptr{UInt8}, (Cint,), err)
    error(prefix * code * " - " * bytesstring(str))
end

mutable struct Socket
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

function bind(socket::Socket, url::String)
    id = ccall((:nn_bind, libnn), Cint, (Cint, Ptr{UInt8}), socket.id, url)
    if id < 0
        throw(error_message("Socket creation error: "))
    end
    socket.endpoint_id = id
    socket
end

function connect(socket::Socket, url::String)
    id = ccall((:nn_connect, libnn), Cint, (Cint, Ptr{UInt8}), socket.id, url)
    if id < 0
        throw(error_message("Socket creation error: "))
    end
    socket.endpoint_id = id
    socket
end

function listener(socket::Socket, f::Function)
    buff = Array(UInt8, NN_MSG)
    while true
        len = ccall((:nn_recv, libnn), Cint, (Cint, Ptr{UInt8}, Csize_t, Cint),
            socket.id, buff, NN_MSG, NN_DONTWAIT)
        if len < 0
            err = ccall((:nn_errno, libnn), Cint, ())
            if haskey(nn_errors, err) && nn_errors[err] == "EAGAIN"
                sleep(0.005)
            else
                println(error_message("Message receive: "))
            end
            continue
        end
        msg = Array{UInt8}(len)
        copy!(msg, 1, buff, 1, len)
        f(msg)
        yield()
    end
end

function on_message(socket::Socket, f::Function)
    _listener = @task listener(socket, f)
    @async yieldto(_listener)
end

function send(socket::Socket, message::Array{UInt8},
    offset::Integer=1, len::Integer=length(message))
    ret = ccall((:nn_send, libnn), Cint, (Cint, Ptr{UInt8}, Csize_t, Cint),
            socket.id, Ref(message, offset), Csize_t(len), 0)
    if (ret < 0)
        println(error_message("Could not send the message: "))
    end
end

function send(socket::Socket, message::String)
    msg = convert(Array{UInt8}, message)
    send(socket, msg, 1, length(msg))
end

function close(socket::Socket)
    ret = ccall((:nn_close, libnn), Cint, (Cint,), socket.id)
    if (ret < 0)
        println(error_message("Could not close the socker: "))
    end
end

function shutdown(socket::Socket)   # TODO parameter 'how'
    ret = ccall((:nn_shutdown, libnn), Cint, (Cint, Cint), socket.id, 0)
    if (ret < 0)
        println(error_message("Could not shutdown the socker: "))
    end
end

export Socket, bind, connect, on_message, send, shutdown

end             # module NN
