# =========================================================================== #

# Using the following packages

include("modelLAP.jl")

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

C2 = [9 8 6 4 6
      3 6 6 7 4
      4 9 8 3 6
      7 6 4 4 7
      2 8 3 5 6]

C3 = [90 75 75 80
      35 85 55 65
      125 95 90 105
      45 110 95 115]
# ------------------------- Etape0 ---------------------------------------------
function etape0(matrice)
  println("Lancement etape 0 ")
  C = copy(matrice)
  n,n = size(C)
  println("n = ",n)
  # soustraire à chaque ligne le min de la ligne
  for l = 1:n
    C[l,:] = C[l,:] - minimum(C[l,:])
  end
  # soustraire à chaque colonne le min de la colonne
  for c = 1:n
    C[:,c] = C[:,c] - minimum(C[:,c])
  end
  etape1(C,matrice)
end

# ------------------------- Etape1 ---------------------------------------------
function etape1(C,matrice)
  println("Lancement etape 1 ")
  n,n       = size(C)
  encadrer  = zeros(Int,n)
  mat = zeros(Int,n,n)
  tab = copy(C)
  value = n * maximum(C)
  for i = 1:n
    encadrer[i]   = n - countnz(C[i,:])
  end
  while 0 in tab
    lin = findfirst(encadrer,minimum(encadrer))
    col = findfirst(tab[lin,:],0)
    # encadrer C[lin,col]
    mat[lin,col] =  1
    tab[lin,col] = value
    # barrer les zeros se trouvant sur la même ligne et colonne
    tab[lin,:] = value
    tab[:,col] = value
    # mis a jour de la tab encadrer
    for i = 1:n
      encadrer[i]   = n - countnz(tab[i,:])
      if encadrer[i] == 0
        encadrer[i] = value
      end
    end
  end
  verif = true
  for i = 1:n
    verif = verif && sum(mat[i,:]) == 1
  end
  if verif == true
      # on tombe sur l'optimale
    println("Condition optimale : TRUE")
    ##############################################
    println("\nAffectation optimale ")
    for i = 1:n
      for j = 1:n
        print(" ");print(mat[i,j])
      end
      println()
    end
    print("Coût = ");println(sum(dot(mat[i,:],matrice[i,:]) for i=1:n))
    #############################################
  else
    println("Condition optimale : FALSE")
    etape2(mat,C,matrice)
  end
end
# ------------------------- Etape2 ---------------------------------------------
function etape2(mat,C,matrice)
  println("Lancement etape 2 ")
  n,n = size(C)
  marquageL   = zeros(Int,n)
  marquageC   = zeros(Int,n)
  value = n * maximum(C)
  for l = 1:n
    for c = 1:n
      if(C[l,c] == 0 && mat[l,c] == 0)
        mat[l,c] = value
      end
    end
  end
  verif = true
  # marquage ligne
  for l = 1:n
    if findfirst(mat[l,:],1) == 0
      marquageL[l] = 1
    end
  end
  # nombre de ligne et colonne marqué
  nb = 0
  for l = 1:n
    nb+=marquageL[l]
    nb+=marquageC[l]
  end
  while verif
    # marquage colonne
    for l = 1:n
      if marquageL[l] == 1
        for c = 1:n
          if mat[l,c] == value
            marquageC[c] = 1
          end
        end
      end
    end
    # marquage ligne
    for c = 1:n
      if marquageC[c] == 1
        for l = 1:n
          if mat[l,c] == 1
            marquageL[l] = 1
          end
        end
      end
    end
    # recommercer les opérations ci-dessus si pas changement
    # nombre de ligne et colonne marqué
    nbv = 0
    for l = 1:n
      nbv+=marquageL[l]
      nbv+=marquageC[l]
    end
    verif = nbv > nb
    nb = nbv
  end
  # tracer un trait sur les lignes non marquée et colonne marqueé
  ligne   = ones(Int,n)
  colonne = zeros(Int,n)
  for l= 1:n
    if marquageL[l] == 1
      ligne[l] = 0
    end
    if marquageC[l] == 1
      colonne[l] = 1
    end
  end
  etape3(ligne,colonne,C,matrice)
end
# ------------------------- Etape3 ---------------------------------------------
function etape3(ligne,colonne,C,matrice)
  println("Lancement etape 3 ")
  n,n = size(C)
  value = n * maximum(C)
  tab = copy(C)
  for i = 1:n
    for j = 1:n
      if tab[i,j] == 0
        tab[i,j] = value
      end
    end
  end
  for l = 1:n
    if ligne[l] == 0
      value = min(minimum(tab[l,:]),value)
    end
  end
  # soustraire value de chaque ligne non couverte
  for l = 1:n
    if ligne[l] == 0
      C[l,:] = C[l,:] - value
    end
  end
  # ajouter value à colonne couverte
  for l = 1:n
    if colonne[l] == 1
      C[:,l] = C[:,l] + value
    end
  end
  println()
  etape1(C,matrice)
end

# ----------------------- Execution --------------------------------------------
# Proceeding to the optimization
solverSelected = GLPKSolverMIP()
# Matrice carrée
matrice = copy(C2)
n,n = size(matrice)
# Affichage de la matrice
println("La matrice des coûts")
for i = 1:n
  for j = 1:n
    print(" ");print(matrice[i,j])
  end
  println()
end
# Lancement des etapes d'executions
tic = time()
etape0(matrice)
tac = time()
print("Time = ",round((tac-tic),3));println(" Secondes")
# GLPK et JUMP
ip,X = setLAP(solverSelected,C2)

println("The optimization problem to be solved is:")
tic = time()
print(ip)
println("Solving...");
status = solve(ip)

# Displaying the results
if status == :Optimal
  println("status = ", status)
  println("z  = ", getobjectivevalue(ip))
  print("x  = "); println(getvalue(X))
end
tac = time()
print("Time = ",round((tac-tic),3));println(" Secondes")
