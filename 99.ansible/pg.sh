# ANSIBLE_FORCE_COLOR=1 -i ../05.ansible/inventory/inventory.yaml ../../postgresql_cluster/deploy_pgcluster.yml -vvvvv
ANSIBLE_FORCE_COLOR=1 -i ./inventory/inventory.yaml ./playbook/stage/pg.yaml
