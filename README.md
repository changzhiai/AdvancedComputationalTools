# Advanced Computational Tools

## Teacher setup

Clone this repo:

`git clone git@gitlab.com:asc-dtu/advanced_computational_tools.git`

Run `setup-teacher.sh`:

`sh advanced_computational_tools/tools/setup-teacher.sh`

This will copy a version of the repo to `$HOME/advanced_computational_tools_2020` that the students will copy from. Make note of the command printed to the screen, that's the one the students need to use. Maybe you will want to change the permissions of the repository folder because it has all the solutions.

## Student setup

Ask them put in the command mentioned above:

`source <TEACHER_HOME_FOLDER>/advanced_computational_tools_2020/tools/setup.sh`, (this should only be performed once)

and then to start the jupyter notebook:

`notebook`

take note of the hostname and port that serves the jupyter notebook. (E.g. `The Jupyter Notebook is running at: http://n-62-30-5:40000/`)

To view the notebooks in the browser a tunnel has to be created to the gbar.
For Linux users:

`ssh <USERNAME>@login.gbar.dtu.dk -vvv -g -L 8080:n-62-30-5:40000 -N -T`

For Windows users:

See: https://wiki.fysik.dtu.dk/gpaw/summerschools/summerschool18/accesswin.html#create-an-ssh-tunnel-to-the-notebook

To view notebooks:

Start a browser and navigate to: `http://localhost:8080`

### Requirements

No requirements at the moment. `ASE` and `GPAW` are installed by modules in the gbar, we just activate these modules.
