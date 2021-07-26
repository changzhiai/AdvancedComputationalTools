#!/bin/bash

# Run this script to make a repo ready on your account. The students will copy from this repo.
# If the repo already exists files will be overwritten.
#

echo
echo
echo "Setting up base repo that the students will copy from."
echo

# Location for the local copy of exercises and tools for the students
DIRNAME=$HOME/advanced_computational_tools_2020

# Location for the solutions of the exercises should be made available at specific times using the bash command "at"
SOLUTIONS=$HOME/advanced_computational_tools_2020_solutions
mkdir -p $SOLUTIONS
echo
echo "The students will have a folder called solutions in their folder that links to:"
echo "$SOLUTIONS"
echo "You can add notebooks with solutions to that folder at times you see fit."
echo

# Name of the folder for the students to use
STUDENT_FOLDER=comp_tools_2020


# Get the folder in which this file is located, snippet from:
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
unset CDPATH
# cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
cwd="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"

# Make repo folder, but check if it exists first
if [[ -d $DIRNAME ]]; then
    echo "The folder $DIRNAME already exists."

    # Already existing folder. Let the user decide if the script should continue.
    # Snippet from: https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
    read -n 1 -p "Do you want to continue? You will possibly overwrite files in the folder (y/n)? " answer
    echo
    if echo "$answer" | grep -iq "^y" ;then
        echo 'Continuing'
    else
        echo 'Quitting'
        exit
    fi
else
    echo "The repo is located in the folder '$DIRNAME'."
    mkdir $DIRNAME
fi

mkdir -p $DIRNAME/tools $DIRNAME/exercises $DIRNAME/project

# Copy the exercises to this base repo
cp -r "$cwd"/../exercises/* $DIRNAME/exercises/
cp -r "$cwd"/../project/* $DIRNAME/project/
ln -s $SOLUTIONS $DIRNAME/exercises/solutions

# Run script to convert from master to student version of the exercises
python3 "$cwd"/convert.py $DIRNAME/exercises
python3 "$cwd"/convert.py $DIRNAME/exercises/Lecture_6

# Remove all master versions of the notebooks
rm $DIRNAME/exercises/day*/*master.ipynb
rm $DIRNAME/exercises/homework*/*master.ipynb

# Copy different scripts and change some folder locations
cp "$cwd"/setup.sh $DIRNAME/tools/
cp "$cwd"/activate.sh $DIRNAME/tools/
cp "$cwd"/bsub.py $DIRNAME/tools/
cp "$cwd"/notebook $DIRNAME/tools/
cp "$cwd"/update-notebooks $DIRNAME/tools/
sed -i "s,+++SETUP_SCRIPT+++,$DIRNAME/tools/setup.sh,g" $DIRNAME/tools/setup.sh
sed -i "s,+++ACTIVATE_SCRIPT+++,$DIRNAME/tools/activate.sh,g" $DIRNAME/tools/setup.sh
sed -i "s,+++STUDENT_FOLDER+++,$STUDENT_FOLDER,g" $DIRNAME/tools/setup.sh
sed -i "s,+++SOURCEDIR+++,$DIRNAME/exercises,g" $DIRNAME/tools/setup.sh
sed -i "s,+++PROJECTDIR+++,$DIRNAME/project,g" $DIRNAME/tools/setup.sh
sed -i "s,+++STUDENT_FOLDER+++,$STUDENT_FOLDER,g" $DIRNAME/tools/update-notebooks
sed -i "s,+++SOURCEDIR+++,$DIRNAME/exercises,g" $DIRNAME/tools/update-notebooks
sed -i "s,+++PROJECTDIR+++,$DIRNAME/project,g" $DIRNAME/tools/update-notebooks
# sed -i "s,+++SOURCEDIR+++,$DIRNAME/exercises,g" $DIRNAME/tools/notebook
sed -i "s,+++TOOLS_FOLDER+++,$DIRNAME/tools,g" $DIRNAME/tools/activate.sh

echo
echo "Ask the students to do: source $DIRNAME/tools/setup.sh"
echo "This is done only once."
echo
echo "To start a notebook do: notebook"
echo
