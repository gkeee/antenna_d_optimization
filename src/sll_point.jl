include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots
using Optim

formulas = e_field_and_gain_formulas
Θ_deg = formulas.Θ_deg
N = 10
Θ = 0:1:180
pow = zeros(length(Θ))

function plot_gain(Θ, N, d)
    p1=plot(Θ, formulas.gain_dB(Θ, N, d),label="Array factor gain")
    title!("gain dB for cos \n N = $(N), d = $(d) λ")
    ylabel!("Normalized radiation pattern");
    xlabel!("Zenith angle [deg]");
    plot!(Θ, formulas.gain_desired(Θ), label="desired gain pattern")
    # plot!(Θ, formulas.gain_balanis(Θ, N, d+0.1),label="Array factor gain+0.1")
    ylims!(-50,1)
    xlims!(0,180)
    a = formulas.null(N, d, 1)
    b = formulas.null(N, d, 2)
    sll_point = 90 - (a + b)./2
    gain_dB_sll = formulas.gain_dB(sll_point,N,d)
    scatter!([sll_point],formulas.gain_dB([sll_point], N, d), label = "$gain_dB_sll")
    return p1
end
#
# function error_power(d)
#     for i = 0:1:180
#         if (formulas.gain_desired(i) == -20.) && (formulas.gain_desired(i) > formulas.gain_dB(i,N,d[1]))
#             pow[i+1] = 0.
#         elseif formulas.gain_desired_cos(i) >= -20. && (formulas.gain_desired(i) == formulas.gain_dB(i,N,d[1]))
#             pow[i+1] = 0.
#         else
#             pow[i+1] = norm.(formulas.gain_dB(i, N, d[1]) - formulas.gain_desired(i)).^2
#         end
#     end
#     pow[91]=0
#     summation=sum(pow)
#     return summation
# end
#
# result = Optim.optimize(error_power, [0.25,0], BFGS())
#
# # m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# # @variable(m, d )
# # @NLconstraint(m, 0.01 <= d <= 1 )
# # JuMP.register(m, :error_power, 1, error_power, autodiff=true)
# # @NLobjective(m, Min, error_power(d))
# # solve(m)
# # println("cost ", getobjectivevalue(m), " at ", [getvalue(d)])
#
# i = linspace(0.1,1,1000)
# e_p = error_power.(i)
#
# compare =zeros(1000,2)
# compare[:,1] = i
# compare[:,2] = e_p
# plot_compare = plot(compare[:,1],compare[:,2], label = "min d = 0.4986")
# title!("d vs error_power")
# xlabel!("d")
# ylabel!("error_power")
