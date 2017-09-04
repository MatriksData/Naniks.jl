
# Naniks - Nanomsg Connector for Julia

An iterator based [Nanomsg](http://nanomsg.org/) connector for [Julia](http://julialang.org).

## Installation

Naniks is not regintered yet.  Therefore, you need to install by cloning the Github repository ao follows:

```julia
Pkg.clone("https://github.com/MatriksData/Naniks.jl.git")
```

## Usage

Naniks functions and constants would be accessible thorough both `Naniks` and `NN` namespaces.

```julia
using Naniks

socket = NN.Socket(NN.Bus)
NN.bind(socket, "tcp://127.0.0.1:2000")

for msg in socket
    println(String(msg))
end
```

The library is still in active development.
