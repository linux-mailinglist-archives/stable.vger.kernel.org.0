Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F377562B5FC
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 10:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiKPJGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 04:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiKPJGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 04:06:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA221261;
        Wed, 16 Nov 2022 01:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C2CEB81C37;
        Wed, 16 Nov 2022 09:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599C0C433D6;
        Wed, 16 Nov 2022 09:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668589581;
        bh=B2r0BMTnj3trngjVnEB9jZvVjPdXqbD6gveHp3VELqs=;
        h=From:To:Cc:Subject:Date:From;
        b=EVH35eXrhLSeE+kb2Fon6zoLd9x6ELK3FRWRzN0kCSrgtkAjbwpH1lFwUT+kcnTub
         JemnWDBqzYLZyGhyW2Nhioi4yv3OgvYhGukwg8qTxCIti1rOrpRPzLlB+2GSDmUbzp
         4oL3YOvC8Xp6Jv0owxYW76B21zEZK4VWxxp+NKMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.9
Date:   Wed, 16 Nov 2022 10:06:12 +0100
Message-Id: <16685895732936@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.9 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/engleder,tsnep.yaml          |    2 
 Documentation/virt/kvm/devices/vm.rst                              |    3 
 Makefile                                                           |    2 
 arch/arm64/kernel/efi.c                                            |   52 ++-
 arch/m68k/include/uapi/asm/bootinfo-virt.h                         |    9 
 arch/m68k/include/uapi/asm/bootinfo.h                              |    7 
 arch/m68k/kernel/setup_mm.c                                        |   12 
 arch/m68k/virt/config.c                                            |   11 
 arch/mips/kernel/jump_label.c                                      |    2 
 arch/riscv/kernel/process.c                                        |    2 
 arch/riscv/kernel/setup.c                                          |    1 
 arch/riscv/kernel/vdso/Makefile                                    |    2 
 arch/riscv/mm/init.c                                               |    1 
 arch/s390/kvm/kvm-s390.c                                           |   26 +
 arch/s390/kvm/kvm-s390.h                                           |    1 
 arch/s390/kvm/pci.c                                                |    2 
 arch/x86/include/asm/msr-index.h                                   |    8 
 arch/x86/kernel/asm-offsets.c                                      |    6 
 arch/x86/kernel/cpu/amd.c                                          |    6 
 arch/x86/kernel/cpu/hygon.c                                        |    4 
 arch/x86/kvm/.gitignore                                            |    2 
 arch/x86/kvm/Makefile                                              |   12 
 arch/x86/kvm/kvm-asm-offsets.c                                     |   27 +
 arch/x86/kvm/mmu/mmu.c                                             |    4 
 arch/x86/kvm/svm/sev.c                                             |    2 
 arch/x86/kvm/svm/svm.c                                             |   24 -
 arch/x86/kvm/svm/svm.h                                             |    4 
 arch/x86/kvm/svm/vmenter.S                                         |  134 +++++---
 arch/x86/kvm/vmx/vmenter.S                                         |    2 
 arch/x86/kvm/x86.c                                                 |   16 -
 arch/x86/mm/hugetlbpage.c                                          |    4 
 arch/x86/power/cpu.c                                               |    1 
 drivers/ata/libata-scsi.c                                          |    3 
 drivers/cxl/core/region.c                                          |   20 +
 drivers/dma/apple-admac.c                                          |    2 
 drivers/dma/at_hdmac.c                                             |  153 +++-------
 drivers/dma/at_hdmac_regs.h                                        |   10 
 drivers/dma/idxd/cdev.c                                            |   18 +
 drivers/dma/idxd/device.c                                          |   26 +
 drivers/dma/idxd/idxd.h                                            |   34 ++
 drivers/dma/idxd/init.c                                            |   24 +
 drivers/dma/idxd/registers.h                                       |    2 
 drivers/dma/idxd/sysfs.c                                           |   11 
 drivers/dma/mv_xor_v2.c                                            |    1 
 drivers/dma/pxa_dma.c                                              |    4 
 drivers/dma/stm32-dma.c                                            |   14 
 drivers/dma/ti/k3-udma-glue.c                                      |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                             |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c                       |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                           |   34 --
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                            |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c                           |   49 ++-
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c     |   32 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c       |   52 ++-
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c  |   24 +
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c             |    4 
 drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h                    |   15 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h       |   15 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c            |    4 
 drivers/gpu/drm/i915/display/intel_dp.c                            |    2 
 drivers/gpu/drm/i915/display/intel_lvds.c                          |    3 
 drivers/gpu/drm/i915/display/intel_panel.c                         |   29 -
 drivers/gpu/drm/i915/display/intel_panel.h                         |    2 
 drivers/gpu/drm/i915/display/intel_psr.c                           |    5 
 drivers/gpu/drm/i915/display/intel_sdvo.c                          |    6 
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c                         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c                          |    4 
 drivers/gpu/drm/i915/gvt/kvmgt.c                                   |    3 
 drivers/gpu/drm/vc4/vc4_drv.c                                      |    7 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                     |   21 +
 drivers/gpu/drm/vc4/vc4_hdmi.h                                     |    1 
 drivers/hid/hid-hyperv.c                                           |    2 
 drivers/hid/wacom_wac.c                                            |   11 
 drivers/hwspinlock/qcom_hwspinlock.c                               |    2 
 drivers/mmc/host/sdhci-brcmstb.c                                   |    3 
 drivers/mmc/host/sdhci-cqhci.h                                     |   24 +
 drivers/mmc/host/sdhci-esdhc-imx.c                                 |    7 
 drivers/mmc/host/sdhci-of-arasan.c                                 |    3 
 drivers/mmc/host/sdhci-tegra.c                                     |    3 
 drivers/mmc/host/sdhci_am654.c                                     |    7 
 drivers/net/can/at91_can.c                                         |    2 
 drivers/net/can/c_can/c_can_main.c                                 |    2 
 drivers/net/can/can327.c                                           |    2 
 drivers/net/can/cc770/cc770.c                                      |    2 
 drivers/net/can/ctucanfd/ctucanfd_base.c                           |    2 
 drivers/net/can/dev/skb.c                                          |    9 
 drivers/net/can/flexcan/flexcan-core.c                             |    2 
 drivers/net/can/grcan.c                                            |    2 
 drivers/net/can/ifi_canfd/ifi_canfd.c                              |    2 
 drivers/net/can/janz-ican3.c                                       |    2 
 drivers/net/can/kvaser_pciefd.c                                    |    2 
 drivers/net/can/m_can/m_can.c                                      |    2 
 drivers/net/can/mscan/mscan.c                                      |    2 
 drivers/net/can/pch_can.c                                          |    2 
 drivers/net/can/peak_canfd/peak_canfd.c                            |    2 
 drivers/net/can/rcar/rcar_can.c                                    |    2 
 drivers/net/can/rcar/rcar_canfd.c                                  |   15 
 drivers/net/can/sja1000/sja1000.c                                  |    2 
 drivers/net/can/slcan/slcan-core.c                                 |    2 
 drivers/net/can/softing/softing_main.c                             |    2 
 drivers/net/can/spi/hi311x.c                                       |    2 
 drivers/net/can/spi/mcp251x.c                                      |    2 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c                       |    2 
 drivers/net/can/sun4i_can.c                                        |    2 
 drivers/net/can/ti_hecc.c                                          |    2 
 drivers/net/can/usb/ems_usb.c                                      |    2 
 drivers/net/can/usb/esd_usb.c                                      |    2 
 drivers/net/can/usb/etas_es58x/es58x_core.c                        |    2 
 drivers/net/can/usb/gs_usb.c                                       |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                   |    2 
 drivers/net/can/usb/mcba_usb.c                                     |    2 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                       |    2 
 drivers/net/can/usb/ucan.c                                         |    2 
 drivers/net/can/usb/usb_8dev.c                                     |    2 
 drivers/net/can/xilinx_can.c                                       |    2 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c                   |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c                 |    2 
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c         |   18 -
 drivers/net/ethernet/broadcom/Kconfig                              |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                  |    2 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                    |    1 
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                |    2 
 drivers/net/ethernet/freescale/fman/mac.c                          |    9 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                    |    2 
 drivers/net/ethernet/intel/ice/ice_base.c                          |    2 
 drivers/net/ethernet/intel/ice/ice_lib.c                           |   25 +
 drivers/net/ethernet/intel/ice/ice_lib.h                           |    1 
 drivers/net/ethernet/intel/ice/ice_vf_lib.c                        |    5 
 drivers/net/ethernet/marvell/mv643xx_eth.c                         |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c           |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c               |  135 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h           |   57 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c             |   32 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h             |    1 
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c              |    7 
 drivers/net/ethernet/mediatek/mtk_star_emac.c                      |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c            |   31 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c            |   92 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                  |   24 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                    |    5 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                  |   14 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |   18 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   14 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                 |    3 
 drivers/net/ethernet/neterion/s2io.c                               |   29 +
 drivers/net/ethernet/ni/nixge.c                                    |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                  |   11 
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c               |   39 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c                |    8 
 drivers/net/ethernet/sunplus/spl2sw_driver.c                       |    1 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                           |    2 
 drivers/net/ethernet/ti/cpsw.c                                     |    2 
 drivers/net/ethernet/tundra/tsi108_eth.c                           |    5 
 drivers/net/hamradio/bpqether.c                                    |    2 
 drivers/net/macsec.c                                               |   23 -
 drivers/net/macvlan.c                                              |    4 
 drivers/net/phy/mscc/mscc_macsec.c                                 |    1 
 drivers/net/tun.c                                                  |   18 -
 drivers/net/wan/lapbether.c                                        |    3 
 drivers/net/wireless/ath/ath11k/reg.c                              |    6 
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c                          |    8 
 drivers/net/wwan/iosm/iosm_ipc_mux.h                               |    1 
 drivers/net/wwan/iosm/iosm_ipc_pcie.c                              |   11 
 drivers/net/wwan/iosm/iosm_ipc_wwan.c                              |    1 
 drivers/net/wwan/mhi_wwan_mbim.c                                   |    1 
 drivers/pci/controller/pci-hyperv.c                                |   22 +
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c                          |    2 
 drivers/phy/ralink/phy-mt7621-pci.c                                |    3 
 drivers/phy/st/phy-stm32-usbphyc.c                                 |    2 
 drivers/platform/x86/hp-wmi.c                                      |   12 
 drivers/platform/x86/p2sb.c                                        |   15 
 drivers/soundwire/qcom.c                                           |    9 
 drivers/spi/spi-intel.c                                            |    8 
 drivers/spi/spi-mt65xx.c                                           |   23 -
 drivers/thunderbolt/tb.c                                           |   28 +
 fs/btrfs/disk-io.c                                                 |    4 
 fs/btrfs/tests/btrfs-tests.c                                       |    2 
 fs/btrfs/volumes.c                                                 |   39 +-
 fs/btrfs/volumes.h                                                 |    2 
 fs/btrfs/zoned.c                                                   |   40 ++
 fs/btrfs/zoned.h                                                   |   11 
 fs/nilfs2/segment.c                                                |   15 
 fs/nilfs2/super.c                                                  |    2 
 fs/nilfs2/the_nilfs.c                                              |    2 
 fs/udf/namei.c                                                     |    2 
 include/asm-generic/vmlinux.lds.h                                  |    2 
 include/linux/bpf_verifier.h                                       |   21 +
 include/linux/can/dev.h                                            |   16 +
 include/linux/skmsg.h                                              |    2 
 include/uapi/linux/capability.h                                    |    2 
 include/uapi/linux/idxd.h                                          |    1 
 io_uring/kbuf.c                                                    |    2 
 kernel/bpf/verifier.c                                              |  148 ++-------
 mm/damon/dbgfs.c                                                   |    7 
 mm/hugetlb_vmemmap.c                                               |    1 
 mm/memremap.c                                                      |    1 
 mm/userfaultfd.c                                                   |    2 
 net/can/af_can.c                                                   |    2 
 net/can/isotp.c                                                    |   71 ++--
 net/can/j1939/main.c                                               |    3 
 net/core/skbuff.c                                                  |   36 +-
 net/core/skmsg.c                                                   |    7 
 net/core/sock_map.c                                                |    7 
 net/ipv4/tcp.c                                                     |    2 
 net/ipv4/tcp_bpf.c                                                 |    8 
 net/ipv6/addrlabel.c                                               |    1 
 net/mac80211/s1g.c                                                 |    3 
 net/mac80211/tx.c                                                  |    5 
 net/mctp/af_mctp.c                                                 |    4 
 net/mctp/route.c                                                   |    2 
 net/netfilter/nf_tables_api.c                                      |    3 
 net/netfilter/nfnetlink.c                                          |    1 
 net/tipc/netlink_compat.c                                          |    2 
 net/wireless/reg.c                                                 |   12 
 net/wireless/scan.c                                                |    4 
 sound/arm/pxa2xx-ac97-lib.c                                        |    4 
 sound/core/memalloc.c                                              |   15 
 sound/hda/hdac_sysfs.c                                             |    4 
 sound/pci/hda/hda_intel.c                                          |    3 
 sound/pci/hda/patch_ca0132.c                                       |    1 
 sound/pci/hda/patch_realtek.c                                      |    2 
 sound/usb/card.c                                                   |   29 +
 sound/usb/quirks-table.h                                           |    4 
 sound/usb/quirks.c                                                 |    1 
 tools/arch/x86/include/asm/msr-index.h                             |    8 
 tools/bpf/bpftool/common.c                                         |    3 
 tools/perf/.gitignore                                              |    1 
 tools/perf/tests/shell/test_brstack.sh                             |    5 
 tools/perf/util/parse-branch-options.c                             |    4 
 tools/perf/util/stat-display.c                                     |    6 
 virt/kvm/kvm_main.c                                                |   13 
 235 files changed, 1682 insertions(+), 961 deletions(-)

Alex Barba (1):
      bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Alexander Potapenko (1):
      ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Amelie Delaunay (1):
      dmaengine: stm32-dma: fix potential race between pause and resume

Andy Shevchenko (1):
      platform/x86: p2sb: Don't fail if unknown CPU is found

Antoine Tenart (2):
      net: phy: mscc: macsec: clear encryption keys when freeing a flow
      net: atlantic: macsec: clear encryption keys from the stack

Ard Biesheuvel (1):
      arm64: efi: Fix handling of misaligned runtime regions and drop warning

Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Athira Rajeev (1):
      perf stat: Fix printing os->prefix in CSV metrics output

Borislav Petkov (1):
      x86/cpu: Restore AMD's DE_CFG MSR after resume

Brian Norris (6):
      mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI
      mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
      mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI
      mmc: sdhci_am654: Fix SDHCI_RESET_ALL for CQHCI
      mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI
      mms: sdhci-esdhc-imx: Fix SDHCI_RESET_ALL for CQHCI

Chris Mi (1):
      net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode

Christian König (1):
      drm/amdgpu: workaround for TLB seq race

Christophe JAILLET (1):
      dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Chuang Wang (1):
      net: macvlan: fix memory leaks of macvlan_common_newlink

Cong Wang (1):
      bpf, sock_map: Move cancel_work_sync() out of sock lock

Conor Dooley (1):
      riscv: fix reserved memory setup

Dan Carpenter (1):
      phy: stm32: fix an error code in probe

Dan Williams (1):
      cxl/region: Recycle region ids

Dave Jiang (1):
      dmanegine: idxd: reformat opcap output to match bitmap_parse() input

Dexuan Cui (1):
      PCI: hv: Fix the definition of vector in hv_compose_msi_msg()

Dillon Varone (2):
      drm/amd/display: Acquire FCLK DPM levels on DCN32
      drm/amd/display: Set memclk levels to be at least 1 for dcn32

Donglin Peng (1):
      perf tools: Add the include/perf/ directory to .gitignore

Doug Brown (1):
      dmaengine: pxa_dma: use platform_get_irq_optional

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo C6300 model quirk

Eric Dumazet (1):
      net: tun: call napi_schedule_prep() to ensure we own a napi

Evan Quan (1):
      ALSA: hda/hdmi - enable runtime pm for more AMD display audio

Felix Kuehling (2):
      drm/amdkfd: Fix error handling in criu_checkpoint
      drm/amdkfd: Fix error handling in kfd_criu_restore_events

Fenghua Yu (1):
      dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing

Fengqian Gao (1):
      dmaengine: idxd: fix RO device state error after been disabled/reset

Gaosheng Cui (1):
      capabilities: fix undefined behavior in bit shift for CAP_TO_MASK

Geert Uytterhoeven (1):
      can: rcar_canfd: Add missing ECC error checks for channels 2-7

Greg Kroah-Hartman (1):
      Linux 6.0.9

Guchun Chen (1):
      drm/amdgpu: disable BACO on special BEIGE_GOBY card

HW He (2):
      net: wwan: iosm: fix memory leak in ipc_wwan_dellink
      net: wwan: mhi: fix memory leak in mhi_mbim_dellink

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA

Hou Wenlong (1):
      KVM: debugfs: Return retval of simple_attr_open() if it fails

Howard Hsu (1):
      wifi: mac80211: Set TWT Information Frame Disabled bit as 1

James Clark (1):
      perf test: Fix skipping branch stack sampling test

Jason A. Donenfeld (1):
      m68k: Rework BI_VIRT_RNG_SEED as BI_RNG_SEED

Jason Gerecke (1):
      HID: wacom: Fix logic used for 3rd barrel switch emulation

Jason Gunthorpe (1):
      drm/i915/gvt: Add missing vfio_unregister_group_dev() call

Jens Axboe (1):
      io_uring: check for rollover of buffer ID when providing buffers

Jianbo Liu (1):
      net/mlx5e: TC, Fix wrong rejection of packet-per-second policing

Jiaxun Yang (1):
      MIPS: jump_label: Fix compat branch range check

Jiri Benc (1):
      net: gso: fix panic on frag_list with mixed head alloc types

Jisheng Zhang (2):
      riscv: process: fix kernel info leakage
      riscv: vdso: fix build with llvm

Johan Hovold (1):
      phy: qcom-qmp-combo: fix NULL-deref on runtime resume

Johannes Berg (1):
      wifi: cfg80211: silence a sparse RCU warning

Johannes Thumshirn (2):
      btrfs: zoned: clone zoned device info when cloning a device
      btrfs: zoned: initialize device's zone info for seeding

John Thomson (1):
      phy: ralink: mt7621-pci: add sentinel to quirks table

Jorge Lopez (1):
      platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Jouni Högander (1):
      drm/i915/psr: Send update also on invalidate

Jun Lei (1):
      drm/amd/display: Limit dcn32 to 1950Mhz display clock

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Kees Cook (1):
      bpf, verifier: Fix memory leak in array reallocation for stack state

Krzysztof Kozlowski (1):
      hwspinlock: qcom: correct MMIO max register for newer SoCs

Kumar Kartikeya Dwivedi (1):
      bpf: Add helper macro bpf_for_each_reg_in_vstate

Like Xu (1):
      KVM: x86/pmu: Do not speculatively query Intel GP PMCs that don't exist yet

Liu Shixin (1):
      btrfs: fix match incorrectly in dev_args_match_device

Lu Wei (1):
      tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

M Chetan Kumar (2):
      net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
      net: wwan: iosm: fix invalid mux header type

Ma Jun (1):
      drm/amdgpu: Fix the lpfn checking condition in drm buddy

Martin Povišer (1):
      dmaengine: apple-admac: Fix grabbing of channels in of_xlate

Matthew Auld (1):
      drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Maxim Mikityanskiy (1):
      net/mlx5e: Add missing sanity checks for max TX WQE size

Michael Chan (1):
      bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

Michal Jaron (1):
      iavf: Fix VF driver counting VLAN 0 filters

Mika Westerberg (1):
      spi: intel: Use correct mask for flash and protected regions

Miquel Raynal (1):
      dt-bindings: net: tsnep: Fix typo on generic nvmem property

Namhyung Kim (1):
      perf stat: Fix crash with --per-node --metric-only in CSV mode

Naoya Horiguchi (1):
      arch/x86/mm/hugetlbpage.c: pud_huge() returns 0 when using 2-level paging

Nathan Chancellor (1):
      vmlinux.lds.h: Fix placement of '.data..decrypted' section

Nicholas Kazlauskas (2):
      drm/amd/display: Fix reg timeout in enc314_enable_fifo
      drm/amd/display: Update SR watermarks for DCN314

Nico Boehr (1):
      KVM: s390: pv: don't allow userspace to set the clock under PV

Niranjana Vishwanathapura (1):
      drm/i915: Do not set cache_dirty for DGFX

Norbert Zulinski (1):
      ice: Fix spurious interrupt during removal of trusted VF

Oliver Hartkopp (3):
      can: j1939: j1939_send_one(): fix missing CAN header initialization
      can: isotp: fix tx state handling for echo tx processing
      can: dev: fix skb drop check

Pankaj Gupta (1):
      mm/memremap.c: map FS_DAX device memory as decrypted

Paolo Bonzini (5):
      KVM: x86: use a separate asm-offsets.c file
      KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm
      KVM: SVM: adjust register allocation for __svm_vcpu_run()
      KVM: SVM: retrieve VMCB from assembly
      KVM: SVM: move guest vmsave/vmload back to assembly

Peter Gonda (1):
      KVM: SVM: Only dump VMSA to klog at KERN_DEBUG level

Peter Xu (1):
      mm/shmem: use page_mapping() to detect page cache for uffd continue

Philip Yang (2):
      drm/amdkfd: handle CPU fault on COW mapping
      drm/amdkfd: Migrate in CPU page fault use current mm

Pu Lehui (1):
      bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Rafael Mendonca (1):
      KVM: s390: pci: Fix allocation size of aift kzdev elements

Rasmus Villemoes (1):
      net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()

Ratheesh Kannoth (2):
      octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
      octeontx2-pf: Fix SQE threshold checking

Roger Quadros (1):
      net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload

Roi Dayan (2):
      net/mlx5e: Fix tc acts array not to be dependent on enum order
      net/mlx5e: E-Switch, Fix comparing termination table instance

Roy Novich (1):
      net/mlx5: Allow async trigger completion execution on single CPU systems

Ryusuke Konishi (2):
      nilfs2: fix deadlock in nilfs_count_free_blocks()
      nilfs2: fix use-after-free bug of ns_writer on remount

Sabrina Dubroca (4):
      macsec: delete new rxsc when offload fails
      macsec: fix secy->n_rx_sc accounting
      macsec: fix detection of RXSCs when toggling offloading
      macsec: clear encryption keys from the stack after setting up offload

Sanjay R Mehta (1):
      thunderbolt: Add DP OUT resource when DP tunnel is discovered

Sean Anderson (1):
      net: fman: Unregister ethernet device on removal

Sean Christopherson (1):
      KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range()

SeongJae Park (1):
      mm/damon/dbgfs: check if rm_contexts input is for a real context

Shay Drory (1):
      net/mlx5: fw_reset: Don't try to load device in case PCI isn't working

Shigeru Yoshida (1):
      netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()

Shin'ichiro Kawasaki (1):
      ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure

Srinivas Kandagatla (2):
      soundwire: qcom: reinit broadcast completion
      soundwire: qcom: check for outanding writes before doing a read

Stefan Binding (1):
      ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41

Takashi Iwai (4):
      ALSA: memalloc: Don't fall back for SG-buffer with IOMMU
      ALSA: usb-audio: Yet more regression for for the delayed card registration
      ALSA: usb-audio: Add quirk entry for M-Audio Micro
      ALSA: memalloc: Try dma_alloc_noncontiguous() at first

Tan, Tee Min (1):
      stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz

Tim Huang (1):
      drm/amd/pm: update SMU IP v13.0.4 msg interface header

Tudor Ambarus (15):
      dmaengine: at_hdmac: Fix at_lli struct definition
      dmaengine: at_hdmac: Don't start transactions at tx_submit level
      dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pending
      dmaengine: at_hdmac: Fix premature completion of desc in issue_pending
      dmaengine: at_hdmac: Do not call the complete callback on device_terminate_all
      dmaengine: at_hdmac: Protect atchan->status with the channel lock
      dmaengine: at_hdmac: Fix concurrency problems by removing atc_complete_all()
      dmaengine: at_hdmac: Fix concurrency over descriptor
      dmaengine: at_hdmac: Free the memset buf without holding the chan lock
      dmaengine: at_hdmac: Fix concurrency over the active list
      dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardware
      dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
      dmaengine: at_hdmac: Don't allow CPU to reorder channel enable
      dmaengine: at_hdmac: Fix impossible condition
      dmaengine: at_hdmac: Check return code of dma_async_device_register

Vasily Gorbik (1):
      mm: hugetlb_vmemmap: include missing linux/moduleparam.h

Ville Syrjälä (3):
      drm/i915: Allow more varied alternate fixed modes for panels
      drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()
      drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs

Vlad Buslov (1):
      net/mlx5: Bridge, verify LAG state when adding bond to bridge

Wang Yufen (2):
      bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues
      net: tun: Fix memory leaks of napi_get_frags

Wei Yongjun (2):
      mctp: Fix an error handling path in mctp_init()
      eth: sp7021: drop free_netdev() from spl2sw_init_netdev()

Wen Gong (1):
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Xian Wang (1):
      ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Xiaochen Shen (1):
      dmaengine: idxd: Fix max batch size for Intel IAA

Xin Long (1):
      tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Yang Li (1):
      drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()

Yang Yingliang (6):
      ALSA: arm: pxa: pxa2xx-ac97-lib: fix return value check of platform_get_irq()
      HID: hyperv: fix possible memory leak in mousevsc_probe()
      dmaengine: ti: k3-udma-glue: fix memory leak when register device fail
      stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
      stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
      stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

Ye Bin (1):
      ALSA: hda: fix potential memleak in 'add_widget_node'

Youlin Li (1):
      bpf: Fix wrong reg type conversion in release_reference()

Yuan Can (1):
      drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()

YueHaibing (1):
      net: broadcom: Fix BCMGENET Kconfig

Zhang Xiaoxu (1):
      btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()

ZhangPeng (1):
      udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Zhengchao Shao (15):
      wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
      net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
      hamradio: fix issue of dev reference count leakage in bpq_device_event()
      can: af_can: fix NULL pointer dereference in can_rx_register()
      net: lapbether: fix issue of invalid opcode in lapbeth_open()
      net: ethernet: mtk-star-emac: disable napi when connect and start PHY failed in mtk_star_enable()
      drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
      net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
      net: nixge: disable napi when enable interrupts failed in nixge_open()
      net: cpsw: disable napi in cpsw_ndo_open()
      net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
      cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
      ethernet: s2io: disable napi when start nic failed in s2io_card_up()
      net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
      ethernet: tundra: free irq when alloc ring failed in tsi108_open()

Ziyang Xuan (1):
      netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

maxime@cerno.tech (1):
      drm/vc4: hdmi: Fix HSM clock too low on Pi4

zhichao.liu (1):
      spi: mediatek: Fix package division error

