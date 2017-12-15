# =========================================================================== #

# Using the following packages

include("modelLAP.jl")
include("lap.jl")
include("load.jl")
# Proceeding to the optimization
solverSelected = GLPKSolverMIP()

# Setting the data
C = [10 70 50 100 20 80 70 100;
     20 40 50 10 30 15 40 50;
     40 50 80 100 40 80 90 160;
     1000 100 100 150 160 90 100 100;
     50 50 20 40 10 10 20 10;
     70 40 40 40 100 20 40 50;
     20 20 50 10 20 60 40 40;
     10 20 40 80 10 10 20 30 ]

C2 = [9 8 6 4 6
      3 6 6 7 4
      4 9 8 3 6
      7 6 4 4 7
      2 8 3 5 6]

C3 = [90 75 75 80
      35 85 55 65
      125 95 90 105
      45 110 95 115]

# ----------------------- Execution --------------------------------------------
# Matrice carrée
# matrice = rand(1:20,(15,15))
function execLap(typeResolution,instance)
  matrice = loadPb(instance)
  if typeResolution == "LAP"
    algorithmeLap(matrice)
  else
    glpk_jump(matrice)
  end
end
