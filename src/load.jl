# --------------------------------------------------------------------------- #
#=
OR-Library
The format of these data files is:
number of items to be assigned (n)
for each item i (i=1,...,n):
the cost of allocating item i to item j (c(i,j),j=1,...,n)
=#
# Loading an instance of LSP (format: decrit dans le rapport)
function loadPb(fname)
  f = open(fname)
  # lecture du nbre d'item
  n = parse.(Int,split(readline(f)))
  n = n[1]
  # lecture des coûts C[i,t]
  C = zeros(Int,n,n)
  cp = 1
  l  = 1
  c  = 1
  while cp < n*n
    for value in split(readline(f))
      valeur = parse(Int,value)
      C[l,c] = valeur
      cp+=1
      if c == n
        l+=1
        c = 0
      end
      c+=1
    end
  end
  close(f)
  return C
end
