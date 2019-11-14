module NN

using Libdl

const libnn = "libnanomsg"
Libdl.dlopen(libnn)
include("nn_sys.jl")

@enum Protocol Req=NN_REQ Rep=NN_REP Pull=NN_PULL Push=NN_PUSH Pair=NN_PAIR Bus=NN_BUS Pub=NN_PUB Sub=NN_SUB Surveyor=NN_SURVEYOR Respondent=NN_RESPONDENT
export Protocol, Rep, Req, Pull, Push, Pair, Bus, Pub, Sub, Surveyor, Respondent

@enum Transport Inproc=NN_INPROC Ipc=NN_IPC Tcp=NN_TCP Ws=NN_WS Tcpmux=NN_TCPMUX
export Transport, Inproc, Ipc, Tcp, Ws, Tcpmux

error_message(prefix::String="") = begin
    err = ccall((:nn_errno, libnn), Cint, ())
    code = haskey(nn_errors, err) ? nn_errors[err] : ""
    #str = ccall((:strerror, "libc"), Ptr{UInt8}, (Cint,), err)
    str = ccall((:nn_strerror, libnn), Ptr{UInt8}, (Cint,), err)
    msg = prefix * string(err) * code * " - " * unsafe_string(str) * "\n"
    msg
end

mutable struct Socket
    domain::Cint
    protocol::Protocol
    id::Cint
    rx::RemoteChannel{Channel{Array{UInt8}}}
    endpoint_id::Cint

    Socket(p::Protocol) = Socket(AF_SP, p)
    Socket(is_raw::Bool, p::Protocol) = Socket(is_raw ? AF_SP_RAW : AF_SP, p)
    Socket(domain::Cint, p::Protocol) = begin
        sz = 1024
        s = ccall((:nn_socket, libnn), Cint, (Cint, Cint,), domain, p)
        s < 0 && throw(error_message("Socket creation error: "))
        r = RemoteChannel(()->Channel{Array{UInt8}}(sz))
        new(domain, p, s, r)
    end
end

macro listenerfn()
    quote
        function listener(socket::Socket)
            buff = Array{UInt8}(NN_MSG)
            const buff_ref = pointer(buff)
            #flags = Cint(0)
            flags = NN_DONTWAIT
            #const EAGAIN = Cint(11)
            const IDLE = 0.005
            while true
                len = ccall((:nn_recv, libnn), Cint, (Cint, Ptr{Void}, Csize_t, Cint),
                    socket.id, buff_ref, NN_MSG, flags)
                #len > 0 && println("msg sz: " * string(len))
                if len < 0
                    err = ccall((:nn_errno, libnn), Cint, ())
                    if err == Libc.EAGAIN
                        sleep(IDLE)
                    else
                        println(error_message("Message receive " * string(len) * ": "))
                    end
                    continue
                end
		try
			msg = Array{UInt8}(len)
			copy!(msg, 1, buff, 1, len)
			Base.put!(socket.rx, msg)				
	        catch ex
			println(ex)
			println(len)		
			continue
                end 
            end
        end
    end
end

function bind(socket::Socket, url::String)
    eid = ccall((:nn_bind, libnn), Cint, (Cint, Cstring), socket.id, url)
    eid < 0 && throw(error_message("Socket bind error: "))
    socket.endpoint_id = eid
    @async remote_do(@listenerfn(), rand(1:nprocs()), socket)
    info("Bind..." * string(socket.id))
    sleep(0.1)
    socket
end

function connect(socket::Socket, url::String)
    eid = ccall((:nn_connect, libnn), Cint, (Cint, Cstring), socket.id, url)
    eid < 0 && throw(error_message("Socket creation error: "))
    socket.endpoint_id = eid
    if socket.protocol != Req
	       @async remote_do(@listenerfn(), rand(1:nprocs()), socket)
    end
    sleep(0.1)
    socket
end

function recv(socket::Socket)
    buff = Array{UInt8}(NN_MSG)
    const buff_ref = pointer(buff)
    len = ccall((:nn_recv, libnn), Cint, (Cint, Ptr{Void}, Csize_t, Cint), socket.id, buff_ref, NN_MSG, Int32(0))
	if len < 0
        	err = ccall((:nn_errno, libnn), Cint, ())
        	println(error_message("Message receive " * string(len) * ": "))
        	return nothing
    end
    msg = Array{UInt8}(len)
    copy!(msg, 1, buff, 1, len)
    return msg
end

function send(socket::Socket, msg::String)
    size = convert(Csize_t, length(msg))
    msg_ptr = pointer(msg)
    len = ccall((:nn_send, libnn), Cint, (Cint,Ptr{Void},Csize_t,Cint), socket.id, convert(Ptr{Void}, msg_ptr), size, Int32(0))
    if len == -1
        throw(error_message("Socket send failed"))
    end

    if size != len
    	throw(error_message("Socket sent bytes $len != $size failed"))
    end
    return len
end

#
function Base.put!(socket::Socket, data::Array{UInt8})
    ret = ccall((:nn_send, libnn), Cint, (Cint, Ptr{UInt8}, Csize_t, Cint),
            socket.id, pointer(data), Csize_t(length(data)), 0)
    ret < 0 && println(error_message("Could not send the message: "))
end

Base.take!(socket::Socket) = Base.take!(socket.rx)

# TODO Use socket status for state
Base.start(socket::Socket) = nothing

Base.next(socket::Socket, state) = (take!(socket), nothing)

Base.done(socket::Socket, state) = false

function close(socket::Socket)
    ret = ccall((:nn_close, libnn), Cint, (Cint,), socket.id)
    if (ret < 0)
        println(error_message("Could not close the socket: "))
    end
end

function shutdown(socket::Socket)   # TODO parameter 'how'
    ret = ccall((:nn_shutdown, libnn), Cint, (Cint, Cint), socket.id, 0)
    if (ret < 0)
        println(error_message("Could not shutdown the socket: "))
    end
end

export Socket, bind, connect, send, shutdown, put!, take!

end             # module NN

module Naniks

using NN
export NN

end
