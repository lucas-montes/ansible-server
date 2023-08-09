.PHONY: rap rap-h restart-daemon

SHELL=/bin/bash
CONDA_ENV=devopsenv
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

PLAYBOOKS=ansible/playbooks
INVENTORY=ansible/inventory.yml
PASSWORDS=ansible/pssw.txt

rap:
	$(CONDA_ACTIVATE) $(CONDA_ENV) && ansible-playbook -i $(INVENTORY) --vault-password-file $(PASSWORDS) $(PLAYBOOKS)/$(ar).yml $(extra_vars)

rap-h:
	$(MAKE) rap ar=$(ar) extra_vars="-e 'host=hetzner' $(extra_vars)"

restart-daemon:
	$(MAKE) rap-h ar="systemd/restart_daemon" extra_vars="-e 'service=recsys'"

backup-recsys:
	$(MAKE) rap-h ar="database/backup" extra_vars="-e 'src="/home/lucas/recsys/recsys.sqlite"' -e 'dst="/home/lucas/Dev/rusty/webserver/backups"'"