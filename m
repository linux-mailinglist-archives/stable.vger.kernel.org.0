Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEED43C520
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhJ0Ibb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239187AbhJ0IbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9340E610CF;
        Wed, 27 Oct 2021 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635323334;
        bh=G2auBCh86dtcZFZaC3hQqfG038MMttNWa4ZRkR4abFU=;
        h=From:To:Cc:Subject:Date:From;
        b=VgAnX/QLsXUK4FG1dSfucqc4gaXBM3/N+75RtyqS7IZqW5eGIM1s2KCdl8zvg+p2t
         hq7ELjx+2o07FRZispV76sAhYRu0lcXLllUr4EQKDVRrcudcB9Dv61vrGWrFwUTK2R
         Rj55qoUWHmBrK+yIX+mQkbUML9fKRtTmswY0Ud1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.156
Date:   Wed, 27 Oct 2021 10:28:42 +0200
Message-Id: <163532332277171@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.156 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/Kconfig                                        |    1 
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts             |    1 
 arch/arm/boot/dts/spear3xx.dtsi                         |    2 
 arch/nios2/include/asm/irqflags.h                       |    4 
 arch/nios2/include/asm/registers.h                      |    2 
 arch/parisc/math-emu/fpudispatch.c                      |   56 +++++-
 arch/powerpc/kernel/idle_book3s.S                       |  148 ++++++++--------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                 |   28 +--
 arch/xtensa/platforms/xtfpga/setup.c                    |   12 -
 drivers/input/keyboard/snvs_pwrkey.c                    |   29 +++
 drivers/isdn/capi/kcapi.c                               |    5 
 drivers/isdn/hardware/mISDN/netjet.c                    |    2 
 drivers/net/can/rcar/rcar_can.c                         |   20 +-
 drivers/net/can/sja1000/peak_pci.c                      |    9 
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c              |    5 
 drivers/net/dsa/lantiq_gswip.c                          |    2 
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c    |    2 
 drivers/net/ethernet/hisilicon/hns3/hnae3.c             |   21 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c     |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c   |    8 
 drivers/net/phy/mdio_bus.c                              |    1 
 drivers/net/usb/Kconfig                                 |    1 
 drivers/pinctrl/stm32/pinctrl-stm32.c                   |    4 
 drivers/platform/x86/intel_scu_ipc.c                    |    2 
 drivers/scsi/hosts.c                                    |    3 
 drivers/tee/optee/core.c                                |    3 
 drivers/tee/optee/device.c                              |   22 ++
 drivers/tee/optee/optee_private.h                       |    1 
 fs/btrfs/tree-log.c                                     |   47 +++--
 fs/ceph/caps.c                                          |   12 -
 fs/ceph/file.c                                          |    1 
 fs/ceph/inode.c                                         |    2 
 fs/ceph/mds_client.c                                    |   17 -
 fs/ceph/super.h                                         |    3 
 fs/exec.c                                               |    2 
 fs/nfsd/nfsctl.c                                        |    5 
 fs/ocfs2/alloc.c                                        |   46 +---
 fs/ocfs2/super.c                                        |   14 +
 include/linux/elfcore.h                                 |    2 
 kernel/auditsc.c                                        |    2 
 kernel/dma/debug.c                                      |   12 -
 kernel/trace/ftrace.c                                   |    4 
 kernel/trace/trace.h                                    |   64 ++----
 kernel/trace/trace_functions.c                          |    2 
 mm/slub.c                                               |   13 +
 net/can/j1939/j1939-priv.h                              |    1 
 net/can/j1939/main.c                                    |    7 
 net/can/j1939/transport.c                               |   14 -
 net/netfilter/Kconfig                                   |    2 
 net/netfilter/ipvs/ip_vs_ctl.c                          |    5 
 net/nfc/nci/rsp.c                                       |    2 
 net/switchdev/switchdev.c                               |    9 
 scripts/Makefile.gcc-plugins                            |    4 
 sound/hda/hdac_controller.c                             |    5 
 sound/pci/hda/patch_realtek.c                           |    1 
 sound/soc/codecs/wm8960.c                               |   13 +
 sound/soc/soc-dapm.c                                    |   13 -
 sound/usb/quirks-table.h                                |   32 +++
 tools/testing/selftests/netfilter/nft_flowtable.sh      |    1 
 65 files changed, 490 insertions(+), 279 deletions(-)

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: fix register definition

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
      Linux 5.4.156

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

Jan Kara (1):
      ocfs2: fix data corruption after conversion from inline format

Jeff Layton (1):
      ceph: fix handling of "meta" errors

Kai Vehmanen (1):
      ALSA: hda: avoid write to STATESTS if controller is in reset

Kurt Kanzenbach (1):
      net: stmmac: Fix E2E delay mechanism

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Lukas Bulwahn (1):
      elfcore: correct reference to CONFIG_UML

Matthew Wilcox (Oracle) (1):
      vfs: check fd has read access in kernel_read_file_from_fd()

Max Filippov (1):
      xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Miaohe Lin (2):
      mm, slub: fix mismatch between reconstructed freelist depth and cnt
      mm, slub: fix potential memoryleak in kmem_cache_open()

Michael Ellerman (3):
      KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
      KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest
      powerpc/idle: Don't corrupt back chain when going idle

Nick Desaulniers (1):
      ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Peng Li (1):
      net: hns3: disable sriov before unload hclge layer

Prashant Malani (1):
      platform/x86: intel_scu_ipc: Update timeout value in comment

Randy Dunlap (1):
      NIOS2: irqflags: rename a redefined register name

Russell King (1):
      net: switchdev: do not propagate bridge updates across bridges

Shengjiu Wang (1):
      ASoC: wm8960: Fix clock configuration on slave mode

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Steven Clarkson (1):
      ALSA: hda/realtek: Add quirk for Clevo PC50HS

Steven Rostedt (VMware) (1):
      tracing: Have all levels of checks prevent recursion

Sumit Garg (1):
      tee: optee: Fix missing devices unregister during optee_remove

Takashi Iwai (1):
      ASoC: DAPM: Fix missing kctl change notifications

Uwe Kleine-König (1):
      Input: snvs_pwrkey - add clk handling

Valentin Vidic (1):
      ocfs2: mount fails with buffer overflow in strlen

Vegard Nossum (2):
      lan78xx: select CRC32
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Vladimir Oltean (1):
      net: enetc: fix ethtool counter name for PM0_TERR

Xiaolong Huang (1):
      isdn: cpai: check ctr->cnr to avoid array index out of bound

Yanfei Xu (1):
      net: mdiobus: Fix memory leak in __mdiobus_register

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Zhang Changzhong (2):
      can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
      can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zheyu Ma (2):
      can: peak_pci: peak_pci_remove(): fix UAF
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (2):
      can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
      can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv

