Selinux
=========

* Manage Selinux State
* Build and install selinux modules from `.te` templates

Requirements
------------

Required packages are installed by this role.

* `checkpolicy`
* `policycoreutils-python`
* `policycoreutils`
* `libselinux-python`

Role Variables
--------------

~~~yaml
# manage selinux state as defined by selinux_state
manage_selinux_state: True

# disabled, enforcing or permissive
selinux_state: enforcing

## Example:
selinux_modules:
  - name: xyz
    template: xyz.te # optional
    rebuild: True # optional, default: False
~~~

Example Playbook
----------------

~~~yaml
- hosts: servers
  roles:
      - { role: mwojtowicz.semodule }
~~~

Example task to install single Selinux Module from another role
----------------------------------------

File: `roles/zabbix_agent/tasks/main.yml`

~~~yaml
- name: Install zabbix_agent_t selinux module from template
  vars:
    selinux_module: zabbix_agent_t
  import_role:
    name: mwojtowicz.semodule
    tasks_from: semodule.yml
~~~

Selinux template can be placed in `roles/zabbix_agent/templates/zabbix_agent_t.te`

Template Search paths: <https://docs.ansible.com/ansible/latest/user_guide/playbook_pathing.html#the-magic-of-local-paths>

License
-------

MIT
