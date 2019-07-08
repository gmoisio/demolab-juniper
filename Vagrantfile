# -*- mode: ruby -*-
# vi: set ft=ruby :
# Gilbert MOISIO 2019

## Define port mapping to build the Fabric
spine_port_map = {  1 => [1,3],
                    2 => [2,4] }

leaf_port_map  = {  1 => [1,2],
                    2 => [3,4] }

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

#######################
# Spine configuration #
#######################
  (1..2).each do |id|
    re_name  = ( "spine0" + id.to_s ).to_sym
    config.vm.define re_name do |vqfx|
      vqfx.vm.host_name = "spine0#{id}"
      vqfx.vm.box = "gmoisio/vQFX-re"
      vqfx.vm.box_version = "18.4"
# Do not remove / No VMtools installed
      vqfx.vm.synced_folder ".", "/vagrant", disabled: true
# Management port (em1 / em2)
      vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "vqfx_internal_#{id}"
      vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"
# (em3, em4)
      (1..2).each do |seg_id|
        vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "non_used"
      end
# (em5, em6)
      (0..1).each do |seg_id|
        vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "seg#{spine_port_map[id][seg_id]}"
      end
    end
  end

#######################
# Leaf configuration  #
#######################
  (1..2).each do |id|
    re_name  = ( "leaf0" + id.to_s ).to_sym
    config.vm.define re_name do |vqfx|
      vqfx.vm.host_name = "leaf0#{id}"
      vqfx.vm.box = "gmoisio/vQFX-re"
      vqfx.vm.box_version = "18.4"
# Do not remove / No VMtools installed
      vqfx.vm.synced_folder ".", "/vagrant", disabled: true
# Management port (em1 / em2)
      vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "vqfx_internal_#{id}"
      vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"
# (em3, em4)
      (1..2).each do |seg_id|
        vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "non_used"
      end
# (em5, em6)
      (0..1).each do |seg_id|
        vqfx.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "seg#{leaf_port_map[id][seg_id]}"
      end
    end
  end

#######################
# Box provisioning    #
#######################
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.groups = {
                "qfx"          => ["spine01", "spine02", "leaf01", "leaf02"],
                "spine"        => ["spine01", "spine02"],
                "leaf"         => ["leaf01", "leaf02"],
                "all:children" => ["qfx"]
            }
    ansible.playbook = "site.yml"
    ansible.tags = "ospf"
  end

end
