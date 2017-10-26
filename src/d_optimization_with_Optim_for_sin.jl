#   To calculate of gain using gain_balanis formula in formulas module
# and to obtain error between gain and desired gain.
#   gain_balanis_for_sin.png and error_power_gain_balanis_for_sin.png
# are obtain by using this code.
#  To optimize error power, Optim packeges is used.

include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots
using Optim

formulas = e_field_and_gain_formulas
Θ_deg = formulas.Θ_deg
N = 10
Θ = -90:1:90
pow = zeros(length(Θ))

function plot_gain(Θ, N, d, f)
    p1=plot(Θ, formulas.gain_balanis(Θ, N, d, f),label="Array factor gain")
    title!("gain_balanis for sin \n N = 20,  d = $(0.5) λ")
    ylabel!("Normalized radiation pattern");
    xlabel!("Zenith angle [deg]");
    plot!(Θ, formulas.gain_desired_sin(Θ), label="desired gain pattern")
    ylims!(-300,100)
    xlims!(-90,90)
 return p1
end

function error_power(d)
    for i = -90:1:90
        if (formulas.gain_desired_sin(i) == 0.) &&
             (formulas.gain_desired_sin(i) > formulas.gain_balanis(i,N,d[1],sind))
            pow[i+91] = 0.
        elseif formulas.gain_desired_sin(i) >= 0. &&
             (formulas.gain_desired_sin(i) == formulas.gain_balanis(i,N,d[1],sind))
            pow[i+91] = 0.
        else
            pow[i+91] = norm.(formulas.gain_balanis(i, N, d[1],sind)
             - formulas.gain_desired_sin(i)).^2
        end
    end
    summation=sum(pow)
    return summation
end

i = linspace(0.1,1,1000)
e_p = error_power.(i)
compare =zeros(1000,2)
compare[:,1] = i
compare[:,2] = e_p
plot_compare=plot(compare[:,1],compare[:,2], label = "min d = 0.4312")
title!("d vs error_power")
xlabel!("d")
ylabel!("error_power")

result = Optim.optimize(error_power, [0.25,0], BFGS())
