# ansible-playbook -i ../05.ansible/inventory/inventory.yaml ../../postgresql_cluster/deploy_pgcluster.yml -vvvvv
ansible-playbook -i ./inventory/inventory.yaml ./playbook/stage/pg.yaml
