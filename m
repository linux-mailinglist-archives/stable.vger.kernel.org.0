Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8361C5A0D34
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbiHYJul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiHYJuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:50:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1FABD49;
        Thu, 25 Aug 2022 02:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3773CB827EA;
        Thu, 25 Aug 2022 09:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547B5C433C1;
        Thu, 25 Aug 2022 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420893;
        bh=Mj54xxBiHITRYgn6VL8JxcSUBz3jx97Cc2boC+qYkuA=;
        h=From:To:Cc:Subject:Date:From;
        b=Vn7Mf01lnW837WVF19SMtP1Cj/yw6ifRLXerqv9LmuSac1tIMU6IsGoMLftojvu6H
         TLmRFP5/xsDj/MEtixJfJfxbJ6kpHsd2kfci48RTuhw3KX3IFaExDCx8S/Aty0uuJE
         rUjle1QDLykof8zKW7StWWhA0kynbDz38VyN3MC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.4
Date:   Thu, 25 Aug 2022 11:47:49 +0200
Message-Id: <166142086964119@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.4 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/kernel.rst                             |   12 
 Documentation/atomic_bitops.txt                                         |    2 
 Documentation/devicetree/bindings/arm/qcom.yaml                         |   18 
 Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml           |   16 
 Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml |    4 
 Documentation/devicetree/bindings/gpio/gpio-zynq.yaml                   |    6 
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml             |   28 
 Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml              |   15 
 Documentation/devicetree/bindings/pci/qcom,pcie.yaml                    |    2 
 Documentation/devicetree/bindings/pinctrl/pinctrl-mt8186.yaml           |   29 
 Documentation/devicetree/bindings/pinctrl/pinctrl-mt8192.yaml           |   58 -
 Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml           |   37 
 Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml  |   11 
 Documentation/devicetree/bindings/spi/qcom,spi-geni-qcom.yaml           |    5 
 Documentation/devicetree/bindings/spi/spi-cadence.yaml                  |    7 
 Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml              |    7 
 Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml            |    1 
 Documentation/firmware-guide/acpi/apei/einj.rst                         |    2 
 Makefile                                                                |    8 
 arch/arm64/include/asm/kvm_host.h                                       |    4 
 arch/arm64/kvm/arm.c                                                    |    3 
 arch/arm64/kvm/guest.c                                                  |    2 
 arch/arm64/kvm/sys_regs.c                                               |    4 
 arch/csky/kernel/probes/kprobes.c                                       |    4 
 arch/m68k/coldfire/device.c                                             |    6 
 arch/mips/cavium-octeon/octeon-platform.c                               |    3 
 arch/mips/mm/tlbex.c                                                    |    4 
 arch/nios2/include/asm/entry.h                                          |    3 
 arch/nios2/include/asm/ptrace.h                                         |    2 
 arch/nios2/kernel/entry.S                                               |   22 
 arch/nios2/kernel/signal.c                                              |    3 
 arch/nios2/kernel/syscall_table.c                                       |    1 
 arch/openrisc/include/asm/io.h                                          |    2 
 arch/openrisc/mm/ioremap.c                                              |    2 
 arch/powerpc/Makefile                                                   |   26 
 arch/powerpc/include/asm/nmi.h                                          |    2 
 arch/powerpc/kernel/head_book3s_32.S                                    |    4 
 arch/powerpc/kernel/pci-common.c                                        |   16 
 arch/powerpc/kernel/prom.c                                              |    7 
 arch/powerpc/kernel/watchdog.c                                          |   21 
 arch/powerpc/kvm/book3s_hv_p9_entry.c                                   |   13 
 arch/powerpc/mm/book3s32/mmu.c                                          |   10 
 arch/powerpc/platforms/Kconfig.cputype                                  |   21 
 arch/powerpc/platforms/powernv/pci-ioda.c                               |    2 
 arch/powerpc/platforms/pseries/mobility.c                               |   43 
 arch/riscv/boot/dts/canaan/k210.dtsi                                    |   12 
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi                              |   24 
 arch/riscv/kernel/sys_riscv.c                                           |    5 
 arch/riscv/kernel/traps.c                                               |    4 
 arch/um/os-Linux/skas/process.c                                         |   17 
 arch/x86/include/asm/ibt.h                                              |   11 
 arch/x86/kernel/kprobes/core.c                                          |    2 
 arch/x86/kvm/emulate.c                                                  |    3 
 arch/x86/mm/init_64.c                                                   |    2 
 block/blk-mq.c                                                          |    2 
 drivers/acpi/pci_mcfg.c                                                 |    3 
 drivers/acpi/pptt.c                                                     |  102 --
 drivers/acpi/property.c                                                 |    8 
 drivers/ata/libata-eh.c                                                 |    1 
 drivers/atm/idt77252.c                                                  |    1 
 drivers/block/virtio_blk.c                                              |   24 
 drivers/block/zram/zcomp.c                                              |   11 
 drivers/clk/imx/clk-imx93.c                                             |    2 
 drivers/clk/qcom/clk-alpha-pll.c                                        |    2 
 drivers/clk/qcom/gcc-ipq8074.c                                          |    1 
 drivers/clk/ti/clk-44xx.c                                               |  210 ++--
 drivers/clk/ti/clk-54xx.c                                               |  160 +--
 drivers/clk/ti/clkctrl.c                                                |    4 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                          |   11 
 drivers/dma/sprd-dma.c                                                  |    5 
 drivers/dma/tegra186-gpc-dma.c                                          |   26 
 drivers/gpu/drm/amd/amdgpu/aldebaran.c                                  |   45 
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                                  |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_reset.h                               |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c                                |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c                                   |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c                                   |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                       |    7 
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c                 |    2 
 drivers/gpu/drm/bridge/lvds-codec.c                                     |    2 
 drivers/gpu/drm/i915/gem/i915_gem_object.c                              |   16 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h                        |    3 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c                               |   25 
 drivers/gpu/drm/i915/gt/intel_gt.c                                      |   77 +
 drivers/gpu/drm/i915/gt/intel_gt.h                                      |   12 
 drivers/gpu/drm/i915/gt/intel_gt_pm.h                                   |    3 
 drivers/gpu/drm/i915/gt/intel_gt_types.h                                |   18 
 drivers/gpu/drm/i915/gt/intel_migrate.c                                 |   23 
 drivers/gpu/drm/i915/gt/intel_ppgtt.c                                   |    8 
 drivers/gpu/drm/i915/i915_drv.h                                         |    4 
 drivers/gpu/drm/i915/i915_vma.c                                         |   33 
 drivers/gpu/drm/i915/i915_vma.h                                         |    1 
 drivers/gpu/drm/i915/i915_vma_resource.c                                |    5 
 drivers/gpu/drm/i915/i915_vma_resource.h                                |    6 
 drivers/gpu/drm/imx/dcss/dcss-kms.c                                     |    2 
 drivers/gpu/drm/meson/meson_drv.c                                       |    5 
 drivers/gpu/drm/meson/meson_viu.c                                       |   22 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c                       |   22 
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                                  |   10 
 drivers/gpu/drm/ttm/ttm_bo.c                                            |    2 
 drivers/hid/hid-multitouch.c                                            |   13 
 drivers/hwtracing/coresight/coresight-etm4x.h                           |    3 
 drivers/i2c/busses/i2c-imx.c                                            |   20 
 drivers/i2c/busses/i2c-qcom-geni.c                                      |    5 
 drivers/infiniband/core/umem_dmabuf.c                                   |    8 
 drivers/infiniband/hw/cxgb4/cm.c                                        |   25 
 drivers/infiniband/hw/mlx5/main.c                                       |   34 
 drivers/infiniband/sw/rxe/rxe_loc.h                                     |    1 
 drivers/infiniband/sw/rxe/rxe_mr.c                                      |  199 +---
 drivers/infiniband/sw/rxe/rxe_mw.c                                      |    6 
 drivers/infiniband/sw/rxe/rxe_param.h                                   |    6 
 drivers/infiniband/sw/rxe/rxe_task.c                                    |   16 
 drivers/infiniband/sw/rxe/rxe_verbs.c                                   |   39 
 drivers/infiniband/sw/rxe/rxe_verbs.h                                   |   21 
 drivers/infiniband/ulp/iser/iser_initiator.c                            |    7 
 drivers/input/keyboard/mt6779-keypad.c                                  |    8 
 drivers/input/misc/iqs7222.c                                            |  178 ++-
 drivers/input/touchscreen/exc3000.c                                     |    7 
 drivers/iommu/io-pgtable-arm-v7s.c                                      |   75 +
 drivers/irqchip/irq-tegra.c                                             |   10 
 drivers/md/md.c                                                         |    1 
 drivers/md/raid5.c                                                      |    4 
 drivers/media/platform/qcom/venus/pm_helpers.c                          |   10 
 drivers/misc/cxl/irq.c                                                  |    1 
 drivers/misc/habanalabs/common/sysfs.c                                  |    2 
 drivers/misc/habanalabs/gaudi/gaudi.c                                   |   50 -
 drivers/misc/habanalabs/goya/goya_hwmgr.c                               |    2 
 drivers/misc/uacce/uacce.c                                              |  133 +-
 drivers/mmc/host/meson-gx-mmc.c                                         |    6 
 drivers/mmc/host/pxamci.c                                               |    4 
 drivers/mmc/host/renesas_sdhi.h                                         |    1 
 drivers/mmc/host/renesas_sdhi_core.c                                    |   34 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                           |    6 
 drivers/mmc/host/tmio_mmc.c                                             |    2 
 drivers/mmc/host/tmio_mmc.h                                             |    6 
 drivers/mmc/host/tmio_mmc_core.c                                        |   28 
 drivers/net/can/spi/mcp251x.c                                           |   18 
 drivers/net/can/usb/ems_usb.c                                           |    2 
 drivers/net/dsa/microchip/ksz9477.c                                     |    3 
 drivers/net/dsa/mv88e6060.c                                             |    3 
 drivers/net/dsa/ocelot/felix.c                                          |    3 
 drivers/net/dsa/ocelot/felix_vsc9959.c                                  |  491 +++++++---
 drivers/net/dsa/ocelot/seville_vsc9953.c                                |  484 +++++++--
 drivers/net/dsa/sja1105/sja1105_devlink.c                               |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                         |   21 
 drivers/net/ethernet/broadcom/bgmac.c                                   |    2 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                            |    3 
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h                             |    2 
 drivers/net/ethernet/engleder/tsnep_main.c                              |    8 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                        |    4 
 drivers/net/ethernet/freescale/fec_ptp.c                                |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c                             |    4 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                             |    8 
 drivers/net/ethernet/intel/iavf/iavf_adminq.c                           |   15 
 drivers/net/ethernet/intel/iavf/iavf_main.c                             |   22 
 drivers/net/ethernet/intel/ice/ice_fltr.c                               |    8 
 drivers/net/ethernet/intel/ice/ice_lib.c                                |    8 
 drivers/net/ethernet/intel/ice/ice_main.c                               |   12 
 drivers/net/ethernet/intel/ice/ice_switch.c                             |    9 
 drivers/net/ethernet/intel/ice/ice_vf_lib.c                             |   15 
 drivers/net/ethernet/intel/ice/ice_virtchnl.c                           |   57 +
 drivers/net/ethernet/intel/igb/igb.h                                    |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                               |   12 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c                         |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c                     |   15 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c                  |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c                |   19 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h                |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                     |    4 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                          |    2 
 drivers/net/ethernet/moxa/moxart_ether.c                                |   20 
 drivers/net/ethernet/mscc/ocelot.c                                      |   51 -
 drivers/net/ethernet/mscc/ocelot_net.c                                  |   55 -
 drivers/net/ethernet/mscc/ocelot_vsc7514.c                              |  468 +++++++--
 drivers/net/ethernet/mscc/vsc7514_regs.c                                |   26 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                    |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                       |    1 
 drivers/net/geneve.c                                                    |   15 
 drivers/net/phy/phy-c45.c                                               |   34 
 drivers/net/phy/phy_device.c                                            |    6 
 drivers/net/plip/plip.c                                                 |    2 
 drivers/net/tap.c                                                       |   20 
 drivers/net/virtio_net.c                                                |    9 
 drivers/net/vxlan/vxlan_core.c                                          |    2 
 drivers/ntb/test/ntb_tool.c                                             |    8 
 drivers/nvme/host/fc.c                                                  |    3 
 drivers/nvme/target/tcp.c                                               |    3 
 drivers/of/overlay.c                                                    |   11 
 drivers/pci/controller/pci-aardvark.c                                   |   33 
 drivers/pci/quirks.c                                                    |    3 
 drivers/phy/samsung/phy-exynos-pcie.c                                   |   25 
 drivers/pinctrl/intel/pinctrl-intel.c                                   |   14 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                               |    4 
 drivers/pinctrl/pinctrl-amd.c                                           |   11 
 drivers/pinctrl/qcom/pinctrl-msm8916.c                                  |    4 
 drivers/pinctrl/qcom/pinctrl-sm8250.c                                   |    2 
 drivers/pinctrl/renesas/pinctrl-rzg2l.c                                 |    2 
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c                             |    1 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                                   |    7 
 drivers/platform/chrome/cros_ec_proto.c                                 |    8 
 drivers/rtc/rtc-spear.c                                                 |    2 
 drivers/s390/crypto/ap_bus.c                                            |    3 
 drivers/s390/crypto/ap_bus.h                                            |    4 
 drivers/scsi/lpfc/lpfc_debugfs.c                                        |   20 
 drivers/scsi/lpfc/lpfc_sli.c                                            |    4 
 drivers/scsi/scsi_transport_iscsi.c                                     |    2 
 drivers/spi/spi-meson-spicc.c                                           |  129 ++
 drivers/staging/r8188eu/core/rtw_cmd.c                                  |   15 
 drivers/staging/r8188eu/core/rtw_efuse.c                                |   33 
 drivers/staging/r8188eu/core/rtw_fw.c                                   |   72 +
 drivers/staging/r8188eu/core/rtw_led.c                                  |   16 
 drivers/staging/r8188eu/core/rtw_mlme_ext.c                             |   62 +
 drivers/staging/r8188eu/core/rtw_pwrctrl.c                              |    9 
 drivers/staging/r8188eu/core/rtw_wlan_util.c                            |   20 
 drivers/staging/r8188eu/hal/Hal8188ERateAdaptive.c                      |   21 
 drivers/staging/r8188eu/hal/HalPhyRf_8188e.c                            |   21 
 drivers/staging/r8188eu/hal/HalPwrSeqCmd.c                              |    9 
 drivers/staging/r8188eu/hal/hal_com.c                                   |   27 
 drivers/staging/r8188eu/hal/rtl8188e_cmd.c                              |   37 
 drivers/staging/r8188eu/hal/rtl8188e_dm.c                               |    6 
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c                         |  136 ++
 drivers/staging/r8188eu/hal/rtl8188e_phycfg.c                           |   30 
 drivers/staging/r8188eu/hal/usb_halinit.c                               |  251 ++++-
 drivers/staging/r8188eu/hal/usb_ops_linux.c                             |   33 
 drivers/staging/r8188eu/include/rtw_io.h                                |    6 
 drivers/staging/r8188eu/os_dep/ioctl_linux.c                            |   47 
 drivers/staging/r8188eu/os_dep/os_intfs.c                               |   19 
 drivers/thunderbolt/tmu.c                                               |   13 
 drivers/tty/serial/ucc_uart.c                                           |    2 
 drivers/ufs/core/ufshcd.c                                               |   11 
 drivers/ufs/host/ufs-exynos.c                                           |   17 
 drivers/ufs/host/ufs-mediatek.c                                         |   60 +
 drivers/usb/cdns3/cdns3-gadget.c                                        |    2 
 drivers/usb/dwc2/gadget.c                                               |    3 
 drivers/usb/gadget/function/uvc_queue.c                                 |   17 
 drivers/usb/gadget/function/uvc_video.c                                 |    2 
 drivers/usb/gadget/legacy/inode.c                                       |    1 
 drivers/usb/host/ohci-ppc-of.c                                          |    1 
 drivers/usb/renesas_usbhs/rza.c                                         |    4 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                        |    4 
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c                                    |    6 
 drivers/vfio/vfio.c                                                     |    1 
 drivers/video/fbdev/i740fb.c                                            |    9 
 drivers/virt/vboxguest/vboxguest_linux.c                                |    9 
 drivers/virtio/Kconfig                                                  |    3 
 drivers/xen/xenbus/xenbus_dev_frontend.c                                |    4 
 fs/btrfs/block-group.c                                                  |    4 
 fs/btrfs/relocation.c                                                   |    7 
 fs/btrfs/tree-log.c                                                     |    8 
 fs/ceph/caps.c                                                          |   27 
 fs/ceph/mds_client.c                                                    |    7 
 fs/ceph/mds_client.h                                                    |    6 
 fs/cifs/misc.c                                                          |    6 
 fs/cifs/smb2ops.c                                                       |    5 
 fs/ext4/mballoc.c                                                       |   21 
 fs/ext4/namei.c                                                         |    7 
 fs/ext4/resize.c                                                        |   10 
 fs/f2fs/f2fs.h                                                          |    6 
 fs/f2fs/file.c                                                          |   32 
 fs/f2fs/node.c                                                          |    6 
 fs/f2fs/segment.c                                                       |   17 
 fs/fscache/cookie.c                                                     |    7 
 fs/nfs/nfs4idmap.c                                                      |   46 
 fs/nfs/nfs4proc.c                                                       |   20 
 fs/ntfs3/fslog.c                                                        |    2 
 fs/ntfs3/fsntfs.c                                                       |    7 
 fs/ntfs3/index.c                                                        |    2 
 fs/ntfs3/inode.c                                                        |    1 
 fs/ntfs3/super.c                                                        |    8 
 fs/ntfs3/xattr.c                                                        |   22 
 fs/overlayfs/super.c                                                    |    7 
 include/asm-generic/bitops/atomic.h                                     |    6 
 include/linux/bpfptr.h                                                  |    8 
 include/linux/io-pgtable.h                                              |   15 
 include/linux/nmi.h                                                     |    2 
 include/linux/sunrpc/xdr.h                                              |    4 
 include/linux/sunrpc/xprt.h                                             |    3 
 include/linux/uacce.h                                                   |    6 
 include/linux/usb/typec_mux.h                                           |   44 
 include/net/mptcp.h                                                     |    4 
 include/net/netns/conntrack.h                                           |    2 
 include/soc/mscc/ocelot.h                                               |  113 ++
 include/sound/control.h                                                 |    2 
 include/sound/core.h                                                    |    8 
 include/sound/pcm.h                                                     |    2 
 include/uapi/linux/atm_zatm.h                                           |   47 
 include/uapi/linux/f2fs.h                                               |    2 
 include/ufs/ufshcd.h                                                    |   12 
 kernel/bpf/arraymap.c                                                   |    6 
 kernel/bpf/hashtab.c                                                    |    8 
 kernel/bpf/syscall.c                                                    |   20 
 kernel/trace/trace_eprobe.c                                             |   91 +
 kernel/trace/trace_event_perf.c                                         |    7 
 kernel/trace/trace_events.c                                             |    1 
 kernel/trace/trace_probe.c                                              |   29 
 kernel/watchdog.c                                                       |   21 
 lib/list_debug.c                                                        |   12 
 net/can/j1939/socket.c                                                  |    5 
 net/can/j1939/transport.c                                               |    8 
 net/core/bpf_sk_storage.c                                               |   12 
 net/core/devlink.c                                                      |    4 
 net/core/gen_stats.c                                                    |    2 
 net/core/rtnetlink.c                                                    |    1 
 net/core/sock_map.c                                                     |   20 
 net/dsa/port.c                                                          |    7 
 net/ipv6/ip6_output.c                                                   |    3 
 net/ipv6/ndisc.c                                                        |    3 
 net/mptcp/protocol.c                                                    |   47 
 net/mptcp/protocol.h                                                    |   13 
 net/mptcp/subflow.c                                                     |    3 
 net/netfilter/nf_conntrack_ftp.c                                        |   24 
 net/netfilter/nf_conntrack_h323_main.c                                  |   10 
 net/netfilter/nf_conntrack_irc.c                                        |   12 
 net/netfilter/nf_conntrack_sane.c                                       |   68 -
 net/netfilter/nf_tables_api.c                                           |   74 +
 net/netfilter/nf_tables_core.c                                          |   21 
 net/netfilter/nfnetlink.c                                               |   83 +
 net/netlink/genetlink.c                                                 |    6 
 net/netlink/policy.c                                                    |   14 
 net/qrtr/mhi.c                                                          |   12 
 net/rds/ib_recv.c                                                       |    1 
 net/sunrpc/auth.c                                                       |    2 
 net/sunrpc/backchannel_rqst.c                                           |   14 
 net/sunrpc/clnt.c                                                       |    1 
 net/sunrpc/sysfs.c                                                      |    6 
 net/sunrpc/xprt.c                                                       |   27 
 net/sunrpc/xprtsock.c                                                   |   12 
 net/vmw_vsock/af_vsock.c                                                |   10 
 scripts/Makefile.gcc-plugins                                            |    2 
 scripts/dummy-tools/gcc                                                 |    8 
 scripts/mod/modpost.c                                                   |    4 
 scripts/module.lds.S                                                    |    2 
 security/apparmor/apparmorfs.c                                          |    2 
 security/apparmor/audit.c                                               |    2 
 security/apparmor/domain.c                                              |    2 
 security/apparmor/include/lib.h                                         |    5 
 security/apparmor/include/policy.h                                      |    2 
 security/apparmor/label.c                                               |   13 
 security/apparmor/mount.c                                               |    8 
 security/apparmor/policy_unpack.c                                       |   12 
 sound/core/control.c                                                    |    7 
 sound/core/info.c                                                       |    6 
 sound/core/misc.c                                                       |   94 +
 sound/core/pcm.c                                                        |    1 
 sound/core/pcm_lib.c                                                    |    2 
 sound/core/pcm_native.c                                                 |    2 
 sound/core/timer.c                                                      |   11 
 sound/pci/hda/hda_codec.c                                               |   14 
 sound/pci/hda/patch_realtek.c                                           |    3 
 sound/soc/codecs/lpass-va-macro.c                                       |   11 
 sound/soc/codecs/nau8821.c                                              |   10 
 sound/soc/codecs/tas2770.c                                              |   98 -
 sound/soc/codecs/tas2770.h                                              |    5 
 sound/soc/codecs/tlv320aic32x4.c                                        |    9 
 sound/soc/intel/avs/core.c                                              |    1 
 sound/soc/intel/avs/pcm.c                                               |    4 
 sound/soc/intel/boards/sof_es8336.c                                     |   35 
 sound/soc/intel/boards/sof_nau8825.c                                    |   10 
 sound/soc/qcom/qdsp6/q6apm-dai.c                                        |    6 
 sound/soc/sh/rcar/ssiu.c                                                |    2 
 sound/soc/soc-pcm.c                                                     |    3 
 sound/soc/sof/debug.c                                                   |    6 
 sound/soc/sof/intel/cnl.c                                               |   37 
 sound/soc/sof/intel/hda-ipc.c                                           |   39 
 sound/soc/sof/intel/hda.c                                               |    9 
 sound/soc/sof/sof-client-probes.c                                       |    4 
 sound/usb/card.c                                                        |    8 
 sound/usb/mixer_maps.c                                                  |   34 
 tools/build/feature/test-libcrypto.c                                    |   15 
 tools/lib/bpf/skel_internal.h                                           |    4 
 tools/objtool/check.c                                                   |    3 
 tools/perf/tests/switch-tracking.c                                      |   18 
 tools/perf/util/parse-events.c                                          |   14 
 tools/perf/util/probe-event.c                                           |    6 
 tools/testing/cxl/test/cxl.c                                            |    1 
 tools/testing/cxl/test/mock.c                                           |    8 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc    |    1 
 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh         |   24 
 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh     |   24 
 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh  |   24 
 tools/testing/selftests/net/mptcp/mptcp_connect.c                       |   26 
 tools/tracing/rtla/Makefile                                             |    4 
 tools/vm/slabinfo.c                                                     |   32 
 virt/kvm/kvm_main.c                                                     |   14 
 388 files changed, 5446 insertions(+), 2430 deletions(-)

Aaron Lu (1):
      x86/mm: Use proper mask when setting PUD mapping

Adrian Hunter (2):
      perf parse-events: Fix segfault when event parser gets an error
      perf tests: Fix Track with sched_switch test for hybrid case

Akhil R (1):
      dmaengine: tegra: Add terminate() for Tegra234

Al Viro (6):
      nios2: page fault et.al. are *not* restartable syscalls...
      nios2: don't leave NULLs in sys_call_table[]
      nios2: traced syscall does need to check the syscall number
      nios2: fix syscall restart checks
      nios2: restarts apply only to the first sigframe we build...
      nios2: add force_successful_syscall_return()

Alan Brady (1):
      i40e: Fix to stop tx_timeout recovery if GLOBR fails

Alex Deucher (1):
      drm/amdgpu: Only disable prefer_shadow on hawaii

Alexei Starovoitov (1):
      bpf: Disallow bpf programs call prog_run command.

Alexey Kardashevskiy (1):
      powerpc/ioda/iommu/debugfs: Generate unique debugfs entries

Allen-KH Cheng (1):
      dt-bindings: pinctrl: mt8186: Add and use drive-strength-microamp

Amadeusz Sławiński (2):
      ALSA: info: Fix llseek return value when using callback
      ASoC: Intel: avs: Set max DMA segment size

Amelie Delaunay (1):
      usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch

Amit Cohen (1):
      mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice

Andrew Donnellan (1):
      gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Andrey Turkin (2):
      ASoC: Intel: sof_es8336: Fix GPIO quirks set via module option
      ASoC: Intel: sof_es8336: ignore GpioInt when looking for speaker/headset GPIO lines

Andy Shevchenko (1):
      pinctrl: intel: Check against matching data instead of ACPI companion

AngeloGioacchino Del Regno (2):
      dt-bindings: pinctrl: mt8195: Fix name for mediatek,rsel-resistance-in-si-unit
      dt-bindings: pinctrl: mt8195: Add and use drive-strength-microamp

Arun Ramadoss (1):
      net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Arunpravin Paneer Selvam (1):
      drm/ttm: Fix dummy res NULL ptr deref bug

Aurabindo Pillai (1):
      drm/amd/display: Check correct bounds for stream encoder instances for DCN303

Basavaraj Natikar (1):
      pinctrl: amd: Don't save/restore interrupt status and wake status bits

Ben Dooks (2):
      dmaengine: dw-axi-dmac: do not print NULL LLI during error
      dmaengine: dw-axi-dmac: ignore interrupt if no descriptor

Ben Hutchings (1):
      tools/rtla: Fix command symlinks

Benjamin Mikailenko (2):
      ice: Fix VSI rebuild WARN_ON check for VF
      ice: Ignore error message when setting same promiscuous mode

Bob Pearson (1):
      RDMA/rxe: Limit the number of calls to each tasklet

Bryan O'Donoghue (1):
      dt-bindings: opp: opp-v2-kryo-cpu: Fix example binding checks

Celeste Liu (1):
      riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Cezar Bulinaru (1):
      net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null

Cezary Rojewski (1):
      ALSA: hda: Fix page fault in snd_hda_codec_shutdown()

Chanho Park (1):
      scsi: ufs: ufs-exynos: Change ufs phy control sequence

Chao Yu (2):
      f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()
      f2fs: fix to do sanity check on segment type in build_sit_entries()

Chen Lin (1):
      dpaa2-eth: trace the allocated address instead of page struct

Chia-Lin Kao (AceLan) (1):
      net: atlantic: fix aq_vec index out of range error

Chris Wilson (5):
      drm/i915/gem: Remove shared locking on freeing objects
      drm/i915/gt: Ignore TLB invalidations on idle engines
      drm/i915/gt: Invalidate TLB of the OA unit at TLB invalidations
      drm/i915/gt: Skip TLB invalidations once wedged
      drm/i915/gt: Batch TLB invalidations

Christoffer Sandberg (1):
      ALSA: hda/realtek: Add quirk for Clevo NS50PU, NS70PU

Christoph Hellwig (1):
      nvme-fc: fix the fc_appid_store return value

Christophe JAILLET (6):
      mmc: pxamci: Fix another error handling path in pxamci_probe()
      mmc: pxamci: Fix an error handling path in pxamci_probe()
      mmc: meson-gx: Fix an error handling path in meson_mmc_probe()
      perf probe: Fix an error handling path in 'parse_perf_probe_command()'
      stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
      cxl: Fix a memory leak in an error handling path

Christophe Leroy (2):
      powerpc/32: Set an IBAT covering up to _einittext during init
      powerpc/32: Don't always pass -mcpu=powerpc to the compiler

Chuck Lever (1):
      SUNRPC: Fix xdr_encode_bool()

Conor Dooley (2):
      riscv: dts: sifive: Add fu740 topology information
      riscv: dts: canaan: Add k210 topology information

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Daeho Jeong (1):
      f2fs: revive F2FS_IOC_ABORT_VOLATILE_WRITE

Dafna Hirschfeld (1):
      habanalabs: add terminating NULL to attrs arrays

Damien Le Moal (1):
      ata: libata-eh: Add missing command name

Dan Aloni (1):
      sunrpc: fix expiry of auth creds

Dan Carpenter (4):
      NTB: ntb_tool: uninitialized heap data in tool_fn_write()
      xen/xenbus: fix return type in xenbus_file_read()
      fs/ntfs3: Don't clear upper bits accidentally in log_replay()
      fs/ntfs3: uninitialized variable in ntfs_set_acl_ex()

Dan Williams (2):
      tools/testing/cxl: Fix decoder default state
      tools/testing/cxl: Fix cxl_hdm_decode_init() calling convention

Dmitry Baryshkov (1):
      dt-bindings: clock: qcom,gcc-msm8996: add more GCC clock sources

Duoming Zhou (1):
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings

Fedor Pchelkin (2):
      can: j1939: j1939_session_destroy(): fix memory leak of skbs
      can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()

Filipe Manana (2):
      btrfs: fix lost error handling when looking up extended ref on log replay
      btrfs: fix warning during log replay when bumping inode link count

Florian Fainelli (2):
      net: phy: Warn about incorrect mdio_bus_phy_resume() state
      net: bcmgenet: Indicate MAC is in charge of PHY PM

Florian Westphal (9):
      netfilter: nf_tables: fix crash when nf_trace is enabled
      selftests: mptcp: make sendfile selftest work
      plip: avoid rcu debug splat
      netfilter: nfnetlink: re-enable conntrack expectation events
      netfilter: nf_ct_sane: remove pseudo skb linearization
      netfilter: nf_ct_h323: cap packet size at 64k
      netfilter: nf_ct_ftp: prefer skb_linearize
      netfilter: nf_ct_irc: cap packet search space to 4k
      netfilter: nf_tables: fix scheduling-while-atomic splat

Frank Li (1):
      usb: cdns3 fix use-after-free at workaround 2

Frieder Schrempf (1):
      regulator: pca9450: Remove restrictions for regulator-name

Geert Uytterhoeven (1):
      of: overlay: Move devicetree_corrupt() check up

Gerhard Engleder (1):
      tsnep: Fix tsnep_tx_unmap() error path usage

Gil Fine (1):
      thunderbolt: Change downstream router's TMU rate in both TMU uni/bidir mode

Greg Kroah-Hartman (1):
      Linux 5.19.4

Grzegorz Siwik (3):
      ice: Fix double VLAN error when entering promisc mode
      ice: Ignore EEXIST when setting promisc mode
      ice: Fix clearing of promisc mode with bridge over bond

Guenter Roeck (1):
      lib/list_debug.c: Detect uninitialized lists

Harald Freudenberger (1):
      s390/ap: fix crash on older machines based on QCI info missing

Harman Kalra (1):
      octeontx2-af: suppress external profile loading warning

Hector Martin (1):
      locking/atomic: Make test_and_*_bit() ordered on failure

Helge Deller (1):
      modules: Ensure natural alignment for .altinstructions and __bug_table sections

Hou Tao (5):
      bpf: Acquire map uref in .init_seq_private for array map iterator
      bpf: Acquire map uref in .init_seq_private for hash map iterator
      bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
      bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator
      bpf: Check the validity of max_rdwr_access for sock local storage map iterator

Huacai Chen (1):
      PCI/ACPI: Guard ARM64-specific mcfg_quirks

Ido Schimmel (2):
      devlink: Fix use-after-free after a failed reload
      selftests: forwarding: Fix failing tests with old libnet

Ivan Vecera (1):
      iavf: Fix deadlock in initialization

Jacky Bai (1):
      clk: imx93: Correct the edma1's parent clock

Jakub Kicinski (2):
      net: atm: bring back zatm uAPI
      net: genl: fix error path memory leak in policy dumping

James Smart (2):
      scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
      scsi: lpfc: Fix possible memory leak when failing to issue CMF WQE

Jason A. Donenfeld (1):
      um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups

Jason Gunthorpe (1):
      RDMA: Handle the return code from dma_resv_wait_timeout() properly

Jean-Philippe Brucker (1):
      uacce: Handle parent device removal or parent driver module rmmod

Jeff LaBundy (9):
      Input: iqs7222 - correct slider event disable logic
      Input: iqs7222 - fortify slider event reporting
      Input: iqs7222 - protect volatile registers
      Input: iqs7222 - acknowledge reset before writing registers
      Input: iqs7222 - handle reset during ATI
      Input: iqs7222 - remove support for RF filter
      dt-bindings: input: iqs7222: Remove support for RF filter
      dt-bindings: input: iqs7222: Correct bottom speed step size
      dt-bindings: input: iqs7222: Extend slider-mapped GPIO to IQS7222C

Jeff Layton (2):
      ceph: don't leak snap_rwsem in handle_cap_grant
      fscache: don't leak cookie access refs if invalidation is in progress or failed

Jianhua Lu (1):
      pinctrl: qcom: sm8250: Fix PDC map

Jinghao Jia (1):
      BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

Jiri Olsa (1):
      mptcp, btf: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled

Johan Hovold (1):
      dt-bindings: PCI: qcom: Fix reset conditional

John Johansen (5):
      apparmor: fix quiet_denied for file rules
      apparmor: fix absroot causing audited secids to begin with =
      apparmor: Fix failed mount permission check error message
      apparmor: fix setting unconfined mode on a loaded profile
      apparmor: fix overlapping attachment computation

Josef Bacik (1):
      btrfs: reset RO counter on block group if we fail to relocate

Josh Poimboeuf (2):
      x86/ibt, objtool: Add IBT_NOSEAL()
      x86/kvm: Fix "missing ENDBR" BUG for fastop functions

Jozef Martiniak (1):
      gadgetfs: ep_io - wait until IRQ finishes

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable speaker and mute LEDs for HP laptops

Karol Herbst (1):
      drm/nouveau: recognise GA103

Kiselev, Oleg (1):
      ext4: avoid resizing to a partial cluster size

Konstantin Komarov (3):
      fs/ntfs3: Fix double free on remount
      fs/ntfs3: Do not change mode if ntfs_set_ea failed
      fs/ntfs3: Fix missing i_op in ntfs_read_mft

Krzysztof Kozlowski (7):
      dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles
      dt-bindings: arm: qcom: fix Longcheer L8150 compatibles
      dt-bindings: arm: qcom: fix MSM8916 MTP compatibles
      dt-bindings: arm: qcom: fix MSM8994 boards compatibles
      spi: dt-bindings: cadence: add missing 'required'
      spi: dt-bindings: zynqmp-qspi: add missing 'required'
      spi: dt-bindings: qcom,spi-geni-qcom: allow three interconnects

Kumar Kartikeya Dwivedi (1):
      bpf: Don't reinit map value in prealloc_lru_pop

Kuninori Morimoto (1):
      ASoC: rsnd: care default case on rsnd_ssiu_busif_err_irq_ctrl()

Lad Prabhakar (1):
      pinctrl: renesas: rzg2l: Return -EINVAL for pins which have input disabled

Laurent Dufour (3):
      watchdog: export lockup_detector_reconfigure
      powerpc/watchdog: introduce a NMI watchdog's factor
      powerpc/pseries/mobility: set NMI watchdog factor during an LPM

Laurentiu Palcu (1):
      drm/imx/dcss: get rid of HPD warning message

Li Zhijian (1):
      Revert "RDMA/rxe: Create duplicate mapping tables for FMRs"

Liang He (5):
      drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
      usb: host: ohci-ppc-of: Fix refcount leak bug
      usb: renesas: Fix refcount leak bug
      tty: serial: Fix refcount leak bug in ucc_uart.c
      mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Liao Chang (1):
      csky/kprobe: reclaim insn_slot on kprobe unregistration

Lijo Lazar (1):
      drm/amdgpu: Avoid another list of reset devices

Likun Gao (1):
      drm/amdgpu: change vram width algorithm for vram_info v3_0

Lin Ma (1):
      igb: Add lock to avoid data race

Logan Gunthorpe (2):
      md: Notify sysfs sync_completed in md_reap_sync_thread()
      md/raid5: Make logic blocking check consistent with logic that blocks

Lukas Czerner (1):
      ext4: block range must be validated before use in ext4_mb_clear_bb()

Luís Henriques (1):
      ceph: use correct index when encoding client supported features

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Marek Szyprowski (1):
      phy: samsung: phy-exynos-pcie: sanitize init/power_on callbacks

Marek Vasut (1):
      drm/bridge: lvds-codec: Fix error checking of drm_of_lvds_get_data_mapping()

Mark Bloch (1):
      RDMA/mlx5: Use the proper number of ports

Mark Brown (1):
      ASoC: nau8821: Don't unconditionally free interrupt

Martin Povišer (4):
      ASoC: tas2770: Set correct FSYNC polarity
      ASoC: tas2770: Allow mono streams
      ASoC: tas2770: Drop conflicting set_bias_level power setting
      ASoC: tas2770: Fix handling of mute/unmute

Masahiro Yamada (2):
      modpost: fix module versioning when a symbol lacks valid CRC
      kbuild: fix the modules order between drivers and libs

Matthew Auld (1):
      drm/i915/ttm: don't leak the ccs state

Matthias May (5):
      geneve: do not use RT_TOS for IPv6 flowlabel
      vxlan: do not use RT_TOS for IPv6 flowlabel
      mlx5: do not use RT_TOS for IPv6 flowlabel
      ipv6: do not use RT_TOS for IPv6 flowlabel
      geneve: fix TOS inheriting for ipv4

Mattijs Korpershoek (1):
      Input: mt6779-keypad - match hardware matrix organization

Mauro Carvalho Chehab (1):
      drm/i915: pass a pointer for tlb seqno at vma_invalidate_tlb()

Maxim Kochetkov (1):
      net: qrtr: start MHI channel after endpoit creation

Maíra Canal (1):
      drm/amdgpu: Fix use-after-free on amdgpu_bo_list mutex

Miaoqian Lin (2):
      pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map
      Input: exc3000 - fix return value check of wait_for_completion_timeout

Michael Ellerman (1):
      powerpc/pci: Fix get_phb_number() locking

Michael Grzeschik (2):
      usb: gadget: uvc: calculate the number of request depending on framesize
      usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info

Michael S. Tsirkin (2):
      virtio: VIRTIO_HARDEN_NOTIFICATION is broken
      virtio_net: fix endian-ness for RSS

Michal Jaron (1):
      ice: Fix call trace with null VSI during VF reset

Michal Simek (1):
      dt-bindings: gpio: zynq: Add missing compatible strings

Mike Christie (1):
      scsi: iscsi: Fix HW conn removal use after free

Miklos Szeredi (1):
      ovl: warn if trusted xattr creation fails

Mikulas Patocka (1):
      rds: add missing barrier to release_refill

Mohan Kumar (1):
      ALSA: hda: Fix crash due to jack poll in suspend

Nadav Amit (1):
      x86/kprobes: Fix JNG/JNLE emulation

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Naveen Mamindlapalli (1):
      octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration

Neil Armstrong (1):
      spi: meson-spicc: add local pow2 clock ops to preserve rate between messages

Nick Desaulniers (1):
      coresight: etm4x: avoid build failure with unrolled loops

Nikita Travkin (1):
      pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Nícolas F. R. A. Prado (3):
      dt-bindings: usb: mtk-xhci: Allow wakeup interrupt-names to be optional
      dt-bindings: pinctrl: mt8192: Add drive-strength-microamp
      dt-bindings: pinctrl: mt8192: Use generic bias instead of pull-*-adv

Oded Gabbay (1):
      habanalabs/gaudi: mask constant value before cast

Ofir Bitton (1):
      habanalabs/gaudi: fix shift out of bounds

Oleksij Rempel (1):
      net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified

Oliver Upton (2):
      KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Ondrej Mosnacek (1):
      kbuild: dummy-tools: avoid tmpdir leak in dummy gcc

Pablo Neira Ayuso (8):
      netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
      netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
      netfilter: nf_tables: possible module reference underflow in error path
      netfilter: nf_tables: really skip inactive sets when allocating name
      netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
      netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
      netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified

Pali Rohár (1):
      PCI: aardvark: Fix reporting Slot capabilities on emulated bridge

Paolo Abeni (2):
      mptcp: move subflow cleanup in mptcp_destroy_common()
      mptcp: do not queue data on closed subflows

Pascal Terjan (1):
      vboxguest: Do not use devm for irq

Pavan Chebbi (1):
      PCI: Add ACS quirk for Broadcom BCM5750x NICs

Pavel Skripkin (4):
      fs/ntfs3: Fix NULL deref in ntfs_update_mftmirr
      staging: r8188eu: add error handling of rtw_read8
      staging: r8188eu: add error handling of rtw_read16
      staging: r8188eu: add error handling of rtw_read32

Peilin Ye (2):
      vsock: Fix memory leak in vsock_connect()
      vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Peter Ujfalusi (3):
      ASoC: SOF: Intel: cnl: Do not process IPC reply before firmware boot
      ASoC: SOF: Intel: hda-ipc: Do not process IPC reply before firmware boot
      ASoC: SOF: sof-client-probes: Only load the driver if IPC3 is used

Philipp Zabel (1):
      ASoC: codec: tlv320aic32x4: fix mono playback via I2S

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: hda: add sanity check on SSP index reported by NHLT

Po-Wen Kao (1):
      scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators

Potnuri Bharat Teja (1):
      RDMA/cxgb4: fix accept failure due to increased cpl_t5_pass_accept_rpl size

Prashant Malani (1):
      usb: typec: mux: Add CONFIG guards for functions

Przemyslaw Patynowski (4):
      iavf: Fix adminq error handling
      iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
      iavf: Fix reset error handling
      i40e: Fix tunnel checksum offload with fragmented traffic

Qifu Zhang (1):
      Documentation: ACPI: EINJ: Fix obsolete example

Randy Dunlap (1):
      m68k: coldfire/device.c: protect FLEXCAN blocks

Ren Zhijie (1):
      scsi: ufs: ufs-mediatek: Fix build error and type mismatch

Robert Marko (1):
      clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Roberto Sassu (1):
      tools build: Switch to new openssl API for test-libcrypto

Robin Reckmann (1):
      i2c: qcom-geni: Fix GPI DMA buffer sync-back

Rustam Subkhankulov (1):
      net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()

Sagi Grimberg (1):
      nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown

Sai Prakash Ranjan (2):
      irqchip/tegra: Fix overflow implicit truncation warnings
      drm/meson: Fix overflow implicit truncation warnings

Sakari Ailus (1):
      ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Samuel Holland (3):
      pinctrl: sunxi: Add I/O bias setting for H6 R-PIO
      dt-bindings: display: sun4i: Add D1 TCONs to conditionals
      drm/sun4i: dsi: Prevent underflow when computing packet sizes

Sandor Bodo-Merle (1):
      net: bgmac: Fix a BUG triggered by wrong bytes_compl

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Sean Christopherson (1):
      KVM: Unconditionally get a ref to /dev/kvm module when creating a VM

Sebastian Würl (1):
      can: mcp251x: Fix race condition on receive interrupt

Sergei Antonov (2):
      net: dsa: mv88e6060: prevent crash on an unused port
      net: moxa: pass pdev instead of ndev to DMA functions

Sergey Gorenko (1):
      IB/iser: Fix login with authentication

Sergey Senozhatsky (1):
      zram: do not lookup algorithm in backends table

Shigeru Yoshida (1):
      virtio-blk: Avoid use-after-free on suspend/resume

Srinivas Kandagatla (2):
      ASoC: qdsp6: q6apm-dai: unprepare stream if its already prepared
      ASoC: codecs: va-macro: use fsgen as clock

Stafford Horne (1):
      openrisc: io: Define iounmap argument as volatile

Stanimir Varbanov (1):
      venus: pm_helpers: Fix warning in OPP during probe

Stanislaw Kardach (1):
      octeontx2-af: Apply tx nibble fixup always

Stefano Garzarella (2):
      vdpa_sim: use max_iotlb_entries as a limit in vhost_iotlb_init
      vdpa_sim_blk: set number of address spaces and virtqueue groups

Steve French (1):
      smb3: check xattr value length earlier

Steven Rostedt (Google) (8):
      tracing/perf: Fix double put of trace event when init fails
      tracing/eprobes: Do not allow eprobes to use $stack, or % for regs
      tracing/eprobes: Do not hardcode $comm as a string
      tracing/eprobes: Fix reading of string fields
      tracing/eprobes: Have event probes be consistent with kprobes and uprobes
      tracing/probes: Have kprobes and uprobes use $COMM too
      tracing: Have filter accept "common_cpu" to be consistent
      selftests/kprobe: Do not test for GRP/ without event failures

Subbaraya Sundeep (2):
      octeontx2-af: Fix mcam entry resource leak
      octeontx2-af: Fix key checking for source mac

Sudeep Holla (1):
      ACPI: PPTT: Leave the table mapped for the runtime usage

Sylwester Dziedziuch (1):
      ice: Fix VF not able to send tagged traffic with no VLAN filters

Takashi Iwai (10):
      ALSA: usb-audio: More comprehensive mixer map for ASUS ROG Zenith II
      ASoC: Intel: avs: Fix potential buffer overflow by snprintf()
      ASoC: SOF: debug: Fix potential buffer overflow by snprintf()
      ASoC: SOF: Intel: hda: Fix potential buffer overflow by snprintf()
      ASoC: DPCM: Don't pick up BE without substream
      ALSA: core: Add async signal helpers
      ALSA: timer: Use deferred fasync helper
      ALSA: pcm: Use deferred fasync helper
      ALSA: control: Use deferred fasync helper
      Revert "ALSA: hda: Fix page fault in snd_hda_codec_shutdown()"

Takeshi Saito (1):
      mmc: renesas_sdhi: newer SoCs don't need manual tap correction

Tal Cohen (1):
      habanalabs/gaudi: invoke device reset from one code block

Tao Jin (1):
      HID: multitouch: new device class fix Lenovo X12 trackpad sticky

Tom Rix (1):
      apparmor: fix aa_label_asxprint return check

Tony Lindgren (1):
      clk: ti: Stop using legacy clkctrl names for omap4 and 5

Trond Myklebust (6):
      NFSv4.1: Don't decrease the value of seq_nr_highest_sent
      NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
      NFSv4: Fix races in the legacy idmapper upcall
      NFSv4/pnfs: Fix a use-after-free bug in open
      SUNRPC: Reinitialise the backchannel request buffers before reuse
      SUNRPC: Don't reuse bvec on retransmission of the request

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_proto: don't show MKBP version if unsupported

Uwe Kleine-König (2):
      i2c: imx: Make sure to unregister adapter on remove()
      dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Vladimir Oltean (9):
      net: dsa: felix: suppress non-changes to the tagging protocol
      net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
      net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
      net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
      net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it
      net: mscc: ocelot: turn stats_lock into a spinlock
      net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work
      net: mscc: ocelot: make struct ocelot_stat_layout array indexable
      net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats

Vladimir Zapolskiy (1):
      clk: qcom: clk-alpha-pll: fix clk_trion_pll_configure description

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

Wolfram Sang (1):
      mmc: tmio: avoid glitches when resetting

Xianting Tian (1):
      RISC-V: Add fast call path of crash_kexec()

Xin Xiong (3):
      apparmor: fix reference count leak in aa_pivotroot()
      net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
      net: fix potential refcount leak in ndisc_router_discovery()

Xiu Jianfeng (1):
      apparmor: Fix memleak in aa_simple_write_to_buffer()

Xuan Zhuo (1):
      virtio_net: fix memory leak inside XPD_TX with mergeable

Yan Lei (1):
      fs/ntfs3: Fix using uninitialized value n when calling indx_read

Ye Bin (2):
      ext4: avoid remove directory when directory is corrupted
      f2fs: fix null-ptr-deref in f2fs_get_dnode_of_data

Yong Zhi (1):
      ASoC: Intel: sof_nau8825: Move quirk check to the front in late probe

Yoshihiro Shimoda (2):
      scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS
      scsi: ufs: core: Add UFSHCD_QUIRK_HIBERN_FASTAUTO

Yu Xiao (1):
      nfp: ethtool: fix the display error of `ethtool -m DEVNAME`

Yuanzheng Song (1):
      tools/vm/slabinfo: use alphabetic order when two values are equal

Yufen Yu (1):
      blk-mq: run queue no matter whether the request is the last request

Yunfei Wang (1):
      iommu/io-pgtable-arm-v7s: Add a quirk to allow pgtable PA up to 35bit

Zeng Jingxiang (1):
      rtc: spear: set range max

Zhang Xianwei (1):
      NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Zhang Xiaoxu (1):
      cifs: Fix memory leak on the deferred close

Zhengchao Shao (2):
      net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
      net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu

Zheyu Ma (1):
      video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhouyi Zhou (1):
      powerpc/64: Init jump labels before parse_early_param()

Zixuan Fu (1):
      btrfs: unset reloc control if transaction commit fails in prepare_to_relocate()

