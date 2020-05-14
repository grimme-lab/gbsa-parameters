#!/usr/bin/awk -f

# Initialize constants and strings for accumulation of paramters
BEGIN {
   autokcal = 627.50947428
   descreening = "  Descreening = Values {\n"
   surface_tension = "    SurfaceTension = Values {\n"
   hbond_strength = "  HBondStrength = Values {\n"
   hbond_corr = 0
}

# The first eight lines contain global constants, the first three are specific
# for the solvent, while the next four are model parameters, the eight is not used
NR == 1 { epsilon = $1 }
NR == 2 { molecular_mass = $1 }
NR == 3 { density = $1 }
NR == 4 { born_scale = $1 }
NR == 5 { probe_rad = $1 }
NR == 6 { free_energy_shift = $1 }
NR == 7 { born_offset = $1 * 0.1 }

# Translate atomic numbers to element symbols, DFTB+ only understands symbols
function to_symbol(number) {
   switch(number) {
      case 1  :  return "H "
      case 2  :  return "He"
      case 3  :  return "Li"
      case 4  :  return "Be"
      case 5  :  return "B "
      case 6  :  return "C "
      case 7  :  return "N "
      case 8  :  return "O "
      case 9  :  return "F "
      case 10 :  return "Ne"
      case 11 :  return "Na"
      case 12 :  return "Mg"
      case 13 :  return "Al"
      case 14 :  return "Si"
      case 15 :  return "P "
      case 16 :  return "S "
      case 17 :  return "Cl"
      case 18 :  return "Ar"
      case 19 :  return "K "
      case 20 :  return "Ca"
      case 21 :  return "Sc"
      case 22 :  return "Ti"
      case 23 :  return "V "
      case 24 :  return "Cr"
      case 25 :  return "Mn"
      case 26 :  return "Fe"
      case 27 :  return "Co"
      case 28 :  return "Ni"
      case 29 :  return "Cu"
      case 30 :  return "Zn"
      case 31 :  return "Ga"
      case 32 :  return "Ge"
      case 33 :  return "As"
      case 34 :  return "Se"
      case 35 :  return "Br"
      case 36 :  return "Kr"
      case 37 :  return "Rb"
      case 38 :  return "Sr"
      case 39 :  return "Y "
      case 40 :  return "Zr"
      case 41 :  return "Nb"
      case 42 :  return "Mo"
      case 43 :  return "Tc"
      case 44 :  return "Ru"
      case 45 :  return "Rh"
      case 46 :  return "Pd"
      case 47 :  return "Ag"
      case 48 :  return "Cd"
      case 49 :  return "In"
      case 50 :  return "Sn"
      case 51 :  return "Sb"
      case 52 :  return "Te"
      case 53 :  return "I "
      case 54 :  return "Xe"
      case 55 :  return "Cs"
      case 56 :  return "Ba"
      case 57 :  return "La"
      case 58 :  return "Ce"
      case 59 :  return "Pr"
      case 60 :  return "Nd"
      case 61 :  return "Pm"
      case 62 :  return "Sm"
      case 63 :  return "Eu"
      case 64 :  return "Gd"
      case 65 :  return "Tb"
      case 66 :  return "Dy"
      case 67 :  return "Ho"
      case 68 :  return "Er"
      case 69 :  return "Tm"
      case 70 :  return "Yb"
      case 71 :  return "Lu"
      case 72 :  return "Hf"
      case 73 :  return "Ta"
      case 74 :  return "W "
      case 75 :  return "Re"
      case 76 :  return "Os"
      case 77 :  return "Ir"
      case 78 :  return "Pt"
      case 79 :  return "Au"
      case 80 :  return "Hg"
      case 81 :  return "Tl"
      case 82 :  return "Pb"
      case 83 :  return "Bi"
      case 84 :  return "Po"
      case 85 :  return "At"
      case 86 :  return "Rn"
      case 87 :  return "Fr"
      case 88 :  return "Ra"
      case 89 :  return "Ac"
      case 90 :  return "Th"
      case 91 :  return "Pa"
      case 92 :  return "U "
      case 93 :  return "Np"
      case 94 :  return "Pu"
      case 95 :  return "Am"
      case 96 :  return "Cm"
      case 97 :  return "Bk"
      case 98 :  return "Cf"
      case 99 :  return "Es"
      case 100:  return "Fm"
      case 101:  return "Md"
      case 102:  return "No"
      case 103:  return "Lr"
      case 104:  return "Rf"
      case 105:  return "Db"
      case 106:  return "Sg"
      case 107:  return "Bh"
      case 108:  return "Hs"
      case 109:  return "Mt"
      case 110:  return "Ds"
      case 111:  return "Rg"
      case 112:  return "Cn"
      case 113:  return "Nh"
      case 114:  return "Fl"
      case 115:  return "Mc"
      case 116:  return "Lv"
      case 117:  return "Ts"
      case 118:  return "Og" 
   }
}

# Everything past line 8 are element specific parameters, we allow up to 94
# rows of parameters up to Plutonium
NR >= 9 && NR < 102 {
   symbol = to_symbol(NR-8)
   descreening = sprintf("%s    %s = %11.8f\n", descreening, symbol, $2)
   surface_tension = sprintf("%s      %s = %12.8f\n", surface_tension, symbol, $1)
   hbond_strength = sprintf("%s    %s = %.10e\n", hbond_strength, symbol, -$3*$3/autokcal)
   hbond_corr = hbond_corr || $3*$3 > 0.0
}

# Now write out the HSD input for DFTB+
END {
   # cap strings with closing braces
   descreening = sprintf("%s  }", descreening)
   surface_tension = sprintf("%s    }", surface_tension)
   hbond_strength = sprintf("%s  }", hbond_strength)
   # Solvation input
   print "GeneralizedBorn {"
   print "  Solvent = fromConstants {"
   print "    Epsilon =", epsilon
   print "    MolecularMass [amu] =", molecular_mass
   print "    Density [kg/l] =", density
   print "  }"
   print "  FreeEnergyShift [kcal/mol] =", free_energy_shift
   print "  BornScale =", born_scale
   print "  BornOffset [AA] =", born_offset
   if (hbond_corr) {
      print "  HBondCorr = Yes"
   } else {
      print "  HBondCorr = No"
   }
   print "  Radii = vanDerWaalsRadiiD3 [AA] {}"
   print "  SASA {"
   print "    ProbeRadius [AA] =", probe_rad
   print "    Radii = vanDerWaalsRadiiD3 [AA] {}"
   print surface_tension
   print "  }"
   print descreening
   if (hbond_corr) { print hbond_strength }
   print "}"
}
