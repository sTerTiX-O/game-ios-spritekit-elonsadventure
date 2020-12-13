


# ================================================================================================
#
#
#     Voir le document créé à l'occasion "Docker le bases", stocké sur Google Drive
#
#     https://docs.google.com/document/d/1KgPMkyNNpRPKiaV5ZWbptvcm8EnoIRL0stxTvjFw1tk/edit#heading=h.qd1ku6pizov2
#
#
# ================================================================================================




# Select the project
gcloud auth login "nicolas.fonrose@teevity.com"
gcloud config set project "teevity-sandbox-240308"

# Configure the default CloudRun parameters
gcloud config set run/platform "managed"
gcloud config set run/region "europe-west1"

# Ensure Docker can push images to Google Cloud Container Registry
# cf https://cloud.google.com/run/docs/setup
gcloud auth configure-docker "eu.gcr.io" -q

# Push the docker image 
#  - Tag the image with a 'remote repository URL'
#    Remark: when you execute 'docker image ls', you now see twice the image with two different names (but the same 'IMAGE ID')
docker image tag proutechos/elonsadventure-server:latest eu.gcr.io/teevity-sandbox-240308/proutechos/elonsadventure-server:latest
docker push "eu.gcr.io/teevity-sandbox-240308/proutechos/elonsadventure-server:latest"

# Create a CloudRun service with the image we have just pushed
gcloud run deploy "teevity-sandbox-python-elonsadventure-gameserver-service" \
             --image "eu.gcr.io/teevity-sandbox-240308/proutechos/elonsadventure-server@sha256:cde24b17e3aa318ca68df6f6d432e7ec5c9f8e652f04474bbeb9cfa0ec9cf3b7" \
             --platform "managed" \
             --region "europe-west1" \
             --concurrency "80" \
             --max-instances "1" \
             --cpu "1" \
             --memory "128M" \
             --port "7500" \
             --timeout "1m30s" \
             --labels "env=sandbox,project=elonsadventure-gameserver,owner=nicolas,shouldbedeleted=20201213_2200" \
             --set-env-vars "GAMEOPTION001=OFF"
# Remark: only available in beta
             --min-instances "0" \
# Remark: only available in alpha 
             --use-http2 \



# ----------------------------------------------------------------------
#
#
#  CloudRun "Service creation + initialization" 
#
#
# ----------------------------------------------------------------------


# ddd
docker run --rm --name container001 proutechos/elonsadventure-server bash -c "ls -laG /opt/proutechos"




