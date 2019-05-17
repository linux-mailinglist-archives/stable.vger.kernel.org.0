Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD52421488
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfEQHg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfEQHg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:36:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C146420873;
        Fri, 17 May 2019 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078586;
        bh=XT8tOfCt+F5P9zZJZV/q64PZuvZXJT/uqrZB16P30N8=;
        h=Date:From:To:Cc:Subject:From;
        b=baJhWZVORXxkn+6RlUFq/6sy7tkL9lu6vE25ckQBqPz3OzzEcB5Pt/n+k3IyREFcR
         JcZxenQ5e8LJ1gyC0YBhzD5+ftHbTZN8VhMdRM2cOYsldhJyeIxsaFZXrDfH1B2mo/
         8rEMpkRfDFFdP9Py7YHlqn7oPv7bck9CLVsz2c8E=
Date:   Fri, 17 May 2019 09:36:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.44
Message-ID: <20190517073623.GA4137@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.44 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm/kernel/head-nommu.S                                |    2=20
 arch/mips/ath79/setup.c                                     |    6=20
 arch/powerpc/include/asm/book3s/64/pgalloc.h                |    3=20
 arch/powerpc/include/asm/reg_booke.h                        |    2=20
 arch/powerpc/kernel/idle_book3s.S                           |   20=20
 arch/powerpc/kernel/security.c                              |    1=20
 arch/powerpc/kernel/smp.c                                   |   90 +--
 arch/um/drivers/port_user.c                                 |    2=20
 arch/x86/kernel/kprobes/core.c                              |   22=20
 arch/x86/kernel/reboot.c                                    |   21=20
 arch/x86/kernel/vmlinux.lds.S                               |    2=20
 arch/x86/kvm/lapic.c                                        |    4=20
 arch/x86/kvm/trace.h                                        |    4=20
 block/bfq-iosched.c                                         |    8=20
 block/blk-mq.c                                              |    2=20
 drivers/acpi/nfit/core.c                                    |   12=20
 drivers/char/ipmi/ipmi_si_hardcode.c                        |    2=20
 drivers/clocksource/Kconfig                                 |    1=20
 drivers/clocksource/timer-oxnas-rps.c                       |    2=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |   19=20
 drivers/gpu/drm/amd/display/dc/dc.h                         |    3=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c                |    9=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h                |    6=20
 drivers/gpu/drm/imx/ipuv3-crtc.c                            |    2=20
 drivers/gpu/drm/sun4i/sun4i_drv.c                           |    7=20
 drivers/gpu/ipu-v3/ipu-dp.c                                 |   12=20
 drivers/hid/hid-input.c                                     |   14=20
 drivers/hwmon/pwm-fan.c                                     |    2=20
 drivers/iio/adc/xilinx-xadc-core.c                          |    3=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                     |    2=20
 drivers/input/rmi4/rmi_driver.c                             |    6=20
 drivers/irqchip/irq-ath79-misc.c                            |   11=20
 drivers/isdn/gigaset/bas-gigaset.c                          |    9=20
 drivers/isdn/mISDN/socket.c                                 |    4=20
 drivers/md/raid5.c                                          |   19=20
 drivers/net/bonding/bond_options.c                          |    7=20
 drivers/net/dsa/mv88e6xxx/port.c                            |   24 -
 drivers/net/ethernet/cadence/macb_main.c                    |    6=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |    2=20
 drivers/net/ethernet/freescale/fec_main.c                   |   30 -
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c           |    8=20
 drivers/net/ethernet/mellanox/mlxsw/core.c                  |    6=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c    |    2=20
 drivers/net/ethernet/mscc/ocelot.c                          |    2=20
 drivers/net/ethernet/neterion/vxge/vxge-config.c            |    1=20
 drivers/net/ethernet/qlogic/qede/qede_ptp.c                 |    7=20
 drivers/net/ethernet/seeq/sgiseeq.c                         |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c           |    2=20
 drivers/net/phy/spi_ks8995.c                                |    9=20
 drivers/net/tun.c                                           |   14=20
 drivers/net/wireless/marvell/mwl8k.c                        |   13=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c         |    1=20
 drivers/net/wireless/st/cw1200/scan.c                       |    5=20
 drivers/nfc/st95hf/core.c                                   |    7=20
 drivers/nvdimm/btt_devs.c                                   |   18=20
 drivers/nvdimm/namespace_devs.c                             |    5=20
 drivers/nvdimm/pmem.c                                       |    8=20
 drivers/pci/controller/pci-hyperv.c                         |   23=20
 drivers/platform/x86/dell-laptop.c                          |    6=20
 drivers/platform/x86/sony-laptop.c                          |    8=20
 drivers/platform/x86/thinkpad_acpi.c                        |   72 ++-
 drivers/s390/block/dasd_eckd.c                              |    6=20
 drivers/s390/char/con3270.c                                 |    2=20
 drivers/s390/char/fs3270.c                                  |    3=20
 drivers/s390/char/raw3270.c                                 |    3=20
 drivers/s390/char/raw3270.h                                 |    4=20
 drivers/s390/char/tty3270.c                                 |    3=20
 drivers/s390/crypto/pkey_api.c                              |    3=20
 drivers/s390/net/ctcm_main.c                                |    1=20
 drivers/scsi/aic7xxx/aic7770_osm.c                          |    1=20
 drivers/scsi/aic7xxx/aic7xxx.h                              |    1=20
 drivers/scsi/aic7xxx/aic7xxx_osm.c                          |   10=20
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c                      |    1=20
 drivers/usb/serial/generic.c                                |   39 +
 drivers/usb/typec/typec_wcove.c                             |    9=20
 drivers/virt/fsl_hypervisor.c                               |   29 -
 drivers/virt/vboxguest/vboxguest_core.c                     |   31 +
 fs/afs/write.c                                              |    1=20
 fs/kernfs/dir.c                                             |    5=20
 include/linux/efi.h                                         |    7=20
 include/linux/elevator.h                                    |    1=20
 include/linux/kvm_host.h                                    |   10=20
 include/net/netfilter/nf_conntrack.h                        |    2=20
 include/net/nfc/nci_core.h                                  |    2=20
 init/main.c                                                 |    4=20
 mm/memory.c                                                 |   11=20
 mm/memory_hotplug.c                                         |    1=20
 mm/vmscan.c                                                 |   29 -
 net/8021q/vlan_dev.c                                        |    4=20
 net/bridge/br_if.c                                          |   13=20
 net/core/fib_rules.c                                        |    6=20
 net/dsa/dsa.c                                               |   11=20
 net/ipv4/raw.c                                              |    4=20
 net/ipv6/sit.c                                              |    2=20
 net/mac80211/mesh_pathtbl.c                                 |    2=20
 net/mac80211/trace_msg.h                                    |    7=20
 net/mac80211/tx.c                                           |    3=20
 net/netfilter/ipvs/ip_vs_core.c                             |    2=20
 net/netfilter/nf_conntrack_core.c                           |   35 +
 net/netfilter/nf_conntrack_netlink.c                        |   34 +
 net/netfilter/nf_conntrack_proto.c                          |    2=20
 net/netfilter/nf_tables_api.c                               |   11=20
 net/nfc/nci/hci.c                                           |    8=20
 net/packet/af_packet.c                                      |   25 -
 net/strparser/strparser.c                                   |   12=20
 net/tipc/socket.c                                           |    4=20
 net/tls/tls_device.c                                        |    5=20
 net/wireless/nl80211.c                                      |   18=20
 net/wireless/reg.c                                          |   39 +
 security/selinux/hooks.c                                    |    8=20
 tools/lib/traceevent/event-parse.c                          |    2=20
 tools/testing/selftests/net/fib_tests.sh                    |   94 +--
 tools/testing/selftests/net/run_netsocktests                |    2=20
 tools/testing/selftests/netfilter/Makefile                  |    2=20
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh |  283 +++++++=
+++++
 virt/kvm/irqchip.c                                          |    5=20
 virt/kvm/kvm_main.c                                         |    6=20
 118 files changed, 1112 insertions(+), 379 deletions(-)

Aditya Pakki (1):
      libnvdimm/btt: Fix a kmemdup failure check

Andrea Parri (1):
      kernfs: fix barrier usage in __kernfs_new_node()

Andrei Otcheretianski (1):
      mac80211: Increase MAX_MSG_LEN

Andrei Vagin (1):
      netfilter: fix nf_l4proto_log_invalid to log invalid packets

Andy Duan (1):
      net: fec: manage ahb clock in runtime pm

Arnd Bergmann (2):
      clocksource/drivers/npcm: select TIMER_OF
      s390: ctcm: fix ctcm_new_device error return code

Breno Leitao (1):
      powerpc/64s: Include cpu header

Christoph Hellwig (1):
      scsi: aic7xxx: fix EISA support

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Claudiu Manoil (1):
      ocelot: Don't sleep in atomic context (irqs_disabled())

Colin Ian King (2):
      vxge: fix return of a free'd memblock on a failed dma mapping
      qede: fix write to free'd pointer error and double free of ptp

Corentin Labbe (1):
      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filteri=
ng

Dan Carpenter (5):
      netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
      NFC: nci: Add some bounds checking in nci_hci_cmd_received()
      nfc: nci: Potential off by one in ->pipes[] array
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (2):
      acpi/nfit: Always dump _DSM output payload
      init: initialize jump labels before command line option parsing

Daniel Gomez (2):
      spi: Micrel eth switch: declare missing of table
      spi: ST ST95HF NFC: declare missing of table

David Ahern (2):
      selftests: fib_tests: Fix 'Command line is not complete' errors
      ipv4: Fix raw socket lookup for local traffic

David Francis (1):
      drm/amd/display: If one stream full updates, full update all planes

David Hildenbrand (1):
      mm/memory_hotplug.c: drop memory device reference after find_memory_b=
lock()

Dexuan Cui (3):
      PCI: hv: Fix a memory leak in hv_eject_device_work()
      PCI: hv: Add hv_pci_remove_slots() when we unload the driver
      PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if nec=
essary

Dmitry Torokhov (3):
      HID: input: add mapping for Expose/Overview key
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
      HID: input: add mapping for "Toggle Display" key

Felix Fietkau (2):
      mac80211: fix unaligned access in mesh table hash function
      mac80211: fix memory accounting with A-MSDU aggregation

Florian Westphal (2):
      selftests: netfilter: check icmp pkttoobig errors are set as related
      netfilter: ctnetlink: don't use conntrack/expect object addresses as =
id

Greg Kroah-Hartman (1):
      Linux 4.19.44

Gustavo A. R. Silva (3):
      platform/x86: sony-laptop: Fix unintentional fall-through
      usb: typec: Fix unchecked return value
      rtlwifi: rtl8723ae: Fix missing break in switch statement

Hangbin Liu (2):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_=
F_EXCL not supplied
      vlan: disable SIOCSHWTSTAMP in container

Hans de Goede (1):
      virt: vbox: Sanity-check parameter types for hgcm-calls coming from u=
serspace

Harald Freudenberger (1):
      s390/pkey: add one more argument space for debug feature entry

Harini Katakam (1):
      net: macb: Change interrupt and napi enable order in open

Heiner Kallweit (1):
      net: dsa: mv88e6xxx: fix few issues in mv88e6390x_port_set_cmode

Ido Schimmel (4):
      mlxsw: spectrum_switchdev: Add MDB entries in prepare phase
      mlxsw: core: Do not use WQ_MEM_RECLAIM for EMAD workqueue
      mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw ordered workqueue
      mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw workqueue

Ilan Peer (1):
      cfg80211: Handle WMM rules in regulatory domain intersection

Jakub Kicinski (2):
      net/tls: fix the IV leaks
      net: strparser: partially revert "strparser: Call skb_unclone conditi=
onally"

Jan Kara (1):
      mm/memory.c: fix modifying of page protection by insert_pfn()

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Wang (2):
      tuntap: fix dividing by zero in ebpf queue selection
      tuntap: synchronize through tfiles array instead of tun->numqueues

Jens Axboe (1):
      bfq: update internal depth state when queue depth changes

Jian-Hong Pan (1):
      x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Jiaxun Yang (1):
      platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Johan Hovold (1):
      USB: serial: fix unthrottle races

Johannes Weiner (1):
      mm: fix inactive list balancing between NUMA nodes and cgroups

Julian Anastasov (1):
      ipvs: do not schedule icmp errors from tunnels

Kangjie Lu (1):
      libnvdimm/namespace: Fix a potential NULL pointer dereference

Laurentiu Tudor (2):
      dpaa_eth: fix SG frame cleanup
      powerpc/booke64: set RI in default MSR

Li RongQing (1):
      libnvdimm/pmem: fix a possible OOB access when read and write pmem

Lijun Ou (1):
      RDMA/hns: Bugfix for mapping user db

Lucas Stach (2):
      gpu: ipu-v3: dp: fix CSC handling
      drm/imx: don't skip DP channel disable for background plane

Marc Dionne (1):
      afs: Unlock pages for __pagevec_release()

Mario Limonciello (1):
      platform/x86: dell-laptop: fix rfkill functionality

Martin Leung (1):
      drm/amd/display: extending AUX SW Timeout

Martin Schwidefsky (1):
      s390/3270: fix lockdep false positive on view->lock

Masami Hiramatsu (1):
      x86/kprobes: Avoid kretprobe recursion bug

Neil Armstrong (1):
      clocksource/drivers/oxnas: Fix OX820 compatible

Nicholas Piggin (2):
      powerpc/smp: Fix NMI IPI timeout
      powerpc/smp: Fix NMI IPI xmon timeout

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Pablo Neira Ayuso (1):
      netfilter: nf_tables: use-after-free in dynamic operations

Pan Bian (1):
      Input: synaptics-rmi4 - fix possible double free

Paolo Abeni (1):
      selinux: do not report error on connect(AF_UNSPEC)

Paolo Bonzini (1):
      KVM: fix spectrev1 gadgets

Parthasarathy Bhuvaragan (1):
      tipc: fix hanging clients using poll with EPOLLOUT flag

Paul Bolle (1):
      isdn: bas_gigaset: use usb_fill_int_urb() properly

Paul Kocialkowski (3):
      drm/sun4i: Set device driver data at bind time for use in unbind
      drm/sun4i: Fix component unbinding and component master deletion
      drm/sun4i: Unbind components before releasing DRM and memory

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Petr =C5=A0tetiar (2):
      MIPS: perf: ath79: Fix perfcount IRQ assignment
      mwl8k: Fix rate_idx underflow

Po-Hsu Lin (1):
      selftests/net: correct the return value for run_netsocktests

Rick Lindsley (1):
      powerpc/book3s/64: check for NULL pointer in pgd_alloc()

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Ritesh Raj Sarraf (1):
      um: Don't hardcode path as it is architecture dependent

Russell Currey (1):
      powerpc/powernv/idle: Restore IAMR after idle

Sami Tolvanen (1):
      x86/build/lto: Fix truncated .bss with -fdata-sections

Stefan Wahren (1):
      hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Sunil Dutt (1):
      nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

Sven Van Asbroeck (3):
      iio: adc: xilinx: fix potential use-after-free on remove
      iio: adc: xilinx: fix potential use-after-free on probe
      iio: adc: xilinx: prevent touching unclocked h/w on remove

Taehee Yoo (1):
      netfilter: nf_tables: add missing ->release_ops() in error path of ne=
wrule()

Tetsuo Handa (1):
      mISDN: Check address length before reading address family

Thomas Bogendoerfer (1):
      net: seeq: fix crash caused by not set dev.parent

Tigran Tadevosyan (1):
      ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU i=
s disabled

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Tony Camuso (1):
      ipmi: ipmi_si_hardcode.c: init si_type array to fix a crash

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered i=
n tracing

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

YueHaibing (2):
      net: dsa: Fix error cleanup path in dsa_init_module
      packet: Fix error path in packet_init


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzeZHcACgkQONu9yGCS
aT75UA/9F646ESS4pNxcPSFd/e7UqeAT+Dzp6o7lz9aNaRo55Be03fgsjuMNYYq8
WR61eXrFYWjyuiUanbQFQvyYgq7Ff1OZx8jqvzXTppczV+oGffyLRwRT7ZBT6WEs
JQnmcREhEOLBXsq64qPLO9+vNQaF+gRQsGNeAssihp49P5qkA5IZN9z2o4Qqkr+4
eVxRpSB93ON8IWHfEEPk686rnQ0gnZGLnHZ2D6dWGu6hKVd93k72XVXCntrpAATx
2KAVn5pIza/9WuupvSDoj4lyPUX/Kqv3bP1GkG+KMON4i/6wB90vEB6lb7yXws3B
Igxu3N8ByCXCrwpfaxSsoE7IbyjS2l2fanUyzwInM1kF5O6TJ3ogBdeDXavRaAlH
1dnn7FJdjcm8bZSlXuP74n4vOuaVLkgcEt+Py3q25izE70t7rHdmg5k+/T8yzpEb
4NA+7nCTpRDQqsfvNIj1a0fgsPqva+3EBWmhi8chvI42S8SJiOSbWcJOtqyHQwQq
tZJjqndFi+EZskC/TlfVMT4QxEUOuMZ1Tdk2DSa1kfxVIE8H/o/VvSZhDRJQ5hkh
fpK87FjHINulEv6yeqocPdaKCPtgJVzM0RRKtTsPCsRN3CHc23VEIaiOiRkwSzUV
ju+QETdt7sIwJiaBkUXB3aHVhUnhl4c4toaVW2FKSzGxm6mQGlw=
=SupD
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
