Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84E942BA1A
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhJMI0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhJMI03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B1D61040;
        Wed, 13 Oct 2021 08:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634113467;
        bh=9GGlQvl1WjLyznZCsHmj/eNKfDM86cu14ESVWQXfzLc=;
        h=From:To:Cc:Subject:Date:From;
        b=sgyiA28/XWMp2dEtmYxvZ3njdIIGSov33SkrWcgWefvGruSiWvct4rrnqL3NsMqzQ
         RiBq/VAtqezo5XDXRMkxvuBgQXD6I/oVe3P6Fe6ziKt0TmtNeV2wfFfP/jN8VpfcwE
         VsyXi1vH/ud3JqEJ+DV/dDTrsZT3RvJCZvGuCaYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.153
Date:   Wed, 13 Oct 2021 10:24:23 +0200
Message-Id: <163411346364123@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.153 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/arm/boot/dts/imx53-m53menlo.dts           |    4 
 arch/arm/boot/dts/omap3430-sdp.dts             |    2 
 arch/arm/boot/dts/qcom-apq8064.dtsi            |    7 
 arch/arm/mach-imx/pm-imx6.c                    |    2 
 arch/arm/mach-omap2/omap_hwmod.c               |    2 
 arch/arm/net/bpf_jit_32.c                      |   19 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi |   22 
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi |   16 
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi |   16 
 arch/arm64/boot/dts/qcom/pm8150.dtsi           |    2 
 arch/mips/Kconfig                              |    1 
 arch/mips/net/Makefile                         |    1 
 arch/mips/net/bpf_jit.c                        | 1299 +++++++++++++++++++++++++
 arch/mips/net/bpf_jit_asm.S                    |  285 +++++
 arch/powerpc/boot/dts/fsl/t1023rdb.dts         |    2 
 arch/riscv/include/uapi/asm/unistd.h           |    3 
 arch/s390/net/bpf_jit_comp.c                   |    2 
 arch/x86/Kconfig                               |    2 
 arch/x86/kernel/early-quirks.c                 |    6 
 arch/x86/kernel/hpet.c                         |   81 +
 arch/x86/platform/olpc/olpc.c                  |    2 
 arch/xtensa/include/asm/kmem_layout.h          |   29 
 arch/xtensa/include/asm/vectors.h              |   42 
 arch/xtensa/kernel/irq.c                       |    2 
 arch/xtensa/kernel/setup.c                     |   12 
 arch/xtensa/mm/mmu.c                           |    2 
 drivers/bus/ti-sysc.c                          |    3 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c      |    1 
 drivers/i2c/i2c-core-acpi.c                    |    1 
 drivers/mmc/host/meson-gx-mmc.c                |   73 +
 drivers/net/ethernet/google/gve/gve.h          |    2 
 drivers/net/ethernet/google/gve/gve_main.c     |   13 
 drivers/net/ethernet/intel/i40e/i40e_main.c    |    5 
 drivers/net/phy/mdio_bus.c                     |    7 
 drivers/net/phy/sfp.c                          |    2 
 drivers/ptp/ptp_pch.c                          |    1 
 drivers/soc/qcom/mdt_loader.c                  |    2 
 drivers/soc/qcom/socinfo.c                     |    2 
 drivers/usb/class/cdc-acm.c                    |    8 
 drivers/usb/common/Kconfig                     |    3 
 drivers/usb/typec/tcpm/tcpm.c                  |    1 
 drivers/video/fbdev/gbefb.c                    |    2 
 drivers/xen/balloon.c                          |   21 
 drivers/xen/privcmd.c                          |    7 
 fs/nfsd/nfs4xdr.c                              |   19 
 fs/nfsd/nfsctl.c                               |    2 
 fs/overlayfs/dir.c                             |   10 
 kernel/bpf/stackmap.c                          |    3 
 net/bridge/br_netlink.c                        |    2 
 net/core/rtnetlink.c                           |    2 
 net/ipv4/inet_hashtables.c                     |    4 
 net/ipv4/udp.c                                 |    3 
 net/ipv6/inet6_hashtables.c                    |    2 
 net/ipv6/udp.c                                 |    3 
 net/netlink/af_netlink.c                       |   14 
 net/sched/sch_fifo.c                           |    3 
 net/sched/sch_taprio.c                         |    4 
 58 files changed, 1946 insertions(+), 144 deletions(-)

Andre Przywara (1):
      arm64: dts: freescale: Fix SP805 clock-names

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Antonio Martorana (1):
      soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Ben Hutchings (1):
      Partially revert "usb: Kconfig: using select for USB_COMMON dependency"

Catherine Sullivan (1):
      gve: Correct available tx qpl check

David Heidelberg (1):
      ARM: dts: qcom: apq8064: use compatible which contains chipid

Dmitry Baryshkov (1):
      arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding

Eric Dumazet (6):
      net_sched: fix NULL deref in fifo_set_limit()
      net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
      net/sched: sch_taprio: properly cancel timer from taprio_destroy()
      netlink: annotate data races around nlk->bound
      rtnetlink: fix if_nlmsg_stats_size() under estimation
      gve: fix gve_get_stats()

Greg Kroah-Hartman (1):
      Linux 5.4.153

Jamie Iles (1):
      i2c: acpi: fix resource leak in reconfiguration device addition

Jan Beulich (1):
      xen/privcmd: fix error handling in mmap-resource processing

Jiri Benc (1):
      i40e: fix endless loop under rtnl

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Johan Hovold (2):
      USB: cdc-acm: fix racy tty buffer accesses
      USB: cdc-acm: fix break reporting

Juergen Gross (1):
      xen/balloon: fix cancelled balloon action

Lukas Bulwahn (2):
      x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI
      x86/Kconfig: Correct reference to MWINCHIP3D

Marek Vasut (2):
      ARM: dts: imx: Add missing pinctrl-names for panel on M53Menlo
      ARM: dts: imx: Fix USB host power regulator polarity on M53Menlo

Marijn Suijten (1):
      ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference

Mark Brown (1):
      video: fbdev: gbefb: Only instantiate device when built for IP32

Max Filippov (2):
      xtensa: move XCHAL_KIO_* definitions to kmem_layout.h
      xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Michael Walle (1):
      arm64: dts: ls1028a: add missing CAN nodes

Mike Manning (1):
      net: prefer socket bound to interface when not in VRF

Neil Armstrong (1):
      mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Palmer Dabbelt (1):
      RISC-V: Include clone3() on rv32

Patrick Ho (1):
      nfsd: fix error handling of register_pernet_subsys() in init_nfsd()

Paul Burton (1):
      MIPS: BPF: Restore MIPS32 cBPF JIT

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

Randy Dunlap (1):
      xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Roger Quadros (1):
      ARM: dts: omap3430-sdp: Fix NAND device node

Sean Anderson (1):
      net: sfp: Fix typo in state machine debug string

Shawn Guo (1):
      soc: qcom: mdt_loader: Drop PT_LOAD check on hash segment

Sylwester Dziedziuch (1):
      i40e: Fix freeing of uninitialized misc IRQ vector

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Thomas Gleixner (1):
      x86/hpet: Use another crystalball to evaluate HPET usability

Tiezhu Yang (1):
      bpf, s390: Fix potential memory leak about jit_data

Tony Lindgren (1):
      bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Xu Yang (1):
      usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Yang Yingliang (1):
      drm/nouveau/debugfs: fix file release memory leak

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

