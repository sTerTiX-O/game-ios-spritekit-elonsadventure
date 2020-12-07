
# Build the Docker image defined in ./@docker
docker build -t proutechos/elonsadventure-server ./@docker




# ----------------------------------------------------------------------
#
#
#  Things that work, but I don't really know why (why is the CMD specified on the command-line executed inside the container; what is the ENTRYPOINT it gets appended to)
#
#
# ----------------------------------------------------------------------


# Run a container for a single task (specified using the last parameter)
# Remarks:
#   the container is detroyed after the task execution thanks to "-rm" (one would need to "docker rm" it without this option)
docker run --rm --name container001 proutechos/elonsadventure-server bash -c "ls -laG /opt/proutechos"

# Run a container for a list of tasks (specified using the last parameter)
# Remark:
#   Each execution start from a clean slate (which the first 'ls' shows)
docker run --rm --name container001 proutechos/elonsadventure-server bash -c "ls -laG /opt/proutechos; touch /opt/proutechos/coucou.txt; ls -laG /opt/proutechos"








# ----------------------------------------------------------------------
#
#
#  Python server execution (fixed / generic with default parameters / generic with specific parameters)  
#
#
# ----------------------------------------------------------------------


# Run a container and:
#   - execute its entrypoint (which executes a *fixed* python server; cf 'entrypoint-gameServer.sh')
#   - kill the container when it's done executing the entrypoint
# REMARK: Add '--interactive --tty / -it' if you want to be able to Ctrl+C it
docker run --rm -it --name container001 proutechos/elonsadventure-server 

# Run a container and:
#   - execute its entrypoint (which executes a *generic* python server (cf 'entrypoint-python-generic.sh'), but DOESN'T OVERRIDE its default CMD parameter)
# REMARK: Add '--interactive --tty / -it' if you want to be able to Ctrl+C it
docker run --rm -it --name container001 proutechos/elonsadventure-server --entrypoint "./@docker/entrypoint-python-generic.sh"

# Run a container and:
#   - execute its entrypoint (which executes a *generic* python server (cf 'entrypoint-python-generic.sh'), and OVERRIDES its default CMD parameter to choose a specific python server)
# REMARK: Add '--interactive --tty / -it' if you want to be able to Ctrl+C it
docker run --rm -it --name container001 proutechos/elonsadventure-server --entrypoint "./@docker/entrypoint-python-generic.sh" game-elonsadventure-server




# ----------------------------------------------------------------------
#
#
#  DEBUGGING Python server 'docker image'
#
#
# ----------------------------------------------------------------------


# Run a container and:
#   - enter it in interactive mode using /bin/bash *INSTEAD OF* executing its entrypoint
#
# REMARK: passing "/bin/bash" as the last argument of this command doens't work because
#         the image has en entrypoint defined
docker run --rm -it --entrypoint "/bin/bash" --name container001 proutechos/elonsadventure-server

# Run a container and:
#   - execute its entrypoint (which MUST end with a sleep 3600, so that the container 'waits')
#   - enter it in interactive mode using /bin/bash
docker run -it --name "container001" proutechos/elonsadventure-server
docker exec -it "container001" /bin/bash

