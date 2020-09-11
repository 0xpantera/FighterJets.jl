mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end

# Type of weapon
@enum Weapon Laser Missile

# A thing should have a position and size
abstract type Thing end

position(t::Thing) = t.position
size(t::Thing) = t.size
shape(t::Thing) = :unknown

struct Spaceship <: Thing
    position::Position
    size::Size
    weapon::Weapon
end
shape(s::Spaceship) = :saucer

Base.show(io::IO, s::Spaceship) =
    print(io, "Spaceship (", s.position.x, ",", s.position.y, ") ",
          s.size.width, "x", s.size.height, "/", s.weapon)

struct Asteroid <: Thing
    position::Position
    size::Size
end

Base.show(io::IO, a::Asteroid) =
    print(io, "Asteroid (", a.position.x, ",", a.position.y,
          ") ", a.size.width, "x", a.size.height)

# Test
s1 = Spaceship(Position(0,0), Size(30,5), Missile) 
s2 = Spaceship(Position(10,0), Size(30,5), Laser) 
a1 = Asteroid(Position(20,0), Size(20,20))
a2 = Asteroid(Position(0,20), Size(20,20))

# --------------------------------------------------------

function explode(things::AbstractVector{Any})
    for t in things
        println("Exploding $t")
    end
end

function explode(things::AbstractVector{T}) where {T <: Thing}
    for t in things
        println("Exploding thing => $t")
    end
end

# specifying abstract/concrete types in method signature
function tow(A::Spaceship, B::Thing)
    "tow 1"
end

# equivalent of parametric type
function tow(A::Spaceship, B::T) where {T <: Thing}
    "tow 2"
end

function group_anything(A::Thing, B::Thing)
    println("Grouped $A and $B")
end

function group_same_things(A::T, B::T) where {T <: Thing}
    println("Grouped $A and $B")
end

eltype(things::AbstractVector{T}) where {T <: Thing} = T