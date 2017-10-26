include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots
using Optim

formulas = e_field_and_gain_formulas
Θ = 0:1:180
pow_sll = zeros(length(Θ))
pow_main = zeros(length(Θ))
N = 4
function plot_gain(Θ, N, d)
    p1=plot(Θ, formulas.gain_dB(Θ, N, d, cosd),label="Array factor gain")
    title!("gain dB for cos \n N = $(N), d = $(d) λ")
    ylabel!("Normalized radiation pattern");
    xlabel!("Zenith angle [deg]");
    # plot!(Θ, formulas.gain_desired(Θ), label="desired gain pattern")
    # ylims!(-50,1)
    xlims!(0,180)
    null_point = round(formulas.null(N, d, 1))
    gain_dB_sll = formulas.gain_dB(null_point,N,d,cosd)
    scatter!([null_point],formulas.gain_dB([null_point], N, d,cosd), label = "$null_point \n $gain_dB_sll")
 return p1
end

function error_power_sll(d)
    null_point = round(formulas.null(N, d[1], 1))
    gain_null = formulas.gain_dB(null_point,N,d[1],cosd)
    for Θ = 0:1:180
        if  Θ <= null_point && formulas.gain_dB(Θ,N,d[1],cosd)  >= -20
            pow_sll[Θ+1] = norm.(formulas.gain_dB(Θ, N, d[1], cosd) - (-20)).^2
        else
            pow_sll[Θ+1] = 0
        end
    end
    return sum(pow_sll)
end

# function error_power_main(d)
#     null_point = round(formulas.null(N, d[1], 1))
#     gain_null = formulas.gain_dB(null_point,N,d[1],cosd)
#     for Θ = 0:1:180
#         if  90 >= Θ >= null_point && formulas.gain_dB(Θ,N,d[1],cosd)  >= -20
#             pow_main[Θ+1] = norm.(formulas.gain_dB(Θ, N, d[1], cosd) - (-20)).^2
#         else
#             pow_main[Θ+1] = 0
#         end
#     end
#     return sum(pow_main)
# end

i = linspace(0.25,1,100)
e_p_sll = error_power_sll.(i)
# e_p_main = error_power_main.(i)
compare =zeros(100,2)
compare[:,1] = i
compare[:,2] = e_p_sll
plot_compare = plot(compare[:,1],compare[:,2], label = "min d =")
# title!("d vs error_power")
# xlabel!("d")
# ylabel!("error_power")
#
# result = Optim.optimize(error_power_sll, [0.3,0], BFGS())
