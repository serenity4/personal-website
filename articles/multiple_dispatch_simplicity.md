# Multiple dispatch: towards intuitive programming

[Multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch) favors simplicity and intuitive code constructs.

This is the primary paradigm for the [Julia language](https://en.wikipedia.org/wiki/Julia_(programming_language)) - although many paradigms may be expressed via this mechanism.

This article will assume basic familiarity with multiple dispatch. To learn more about it, and how it compares with class-based dynamic dispatch, I encourage you to take a look at this fantastic article: [https://blog.glcs.io/multiple-dispatch](https://blog.glcs.io/multiple-dispatch).

## Namespacing

Say you want to call a `write` function that takes as input an `io` object of type `IO`, as well as a dictionary `dict` of type `Dict` to write in a JSON format.

Usually, you'd have the following possibilities:
- `write` is a global function in your namespace (perhaps you defined it, or it is a common symbol pulled in with your libraries). You may call it as `write(io, dict)`. Very straightforward.
- `write` is a global function, that is not in your namespace because other namespaces have different `write` functions and you don't want to pollute your own namespace. That's fair enough, we then have the following possibilities:
  - `write` is part of an IO-related namespace, say `IOStreams`, which supports writing dictionaries. You may call it as `IOStreams.write(io, dict)`
  - `write` is part of the module providing dictionaries, say `Dicts`, which supports the io object. You may call it as `Dicts.write(io, dict)`.
  - `write` is part of neither a dictionary or IO module, and was defined by another module, say `JSON`. You may call it as `JSON.write(io, dict)`.
- `write` is a class method (abstract or concrete), which you may call via the relevant class: `IO.write(io, dict)`, or `Dict.write(io, dict)`.
- `write` is an instance method, which you may call using the relevant object: `io.write(dict)`, or `dict.write(io)`.

All you wanted to do, was to invoke a function whose name you recall, but then you end up searching documentation just to know where it is defined and how it should be called. I wouldn't call that intuitive; note, by the way, that there isn't a way to make it intuitive if all of these `write` functions are completely separate - that's what namespacing is for, making sure you grab the intended symbol.

I would say that the first possibility is, in theory, the most intuitive. You want to call a function with arguments, so call `write` with your arguments `io` and `dict`: `write(io, dict)`[^1].

Most languages, in practice, stumble upon namespacing issues when trying to use widely named globals. The special case is [operator overloading](https://en.wikipedia.org/wiki/Operator_overloading), which feels great because it allows the use of common infix mathematical operators without namespacing[^2].

Multiple dispatch greatly helps with this issue of namespacing, allowing a function name to be used across many different contexts and to be extended across modules. Although namespacing is still desired in certain contexts, or unavoidable in others, its need is greatly reduced. See for yourself[^3] with `Base.write` in Julia (exported as a global by default):

```julia-repl
julia> write
write (generic function with 53 methods)

julia> methods(write)
# 53 methods for generic function "write" from Base:
  [1] write(dest::Base.AnnotatedIOBuffer, src::Base.AnnotatedIOBuffer)
     @ strings/annotated.jl:509
  [2] write(io::Base.AnnotatedIOBuffer, b::UInt8)
     @ strings/annotated.jl:507
  [3] write(io::Base.AnnotatedIOBuffer, s::Union{SubString{String}, String})
     @ strings/annotated.jl:506
  [4] write(io::Base.AnnotatedIOBuffer, astr::Union{Base.AnnotatedString, SubString{<:Base.AnnotatedString}})
     @ strings/annotated.jl:495
  [5] write(io::Base.AnnotatedIOBuffer, x::AbstractString)
     @ strings/annotated.jl:505
  [6] write(io::Base.AbstractPipe, s::Union{Base.AnnotatedString, SubString{<:Base.AnnotatedString}})
     @ strings/annotated.jl:523
  [7] write(io::IO, s::Union{Base.AnnotatedString, SubString{<:Base.AnnotatedString}})
     @ StyledStrings ~/.julia/juliaup/julia-nightly/share/julia/stdlib/v1.12/StyledStrings/src/io.jl:255
  [8] write(io::IO, s::Union{SubString{String}, String})
     @ strings/io.jl:248
  [9] write(io::Base.AnnotatedIOBuffer, c::Base.AnnotatedChar)
     @ strings/annotated.jl:503
 [10] write(f::Base.Filesystem.File, c::UInt8)
     @ Base.Filesystem filesystem.jl:241
 [11] write(io::Base.SecretBuffer, b::UInt8)
     @ secretbuffer.jl:133
 [12] write(s::Base.BufferStream, b::UInt8)
     @ stream.jl:1576
 [13] write(s::IOStream, b::UInt8)
     @ iostream.jl:378
 [14] write(pipe::Base64.Base64EncodePipe, x::UInt8)
     @ Base64 ~/.julia/juliaup/julia-nightly/share/julia/stdlib/v1.12/Base64/src/encode.jl:101
 [15] write(::Base.DevNull, ::UInt8)
     @ coreio.jl:12
 [16] write(io::Base.AbstractPipe, c::Base.AnnotatedChar)
     @ strings/annotated.jl:531
 [17] write(io::Base.AbstractPipe, byte::UInt8)
     @ io.jl:450
 [18] write(filename::AbstractString, a1, args...)
     @ io.jl:489
 [19] write(s::Base.LibuvStream, b::UInt8)
     @ stream.jl:1173
 [20] write(io::JSON.Writer.StringContext, byte::UInt8)
     @ JSON.Writer ~/.julia/packages/JSON/93Ea8/src/Writer.jl:139
 [21] write(to::Base.GenericIOBuffer, a::UInt8)
     @ iobuffer.jl:540
 [22] write(s::SwapStreams.SwapStream{S}, x::Array) where S
     @ SwapStreams ~/.julia/packages/SwapStreams/Ud7us/src/SwapStreams.jl:113
 ... (truncated)
```

Note that beyond built-in (Base) functionality, a few packages use and extend this function with their own types, such as JSON or SwapStreams.

Another advantage of multiple dispatch comes into play to further reduce mental overhead: methods no longer belong to specific classes. This lifts the namespacing requirement that comes with it when you do need to dispatch on your type, as you would with virtual methods and abstract classes in object-oriented languages. Even better, you may now define your methods wherever it seems appropriate in your codebase.

## Semantics

Because you are now free to use a function name, and define many implementations (methods) for it with various types and different arities, you might as well name functions in a way that is most meaningful semantically.

Here are a few examples:
```julia-repl
julia> show
show (generic function with 357 methods)

julia> iterate
iterate (generic function with 308 methods)

julia> length
length (generic function with 109 methods)

julia> findfirst
findfirst (generic function with 14 methods)

julia> minimum
minimum (generic function with 11 methods)

julia> open
open (generic function with 11 methods)
```

Of course, it is conventionally required that methods have a consistent meaning with one another. `length`, in Julia, returns the number of elements an object may be iterated over, with `iterate`; any extension of `Base.length` describing a geometrical length would be considered inadequate, and would by convention require to be a different function in another namespace.

Along with [namespacing improvements](@ref Namespacing), this enables a form of declarative programming: for high-level use, functions may be considered verbs and arguments nouns or complements, naturally expressing intent. Which instructions are to be executed is then up to the relevant implementations, which unlike functional programming, *may* use a more imperative form.
This is particularly important for a smooth interactive REPL experience − a productivity driver − and for high-level scripts that may be written by users whose programming skills may not be on par with their domain knowledge.

[^1]: Or shall it be `write(dict, io)`? Fortunately, this issue partly goes away [by convention](https://docs.julialang.org/en/v1/manual/style-guide/#Write-functions-with-argument-ordering-similar-to-Julia-Base), such that we can generally figure out the argument order on the spot or at least make it easier to recall later on. With the regular caveat that, the more positional arguments a function uses, the easier it is to get it wrong nevertheless.

[^2]: Actually, this seems to be the only solution that makes sense for infix operators; would you ever want to support writing something like `a Math.+ b` in a programming language?

[^3]: Note that `write(::IO, ::Dict)` is not implemented in Julia, because which serialization scheme to use is undecidable: JSON, YAML, TOML? Others? For JSON, you'd use the package-defined `JSON3.write(::Dict)::String` function, for instance, and use `write(::IO, ::String)` on the result; although, `print(::IO, ...)` and `println(::IO, ...)` are generally better suited and higher-level than `write` for that matter.
