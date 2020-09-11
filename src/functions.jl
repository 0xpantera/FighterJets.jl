
mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end

struct Widget
    name::String
    position::Position
    size::Size
end

# Define moving functions
move_up!(widget::Widget, v::Int)    = widget.position.y -= v
move_down!(widget::Widget, v::Int)  = widget.position.y += v
move_left!(widget::Widget, v::Int)  = widget.position.x -= v
move_right!(widget::Widget, v::Int) = widget.position.x += v

# Define pretty print functions
Base.show(io::IO, p::Position) = print(io, "(", p.x, ",", p.y, ")")
Base.show(io::IO, s::Size) = print(io, s.width, " x ", s.height)
Base.show(io::IO, w::Widget) = print(io, w.name, " at ", w.position, " size ", w.size)

# example
w = Widget("asteroid", Position(0, 0), Size(10, 20))
move_up!(w, 10)
move_down!(w, 10)
move_left!(w, 20)
move_right!(w, 20)


# Make a bunch of asteroids
# Optional arguments
function make_asteroids(N::Int, pos_range = 0:200, size_range = 10:30)
    pos_rand() = rand(pos_range)
    sz_rand() = rand(size_range)

    return [Widget("Asteroid #$i",
                   Position(pos_rand(), pos_rand()),
                   Size(sz_rand(), sz_rand()))
            for i in 1:N]
end


# Keyword arguments
function make_asteroids2(N::Int; pos_range = 0:200, size_range = 10:30)
    pos_rand() = rand(pos_range)
    sz_rand() = rand(size_range)

    return [Widget("Asteroid #$i",
                   Position(pos_rand(), pos_rand()),
                   Size(sz_rand(), sz_rand()))
            for i in 1:N]
end

# Shoot any number of targets
# Slurping (...) example
function shoot(from::Widget, targets::Widget...)
    println("Type of targets: $(typeof(targets))")
    for target in targets
        println(from.name, " --> ", target.name)
    end
end

asteroids = make_asteroids(5)

spaceship = Widget("Spaceship", Position(0, 0), Size(30, 30))
target1 = asteroids[1]
target2 = asteroids[2]
target3 = asteroids[3]

# Special arrangement before attacks
function triangular_formation!(s1::Widget, s2::Widget, s3::Widget)
    x_offset = 30
    y_offset = 50
    s2.position.x = s1.position.x - x_offset
    s3.position.x = s1.position.x + x_offset
    s2.position.y = s3.position.y = s1.position.y - y_offset
    (s1, s2, s3)
end

spaceships = [
    Widget("Spaceship $i", Position(0, 0), Size(20, 50))
    for i in 1:3
]

# Splat example
triangular_formation!(spaceships...)

random_move() = rand([move_down!, move_left!, move_right!, move_up!])

function random_leap!(w::Widget, move_func::Function, distance::Int)
    move_func(w, distance)
    return w
end

spaceship = Widget("Spaceship", Position(0,0), Size(20,50))

random_leap!(spaceship, random_move(), rand(50:100))


function clean_up_galaxy(asteroids, spaceships)
    ep = x -> println("$x exploded!")
    foreach(ep, asteroids)
    foreach(ep, spaceships)
end

# Random healthiness function for testing
healthy(spaceship) = rand(Bool)

# Ensure spaceship is healthy before any operation
function fire(f::Function, spaceship::Widget)
    if healthy(spaceship)
        f(spaceship)
    else
        println("Operation aborted as spaceship is not healthy")
    end
    return nothing
end

fire(s -> println("$s launched missile!"), spaceship)

fire(spaceship) do s
    move_up!(s, 100)
    println("$s launched missile!")
    move_down!(s, 100)
end

function process_file(func::Function, filename::AbstractString)
    ios = nothing
    try
        ios = open(filename)
        func(ios)
    finally
        close(ios)
    end
end
