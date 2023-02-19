
- Challenge 1

  Tinkered a bit with the code, in app.py and src/mongoflask.py

  Just a note, I found that pymongo 4.0 dropped support for python 2.7 and 3.4
  https://pymongo.readthedocs.io/en/stable/changelog.html#changes-in-version-4-0
  
  python 2.7 works, because the regexp used by pymongo to decide if python version is supported is:

  ERROR: pymongo requires Python '>=2.7,!=3.0.*,!=3.1.*,!=3.2.*,!=3.3.*,!=3.4.*

  So python 2.7 passed (>=), but 3.4 don't (!=)

- Challenge 2

  

- Challenge 3

  I added dockerfiles for both the api, and the mongodb import - basically to copy the restaurant dataset to the image.

  In a "real world" scenario, this won't be needed, as production database state will not be needed to be reloaded everytime, as we do here with ephemeral clusters. We would ensure DR as well with database backups

- Challenge 4

  I added another deployment for mongodb import

- Challenge 5

  Added a docker-compose file,in repo's root

- Challenge 6

  Added a makefile to streamline ops. It creates a kind cluster, in which everything gets deployed. make bootstrap will make it happen.

  Added some yaml manifests (yaml folder), as well as some extra features: metrics-server and grafana observability stack.

  

  