include("../src/e_field_and_gain_formulas.jl")
using e_field_and_gain_formulas
using Plots

formulas = e_field_and_gain_formulas
Θ_deg = -180:0.1:180;
Θ_rad = Θ_deg * pi / 180;
N = 10;
d = linspace(0.1,1,19);
# d= 0.43125

n=length(d)
Θ_null = zeros(n,2)
Θ_bound = [-90, 90]
null_integral = zeros(n)
bound_integral = zeros(n)
difference_value = zeros(n)
max_area = zeros(n)
 for i=1:n
     Θ_null[i,1] = formulas.null(N,d[i],1);
     Θ_null[i,2] = - formulas.null(N,d[i],1);
     null_integral[i] = quadgk(Θ->formulas.e_field(Θ,N,d[i],sind),
      Θ_null[i,2]-1e-5,Θ_null[i,1]-1e-5)[1]
     bound_integral[i] = quadgk(Θ->formulas.e_field(Θ,N,d[i],sind),
      Θ_bound[1]-1e-5,Θ_bound[2]-1e-5)[1]
     difference_value[i] = bound_integral[i] - null_integral[i]
     max_area[i] = null_integral[i] - difference_value[i]
 end

# compare max_area and d
d_vs_area=zeros(length(d),2)
for i=1:length(d)
    d_vs_area[i,1] = d[i]
    d_vs_area[i,2] = max_area[i]
end

 # compare beamwidth(bw) and d
d_vs_bw=zeros(length(d),3);
for i=1:length(d)
    d_vs_bw[i,1] = d[i]
    d_vs_bw[i,2] = 2 * (90 - Θ_null[i,1])
    d_vs_bw[i,3] = max_area[i]
end

# Plots
function plot_e(Θ_deg, N, d, f)
    p1=plot(Θ_deg, formulas.e_field(Θ_deg, N, d, f))
    return p1
end

p2=scatter(d_vs_area[:,1],d_vs_area[:,2])


# Next comments are mot necessary now.


# # Plots
# p1=arpp.plot(Θ_deg, arpp.E_field(Θ_deg,N,d))
# arpp.scatter!(Θ_null, arpp.E_field(Θ_null,N,d))
# arpp.scatter!(Θ_null_side, arpp.E_field(Θ_null_side,N,d))
# arpp.scatter!(Θ_bound, arpp.E_field(Θ_bound,N,d))

# optimization
# m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
# @variable(m, d)
# @NLconstraint(m,0.01 <= d <= 1 )
# JuMP.register(m, :integral_area, 1, integral_area, autodiff=true)
# @NLobjective(m, Min, integral_area(d))
# solve(m)
# println("cost ", getobjectivevalue(m), " at ", [getvalue(d)])

# d_max_area = arpp.scatter(d,max_area);
# arpp.scatter!(d,ratio)

# data = zeros(180,2)
# for i=1:180 data[i,1]= Θ_deg[i] end
# for i=1:180 data[i,2]= arpp.E_field(Θ_deg,N ,d)[i] end


# # first null points
# Θ_null_1 = null(N,d,1);
# Θ_null_2 = -Θ_null_1 ;
# Θ_null = [Θ_null_1, Θ_null_2]
# # second null points
# Θ_null_side_1 = null(N,d,2);
# Θ_null_side_2 = - Θ_null_side_1;
# Θ_null_side = [Θ_null_side_1, Θ_null_side_2]
# # bound points
# Θ_bound = [-90, 90]
# # integral between first null points
# null_integral = quadgk(Θ->arpp.E_field(Θ,N,d),Θ_null_2-1e-5,Θ_null_1-1e-5)[1]
# # integral between second null points
# null_side_total_integral = quadgk(Θ->arpp.E_field(Θ,N,d),Θ_null_side_2-1e-5,Θ_null_side_1-1e-5)[1]
# # integral between second null points except first null points
# null_side_integral = null_side_total_integral - null_integral
# # integral between bound points
# bound_integral = quadgk(Θ->arpp.E_field(Θ,N,d),Θ_bound[1]-1e-5,Θ_bound[2]-1e-5)[1]
# # integral between bound points except first null points
# difference_value = bound_integral - null_integral
# # null integral maximum, difference between bound and first nulls minimum
# max_area = null_integral - difference_value
# # ratio between first null integral and other area
# ratio = null_integral / difference_value
