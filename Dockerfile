# "as" is used to tag this phase of the build as "builder"
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
# volumes setup not necessary, because we don't care about instant live changes in prod build
COPY . .

# produce the package used by the next phase
# build package will be located in /app/build
RUN npm run build

# the FROM statement here specifies a new block in the Dockerfile. Each block can only have one FROM statement
FROM nginx
# --from tag allows copy from another stage/container
# syntax COPY --from=sourceStage <sourceDir> <destinationDir>
COPY --from=builder /app/build /usr/share/nginx/html
# NOTE: in this container, nginx automatically starts, so nothing needs to be run. Just need to copy the static HTML files