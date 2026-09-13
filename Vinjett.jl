using JuMP, HiGHS

include("Data.jl")

model = Model(HiGHS.Optimizer)
set_silent(model)  # Kommentera bort för att se solverns loggar

# Beslutsvariabler
@variable(model, x[i in I, j in J] >= 0)

# Bivillkor: tillgång på råvara
@constraint(model, tillgang[i in I],
    sum(x[i,j] for j in J) <= s[i])

# Bivillkor: efterfrågan ska uppfyllas exakt 
@constraint(model, efterfragan[j in J],
    sum(x[i,j] for i in I) == d[j])

# Bivillkor: egenskaper hos produkten inom angivet intervall 
# Eftersom sum_i x[i,j] = d[j] skrivs villkoret som: b1[k,j]*d[j] <= sum_i a[i,k]*x[i,j] <= b2[k,j]*d[j]
@constraint(model, egenskap_lo[j in J, k in K],
    sum(a[i,k] * x[i,j] for i in I) >= b1[k,j] * d[j])

@constraint(model, egenskap_hi[j in J, k in K],
    sum(a[i,k] * x[i,j] for i in I) <= b2[k,j] * d[j])

# Målfunktion
total_cost(i) = sum(x[i,j] for j in J)

if objective_type == :cost
    @objective(model, Min, sum(cI[i] * total_cost(i) for i in I))

elseif objective_type == :environment
    @objective(model, Min, sum(cM[i] * total_cost(i) for i in I))

elseif objective_type == :weighted
    maxI = maximum(values(cI))   # normaliseringsfaktorer
    maxM = maximum(values(cM))
    @objective(model, Min,
        w1 * sum(cI[i] * total_cost(i) for i in I) / maxI +
        w2 * sum(cM[i] * total_cost(i) for i in I) / maxM)

else
    error("Okänd objective_type: $(objective_type)")
end

optimize!(model)

println("Status: ", termination_status(model))
println("Optimalt målfunktionsvärde: ", round(objective_value(model), digits=2))
println()
println("Optimal blandning (x[i,j] > 0):")
for i in I, j in J
    v = value(x[i,j])
    if v > 1e-6
        println("  Råvara $i -> Produkt $j : ", round(v, digits=3), " ton")
    end
end

println()
println("Total mängd använd per råvara:")
for i in I
    println("  Råvara $i: ", round(sum(value(x[i,j]) for j in J), digits=3),
            " av ", s[i], " ton tillgängligt")
end