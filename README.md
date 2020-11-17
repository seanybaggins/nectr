# nectr
Never Ending Container Throwing Robot. 

A template for a self hosted nginx server with Jenkins and AWS integration.

The nectr project uses docker-compose to create containers for each service (ex. nginx, jenkins). Adding another service to your server simply requires appending some lines of code to the `docker/stacks/lanuch-server.yml` file.

## Architecture

See the [architecture document](./docs/nectr-architecture.md)

## Deploying

See the [deploy instructions](./docs/nectr-deploy-instructions.md)
