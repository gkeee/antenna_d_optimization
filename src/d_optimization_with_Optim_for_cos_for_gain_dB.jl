#   To calculate of gain using gain_dB formula in formulas module
# and to obtain error between gain and desired gain.
#   gain_dB_for_cos.png and error_power_gain_dB_for_cos.png
# are obtain by using this code.
#  To optimize error power, Optim packeges is used.

include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots
using Optim

formulas = e_field_and_gain_formulas
N = 4
Θ = 0:1:180
pow = zeros(length(Θ))

function plot_gain(Θ, N, d,f)
    p1=plot(Θ, formulas.gain_dB(Θ, N, d, f),label="Array factor gain")
    title!("gain dB for cos \n N = $(N), d = $(0.5) λ")
    ylabel!("Normalized radiation pattern");
    xlabel!("Zenith angle [deg]");
    plot!(Θ, formulas.gain_desired(Θ), label="desired gain pattern")
    ylims!(-50,1)
    xlims!(0,180)
 return p1
end

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


# compare d and error_power
i = linspace(0.1,1,10)
e_p = error_power.(i)
compare =zeros(10,2)
compare[:,1] = i
compare[:,2] = e_p
plot_compare = plot(compare[:,1],compare[:,2], label = "min d = 0.4986")
title!("d vs error_power")
xlabel!("d")
ylabel!("error_power")

result = Optim.optimize(error_power, [0.25,0], BFGS())
