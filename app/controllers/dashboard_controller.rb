class DashboardController < ApplicationController

  def index
    @r = LovelyRethink.db

    json_string = '{"timestamp":1378935477,"version":"1.0","payload":[{"LONGTERM":{"Processes.qmgr.postfix.mem":3328,"Processes.mcelog.root.cpu":0,"Processes.irqbalance.root.iowritekbytes":0,"Processes.rpc\\.statd.rpcuser.mem":1332,"Processes.abrtd.root.ioreadkbytes":8192,"Disk./dev/sda1.fs.total":507744256,"Processes.udevd.root.cpu":18,"Disk./dev/dm-0.fs.free":5444661248,"Processes.dhclient.root.count":1,"Network.Interface.eth0.tx_bytes":30935,"Processes.crond.root.cpu":104,"Processes.login.root.iowritekbytes":12288,"Processes.prltoolsd.root.mem":932,"Processes.acpid.root.cpu":1,"Processes.rsyslogd.root.iowritekbytes":73728,"CPU.cpu3.wait":30,"Processes.master.root.mem":3308,"Disk./dev/sda1.fs.ifree":127970,"Processes.login.root.mem":2664,"Processes.linode-longview.root.count":1,"Processes.hald.haldaemon.mem":3996,"Processes.hald.haldaemon.ioreadkbytes":921600,"Processes.mcelog.root.ioreadkbytes":0,"Disk./dev/dm-0.fs.total":8000811008,"Disk./dev/dm-0.fs.itotal":496784,"Processes.irqbalance.root.count":1,"Disk./dev/dm-1.writes":2,"Processes.sshd.root.mem":1172,"Processes.rsyslogd.root.count":1,"Processes.mingetty.root.cpu":1,"Processes.certmonger.root.count":1,"Processes.bash.root.mem":1944,"Processes.prltoolsd.root.cpu":6,"Processes.cupsd.root.iowritekbytes":4096,"Processes.init.root.iowritekbytes":253952,"Processes.dhclient.root.cpu":0,"CPU.cpu2.wait":51,"Network.Interface.eth0.rx_bytes":341156,"Processes.auditd.root.mem":804,"Processes.bash.root.count":1,"Processes.hald.haldaemon.cpu":13,"Processes.dbus-daemon.dbus.count":1,"Processes.rpc\\.statd.rpcuser.count":1,"Processes.qmgr.postfix.iowritekbytes":0,"Disk./dev/dm-0.writes":1509,"Processes.certmonger.root.cpu":0,"Processes.qmgr.postfix.count":1,"Processes.acpid.root.count":1,"Processes.acpid.root.mem":632,"CPU.cpu3.user":101,"Processes.master.root.count":1,"Processes.atd.root.iowritekbytes":4096,"Processes.mingetty.root.iowritekbytes":4096,"Processes.prltoolsd.root.iowritekbytes":0,"Processes.atd.root.count":1,"Processes.acpid.root.ioreadkbytes":16384,"Processes.crond.root.count":1,"Processes.init.root.count":1,"Processes.sshd.root.ioreadkbytes":0,"Processes.linode-longview.root.ioreadkbytes":155648,"Processes.console-kit-dae.root.iowritekbytes":12288,"Processes.pickup.postfix.mem":3288,"Processes.sshd.root.count":1,"Processes.hald-addon-inpu.root.cpu":4,"Processes.crond.root.iowritekbytes":0,"Processes.prltoolsd.root.count":2,"Processes.sshd.root.iowritekbytes":4096,"Processes.udevd.root.ioreadkbytes":14356480,"Processes.hald-runner.root.mem":1152,"Processes.certmonger.root.mem":604,"Processes.pickup.postfix.cpu":0,"Processes.dhclient.root.iowritekbytes":4096,"Processes.cupsd.root.count":1,"Processes.abrtd.root.iowritekbytes":4096,"Processes.hald-runner.root.count":1,"Processes.rpcbind.rpc.count":1,"Processes.rpc\\.idmapd.root.mem":524,"Disk./dev/sda1.writes":10,"Processes.mingetty.root.ioreadkbytes":0,"Processes.rpc\\.statd.rpcuser.iowritekbytes":4096,"Processes.hald-runner.root.cpu":0,"CPU.cpu2.user":101,"Processes.hald-addon-acpi.haldaemon.mem":1040,"CPU.cpu0.wait":74,"Processes.dbus-daemon.dbus.mem":1216,"Processes.mingetty.root.mem":2688,"Processes.login.root.cpu":17,"Processes.dbus-daemon.dbus.cpu":6,"Processes.cupsd.root.mem":3320,"Memory.real.cache":72808,"Processes.auditd.root.iowritekbytes":8192,"Processes.init.root.cpu":114,"Processes.crond.root.mem":1384,"CPU.cpu3.system":237,"Processes.hald-addon-acpi.haldaemon.count":1,"CPU.cpu0.user":235,"CPU.cpu1.user":61,"Processes.dbus-daemon.dbus.iowritekbytes":0,"Processes.hald-addon-inpu.root.ioreadkbytes":32768,"Memory.real.used":227652,"Processes.qmgr.postfix.ioreadkbytes":311296,"Memory.real.free":1691116,"Processes.init.root.ioreadkbytes":68711424,"Processes.pickup.postfix.ioreadkbytes":237568,"Processes.abrtd.root.count":1,"Processes.login.root.count":1,"Processes.dbus-daemon.dbus.ioreadkbytes":0,"Processes.rpc\\.idmapd.root.cpu":0,"Processes.udevd.root.iowritekbytes":0,"Processes.linode-longview.root.cpu":87,"Processes.hald-addon-acpi.haldaemon.ioreadkbytes":24576,"Processes.bash.root.ioreadkbytes":6475776,"Processes.prltoolsd.root.ioreadkbytes":8192,"Processes.rpcbind.rpc.mem":916,"Processes.console-kit-dae.root.cpu":3,"Processes.pickup.postfix.count":1,"Processes.master.root.cpu":2,"Processes.automount.root.iowritekbytes":8192,"Processes.rsyslogd.root.ioreadkbytes":401408,"Processes.hald-addon-acpi.haldaemon.iowritekbytes":0,"Processes.crond.root.ioreadkbytes":32768,"Processes.automount.root.count":1,"Processes.abrtd.root.mem":892,"Processes.irqbalance.root.ioreadkbytes":0,"Processes.udevd.root.count":3,"Processes.hald-addon-acpi.haldaemon.cpu":0,"Processes.qmgr.postfix.cpu":0,"CPU.cpu1.wait":7,"Processes.master.root.ioreadkbytes":12288,"Processes.certmonger.root.ioreadkbytes":0,"Processes.atd.root.mem":484,"Memory.swap.free":4128760,"Processes.dhclient.root.mem":680,"Processes.rpc\\.idmapd.root.iowritekbytes":0,"Processes.console-kit-dae.root.mem":3216,"Processes.rpc\\.idmapd.root.count":1,"Processes.mingetty.root.count":5,"Processes.mcelog.root.iowritekbytes":4096,"Processes.rsyslogd.root.mem":1584,"Processes.hald-runner.root.iowritekbytes":0,"Processes.automount.root.ioreadkbytes":913408,"Processes.udevd.root.mem":6372,"Processes.cupsd.root.cpu":2,"Processes.abrtd.root.cpu":0,"Processes.atd.root.ioreadkbytes":4096,"Disk./dev/dm-0.reads":5894,"Processes.rpcbind.rpc.cpu":2,"Processes.dhclient.root.ioreadkbytes":0,"Processes.rsyslogd.root.cpu":2,"Processes.rpcbind.rpc.iowritekbytes":0,"Processes.cupsd.root.ioreadkbytes":729088,"Disk./dev/sda1.fs.free":441424896,"Processes.rpcbind.rpc.ioreadkbytes":593920,"Memory.real.buffers":16252,"Processes.hald.haldaemon.iowritekbytes":4096,"Disk./dev/dm-0.fs.ifree":409028,"Processes.atd.root.cpu":0,"Processes.hald-addon-inpu.root.count":1,"Processes.sshd.root.cpu":0,"Processes.automount.root.cpu":1,"Memory.swap.used":0,"Processes.rpc\\.statd.rpcuser.ioreadkbytes":4096,"Processes.login.root.ioreadkbytes":565248,"Processes.mcelog.root.count":1,"Disk./dev/sda1.fs.itotal":128016,"CPU.cpu2.system":316,"Processes.linode-longview.root.iowritekbytes":45056,"CPU.cpu0.system":572,"Processes.linode-longview.root.mem":22732,"Processes.console-kit-dae.root.ioreadkbytes":339968,"Processes.hald-runner.root.ioreadkbytes":417792,"Processes.certmonger.root.iowritekbytes":4096,"Processes.hald-addon-inpu.root.iowritekbytes":0,"Processes.irqbalance.root.mem":596,"Disk./dev/dm-1.reads":322,"Processes.hald.haldaemon.count":1,"Processes.auditd.root.ioreadkbytes":8192,"Processes.hald-addon-inpu.root.mem":1092,"Processes.acpid.root.iowritekbytes":4096,"Processes.rpc\\.idmapd.root.ioreadkbytes":0,"Processes.bash.root.cpu":9,"Processes.irqbalance.root.cpu":1,"Processes.init.root.mem":1536,"Processes.pickup.postfix.iowritekbytes":0,"Processes.auditd.root.count":1,"Disk./dev/sda1.reads":914,"Processes.console-kit-dae.root.count":1,"Processes.bash.root.iowritekbytes":20480,"Processes.rpc\\.statd.rpcuser.cpu":3,"Processes.master.root.iowritekbytes":8192,"CPU.cpu1.system":247,"Processes.automount.root.mem":1764,"Load":0.23,"Processes.auditd.root.cpu":0,"Processes.mcelog.root.mem":432},"timestamp":1378935477,"INSTANT":{"Network.mac_addr":"00:1c:42:09:b5:1c","Uptime":220.82,"Disk./dev/dm-0.mounted":1,"SysInfo.os.dist":"Centos","Disk./dev/dm-1.childof":0,"Disk./dev/sda1.dm":0,"Disk./dev/sda1.children":0,"Disk./dev/dm-1.isswap":1,"Disk./dev/dm-1.dm":0,"Disk./dev/dm-0.childof":0,"Disk./dev/dm-1.label":"VolGroup-lv_swap","SysInfo.cpu.type":"Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz","Disk./dev/sda1.childof":0,"Disk./dev/sda1.mounted":1,"Disk./dev/dm-0.fs.path":"/","Ports.active":[],"Disk./dev/dm-0.isswap":0,"Disk./dev/sda1.fs.path":"/boot","SysInfo.cpu.cores":4,"SysInfo.hostname":"localhost.localdomain","Disk./dev/sda1.isswap":0,"SysInfo.type":"kvm","Disk./dev/dm-1.children":0,"Disk./dev/dm-0.dm":0,"Disk./dev/dm-0.label":"VolGroup-lv_root","Ports.listening":[{"ip":"::1","user":"root","name":"master","type":"tcp6","port":25},{"ip":"::","user":"root","name":"sshd","type":"tcp6","port":22},{"ip":"0.0.0.0","user":"root","name":"sshd","type":"tcp","port":22},{"ip":"::1","user":"root","name":"cupsd","type":"tcp6","port":631},{"ip":"0.0.0.0","user":"rpcuser","name":"rpc.statd","type":"udp","port":49120},{"ip":"0.0.0.0","user":"rpc","name":"rpcbind","type":"udp","port":647},{"ip":"0.0.0.0","user":"rpcuser","name":"rpc.statd","type":"udp","port":666},{"ip":"::","user":"rpc","name":"rpcbind","type":"udp6","port":111},{"ip":"0.0.0.0","user":"rpcuser","name":"rpc.statd","type":"tcp","port":59638},{"ip":"::","user":"rpcuser","name":"rpc.statd","type":"udp6","port":51072},{"ip":"0.0.0.0","user":"rpc","name":"rpcbind","type":"tcp","port":111},{"ip":"::","user":"rpcuser","name":"rpc.statd","type":"tcp6","port":56385},{"ip":"0.0.0.0","user":"root","name":"dhclient","type":"udp","port":68},{"ip":"0.0.0.0","user":"rpc","name":"rpcbind","type":"udp","port":111},{"ip":"::","user":"rpc","name":"rpcbind","type":"udp6","port":647},{"ip":"0.0.0.0","user":"root","name":"cupsd","type":"udp","port":631},{"ip":"127.0.0.1","user":"root","name":"cupsd","type":"tcp","port":631},{"ip":"::","user":"rpc","name":"rpcbind","type":"tcp6","port":111},{"ip":"127.0.0.1","user":"root","name":"master","type":"tcp","port":25}],"Disk./dev/dm-1.mounted":0,"SysInfo.client":"1.0.0","SysInfo.kernel":"Linux 2.6.32-358.18.1.el6.x86_64","SysInfo.arch":"x86_64","Disk./dev/dm-0.children":0,"SysInfo.os.distversion":"6.4"}}],"apikey":"F74FA40E-EA58-3953-7AF69D263BA4E07F"}'
    obj = JSON::parse(json_string)

    # (0..1000).each do |i|
    #   @r.table('longterm').insert(obj['payload'][0]["LONGTERM"]).run(:durability=>"soft")
    #   @r.table('instant').insert(obj['payload'][0]["INSTANT"]).run(:durability=>"soft")
    # end

    @longterms = @r.table('longterm').count.run

  end

end
