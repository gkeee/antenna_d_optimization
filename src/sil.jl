include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots
using Optim

formulas = e_field_and_gain_formulas
N = 10
Θ = 0:1:180
pow = zeros(length(Θ))

function error_power(d)
    for i = 0:1:180
        if (formulas.gain_dB(i,N,d[1],cosd) <= formulas.gain_desired(i)) && (formulas.gain_desired(i) == -20.)
            pow[i+1] = 0.
        elseif formulas.gain_desired(i) == 0. && (formulas.gain_desired(i) <= formulas.gain_dB(i,N,d[1],cosd))
            pow[i+1] = 0.
        elseif i == 90
            pow[i+1] = 0
        else
            pow[i+1] = norm.(formulas.gain_dB(i, N, d[1],cosd) - formulas.gain_desired(i)).^2
        end
    end
    return sum(pow)
end

i = linspace(0.1,1,10)
e_p = error_power.(i)
compare =zeros(10,2)
compare[:,1] = i
compare[:,2] = e_p
plot_compare = plot(compare[:,1],compare[:,2], label = "min d = ")
title!("d vs error_power")
xlabel!("d")
ylabel!("error_power")
result = Optim.optimize(error_power, [0.25,0], BFGS())
