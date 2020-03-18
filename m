Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F01D1898CF
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgCRKDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCRKDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:03:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E45C20768;
        Wed, 18 Mar 2020 10:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525782;
        bh=d3Nv6gKIWfTjOsVVsLBR9W4CFx/G6zO4o6o6avWFX04=;
        h=Date:From:To:Cc:Subject:From;
        b=CyzQqS1uvkWC/w6gA6sUu5Ka55PQ+XAJa/9chpukR+abuhevLdovAX+cJHTkuXlZy
         mveHU9mn6IFDsexK9dPg+Wp/iTsSfXG0BJKMF+3Lv02b+MOS151hcoDT4HwqGVqUo2
         8YRpLPhcd8FZgFNoZqfeJvMJSlJjINz2qWozswYU=
Date:   Wed, 18 Mar 2020 11:02:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.10
Message-ID: <20200318100259.GA2035262@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.10 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/fsl-fman.txt      |    7=20
 Documentation/filesystems/porting.rst                   |    8=20
 Makefile                                                |    2=20
 arch/arc/include/asm/linkage.h                          |    2=20
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi      |    2=20
 arch/mips/boot/dts/ingenic/ci20.dts                     |   44 ++--
 arch/mips/kernel/setup.c                                |    3=20
 arch/x86/events/amd/uncore.c                            |   17 -
 arch/x86/kernel/cpu/mce/intel.c                         |    9=20
 arch/x86/kernel/cpu/mce/therm_throt.c                   |    9=20
 arch/x86/kvm/emulate.c                                  |    1=20
 arch/x86/kvm/vmx/nested.c                               |    5=20
 arch/x86/mm/ioremap.c                                   |   18 +
 block/blk-iocost.c                                      |    2=20
 block/genhd.c                                           |   36 +++
 drivers/base/platform.c                                 |   25 --
 drivers/block/virtio_blk.c                              |    8=20
 drivers/char/ipmi/ipmi_si_platform.c                    |    4=20
 drivers/firmware/efi/efivars.c                          |   32 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c            |    3=20
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c          |    3=20
 drivers/gpu/drm/i915/gt/intel_lrc.c                     |   29 +-
 drivers/gpu/drm/i915/gt/intel_timeline.c                |    8=20
 drivers/gpu/drm/i915/gvt/display.c                      |    3=20
 drivers/gpu/drm/i915/gvt/vgpu.c                         |   12 -
 drivers/gpu/drm/i915/i915_request.c                     |   28 +-
 drivers/gpu/drm/i915/i915_request.h                     |    2=20
 drivers/gpu/drm/i915/i915_utils.h                       |    5=20
 drivers/i2c/busses/i2c-designware-pcidrv.c              |    1=20
 drivers/i2c/busses/i2c-gpio.c                           |    2=20
 drivers/i2c/i2c-core-acpi.c                             |   10=20
 drivers/iommu/amd_iommu.c                               |    4=20
 drivers/iommu/dma-iommu.c                               |   16 -
 drivers/iommu/dmar.c                                    |   21 +-
 drivers/iommu/intel-iommu.c                             |   24 +-
 drivers/macintosh/windfarm_ad7417_sensor.c              |    7=20
 drivers/macintosh/windfarm_fcu_controls.c               |    7=20
 drivers/macintosh/windfarm_lm75_sensor.c                |   16 +
 drivers/macintosh/windfarm_lm87_sensor.c                |    7=20
 drivers/macintosh/windfarm_max6690_sensor.c             |    7=20
 drivers/macintosh/windfarm_smu_sat.c                    |    7=20
 drivers/mmc/host/sdhci-pci-gli.c                        |   17 +
 drivers/net/bonding/bond_alb.c                          |   20 -
 drivers/net/can/dev.c                                   |    1=20
 drivers/net/dsa/mv88e6xxx/chip.c                        |    2=20
 drivers/net/dsa/mv88e6xxx/global2.c                     |    8=20
 drivers/net/ethernet/broadcom/bcmsysport.c              |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c       |   24 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |   49 ++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c          |  110 ++++++++++
 drivers/net/ethernet/freescale/fec_main.c               |    6=20
 drivers/net/ethernet/freescale/fman/Kconfig             |   28 ++
 drivers/net/ethernet/freescale/fman/fman.c              |   18 +
 drivers/net/ethernet/freescale/fman/fman.h              |    5=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |   46 ++++
 drivers/net/ethernet/mscc/ocelot.c                      |   28 +-
 drivers/net/ethernet/mscc/ocelot_dev.h                  |    2=20
 drivers/net/ethernet/sfc/efx.c                          |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c    |    3=20
 drivers/net/ipvlan/ipvlan_core.c                        |   19 +
 drivers/net/ipvlan/ipvlan_main.c                        |    5=20
 drivers/net/macsec.c                                    |   12 -
 drivers/net/macvlan.c                                   |    2=20
 drivers/net/phy/bcm63xx.c                               |    1=20
 drivers/net/phy/phy.c                                   |    3=20
 drivers/net/phy/phy_device.c                            |   11 -
 drivers/net/slip/slhc.c                                 |   14 -
 drivers/net/team/team.c                                 |    2=20
 drivers/net/usb/r8152.c                                 |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c            |    3=20
 drivers/net/wireless/mediatek/mt76/dma.c                |    9=20
 drivers/pinctrl/core.c                                  |    1=20
 drivers/pinctrl/freescale/pinctrl-scu.c                 |    4=20
 drivers/pinctrl/meson/pinctrl-meson-gxl.c               |    4=20
 drivers/pinctrl/pinctrl-falcon.c                        |    2=20
 drivers/pinctrl/qcom/pinctrl-msm.c                      |    3=20
 drivers/s390/block/dasd.c                               |   27 ++
 drivers/s390/block/dasd_eckd.c                          |  163 +++++++++++=
++++-
 drivers/s390/block/dasd_int.h                           |   15 +
 drivers/s390/net/qeth_core_main.c                       |   14 -
 drivers/virtio/virtio_balloon.c                         |    2=20
 drivers/virtio/virtio_ring.c                            |    4=20
 fs/cifs/dir.c                                           |    1=20
 fs/crypto/keysetup.c                                    |    9=20
 fs/fuse/dev.c                                           |    6=20
 fs/fuse/fuse_i.h                                        |    2=20
 fs/gfs2/inode.c                                         |    2=20
 fs/open.c                                               |    3=20
 include/dt-bindings/clock/imx8mn-clock.h                |    4=20
 include/linux/cgroup.h                                  |    1=20
 include/linux/dmar.h                                    |    8=20
 include/linux/genhd.h                                   |   13 -
 include/linux/inet_diag.h                               |   18 +
 include/linux/phy.h                                     |    3=20
 include/linux/platform_device.h                         |    2=20
 include/net/fib_rules.h                                 |    1=20
 kernel/cgroup/cgroup.c                                  |   43 ++--
 kernel/pid.c                                            |    2=20
 kernel/trace/ftrace.c                                   |    2=20
 kernel/workqueue.c                                      |   14 -
 mm/memcontrol.c                                         |   14 -
 net/batman-adv/bat_iv_ogm.c                             |    4=20
 net/core/devlink.c                                      |   33 ++-
 net/core/netclassid_cgroup.c                            |   47 +++-
 net/core/sock.c                                         |    5=20
 net/dsa/dsa_priv.h                                      |    2=20
 net/dsa/port.c                                          |   44 +++-
 net/dsa/slave.c                                         |    8=20
 net/ieee802154/nl_policy.c                              |    6=20
 net/ipv4/gre_demux.c                                    |   12 -
 net/ipv4/inet_connection_sock.c                         |   20 +
 net/ipv4/inet_diag.c                                    |   44 +---
 net/ipv4/raw_diag.c                                     |    5=20
 net/ipv4/udp_diag.c                                     |    5=20
 net/ipv6/addrconf.c                                     |   51 +++--
 net/ipv6/ipv6_sockglue.c                                |   10=20
 net/netfilter/nf_conntrack_standalone.c                 |    2=20
 net/netfilter/nf_synproxy_core.c                        |    2=20
 net/netfilter/nf_tables_api.c                           |   22 +-
 net/netfilter/nfnetlink_cthelper.c                      |    2=20
 net/netfilter/nft_chain_nat.c                           |    1=20
 net/netfilter/nft_payload.c                             |    1=20
 net/netfilter/nft_tunnel.c                              |    2=20
 net/netfilter/x_tables.c                                |    6=20
 net/netfilter/xt_recent.c                               |    2=20
 net/netlink/af_netlink.c                                |    2=20
 net/nfc/hci/core.c                                      |   19 +
 net/nfc/netlink.c                                       |    4=20
 net/openvswitch/datapath.c                              |    1=20
 net/packet/af_packet.c                                  |   13 -
 net/sched/sch_fq.c                                      |    1=20
 net/sched/sch_taprio.c                                  |   13 -
 net/sctp/diag.c                                         |    8=20
 net/smc/smc_ib.c                                        |    3=20
 net/tipc/netlink.c                                      |    1=20
 net/wireless/nl80211.c                                  |    5=20
 sound/pci/hda/patch_realtek.c                           |  163 ++++++++++-=
-----
 tools/perf/bench/futex-wake.c                           |    4=20
 tools/testing/ktest/ktest.pl                            |    2=20
 tools/testing/selftests/net/fib_tests.sh                |   34 +++
 142 files changed, 1419 insertions(+), 498 deletions(-)

Al Viro (2):
      cifs_atomic_open(): fix double-put on late allocation failure
      gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache

Amol Grover (1):
      iommu/vt-d: Fix RCU list debugging warnings

Andrew Lunn (2):
      net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed
      net: dsa: mv88e6xxx: Add missing mask of ATU occupancy register

Anson Huang (1):
      clk: imx8mn: Fix incorrect clock defines

Artem Savkov (1):
      ftrace: Return the first found result in lookup_rec()

Ben Chuang (1):
      mmc: sdhci-pci-gli: Enable MSI interrupt for GL975x

Charles Keepax (1):
      pinctrl: core: Remove extra kref_get which blocks hogs being freed

Chris Wilson (5):
      drm/i915: Actually emit the await_start
      drm/i915: Return early for await_start on same timeline
      drm/i915: Defer semaphore priority bumping to a workqueue
      drm/i915/gt: Close race between cacheline_retire and free
      drm/i915/execlists: Enable timeslice on partial virtual engine dequeue

Christoph Hellwig (1):
      driver code: clarify and fix platform device DMA mask allocation

Colin Ian King (2):
      net: systemport: fix index check to avoid an array out of bounds acce=
ss
      drm/amd/display: remove duplicated assignment to grph_obj_type

Corey Minyard (1):
      pid: Fix error return value in some cases

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Dan Moulding (1):
      iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

Daniel Drake (1):
      iommu/vt-d: Ignore devices with out-of-spec domain number

Dmitry Bogdanov (1):
      net: macsec: update SCI upon MAC address change.

Dmitry Yakunin (2):
      cgroup, netclassid: periodically release file_lock on classid updating
      inet_diag: return classid for all socket types

Edward Cree (1):
      sfc: detach from cb_page in efx_copy_channel()

Edwin Peer (1):
      bnxt_en: fix error handling when flashing from file

Eric Biggers (1):
      fscrypt: don't evict dirty inodes after removing key

Eric Dumazet (6):
      gre: fix uninit-value in __iptunnel_pull_header
      ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
      slip: make slhc_compress() more robust against malicious packets
      bonding/alb: make sure arp header is pulled before accessing it
      net: memcg: fix lockdep splat in inet_csk_accept()
      ipv6: restrict IPV6_ADDRFORM operation

Eugeniy Paltsev (1):
      ARC: define __ALIGN_STR and __ALIGN symbols for ARC

Felix Fietkau (1):
      mt76: fix array overflow on receiving too many fragments for a packet

Florian Fainelli (1):
      net: phy: Avoid multiple suspends

Florian Westphal (2):
      netfilter: nf_tables: fix infinite loop when expr is not available
      netfilter: nf_tables: free flowtable hooks on hook register error

Greg Kroah-Hartman (1):
      Linux 5.5.10

H. Nikolaus Schaller (2):
      MIPS: DTS: CI20: fix PMU definitions for ACT8600
      MIPS: DTS: CI20: fix interrupt for pcf8563 RTC

Halil Pasic (1):
      virtio-blk: fix hw_queue stopped on arbitrary error

Hamish Martin (1):
      i2c: gpio: suppress error on probe defer

Hangbin Liu (5):
      ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface
      net/ipv6: use configured metric when add peer route
      net/ipv6: need update peer route when modify metric
      net/ipv6: remove the old peer route if change it to a new one
      selftests/net/fib_tests: update addr_metric_test for peer route testi=
ng

Hans de Goede (3):
      iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_wa=
rn + add_taint
      iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint
      iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT with pr_warn + ad=
d_taint

Heiner Kallweit (2):
      net: phy: avoid clearing PHY interrupts twice in irq handler
      net: phy: fix MDIO bus PM PHY resuming

Hillf Danton (1):
      workqueue: don't use wq_select_unbound_cpu() for bound works

Jakub Kicinski (23):
      net: fec: validate the new settings in fec_enet_set_coalesce()
      devlink: validate length of param values
      devlink: validate length of region addr/len
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      can: add missing attribute validation for termination
      macsec: add missing attribute validation for port
      openvswitch: add missing attribute validation for hash
      net: fq: add missing attribute validation for orphan mask
      net: taprio: add missing attribute validation for txtime delay
      team: add missing attribute validation for port ifindex
      team: add missing attribute validation for array index
      tipc: add missing attribute validation for MTU property
      nfc: add missing attribute validation for SE API
      nfc: add missing attribute validation for deactivate target
      nfc: add missing attribute validation for vendor subcommand
      nl80211: add missing attribute validation for critical protocol indic=
ation
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch
      netfilter: cthelper: add missing attribute validation for cthelper
      netfilter: nft_payload: add missing attribute validation for payload =
csum flags
      netfilter: nft_tunnel: add missing attribute validation for tunnels

Jarkko Nikula (1):
      i2c: designware-pci: Fix BUG_ON during device removal

Jian Shen (3):
      net: hns3: fix a not link up issue when fibre port supports autoneg
      net: hns3: fix RMW issue for VLAN filter switch
      net: hns3: clear port base VLAN when unload PF

Jiri Wiesner (1):
      ipvlan: do not add hardware address of master to its unicast filter l=
ist

Jonas Gorski (1):
      net: phy: bcm63xx: fix OOPS due to missing driver name

Julian Wiedmann (2):
      s390/qeth: don't reset default_out_queue
      s390/qeth: handle error when backing RX buffer

Kailang Yang (2):
      ALSA: hda/realtek - Add Headset Mic supported for HP cPC
      ALSA: hda/realtek - Fixed one of HP ALC671 platform Headset Mic suppo=
rted

Karsten Graul (2):
      net/smc: cancel event worker during device removal
      net/smc: check for valid ib_client_data

Kim Phillips (1):
      perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT =
flag

Leonard Crestez (1):
      pinctrl: imx: scu: Align imx sc msg structs to 4

Linus Walleij (1):
      pinctrl: qcom: Assign irq_eoi conditionally

Madalin Bucur (4):
      dt-bindings: net: FMan erratum A050385
      arm64: dts: ls1043a: FMan erratum A050385
      fsl/fman: detect FMan erratum A050385
      dpaa_eth: FMan erratum A050385 workaround

Mahesh Bandewar (3):
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      ipvlan: don't deref eth hdr before checking it's set
      macvlan: add cond_resched() during multicast processing

Marc Zyngier (1):
      iommu/dma: Fix MSI reservation allocation

Mathias Kresin (1):
      pinctrl: falcon: fix syntax error

Matthew Auld (1):
      drm/i915: be more solid in checking the alignment

Michal Koutn=FD (1):
      cgroup: Iterate tasks that did not finish do_exit()

Miklos Szeredi (1):
      fuse: fix stack use after return

Nathan Chancellor (1):
      virtio_balloon: Adjust label in virtballoon_probe

Nicolas Belin (1):
      pinctrl: meson-gxl: fix GPIOX sdio pins

Pablo Neira Ayuso (3):
      netlink: Use netlink header as base to calculate bad attribute offset
      netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
      netfilter: nft_chain_nat: inet family is missing module ownership

Paul Cercueil (1):
      MIPS: Fix CONFIG_MIPS_CMDLINE_DTB_EXTEND handling

Qian Cai (2):
      cgroup: fix psi_show() crash on 32bit ino archs
      iommu/vt-d: Fix RCU-list bugs in intel_iommu_init()

Remi Pommarel (1):
      net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used

Russell King (2):
      net: dsa: fix phylink_start()/phylink_stop() calls
      net: dsa: mv88e6xxx: fix lockup on warm boot

Shakeel Butt (2):
      cgroup: memcg: net: do not associate sock with unrelated cgroup
      net: memcg: late association of sock to memcg

Shin'ichiro Kawasaki (1):
      block: Fix partition support for host aware zoned block devices

Stefan Haberland (1):
      s390/dasd: fix data corruption for thin provisioned devices

Steven Rostedt (VMware) (1):
      ktest: Add timeout for ssh sync testing

Suman Anna (1):
      virtio_ring: Fix mem leak with vring_new_virtqueue()

Suravee Suthikulpanit (1):
      iommu/amd: Fix IOMMU AVIC not properly update the is_run bit in IRTE

Sven Eckelmann (1):
      batman-adv: Don't schedule OGM for disabled interface

Takashi Iwai (2):
      ALSA: hda/realtek - More constifications
      ipmi_si: Avoid spurious errors for optional IRQs

Tejun Heo (1):
      blk-iocost: fix incorrect vtime comparison in iocg_is_idle()

Thomas Gleixner (1):
      x86/mce/therm_throt: Undo thermal polling properly on CPU offline

Tina Zhang (1):
      drm/i915/gvt: Fix dma-buf display blur issue on CFL

Tom Lendacky (1):
      x86/ioremap: Map EFI runtime services data as encrypted for SEV

Tommi Rantala (1):
      perf bench futex-wake: Restore thread count default to online CPU cou=
nt

Tony Luck (1):
      x86/mce: Fix logic and comments around MSR_PPIN_CTL

Vasily Averin (5):
      cgroup: cgroup_procs_next should increase position index
      netfilter: nf_conntrack: ct_cpu_seq_next should increase position ind=
ex
      netfilter: synproxy: synproxy_cpu_seq_next should increase position i=
ndex
      netfilter: xt_recent: recent_seq_next should increase position index
      netfilter: x_tables: xt_mttg_seq_next should increase position index

Vasundhara Volam (1):
      bnxt_en: reinitialize IRQs when MTU is modified

Vinicius Costa Gomes (1):
      taprio: Fix sending packets without dequeueing them

Vishal Kulkarni (1):
      cxgb4: fix checks for max queues to allocate

Vitaly Kuznetsov (2):
      KVM: x86: clear stale x86_emulate_ctxt->intercept value
      KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs

Vladimir Oltean (1):
      net: mscc: ocelot: properly account for VLAN header length when setti=
ng MRU

Vladis Dronov (2):
      efi: Fix a race and a buffer overflow while reading efivars via sysfs
      efi: Add a sanity check to efivar_store_raw()

Willem de Bruijn (1):
      net/packet: tpacket_rcv: do not increment ring index on drop

Wolfram Sang (2):
      macintosh: windfarm: fix MODINFO regression
      i2c: acpi: put device when verifying client fails

Yonghyun Hwang (1):
      iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page

Yonglong Liu (1):
      net: hns3: fix "tc qdisc del" failed issue

You-Sheng Yang (1):
      r8152: check disconnect status after long sleep

Zhenyu Wang (1):
      drm/i915/gvt: Fix unnecessary schedule timer when no vGPU exits

Zhenzhong Duan (1):
      iommu/vt-d: Fix the wrong printing in RHSA parsing


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5x8dMACgkQONu9yGCS
aT7R8g//cce3/puWG0YFCHdLmBUJZ60ET3o29vMflCrd8vYxz7wOndDd2gCZ0bev
wwsQIF2inrcqDOa31lXwlVUmqlonoGzjOYaSfbPajJxVsUHzxYKeonQPqfIimKoq
q0WU/vgkQOhzzDB0yQOO6xRYLmN6pmsocYqot8olFWj19Jb3ggQ44jAmbreX26wG
41VtNAiX6QfViN8HLhvATrDZtOZ5xoWGuR03YwXHGJCSx5bZHM3GY40a/2NGAPIH
rKOUuZ+oYd03Cqt+0mG+MBSqAw26TFe/ZXks8ayOWtdkEMWIJSZg6kibdyzE9AiJ
WswRjeWBgsAy6RtmSIlwxBmPTZVlwQT8X46e6P7KGclGJJtOG2efxHLltlPiePzO
sSaT2sGmj61/RMrKjiN/j+cT+No8oFKqt6/sY1A0OdNiTJNFDfiIGYFQ7gi0r32K
Pi0Q9QaTYOv1dsltxb0u5p1arGsrDBazyCu+WIkbBJmddszr0Np0oVZ6UYvNLS+1
bZl0ucfl6L2BYd10Nd/wRFvKPigH6wdMlccRHaG829V3l5h4HkSnaX1JGC09tyLQ
p9Im6ei70rcu1nIIAF79t1+vOszX8yfLyihKiWyDVp/RDvzt1TCaIDI7G0+Xg6KN
7SBZ039i+OqyTygrizQMXJDtegN1Jb4Id+SVoCvNBGKkrI5VuHQ=
=EsnX
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
