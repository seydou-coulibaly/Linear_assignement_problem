# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface

function setLAP(solverSelected,C)
  n,n = size(C)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:n,1:n],Bin)

  #Objectives functions
  @objective(ip, Min,
                    sum(C[i,j] * X[i,j] for i=1:n,j=1:n)
                    )

  #Constraints of problem
  for i=1:n
    @constraint(ip, sum(X[i,j] for j=1:n) == 1)
  end
  for j=1:n
    @constraint(ip, sum(X[i,j] for i=1:n) == 1)
  end

  return ip, X
end
