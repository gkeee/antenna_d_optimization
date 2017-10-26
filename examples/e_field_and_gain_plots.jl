include("../src/e_field_and_gain_formulas.jl")

using e_field_and_gain_formulas
using Plots

formulas = e_field_and_gain_formulas
Θ_deg = formulas.Θ_deg
Θ_rad = formulas.Θ_rad


function e_field_and_gain_plots(Θ_deg, N, d)
    p1 = plot(Θ_deg, formulas.e_field(Θ_deg, N, d),legend=false)
    title!("Ratio between distance and wavelength \n d / λ = $d");
    xlabel!("Zenith angle [deg]");
    ylabel!("Normalized radiation pattern");

    p2 = plot(Θ_rad, formulas.e_field(Θ_deg, N, d), proj=:polar,legend=false )
    title!("Polar plot \n for the radiation pattern \n d / λ = $d");

    # Plot_e_field=plot(Plot_e_field_deg, Plot_e_field_rad, layout=(1,2))

    p3 = plot(Θ_deg, formulas.gain_dB(Θ_deg, N, d),legend=false)
    # ylims!(-100,0)
    # xlims!(-90,90)
    title!("Number of elements = $N , d/λ = $d")
    xlabel!("Zenith angle [deg]")
    ylabel!("Radiation pattern dB")

    #anten sayısı N'in 2 katı
    p4 = plot(Θ_deg, formulas.gain_balanis(Θ_deg, N, d),legend=false)
    title!("Number of antennas N = $N, \n Distance between antennas d = $d λ")
    ylabel!("Normalized radiation pattern");
    xlabel!("Zenith angle [deg]");
        return p4
end
