<h1> Webserver deployment example using Habitat in HPE OneSphere environment </h1>

This repository is associated with a blog post that outlines steps for deploying a Nginx Habitat package on a public cloud VM and then deploying the same package on a Kubernetes cluster.

Here is a brief description of different sections included:

<p><b> 1- web-server-package </b><p>
Nginx webserver packaged with Habitat. Uses core/nginx as dependency and serves a simple webpage on port 80 when installed

<p><b> 2- web-server-recipe </b><p>
A Chef recipe to install the Habitat package for Nginx 

<p><b> 3- vm-install </b> <p>
A Python script example that deploys an AWS based VM in HPE OneSphere using API calls, deploys the Habitat package for Nginx webserver using the Chef recipe

<p><b> 4- k8s-install </b><p>
A manifest file used to deploy the Nginx Habitat pakage on a Kubernetes cluster
