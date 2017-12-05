# =========================================================================== #

# Using the following packages

# include("setULP.jl")

# =========================================================================== #

# Setting the data
C = [10 70 50 100 20 80 70 100;
     20 40 50 10 30 15 40 50;
     40 50 80 100 40 80 90 160;
     1000 100 100 150 160 90 100 100;
     50 50 20 40 10 10 20 10;
     70 40 40 40 100 20 40 50;
     20 20 50 10 20 60 40 40;
     10 20 40 80 10 10 20 30 ]
n,m = size(C)
println(C)
# ------------------------- Etape0 ---------------------------------------------
function etape0(C)
  # soustraire à chaque ligne le min de la ligne
  for l = 1:n
    C[l,:] = C[l,:] - minimum(C[l,:])
  end
  # soustraire à chaque colonne le min de la colonne
  for c = 1:m
    C[:,c] = C[:,c] - minimum(C[:,c])
  end
end
etape0(C)
# ------------------------- Etape1 ---------------------------------------------
function etape1(C)
end
