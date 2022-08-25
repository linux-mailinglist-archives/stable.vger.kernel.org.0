Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D75A0D18
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiHYJuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiHYJsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:48:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B783AB4DC;
        Thu, 25 Aug 2022 02:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D20BB827E9;
        Thu, 25 Aug 2022 09:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0A2C43149;
        Thu, 25 Aug 2022 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420863;
        bh=PlfNXgoL/xGnq4LZYoaKzgh4UNJCfhRCUgUa+tJvDmY=;
        h=From:To:Cc:Subject:Date:From;
        b=jC4Si6PuODXHqk9/qpUKuiTHWJeCMWwhXs4UT7y6dOoLIhUrbK/CA0iZmn5HXZS3K
         xU/wY+zvR6brHzNCoRrbPm5QIv+CnTeTU77pJNbdQdA9TAcGWmLv9fIO2KSyQie3hx
         hXzwnEFkfuK4oo+wUtabqpfnXreFg+CkykTKIuuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.211
Date:   Thu, 25 Aug 2022 11:47:24 +0200
Message-Id: <16614208441274@kroah.com>
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

I'm announcing the release of the 5.4.211 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/pm/cpuidle.rst                             |   15 -
 Documentation/atomic_bitops.txt                                      |    2 
 Documentation/devicetree/bindings/arm/qcom.yaml                      |    2 
 Documentation/firmware-guide/acpi/apei/einj.rst                      |    2 
 Makefile                                                             |    5 
 arch/arm/boot/dts/aspeed-ast2500-evb.dts                             |    2 
 arch/arm/boot/dts/aspeed-ast2600-evb.dts                             |    2 
 arch/arm/boot/dts/imx6ul.dtsi                                        |   31 +--
 arch/arm/boot/dts/qcom-mdm9615.dtsi                                  |    1 
 arch/arm/boot/dts/qcom-pm8841.dtsi                                   |    1 
 arch/arm/boot/dts/uniphier-pxs2.dtsi                                 |    8 
 arch/arm/lib/findbit.S                                               |   16 -
 arch/arm/mach-bcm/bcm_kona_smc.c                                     |    1 
 arch/arm/mach-omap2/display.c                                        |    3 
 arch/arm/mach-omap2/prm3xxx.c                                        |    1 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c                   |    5 
 arch/arm/mach-zynq/common.c                                          |    1 
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts            |    2 
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts             |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                                |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi                     |    8 
 arch/arm64/crypto/Kconfig                                            |    1 
 arch/arm64/include/asm/processor.h                                   |    3 
 arch/arm64/kernel/armv8_deprecated.c                                 |    9 
 arch/ia64/include/asm/processor.h                                    |    2 
 arch/mips/cavium-octeon/octeon-platform.c                            |    3 
 arch/mips/kernel/proc.c                                              |    2 
 arch/mips/mm/tlbex.c                                                 |    4 
 arch/nios2/include/asm/entry.h                                       |    3 
 arch/nios2/include/asm/ptrace.h                                      |    2 
 arch/nios2/kernel/entry.S                                            |   22 +-
 arch/nios2/kernel/signal.c                                           |    3 
 arch/nios2/kernel/syscall_table.c                                    |    1 
 arch/parisc/kernel/drivers.c                                         |    9 
 arch/parisc/kernel/syscalls/syscall.tbl                              |    2 
 arch/powerpc/Makefile                                                |   26 --
 arch/powerpc/kernel/pci-common.c                                     |   45 +++-
 arch/powerpc/kernel/prom.c                                           |    7 
 arch/powerpc/mm/ptdump/shared.c                                      |    6 
 arch/powerpc/platforms/Kconfig.cputype                               |   25 ++
 arch/powerpc/platforms/cell/axon_msi.c                               |    1 
 arch/powerpc/platforms/cell/spufs/inode.c                            |    1 
 arch/powerpc/platforms/powernv/rng.c                                 |    2 
 arch/powerpc/sysdev/fsl_pci.c                                        |    8 
 arch/powerpc/sysdev/fsl_pci.h                                        |    1 
 arch/powerpc/sysdev/xive/spapr.c                                     |    1 
 arch/riscv/kernel/sys_riscv.c                                        |    5 
 arch/riscv/kernel/traps.c                                            |    4 
 arch/s390/kernel/machine_kexec_file.c                                |   18 +
 arch/um/os-Linux/skas/process.c                                      |   17 +
 arch/x86/boot/Makefile                                               |    2 
 arch/x86/boot/compressed/Makefile                                    |    4 
 arch/x86/entry/vdso/Makefile                                         |    2 
 arch/x86/kernel/pmem.c                                               |    7 
 arch/x86/kernel/process.c                                            |    9 
 arch/x86/kvm/emulate.c                                               |   23 +-
 arch/x86/kvm/hyperv.c                                                |    3 
 arch/x86/kvm/lapic.c                                                 |    4 
 arch/x86/kvm/svm.c                                                   |    2 
 arch/x86/kvm/vmx/nested.c                                            |   76 ++++----
 arch/x86/mm/numa.c                                                   |    4 
 arch/x86/platform/olpc/olpc-xo1-sci.c                                |    2 
 block/blk-mq-debugfs.c                                               |    3 
 drivers/acpi/acpi_lpss.c                                             |    3 
 drivers/acpi/cppc_acpi.c                                             |   54 ++---
 drivers/acpi/ec.c                                                    |    7 
 drivers/acpi/pci_mcfg.c                                              |    3 
 drivers/acpi/property.c                                              |    8 
 drivers/acpi/sleep.c                                                 |    8 
 drivers/ata/libata-eh.c                                              |    1 
 drivers/atm/idt77252.c                                               |    1 
 drivers/base/dd.c                                                    |    5 
 drivers/block/null_blk_main.c                                        |   14 +
 drivers/bluetooth/hci_intel.c                                        |    6 
 drivers/bus/hisi_lpc.c                                               |   10 -
 drivers/clk/mediatek/reset.c                                         |    4 
 drivers/clk/qcom/camcc-sdm845.c                                      |    4 
 drivers/clk/qcom/clk-krait.c                                         |    7 
 drivers/clk/qcom/gcc-ipq8074.c                                       |   19 ++
 drivers/clk/renesas/r9a06g032-clocks.c                               |    8 
 drivers/clk/rockchip/clk-rk3188.c                                    |    1 
 drivers/crypto/hisilicon/sec/sec_algs.c                              |   14 -
 drivers/crypto/hisilicon/sec/sec_drv.h                               |    2 
 drivers/crypto/inside-secure/safexcel.c                              |    2 
 drivers/dma/sprd-dma.c                                               |    5 
 drivers/firmware/arm_scpi.c                                          |   61 +++---
 drivers/fpga/altera-pr-ip-core.c                                     |    2 
 drivers/gpio/gpiolib-of.c                                            |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                           |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                         |   24 +-
 drivers/gpu/drm/bridge/sil-sii8620.c                                 |    4 
 drivers/gpu/drm/drm_gem.c                                            |    4 
 drivers/gpu/drm/drm_mipi_dbi.c                                       |    7 
 drivers/gpu/drm/exynos/exynos7_drm_decon.c                           |   17 +
 drivers/gpu/drm/mcde/mcde_dsi.c                                      |    1 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                   |   33 ---
 drivers/gpu/drm/mediatek/mtk_dsi.c                                   |    2 
 drivers/gpu/drm/meson/meson_drv.c                                    |    5 
 drivers/gpu/drm/meson/meson_viu.c                                    |   22 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c                            |    3 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c                      |    2 
 drivers/gpu/drm/radeon/ni_dpm.c                                      |    6 
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c                      |   10 -
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                          |    3 
 drivers/gpu/drm/vc4/vc4_dsi.c                                        |    6 
 drivers/gpu/drm/vc4/vc4_plane.c                                      |   30 +--
 drivers/hid/hid-alps.c                                               |    2 
 drivers/hid/hid-cp2112.c                                             |    5 
 drivers/hid/wacom_sys.c                                              |    2 
 drivers/hid/wacom_wac.c                                              |   72 ++++---
 drivers/hwtracing/coresight/coresight.c                              |    1 
 drivers/hwtracing/intel_th/msu-sink.c                                |    3 
 drivers/hwtracing/intel_th/msu.c                                     |   14 +
 drivers/hwtracing/intel_th/pci.c                                     |   25 ++
 drivers/i2c/busses/i2c-cadence.c                                     |   10 -
 drivers/i2c/i2c-core-base.c                                          |    3 
 drivers/i2c/muxes/i2c-mux-gpmux.c                                    |    1 
 drivers/iio/light/isl29028.c                                         |    2 
 drivers/infiniband/hw/hfi1/file_ops.c                                |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                           |    4 
 drivers/infiniband/sw/rxe/rxe_qp.c                                   |   12 -
 drivers/infiniband/sw/siw/siw_cm.c                                   |    7 
 drivers/iommu/dmar.c                                                 |    2 
 drivers/iommu/exynos-iommu.c                                         |    6 
 drivers/iommu/qcom_iommu.c                                           |    7 
 drivers/irqchip/irq-tegra.c                                          |   10 -
 drivers/md/dm-raid.c                                                 |    4 
 drivers/md/dm-thin-metadata.c                                        |    7 
 drivers/md/dm-thin.c                                                 |    4 
 drivers/md/dm-writecache.c                                           |    2 
 drivers/md/dm.c                                                      |    5 
 drivers/md/raid10.c                                                  |    5 
 drivers/md/raid5.c                                                   |    2 
 drivers/media/pci/tw686x/tw686x-core.c                               |   18 -
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h                         |    2 
 drivers/media/usb/hdpvr/hdpvr-video.c                                |    2 
 drivers/memstick/core/ms_block.c                                     |   11 -
 drivers/mfd/max77620.c                                               |    2 
 drivers/mfd/t7l66xb.c                                                |    6 
 drivers/misc/cardreader/rtsx_pcr.c                                   |    6 
 drivers/misc/cxl/irq.c                                               |    1 
 drivers/mmc/host/cavium-octeon.c                                     |    1 
 drivers/mmc/host/cavium-thunderx.c                                   |    4 
 drivers/mmc/host/pxamci.c                                            |    4 
 drivers/mmc/host/sdhci-of-at91.c                                     |    9 
 drivers/mmc/host/sdhci-of-esdhc.c                                    |    1 
 drivers/mtd/devices/st_spi_fsm.c                                     |    8 
 drivers/mtd/maps/physmap-versatile.c                                 |    2 
 drivers/mtd/nand/raw/meson_nand.c                                    |    1 
 drivers/mtd/parsers/redboot.c                                        |    1 
 drivers/mtd/sm_ftl.c                                                 |    2 
 drivers/net/can/pch_can.c                                            |    8 
 drivers/net/can/rcar/rcar_can.c                                      |    8 
 drivers/net/can/sja1000/sja1000.c                                    |    7 
 drivers/net/can/spi/hi311x.c                                         |    5 
 drivers/net/can/spi/mcp251x.c                                        |   18 +
 drivers/net/can/sun4i_can.c                                          |    9 
 drivers/net/can/usb/ems_usb.c                                        |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                    |   12 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                     |    6 
 drivers/net/can/usb/usb_8dev.c                                       |    7 
 drivers/net/dsa/microchip/ksz9477.c                                  |    3 
 drivers/net/dsa/mv88e6060.c                                          |    3 
 drivers/net/ethernet/broadcom/bgmac.c                                |    2 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                     |    4 
 drivers/net/ethernet/freescale/fec_ptp.c                             |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c                          |    4 
 drivers/net/ethernet/intel/iavf/iavf.h                               |    1 
 drivers/net/ethernet/intel/iavf/iavf_adminq.c                        |   15 +
 drivers/net/ethernet/intel/iavf/iavf_main.c                          |   25 ++
 drivers/net/ethernet/intel/ice/ice_switch.c                          |    2 
 drivers/net/ethernet/intel/igb/igb.h                                 |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                            |   12 +
 drivers/net/ethernet/intel/igc/igc_base.c                            |   10 -
 drivers/net/ethernet/intel/igc/igc_main.c                            |    3 
 drivers/net/ethernet/intel/igc/igc_phy.c                             |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                         |    2 
 drivers/net/ethernet/moxa/moxart_ether.c                             |   20 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                 |    2 
 drivers/net/geneve.c                                                 |    3 
 drivers/net/netdevsim/bpf.c                                          |    8 
 drivers/net/plip/plip.c                                              |    2 
 drivers/net/usb/ax88179_178a.c                                       |   16 -
 drivers/net/usb/usbnet.c                                             |    8 
 drivers/net/wireless/ath/ath10k/snoc.c                               |    5 
 drivers/net/wireless/ath/ath9k/htc.h                                 |   10 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                        |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c                           |   18 -
 drivers/net/wireless/intel/iwlegacy/4965-rs.c                        |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                         |    1 
 drivers/net/wireless/intersil/p54/main.c                             |    2 
 drivers/net/wireless/intersil/p54/p54spi.c                           |    3 
 drivers/net/wireless/mac80211_hwsim.c                                |   14 -
 drivers/net/wireless/marvell/libertas/if_usb.c                       |    1 
 drivers/net/wireless/mediatek/mt76/mac80211.c                        |    1 
 drivers/net/wireless/realtek/rtlwifi/debug.c                         |    8 
 drivers/ntb/test/ntb_tool.c                                          |    8 
 drivers/nvme/target/tcp.c                                            |    3 
 drivers/opp/core.c                                                   |    4 
 drivers/pci/controller/dwc/pcie-tegra194.c                           |   48 ++---
 drivers/pci/quirks.c                                                 |    3 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                            |    4 
 drivers/pinctrl/qcom/pinctrl-msm8916.c                               |    4 
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c                          |    1 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                                |    7 
 drivers/platform/olpc/olpc-ec.c                                      |    2 
 drivers/regulator/of_regulator.c                                     |    6 
 drivers/remoteproc/qcom_wcnss.c                                      |   10 -
 drivers/rpmsg/qcom_smd.c                                             |    1 
 drivers/s390/char/zcore.c                                            |   11 +
 drivers/s390/cio/vfio_ccw_drv.c                                      |   14 -
 drivers/s390/scsi/zfcp_fc.c                                          |   29 ++-
 drivers/s390/scsi/zfcp_fc.h                                          |    6 
 drivers/s390/scsi/zfcp_fsf.c                                         |    4 
 drivers/scsi/lpfc/lpfc_debugfs.c                                     |   20 +-
 drivers/scsi/qla2xxx/qla_def.h                                       |    4 
 drivers/scsi/qla2xxx/qla_gbl.h                                       |    3 
 drivers/scsi/qla2xxx/qla_init.c                                      |   34 +++
 drivers/scsi/qla2xxx/qla_isr.c                                       |   16 -
 drivers/scsi/qla2xxx/qla_mbx.c                                       |   17 +
 drivers/scsi/qla2xxx/qla_nvme.c                                      |    5 
 drivers/scsi/sg.c                                                    |   57 +++---
 drivers/scsi/smartpqi/smartpqi_init.c                                |    4 
 drivers/soc/amlogic/meson-mx-socinfo.c                               |    1 
 drivers/soc/fsl/guts.c                                               |    2 
 drivers/soc/qcom/qcom_aoss.c                                         |    4 
 drivers/soundwire/bus_type.c                                         |    8 
 drivers/spi/spi-rspi.c                                               |    4 
 drivers/spi/spi-synquacer.c                                          |    1 
 drivers/staging/rtl8192u/r8192U.h                                    |    2 
 drivers/staging/rtl8192u/r8192U_dm.c                                 |   38 +---
 drivers/staging/rtl8192u/r8192U_dm.h                                 |    2 
 drivers/tee/tee_core.c                                               |    3 
 drivers/thermal/thermal_sysfs.c                                      |   10 -
 drivers/tty/n_gsm.c                                                  |   90 ++++++++-
 drivers/tty/serial/8250/8250_dw.c                                    |    3 
 drivers/tty/serial/mvebu-uart.c                                      |   11 +
 drivers/tty/serial/ucc_uart.c                                        |    2 
 drivers/tty/vt/vt.c                                                  |    2 
 drivers/usb/cdns3/gadget.c                                           |    2 
 drivers/usb/core/hcd.c                                               |   26 +-
 drivers/usb/gadget/function/uvc_video.c                              |    2 
 drivers/usb/gadget/legacy/inode.c                                    |    1 
 drivers/usb/gadget/udc/Kconfig                                       |    2 
 drivers/usb/host/ehci-ppc-of.c                                       |    1 
 drivers/usb/host/ohci-nxp.c                                          |    1 
 drivers/usb/host/ohci-ppc-of.c                                       |    1 
 drivers/usb/host/xhci-tegra.c                                        |    8 
 drivers/usb/host/xhci.h                                              |    2 
 drivers/usb/renesas_usbhs/rza.c                                      |    4 
 drivers/usb/serial/sierra.c                                          |    3 
 drivers/usb/serial/usb-serial.c                                      |    2 
 drivers/usb/serial/usb_wwan.c                                        |    3 
 drivers/vfio/vfio.c                                                  |    1 
 drivers/video/fbdev/amba-clcd.c                                      |   24 +-
 drivers/video/fbdev/arkfb.c                                          |    9 
 drivers/video/fbdev/core/fbcon.c                                     |    8 
 drivers/video/fbdev/i740fb.c                                         |    9 
 drivers/video/fbdev/s3fb.c                                           |    2 
 drivers/video/fbdev/sis/init.c                                       |    4 
 drivers/video/fbdev/vt8623fb.c                                       |    2 
 drivers/virt/vboxguest/vboxguest_linux.c                             |    9 
 drivers/watchdog/armada_37xx_wdt.c                                   |    2 
 drivers/xen/xenbus/xenbus_dev_frontend.c                             |    4 
 fs/attr.c                                                            |    2 
 fs/btrfs/block-group.c                                               |    1 
 fs/btrfs/disk-io.c                                                   |   14 +
 fs/btrfs/raid56.c                                                    |   74 ++++++-
 fs/btrfs/tree-log.c                                                  |    4 
 fs/cifs/smb2ops.c                                                    |    5 
 fs/erofs/decompressor.c                                              |   16 +
 fs/eventpoll.c                                                       |   22 ++
 fs/ext2/super.c                                                      |   12 +
 fs/ext4/inline.c                                                     |    3 
 fs/ext4/inode.c                                                      |   10 -
 fs/ext4/migrate.c                                                    |    4 
 fs/ext4/namei.c                                                      |   23 +-
 fs/ext4/resize.c                                                     |   11 +
 fs/ext4/xattr.c                                                      |    6 
 fs/ext4/xattr.h                                                      |   13 +
 fs/f2fs/node.c                                                       |    6 
 fs/fuse/control.c                                                    |    4 
 fs/fuse/inode.c                                                      |    6 
 fs/jbd2/commit.c                                                     |    2 
 fs/jbd2/transaction.c                                                |   14 +
 fs/namei.c                                                           |    2 
 fs/nfs/nfs4idmap.c                                                   |   46 ++--
 fs/nfs/nfs4proc.c                                                    |   20 +-
 fs/overlayfs/export.c                                                |    2 
 fs/splice.c                                                          |   10 -
 include/acpi/cppc_acpi.h                                             |    2 
 include/asm-generic/bitops/atomic.h                                  |    6 
 include/linux/buffer_head.h                                          |   25 ++
 include/linux/kfifo.h                                                |    2 
 include/linux/kvm_host.h                                             |   28 ++
 include/linux/mfd/t7l66xb.h                                          |    1 
 include/linux/nmi.h                                                  |    2 
 include/linux/pci_ids.h                                              |    2 
 include/linux/tpm_eventlog.h                                         |    2 
 include/linux/usb/hcd.h                                              |    1 
 include/linux/wait.h                                                 |    9 
 include/sound/core.h                                                 |    8 
 include/trace/events/spmi.h                                          |   12 -
 include/uapi/linux/can/error.h                                       |    5 
 kernel/irq/chip.c                                                    |    3 
 kernel/kprobes.c                                                     |    3 
 kernel/power/user.c                                                  |   13 +
 kernel/profile.c                                                     |    7 
 kernel/sched/rt.c                                                    |   15 -
 kernel/time/timekeeping.c                                            |    7 
 kernel/trace/trace_events.c                                          |    1 
 kernel/trace/trace_probe.c                                           |    5 
 kernel/watchdog.c                                                    |   21 +-
 lib/list_debug.c                                                     |   12 +
 mm/mmap.c                                                            |    1 
 mm/mremap.c                                                          |    6 
 net/9p/client.c                                                      |    5 
 net/bluetooth/l2cap_core.c                                           |   13 -
 net/can/j1939/socket.c                                               |    5 
 net/can/j1939/transport.c                                            |    8 
 net/core/devlink.c                                                   |    4 
 net/dccp/proto.c                                                     |   10 -
 net/ipv4/tcp_output.c                                                |   30 ++-
 net/netfilter/nf_tables_api.c                                        |   14 +
 net/rds/ib_recv.c                                                    |    1 
 net/rose/af_rose.c                                                   |   11 -
 net/rose/rose_route.c                                                |    2 
 net/sched/cls_route.c                                                |   12 +
 net/sunrpc/auth.c                                                    |    2 
 net/sunrpc/backchannel_rqst.c                                        |   14 +
 net/vmw_vsock/af_vsock.c                                             |   10 -
 scripts/Makefile.gcc-plugins                                         |    2 
 scripts/faddr2line                                                   |    4 
 security/apparmor/apparmorfs.c                                       |    2 
 security/apparmor/audit.c                                            |    2 
 security/apparmor/domain.c                                           |    2 
 security/apparmor/include/lib.h                                      |    5 
 security/apparmor/include/policy.h                                   |    2 
 security/apparmor/label.c                                            |   13 -
 security/apparmor/mount.c                                            |    8 
 security/selinux/ss/policydb.h                                       |    2 
 sound/core/info.c                                                    |    6 
 sound/core/misc.c                                                    |   94 ++++++++++
 sound/core/timer.c                                                   |   11 -
 sound/pci/hda/patch_cirrus.c                                         |    1 
 sound/pci/hda/patch_conexant.c                                       |   11 +
 sound/pci/hda/patch_realtek.c                                        |   11 +
 sound/soc/codecs/da7210.c                                            |    2 
 sound/soc/codecs/msm8916-wcd-digital.c                               |   46 ++--
 sound/soc/codecs/wcd9335.c                                           |   81 +++-----
 sound/soc/generic/audio-graph-card.c                                 |    4 
 sound/soc/mediatek/mt6797/mt6797-mt6351.c                            |    6 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c                     |   10 -
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                            |    9 
 sound/soc/qcom/qdsp6/q6adm.c                                         |    2 
 sound/usb/bcd2000/bcd2000.c                                          |    3 
 tools/build/feature/test-libcrypto.c                                 |   15 +
 tools/lib/bpf/libbpf.c                                               |    9 
 tools/perf/util/genelf.c                                             |    6 
 tools/perf/util/symbol-elf.c                                         |   27 ++
 tools/testing/selftests/bpf/test_btf.c                               |    2 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc |    1 
 tools/testing/selftests/timers/clocksource-switch.c                  |    6 
 tools/testing/selftests/timers/valid-adjtimex.c                      |    2 
 tools/thermal/tmon/sysfs.c                                           |   24 +-
 tools/thermal/tmon/tmon.h                                            |    3 
 tools/vm/slabinfo.c                                                  |   32 ++-
 virt/kvm/kvm_main.c                                                  |   10 -
 368 files changed, 2211 insertions(+), 1113 deletions(-)

Al Viro (6):
      nios2: page fault et.al. are *not* restartable syscalls...
      nios2: don't leave NULLs in sys_call_table[]
      nios2: traced syscall does need to check the syscall number
      nios2: fix syscall restart checks
      nios2: restarts apply only to the first sigframe we build...
      nios2: add force_successful_syscall_return()

Alan Brady (1):
      i40e: Fix to stop tx_timeout recovery if GLOBR fails

Alex Bee (1):
      clk: rockchip: add sclk_mac_lbtest to rk3188_critical_clocks

Alexander Gordeev (1):
      s390/zcore: fix race when reading from hardware system area

Alexander Lobakin (3):
      ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
      x86/olpc: fix 'logical not is only applied to the left hand side'
      iommu/vt-d: avoid invalid memory access via node_online(NUMA_NO_NODE)

Alexander Shishkin (4):
      intel_th: msu: Fix vmalloced buffers
      intel_th: pci: Add Raptor Lake-S CPU support
      intel_th: pci: Add Raptor Lake-S PCH support
      intel_th: pci: Add Meteor Lake-P support

Alexander Stein (5):
      ARM: dts: imx6ul: add missing properties for sram
      ARM: dts: imx6ul: change operating-points to uint32-matrix
      ARM: dts: imx6ul: fix csi node compatible
      ARM: dts: imx6ul: fix lcdif node compatible
      ARM: dts: imx6ul: fix qspi node compatible

Alexey Kodanev (2):
      drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
      wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Allen Ballway (1):
      ALSA: hda/cirrus - support for iMac 12,1 model

Amadeusz Sławiński (1):
      ALSA: info: Fix llseek return value when using callback

Ammar Faizi (1):
      wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Andrew Donnellan (1):
      gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Aneesh Kumar K.V (1):
      mm/mremap: hold the rmap lock in write mode when moving page table entries.

AngeloGioacchino Del Regno (1):
      media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Ansuel Smith (1):
      clk: qcom: clk-krait: unlock spin after mux completion

Antonio Borneo (2):
      genirq: Don't return error on missing optional irq_request_resources()
      drm: adv7511: override i2c address of cec before accessing it

Arnaldo Carvalho de Melo (1):
      genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Artem Borisov (1):
      HID: alps: Declare U1_UNICORN_LEGACY support

Arun Easi (1):
      scsi: qla2xxx: Fix discovery issues in FC-AL topology

Arun Ramadoss (1):
      net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Baokun Li (4):
      ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h
      ext4: fix use-after-free in ext4_xattr_set_entry
      ext4: correct max_inline_xattr_value_size computing
      ext4: correct the misjudgment in ext4_iget_extra_inode

Benjamin Segall (1):
      epoll: autoremove wakers even more aggressively

Biju Das (1):
      spi: spi-rspi: Fix PIO fallback on RZ platforms

Bo-Chen Chen (1):
      drm/mediatek: dpi: Remove output format of YUV

Brian Norris (1):
      drm/rockchip: vop: Don't crash for invalid duplicate_state()

Celeste Liu (1):
      riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Chao Yu (1):
      f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()

Chen Lin (1):
      dpaa2-eth: trace the allocated address instead of page struct

Chen Zhongjin (2):
      profiling: fix shift too large makes kernel panic
      kprobes: Forbid probing on trampoline and BPF code areas

Cheng Xu (1):
      RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event

Christophe JAILLET (11):
      drm/rockchip: Fix an error handling path rockchip_dp_probe()
      wifi: p54: Fix an error handling path in p54spi_probe()
      mtd: rawnand: meson: Fix a potential double free issue
      misc: rtsx: Fix an error handling path in rtsx_pci_probe()
      intel_th: Fix a resource leak in an error handling path
      memstick/ms_block: Fix some incorrect memory allocation
      memstick/ms_block: Fix a memory leak
      ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()
      mmc: pxamci: Fix another error handling path in pxamci_probe()
      mmc: pxamci: Fix an error handling path in pxamci_probe()
      cxl: Fix a memory leak in an error handling path

Christophe Leroy (3):
      powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
      powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32
      powerpc/32: Don't always pass -mcpu=powerpc to the compiler

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Damien Le Moal (1):
      ata: libata-eh: Add missing command name

Dan Aloni (1):
      sunrpc: fix expiry of auth creds

Dan Carpenter (8):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      selftests/bpf: fix a test for snprintf() overflow
      platform/olpc: Fix uninitialized data in debugfs write
      null_blk: fix ida error handling in null_add_dev()
      kfifo: fix kfifo_to_user() return type
      NTB: ntb_tool: uninitialized heap data in tool_fn_write()
      xen/xenbus: fix return type in xenbus_file_read()

Daniel Starke (6):
      tty: n_gsm: fix non flow control frames during mux flow off
      tty: n_gsm: fix packet re-transmission without open control channel
      tty: n_gsm: fix race condition in gsmld_write()
      tty: n_gsm: fix wrong T1 retry count handling
      tty: n_gsm: fix DM command
      tty: n_gsm: fix missing corner cases in gsmld_poll()

Dave Stevenson (2):
      drm/vc4: plane: Fix margin calculations for the right/bottom edges
      drm/vc4: dsi: Correct DSI divider calculations

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Dmitry Osipenko (1):
      drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error

Dom Cobley (1):
      drm/vc4: plane: Remove subpixel positioning check

Duoming Zhou (3):
      mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
      staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Eric Dumazet (2):
      net: rose: fix netdev reference changes
      tcp: fix over estimation in sk_forced_mem_schedule()

Eric Farman (1):
      vfio/ccw: Do not change FSM state in subchannel event

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Fedor Pchelkin (2):
      can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
      can: j1939: j1939_session_destroy(): fix memory leak of skbs

Filipe Manana (1):
      btrfs: fix lost error handling when looking up extended ref on log replay

Florian Fainelli (1):
      tools/thermal: Fix possible path truncations

Florian Westphal (2):
      netfilter: nf_tables: fix null deref due to zeroed list head
      plip: avoid rcu debug splat

Francis Laniel (1):
      arm64: Do not forget syscall when starting a new thread.

Frank Li (1):
      usb: cdns3 fix use-after-free at workaround 2

Gao Xiang (1):
      erofs: avoid consecutive detection for Highmem memory

Greg Kroah-Hartman (1):
      Linux 5.4.211

Grzegorz Siwik (1):
      ice: Ignore EEXIST when setting promisc mode

Guenter Roeck (1):
      lib/list_debug.c: Detect uninitialized lists

Guillaume Ranquet (1):
      drm/mediatek: dpi: Only enable dpi after the bridge is enabled

Guo Mengqi (1):
      spi: synquacer: Add missing clk_disable_unprepare()

Hangyu Hua (3):
      drm: bridge: sii8620: fix possible off-by-one
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Hans de Goede (1):
      ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks

Haoyue Xu (1):
      RDMA/hns: Fix incorrect clearing of interrupt status register

Harshit Mogalapalli (1):
      HID: cp2112: prevent a buffer overflow in cp2112_xfer()

Hector Martin (1):
      locking/atomic: Make test_and_*_bit() ordered on failure

Helge Deller (3):
      fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters
      parisc: Fix device names in /proc/iomem
      parisc: io_pgetevents_time64() needs compat syscall in 32-bit compat mode

Huacai Chen (3):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
      tpm: eventlog: Fix section mismatch for DEBUG_SECTION_MISMATCH
      PCI/ACPI: Guard ARM64-specific mcfg_quirks

Ian Rogers (1):
      perf symbol: Fail to read phdr workaround

Ido Schimmel (1):
      devlink: Fix use-after-free after a failed reload

Ilpo Järvinen (1):
      serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

James Smart (1):
      scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input

Jan Kara (1):
      ext2: Add more validity checks for inode counts

Jason A. Donenfeld (3):
      fs: check FMODE_LSEEK to control internal pipe splicing
      timekeeping: contribute wall clock to rng on time change
      um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Jian Zhang (1):
      drm/exynos/exynos7_drm_decon: free resources when clk_set_parent() failed.

Jianglei Nie (1):
      RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Jiasheng Jiang (4):
      drm: bridge: adv7511: Add check for mipi_dsi_driver_register
      Bluetooth: hci_intel: Add check for platform_driver_register
      intel_th: msu-sink: Potential dereference of null pointer
      ASoC: codecs: da7210: add check for i2c_add_driver

Johan Hovold (2):
      x86/pmem: Fix platform-device leak in error path
      USB: serial: fix tty-port initialized comments

Johannes Berg (2):
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: mac80211_hwsim: use 32-bit skb cookie

John Johansen (4):
      apparmor: fix quiet_denied for file rules
      apparmor: fix absroot causing audited secids to begin with =
      apparmor: Fix failed mount permission check error message
      apparmor: fix overlapping attachment computation

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Josef Bacik (1):
      btrfs: reset block group chunk force if we have to wait

Josh Poimboeuf (1):
      scripts/faddr2line: Fix vmlinux detection on arm64

Jozef Martiniak (1):
      gadgetfs: ep_io - wait until IRQ finishes

Juri Lelli (1):
      wait: Fix __wait_event_hrtimeout for RT/DL tasks

Kiselev, Oleg (1):
      ext4: avoid resizing to a partial cluster size

Krzysztof Kozlowski (6):
      ARM: dts: ast2500-evb: fix board compatible
      ARM: dts: ast2600-evb: fix board compatible
      ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg
      ARM: dts: qcom: pm8841: add required thermal-sensor-cells
      ath10k: do not enforce interrupt trigger type
      dt-bindings: arm: qcom: fix MSM8916 MTP compatibles

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
      arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC

Lars-Peter Clausen (1):
      i2c: cadence: Support PEC for SMBus block read

Laurent Dufour (1):
      watchdog: export lockup_detector_reconfigure

Leo Li (1):
      drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Li Lingfeng (1):
      ext4: recover csum seed of tmp_inode after migrating to extents

Liang He (16):
      ARM: OMAP2+: display: Fix refcount leak bug
      ARM: shmobile: rcar-gen2: Increase refcount for new reference
      regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      i2c: mux-gpmux: Add of_node_put() when breaking out of loop
      gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
      mmc: cavium-octeon: Add of_node_put() when breaking out of loop
      mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
      iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
      ASoC: audio-graph-card: Add of_node_put() in fail path
      video: fbdev: amba-clcd: Fix refcount leak bugs
      drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
      usb: host: ohci-ppc-of: Fix refcount leak bug
      usb: renesas: Fix refcount leak bug
      tty: serial: Fix refcount leak bug in ucc_uart.c
      mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Lin Ma (1):
      igb: Add lock to avoid data race

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Lukas Czerner (1):
      ext4: make sure ext4_append() always allocates new block

Lukas Wunner (1):
      usbnet: Fix linkwatch use-after-free on disconnect

Luo Meng (1):
      dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Maciej S. Szmigiero (1):
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Mahesh Rajashekhara (1):
      scsi: smartpqi: Fix DMA direction for RAID requests

Manyi Li (1):
      ACPI: PM: save NVS memory for Lenovo G40-45

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Marco Pagani (1):
      fpga: altera-pr-ip: fix unsigned comparison with less than zero

Markus Mayer (1):
      thermal/tools/tmon: Include pthread and time headers in tmon.h

Matthias May (1):
      geneve: do not use RT_TOS for IPv6 flowlabel

Maxim Mikityanskiy (1):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Meng Tang (2):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
      ALSA: hda/realtek: Add quirk for another Asus K42JZ model

Miaohe Lin (1):
      mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Miaoqian Lin (22):
      meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
      ARM: bcm: Fix refcount leak in bcm_kona_smc_init
      ARM: OMAP2+: Fix refcount leak in omapdss_init_of
      ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
      cpufreq: zynq: Fix refcount leak in zynq_get_revision
      soc: qcom: aoss: Fix refcount leak in qmp_cooling_devices_register
      drm/mcde: Fix refcount leak in mcde_dsi_bind
      mtd: maps: Fix refcount leak in of_flash_probe_versatile
      mtd: maps: Fix refcount leak in ap_flash_init
      mtd: partitions: Fix refcount leak in parse_redboot_of
      usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe
      usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe
      mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
      ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
      ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe
      ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe
      rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge
      mfd: max77620: Fix refcount leak in max77620_initialise_fps
      powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader
      powerpc/xive: Fix refcount leak in xive_get_max_prio
      powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address
      pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Michael Ellerman (3):
      powerpc/powernv: Avoid crashing if rng is NULL
      powerpc/pci: Fix PHB numbering when using opal-phbid
      powerpc/pci: Fix get_phb_number() locking

Michael Grzeschik (1):
      usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info

Michael Walle (1):
      soc: fsl: guts: machine variable might be unset

Michal Suchanek (1):
      kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

Mike Snitzer (1):
      dm: return early from dm_pr_call() if DM device is suspended

Miklos Szeredi (1):
      fuse: limit nsec

Mikulas Patocka (6):
      add barriers to buffer_uptodate and set_buffer_uptodate
      md-raid10: fix KASAN warning
      dm raid: fix address sanitizer warning in raid_resume
      dm raid: fix address sanitizer warning in raid_status
      dm writecache: set a default MAX_WRITEBACK_JOBS
      rds: add missing barrier to release_refill

Ming Lei (1):
      blk-mq: don't create hctx debugfs dir until q->debugfs_dir is created

Narendra Hadke (1):
      serial: mvebu-uart: uart2 error bits clearing

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Nick Desaulniers (2):
      Makefile: link with -z noexecstack --no-warn-rwx-segments
      x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nick Hainke (1):
      arm64: dts: mt7622: fix BPI-R64 WPS button

Nicolas Saenz Julienne (1):
      nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Niels Dossche (1):
      media: hdpvr: fix error value returns in hdpvr_read

Nikita Travkin (1):
      pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Nilesh Javali (1):
      scsi: Revert "scsi: qla2xxx: Fix disk failure to rediscover"

Pablo Neira Ayuso (1):
      netfilter: nf_tables: really skip inactive sets when allocating name

Pali Rohár (4):
      PCI: Add defines for normal and subtractive PCI bridges
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port
      crypto: inside-secure - Add missing MODULE_DEVICE_TABLE for of
      powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Pascal Terjan (1):
      vboxguest: Do not use devm for irq

Pavan Chebbi (1):
      PCI: Add ACS quirk for Broadcom BCM5750x NICs

Pavel Skripkin (1):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Peilin Ye (2):
      vsock: Fix memory leak in vsock_connect()
      vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Pierre-Louis Bossart (1):
      soundwire: bus_type: fix remove and shutdown support

Ping Cheng (2):
      HID: wacom: Only report rotation for art pen
      HID: wacom: Don't register pad_input for touch switch

Przemyslaw Patynowski (2):
      iavf: Fix max_rate limiting
      iavf: Fix adminq error handling

Qian Cai (1):
      crypto: arm64/gcm - Select AEAD for GHASH_ARM64_CE

Qifu Zhang (1):
      Documentation: ACPI: EINJ: Fix obsolete example

Qu Wenruo (3):
      btrfs: reject log replay if there is unsupported RO compat flag
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Quinn Tran (2):
      scsi: qla2xxx: Turn off multi-queue for 8G adapters
      scsi: qla2xxx: Fix erroneous mailbox timeout after PCI error injection

Rafael J. Wysocki (2):
      thermal: sysfs: Fix cooling_device_stats_setup() error code path
      ACPI: CPPC: Do not prevent CPPC from working in the future

Ralph Siemsen (1):
      clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Randy Dunlap (1):
      usb: gadget: udc: amd5536 depends on HAS_DMA

Rex-BC Chen (1):
      clk: mediatek: reset: Fix written reset bit offset

Rob Clark (1):
      drm/msm/mdp5: Fix global state lock backoff

Robert Marko (4):
      arm64: dts: qcom: ipq8074: fix NAND node name
      clk: qcom: ipq8074: fix NSS port frequency tables
      clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks
      clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Roberto Sassu (1):
      tools build: Switch to new openssl API for test-libcrypto

Russell King (Oracle) (1):
      ARM: findbit: fix overflowing offset

Rustam Subkhankulov (2):
      wifi: p54: add missing parentheses in p54_flush()
      video: fbdev: sis: fix typos in SiS_GetModeID()

Sagi Grimberg (1):
      nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown

Sai Prakash Ranjan (2):
      irqchip/tegra: Fix overflow implicit truncation warnings
      drm/meson: Fix overflow implicit truncation warnings

Sakari Ailus (1):
      ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Sam Protsenko (1):
      iommu/exynos: Handle failed IOMMU device registration properly

Samuel Holland (2):
      arm64: dts: allwinner: a64: orangepi-win: Fix LED node name
      pinctrl: sunxi: Add I/O bias setting for H6 R-PIO

Sandor Bodo-Merle (1):
      net: bgmac: Fix a BUG triggered by wrong bytes_compl

Sasha Neftin (1):
      igc: Remove _I_PHY_ID checking

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Sean Christopherson (6):
      KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
      KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
      KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: Add infrastructure and macro to mark VM as bugged

Sebastian Würl (1):
      can: mcp251x: Fix race condition on receive interrupt

Sergei Antonov (2):
      net: dsa: mv88e6060: prevent crash on an unused port
      net: moxa: pass pdev instead of ndev to DMA functions

Sergey Shtylyov (1):
      usb: host: xhci: use snprintf() in xhci_decode_trb()

Siddh Raman Pant (1):
      x86/numa: Use cpumask_available instead of hardcoded NULL check

Sireesh Kodali (1):
      remoteproc: qcom: wcnss: Fix handling of IRQs

Srinivas Kandagatla (2):
      ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV
      ASoC: codecs: wcd9335: move gains from SX_TLV to S8_TLV

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Steve French (1):
      smb3: check xattr value length earlier

Steven Rostedt (Google) (3):
      tracing: Have filter accept "common_cpu" to be consistent
      selftests/kprobe: Do not test for GRP/ without event failures
      tracing/probes: Have kprobes and uprobes use $COMM too

Sudeep Holla (1):
      firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Suzuki K Poulose (1):
      coresight: Clear the connection field properly

Takashi Iwai (2):
      ALSA: core: Add async signal helpers
      ALSA: timer: Use deferred fasync helper

Tang Bin (2):
      usb: xhci: tegra: Fix error check
      opp: Fix error check in dev_pm_opp_attach_genpd()

Tetsuo Handa (2):
      tty: vt: initialize unicode screen buffer
      PM: hibernate: defer device probing when resuming from hibernation

Thadeu Lima de Souza Cascardo (3):
      netfilter: nf_tables: do not allow SET_ID to refer to another table
      netfilter: nf_tables: do not allow RULE_ID to refer to another chain
      net_sched: cls_route: remove from list when handle is 0

Theodore Ts'o (1):
      ext4: update s_overhead_clusters in the superblock during an on-line resize

Timur Tabi (1):
      drm/nouveau: fix another off-by-one in nvbios_addr

Tom Rix (1):
      apparmor: fix aa_label_asxprint return check

Tony Battersby (1):
      scsi: sg: Allow waiting for commands to complete on removed device

Trond Myklebust (5):
      NFSv4.1: Don't decrease the value of seq_nr_highest_sent
      NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
      NFSv4: Fix races in the legacy idmapper upcall
      NFSv4/pnfs: Fix a use-after-free bug in open
      SUNRPC: Reinitialise the backchannel request buffers before reuse

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Uwe Kleine-König (3):
      mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path
      mfd: t7l66xb: Drop platform disable callback
      dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Vidya Sagar (2):
      PCI: tegra194: Fix Root Port interrupt handling
      PCI: tegra194: Fix link up retry sequence

Vincent Mailhol (10):
      can: pch_can: do not report txerr and rxerr during bus-off
      can: rcar_can: do not report txerr and rxerr during bus-off
      can: sja1000: do not report txerr and rxerr during bus-off
      can: hi311x: do not report txerr and rxerr during bus-off
      can: sun4i_can: do not report txerr and rxerr during bus-off
      can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
      can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
      can: usb_8dev: do not report txerr and rxerr during bus-off
      can: error: specify the values of data[5..7] of CAN error frames
      can: pch_can: pch_can_error(): initialize errc before using it

Vitaly Kuznetsov (2):
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Vladimir Zapolskiy (1):
      clk: qcom: camcc-sdm845: Fix topology around titan_top power domain

Weitao Wang (1):
      USB: HCD: Fix URB giveback issue in tasklet function

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

William Dean (1):
      watchdog: armada_37xx_wdt: check the return value of devm_ioremap() in armada_37xx_wdt_probe()

Wolfram Sang (2):
      selftests: timers: valid-adjtimex: build fix for newer toolchains
      selftests: timers: clocksource-switch: fix passing errors from child

Wyes Karny (1):
      x86: Handle idle=nomwait cmdline properly for x86_idle

Xianting Tian (1):
      RISC-V: Add fast call path of crash_kexec()

Xie Yongji (1):
      fuse: Remove the control interface for virtio-fs

Xin Xiong (1):
      apparmor: fix reference count leak in aa_pivotroot()

Xinlei Lee (1):
      drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Xiu Jianfeng (2):
      selinux: Add boundary check in put_entry()
      apparmor: Fix memleak in aa_simple_write_to_buffer()

Xu Wang (1):
      i2c: Fix a potential use after free

Yang Xu (1):
      fs: Add missing umask strip in vfs_tmpfile

Yang Yingliang (1):
      bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Ye Bin (1):
      ext4: avoid remove directory when directory is corrupted

Yonglong Li (1):
      tcp: make retransmitted SKB fit into the send window

Yu Xiao (1):
      nfp: ethtool: fix the display error of `ethtool -m DEVNAME`

Yuanzheng Song (1):
      tools/vm/slabinfo: use alphabetic order when two values are equal

Yunhao Tian (1):
      drm/mipi-dbi: align max_chunk to 2 in spi_transfer

Zhang Wensheng (1):
      driver core: fix potential deadlock in __driver_attach

Zhang Xianwei (1):
      NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Zhang Yi (1):
      jbd2: fix outstanding credits assert in jbd2_journal_commit_transaction()

Zhengchao Shao (1):
      crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Zheyu Ma (8):
      ALSA: bcd2000: Fix a UAF bug on the error path of probing
      iio: light: isl29028: Fix the warning in isl29028_remove()
      media: tw686x: Register the irq at the end of probe
      video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()
      video: fbdev: vt8623fb: Check the size of screen before memset_io()
      video: fbdev: arkfb: Check the size of screen before memset_io()
      video: fbdev: s3fb: Check the size of screen before memset_io()
      video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhihao Cheng (1):
      jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted

Zhouyi Zhou (1):
      powerpc/64: Init jump labels before parse_early_param()

Zhu Yanjun (1):
      RDMA/rxe: Fix error unwind in rxe_create_qp()

haibinzhang (张海斌) (1):
      arm64: fix oops in concurrently setting insn_emulation sysctls

huhai (1):
      ACPI: LPSS: Fix missing check in register_device_clock()

