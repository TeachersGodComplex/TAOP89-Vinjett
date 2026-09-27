
I = 1:3   # råvaror
J = 1:3   # bensinsorter (slutprodukter)
K = 1:2   # egenskaper

a = Dict(
    (1,1) => 130, (2,1) => 100, (3,1) => 87,   # egenskap 1
    (1,2) => 60,  (2,2) => 6,   (3,2) => 8     # egenskap 2
)

# Tillgänglig mängd av råvara i
s = Dict(1 => 20, 2 => 20, 3 => 25)

# Efterfrågad mängd av produkt j
d = Dict(1 => 20, 2 => 15, 3 => 10)

# Inköpskostnad per ton råvara i 
cI = Dict(1 => 1500, 2 => 2400, 3 => 3000)

# Miljöpåverkan per ton råvara i
cM = Dict(1 => 30, 2 => 20, 3 => 10)

b1 = Dict((1,1)=>89,  (2,1)=>8,
          (1,2)=>93,  (2,2)=>7,
          (1,3)=>97,  (2,3)=>6)

b2 = Dict((1,1)=>91,  (2,1)=>11,
          (1,2)=>96,  (2,2)=>8,
          (1,3)=>100, (2,3)=>7)


objective_type = :cost

w1 = 0.5   # vikt för kostnad      (används bara om :weighted)
w2 = 0.5   # vikt för miljöpåverkan (används bara om :weighted)