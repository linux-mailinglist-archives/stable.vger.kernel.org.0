Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36349E38F
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbiA0Ndl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbiA0Nct (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A046C061748;
        Thu, 27 Jan 2022 05:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85080B82232;
        Thu, 27 Jan 2022 13:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E815C340E4;
        Thu, 27 Jan 2022 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290348;
        bh=TuAIeGB8Xm8pZDmiYw/SRREUh0HETr8wTL/RGo0SIlw=;
        h=From:To:Cc:Subject:Date:From;
        b=UjcZEYxP321g4c6VFM+AY3o7zra3T4xK47/hIFotmyQL31VUAdeyhOX6/u1NU7xe2
         ZNtl9J/2b/FzqdvsM0YtnXXxb9SmgJLiXDJDpBIyR9mc+w3PeqWDdsZiwDrr/AZz4e
         dGHXWI5s2V8eC5AT9tPosWldsLpOjSqAk1Qh8NwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.174
Date:   Thu, 27 Jan 2022 14:32:06 +0100
Message-Id: <164329032725153@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.174 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst                        |    2 
 Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml |    5 
 Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml     |    6 
 Documentation/driver-api/dmaengine/dmatest.rst                       |    7 
 Documentation/driver-api/firewire.rst                                |    4 
 Documentation/firmware-guide/acpi/dsd/data-node-references.rst       |   10 
 Makefile                                                             |    2 
 arch/arm/boot/compressed/efi-header.S                                |   22 
 arch/arm/boot/compressed/head.S                                      |    3 
 arch/arm/boot/dts/armada-38x.dtsi                                    |    4 
 arch/arm/boot/dts/gemini-nas4220b.dts                                |    2 
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c                   |    5 
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi                    |    3 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts                    |   14 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                             |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                                |    4 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                                |    3 
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                                 |    6 
 arch/ia64/kernel/kprobes.c                                           |   78 ++
 arch/mips/bcm63xx/clk.c                                              |    6 
 arch/mips/cavium-octeon/octeon-platform.c                            |    2 
 arch/mips/cavium-octeon/octeon-usb.c                                 |    1 
 arch/mips/include/asm/octeon/cvmx-bootinfo.h                         |    4 
 arch/mips/lantiq/clk.c                                               |    6 
 arch/parisc/kernel/traps.c                                           |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi                        |    2 
 arch/powerpc/kernel/btext.c                                          |    4 
 arch/powerpc/kernel/prom_init.c                                      |    2 
 arch/powerpc/kernel/smp.c                                            |   32 
 arch/powerpc/kernel/watchdog.c                                       |   41 +
 arch/powerpc/kvm/book3s_hv_nested.c                                  |    2 
 arch/powerpc/platforms/cell/iommu.c                                  |    1 
 arch/powerpc/platforms/cell/pervasive.c                              |    1 
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c                        |    1 
 arch/powerpc/platforms/powermac/low_i2c.c                            |    3 
 arch/powerpc/platforms/powernv/opal-lpc.c                            |    1 
 arch/s390/mm/pgalloc.c                                               |    4 
 arch/um/include/shared/registers.h                                   |    4 
 arch/um/os-Linux/registers.c                                         |    4 
 arch/um/os-Linux/start_up.c                                          |    2 
 arch/x86/include/asm/realmode.h                                      |    1 
 arch/x86/kernel/cpu/mce/core.c                                       |   31 
 arch/x86/kernel/cpu/mce/inject.c                                     |    2 
 arch/x86/kernel/early-quirks.c                                       |   10 
 arch/x86/kernel/reboot.c                                             |   12 
 arch/x86/realmode/init.c                                             |   26 
 arch/x86/um/syscalls_64.c                                            |    3 
 drivers/acpi/acpica/exfield.c                                        |    7 
 drivers/acpi/acpica/exoparg1.c                                       |    3 
 drivers/acpi/acpica/hwesleep.c                                       |    4 
 drivers/acpi/acpica/hwsleep.c                                        |    4 
 drivers/acpi/acpica/hwxfsleep.c                                      |    2 
 drivers/acpi/acpica/utdelete.c                                       |    1 
 drivers/acpi/battery.c                                               |   22 
 drivers/acpi/ec.c                                                    |   57 +
 drivers/acpi/internal.h                                              |    2 
 drivers/acpi/scan.c                                                  |   13 
 drivers/android/binder.c                                             |    4 
 drivers/block/floppy.c                                               |    6 
 drivers/bluetooth/btmtksdio.c                                        |    2 
 drivers/bluetooth/hci_bcm.c                                          |    7 
 drivers/char/mwave/3780i.h                                           |    2 
 drivers/char/random.c                                                |   19 
 drivers/char/tpm/tpm_tis_core.c                                      |    8 
 drivers/clk/bcm/clk-bcm2835.c                                        |   13 
 drivers/clk/clk-si5341.c                                             |    2 
 drivers/clk/clk-stm32f4.c                                            |    4 
 drivers/clk/imx/clk-imx8mn.c                                         |    6 
 drivers/clk/meson/gxbb.c                                             |   44 +
 drivers/cpufreq/cpufreq.c                                            |    4 
 drivers/crypto/caam/caamalg_qi2.c                                    |    2 
 drivers/crypto/omap-aes.c                                            |    2 
 drivers/crypto/qce/sha.c                                             |    2 
 drivers/crypto/stm32/stm32-crc32.c                                   |    4 
 drivers/crypto/stm32/stm32-cryp.c                                    |    6 
 drivers/dma-buf/dma-fence-array.c                                    |    6 
 drivers/dma/at_xdmac.c                                               |   49 -
 drivers/dma/mmp_pdma.c                                               |    6 
 drivers/dma/pxa_dma.c                                                |    7 
 drivers/dma/stm32-mdma.c                                             |    2 
 drivers/edac/synopsys_edac.c                                         |    3 
 drivers/firmware/google/Kconfig                                      |    6 
 drivers/gpio/gpio-aspeed.c                                           |   52 -
 drivers/gpio/gpiolib-acpi.c                                          |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                                |   13 
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c                    |   14 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c             |   40 -
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                       |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c                         |    6 
 drivers/gpu/drm/lima/lima_device.c                                   |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                              |    4 
 drivers/gpu/drm/nouveau/dispnv04/disp.c                              |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c                       |   37 -
 drivers/gpu/drm/panel/panel-innolux-p079zca.c                        |   10 
 drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c                   |    8 
 drivers/gpu/drm/radeon/radeon_kms.c                                  |   42 -
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                      |   80 +-
 drivers/hid/hid-apple.c                                              |    2 
 drivers/hid/hid-input.c                                              |    6 
 drivers/hid/hid-uclogic-params.c                                     |   31 
 drivers/hid/uhid.c                                                   |   29 
 drivers/hid/wacom_wac.c                                              |   39 +
 drivers/hsi/hsi_core.c                                               |    1 
 drivers/i2c/busses/i2c-designware-pcidrv.c                           |    8 
 drivers/i2c/busses/i2c-i801.c                                        |   15 
 drivers/i2c/busses/i2c-mpc.c                                         |   23 
 drivers/infiniband/core/cma.c                                        |   12 
 drivers/infiniband/core/device.c                                     |    3 
 drivers/infiniband/hw/cxgb4/qp.c                                     |    1 
 drivers/infiniband/hw/hns/hns_roce_main.c                            |    5 
 drivers/infiniband/sw/rxe/rxe_opcode.c                               |    2 
 drivers/iommu/io-pgtable-arm-v7s.c                                   |    6 
 drivers/iommu/io-pgtable-arm.c                                       |    9 
 drivers/iommu/iova.c                                                 |    3 
 drivers/md/persistent-data/dm-btree.c                                |    8 
 drivers/md/persistent-data/dm-space-map-common.c                     |    5 
 drivers/media/common/saa7146/saa7146_fops.c                          |    2 
 drivers/media/common/videobuf2/videobuf2-dma-contig.c                |    8 
 drivers/media/dvb-core/dmxdev.c                                      |   18 
 drivers/media/dvb-frontends/dib8000.c                                |    4 
 drivers/media/pci/b2c2/flexcop-pci.c                                 |    3 
 drivers/media/pci/saa7146/hexium_gemini.c                            |    7 
 drivers/media/pci/saa7146/hexium_orion.c                             |    8 
 drivers/media/pci/saa7146/mxb.c                                      |    8 
 drivers/media/platform/aspeed-video.c                                |   14 
 drivers/media/platform/coda/imx-vdoa.c                               |    6 
 drivers/media/platform/imx-pxp.c                                     |    4 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c               |    2 
 drivers/media/platform/qcom/venus/core.c                             |    8 
 drivers/media/platform/rcar-vin/rcar-csi2.c                          |   18 
 drivers/media/radio/si470x/radio-si470x-i2c.c                        |    3 
 drivers/media/rc/igorplugusb.c                                       |    4 
 drivers/media/rc/mceusb.c                                            |    8 
 drivers/media/rc/redrat3.c                                           |   22 
 drivers/media/tuners/msi001.c                                        |    7 
 drivers/media/tuners/si2157.c                                        |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                                 |   10 
 drivers/media/usb/b2c2/flexcop-usb.h                                 |   12 
 drivers/media/usb/cpia2/cpia2_usb.c                                  |    4 
 drivers/media/usb/dvb-usb/dib0700_core.c                             |    2 
 drivers/media/usb/dvb-usb/dw2102.c                                   |  338 ++++++----
 drivers/media/usb/dvb-usb/m920x.c                                    |   12 
 drivers/media/usb/em28xx/em28xx-cards.c                              |   18 
 drivers/media/usb/em28xx/em28xx-core.c                               |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                              |    8 
 drivers/media/usb/s2255/s2255drv.c                                   |    4 
 drivers/media/usb/stk1160/stk1160-core.c                             |    4 
 drivers/media/usb/uvc/uvcvideo.h                                     |    2 
 drivers/media/v4l2-core/v4l2-ioctl.c                                 |    4 
 drivers/misc/lattice-ecp3-config.c                                   |   12 
 drivers/misc/lkdtm/Makefile                                          |    2 
 drivers/mmc/core/sdio.c                                              |    4 
 drivers/mmc/host/meson-mx-sdio.c                                     |    5 
 drivers/mtd/nand/bbt.c                                               |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                           |   37 -
 drivers/net/bonding/bond_main.c                                      |    6 
 drivers/net/can/softing/softing_cs.c                                 |    2 
 drivers/net/can/softing/softing_fw.c                                 |   11 
 drivers/net/can/xilinx_can.c                                         |    7 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                       |   10 
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c                    |    3 
 drivers/net/ethernet/cortina/gemini.c                                |    9 
 drivers/net/ethernet/freescale/fman/mac.c                            |   21 
 drivers/net/ethernet/freescale/xgmac_mdio.c                          |    3 
 drivers/net/ethernet/i825xx/sni_82596.c                              |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                        |   36 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                    |   10 
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c                     |    6 
 drivers/net/ethernet/mellanox/mlxsw/pci.c                            |    1 
 drivers/net/ethernet/rocker/rocker_ofdpa.c                           |    3 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                    |   10 
 drivers/net/phy/marvell.c                                            |    6 
 drivers/net/phy/mdio_bus.c                                           |    2 
 drivers/net/phy/phy-core.c                                           |    2 
 drivers/net/ppp/ppp_generic.c                                        |    7 
 drivers/net/usb/mcs7830.c                                            |   12 
 drivers/net/wireless/ath/ar5523/ar5523.c                             |    4 
 drivers/net/wireless/ath/ath10k/htt_tx.c                             |    3 
 drivers/net/wireless/ath/ath10k/txrx.c                               |    2 
 drivers/net/wireless/ath/ath9k/hif_usb.c                             |    7 
 drivers/net/wireless/ath/wcn36xx/dxe.c                               |    5 
 drivers/net/wireless/ath/wcn36xx/smd.c                               |    4 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                         |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                    |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                        |   27 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                        |    2 
 drivers/net/wireless/marvell/mwifiex/sta_event.c                     |    8 
 drivers/net/wireless/marvell/mwifiex/usb.c                           |    3 
 drivers/net/wireless/rsi/rsi_91x_main.c                              |    4 
 drivers/net/wireless/rsi/rsi_91x_usb.c                               |    9 
 drivers/net/wireless/rsi/rsi_usb.h                                   |    2 
 drivers/of/base.c                                                    |   11 
 drivers/parisc/pdc_stable.c                                          |    4 
 drivers/pci/controller/pci-aardvark.c                                |    4 
 drivers/pci/controller/pci-mvebu.c                                   |    8 
 drivers/pci/msi.c                                                    |   26 
 drivers/pci/pci-bridge-emul.c                                        |   27 
 drivers/pci/quirks.c                                                 |    3 
 drivers/pcmcia/cs.c                                                  |    8 
 drivers/pcmcia/rsrc_nonstatic.c                                      |    6 
 drivers/phy/socionext/phy-uniphier-usb3ss.c                          |   10 
 drivers/power/supply/bq25890_charger.c                               |    4 
 drivers/regulator/qcom_smd-regulator.c                               |  100 ++
 drivers/rpmsg/rpmsg_core.c                                           |   20 
 drivers/rtc/rtc-cmos.c                                               |    3 
 drivers/rtc/rtc-pxa.c                                                |    4 
 drivers/scsi/lpfc/lpfc.h                                             |    2 
 drivers/scsi/lpfc/lpfc_attr.c                                        |   62 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                                     |    8 
 drivers/scsi/lpfc/lpfc_sli.c                                         |    6 
 drivers/scsi/scsi_debugfs.c                                          |    1 
 drivers/scsi/sr.c                                                    |    2 
 drivers/scsi/sr_vendor.c                                             |    4 
 drivers/scsi/ufs/tc-dwc-g210-pci.c                                   |    1 
 drivers/scsi/ufs/ufshcd-pltfrm.c                                     |    2 
 drivers/scsi/ufs/ufshcd.c                                            |    7 
 drivers/soc/mediatek/mtk-scpsys.c                                    |   15 
 drivers/spi/spi-meson-spifc.c                                        |    1 
 drivers/staging/greybus/audio_topology.c                             |   15 
 drivers/staging/media/hantro/hantro_drv.c                            |    3 
 drivers/staging/rtl8192e/rtllib.h                                    |    2 
 drivers/staging/rtl8192e/rtllib_module.c                             |   16 
 drivers/staging/rtl8192e/rtllib_softmac.c                            |    6 
 drivers/tee/tee_core.c                                               |    4 
 drivers/tty/serial/amba-pl010.c                                      |    3 
 drivers/tty/serial/amba-pl011.c                                      |   27 
 drivers/tty/serial/atmel_serial.c                                    |   14 
 drivers/tty/serial/serial_core.c                                     |    7 
 drivers/tty/serial/uartlite.c                                        |    2 
 drivers/usb/core/hub.c                                               |    5 
 drivers/usb/gadget/function/f_fs.c                                   |    4 
 drivers/usb/host/uhci-platform.c                                     |    3 
 drivers/usb/misc/ftdi-elan.c                                         |    1 
 drivers/w1/slaves/w1_ds28e04.c                                       |   26 
 fs/btrfs/backref.c                                                   |   21 
 fs/btrfs/ctree.c                                                     |   19 
 fs/btrfs/inode.c                                                     |   11 
 fs/btrfs/qgroup.c                                                    |   19 
 fs/debugfs/file.c                                                    |    2 
 fs/dlm/lock.c                                                        |    9 
 fs/ext4/ioctl.c                                                      |    2 
 fs/ext4/mballoc.c                                                    |    8 
 fs/ext4/migrate.c                                                    |   23 
 fs/ext4/super.c                                                      |   25 
 fs/f2fs/f2fs.h                                                       |   11 
 fs/f2fs/gc.c                                                         |    3 
 fs/f2fs/segment.h                                                    |    3 
 fs/f2fs/super.c                                                      |   44 +
 fs/f2fs/sysfs.c                                                      |    4 
 fs/fuse/file.c                                                       |    2 
 fs/jffs2/file.c                                                      |   40 -
 fs/ubifs/super.c                                                     |    1 
 include/acpi/actypes.h                                               |   10 
 include/linux/hid.h                                                  |    2 
 include/linux/mmzone.h                                               |    9 
 include/net/inet_frag.h                                              |   11 
 include/net/ipv6_frag.h                                              |    3 
 include/net/sch_generic.h                                            |    5 
 kernel/audit.c                                                       |   18 
 kernel/rcu/tree_exp.h                                                |    1 
 kernel/sched/cputime.c                                               |    4 
 kernel/sched/rt.c                                                    |   23 
 kernel/trace/trace_kprobe.c                                          |    5 
 lib/test_meminit.c                                                   |    1 
 mm/page_alloc.c                                                      |   19 
 mm/shmem.c                                                           |   37 -
 net/batman-adv/netlink.c                                             |   30 
 net/bluetooth/cmtp/core.c                                            |    4 
 net/bluetooth/hci_core.c                                             |    1 
 net/bluetooth/hci_event.c                                            |    8 
 net/bridge/br_netfilter_hooks.c                                      |    7 
 net/core/filter.c                                                    |    8 
 net/core/net-sysfs.c                                                 |    3 
 net/core/net_namespace.c                                             |    4 
 net/ipv4/fib_semantics.c                                             |   36 -
 net/ipv4/inet_fragment.c                                             |    8 
 net/ipv4/ip_fragment.c                                               |    3 
 net/ipv4/ip_gre.c                                                    |    5 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                                   |    5 
 net/ipv6/ip6_gre.c                                                   |    5 
 net/mac80211/rx.c                                                    |    2 
 net/nfc/llcp_sock.c                                                  |    5 
 net/sched/sch_generic.c                                              |    1 
 net/unix/garbage.c                                                   |   14 
 net/unix/scm.c                                                       |    6 
 net/xfrm/xfrm_interface.c                                            |   14 
 net/xfrm/xfrm_policy.c                                               |   24 
 net/xfrm/xfrm_user.c                                                 |   23 
 scripts/dtc/dtx_diff                                                 |    8 
 security/selinux/hooks.c                                             |   12 
 sound/core/jack.c                                                    |    3 
 sound/core/oss/pcm_oss.c                                             |    2 
 sound/core/pcm.c                                                     |    6 
 sound/core/seq/seq_queue.c                                           |   14 
 sound/pci/hda/hda_codec.c                                            |    3 
 sound/soc/codecs/rt5663.c                                            |   12 
 sound/soc/mediatek/mt8173/mt8173-max98090.c                          |    3 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c                     |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                            |    2 
 sound/soc/samsung/idma.c                                             |    2 
 sound/soc/uniphier/Kconfig                                           |    2 
 tools/bpf/bpftool/Documentation/Makefile                             |    1 
 tools/bpf/bpftool/Makefile                                           |    1 
 tools/bpf/bpftool/main.c                                             |    2 
 tools/include/nolibc/nolibc.h                                        |   33 
 tools/perf/util/debug.c                                              |    2 
 310 files changed, 2394 insertions(+), 1012 deletions(-)

Adam Ford (1):
      clk: imx8mn: Fix imx8mn_clko1_sels

Adrian Hunter (1):
      perf script: Fix hex dump character output

Alexander Aring (1):
      fs: dlm: filter user dlm messages for kernel locks

Alexander Gordeev (1):
      s390/mm: fix 2KB pgtable release race

Alexander Stein (2):
      dt-bindings: display: meson-dw-hdmi: add missing sound-name-prefix property
      dt-bindings: display: meson-vpu: Add missing amlogic,canvas property

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST

Alistair Francis (1):
      HID: quirks: Allow inverting the absolute X/Y values

Amelie Delaunay (1):
      dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK

Ammar Faizi (1):
      tools/nolibc: x86-64: Fix startup code bug

Anders Roxell (1):
      powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Andre Przywara (1):
      ARM: 9159/1: decompressor: Avoid UNPREDICTABLE NOP encoding

Andrey Konovalov (1):
      lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Andrey Ryabinin (1):
      cputime, cpuacct: Include guest time in user time in cpuacct.stat

Antoine Tenart (1):
      net-sysfs: update the queue counts in the unregistration path

Anton Vasilyev (1):
      media: dw2102: Fix use after free

Antony Antony (2):
      xfrm: interface with if_id 0 should return error
      xfrm: state and policy should fail if XFRMA_IF_ID 0

Arnaud Pouliquen (1):
      rpmsg: core: Clean up resources on announce_create failure.

Arnd Bergmann (1):
      dmaengine: pxa/mmp: stop referencing config->slave_id

Avihai Horon (2):
      RDMA/core: Let ib_find_gid() continue search even after empty entry
      RDMA/cma: Let cma_resolve_ib_dev() continue search even after empty entry

Aya Levin (1):
      Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"

Baoquan He (2):
      mm_zone: add function to check if managed dma zone exists
      mm/page_alloc.c: do not warn allocation failure on zone DMA if no managed pages

Bart Van Assche (2):
      scsi: ufs: Fix race conditions related to driver data
      scsi: core: Show SCMD_LAST in text form

Baruch Siach (2):
      of: base: Fix phandle argument length mismatch error message
      of: base: Improve argument length mismatch error

Ben Hutchings (1):
      firmware: Update Kconfig help text for Google firmware

Ben Skeggs (1):
      drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

Bernard Zhao (1):
      selinux: fix potential memleak in selinux_add_opt()

Biwen Li (1):
      arm64: dts: ls1028a-qds: move rtc node to the correct i2c bus

Bixuan Cui (1):
      ALSA: oss: fix compile error when OSS_DEBUG is enabled

Borislav Petkov (3):
      x86/mce: Mark mce_panic() noinstr
      x86/mce: Mark mce_end() noinstr
      x86/mce: Mark mce_read_aux() noinstr

Brian Norris (7):
      drm/rockchip: dsi: Hold pm-runtime across bind/unbind
      drm/rockchip: dsi: Reconfigure hardware on resume()
      drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure
      drm/panel: innolux-p079zca: Delete panel on attach() failure
      drm/rockchip: dsi: Fix unbalanced clock on probe error
      mwifiex: Fix possible ABBA deadlock
      drm/bridge: analogix_dp: Make PSR-exit block less

Bryan O'Donoghue (2):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
      wcn36xx: Release DMA channel descriptor allocations

Chao Yu (2):
      f2fs: fix to do sanity check in is_alive()
      f2fs: fix to reserve space for IO align feature

Chen Jun (1):
      tpm: add request_locality before write TPM_INT_ENABLE

Chengfeng Ye (2):
      crypto: qce - fix uaf on qce_ahash_register_one
      HSI: core: Fix return freed object in hsi_new_client

Chengguang Xu (1):
      RDMA/rxe: Fix a typo in opcode name

Christian Eggers (1):
      mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings

Christian Hewitt (2):
      arm64: dts: meson-gxbb-wetek: fix HDMI in early boot
      arm64: dts: meson-gxbb-wetek: fix missing GPIO binding

Christian König (1):
      drm/radeon: fix error handling in radeon_driver_open_kms

Christian Lamparter (1):
      ARM: dts: gemini: NAS4220-B: fis-index-block with 128 KiB sectors

Christoph Hellwig (1):
      scsi: sr: Don't use GFP_DMA

Christophe JAILLET (1):
      media: venus: core: Fix a resource leak in the error handling path of 'venus_probe()'

Christophe Leroy (4):
      lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()
      powerpc/powermac: Add additional missing lockdep_register_key()
      powerpc/powermac: Add missing lockdep_register_key()
      w1: Misuse of get_user()/put_user() reported by sparse

Dafna Hirschfeld (1):
      media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Dan Carpenter (1):
      rocker: fix a sleeping in atomic bug

Daniel Thompson (1):
      Documentation: dmaengine: Correctly describe dmatest with channel unset

Danielle Ratson (1):
      mlxsw: pci: Add shutdown method in PCI driver

David Heidelberg (1):
      arm64: dts: qcom: msm8996: drop not documented adreno properties

Dillon Min (2):
      media: videobuf2: Fix the size printk format
      clk: stm32: Fix ltdc's clock turn off by clk_disable_unused() after system enter shell

Dinh Nguyen (1):
      EDAC/synopsys: Use the quirk for version instead of ddr version

Dmitry Baryshkov (2):
      arm64: dts: qcom: msm8916: fix MMC controller aliases
      drm/msm/dpu: fix safe status debugfs file

Dominik Brodowski (1):
      pcmcia: fix setting of kthread task states

Dongliang Mu (1):
      media: em28xx: fix memory leak in em28xx_init_dev

Doyle, Patrick (1):
      mtd: nand: bbt: Fix corner case in bad block table handling

Eric Dumazet (6):
      xfrm: fix a small bug in xfrm_sa_len()
      ppp: ensure minimum packet size in ppp_write()
      ipv4: avoid quadratic behavior in netns dismantle
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
      netns: add schedule point in ops_exit_list()

Fabio Estevam (1):
      media: imx-pxp: Initialize the spinlock prior to using it

Filipe Manana (2):
      btrfs: fix deadlock between quota enable and other quota operations
      btrfs: respect the max size in the header when activating swap file

Florian Fainelli (1):
      net: mdio: Demote probed message to debug print

Florian Westphal (1):
      netfilter: bridge: add support for pppoe filtering

Frederic Weisbecker (1):
      rcu/exp: Mark current CPU as exp-QS in IPI loop second pass

Gang Li (1):
      shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Ghalem Boudour (1):
      xfrm: fix policy lookup for ipv6 gre packets

Greg Kroah-Hartman (1):
      Linux 5.4.174

Guillaume Nault (3):
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
      gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
      libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

Hans Verkuil (1):
      media: v4l2-ioctl.c: readbuffers depends on V4L2_CAP_READWRITE

Hans de Goede (3):
      ACPI: scan: Create platform device for BCM4752 and LNV4752 ACPI nodes
      drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
      gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use

Hari Bathini (1):
      powerpc: handle kdump appropriately with crash_kexec_post_notifiers option

Hector Martin (1):
      iommu/io-pgtable-arm: Fix table descriptor paddr formatting

Heiner Kallweit (2):
      i2c: i801: Don't silently correct invalid transfer size
      crypto: omap-aes - Fix broken pm_runtime_and_get() usage

Ilan Peer (2):
      iwlwifi: mvm: Fix calculation of frame length
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Ilia Mirkin (1):
      drm/nouveau/kms/nv04: use vzalloc for nv04_display

Iwona Winiarska (1):
      gpio: aspeed: Convert aspeed_gpio.lock to raw_spinlock

James Hilliard (1):
      media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

James Smart (1):
      scsi: lpfc: Trigger SLI4 firmware dump before doing driver cleanup

Jammy Huang (2):
      media: aspeed: fix mode-detect always time out at 2nd run
      media: aspeed: Update signal status immediately to ensure sane hw state

Jan Kara (3):
      ext4: avoid trim error on fs with small groups
      ext4: make sure to reset inode lockdep class when quota enabling fails
      ext4: make sure quota gets properly shutdown on error

Jann Horn (1):
      HID: uhid: Fix worker destroying device without any protection

Jason A. Donenfeld (1):
      random: do not throw away excess input to crng_fast_load

Jason Gerecke (3):
      HID: wacom: Reset expected and received contact counts at the same time
      HID: wacom: Ignore the confidence flag when a touch is removed
      HID: wacom: Avoid using stale array indicies to read contact count

Jens Wiklander (1):
      tee: fix put order in teedev_close_context()

Jernej Skrabec (1):
      media: hantro: Fix probe func error path

Jiasheng Jiang (8):
      media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes
      staging: greybus: audio: Check null pointer
      fsl/fman: Check for null pointer after calling devm_ioremap
      Bluetooth: hci_bcm: Check for error irq
      can: xilinx_can: xcan_probe(): check for error irq
      ASoC: rt5663: Handle device_property_read_u32_array error codes
      ASoC: mediatek: Check for error clk pointer
      ASoC: samsung: idma: Check of ioremap return value

Joakim Tjernlund (1):
      i2c: mpc: Correct I2C reset procedure

Joe Thornber (2):
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joerg Roedel (1):
      x86/mm: Flush global TLB when switching to trampoline page-table

Johan Hovold (9):
      media: flexcop-usb: fix control-message timeouts
      media: mceusb: fix control-message timeouts
      media: em28xx: fix control-message timeouts
      media: cpia2: fix control-message timeouts
      media: s2255: fix control-message timeouts
      media: redrat3: fix control-message timeouts
      media: pvrusb2: fix control-message timeouts
      media: stk1160: fix control-message timeouts
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (3):
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: remove module loading failure message

John David Anglin (1):
      parisc: Avoid calling faulthandler_disabled() twice

Josef Bacik (3):
      btrfs: remove BUG_ON() in find_parent_nodes()
      btrfs: remove BUG_ON(!eie) in find_parent_nodes
      btrfs: check the root node for uptodate before returning it

José Expósito (5):
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_get_str_desc
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
      HID: hid-uclogic-params: Invalid parameter check in uclogic_params_frame_init_v1_buttonpad
      HID: apple: Do not reset quirks when the Fn key is not found

Julia Lawall (4):
      powerpc/6xx: add missing of_node_put
      powerpc/powernv: add missing of_node_put
      powerpc/cell: add missing of_node_put
      powerpc/btext: add missing of_node_put

Kai-Heng Feng (1):
      usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Kamal Heib (2):
      RDMA/hns: Validate the pkey index
      RDMA/cxgb4: Set queue pair state when being queried

Kees Cook (1):
      char/mwave: Adjust io port register size

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Kirill A. Shutemov (1):
      ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Konrad Dybcio (1):
      regulator: qcom_smd: Align probe function with rpmh-regulator

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Kuniyuki Iwashima (1):
      bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().

Kyeong Yoo (1):
      jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Lakshmi Sowjanya D (1):
      i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Laurence de Bruxelles (1):
      rtc: pxa: fix null pointer dereference

Li Hua (1):
      sched/rt: Try to restart rt period timer when rt runtime exceeded

Lino Sanfilippo (1):
      serial: amba-pl011: do not request memory region twice

Linus Lüssing (1):
      batman-adv: allow netlink usage in unprivileged containers

Lizhi Hou (1):
      tty: serial: uartlite: allow 64 bit address

Lucas De Marchi (1):
      x86/gpu: Reserve stolen memory for first integrated Intel GPU

Lucas Stach (1):
      drm/etnaviv: limit submit sizes

Lukas Bulwahn (2):
      ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA
      Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Lukas Wunner (3):
      serial: pl010: Drop CR register reset on set_termios
      serial: core: Keep mctrl register state and cached copy in sync
      serial: Fix incorrect rs485 polarity on uart open

Luís Henriques (1):
      ext4: set csum seed in tmp inode while migrating to extents

Maor Dickman (1):
      net/mlx5e: Don't block routes with nexthop objects in SW

Marc Kleine-Budde (1):
      can: softing: softing_startstop(): fix set but not used variable warning

Marek Behún (1):
      ARM: dts: armada-38x: Add generic compatible to UART nodes

Marek Vasut (1):
      crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Mark Langsdorf (1):
      ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Martin Blumenstingl (1):
      clk: meson: gxbb: Fix the SDM_EN bit for MPLL0 on GXBB

Martyn Welch (1):
      drm/bridge: megachips: Ensure both bridges are probed before registration

Masami Hiramatsu (1):
      Revert "ia64: kprobes: Use generic kretprobe trampoline handler"

Mateusz Jończyk (1):
      rtc: cmos: take rtc_lock while reading from CMOS

Matthias Schiffer (1):
      scripts/dtc: dtx_diff: remove broken example from help text

Mauro Carvalho Chehab (1):
      media: m920x: don't use stack on USB reads

Maxime Ripard (2):
      clk: bcm-2835: Pick the closest clock rate
      clk: bcm-2835: Remove rounding up the dividers

Meng Li (1):
      crypto: caam - replace this_cpu_ptr with raw_cpu_ptr

Miaoqian Lin (3):
      spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
      parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
      lib82596: Fix IRQ check in sni_82596_probe

Michael Ellerman (1):
      powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Michael Kuron (1):
      media: dib0700: fix undefined behavior in tuner shutdown

Michal Suchanek (1):
      debugfs: lockdown: Allow reading debugfs files that are not world readable

Moshe Shemesh (2):
      net/mlx5: Set command entry semaphore up once got index free
      Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Neal Liu (1):
      usb: uhci: add aspeed ast2600 uhci support

Nicholas Piggin (1):
      powerpc/watchdog: Fix missed watchdog reset due to memory ordering race

Nicolas Toromanoff (3):
      crypto: stm32/cryp - fix xts and race condition in crypto_engine requests
      crypto: stm32/cryp - fix double pm exit
      crypto: stm32/cryp - fix lrw chaining mode

Nishanth Menon (1):
      arm64: dts: ti: k3-j721e: Fix the L2 cache sets

Pali Rohár (3):
      PCI: pci-bridge-emul: Properly mark reserved PCIe bits in PCI config space
      PCI: pci-bridge-emul: Correctly set PCIe capabilities
      PCI: pci-bridge-emul: Set PCI_STATUS_CAP_LIST for PCIe device

Paolo Abeni (1):
      bpf: Do not WARN in bpf_warn_invalid_xdp_action()

Paul Chaignon (1):
      bpftool: Enable line buffering for stdout

Paul Moore (1):
      audit: ensure userspace is penalized the same as the kernel when under pressure

Pavankumar Kondeti (1):
      usb: gadget: f_fs: Use stream_open() for endpoint files

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peiwei Hu (1):
      powerpc/prom_init: Fix improper check of prom_getprop()

Peng Fan (1):
      arm64: dts: ti: k3-j721e: correct cache-sets info

Petr Cvachoucek (1):
      ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Ping-Ke Shih (1):
      mac80211: allow non-standard VHT MCS-10/11

Qiang Yu (1):
      drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y

Quentin Monnet (1):
      bpftool: Remove inclusion of utilities.mak from Makefiles

Rafael J. Wysocki (4):
      ACPI: EC: Rework flushing of EC work while suspended to idle
      cpufreq: Fix initialization of min and max frequency QoS requests
      ACPICA: Utilities: Avoid deleting the same object twice in a row
      ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Randy Dunlap (4):
      mips: lantiq: add support for clk_set_parent()
      mips: bcm63xx: add support for clk_set_parent()
      um: registers: Rename function names to avoid conflicts and build problems
      Documentation: fix firewire.rst ABI file path error

Robert Hancock (4):
      clk: si5341: Fix clock HW provider cleanup
      net: axienet: limit minimum TX ring size
      net: axienet: fix number of TX ring slots for available check
      net: axienet: increase default TX ring size to 128

Robert Schlabbach (1):
      media: si2157: Fix "warm" tuner state detection

Russell King (Oracle) (3):
      net: phy: prefer 1000baseT over 1000baseKX
      net: phy: marvell: configure RGMII delays for 88E1118
      net: gemini: allow any RGMII interface mode

Ryuta NAKANISHI (1):
      phy: uniphier-usb3ss: fix unintended writing zeros to PHY register

Sakari Ailus (1):
      Documentation: ACPI: Fix data node reference documentation

Sean Wang (1):
      Bluetooth: btmtksdio: fix resume failure

Sean Young (1):
      media: igorplugusb: receiver overflow should be reported

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

Sergey Shtylyov (2):
      mmc: meson-mx-sdio: add IRQ check
      bcmgenet: add WOL IRQ check

Stefan Riedmueller (1):
      mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6

Stephen Boyd (1):
      drm/bridge: ti-sn65dsi86: Set max register for regmap

Sudeep Holla (1):
      ACPICA: Fix wrong interpretation of PCC address

Suresh Kumar (1):
      net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Suresh Udipi (2):
      media: rcar-csi2: Correct the selection of hsfreqrange
      media: rcar-csi2: Optimize the selection PHTW register

Takashi Iwai (4):
      ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
      ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
      ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
      ALSA: seq: Set upper limit of processed events

Tasos Sahanidis (1):
      floppy: Fix hang in watchdog when disk is ejected

Theodore Ts'o (1):
      ext4: don't use the orphan list when migrating an inode

Thierry Reding (1):
      arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Thomas Gleixner (1):
      PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()

Thomas Hellström (1):
      dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()

Thomas Weißschuh (1):
      ACPI: battery: Add the ThinkPad "Not Charging" quirk

Tianjia Zhang (1):
      MIPS: Octeon: Fix build errors using clang

Tobias Waldekranz (2):
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Todd Kjos (1):
      binder: fix handling of error during copy

Tom Rix (1):
      net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()

Tudor Ambarus (7):
      tty: serial: atmel: Check return code of dmaengine_submit()
      tty: serial: atmel: Call dma_async_issue_pending()
      dmaengine: at_xdmac: Don't start transactions at tx_submit level
      dmaengine: at_xdmac: Print debug message after realeasing the lock
      dmaengine: at_xdmac: Fix concurrency over xfers_list
      dmaengine: at_xdmac: Fix lld view setting
      dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tzung-Bi Shih (1):
      ASoC: mediatek: mt8173: fix device_node leak

Ulf Hansson (1):
      mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Wan Jiabing (1):
      ARM: shmobile: rcar-gen2: Add missing of_node_put()

Wang Hai (3):
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
      media: dmxdev: fix UAF when dvb_register_device() fails
      media: msi001: fix possible null-ptr-deref in msi001_probe()

Wei Yongjun (3):
      usb: ftdi-elan: fix memory leak on device disconnect
      misc: lattice-ecp3-config: Fix task hung when firmware load failed
      Bluetooth: Fix debugfs entry leak in hci_register_dev()

Willy Tarreau (2):
      tools/nolibc: i386: fix initial stack alignment
      tools/nolibc: fix incorrect truncation of exit code

Xiangyang Zhang (1):
      tracing/kprobes: 'nmissed' not showed correctly for kretprobe

Xie Yongji (1):
      fuse: Pass correct lend value to filemap_write_and_wait_range()

Xin Xiong (1):
      netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Xiongfeng Wang (1):
      iommu/iova: Fix race between FQ timeout and teardown

Xiongwei Song (1):
      floppy: Add max size check for user space request

Yang Yingliang (3):
      media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()
      staging: rtl8192e: return error code from rtllib_softmac_init()
      staging: rtl8192e: rtllib_module: fix error handle case in alloc_rtllib()

Yauhen Kharuzhy (1):
      power: bq25890: Enable continuous conversion for ADC at charging

Ye Bin (1):
      ext4: Fix BUG_ON in ext4_bread when write quota data

Ye Guojin (1):
      MIPS: OCTEON: add put_device() after of_find_device_by_node()

Yifeng Li (1):
      PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Yixing Liu (1):
      RDMA/hns: Modify the mapping attribute of doorbell to device

Yunfei Wang (1):
      iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure

Zekun Shen (5):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      rsi: Fix use-after-free in rsi_rx_done_handler()
      rsi: Fix out-of-bounds read in rsi_read_pkt()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zhang Zixun (1):
      x86/mce/inject: Avoid out-of-bounds write when setting flags

Zheyu Ma (1):
      media: b2c2: Add missing check in flexcop_pci_isr:

Zhou Qingyang (8):
      drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
      drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()
      media: dib8000: Fix a memleak in dib8000_init()
      media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
      media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
      media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Zongmin Zhou (1):
      drm/amdgpu: fixup bad vram size on gmc v8

