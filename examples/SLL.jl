include("../src/e_field_and_gain_formulas.jl")

using PyPlot
using e_field_and_gain_formulas
formulas = e_field_and_gain_formulas
Θ_deg = formulas.Θ_deg;
N = 20
d = linspace(0.25,1,10)

function null(N,d,k)  # k. null points
    return asind(k/N/d)
end

a = null.(N, d, 1)
b = null.(N, d, 2)
sll_point = 90 - (a + b)./2
gain_dB_sll = zeros(10)
for i = 1:10
 gain_dB_sll[i] = formulas.gain_dB(sll_point[i], N ,d[i])
end

# d = 0.5
#
# gain = formulas.gain_dB(Θ_deg,N ,d)
# PyPlot.plot(Θ_deg, gain)
# sll = maximum(formulas.gain_dB(Θ_deg,N ,d))
#
#
# sll_point = 90 -(null(N, d, 1) + null(N, d, 2))/2
# gain_dB_sll = formulas.gain_dB(sll_point, N ,d)
# PyPlot.scatter(sll_point,formulas.gain_dB(sll_point,N ,d))
