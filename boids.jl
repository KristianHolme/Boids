using Plots

mutable struct Boid
    position::Vector{Float64}
    velocity::Vector{Float64}
end

function InitBoids(N)
    boids = Vector{Boid}(undef, N)
    for i in 1:N
        randpos = rand(Float64, 2)
        randvel = rand(Float64, 2) ./ 10 #slow
        boids[i] = Boid(randpos, randvel)
    end
    return boids
end
# Initialize the plot with fixed bounds
function initialize_plot(boids; xlims=(0, 1), ylims=(0, 1))
    xpos = [boid.position[1] for boid in boids]
    ypos = [boid.position[2] for boid in boids]
    xvel = [boid.velocity[1] for boid in boids]
    yvel = [boid.velocity[2] for boid in boids]
    plt = quiver(xpos, ypos, quiver=(xvel, yvel), xlims=xlims, ylims=ylims, legend=false)
    return plt
end

# Update the plot with the current positions of the boids
function update_plot!(plt, boids)
    xpos = [boid.position[1] for boid in boids]
    ypos = [boid.position[2] for boid in boids]
    xvel = [boid.velocity[1] for boid in boids]
    yvel = [boid.velocity[2] for boid in boids]

    plt[1] = quiver!(xpos, ypos, quiver=(xvel, yvel))
end

function UpdatePositions!(boids)
    for boid in boids
        boid.position += boid.velocity
        # boid.position = mod.(boid.position, 1)
    end
end

function BoundaryVelocity(boid::Boid)
    x, y = boid.position[1], boid.position[2]
    vel = [0.0,0.0]
    α = 0.001
    vel[1] += α*(1/x - 1/(1-x))
    vel[2] += α*(1/y - 1/(1-y))
    return vel
end

function SeparationVelocity(boid::Boid, dists)
    vel = [0,0]
    return vel
end

function AlignmentVelocity(boid::Boid, dists)
    vel = [0,0]
    return vel
end

function CohesionVelocity(boid::Boid, dists)
    vel = [0,0]
    return vel
end

function UpdateVelocities!(boids)
    #calc distances
    dists = []
    for boid in boids
        boid.velocity ./2
        boid.velocity += BoundaryVelocity(boid)
        boid.velocity += SeparationVelocity(boid, dists)
        boid.velocity += AlignmentVelocity(boid, dists)
        boid.velocity += CohesionVelocity(boid, dists)
    end
end


function AnimateBoids(;N=1,steps=100)
    neighborhoodRadius = 0.2
    boids = InitBoids(N)


    anim = Animation()  # Initialize a new animation
    steps = 100
    xlims = (0,1)
    ylims = (0,1)
    for step in 1:steps
        plt = plot(xlims=xlims, ylims=ylims, legend=false)
        xpos = [boid.position[1] for boid in boids]
        ypos = [boid.position[2] for boid in boids]
        xvel = [boid.velocity[1] for boid in boids]
        yvel = [boid.velocity[2] for boid in boids]

        quiver!(plt, xpos, ypos, quiver=(xvel, yvel), color=:blue)
        frame(anim)  # Save the current frame

        UpdateVelocities!(boids)
        UpdatePositions!(boids)
        # Update the positions and velocities of your boids here
        # For example, you might call a function that updates the boid states

    end
    return anim
end
anim = AnimateBoids(N=1, steps=100)
fps = 1
g = gif(anim, "boids_animation.gif", fps = fps)