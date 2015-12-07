
const AF_SP = Cint(1)
const AF_SP_RAW = Cint(2)

const NN_MSG = Csize_t(8192) # TODO Max val
const NN_REQ_RESEND_IVL = Cint(1)

const NN_PROTO_PIPELINE = Cint(5)
const NN_PUSH = Cint(NN_PROTO_PIPELINE * 16 + 0)
const NN_PULL = Cint(NN_PROTO_PIPELINE * 16 + 1)

const NN_PROTO_REQREP = Cint(3)
const NN_REQ = Cint(NN_PROTO_REQREP * 16 + 0)
const NN_REP = Cint(NN_PROTO_REQREP * 16 + 1)

const NN_PROTO_PAIR = Cint(1)
const NN_PAIR = Cint(NN_PROTO_PAIR * 16 + 0)

const NN_PROTO_BUS = Cint(7)
const NN_BUS = Cint(NN_PROTO_BUS * 16 + 0)

const NN_PROTO_PUBSUB = Cint(2)
const NN_PUB = Cint(NN_PROTO_PUBSUB * 16 + 0)
const NN_SUB = Cint(NN_PROTO_PUBSUB * 16 + 1)
const NN_SUB_SUBSCRIBE = Cint(1)
const NN_SUB_UNSUBSCRIBE = Cint(2)

const NN_PROTO_SURVEY = Cint(6)
const NN_SURVEYOR = Cint(NN_PROTO_SURVEY * 16 + 0)
const NN_RESPONDENT = Cint(NN_PROTO_SURVEY * 16 + 1)
const NN_SURVEYOR_DEADLINE = Cint(1)

const NN_SOCKADDR_MAX = Cint(128)

const NN_SOL_SOCKET = Cint(0)

# Socket options
const NN_LINGER = Cint(1)
const NN_SNDBUF = Cint(2)
const NN_RCVBUF = Cint(3)
const NN_SNDTIMEO = Cint(4)
const NN_RCVTIMEO = Cint(5)
const NN_RECONNECT_IVL = Cint(6)
const NN_RECONNECT_IVL_MAX = Cint(7)
const NN_SNDPRIO = Cint(8)
const NN_RCVPRIO= Cint(9)
const NN_SNDFD = Cint(10)
const NN_RCVFD = Cint(11)
const NN_DOMAIN = Cint(12)
const NN_PROTOCOL = Cint(13)
const NN_IPV4ONLY = Cint(14)
const NN_SOCKET_NAME = Cint(15)

# send / receive options
const NN_DONTWAIT = Cint(1)

const NN_INPROC = Cint(-1)
const NN_IPC = Cint(-2)
const NN_TCP = Cint(-3)
const NN_WS = Cint(-4)
const NN_TCPMUX = Cint(-5)

const NN_WS_MSG_TYPE = Cint(1)
const NN_WS_MSG_TYPE_TEXT = Cuint(0x01)
const NN_WS_MSG_TYPE_BINARY = Cuint(0x02)

const NN_TCP_NODELAY = Cint(1)

const NN_POLLIN = Cint(1)
const NN_POLLOUT = Cint(2)
const NN_POLL_IN_AND_OUT = NN_POLLIN + NN_POLLOUT

const NN_HAUSNUMERO = Cuint(156384712)
const nn_errors = Dict(
    # POSIX compliant error codes
    Cuint(45)                   => "ENOTSUP",
    Cuint(NN_HAUSNUMERO + 1)    => "ENOTSUP",
    Cuint(43)                   => "EPROTONOSUPPORT",
    Cuint(NN_HAUSNUMERO + 2)    => "EPROTONOSUPPORT",
    Cuint(55)                   => "ENOBUFS",
    Cuint(NN_HAUSNUMERO + 3)    => "ENOBUFS",
    Cuint(50)                   => "ENETDOWN",
    Cuint(NN_HAUSNUMERO + 4)    => "ENETDOWN",
    Cuint(5)                    => "EADDRINUSE",
    Cuint(NN_HAUSNUMERO + 5)    => "EADDRINUSE",
    Cuint(48)                   => "EADDRNOTAVAIL",
    Cuint(NN_HAUSNUMERO + 6)    => "EADDRNOTAVAIL",
    Cuint(61)                   => "ECONNREFUSED",
    Cuint(NN_HAUSNUMERO + 7)    => "ECONNREFUSED",
    Cuint(36)                   => "EINPROGRESS",
    Cuint(NN_HAUSNUMERO + 8)    => "EINPROGRESS",
    Cuint(38)                   => "ENOTSOCK",
    Cuint(NN_HAUSNUMERO + 9)    => "ENOTSOCK",
    Cuint(47)                   => "EAFNOSUPPORT",
    Cuint(NN_HAUSNUMERO + 10)   => "EAFNOSUPPORT",
    Cuint(100)                  => "EPROTO",
    Cuint(NN_HAUSNUMERO + 11)   => "EPROTO",
    Cuint(35)                   => "EAGAIN",
    Cuint(NN_HAUSNUMERO + 12)   => "EAGAIN",
    Cuint(9)                    => "EBADF",
    Cuint(NN_HAUSNUMERO + 13)   => "EBADF",
    Cuint(22)                   => "EINVAL",
    Cuint(NN_HAUSNUMERO + 14)   => "EINVAL",
    Cuint(24)                   => "EMFILE",
    Cuint(NN_HAUSNUMERO + 15)   => "EMFILE",
    Cuint(14)                   => "EFAULT",
    Cuint(NN_HAUSNUMERO + 16)   => "EFAULT",
    Cuint(13)                   => "EACCES",
    Cuint(NN_HAUSNUMERO + 17)   => "EACCES",
    Cuint(52)                   => "ENETRESET",
    Cuint(NN_HAUSNUMERO + 18)   => "ENETRESET",
    Cuint(51)                   => "ENETUNREACH",
    Cuint(NN_HAUSNUMERO + 19)   => "ENETUNREACH",
    Cuint(65)                   => "EHOSTUNREACH",
    Cuint(NN_HAUSNUMERO + 20)   => "EHOSTUNREACH",
    Cuint(57)                   => "ENOTCONN",
    Cuint(NN_HAUSNUMERO + 21)   => "ENOTCONN",
    Cuint(40)                   => "EMSGSIZE",
    Cuint(NN_HAUSNUMERO + 22)   => "EMSGSIZE",
    Cuint(60)                   => "ETIMEDOUT",
    Cuint(NN_HAUSNUMERO + 23)   => "ETIMEDOUT",
    Cuint(53)                   => "ECONNABORTED",
    Cuint(NN_HAUSNUMERO + 24)   => "ECONNABORTED",
    Cuint(54)                   => "ECONNRESET",
    Cuint(NN_HAUSNUMERO + 25)   => "ECONNRESET",
    Cuint(42)                   => "ENOPROTOOPT",
    Cuint(NN_HAUSNUMERO + 26)   => "ENOPROTOOPT",
    Cuint(56)                   => "EISCONN",
    Cuint(NN_HAUSNUMERO + 27)   => "EISCONN",
    Cuint(44)                   => "ESOCKTNOSUPPORT",
    Cuint(NN_HAUSNUMERO + 28)   => "ESOCKTNOSUPPORT",
    # Native nanomsg error codes
    Cuint(NN_HAUSNUMERO + 53)   => "ETERM",
    Cuint(NN_HAUSNUMERO + 54)   => "EFSM"
)
