.PHONY: rap rap-h restart-daemon

SHELL=/bin/bash
CONDA_ENV=devopsenv
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

PLAYBOOKS=ansible/playbooks
INVENTORY=ansible/inventory.yml
PASSWORDS=ansible/pssw.txt
VAULT=ansible/vault.yml

add-role:
	mkdir ansible/roles/$(arg)
	mkdir ansible/roles/$(arg)/defaults
	touch ansible/roles/$(arg)/defaults/main.yml
	mkdir ansible/roles/$(arg)/handlers
	touch ansible/roles/$(arg)/handlers/main.yml
	mkdir ansible/roles/$(arg)/tasks
	touch ansible/roles/$(arg)/tasks/main.yml
	mkdir ansible/roles/$(arg)/templates
	touch ansible/roles/$(arg)/templates/main.yml

rav:
	$(CONDA_ACTIVATE) $(CONDA_ENV) && ansible-vault edit $(VAULT) --vault-password-file $(PASSWORDS)

rap:
	$(CONDA_ACTIVATE) $(CONDA_ENV) && ansible-playbook -i $(INVENTORY) --vault-password-file $(PASSWORDS) $(PLAYBOOKS)/$(ar).yml $(extra_vars)

rap-h:
	$(MAKE) rap ar=$(ar) extra_vars="-e 'host=hetzner' $(extra_vars)"

restart-daemon:
	$(MAKE) rap-h ar="systemd/restart_daemon" extra_vars="-e 'service=recsys'"

backup-recsys:
	$(MAKE) rap-h ar="database/backup" extra_vars="-e 'src="/home/lucas/recsys/recsys.sqlite"' -e 'dst="/home/lucas/Dev/rusty/webservice/backups"'"