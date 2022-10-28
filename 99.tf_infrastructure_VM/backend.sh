terraform init -reconfigure \
    -backend-config="access_key='$(cat ./secrets/access_key)'" \
    -backend-config="access_key='$(cat ./secrets/secret_key)'" \
