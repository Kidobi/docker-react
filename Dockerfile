# "as" is used to tag this phase of the build as "builder"
FROM node:alpine
WORKDIR '/app'
COPY package*.json ./
RUN npm install
# volumes setup not necessary, because we don't care about instant live changes in prod build
COPY ./ ./

# produce the package used by the next phase
# build package will be located in /app/build
RUN npm run build

# the FROM statement here specifies a new block in the Dockerfile. Each block can only have one FROM statement
FROM nginx

# EXPOSE usually does nothing. It's more of a note to devs that this port will need to be opened.
# however, services like elasticbeanstalk will use this to know what port to open on the container
EXPOSE 80

# --from tag allows copy from another stage/container
# syntax COPY --from=sourceStage <sourceDir> <destinationDir>
COPY --from=0 /app/build /usr/share/nginx/html
# NOTE: in this container, nginx automatically starts, so nothing needs to be run. Just need to copy the static HTML files