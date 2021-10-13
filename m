Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD4D42BA6A
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhJMIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238498AbhJMIcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C7F61077;
        Wed, 13 Oct 2021 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634113836;
        bh=sCZwqCzJe6CgU6MTCgvi7b5dAI+Xtmxlw6FPTfScB1Q=;
        h=From:To:Cc:Subject:Date:From;
        b=jmrwjq9pvMS6uF00IMBUUfJgzT5RUBj78RTcchUjQFlKQzR2JKDUT8Vf97jGQklo3
         C5d2kYKla16j/MJ3nZaOWQ3ux2ImNCqGirAd0MQxbGsi5yBk42xZfg/92cLf3BtOA+
         52lC1r4OF7sfvh1M6IOwSHawz0YyBiM8LszmI8o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.73
Date:   Wed, 13 Oct 2021 10:30:32 +0200
Message-Id: <163411383219141@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.73 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml |    2 
 Makefile                                                           |    2 
 arch/arm/boot/dts/imx53-m53menlo.dts                               |    4 
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi                         |    5 
 arch/arm/boot/dts/imx6qdl-pico.dtsi                                |   11 +
 arch/arm/boot/dts/omap3430-sdp.dts                                 |    2 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                |    7 
 arch/arm/mach-at91/pm.c                                            |   58 ++++-
 arch/arm/mach-imx/pm-imx6.c                                        |    2 
 arch/arm/mach-omap2/omap_hwmod.c                                   |    2 
 arch/arm/net/bpf_jit_32.c                                          |   19 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                     |   18 +
 arch/arm64/boot/dts/qcom/pm8150.dtsi                               |    2 
 arch/powerpc/boot/dts/fsl/t1023rdb.dts                             |    2 
 arch/powerpc/kernel/dma-iommu.c                                    |    9 
 arch/powerpc/kernel/exceptions-64s.S                               |   17 +
 arch/powerpc/net/bpf_jit_comp64.c                                  |   27 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c                       |    4 
 arch/riscv/include/uapi/asm/unistd.h                               |    3 
 arch/riscv/kernel/vdso.c                                           |    4 
 arch/riscv/mm/cacheflush.c                                         |    2 
 arch/s390/net/bpf_jit_comp.c                                       |    2 
 arch/x86/Kconfig                                                   |    2 
 arch/x86/include/asm/entry-common.h                                |    2 
 arch/x86/kernel/cpu/common.c                                       |    1 
 arch/x86/kernel/early-quirks.c                                     |    6 
 arch/x86/kernel/hpet.c                                             |   81 ++++++++
 arch/x86/kernel/sev-es-shared.c                                    |    2 
 arch/x86/platform/olpc/olpc.c                                      |    2 
 arch/xtensa/include/asm/kmem_layout.h                              |    2 
 arch/xtensa/kernel/irq.c                                           |    2 
 arch/xtensa/kernel/setup.c                                         |   12 -
 arch/xtensa/mm/mmu.c                                               |    2 
 drivers/bus/ti-sysc.c                                              |    4 
 drivers/gpu/drm/nouveau/dispnv50/crc.c                             |    1 
 drivers/gpu/drm/nouveau/dispnv50/head.c                            |    2 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                          |    1 
 drivers/gpu/drm/nouveau/nouveau_gem.c                              |    4 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                              |    7 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h                              |    4 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                             |   97 +++++-----
 drivers/i2c/busses/i2c-mt65xx.c                                    |   11 +
 drivers/i2c/i2c-core-acpi.c                                        |    1 
 drivers/mmc/host/meson-gx-mmc.c                                    |   73 ++++++-
 drivers/mmc/host/sdhci-of-at91.c                                   |   22 +-
 drivers/net/ethernet/google/gve/gve.h                              |    2 
 drivers/net/ethernet/google/gve/gve_main.c                         |   45 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                    |    7 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c      |   12 -
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c     |    4 
 drivers/net/phy/mdio_bus.c                                         |    7 
 drivers/net/phy/sfp.c                                              |    2 
 drivers/net/wireless/ath/ath5k/Kconfig                             |    4 
 drivers/net/wireless/ath/ath5k/led.c                               |   10 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                      |    2 
 drivers/pci/controller/pci-hyperv.c                                |   13 +
 drivers/ptp/ptp_pch.c                                              |    1 
 drivers/soc/qcom/mdt_loader.c                                      |    2 
 drivers/soc/qcom/socinfo.c                                         |    2 
 drivers/soc/ti/omap_prm.c                                          |   27 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                                 |   15 +
 drivers/usb/class/cdc-acm.c                                        |    8 
 drivers/usb/common/Kconfig                                         |    3 
 drivers/usb/typec/tcpm/tcpm.c                                      |    1 
 drivers/video/fbdev/gbefb.c                                        |    2 
 drivers/xen/balloon.c                                              |   21 +-
 drivers/xen/privcmd.c                                              |    7 
 fs/nfsd/nfs4xdr.c                                                  |   19 +
 fs/nfsd/nfsctl.c                                                   |    2 
 fs/overlayfs/dir.c                                                 |   10 -
 fs/overlayfs/file.c                                                |   15 +
 kernel/bpf/stackmap.c                                              |    3 
 net/bridge/br_netlink.c                                            |    3 
 net/core/rtnetlink.c                                               |    2 
 net/ipv4/inet_hashtables.c                                         |    4 
 net/ipv4/udp.c                                                     |    3 
 net/ipv6/inet6_hashtables.c                                        |    2 
 net/ipv6/udp.c                                                     |    3 
 net/netlink/af_netlink.c                                           |   14 +
 net/sched/sch_fifo.c                                               |    3 
 net/sched/sch_taprio.c                                             |    4 
 net/sunrpc/auth_gss/svcauth_gss.c                                  |    2 
 tools/perf/pmu-events/jevents.c                                    |   83 +++-----
 84 files changed, 637 insertions(+), 282 deletions(-)

Alexandre Ghiti (1):
      riscv: Flush current cpu icache before other cpus

Alexey Kardashevskiy (1):
      powerpc/iommu: Report the correct most efficient DMA mask for PCI devices

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Antonio Martorana (1):
      soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Arnd Bergmann (1):
      ath5k: fix building with LEDS=m

Ben Hutchings (1):
      Partially revert "usb: Kconfig: using select for USB_COMMON dependency"

Ben Skeggs (1):
      drm/nouveau/kms/tu102-: delay enabling cursor until after assign_windows

Catherine Sullivan (1):
      gve: Correct available tx qpl check

Claudiu Beznea (3):
      mmc: sdhci-of-at91: wait for calibration done before proceed
      mmc: sdhci-of-at91: replace while loop with read_poll_timeout
      ARM: at91: pm: do not panic if ram controllers are not enabled

David Heidelberg (1):
      ARM: dts: qcom: apq8064: use compatible which contains chipid

Dmitry Baryshkov (1):
      arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding

Eric Dumazet (8):
      net_sched: fix NULL deref in fifo_set_limit()
      net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
      net: bridge: fix under estimation in br_get_linkxstats_size()
      net/sched: sch_taprio: properly cancel timer from taprio_destroy()
      netlink: annotate data races around nlk->bound
      rtnetlink: fix if_nlmsg_stats_size() under estimation
      gve: fix gve_get_stats()
      gve: report 64bit tx_bytes counter from gve_handle_report_stats()

Fabio Estevam (2):
      usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle
      ARM: dts: imx6qdl-pico: Fix Ethernet support

Geert Uytterhoeven (1):
      dt-bindings: drm/bridge: ti-sn65dsi86: Fix reg value

Greg Kroah-Hartman (1):
      Linux 5.10.73

J. Bruce Fields (1):
      SUNRPC: fix sign error causing rpcsec_gss drops

Jamie Iles (1):
      i2c: acpi: fix resource leak in reconfiguration device addition

Jan Beulich (1):
      xen/privcmd: fix error handling in mmap-resource processing

Jeremy Cline (1):
      drm/nouveau: avoid a use-after-free when BO init fails

Jernej Skrabec (1):
      drm/sun4i: dw-hdmi: Fix HDMI PHY clock setup

Jiri Benc (1):
      i40e: fix endless loop under rtnl

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Johan Hovold (2):
      USB: cdc-acm: fix racy tty buffer accesses
      USB: cdc-acm: fix break reporting

John Garry (1):
      perf jevents: Tidy error handling

Juergen Gross (1):
      xen/balloon: fix cancelled balloon action

Kewei Xu (1):
      i2c: mediatek: Add OFFSET_EXT_CONF setting back

Long Li (1):
      PCI: hv: Fix sleep while in non-sleep context when removing child devices from the bus

Lukas Bulwahn (3):
      x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI
      x86/Kconfig: Correct reference to MWINCHIP3D
      x86/entry: Correct reference to intended CONFIG_64_BIT

Mahesh Salgaonkar (1):
      pseries/eeh: Fix the kdump kernel crash during eeh_pseries_init

Marek Vasut (2):
      ARM: dts: imx: Add missing pinctrl-names for panel on M53Menlo
      ARM: dts: imx: Fix USB host power regulator polarity on M53Menlo

Marijn Suijten (1):
      ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference

Mark Brown (1):
      video: fbdev: gbefb: Only instantiate device when built for IP32

Max Filippov (1):
      xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Michael Walle (1):
      arm64: dts: ls1028a: add missing CAN nodes

Michal Vokáč (1):
      ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe

Mike Manning (1):
      net: prefer socket bound to interface when not in VRF

Miklos Szeredi (1):
      ovl: fix IOCB_DIRECT if underlying fs doesn't support direct IO

Moshe Shemesh (1):
      net/mlx5: E-Switch, Fix double allocation of acl flow counter

Nathan Chancellor (1):
      bus: ti-sysc: Add break in switch statement in sysc_init_soc()

Naveen N. Rao (1):
      powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

Neil Armstrong (1):
      mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Nicholas Piggin (1):
      powerpc/64s: fix program check interrupt emergency stack path

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Palmer Dabbelt (1):
      RISC-V: Include clone3() on rv32

Patrick Ho (1):
      nfsd: fix error handling of register_pernet_subsys() in init_nfsd()

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Raed Salem (1):
      net/mlx5e: IPSEC RX, enable checksum complete

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

Tao Liu (1):
      gve: Avoid freeing NULL pointer

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Thomas Gleixner (1):
      x86/hpet: Use another crystalball to evaluate HPET usability

Tiezhu Yang (1):
      bpf, s390: Fix potential memory leak about jit_data

Tom Lendacky (1):
      x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]

Tong Tiangen (1):
      riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable

Tony Lindgren (2):
      soc: ti: omap-prm: Fix external abort for am335x pruss
      bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Vegard Nossum (1):
      x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n

Vladimir Zapolskiy (1):
      iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

Xu Yang (1):
      usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Yang Yingliang (2):
      drm/nouveau/kms/nv50-: fix file release memory leak
      drm/nouveau/debugfs: fix file release memory leak

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

