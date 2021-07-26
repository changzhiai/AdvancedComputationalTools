import numpy as np

from ase import Atoms
from ase.calculators.emt import EMT
from ase.optimize import BFGS
from ase.visualize import view
from ase.io import read

# Set up the atoms object
d = 1.2
t = np.pi / 180 * 104.51
atoms = Atoms('H2O',
              positions=[(d, 0, 0),
                         (d * np.cos(t), d * np.sin(t), 0),
                         (0, 0, 0)],
              calculator=EMT())
atoms.center(vacuum=5)
# Relax the atoms
dyn = BFGS(atoms, trajectory='H2O.traj')
dyn.run(0.05)
