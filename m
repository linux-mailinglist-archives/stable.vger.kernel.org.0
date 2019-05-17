Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F86D21482
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfEQHgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfEQHgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:36:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D290A206A3;
        Fri, 17 May 2019 07:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078566;
        bh=fe4yKD5TuAVtJNFdG4BGFSilr+Iq2y+qiJiUBay+hkA=;
        h=Date:From:To:Cc:Subject:From;
        b=gzfjkUNsWYoEmyzN5zkPX+5D/NLskBHjRW+QFI/ggzn5t7jACtLbKP+WyO8MYpV/3
         mlPvI4GT5MV6S32VrzidWm17mXEGpjY2oVUyO6msK+FgkqNzmnrhK5ejECdchtO/BO
         WDJHZfSGCeG/NUDNH4T0B8DiB5IR8uioBVvRGCyA=
Date:   Fri, 17 May 2019 09:36:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.120
Message-ID: <20190517073603.GA1114@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.120 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm64/boot/dts/marvell/armada-ap806.dtsi               |   17=20
 arch/arm64/kvm/hyp/tlb.c                                    |   35 +
 arch/mips/ath79/setup.c                                     |    6=20
 arch/mips/include/asm/processor.h                           |    2=20
 arch/powerpc/Makefile                                       |   31 -
 arch/powerpc/include/asm/reg_booke.h                        |    2=20
 arch/powerpc/kernel/idle_book3s.S                           |   20=20
 arch/powerpc/kernel/security.c                              |    1=20
 arch/s390/kernel/nospec-branch.c                            |    1=20
 arch/sparc/include/asm/switch_to_64.h                       |    3=20
 arch/sparc/kernel/process_64.c                              |   25 -
 arch/sparc/kernel/rtrap_64.S                                |    1=20
 arch/sparc/kernel/signal32.c                                |   12=20
 arch/sparc/kernel/signal_64.c                               |    6=20
 arch/sparc/mm/init_64.c                                     |    1=20
 arch/x86/entry/vdso/Makefile                                |    3=20
 arch/x86/include/asm/efi.h                                  |    6=20
 arch/x86/include/asm/fpu/api.h                              |   15=20
 arch/x86/kernel/fpu/core.c                                  |    6=20
 arch/x86/kernel/kprobes/core.c                              |   22=20
 arch/x86/kernel/reboot.c                                    |   21=20
 arch/x86/kvm/lapic.c                                        |    4=20
 arch/x86/kvm/trace.h                                        |    4=20
 arch/xtensa/boot/dts/xtfpga.dtsi                            |    2=20
 drivers/acpi/acpica/dsopcode.c                              |    4=20
 drivers/acpi/acpica/nsobject.c                              |    4=20
 drivers/base/devres.c                                       |   10=20
 drivers/clocksource/timer-oxnas-rps.c                       |    2=20
 drivers/gpu/drm/i915/intel_pm.c                             |   45 +
 drivers/gpu/drm/imx/ipuv3-crtc.c                            |    2=20
 drivers/gpu/drm/rockchip/cdn-dp-reg.c                       |    2=20
 drivers/gpu/drm/rockchip/rockchip_drm_psr.c                 |    4=20
 drivers/gpu/drm/sun4i/sun4i_drv.c                           |    2=20
 drivers/gpu/ipu-v3/ipu-dp.c                                 |   12=20
 drivers/hid/hid-input.c                                     |   14=20
 drivers/hwmon/pwm-fan.c                                     |    2=20
 drivers/iio/adc/xilinx-xadc-core.c                          |    2=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h                   |   35 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c                |    6=20
 drivers/input/mouse/elan_i2c_core.c                         |   25 +
 drivers/input/rmi4/rmi_driver.c                             |    6=20
 drivers/irqchip/irq-ath79-misc.c                            |   11=20
 drivers/isdn/mISDN/socket.c                                 |    4=20
 drivers/leds/leds-pwm.c                                     |    5=20
 drivers/md/bcache/super.c                                   |    3=20
 drivers/md/raid5.c                                          |   19=20
 drivers/media/cec/cec-api.c                                 |   19=20
 drivers/media/cec/cec-edid.c                                |   60 --
 drivers/media/i2c/adv7604.c                                 |    4=20
 drivers/media/i2c/adv7842.c                                 |    4=20
 drivers/media/i2c/ov5640.c                                  |   12=20
 drivers/net/Kconfig                                         |    4=20
 drivers/net/bonding/bond_options.c                          |    7=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |    2=20
 drivers/net/ethernet/freescale/fec_main.c                   |   30 -
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c           |    8=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c               |   15=20
 drivers/net/ethernet/mellanox/mlxsw/core.c                  |    6=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c    |    2=20
 drivers/net/ethernet/seeq/sgiseeq.c                         |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c           |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |   23=20
 drivers/net/phy/spi_ks8995.c                                |    9=20
 drivers/net/wireless/marvell/mwl8k.c                        |   13=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c         |    1=20
 drivers/net/wireless/st/cw1200/scan.c                       |    5=20
 drivers/nfc/st95hf/core.c                                   |    7=20
 drivers/nvdimm/btt_devs.c                                   |   18=20
 drivers/nvdimm/namespace_devs.c                             |    5=20
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
 drivers/scsi/raid_class.c                                   |    4=20
 drivers/staging/olpc_dcon/Kconfig                           |    1=20
 drivers/tty/vt/vt.c                                         |    2=20
 drivers/usb/serial/generic.c                                |   39 +
 drivers/virt/fsl_hypervisor.c                               |   29 -
 fs/btrfs/disk-io.c                                          |   51 --
 fs/cifs/smb2pdu.c                                           |    1=20
 fs/fuse/dev.c                                               |   12=20
 fs/kernfs/dir.c                                             |    5=20
 include/asm-generic/pgtable.h                               |   16=20
 include/linux/efi.h                                         |    7=20
 include/linux/kvm_host.h                                    |   10=20
 include/media/cec.h                                         |   70 ++
 include/net/netfilter/nf_conntrack.h                        |    2=20
 include/net/nfc/nci_core.h                                  |    2=20
 include/rdma/ib_verbs.h                                     |   34 -
 include/uapi/rdma/ib_user_verbs.h                           |   20=20
 include/uapi/rdma/vmw_pvrdma-abi.h                          |    1=20
 init/main.c                                                 |    4=20
 kernel/trace/trace.h                                        |   57 ++
 kernel/trace/trace_functions_graph.c                        |    4=20
 kernel/trace/trace_irqsoff.c                                |    2=20
 kernel/trace/trace_sched_wakeup.c                           |    2=20
 mm/memory.c                                                 |   11=20
 mm/vmscan.c                                                 |   29 -
 net/8021q/vlan_dev.c                                        |    4=20
 net/bridge/br_if.c                                          |   13=20
 net/core/dev.c                                              |    7=20
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
 net/netfilter/nf_tables_api.c                               |   19=20
 net/netfilter/x_tables.c                                    |    2=20
 net/nfc/nci/hci.c                                           |    8=20
 net/packet/af_packet.c                                      |   25 -
 net/sched/cls_tcindex.c                                     |   16=20
 net/tipc/socket.c                                           |    4=20
 net/wireless/nl80211.c                                      |   18=20
 security/integrity/ima/ima_crypto.c                         |   54 +-
 tools/lib/traceevent/event-parse.c                          |    2=20
 tools/testing/selftests/net/run_netsocktests                |    2=20
 tools/testing/selftests/netfilter/Makefile                  |    2=20
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh |  283 +++++++=
+++++
 virt/kvm/arm/mmu.c                                          |    8=20
 virt/kvm/irqchip.c                                          |    5=20
 virt/kvm/kvm_main.c                                         |    6=20
 133 files changed, 1368 insertions(+), 460 deletions(-)

Adit Ranadive (1):
      RDMA/vmw_pvrdma: Return the correct opcode when creating WR

Aditya Pakki (1):
      libnvdimm/btt: Fix a kmemdup failure check

Alexey Brodkin (1):
      devres: Align data[] to ARCH_KMALLOC_MINALIGN

Alistair Strachan (1):
      x86/vdso: Pass --eh-frame-hdr to the linker

Andrea Parri (1):
      kernfs: fix barrier usage in __kernfs_new_node()

Andrei Otcheretianski (1):
      mac80211: Increase MAX_MSG_LEN

Andy Duan (1):
      net: fec: manage ahb clock in runtime pm

Arnd Bergmann (2):
      s390: ctcm: fix ctcm_new_device error return code
      scsi: raid_attrs: fix unused variable warning

Breno Leitao (1):
      powerpc/64s: Include cpu header

Chris Wilson (1):
      drm/i915: Downgrade Gen9 Plane WM latency error

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Cong Wang (1):
      net_sched: fix two more memory leaks in cls_tcindex

Corentin Labbe (1):
      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filteri=
ng

Damian Kos (1):
      drm/rockchip: fix for mailbox read validation.

Dan Carpenter (4):
      NFC: nci: Add some bounds checking in nci_hci_cmd_received()
      nfc: nci: Potential off by one in ->pipes[] array
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (1):
      init: initialize jump labels before command line option parsing

Daniel Gomez (2):
      spi: Micrel eth switch: declare missing of table
      spi: ST ST95HF NFC: declare missing of table

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

David Miller (1):
      sparc64: Make corrupted user stacks more debuggable.

David S. Miller (1):
      sparc64: Export __node_distance.

Dmitry Torokhov (3):
      HID: input: add mapping for Expose/Overview key
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
      HID: input: add mapping for "Toggle Display" key

Enric Balletbo i Serra (1):
      drm/rockchip: psr: do not dereference encoder before it is null check=
ed.

Erik Schmauss (2):
      ACPICA: AML interpreter: add region addresses in global list during i=
nitialization
      ACPICA: Namespace: remove address node from global list after method =
termination

Felix Fietkau (2):
      mac80211: fix unaligned access in mesh table hash function
      mac80211: fix memory accounting with A-MSDU aggregation

Florian Westphal (3):
      selftests: netfilter: check icmp pkttoobig errors are set as related
      netfilter: ctnetlink: don't use conntrack/expect object addresses as =
id
      netfilter: nf_tables: warn when expr implements only one of activate/=
deactivate

Francesco Ruggeri (1):
      netfilter: compat: initialize all fields in xt_init

Goldwyn Rodrigues (1):
      ima: open a new file instance if no read permissions

Greg Kroah-Hartman (1):
      Linux 4.14.120

Guenter Roeck (1):
      s390/speculation: Fix build error caused by bad backport

Gustavo A. R. Silva (2):
      platform/x86: sony-laptop: Fix unintentional fall-through
      rtlwifi: rtl8723ae: Fix missing break in switch statement

Hangbin Liu (2):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_=
F_EXCL not supplied
      vlan: disable SIOCSHWTSTAMP in container

Hans Verkuil (4):
      media: cec: make cec_get_edid_spa_location() an inline function
      media: cec: integrate cec_validate_phys_addr() in cec-api.c
      media: adv7604: when the EDID is cleared, unconfigure CEC as well
      media: adv7842: when the EDID is cleared, unconfigure CEC as well

Harald Freudenberger (1):
      s390/pkey: add one more argument space for debug feature entry

Heinrich Schuchardt (1):
      arm64: dts: marvell: armada-ap806: reserve PSCI area

Huacai Chen (1):
      MIPS: VDSO: Reduce VDSO_RANDOMIZE_SIZE to 64MB for 64bit

Hugues Fruchet (2):
      media: ov5640: fix wrong binning value in exposure calculation
      media: ov5640: fix auto controls values when switching to manual mode

Ido Schimmel (4):
      mlxsw: spectrum_switchdev: Add MDB entries in prepare phase
      mlxsw: core: Do not use WQ_MEM_RECLAIM for EMAD workqueue
      mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw ordered workqueue
      mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw workqueue

Jan Kara (1):
      mm/memory.c: fix modifying of page protection by insert_pfn()

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Gunthorpe (1):
      IB/rxe: Revise the ib_wr_opcode enum

Jerome Brunet (1):
      leds: pwm: silently error out on EPROBE_DEFER

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

Jun Xiao (1):
      net: hns: Fix WARNING when hns modules installed

KT Liao (1):
      Input: elan_i2c - add hardware ID for multiple Lenovo laptops

Kangjie Lu (1):
      libnvdimm/namespace: Fix a potential NULL pointer dereference

Laurentiu Tudor (2):
      dpaa_eth: fix SG frame cleanup
      powerpc/booke64: set RI in default MSR

Lubomir Rintel (1):
      staging: olpc_dcon: add a missing dependency

Lucas Stach (2):
      gpu: ipu-v3: dp: fix CSC handling
      drm/imx: don't skip DP channel disable for background plane

Marc Zyngier (1):
      arm64: KVM: Make VHE Stage-2 TLB invalidation operations non-interrup=
tible

Martin Schwidefsky (2):
      s390/3270: fix lockdep false positive on view->lock
      mm: introduce mm_[p4d|pud|pmd]_folded

Masami Hiramatsu (1):
      x86/kprobes: Avoid kretprobe recursion bug

Matteo Croce (1):
      gtp: change NET_UDP_TUNNEL dependency to select

Max Filippov (1):
      xtensa: xtfpga.dtsi: fix dtc warnings about SPI

Miklos Szeredi (1):
      fuse: fix possibly missed wake-up after abort

Neil Armstrong (1):
      clocksource/drivers/oxnas: Fix OX820 compatible

Nicholas Piggin (1):
      powerpc: remove old GCC version checks

Nicolas Pitre (1):
      vt: always call notifier with the console lock held

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Omar Sandoval (1):
      Btrfs: fix missing delayed iputs on unmount

Pan Bian (1):
      Input: synaptics-rmi4 - fix possible double free

Paolo Abeni (1):
      net: don't keep lonely packets forever in the gro hash

Paolo Bonzini (1):
      KVM: fix spectrev1 gadgets

Parthasarathy Bhuvaragan (1):
      tipc: fix hanging clients using poll with EPOLLOUT flag

Paul Kocialkowski (1):
      drm/sun4i: Set device driver data at bind time for use in unbind

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Petr =C5=A0tetiar (2):
      MIPS: perf: ath79: Fix perfcount IRQ assignment
      mwl8k: Fix rate_idx underflow

Po-Hsu Lin (1):
      selftests/net: correct the return value for run_netsocktests

Punit Agrawal (1):
      KVM: arm/arm64: Ensure only THP is candidate for adjustment

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Ronnie Sahlberg (1):
      cifs: fix memory leak in SMB2_read

Russell Currey (1):
      powerpc/powernv/idle: Restore IAMR after idle

Sebastian Andrzej Siewior (1):
      x86/fpu: Don't export __kernel_fpu_{begin,end}()

Stefan Wahren (1):
      hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Steven Rostedt (VMware) (1):
      tracing/fgraph: Fix set_graph_function from showing interrupts

Sunil Dutt (1):
      nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

Sven Van Asbroeck (1):
      iio: adc: xilinx: fix potential use-after-free on remove

Tang Junhui (1):
      bcache: correct dirty data statistics

Tetsuo Handa (1):
      mISDN: Check address length before reading address family

Thierry Reding (1):
      net: stmmac: Move debugfs init/exit to ->probe()/->remove()

Thomas Bogendoerfer (1):
      net: seeq: fix crash caused by not set dev.parent

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Disable LP3 watermarks on all SNB machines

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered i=
n tracing

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

YueHaibing (2):
      net: dsa: Fix error cleanup path in dsa_init_module
      packet: Fix error path in packet_init


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzeZGMACgkQONu9yGCS
aT7ocBAAj9zCZqjAYZYemXyc9QKd28PunnEMTzbxGy+FUvqh4moaLNFLSwUxbyVo
2yIacbL8XCI9oum3LgOF11/sJe/hNJ/m8zYvp9CXWO4W3XhFjhVIIlMOLtYjhyho
dVpYlSMv/Re++O2Phq9mh+SBDikosyyCJZOGLRXo0yfZyzLsUqDCgON38LQN/sc/
0MErlYugHAMs4Unv0Laml3IhoCMGqxKxZgXBystX8Pb0X500C23PPUnLVzOrZ1rE
B/8K5LOczSctTVfgZI4pv6g/fdwLJxMxb8he6Y4UjGr7qnyqYfFkHU6JdI/B8a8p
n1SA7kr1uFw01xWerugwW4NljeeYp4cSCEGV9EXOUZpAYEJUzrh8hTBnU3206CMU
+ujyT75fZSC8oWRO7yGGq4J062lEezutASJkKXeih4vhEdsMgN3LiLOlQ71HXbNF
F3OPdS2zXYTbXk0JwTz+DRLxuSLOJ1f6RIpMSUtvxFV9hLaekzDjTaSV7GqnA/EX
tMbKy2xQA5x3W+akarJZKbmuQ4h8GPaL2A6j7kGGEARaAA5s892EaOidGH5wEDBF
Gar4HU5Qf0n9JZABOHgZv/NAOzHMBtDIVTcotRaSPkZk6IgLQmmEyRNlu5RfNZwP
Plrg8DBY2+i8PnLgQSvPmkPRa31P7CcU4jZmdPqxS+ED2URh4vk=
=GnmF
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
