mutable struct Position
    x::Int
    y::Int
end

struct Size
    width::Int
    height::Int
end

s1 = Spaceship(Position(0,0), Size(30,5), Missile);
s2 = Spaceship(Position(10,0), Size(30,5), Laser);
a1 = Asteroid(Position(20,0), Size(20,20));
a2 = Asteroid(Position(0,20), Size(20,20));


struct Rectangle
    top::Int
    left::Int
    bottom::Int
    right::Int
    # return the upper-left and lower-right points
    Rectangle(p::Position, s::Size) =
        new(p.y + s.height, p.x, p.y, p.x+s.width)
end

# check if the 2 rectangles (A & B) overlap
function overlap(A::Rectangle, B::Rectangle)
    return A.left < B.right && A.right > B.left &&
           A.top > B.bottom && A.bottom < B.top
end

function collide(A::Thing, B::Thing)
    println("Checking collision of thing vs. thing")
    rectA = Rectangle(position(A), size(A))
    rectB = Rectangle(position(B), size(B))
    return overlap(rectA, rectB)
end


function collide(A::Spaceship, B::Spaceship)
    println("Checking collision of spaceship vs. spaceship")
    return true # just a test
end

# Randomly pick two things and check
function check_randomly(things)
    for i in 1:5
        two = rand(things, 2)
        collide(two...)
    end
end