This part simulates the process FNR interacts with O2. The equations and data used in this model are from the paper Victoria R.Sutten et al, J.Bacteriol, 2004. The assumptions used in this model are:

- a constant level of FNR(including O2-FNR) in the E.coli
- no effect in the rate of O2-induced Fe2+ release from 4Fe-FNR in the presence and absense of DNA
- in the temperature of 25C
- the loss of O2 is negligible


The reaction is modeled as:

          kobs
O2 + FNR <------> product

kobs = a*[O2]/(b+[O2])
a = 0.0682
b = 408 uM