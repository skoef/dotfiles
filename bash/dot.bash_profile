# Startup file for login instances of the bash(1) shell.

# First of all, run a .bashrc file if it exists.
if [ -f ${HOME}/.bashrc ]
then
	source ${HOME}/.bashrc
fi
