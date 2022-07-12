Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA739571DC9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiGLPCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiGLPBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:01:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F7DBF558;
        Tue, 12 Jul 2022 07:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3281B60C70;
        Tue, 12 Jul 2022 14:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0460AC341D1;
        Tue, 12 Jul 2022 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637973;
        bh=y3GXlIRZVs2EKp4m8LLD3jSjd9t69smC/0aeoIhd7wA=;
        h=From:To:Cc:Subject:Date:From;
        b=hiB04Zw5OZbuOP2MPeUVKheivXTlwVMyoYJCUFJWRI48yNuJ+uoog3OLGyAWHt+hL
         xhcltReN3ChkFctczLPuw4A+pzo1wPmzcnIt4bmgQ6rj5RzZ2QRNwF+f7+7Gc7/IjA
         z+GYmlRBClBKwuLYL9NXOd5I+0P3NM4s00wtzEPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.54
Date:   Tue, 12 Jul 2022 16:59:12 +0200
Message-Id: <1657637952161138@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.54 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml |    2 
 Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml        |    3 
 MAINTAINERS                                                         |    3 
 Makefile                                                            |   17 
 arch/arm/boot/dts/at91-sam9x60ek.dts                                |    3 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                              |    6 
 arch/arm/boot/dts/stm32mp151.dtsi                                   |    4 
 arch/arm/configs/mxs_defconfig                                      |    1 
 arch/arm/include/asm/arch_gicv3.h                                   |    7 
 arch/arm/mach-at91/pm.c                                             |   10 
 arch/arm/mach-meson/platsmp.c                                       |    2 
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts                        |   54 -
 arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts        |   48 -
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts               |    2 
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts                   |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                               |    4 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                |    2 
 arch/arm64/include/asm/arch_gicv3.h                                 |    6 
 arch/arm64/net/bpf_jit_comp.c                                       |    5 
 arch/powerpc/boot/crt0.S                                            |   31 -
 arch/powerpc/crypto/md5-asm.S                                       |   10 
 arch/powerpc/crypto/sha1-powerpc-asm.S                              |    6 
 arch/powerpc/include/asm/ppc_asm.h                                  |   43 -
 arch/powerpc/kernel/entry_32.S                                      |   23 
 arch/powerpc/kernel/exceptions-64e.S                                |   14 
 arch/powerpc/kernel/exceptions-64s.S                                |    6 
 arch/powerpc/kernel/head_32.h                                       |    3 
 arch/powerpc/kernel/head_booke.h                                    |    3 
 arch/powerpc/kernel/interrupt_64.S                                  |   34 -
 arch/powerpc/kernel/optprobes_head.S                                |    4 
 arch/powerpc/kernel/tm.S                                            |   38 -
 arch/powerpc/kernel/trace/ftrace_64_mprofile.S                      |   15 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                             |    5 
 arch/powerpc/kvm/book3s_hv_uvmem.c                                  |    2 
 arch/powerpc/lib/test_emulate_step_exec_instr.S                     |    8 
 arch/powerpc/platforms/powernv/rng.c                                |   16 
 arch/riscv/configs/defconfig                                        |    8 
 arch/riscv/configs/rv32_defconfig                                   |    1 
 arch/riscv/mm/init.c                                                |    1 
 arch/s390/boot/compressed/decompressor.h                            |    1 
 arch/s390/boot/startup.c                                            |    8 
 arch/s390/kernel/entry.h                                            |    1 
 arch/s390/kernel/setup.c                                            |   31 -
 arch/s390/kernel/vmlinux.lds.S                                      |    1 
 arch/s390/kvm/kvm-s390.c                                            |   19 
 arch/s390/kvm/kvm-s390.h                                            |    4 
 arch/s390/kvm/priv.c                                                |   15 
 arch/x86/kernel/cpu/mce/core.c                                      |    8 
 arch/x86/kvm/mmu/page_track.c                                       |    4 
 arch/x86/kvm/mmu/tdp_mmu.c                                          |    9 
 arch/x86/kvm/x86.c                                                  |    4 
 block/bio.c                                                         |   11 
 block/blk-iolatency.c                                               |    2 
 block/blk-rq-qos.h                                                  |   23 
 drivers/base/core.c                                                 |    3 
 drivers/base/memory.c                                               |    2 
 drivers/base/power/runtime.c                                        |   20 
 drivers/block/Kconfig                                               |    1 
 drivers/block/drbd/drbd_main.c                                      |    8 
 drivers/block/virtio_blk.c                                          |  158 +++--
 drivers/bluetooth/btmtksdio.c                                       |    3 
 drivers/bus/mhi/core/init.c                                         |    9 
 drivers/bus/mhi/core/internal.h                                     |    2 
 drivers/clk/renesas/r9a07g044-cpg.c                                 |    4 
 drivers/cxl/core/bus.c                                              |    4 
 drivers/dma-buf/dma-buf.c                                           |   19 
 drivers/dma/at_xdmac.c                                              |    5 
 drivers/dma/idxd/device.c                                           |    5 
 drivers/dma/imx-sdma.c                                              |    2 
 drivers/dma/lgm/lgm-dma.c                                           |    3 
 drivers/dma/pl330.c                                                 |    2 
 drivers/dma/qcom/bam_dma.c                                          |   39 -
 drivers/dma/ti/dma-crossbar.c                                       |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                 |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |   25 
 drivers/gpu/drm/amd/amdgpu/cik.c                                    |    2 
 drivers/gpu/drm/amd/amdgpu/nv.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/si.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/soc15.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                               |    2 
 drivers/gpu/drm/amd/amdgpu/vi.c                                     |   17 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c               |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.h               |    7 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c               |   65 ++
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c             |    2 
 drivers/gpu/drm/i915/gem/i915_gem_context.c                         |    7 
 drivers/gpu/drm/i915/gem/i915_gem_object.c                          |    6 
 drivers/gpu/drm/i915/gt/intel_context_types.h                       |    8 
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                           |    4 
 drivers/gpu/drm/i915/gt/intel_engine_pm.c                           |   23 
 drivers/gpu/drm/i915/gt/intel_engine_pm.h                           |    2 
 drivers/gpu/drm/i915/gt/intel_engine_types.h                        |    7 
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c                |    2 
 drivers/gpu/drm/i915/gt/intel_ring_submission.c                     |    5 
 drivers/gpu/drm/i915/gt/mock_engine.c                               |    2 
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c                   |   12 
 drivers/gpu/drm/mediatek/mtk_disp_drv.h                             |   16 
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c                             |   22 
 drivers/gpu/drm/mediatek/mtk_disp_rdma.c                            |   20 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                             |  133 +++-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c                         |    4 
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h                         |   29 
 drivers/i2c/busses/i2c-cadence.c                                    |    1 
 drivers/i2c/busses/i2c-piix4.c                                      |   16 
 drivers/iio/accel/mma8452.c                                         |    4 
 drivers/input/misc/cpcap-pwrbutton.c                                |    6 
 drivers/input/touchscreen/goodix.c                                  |  150 ++--
 drivers/input/touchscreen/goodix.h                                  |   75 ++
 drivers/iommu/intel/dmar.c                                          |    2 
 drivers/irqchip/irq-gic-v3.c                                        |   42 +
 drivers/media/platform/davinci/vpif.c                               |   97 ++-
 drivers/media/platform/omap3isp/ispstat.c                           |    5 
 drivers/media/rc/ir_toy.c                                           |    2 
 drivers/memory/renesas-rpc-if.c                                     |   48 +
 drivers/misc/cardreader/rtsx_usb.c                                  |   27 
 drivers/mtd/spi-nor/core.c                                          |    3 
 drivers/net/can/grcan.c                                             |    1 
 drivers/net/can/m_can/m_can.c                                       |    8 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c                    |   22 
 drivers/net/can/usb/gs_usb.c                                        |   23 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   25 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  286 +++++----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  119 ++-
 drivers/net/dsa/qca8k.c                                             |   23 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |  147 ++++
 drivers/net/ethernet/ibm/ibmvnic.h                                  |    1 
 drivers/net/ethernet/intel/i40e/i40e.h                              |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   73 ++
 drivers/net/ethernet/intel/i40e/i40e_register.h                     |   13 
 drivers/net/ethernet/intel/i40e/i40e_type.h                         |    1 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                     |   88 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c                            |   23 
 drivers/net/ethernet/qlogic/qede/qede_filter.c                      |   47 -
 drivers/net/ethernet/realtek/r8169_main.c                           |   10 
 drivers/net/usb/usbnet.c                                            |   17 
 drivers/net/wireless/ath/ath11k/core.c                              |    5 
 drivers/net/wireless/ath/ath11k/hw.h                                |    1 
 drivers/net/wireless/ath/ath11k/pci.c                               |   12 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c                |    3 
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h                |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c                 |   31 -
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c                     |   28 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c                    |   33 -
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c                     |   47 -
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h                  |   11 
 drivers/pci/hotplug/pciehp.h                                        |    2 
 drivers/pci/hotplug/pciehp_core.c                                   |    2 
 drivers/pci/hotplug/pciehp_hpc.c                                    |   26 
 drivers/pci/pcie/portdrv.h                                          |    3 
 drivers/pci/pcie/portdrv_core.c                                     |   20 
 drivers/pci/pcie/portdrv_pci.c                                      |    3 
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c                          |   10 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                               |    2 
 drivers/platform/x86/wmi.c                                          |   39 -
 drivers/scsi/qla2xxx/qla_def.h                                      |    5 
 drivers/scsi/qla2xxx/qla_edif.c                                     |   39 -
 drivers/scsi/qla2xxx/qla_edif.h                                     |    1 
 drivers/scsi/qla2xxx/qla_init.c                                     |    2 
 drivers/scsi/qla2xxx/qla_nvme.c                                     |   27 
 drivers/scsi/qla2xxx/qla_os.c                                       |  102 +--
 drivers/soc/atmel/soc.c                                             |   12 
 drivers/tty/n_gsm.c                                                 |  263 +++++++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                   |    7 
 drivers/video/fbdev/core/fbcon.c                                    |   33 +
 drivers/video/fbdev/core/fbmem.c                                    |   16 
 fs/btrfs/block-group.c                                              |  152 +++-
 fs/btrfs/block-group.h                                              |    2 
 fs/btrfs/ctree.c                                                    |   17 
 fs/btrfs/ctree.h                                                    |    8 
 fs/btrfs/delayed-ref.h                                              |    5 
 fs/btrfs/dev-replace.c                                              |   16 
 fs/btrfs/disk-io.c                                                  |    1 
 fs/btrfs/extent-tree.c                                              |   28 
 fs/btrfs/extent_io.c                                                |    8 
 fs/btrfs/file.c                                                     |   13 
 fs/btrfs/free-space-tree.c                                          |    4 
 fs/btrfs/inode.c                                                    |    3 
 fs/btrfs/ioctl.c                                                    |   96 +--
 fs/btrfs/qgroup.c                                                   |    3 
 fs/btrfs/relocation.c                                               |   25 
 fs/btrfs/scrub.c                                                    |    6 
 fs/btrfs/tree-log.c                                                 |    2 
 fs/btrfs/volumes.c                                                  |  310 ++++++----
 fs/btrfs/volumes.h                                                  |   28 
 fs/btrfs/zoned.c                                                    |    2 
 fs/btrfs/zoned.h                                                    |   17 
 fs/gfs2/file.c                                                      |    1 
 fs/io_uring.c                                                       |   10 
 fs/nfsd/nfs3proc.c                                                  |    6 
 fs/nfsd/vfs.c                                                       |   64 +-
 fs/nfsd/vfs.h                                                       |    4 
 fs/seq_file.c                                                       |   32 +
 fs/xfs/xfs_inode.c                                                  |    1 
 include/linux/blk_types.h                                           |    3 
 include/linux/bpf.h                                                 |    6 
 include/linux/compiler-gcc.h                                        |    8 
 include/linux/compiler_attributes.h                                 |   10 
 include/linux/compiler_types.h                                      |   12 
 include/linux/fbcon.h                                               |    4 
 include/linux/hugetlb.h                                             |    6 
 include/linux/list.h                                                |   10 
 include/linux/memregion.h                                           |    2 
 include/linux/mm.h                                                  |    8 
 include/linux/pm_runtime.h                                          |    5 
 include/linux/qed/qed_eth_if.h                                      |   21 
 include/linux/rtsx_usb.h                                            |    2 
 include/linux/seq_file.h                                            |    4 
 include/linux/stddef.h                                              |   61 +
 include/linux/vmalloc.h                                             |    5 
 include/net/netfilter/nf_tables.h                                   |   10 
 include/net/netfilter/nf_tables_ipv4.h                              |    7 
 include/net/netfilter/nf_tables_ipv6.h                              |    6 
 include/uapi/linux/netfilter/nf_tables.h                            |    2 
 include/uapi/linux/omap3isp.h                                       |   21 
 include/uapi/linux/stddef.h                                         |   41 +
 include/video/of_display_timing.h                                   |    2 
 kernel/bpf/core.c                                                   |    7 
 kernel/bpf/verifier.c                                               |  150 +---
 kernel/module.c                                                     |   79 +-
 lib/idr.c                                                           |    3 
 mm/filemap.c                                                        |   12 
 mm/hugetlb.c                                                        |   10 
 mm/hwpoison-inject.c                                                |    3 
 mm/madvise.c                                                        |    2 
 mm/memory-failure.c                                                 |  205 ++++--
 mm/slub.c                                                           |    2 
 mm/util.c                                                           |   50 +
 net/batman-adv/bridge_loop_avoidance.c                              |    2 
 net/bluetooth/hci_event.c                                           |   12 
 net/can/bcm.c                                                       |   18 
 net/netfilter/nf_tables_api.c                                       |    9 
 net/netfilter/nf_tables_core.c                                      |    2 
 net/netfilter/nf_tables_trace.c                                     |    4 
 net/netfilter/nft_exthdr.c                                          |    2 
 net/netfilter/nft_meta.c                                            |    2 
 net/netfilter/nft_payload.c                                         |   63 +-
 net/netfilter/nft_set_pipapo.c                                      |   48 +
 net/rose/rose_route.c                                               |    4 
 net/rxrpc/ar-internal.h                                             |    2 
 net/rxrpc/call_accept.c                                             |    6 
 net/rxrpc/call_object.c                                             |   18 
 net/rxrpc/net_ns.c                                                  |    2 
 net/rxrpc/proc.c                                                    |   10 
 net/xdp/xsk_buff_pool.c                                             |    1 
 scripts/checkpatch.pl                                               |    3 
 scripts/kernel-doc                                                  |    9 
 sound/pci/cs46xx/cs46xx.c                                           |   22 
 sound/pci/hda/patch_realtek.c                                       |    1 
 sound/soc/codecs/rt5682-i2c.c                                       |   36 -
 sound/soc/codecs/rt5682.c                                           |  125 +---
 sound/soc/codecs/rt5682.h                                           |    4 
 sound/soc/codecs/rt700.c                                            |   16 
 sound/soc/codecs/rt711-sdca.c                                       |   27 
 sound/soc/codecs/rt711.c                                            |   25 
 sound/usb/mixer_maps.c                                              |   16 
 sound/usb/quirks.c                                                  |    4 
 tools/testing/selftests/bpf/prog_tests/timer_crash.c                |   32 -
 tools/testing/selftests/bpf/progs/timer_crash.c                     |   54 -
 tools/testing/selftests/net/forwarding/lib.sh                       |    6 
 tools/testing/selftests/net/udpgro.sh                               |    2 
 tools/testing/selftests/net/udpgro_bench.sh                         |    2 
 tools/testing/selftests/net/udpgro_fwd.sh                           |    2 
 tools/testing/selftests/net/veth.sh                                 |    6 
 virt/kvm/kvm_main.c                                                 |   14 
 266 files changed, 3771 insertions(+), 2017 deletions(-)

Alexander Egorenkov (1):
      s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE

Alexander Gordeev (2):
      s390/boot: allocate amode31 section in decompressor
      s390/setup: use physical pointers for memblock_reserve()

Alexey Dobriyan (1):
      module: fix [e_shstrndx].sh_size=0 OOB access

Amelie Delaunay (1):
      ARM: dts: stm32: use usbphyc ck_usbo_48m as USBH OHCI clock on stm32mp151

Andreas Gruenbacher (1):
      gfs2: Fix gfs2_file_buffered_write endless loop workaround

Andrei Lalaev (1):
      pinctrl: sunxi: sunxi_pconf_set: use correct offset

Andrew Gabbasov (1):
      memory: renesas-rpc-if: Avoid unaligned bus access for HyperFlash

AngeloGioacchino Del Regno (2):
      serial: 8250_mtk: Make sure to select the right FEATURE_SEL
      Revert "serial: 8250_mtk: Make sure to select the right FEATURE_SEL"

Arun Easi (2):
      scsi: qla2xxx: Fix crash during module load unload test
      scsi: qla2xxx: Fix loss of NVMe namespaces after driver reload test

Barnabás Pőcze (1):
      platform/x86: wmi: introduce helper to convert driver to WMI driver

Bryan O'Donoghue (1):
      dt-bindings: soc: qcom: smd-rpm: Fix missing MSM8936 compatible

CHANDAN VURDIGERE NATARAJ (1):
      drm/amd/display: Fix by adding FPU protection for dcn30_internal_validate_bw

Caleb Connolly (1):
      dmaengine: qcom: bam_dma: fix runtime PM underflow

Charles Keepax (2):
      ASoC: rt711: Add endianness flag in snd_soc_component_driver
      ASoC: rt711-sdca: Add endianness flag in snd_soc_component_driver

Christian Marangi (1):
      net: dsa: qca8k: reset cpu port on MTU change

Christophe JAILLET (1):
      dmaengine: lgm: Fix an error handling path in intel_ldma_probe()

Christophe Leroy (1):
      powerpc/32: Don't use lmw/stmw for saving/restoring non volatile regs

Chuck Lever (2):
      NFSD: De-duplicate net_generic(nf->nf_net, nfsd_net_id)
      NFSD: COMMIT operations must not return NFS?ERR_INVAL

Chun-Kuang Hu (4):
      drm/mediatek: Use mailbox rx_callback instead of cmdq_task_cb
      drm/mediatek: Remove the pointer of struct cmdq_client
      drm/mediatek: Detect CMDQ execution timeout
      drm/mediatek: Add cmdq_handle in mtk_crtc

Claudio Imbrenda (1):
      KVM: s390x: fix SCK locking

Claudiu Beznea (3):
      ARM: at91: pm: use proper compatible for sama5d2's rtc
      ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt
      ARM: at91: pm: use proper compatibles for sama7g5's rtc and rtt

Dan Carpenter (1):
      btrfs: fix error pointer dereference in btrfs_ioctl_rm_dev_v2()

Dan Williams (2):
      cxl/port: Hold port reference until decoder release
      memregion: Fix memregion_free() fallback definition

Daniel Borkmann (2):
      bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
      bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals

Daniel Starke (5):
      tty: n_gsm: fix frame reception handling
      tty: n_gsm: fix missing update of modem controls after DLCI open
      tty: n_gsm: fix invalid use of MSC in advanced option
      tty: n_gsm: fix sometimes uninitialized warning in gsm_dlci_modem_output()
      tty: n_gsm: fix invalid gsmtty_write_room() result

Dave Jiang (1):
      dmaengine: idxd: force wq context cleanup on device disable path

David Howells (1):
      rxrpc: Fix locking issue

Derek Fang (2):
      ASoC: rt5682: Avoid the unexpected IRQ event during going to suspend
      ASoC: rt5682: Re-detect the combo jack after resuming

Dmitry Baryshkov (1):
      arm64: dts: qcom: sdm845: use dispcc AHB clock for mdss node

Dmitry Osipenko (1):
      dmaengine: pl330: Fix lockdep warning about non-static key

Dongliang Mu (1):
      btrfs: don't access possibly stale fs_info data in device_list_add

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Eli Cohen (1):
      vdpa/mlx5: Avoid processing works if workqueue was destroyed

Eric Sandeen (1):
      xfs: remove incorrect ASSERT in xfs_rename

Eugen Hristev (2):
      ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
      ARM: dts: at91: sama5d2_icp: fix eeprom compatibles

Fabio Estevam (1):
      ARM: mxs_defconfig: Enable the framebuffer

Fabrice Gasnier (1):
      ARM: dts: stm32: add missing usbh clock and fix clk order on stm32mp15

Filipe Manana (3):
      btrfs: fix invalid delayed ref after subvolume creation failure
      btrfs: fix warning when freeing leaf after subvolume creation failure
      btrfs: fix deadlock between chunk allocation and chunk btree modifications

Florian Westphal (1):
      netfilter: nft_payload: don't allow th access for fragments

Greg Kroah-Hartman (1):
      Linux 5.15.54

Guiling Deng (1):
      fbdev: fbmem: Fix logo center image dx issue

Haibo Chen (1):
      iio: accel: mma8452: use the correct logic to get mma8452_data

Hangbin Liu (1):
      selftests/net: fix section name when using xdp_dummy.o

Hans de Goede (6):
      Input: goodix - change goodix_i2c_write() len parameter type to int
      Input: goodix - add a goodix.h header file
      Input: goodix - refactor reset handling
      Input: goodix - try not to touch the reset-pin on x86/ACPI devices
      platform/x86: wmi: Replace read_takes_no_args with a flags field
      platform/x86: wmi: Fix driver->notify() vs ->probe() race

Heiner Kallweit (1):
      r8169: fix accessing unset transport header

Heinrich Schuchardt (1):
      riscv: defconfig: enable DRM_NOUVEAU

Helge Deller (3):
      fbmem: Check virtual screen sizes in fb_set_var()
      fbcon: Disallow setting font bigger than screen size
      fbcon: Prevent that screen size is smaller than font size

Hou Tao (1):
      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

Hsin-Yi Wang (1):
      video: of_display_timing.h: include errno.h

Hui Wang (2):
      serial: sc16is7xx: Clear RS485 bits in the shutdown
      Revert "serial: sc16is7xx: Clear RS485 bits in the shutdown"

Ivan Malov (1):
      xsk: Clear page contiguity bit when unmapping pool

Jack Yu (1):
      ASoC: rt5682: move clk related code to rt5682_i2c_probe

Jann Horn (1):
      mm/slub: add missing TID updates on slab deactivation

Jason A. Donenfeld (1):
      powerpc/powernv: delay rng platform device creation until later in boot

Jean Delvare (1):
      i2c: piix4: Fix a memory leak in the EFCH MMIO support

Jens Axboe (2):
      io_uring: ensure that fsnotify is always called
      block: only mark bio as tracked if it really is tracked

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Johan Hovold (1):
      media: davinci: vpif: fix use-after-free on driver unbind

Johannes Schickel (1):
      ALSA: usb-audio: add mapping for MSI MPG X570S Carbon Max Wifi.

Johannes Thumshirn (1):
      btrfs: zoned: encapsulate inode locking for zoned relocation

Josef Bacik (3):
      btrfs: handle device lookup with btrfs_dev_lookup_args
      btrfs: add a btrfs_get_dev_args_from_path helper
      btrfs: use btrfs_get_dev_args_from_path in dev removal ioctls

Kees Cook (5):
      stddef: Introduce struct_group() helper macro
      media: omap3isp: Use struct_group() for memcpy() region
      Compiler Attributes: add __alloc_size() for better bounds checking
      bus: mhi: core: Use correctly sized arguments for bit field
      stddef: Introduce DECLARE_FLEX_ARRAY() helper

Konrad Dybcio (1):
      arm64: dts: qcom: msm8994: Fix CPU6/7 reg values

Lad Prabhakar (1):
      clk: renesas: r9a07g044: Update multiplier and divider values for PLL2/3

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Linus Torvalds (1):
      ida: don't use BUG_ON() for debugging

Liu Shixin (1):
      mm/filemap: fix UAF in find_lock_entries

Lorenzo Bianconi (4):
      mt76: mt7921: get rid of mt7921_mac_set_beacon_filter
      mt76: mt7921: introduce mt7921_mcu_set_beacon_filter utility routine
      mt76: mt7921: fix a possible race enabling/disabling runtime-pm
      mt76: mt7921: do not always disable fw runtime-pm

Luis Chamberlain (1):
      drbd: add error handling support for add_disk()

Lukas Wunner (2):
      PCI/portdrv: Rename pm_iter() to pcie_port_device_iter()
      PCI: pciehp: Ignore Link Down/Up caused by error-induced Hot Reset

Lukasz Cieplicki (1):
      i40e: Fix dropped jumbo frames statistics

Manish Rangankar (1):
      scsi: qla2xxx: Move heartbeat handling from DPC thread to workqueue

Marc Kleine-Budde (2):
      can: m_can: m_can_chip_config(): actually enable internal timestamping
      can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits

Mario Limonciello (1):
      drm/amd: Refactor `amdgpu_aspm` to be evaluated per device

Mark Rutland (2):
      irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
      irqchip/gic-v3: Refactor ISB + EOIR at ack time

Martin KaFai Lau (1):
      bpf: Stop caching subprog index in the bpf_pseudo_func insn

Matthew Brost (1):
      drm/i915: Disable bonding on gen12+ platforms

Maurizio Avogadro (1):
      ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.

Max Gurtovoy (1):
      virtio-blk: avoid preallocating big SGL for data

Miaohe Lin (1):
      mm/memory-failure.c: fix race with changing page compound again

Miaoqian Lin (3):
      ARM: meson: Fix refcount leak in meson_smp_prepare_cpus
      dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate
      dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Michael Strauss (1):
      drm/amd/display: Set min dcfclk if pipe count is 0

Michael Walle (1):
      dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Michel Dänzer (1):
      dma-buf/poll: Get a file reference for outstanding fence callbacks

Mihai Sain (1):
      ARM: at91: fix soc detection for SAM9X60 SiPs

Naohiro Aota (1):
      btrfs: zoned: use dedicated lock for data relocation

Naoya Horiguchi (3):
      mm/hwpoison: mf_mutex for soft offline and unpoison
      mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()
      Revert "mm/memory-failure.c: fix race with changing page compound again"

Nicholas Piggin (2):
      powerpc: flexible GPR range save/restore macros
      powerpc/tm: Fix more userspace r13 corruption

Niels Dossche (1):
      Bluetooth: protect le accept and resolv lists with hdev->lock

Nikolay Borisov (2):
      btrfs: rename btrfs_alloc_chunk to btrfs_create_chunk
      btrfs: add additional parameters to btrfs_init_tree_ref/btrfs_init_data_ref

Norbert Zulinski (1):
      i40e: Fix VF's MAC Address change on VM

Oliver Hartkopp (1):
      can: bcm: use call_rcu() instead of costly synchronize_rcu()

Oliver Neukum (1):
      usbnet: fix memory leak in error case

Oliver Upton (1):
      KVM: Don't create VM debugfs files outside of the VM directory

Pablo Neira Ayuso (4):
      netfilter: nft_set_pipapo: release elements in clone from abort path
      netfilter: nf_tables: stricter validation of element data
      netfilter: nf_tables: convert pktinfo->tprot_set to flags field
      netfilter: nft_payload: support for inner header matching / mangling

Palmer Dabbelt (2):
      RISC-V: defconfigs: Set CONFIG_FB=y, for FB console
      riscv/mm: Add XIP_FIXUP for riscv_pfn_base

Paolo Bonzini (2):
      mm: vmalloc: introduce array allocation functions
      KVM: use __vcalloc for very large allocations

Paul Davey (1):
      bus: mhi: Fix pm_state conversion to string

Pavel Begunkov (2):
      block: use bdev_get_queue() in bio.c
      io_uring: avoid io-wq -EAGAIN looping for !IOPOLL

Peng Fan (9):
      arm64: dts: imx8mp-evk: correct mmc pad settings
      arm64: dts: imx8mp-evk: correct gpio-led pad settings
      arm64: dts: imx8mp-evk: correct vbus pad settings
      arm64: dts: imx8mp-evk: correct eqos pad settings
      arm64: dts: imx8mp-evk: correct I2C1 pad settings
      arm64: dts: imx8mp-evk: correct I2C3 pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct eqos pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct i2c2 & mmc settings

Peter Robinson (1):
      dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Peter Ujfalusi (1):
      ASoC: rt5682: Fix deadlock on resume

Pierre-Louis Bossart (1):
      ASoC: codecs: rt700/rt711/rt711-sdca: resume bus/codec in .set_jack_detect

Po-Hsu Lin (1):
      Revert "selftests/bpf: Add test for bpf_timer overwriting crash"

Qu Wenruo (1):
      btrfs: remove device item and update super block in the same transaction

Quinn Tran (2):
      scsi: qla2xxx: Fix laggy FC remote port session recovery
      scsi: qla2xxx: edif: Replace list_for_each_safe with list_for_each_entry_safe

Rafael J. Wysocki (1):
      PM: runtime: Redefine pm_runtime_release_supplier()

Rex-BC Chen (1):
      drm/mediatek: Add vblank register/unregister callback functions

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Richard Gong (1):
      drm/amdgpu: vi: disable ASPM on Intel Alder Lake based systems

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Roi Dayan (4):
      net/mlx5e: Check action fwd/drop flag exists also for nic flows
      net/mlx5e: Split actions_match_supported() into a sub function
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions

Samuel Holland (2):
      pinctrl: sunxi: a83t: Fix NAND function name for some pins
      dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

Satish Nagireddy (1):
      i2c: cadence: Unregister the clk notifier in error path

Sean Christopherson (3):
      KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier unmapping
      KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap hook
      KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref

Sean Wang (2):
      mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
      Bluetooth: btmtksdio: fix use-after-free at btmtksdio_recv_event

Sean Young (1):
      media: ir_toy: prevent device from hanging during transmit

Sebastian Andrzej Siewior (1):
      batman-adv: Use netif_rx().

Seevalamuthu Mariappan (1):
      ath11k: add hw_param for wakeup_mhi

Shai Malin (1):
      qed: Improve the stack space of filter_config()

Sherry Sun (1):
      arm64: dts: imx8mp-evk: correct the uart2 pinctl value

Shuah Khan (4):
      module: change to print useful messages from elf_validity_check()
      misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
      misc: rtsx_usb: use separate command and response buffers
      misc: rtsx_usb: set return value in rsp_buf alloc err path

Stephan Gerhold (1):
      arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo

Sukadev Bhattiprolu (3):
      ibmvnic: init init_done_rc earlier
      ibmvnic: clear fop when retrying probe
      ibmvnic: Allow queueing resets during probe

Tadeusz Struk (1):
      uapi/linux/stddef.h: Add include guards

Takashi Iwai (2):
      ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD
      ALSA: cs46xx: Fix missing snd_card_free() call at probe error

Tang Bin (1):
      Input: cpcap-pwrbutton - handle errors from platform_get_irq()

Tejun Heo (1):
      block: fix rq-qos breakage from skipping rq_qos_done_bio()

Thomas Hellström (2):
      drm/i915/gt: Register the migrate contexts with their engines
      drm/i915: Fix a race between vma / object destruction and unbinding

Thomas Kopp (2):
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo L140PU

Tom Rix (1):
      btrfs: fix use of uninitialized variable at rm device ioctl

Tudor Ambarus (1):
      mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set

Ville Syrjälä (1):
      drm/i915: Replace the unconditional clflush with drm_clflush_virt_range()

Vladimir Lypak (1):
      dt-bindings: soc: qcom: smd-rpm: Add compatible for MSM8953 SoC

Vladimir Oltean (3):
      selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
      selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
      selftests: forwarding: fix error message in learning_test

Wu Bo (1):
      drbd: Fix double free problem in drbd_create_device

Xiaomeng Tong (2):
      drbd: fix an invalid memory access caused by incorrect use of list iterator
      ASoC: rt5682: fix an incorrect NULL check on list iterator

Ye Guojin (1):
      virtio-blk: modify the value type of num in virtio_queue_rq()

Yian Chen (1):
      iommu/vt-d: Fix PCI bus rescan device hot add

Zhenguo Zhao (2):
      tty: n_gsm: Modify CR,PF bit when config requester
      tty: n_gsm: Save dlci address open status when config requester

daniel.starke@siemens.com (1):
      tty: n_gsm: fix encoding of command/response bit

luofei (1):
      mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler

tiancyin (1):
      drm/amd/vcn: fix an error msg on vcn 3.0

