#   It includes array factor formulas about
# electric field and gain of the antenna array
# for isotropic sources.
#   d : Space between array elements
#   N : Number of array elements
#   cos(Θ) : for elemets along z direction
#   sin(Θ) : for elemets along x direction
#   x : excitation current
#   β = 0 for broadside array
#   null : first zero point

module e_field_and_gain_formulas

Θ_deg = -180:0.1:180;
Θ_rad = Θ_deg * pi / 180;

function e_field(Θ, N, d, f)
   e_field_num = sin.(pi * d * N * f.(Θ));
   e_field_den=  sin.(pi * d * f.(Θ)) * N;
   return abs.(e_field_num ./ e_field_den);
end

function e_field_dB(Θ_deg, N ,d, f)
   return log10.(e_field(Θ_deg, N ,d, f));
end

function gain_dB(Θ_deg,N ,d, f)
  return 20 * log10.(e_field(Θ_deg,N ,d, f))
end

#number of antennas is twice of N
function gain_balanis(Θ, N, d, f)
  af = 0
  x=ones(N)
  for i = 1 : N
    af = af + x[i] .* cos.((2*i-1) * pi * d .* f.(Θ))
  end
  return 20 .* log10.(abs.(af)) # ./10 for normalized
end

function heaviside(Θ_deg)
   0.5 * (sign.(Θ_deg) + 1)
end

function gain_desired_cos(Θ_deg, a=20, b=-20, Θ_1=85, Θ_2=95)
  -(-b*(heaviside(-Θ_deg+Θ_1) + heaviside(Θ_deg-Θ_2))- a)
end

function gain_desired_sin(Θ_deg, a=20, b=-20, Θ_1=-5, Θ_2=5)
  -(-b*(heaviside(-Θ_deg+Θ_1) + heaviside(Θ_deg-Θ_2)) - a)
end

function gain_desired(Θ, a=-40, b=20, Θ_1=99, Θ_2=81)
    -(-b*(heaviside(-Θ+Θ_1) + heaviside(Θ-Θ_2)) - a)
end

function null(N,d,k)  # k. null points
    return acosd(k/N/d)
end
end #module
