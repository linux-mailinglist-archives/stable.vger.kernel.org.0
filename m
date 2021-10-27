Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2BF43C525
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbhJ0Ibs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240957AbhJ0IbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B00B610C8;
        Wed, 27 Oct 2021 08:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635323336;
        bh=axvrfxh/Xsv5bFBGQEsNBiQQS40dfat4WFzSvTaIM8g=;
        h=From:To:Cc:Subject:Date:From;
        b=jtpc8On8GXbUUJk7Ahs3neSpiq6wPO3O/HzhH8oL6roZfhj4j0v5mcy9hQqORJ49v
         7tUuu+K+xvC23z7UJNJt7+21Xrr0NGONcYFd9RosouPjXtwWDsw817+zH7yj/PWWPD
         ZQNhaMB/9uBSGOJJNYAG4CH2v2oJ0TjDGy3wKL/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.76
Date:   Wed, 27 Oct 2021 10:28:48 +0200
Message-Id: <163532332876161@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.76 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                          |    2 
 arch/arm/Kconfig                                                  |    1 
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts                       |    1 
 arch/arm/boot/dts/spear3xx.dtsi                                   |    2 
 arch/arm/boot/dts/vexpress-v2m.dtsi                               |    2 
 arch/arm/boot/dts/vexpress-v2p-ca9.dts                            |    2 
 arch/nios2/include/asm/irqflags.h                                 |    4 
 arch/nios2/include/asm/registers.h                                |    2 
 arch/parisc/math-emu/fpudispatch.c                                |   56 +++
 arch/powerpc/kernel/idle_book3s.S                                 |  148 ++++----
 arch/powerpc/kernel/smp.c                                         |    2 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                           |   28 -
 arch/s390/include/asm/pci.h                                       |    3 
 arch/s390/pci/pci.c                                               |   45 ++
 arch/s390/pci/pci_event.c                                         |    4 
 arch/x86/events/msr.c                                             |    1 
 arch/x86/kvm/vmx/vmx.c                                            |   17 
 arch/x86/xen/enlighten.c                                          |    9 
 arch/xtensa/platforms/xtfpga/setup.c                              |   12 
 block/blk-mq-debugfs.c                                            |    1 
 drivers/gpu/drm/amd/display/Kconfig                               |    2 
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                                 |    6 
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c                     |   12 
 drivers/input/keyboard/snvs_pwrkey.c                              |   29 +
 drivers/isdn/capi/kcapi.c                                         |    5 
 drivers/isdn/hardware/mISDN/netjet.c                              |    2 
 drivers/net/can/rcar/rcar_can.c                                   |   20 -
 drivers/net/can/sja1000/peak_pci.c                                |    9 
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c                        |    5 
 drivers/net/dsa/lantiq_gswip.c                                    |    2 
 drivers/net/dsa/mt7530.c                                          |    8 
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c              |    2 
 drivers/net/ethernet/hisilicon/hns3/hnae3.c                       |   21 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                       |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                   |   37 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                   |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c            |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c           |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c             |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c         |    6 
 drivers/net/ethernet/intel/e1000e/e1000.h                         |    4 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                       |   31 +
 drivers/net/ethernet/intel/e1000e/ich8lan.h                       |    3 
 drivers/net/ethernet/intel/e1000e/netdev.c                        |   29 -
 drivers/net/ethernet/intel/ice/ice_common.c                       |    2 
 drivers/net/ethernet/intel/ice/ice_devids.h                       |    4 
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c                    |    4 
 drivers/net/ethernet/intel/ice/ice_main.c                         |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c               |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                 |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c             |    8 
 drivers/net/phy/mdio_bus.c                                        |    1 
 drivers/net/usb/Kconfig                                           |    1 
 drivers/pci/hotplug/s390_pci_hpc.c                                |    9 
 drivers/pinctrl/stm32/pinctrl-stm32.c                             |    4 
 drivers/platform/x86/intel_scu_ipc.c                              |    2 
 drivers/scsi/hosts.c                                              |    3 
 drivers/scsi/qla2xxx/qla_bsg.c                                    |    2 
 drivers/scsi/scsi_transport_iscsi.c                               |    2 
 drivers/usb/host/xhci-pci.c                                       |    4 
 drivers/usb/host/xhci-ring.c                                      |   26 +
 drivers/usb/host/xhci.h                                           |    1 
 fs/btrfs/tree-log.c                                               |   47 +-
 fs/ceph/caps.c                                                    |   12 
 fs/ceph/file.c                                                    |    1 
 fs/ceph/inode.c                                                   |    2 
 fs/ceph/mds_client.c                                              |   17 
 fs/ceph/super.c                                                   |   17 
 fs/ceph/super.h                                                   |    3 
 fs/io_uring.c                                                     |    2 
 fs/kernel_read_file.c                                             |    2 
 fs/nfsd/nfsctl.c                                                  |    5 
 fs/ocfs2/alloc.c                                                  |   46 --
 fs/ocfs2/super.c                                                  |   14 
 fs/userfaultfd.c                                                  |   12 
 include/linux/elfcore.h                                           |    2 
 include/sound/hda_codec.h                                         |    1 
 kernel/auditsc.c                                                  |    2 
 kernel/dma/debug.c                                                |   12 
 kernel/sched/core.c                                               |    1 
 kernel/trace/ftrace.c                                             |    4 
 kernel/trace/trace.h                                              |   61 +--
 kernel/trace/trace_functions.c                                    |    2 
 mm/slub.c                                                         |   17 
 net/bpf/test_run.c                                                |   14 
 net/bridge/br_private.h                                           |    4 
 net/can/isotp.c                                                   |   45 +-
 net/can/j1939/j1939-priv.h                                        |    1 
 net/can/j1939/main.c                                              |    7 
 net/can/j1939/transport.c                                         |   14 
 net/ipv4/tcp_ipv4.c                                               |   19 -
 net/ipv6/ip6_output.c                                             |    3 
 net/ipv6/netfilter/ip6t_rt.c                                      |   48 --
 net/netfilter/Kconfig                                             |    2 
 net/netfilter/ipvs/ip_vs_ctl.c                                    |    5 
 net/netfilter/xt_IDLETIMER.c                                      |    2 
 net/nfc/nci/rsp.c                                                 |    2 
 scripts/Makefile.gcc-plugins                                      |    4 
 sound/hda/hdac_controller.c                                       |    5 
 sound/pci/hda/hda_bind.c                                          |   20 -
 sound/pci/hda/hda_codec.c                                         |    1 
 sound/pci/hda/hda_controller.c                                    |   24 -
 sound/pci/hda/hda_controller.h                                    |    2 
 sound/pci/hda/hda_intel.c                                         |   29 +
 sound/pci/hda/hda_intel.h                                         |    4 
 sound/pci/hda/patch_realtek.c                                     |    1 
 sound/soc/codecs/wm8960.c                                         |   13 
 sound/soc/soc-dapm.c                                              |   13 
 sound/usb/quirks-table.h                                          |   32 +
 tools/lib/perf/tests/test-evlist.c                                |    6 
 tools/lib/perf/tests/test-evsel.c                                 |    6 
 tools/testing/selftests/bpf/prog_tests/core_reloc.c               |    2 
 tools/testing/selftests/net/forwarding/Makefile                   |    1 
 tools/testing/selftests/net/forwarding/forwarding.config.sample   |    2 
 tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh |  172 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh                     |    8 
 tools/testing/selftests/netfilter/nft_flowtable.sh                |    1 
 117 files changed, 989 insertions(+), 478 deletions(-)

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: fix register definition

Alex Deucher (1):
      drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI

Antoine Tenart (1):
      netfilter: ipvs: make global sysctl readonly in non-init netns

Benjamin Coddington (1):
      NFSD: Keep existing listeners on portlist error

Brendan Grieve (1):
      ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Brendan Higgins (1):
      gcc-plugins/structleak: add makefile var for disabling structleak

Christopher M. Riedl (1):
      powerpc64/idle: Fix SP offsets when saving GPRs

DENG Qingfang (1):
      net: dsa: mt7530: correct ds->num_ports

Dan Johansen (1):
      drm/panel: ilitek-ili9881c: Fix sync for Feixin K101-IM2BYL02 panel

Daniel Borkmann (1):
      bpf, test, cgroup: Use sk_{alloc,free} for test cases

Dexuan Cui (1):
      scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Eugen Hristev (1):
      ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default

Fabien Dessenne (1):
      pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()

Filipe Manana (1):
      btrfs: deal with errors when checking if a dir entry exists during log replay

Florian Westphal (1):
      selftests: netfilter: remove stray bash debug line

Gaosheng Cui (1):
      audit: fix possible null-pointer dereference in audit_filter_rules

Gerald Schaefer (1):
      dma-debug: fix sg checks in debug_dma_map_sg()

Greg Kroah-Hartman (1):
      Linux 5.10.76

Guangbin Huang (2):
      net: hns3: reset DWRR of unused tc to zero
      net: hns3: add limit ets dwrr bandwidth cannot be 0

Guenter Roeck (1):
      xtensa: xtfpga: Try software restart before simulating CPU reset

Helge Deller (1):
      parisc: math-emu: Fix fall-through warnings

Herve Codina (2):
      net: stmmac: add support for dwmac 3.40a
      ARM: dts: spear3xx: Fix gmac node

Jan Beulich (1):
      xen/x86: prevent PVH type from getting clobbered

Jan Kara (1):
      ocfs2: fix data corruption after conversion from inline format

Jeff Layton (2):
      ceph: skip existing superblocks that are blocklisted or shut down when mounting
      ceph: fix handling of "meta" errors

Johannes Thumshirn (1):
      block: decode QUEUE_FLAG_HCTX_ACTIVE in debugfs output

Jonathan Bell (1):
      xhci: add quirk for host controllers that don't update endpoint DCS

Joy Gu (1):
      scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Juhee Kang (1):
      netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Kai Vehmanen (1):
      ALSA: hda: avoid write to STATESTS if controller is in reset

Kamal Mostafa (1):
      io_uring: fix splice_fd_in checks backport typo

Kan Liang (1):
      perf/x86/msr: Add Sapphire Rapids CPU support

Kurt Kanzenbach (1):
      net: stmmac: Fix E2E delay mechanism

Leonard Crestez (1):
      tcp: md5: Fix overlap between vrf and non-vrf keys

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Lorenz Bauer (1):
      selftests: bpf: fix backported ASSERT_FALSE

Lukas Bulwahn (1):
      elfcore: correct reference to CONFIG_UML

Marc Kleine-Budde (1):
      can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

Marek Vasut (1):
      drm: mxsfb: Fix NULL pointer dereference crash on unload

Matthew Wilcox (Oracle) (1):
      vfs: check fd has read access in kernel_read_file_from_fd()

Max Filippov (1):
      xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Miaohe Lin (3):
      mm, slub: fix mismatch between reconstructed freelist depth and cnt
      mm, slub: fix potential memoryleak in kmem_cache_open()
      mm, slub: fix incorrect memcg slab count for bulk free

Michael Ellerman (3):
      KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
      KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest
      powerpc/idle: Don't corrupt back chain when going idle

Michal Swiatkowski (1):
      ice: fix getting UDP tunnel entry

Mike Christie (1):
      scsi: iscsi: Fix set_param() handling

Nadav Amit (1):
      userfaultfd: fix a race between writeprotect and exit_mmap()

Nathan Lynch (1):
      powerpc/smp: do not decrement idle task preempt count in CPU offline

Nick Desaulniers (1):
      ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Niklas Schnelle (1):
      s390/pci: fix zpci_zdev_put() on reserve

Nikolay Aleksandrov (1):
      net: bridge: mcast: use multicast_membership_interval for IGMPv3

Paolo Bonzini (1):
      KVM: nVMX: promptly process interrupts delivered while in guest mode

Peng Li (1):
      net: hns3: disable sriov before unload hclge layer

Prashant Malani (1):
      platform/x86: intel_scu_ipc: Update timeout value in comment

Randy Dunlap (1):
      NIOS2: irqflags: rename a redefined register name

Rob Herring (1):
      arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address

Sasha Neftin (2):
      e1000e: Fix packet loss on Tiger Lake and later
      e1000e: Separate TGP board type from SPT

Shengjiu Wang (1):
      ASoC: wm8960: Fix clock configuration on slave mode

Shunsuke Nakamura (1):
      libperf tests: Fix test_stat_cpu

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Stephen Suryaputra (1):
      ipv6: When forwarding count rx stats on the orig netdev

Steven Clarkson (1):
      ALSA: hda/realtek: Add quirk for Clevo PC50HS

Steven Rostedt (VMware) (1):
      tracing: Have all levels of checks prevent recursion

Takashi Iwai (2):
      ASoC: DAPM: Fix missing kctl change notifications
      ALSA: hda: intel: Allow repeatedly probing on codec configuration errors

Tony Nguyen (1):
      ice: Add missing E810 device ids

Uwe Kleine-König (1):
      Input: snvs_pwrkey - add clk handling

Valentin Vidic (1):
      ocfs2: mount fails with buffer overflow in strlen

Vegard Nossum (2):
      lan78xx: select CRC32
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Vladimir Oltean (1):
      net: enetc: fix ethtool counter name for PM0_TERR

Woody Lin (1):
      sched/scs: Reset the shadow stack when idle_task_exit

Xiaolong Huang (1):
      isdn: cpai: check ctr->cnr to avoid array index out of bound

Xin Long (1):
      netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6

Yanfei Xu (1):
      net: mdiobus: Fix memory leak in __mdiobus_register

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Yufeng Mo (1):
      net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin (3):
      net: hns3: schedule the polling again when allocation fails
      net: hns3: fix the max tx size according to user manual
      net: hns3: fix for miscalculation of rx unused desc

Zhang Changzhong (2):
      can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
      can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zheyu Ma (2):
      can: peak_pci: peak_pci_remove(): fix UAF
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (4):
      can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
      can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
      can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
      can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()

