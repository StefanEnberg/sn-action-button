#!/bin/bash -x

# To stop execution instantly as a query exits while having a non-zero status
# To know the error location in the running code
set -e

# Get the version of the installed @playwright/test
playwrightVersion=$(npm list @playwright/test | awk '{print $2}' | cut -d "@" -f3 | sed -n 2p)

# Create and start the container with the name *sn-action-button-playwright*
# using the Docker host network stack and binding your current directory
# in the background in a “detached” mod and remove the container once it exits/stops
# The -it instructs Docker to allocate a pseudo-TTY connected to the container’s stdin;
# creating an interactive bash shell in the container
docker run -d --name sn-action-button-playwright --rm --network host -v $(pwd):/work/ -w /work/ -it mcr.microsoft.com/playwright:v$playwrightVersion-focal

# The actual generate/update the reference screenshots is running from the machine running this shell script
docker exec sn-action-button-playwright /bin/sh -c "yarn test:rendering --update-snapshots"

docker stop sn-action-button-playwright
