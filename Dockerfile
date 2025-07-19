#############################################################################
## build demo from source
FROM node:latest AS build

## set working dir
WORKDIR /app

## copy src
COPY . .

## build demo from src
RUN npm install && npm run demo

#############################################################################
## build the final image with demo
FROM httpd:alpine AS final
#FROM httpd:latest AS final

## set apache www root as workding dir
WORKDIR /usr/local/apache2/htdocs/

## copy demo files into www root
COPY --chmod=nobody:nogroup --from=build /app/demo ./

## (annoyingly) index.css has 0600 permissions
RUN find . -type d -exec chmod 0755 {} \; && find . -type f -exec chmod 0644 {} \;

## add metadata via labels
LABEL com.vmware.eocto.version="0.0.1"
LABEL com.vmware.eocto.git.repo="git@github.com:grumpydumpty/markdown-it.git"
LABEL com.vmware.eocto.git.commit="DEADBEEF"
LABEL com.vmware.eocto.maintainer.name="Richard Croft"
LABEL com.vmware.eocto.maintainer.email="arjaycroft@gmail.com"
LABEL com.vmware.eocto.released="9999-99-99"
LABEL com.vmware.eocto.based-on="httpd:alpine"
LABEL com.vmware.eocto.project="markdown-it"
