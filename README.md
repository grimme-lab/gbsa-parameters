GBSA Parameters
===============

This repository contains the parameters for the generalized Born (GB)
solvation model with solvent accessible surface area (SASA), as
used in the [`xtb`](https://github.com/grimme-lab/xtb) program,
the [DFTB module of AMS](https://www.scm.com/product/dftb/) and
the [DFTB+](https://github.com/dftbplus/dftbplus) program package.

Format
------

The parameters are read in from `xtb` in plain text assuming the following format

```
<real>  # Dielectric constant
<real>  # Molecular mass of the solvent molecule in g·mol⁻¹
<real>  # Mass density of neat solvent in kg/L
<real>  # Scaling factor for the Born radii in Ångström
<real>  # Probe radius of the solvent in Ångström
<real>  # Shift to the total energy in kcal/mol
<real>  # Born offset parameter in 0.1·Ångström
<real>  # Dummy, not used
94 * <real> <real> <real>  # Surface tension, Descreening value, H-bond strength
```
