Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F2442BA6F
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbhJMIcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhJMIcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D89E7610C9;
        Wed, 13 Oct 2021 08:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634113844;
        bh=RUtAvqc41XSFBFVTprLhuQAfehQ9P01ySuMfTsC9Z70=;
        h=From:To:Cc:Subject:Date:From;
        b=QJSJ4uIGlgHf3I6u4QY3jhnHRgXaxdO+XuyYpXFu71/O6jizbfLg2rd4ZASzbdcVn
         FuIhAidhN2c0DvS6SKh4Fqc3e0HOWygRCMR5y+wsLmL69QEBk8569NMFmg23+dSeW7
         0x4VqnruvWQOtyV+9CCFlZumCj9OdsylB0FVdsAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.12
Date:   Wed, 13 Oct 2021 10:30:38 +0200
Message-Id: <1634113838284@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.12 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml |    2 
 Makefile                                                           |    2 
 arch/arm/boot/dts/imx53-m53menlo.dts                               |    4 
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi                         |    5 
 arch/arm/boot/dts/imx6qdl-pico.dtsi                                |   11 
 arch/arm/boot/dts/imx6sx-sdb.dts                                   |    4 
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                            |    2 
 arch/arm/boot/dts/omap3430-sdp.dts                                 |    2 
 arch/arm/boot/dts/qcom-apq8064.dtsi                                |    7 
 arch/arm/configs/gemini_defconfig                                  |    1 
 arch/arm/mach-at91/pm.c                                            |   58 +
 arch/arm/mach-imx/pm-imx6.c                                        |    2 
 arch/arm/mach-omap2/omap_hwmod.c                                   |    2 
 arch/arm/net/bpf_jit_32.c                                          |   19 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                     |    4 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi               |    2 
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts                       |    2 
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi        |    1 
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi               |    2 
 arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi              |    2 
 arch/arm64/boot/dts/freescale/imx8mq-evk.dts                       |    2 
 arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dts        |    2 
 arch/arm64/boot/dts/qcom/pm8150.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                               |    6 
 arch/mips/include/asm/mips-cps.h                                   |   23 
 arch/powerpc/boot/dts/fsl/t1023rdb.dts                             |    2 
 arch/powerpc/include/asm/book3s/32/kup.h                           |    8 
 arch/powerpc/include/asm/interrupt.h                               |    5 
 arch/powerpc/kernel/dma-iommu.c                                    |    9 
 arch/powerpc/kernel/exceptions-64s.S                               |   25 
 arch/powerpc/kernel/traps.c                                        |   43 -
 arch/powerpc/net/bpf_jit_comp32.c                                  |    8 
 arch/powerpc/net/bpf_jit_comp64.c                                  |   37 -
 arch/powerpc/platforms/pseries/eeh_pseries.c                       |    4 
 arch/riscv/Makefile                                                |    6 
 arch/riscv/include/asm/syscall.h                                   |    1 
 arch/riscv/include/asm/vdso.h                                      |   37 -
 arch/riscv/include/uapi/asm/unistd.h                               |    3 
 arch/riscv/kernel/syscall_table.c                                  |    1 
 arch/riscv/kernel/vdso.c                                           |   53 +
 arch/riscv/kernel/vdso/Makefile                                    |   25 
 arch/riscv/kernel/vdso/gen_vdso_offsets.sh                         |    5 
 arch/riscv/kernel/vdso/so2s.sh                                     |    6 
 arch/riscv/kernel/vdso/vdso.lds.S                                  |    3 
 arch/riscv/mm/cacheflush.c                                         |    2 
 arch/s390/net/bpf_jit_comp.c                                       |    2 
 arch/x86/Kconfig                                                   |    2 
 arch/x86/include/asm/entry-common.h                                |    2 
 arch/x86/kernel/cpu/common.c                                       |    1 
 arch/x86/kernel/early-quirks.c                                     |    6 
 arch/x86/kernel/fpu/signal.c                                       |   11 
 arch/x86/kernel/hpet.c                                             |   81 ++
 arch/x86/kernel/sev-shared.c                                       |    2 
 arch/x86/platform/olpc/olpc.c                                      |    2 
 arch/xtensa/include/asm/kmem_layout.h                              |    2 
 arch/xtensa/kernel/irq.c                                           |    2 
 arch/xtensa/kernel/setup.c                                         |   12 
 arch/xtensa/mm/mmu.c                                               |    2 
 drivers/bus/ti-sysc.c                                              |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                   |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                         |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                            |   14 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.h          |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c      |   66 ++
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h      |   14 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c              |    8 
 drivers/gpu/drm/amd/display/include/dal_asic_id.h                  |    2 
 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_4_2_0_offset.h      |   27 
 drivers/gpu/drm/i915/display/icl_dsi.c                             |   48 +
 drivers/gpu/drm/i915/display/intel_audio.c                         |    5 
 drivers/gpu/drm/i915/display/intel_bios.c                          |   22 
 drivers/gpu/drm/i915/display/intel_ddi.c                           |    8 
 drivers/gpu/drm/i915/display/intel_display.c                       |   20 
 drivers/gpu/drm/i915/display/intel_vbt_defs.h                      |    5 
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c                       |    7 
 drivers/gpu/drm/i915/i915_reg.h                                    |    6 
 drivers/gpu/drm/i915/intel_pm.c                                    |   12 
 drivers/gpu/drm/nouveau/dispnv50/crc.c                             |    1 
 drivers/gpu/drm/nouveau/dispnv50/head.c                            |    2 
 drivers/gpu/drm/nouveau/include/nvif/class.h                       |    2 
 drivers/gpu/drm/nouveau/include/nvkm/engine/fifo.h                 |    1 
 drivers/gpu/drm/nouveau/nouveau_bo.c                               |    1 
 drivers/gpu/drm/nouveau/nouveau_chan.c                             |    6 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                          |    1 
 drivers/gpu/drm/nouveau/nouveau_drm.c                              |    4 
 drivers/gpu/drm/nouveau/nouveau_gem.c                              |    4 
 drivers/gpu/drm/nouveau/nv84_fence.c                               |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c                  |    3 
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/Kbuild                    |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c                   |  311 ++++++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/top/ga100.c                    |    7 
 drivers/gpu/drm/panel/panel-abt-y030xx067a.c                       |    4 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                              |    7 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h                              |    4 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                             |   97 +--
 drivers/i2c/busses/i2c-mlxcpld.c                                   |    4 
 drivers/i2c/busses/i2c-mt65xx.c                                    |   11 
 drivers/i2c/i2c-core-acpi.c                                        |    1 
 drivers/mmc/host/meson-gx-mmc.c                                    |   73 +-
 drivers/mmc/host/sdhci-of-at91.c                                   |   22 
 drivers/net/ethernet/google/gve/gve.h                              |    2 
 drivers/net/ethernet/google/gve/gve_main.c                         |   45 -
 drivers/net/ethernet/google/gve/gve_rx.c                           |    8 
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |    5 
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                       |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c         |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c                   |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |   59 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                   |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                    |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c                 |   11 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c      |   12 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c     |    4 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                |   37 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c                  |    9 
 drivers/net/ethernet/mscc/ocelot_vcap.c                            |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c                     |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |    6 
 drivers/net/pcs/pcs-xpcs.c                                         |   45 +
 drivers/net/phy/mdio_bus.c                                         |    7 
 drivers/net/phy/sfp.c                                              |    2 
 drivers/net/wireless/ath/ath5k/Kconfig                             |    4 
 drivers/net/wireless/ath/ath5k/led.c                               |   10 
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                      |    2 
 drivers/of/base.c                                                  |    1 
 drivers/pci/controller/pci-hyperv.c                                |   13 
 drivers/ptp/ptp_pch.c                                              |    1 
 drivers/scsi/libiscsi.c                                            |   15 
 drivers/scsi/ufs/ufshcd.c                                          |   52 -
 drivers/scsi/ufs/ufshcd.h                                          |    1 
 drivers/soc/qcom/mdt_loader.c                                      |    2 
 drivers/soc/qcom/socinfo.c                                         |    2 
 drivers/soc/ti/omap_prm.c                                          |   27 
 drivers/usb/chipidea/ci_hdrc_imx.c                                 |   15 
 drivers/usb/class/cdc-acm.c                                        |    8 
 drivers/usb/class/cdc-wdm.c                                        |    6 
 drivers/usb/common/Kconfig                                         |    3 
 drivers/usb/gadget/function/f_uac2.c                               |   14 
 drivers/usb/typec/tcpm/tcpci.c                                     |    2 
 drivers/usb/typec/tcpm/tcpm.c                                      |    1 
 drivers/usb/typec/tipd/core.c                                      |    8 
 drivers/video/fbdev/Kconfig                                        |    5 
 drivers/video/fbdev/gbefb.c                                        |    2 
 drivers/xen/balloon.c                                              |   21 
 drivers/xen/privcmd.c                                              |    7 
 fs/afs/write.c                                                     |    3 
 fs/netfs/read_helper.c                                             |    2 
 fs/nfsd/nfs4xdr.c                                                  |   19 
 fs/nfsd/nfsctl.c                                                   |    2 
 fs/overlayfs/dir.c                                                 |   10 
 fs/overlayfs/file.c                                                |   15 
 include/net/netfilter/ipv6/nf_defrag_ipv6.h                        |    1 
 include/net/netfilter/nf_tables.h                                  |    2 
 include/net/netns/netfilter.h                                      |    6 
 include/soc/mscc/ocelot_vcap.h                                     |    4 
 kernel/bpf/stackmap.c                                              |    3 
 net/bridge/br_netlink.c                                            |    3 
 net/core/rtnetlink.c                                               |    2 
 net/dsa/tag_dsa.c                                                  |    2 
 net/ipv4/inet_hashtables.c                                         |    4 
 net/ipv4/netfilter/nf_defrag_ipv4.c                                |   30 
 net/ipv4/udp.c                                                     |    3 
 net/ipv6/inet6_hashtables.c                                        |    2 
 net/ipv6/netfilter/nf_conntrack_reasm.c                            |    2 
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c                          |   25 
 net/ipv6/udp.c                                                     |    3 
 net/netfilter/nf_tables_api.c                                      |   91 ++
 net/netfilter/nft_quota.c                                          |    2 
 net/netlink/af_netlink.c                                           |   14 
 net/sched/sch_fifo.c                                               |    3 
 net/sched/sch_taprio.c                                             |    4 
 net/sunrpc/auth_gss/svcauth_gss.c                                  |    2 
 tools/lib/bpf/libbpf.c                                             |    3 
 tools/lib/bpf/strset.c                                             |    1 
 tools/objtool/arch/x86/decode.c                                    |    2 
 tools/objtool/special.c                                            |   36 -
 tools/perf/pmu-events/jevents.c                                    |    2 
 182 files changed, 1619 insertions(+), 632 deletions(-)

Adrian Hunter (1):
      scsi: ufs: core: Fix task management completion

Alexandre Ghiti (1):
      riscv: Flush current cpu icache before other cpus

Alexey Kardashevskiy (1):
      powerpc/iommu: Report the correct most efficient DMA mask for PCI devices

Andrew Lunn (1):
      dsa: tag_dsa: Fix mask for trunked packets

Andrii Nakryiko (1):
      libbpf: Fix memory leak in strset

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Antonio Martorana (1):
      soc: qcom: socinfo: Fixed argument passed to platform_set_data()

Arnd Bergmann (2):
      fbdev: simplefb: fix Kconfig dependencies
      ath5k: fix building with LEDS=m

Aya Levin (2):
      net/mlx5: Force round second at 1PPS out start time
      net/mlx5: Avoid generating event after PPS out in Real time mode

Ben Hutchings (1):
      Partially revert "usb: Kconfig: using select for USB_COMMON dependency"

Ben Skeggs (3):
      drm/nouveau/kms/tu102-: delay enabling cursor until after assign_windows
      drm/nouveau/ga102-: support ttm buffer moves via copy engine
      drm/nouveau/fifo/ga102: initialise chid on return from channel creation

Borislav Petkov (1):
      x86/fpu: Restore the masking out of reserved MXCSR bits

Catherine Sullivan (2):
      gve: Correct available tx qpl check
      gve: Properly handle errors in gve_assign_qpl

Christophe Branchereau (1):
      drm/panel: abt-y030xx067a: yellow tint fix

Christophe Leroy (1):
      powerpc/32s: Fix kuap_kernel_restore()

Claudiu Beznea (3):
      mmc: sdhci-of-at91: wait for calibration done before proceed
      mmc: sdhci-of-at91: replace while loop with read_poll_timeout
      ARM: at91: pm: do not panic if ram controllers are not enabled

David Heidelberg (1):
      ARM: dts: qcom: apq8064: use compatible which contains chipid

David Howells (2):
      netfs: Fix READ/WRITE confusion when calling iov_iter_xarray()
      afs: Fix afs_launder_page() to set correct start file position

Dmitry Baryshkov (1):
      arm64: dts: qcom: pm8150: use qcom,pm8998-pon binding

Douglas Anderson (1):
      Revert "arm64: dts: qcom: sc7280: Fixup the cpufreq node"

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

Florian Westphal (1):
      netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

Geert Uytterhoeven (1):
      dt-bindings: drm/bridge: ti-sn65dsi86: Fix reg value

Greg Kroah-Hartman (1):
      Linux 5.14.12

Guchun Chen (1):
      drm/amdgpu: handle the case of pci_channel_io_frozen only in amdgpu_pci_resume

Haibo Chen (2):
      ARM: dts: imx: change the spi-nor tx
      arm64: dts: imx8: change the spi-nor tx

Hansen (1):
      drm/amd/display: Fix detection of 4 lane for DPALT

Heikki Krogerus (1):
      usb: typec: tipd: Remove dependency on "connector" child fwnode

Heiko Thiery (1):
      arm64: dts: imx8mm-kontron-n801x-som: do not allow to switch off buck2

Ilan Peer (1):
      iwlwifi: mvm: Fix possible NULL dereference

Ilya Lipnitskiy (1):
      MIPS: Revert "add support for buggy MT7621S core detection"

Imre Deak (1):
      drm/i915/tc: Fix TypeC port init/resume time sanitization

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

Joe Lawrence (1):
      objtool: Make .altinstructions section entry size consistent

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Johan Hovold (2):
      USB: cdc-acm: fix racy tty buffer accesses
      USB: cdc-acm: fix break reporting

Josh Poimboeuf (1):
      objtool: Remove reloc symbol type checks in get_alt_entry()

Jude Shih (1):
      drm/amd/display: USB4 bring up set correct address

Juergen Gross (1):
      xen/balloon: fix cancelled balloon action

Kai-Heng Feng (1):
      drm/i915/audio: Use BIOS provided value for RKL HDA link

Kewei Xu (1):
      i2c: mediatek: Add OFFSET_EXT_CONF setting back

Kumar Kartikeya Dwivedi (1):
      libbpf: Fix segfault in light skeleton for objects without BTF

Lama Kayal (1):
      net/mlx5e: Fix the presented RQ index in PTP stats

Lang Yu (1):
      drm/amdkfd: fix a potential ttm->sg memory leak

Lijo Lazar (1):
      drm/amdgpu: During s0ix don't wait to signal GFXOFF

Like Xu (1):
      perf jevents: Free the sys_event_tables list after processing entries

Linus Walleij (1):
      ARM: defconfig: gemini: Restore framebuffer

Liu, Zhan (2):
      drm/amd/display: Fix B0 USB-C DP Alt mode
      drm/amd/display: Fix DCN3 B0 DP Alt Mapping

Long Li (1):
      PCI: hv: Fix sleep while in non-sleep context when removing child devices from the bus

Lukas Bulwahn (3):
      x86/platform/olpc: Correct ifdef symbol to intended CONFIG_OLPC_XO15_SCI
      x86/Kconfig: Correct reference to MWINCHIP3D
      x86/entry: Correct reference to intended CONFIG_64_BIT

Lukasz Majczak (1):
      drm/i915/bdb: Fix version check

Maarten Lankhorst (1):
      drm/i915: Fix runtime pm handling in i915_gem_shrink

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
      arm64: dts: ls1028a: fix eSDHC2 node

Michal Vokáč (1):
      ARM: dts: imx6dl-yapp4: Fix lp5562 LED driver probe

Mike Christie (1):
      scsi: iscsi: Fix iscsi_task use after free

Mike Manning (1):
      net: prefer socket bound to interface when not in VRF

Miklos Szeredi (1):
      ovl: fix IOCB_DIRECT if underlying fs doesn't support direct IO

Moshe Shemesh (1):
      net/mlx5: E-Switch, Fix double allocation of acl flow counter

Nathan Chancellor (1):
      bus: ti-sysc: Add break in switch statement in sysc_init_soc()

Naveen N. Rao (6):
      powerpc/bpf: Fix BPF_MOD when imm == 1
      powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
      powerpc/bpf ppc32: Fix ALU32 BPF_ARSH operation
      powerpc/bpf ppc32: Fix JMP32_JSET_K
      powerpc/bpf ppc32: Do not emit zero extend instruction for 64-bit BPF_END
      powerpc/bpf ppc32: Fix BPF_SUB when imm == 0x80000000

Neil Armstrong (1):
      mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk

Nicholas Piggin (3):
      powerpc/64s: fix program check interrupt emergency stack path
      powerpc/traps: do not enable irqs in _exception
      powerpc/64s: Fix unrecoverable MCE calling async handler from NMI

Nikola Cornij (1):
      drm/amd/display: Limit display scaling to up to 4k for DCN 3.1

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add position handle in event notification
      netfilter: nf_tables: reverse order in rule replacement expansion
      netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Palmer Dabbelt (2):
      RISC-V: Fix VDSO build for !MMU
      RISC-V: Include clone3() on rv32

Patrick Ho (1):
      nfsd: fix error handling of register_pernet_subsys() in init_nfsd()

Pavel Hofman (1):
      usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Punit Agrawal (1):
      net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices

Raed Salem (1):
      net/mlx5e: IPSEC RX, enable checksum complete

Randy Dunlap (1):
      xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Rikard Falkeborn (1):
      usb: cdc-wdm: Fix check for WWAN

Roger Quadros (1):
      ARM: dts: omap3430-sdp: Fix NAND device node

Saleem Abdulrasool (1):
      riscv: explicitly use symbol offsets for VDSO

Sean Anderson (1):
      net: sfp: Fix typo in state machine debug string

Shawn Guo (1):
      soc: qcom: mdt_loader: Drop PT_LOAD check on hash segment

Shay Drory (2):
      net/mlx5: Fix length of irq_index in chars
      net/mlx5: Fix setting number of EQs of SFs

Stefan Assmann (1):
      iavf: fix double unlock of crit_lock

Sylwester Dziedziuch (1):
      i40e: Fix freeing of uninitialized misc IRQ vector

Tao Liu (1):
      gve: Avoid freeing NULL pointer

Tariq Toukan (1):
      net/mlx5e: Keep the value for maximum number of channels in-sync

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Tejas Upadhyay (1):
      drm/i915/jsl: Add W/A 1409054076 for JSL

Thomas Gleixner (1):
      x86/hpet: Use another crystalball to evaluate HPET usability

Tiezhu Yang (1):
      bpf, s390: Fix potential memory leak about jit_data

Tom Lendacky (1):
      x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]

Tong Tiangen (3):
      riscv/vdso: Refactor asm/vdso.h
      riscv/vdso: Move vdso data page up front
      riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable

Tony Lindgren (2):
      soc: ti: omap-prm: Fix external abort for am335x pruss
      bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Vadim Pasternak (2):
      i2c: mlxcpld: Fix criteria for frequency setting
      i2c: mlxcpld: Modify register setting for 400KHz frequency

Vegard Nossum (1):
      x86/entry: Clear X86_FEATURE_SMAP when CONFIG_X86_SMAP=n

Ville Syrjälä (1):
      drm/i915: Extend the async flip VT-d w/a to skl/bxt

Vladimir Oltean (1):
      net: mscc: ocelot: fix VCAP filters remaining active after being deleted

Vladimir Zapolskiy (1):
      iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

Wong Vee Khee (3):
      net: pcs: xpcs: fix incorrect CL37 AN sequence
      net: pcs: xpcs: fix incorrect steps on disable EEE
      net: stmmac: trigger PCS EEE to turn off on link down

Xu Yang (2):
      usb: typec: tcpci: don't handle vSafe0V event if it's not enabled
      usb: typec: tcpm: handle SRC_STARTUP state if cc changes

Yang Yingliang (2):
      drm/nouveau/kms/nv50-: fix file release memory leak
      drm/nouveau/debugfs: fix file release memory leak

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

