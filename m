Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A48F454487
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 11:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhKQKEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 05:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235778AbhKQKET (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 05:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC10A61AED;
        Wed, 17 Nov 2021 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637143281;
        bh=2wjp7NrjXwAyaBCPYqPfiMbszLh8xbqBTj4+lypE3SY=;
        h=From:To:Cc:Subject:Date:From;
        b=xTE8ZsvDrQiNB/V2Xr8RipDuAJrKxiNJHPGMvc52arGHMJBh1K6w5VbTh/klCbC3u
         9y8AmYdHgZPZDKcsAeCeagX8r7vj9Ac0H2IERz0bOLxKHyw5E+8xuvAXgqTzDZvQ6o
         NyQGzEelyRb1VflJ/bstS0dRibiMNLGXzE5Gz1Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.160
Date:   Wed, 17 Nov 2021 11:01:17 +0100
Message-Id: <163714327763204@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.160 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                 |    7 
 Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt |   23 -
 Makefile                                                        |    2 
 arch/arm/Makefile                                               |   22 -
 arch/arm/boot/dts/at91-tse850-3.dts                             |    2 
 arch/arm/boot/dts/omap3-gta04.dtsi                              |    2 
 arch/arm/boot/dts/qcom-msm8974.dtsi                             |    4 
 arch/arm/boot/dts/stm32mp157c.dtsi                              |   16 -
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts                 |    2 
 arch/arm/kernel/stacktrace.c                                    |    3 
 arch/arm/mm/Kconfig                                             |    2 
 arch/arm/mm/mmu.c                                               |    4 
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts               |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts                 |    2 
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts              |    2 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                        |    2 
 arch/arm64/include/asm/pgtable.h                                |   12 
 arch/arm64/net/bpf_jit_comp.c                                   |    5 
 arch/ia64/Kconfig.debug                                         |    2 
 arch/ia64/kernel/kprobes.c                                      |    9 
 arch/m68k/Kconfig.machine                                       |    1 
 arch/mips/Kconfig                                               |    1 
 arch/mips/include/asm/mips-cm.h                                 |   12 
 arch/mips/kernel/mips-cm.c                                      |   21 -
 arch/mips/kernel/r2300_fpu.S                                    |    4 
 arch/mips/kernel/syscall.c                                      |    9 
 arch/mips/lantiq/xway/dma.c                                     |   14 -
 arch/parisc/kernel/entry.S                                      |    2 
 arch/parisc/kernel/smp.c                                        |   19 +
 arch/parisc/kernel/unwind.c                                     |   21 +
 arch/parisc/kernel/vmlinux.lds.S                                |    3 
 arch/parisc/mm/fixmap.c                                         |    5 
 arch/parisc/mm/init.c                                           |    4 
 arch/powerpc/include/asm/code-patching.h                        |    1 
 arch/powerpc/include/asm/security_features.h                    |    5 
 arch/powerpc/kernel/security.c                                  |    5 
 arch/powerpc/lib/code-patching.c                                |    7 
 arch/powerpc/net/bpf_jit.h                                      |   33 +-
 arch/powerpc/net/bpf_jit64.h                                    |    8 
 arch/powerpc/net/bpf_jit_comp64.c                               |   91 +++++--
 arch/powerpc/platforms/44x/fsp2.c                               |    2 
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c                    |    3 
 arch/powerpc/platforms/powernv/opal-prd.c                       |   12 
 arch/s390/kvm/priv.c                                            |    2 
 arch/s390/mm/gmap.c                                             |    5 
 arch/sh/kernel/cpu/fpu.c                                        |   10 
 arch/x86/hyperv/hv_init.c                                       |    5 
 arch/x86/include/asm/page_64_types.h                            |    2 
 arch/x86/kernel/cpu/amd.c                                       |    2 
 arch/x86/kernel/cpu/common.c                                    |   44 ++-
 arch/x86/kernel/cpu/cpu.h                                       |    1 
 arch/x86/kernel/cpu/hygon.c                                     |    2 
 arch/x86/kernel/irq.c                                           |    4 
 arch/x86/kvm/vmx/vmx.c                                          |    8 
 arch/x86/mm/mem_encrypt_identity.c                              |    9 
 block/blk-mq.c                                                  |    1 
 crypto/Kconfig                                                  |    2 
 crypto/pcrypt.c                                                 |   12 
 drivers/acpi/acpica/acglobal.h                                  |    2 
 drivers/acpi/acpica/hwesleep.c                                  |    8 
 drivers/acpi/acpica/hwsleep.c                                   |   11 
 drivers/acpi/acpica/hwxfsleep.c                                 |    7 
 drivers/acpi/battery.c                                          |    2 
 drivers/acpi/pmic/intel_pmic.c                                  |   51 ++-
 drivers/android/binder.c                                        |   22 +
 drivers/ata/libata-core.c                                       |    2 
 drivers/ata/libata-eh.c                                         |    8 
 drivers/auxdisplay/ht16k33.c                                    |   66 ++---
 drivers/auxdisplay/img-ascii-lcd.c                              |   10 
 drivers/block/ataflop.c                                         |   18 -
 drivers/block/zram/zram_drv.c                                   |    2 
 drivers/bluetooth/btmtkuart.c                                   |   13 -
 drivers/char/hw_random/mtk-rng.c                                |    9 
 drivers/char/ipmi/ipmi_msghandler.c                             |   10 
 drivers/char/ipmi/ipmi_watchdog.c                               |   17 -
 drivers/char/tpm/tpm2-space.c                                   |    3 
 drivers/clk/at91/pmc.c                                          |    5 
 drivers/clk/mvebu/ap-cpu-clk.c                                  |   14 -
 drivers/clocksource/Kconfig                                     |    1 
 drivers/cpuidle/sysfs.c                                         |    5 
 drivers/crypto/caam/caampkc.c                                   |   19 +
 drivers/crypto/caam/regs.h                                      |    3 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c                   |   13 +
 drivers/crypto/qat/qat_common/adf_vf_isr.c                      |    6 
 drivers/crypto/s5p-sss.c                                        |    2 
 drivers/dma-buf/dma-buf.c                                       |    1 
 drivers/dma/at_xdmac.c                                          |    2 
 drivers/dma/dmaengine.h                                         |    2 
 drivers/edac/amd64_edac.c                                       |   22 +
 drivers/edac/sb_edac.c                                          |    2 
 drivers/firmware/psci/psci_checker.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c                     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h                     |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c                           |    4 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                  |   47 +++
 drivers/gpu/drm/drm_plane_helper.c                              |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c                     |    8 
 drivers/gpu/drm/msm/msm_gem.c                                   |    4 
 drivers/gpu/drm/v3d/v3d_gem.c                                   |    4 
 drivers/gpu/drm/virtio/virtgpu_vq.c                             |    8 
 drivers/hid/hid-u2fzero.c                                       |   10 
 drivers/hv/hyperv_vmbus.h                                       |    1 
 drivers/hwmon/hwmon.c                                           |    6 
 drivers/hwmon/pmbus/lm25066.c                                   |   25 +
 drivers/i2c/busses/i2c-xlr.c                                    |    6 
 drivers/iio/dac/ad5446.c                                        |    9 
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                        |    3 
 drivers/infiniband/hw/mlx4/qp.c                                 |    4 
 drivers/infiniband/hw/qedr/verbs.c                              |   15 -
 drivers/infiniband/sw/rxe/rxe_param.h                           |    2 
 drivers/input/joystick/iforce/iforce-usb.c                      |    2 
 drivers/input/mouse/elantech.c                                  |   13 +
 drivers/input/serio/i8042-x86ia64io.h                           |   14 +
 drivers/irqchip/irq-bcm6345-l1.c                                |    2 
 drivers/irqchip/irq-s3c24xx.c                                   |   22 +
 drivers/irqchip/irq-sifive-plic.c                               |    8 
 drivers/media/dvb-frontends/mn88443x.c                          |   18 +
 drivers/media/i2c/ir-kbd-i2c.c                                  |    1 
 drivers/media/i2c/mt9p031.c                                     |   28 ++
 drivers/media/i2c/tda1997x.c                                    |    8 
 drivers/media/pci/cx23885/cx23885-alsa.c                        |    3 
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c              |   27 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c                        |    5 
 drivers/media/platform/rcar-vin/rcar-csi2.c                     |    2 
 drivers/media/platform/s5p-mfc/s5p_mfc.c                        |    6 
 drivers/media/platform/stm32/stm32-dcmi.c                       |   19 -
 drivers/media/radio/radio-wl1273.c                              |    2 
 drivers/media/radio/si470x/radio-si470x-i2c.c                   |    2 
 drivers/media/radio/si470x/radio-si470x-usb.c                   |    2 
 drivers/media/rc/ite-cir.c                                      |    2 
 drivers/media/rc/mceusb.c                                       |    1 
 drivers/media/spi/cxd2880-spi.c                                 |    2 
 drivers/media/usb/dvb-usb/az6027.c                              |    1 
 drivers/media/usb/dvb-usb/dibusb-common.c                       |    2 
 drivers/media/usb/em28xx/em28xx-cards.c                         |    5 
 drivers/media/usb/em28xx/em28xx-core.c                          |    5 
 drivers/media/usb/tm6000/tm6000-video.c                         |    3 
 drivers/media/usb/uvc/uvc_driver.c                              |    7 
 drivers/media/usb/uvc/uvc_v4l2.c                                |    7 
 drivers/media/usb/uvc/uvc_video.c                               |    5 
 drivers/media/v4l2-core/v4l2-ioctl.c                            |   60 +++-
 drivers/memory/fsl_ifc.c                                        |   13 -
 drivers/memstick/core/ms_block.c                                |    2 
 drivers/memstick/host/jmb38x_ms.c                               |    2 
 drivers/memstick/host/r592.c                                    |    8 
 drivers/mmc/host/Kconfig                                        |    2 
 drivers/mmc/host/dw_mmc.c                                       |    3 
 drivers/mmc/host/mxs-mmc.c                                      |   10 
 drivers/mmc/host/sdhci-omap.c                                   |    3 
 drivers/mtd/mtdcore.c                                           |    4 
 drivers/mtd/spi-nor/hisi-sfc.c                                  |    1 
 drivers/net/bonding/bond_sysfs_slave.c                          |   36 --
 drivers/net/dsa/rtl8366rb.c                                     |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                     |    8 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c                     |   20 +
 drivers/net/ethernet/cavium/thunder/nic_main.c                  |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c                |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c              |    7 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                      |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c          |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c           |    9 
 drivers/net/ethernet/ibm/ibmvnic.c                              |    5 
 drivers/net/ethernet/netronome/nfp/bpf/main.c                   |   16 -
 drivers/net/ethernet/netronome/nfp/bpf/main.h                   |    2 
 drivers/net/ethernet/netronome/nfp/bpf/offload.c                |   17 +
 drivers/net/ethernet/realtek/r8169_main.c                       |    1 
 drivers/net/ethernet/sfc/ptp.c                                  |    4 
 drivers/net/ethernet/sfc/siena_sriov.c                          |    2 
 drivers/net/ethernet/ti/davinci_emac.c                          |   16 +
 drivers/net/phy/micrel.c                                        |    5 
 drivers/net/phy/phylink.c                                       |    2 
 drivers/net/vmxnet3/vmxnet3_drv.c                               |    1 
 drivers/net/vrf.c                                               |   28 +-
 drivers/net/wireless/ath/ath10k/mac.c                           |   45 ++-
 drivers/net/wireless/ath/ath10k/usb.c                           |    7 
 drivers/net/wireless/ath/ath10k/wmi.c                           |    4 
 drivers/net/wireless/ath/ath10k/wmi.h                           |    3 
 drivers/net/wireless/ath/ath6kl/usb.c                           |    7 
 drivers/net/wireless/ath/ath9k/main.c                           |    4 
 drivers/net/wireless/ath/dfs_pattern_detector.c                 |   10 
 drivers/net/wireless/ath/wcn36xx/dxe.c                          |   12 
 drivers/net/wireless/ath/wcn36xx/main.c                         |    4 
 drivers/net/wireless/ath/wcn36xx/smd.c                          |   44 ++-
 drivers/net/wireless/broadcom/b43/phy_g.c                       |    2 
 drivers/net/wireless/broadcom/b43legacy/radio.c                 |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c          |   10 
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                  |    3 
 drivers/net/wireless/marvell/libertas/if_usb.c                  |    2 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c               |    2 
 drivers/net/wireless/marvell/mwifiex/11n.c                      |    5 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                 |   32 --
 drivers/net/wireless/marvell/mwifiex/pcie.c                     |    8 
 drivers/net/wireless/marvell/mwifiex/usb.c                      |   16 +
 drivers/net/wireless/marvell/mwl8k.c                            |    2 
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c                |   13 -
 drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c          |   14 -
 drivers/net/wireless/rsi/rsi_91x_core.c                         |    2 
 drivers/net/wireless/rsi/rsi_91x_hal.c                          |   10 
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                     |   74 +----
 drivers/net/wireless/rsi/rsi_91x_main.c                         |   17 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                         |   24 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c                         |    5 
 drivers/net/wireless/rsi/rsi_91x_usb.c                          |    5 
 drivers/net/wireless/rsi/rsi_hal.h                              |   11 
 drivers/net/wireless/rsi/rsi_main.h                             |   15 -
 drivers/net/xen-netfront.c                                      |    8 
 drivers/nfc/pn533/pn533.c                                       |    6 
 drivers/nvme/host/multipath.c                                   |    9 
 drivers/nvme/host/rdma.c                                        |    2 
 drivers/nvme/target/configfs.c                                  |    2 
 drivers/nvme/target/tcp.c                                       |   21 +
 drivers/opp/of.c                                                |    2 
 drivers/pci/controller/pci-aardvark.c                           |  129 ++++++++--
 drivers/pci/pci-bridge-emul.c                                   |   13 +
 drivers/pci/quirks.c                                            |    1 
 drivers/phy/qualcomm/phy-qcom-qusb2.c                           |   16 -
 drivers/pinctrl/core.c                                          |    2 
 drivers/platform/x86/thinkpad_acpi.c                            |    2 
 drivers/platform/x86/wmi.c                                      |    9 
 drivers/power/supply/bq27xxx_battery_i2c.c                      |    3 
 drivers/power/supply/max17042_battery.c                         |    8 
 drivers/power/supply/rt5033_battery.c                           |    2 
 drivers/regulator/s5m8767.c                                     |   21 -
 drivers/reset/reset-socfpga.c                                   |   26 ++
 drivers/s390/char/tape_std.c                                    |    3 
 drivers/s390/cio/css.c                                          |    4 
 drivers/s390/cio/device_ops.c                                   |   12 
 drivers/scsi/csiostor/csio_lnode.c                              |    2 
 drivers/scsi/dc395x.c                                           |    1 
 drivers/scsi/qla2xxx/qla_attr.c                                 |   24 +
 drivers/scsi/qla2xxx/qla_gbl.h                                  |    2 
 drivers/scsi/qla2xxx/qla_init.c                                 |    4 
 drivers/scsi/qla2xxx/qla_mr.c                                   |   23 -
 drivers/scsi/qla2xxx/qla_os.c                                   |   37 --
 drivers/scsi/qla2xxx/qla_target.c                               |   14 -
 drivers/soc/fsl/dpaa2-console.c                                 |    1 
 drivers/soc/tegra/pmc.c                                         |    2 
 drivers/spi/spi-bcm-qspi.c                                      |    5 
 drivers/spi/spi-pl022.c                                         |    5 
 drivers/staging/ks7010/Kconfig                                  |    3 
 drivers/staging/media/imx/imx-media-dev-common.c                |    2 
 drivers/staging/media/ipu3/ipu3-v4l2.c                          |    7 
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c               |    3 
 drivers/tty/serial/8250/8250_dw.c                               |    2 
 drivers/tty/serial/serial_core.c                                |   16 +
 drivers/tty/serial/xilinx_uartps.c                              |    3 
 drivers/usb/chipidea/core.c                                     |   23 +
 drivers/usb/gadget/legacy/hid.c                                 |    4 
 drivers/usb/host/xhci-hub.c                                     |    3 
 drivers/usb/host/xhci-pci.c                                     |   16 +
 drivers/usb/misc/iowarrior.c                                    |    8 
 drivers/usb/serial/keyspan.c                                    |   15 -
 drivers/video/backlight/backlight.c                             |    6 
 drivers/video/fbdev/chipsfb.c                                   |    2 
 drivers/watchdog/Kconfig                                        |    2 
 drivers/watchdog/f71808e_wdt.c                                  |    4 
 drivers/watchdog/omap_wdt.c                                     |    6 
 drivers/xen/balloon.c                                           |   86 ++++--
 drivers/xen/xen-pciback/conf_space_capability.c                 |    2 
 fs/btrfs/disk-io.c                                              |    3 
 fs/btrfs/tree-log.c                                             |    4 
 fs/btrfs/volumes.c                                              |   14 -
 fs/f2fs/inode.c                                                 |    2 
 fs/f2fs/namei.c                                                 |    2 
 fs/fuse/dev.c                                                   |   14 -
 fs/jfs/jfs_mount.c                                              |   51 +--
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                       |    4 
 fs/nfs/nfs4proc.c                                               |   15 -
 fs/nfs/pnfs_nfs.c                                               |    4 
 fs/nfs/write.c                                                  |   17 -
 fs/ocfs2/file.c                                                 |    8 
 fs/orangefs/dcache.c                                            |    4 
 fs/overlayfs/file.c                                             |   47 +++
 fs/quota/quota_tree.c                                           |   15 +
 fs/tracefs/inode.c                                              |    3 
 include/linux/console.h                                         |    2 
 include/linux/filter.h                                          |    1 
 include/linux/libata.h                                          |    2 
 include/linux/lsm_hooks.h                                       |   28 +-
 include/linux/rpmsg.h                                           |    2 
 include/linux/sched/task_stack.h                                |    4 
 include/linux/security.h                                        |   33 +-
 include/net/llc.h                                               |    4 
 include/net/neighbour.h                                         |   12 
 include/net/sch_generic.h                                       |    4 
 include/net/strparser.h                                         |   16 +
 include/net/udp.h                                               |    5 
 include/uapi/linux/pci_regs.h                                   |    6 
 kernel/bpf/core.c                                               |    4 
 kernel/cgroup/cgroup.c                                          |   31 ++
 kernel/kprobes.c                                                |    3 
 kernel/locking/lockdep.c                                        |    2 
 kernel/power/swap.c                                             |    7 
 kernel/rcu/tree_exp.h                                           |    2 
 kernel/signal.c                                                 |   18 -
 kernel/trace/tracing_map.c                                      |   40 +--
 kernel/workqueue.c                                              |   15 -
 lib/decompress_unxz.c                                           |    2 
 lib/iov_iter.c                                                  |    5 
 lib/xz/xz_dec_lzma2.c                                           |   21 +
 lib/xz/xz_dec_stream.c                                          |    6 
 mm/oom_kill.c                                                   |   23 -
 mm/zsmalloc.c                                                   |    7 
 net/8021q/vlan.c                                                |    3 
 net/8021q/vlan_dev.c                                            |    3 
 net/9p/client.c                                                 |    2 
 net/bluetooth/l2cap_sock.c                                      |   10 
 net/bluetooth/sco.c                                             |   33 +-
 net/can/j1939/main.c                                            |    7 
 net/can/j1939/transport.c                                       |    6 
 net/core/dev.c                                                  |    5 
 net/core/filter.c                                               |   21 +
 net/core/neighbour.c                                            |   48 ++-
 net/core/net-sysfs.c                                            |   55 ++++
 net/core/net_namespace.c                                        |    4 
 net/core/stream.c                                               |    3 
 net/core/sysctl_net_core.c                                      |    2 
 net/ipv4/tcp.c                                                  |    2 
 net/ipv6/addrconf.c                                             |    3 
 net/ipv6/udp.c                                                  |    2 
 net/netfilter/nf_conntrack_proto_udp.c                          |    7 
 net/netfilter/nfnetlink_queue.c                                 |    2 
 net/netfilter/nft_dynset.c                                      |   11 
 net/rxrpc/rtt.c                                                 |    2 
 net/sched/sch_generic.c                                         |    9 
 net/sched/sch_mq.c                                              |   24 +
 net/sched/sch_mqprio.c                                          |   23 +
 net/sched/sch_taprio.c                                          |   27 +-
 net/smc/af_smc.c                                                |   20 -
 net/strparser/strparser.c                                       |   10 
 net/sunrpc/xprt.c                                               |   28 +-
 net/vmw_vsock/af_vsock.c                                        |    2 
 samples/kprobes/kretprobe_example.c                             |    2 
 scripts/leaking_addresses.pl                                    |    3 
 security/apparmor/label.c                                       |    4 
 security/integrity/evm/evm_main.c                               |    2 
 security/security.c                                             |   14 -
 security/selinux/hooks.c                                        |   36 +-
 security/smack/smackfs.c                                        |   11 
 sound/core/oss/mixer_oss.c                                      |   43 ++-
 sound/core/timer.c                                              |   17 -
 sound/pci/hda/hda_intel.c                                       |   28 +-
 sound/pci/hda/patch_realtek.c                                   |    4 
 sound/soc/codecs/cs42l42.c                                      |    9 
 sound/synth/emux/emux.c                                         |    2 
 sound/usb/6fire/comm.c                                          |    2 
 sound/usb/6fire/firmware.c                                      |    6 
 sound/usb/line6/driver.c                                        |   14 -
 sound/usb/line6/driver.h                                        |    2 
 sound/usb/line6/podhd.c                                         |    6 
 sound/usb/line6/toneport.c                                      |    2 
 sound/usb/misc/ua101.c                                          |    4 
 sound/usb/quirks.c                                              |    1 
 tools/lib/bpf/btf.c                                             |   16 -
 tools/perf/util/bpf-event.c                                     |    4 
 tools/testing/selftests/bpf/progs/strobemeta.h                  |    4 
 tools/testing/selftests/bpf/test_progs.c                        |    4 
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c          |    2 
 tools/testing/selftests/net/udpgso_bench_rx.c                   |   11 
 359 files changed, 2538 insertions(+), 1210 deletions(-)

Ahmad Fatoum (1):
      watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Ajay Singh (1):
      wilc1000: fix possible memory leak in cfg_scan_result()

Alagu Sankar (1):
      ath10k: high latency fixes for beacon buffer

Aleksander Jan Bajkowski (2):
      MIPS: lantiq: dma: add small delay after reset
      MIPS: lantiq: dma: reset correct number of channel

Alex Bee (1):
      arm64: dts: rockchip: Fix GPU register width for RK3328

Alex Deucher (1):
      drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits

Alex Xu (Hello71) (1):
      drm/plane-helper: fix uninitialized variable reference

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 400

Alok Prasad (1):
      RDMA/qedr: Fix NULL deref for query_qp on the GSI QP

Amit Engel (1):
      nvmet-tcp: fix header digest verification

Anand Jain (1):
      btrfs: call btrfs_check_rw_degradable only if there is a missing device

Anand Moon (1):
      arm64: dts: meson-g12a: Fix the pwm regulator supply properties

Anant Thazhemadam (1):
      media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Anders Roxell (1):
      PM: hibernate: fix sparse warnings

Andrea Righi (1):
      selftests/bpf: Fix fclose/pclose mismatch in test_progs

Andreas Gruenbacher (1):
      iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value

Andreas Kemnade (1):
      arm: dts: omap3-gta04a4: accelerometer irq fix

Andrej Shadura (2):
      HID: u2fzero: clarify error check and length calculations
      HID: u2fzero: properly handle timeouts in usb_submit_urb

Andrii Nakryiko (3):
      selftests/bpf: Fix strobemeta selftest regression
      libbpf: Fix BTF data layout checks and allow empty BTF
      selftests/bpf: Fix also no-alu32 strobemeta selftest

André Almeida (1):
      ACPI: battery: Accept charges over the design capacity as full

Andy Shevchenko (1):
      serial: 8250_dw: Drop wrong use of ACPI_PTR()

Anel Orazgaliyeva (1):
      cpuidle: Fix kobject memory leaks in error paths

Anssi Hannula (1):
      serial: xilinx_uartps: Fix race condition causing stuck TX

Antoine Tenart (1):
      net-sysfs: try not to restart the syscall if it will fail eventually

Arnaud Pouliquen (1):
      rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined

Arnd Bergmann (8):
      hyperv/vmbus: include linux/bitops.h
      ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
      drm/amdgpu: fix warning for overflow check
      crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
      memstick: avoid out-of-range warning
      arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
      ARM: 9156/1: drop cc-option fallbacks for architecture selection
      ath10k: fix invalid dma_addr_t token assignment

Arun Easi (1):
      scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file

Austin Kim (2):
      ALSA: synth: missing check for possible NULL after the call to kstrdup
      evm: mark evm_fixmode as __ro_after_init

Baptiste Lepers (1):
      pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds

Barnabás Pőcze (1):
      platform/x86: wmi: do not fail if disabling fails

Bastien Roucariès (1):
      ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode

Benjamin Li (2):
      wcn36xx: handle connection loss indication
      wcn36xx: add proper DMA memory barriers in rx path

Bixuan Cui (1):
      powerpc/44x/fsp2: add missing of_node_put

Bryant Mairs (1):
      drm: panel-orientation-quirks: Add quirk for Aya Neo 2021

Charan Teja Reddy (1):
      dma-buf: WARN on dmabuf release with pending attachments

Chengfeng Ye (1):
      nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Christian Löhle (1):
      mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Christophe JAILLET (5):
      media: mtk-vpu: Fix a resource leak in the error handling path of 'mtk_vpu_probe()'
      mmc: mxs-mmc: disable regulator on error and in the remove function
      clk: mvebu: ap-cpu-clk: Fix a memory leak in error handling paths
      soc/tegra: Fix an error handling path in tegra_powergate_power_up()
      i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_probe()'

Christophe Leroy (1):
      video: fbdev: chipsfb: use memset_io() instead of memset()

Claudiu Beznea (1):
      dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Clément Léger (1):
      clk: at91: check pmc node status before registering syscore ops

Colin Ian King (3):
      media: cxd2880-spi: Fix a null pointer dereference on error handling path
      media: cx23885: Fix snd_card_free call on null card pointer
      media: em28xx: Don't use ops->suspend if it is NULL

Corey Minyard (1):
      ipmi: Disable some operations during a panic

Cyril Strejc (1):
      net: multicast: calculate csum of looped-back and forwarded packets

Damien Le Moal (1):
      libata: fix read log timeout value

Dan Carpenter (8):
      tpm: Check for integer overflow in tpm2_map_response_body()
      b43legacy: fix a lower bounds test
      b43: fix a lower bounds test
      memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
      drm/msm: uninitialized variable in msm_gem_import()
      usb: gadget: hid: fix error code in do_config()
      scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
      zram: off by one in read_block_state()

Daniel Borkmann (2):
      net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
      net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE

Daniel Jordan (1):
      crypto: pcrypt - Delay write to padata->info

David Hildenbrand (1):
      s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()

Desmond Cheong Zhi Xi (1):
      Bluetooth: fix init and cleanup of sco_conn.timeout_work

Dinghao Liu (1):
      Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Dirk Bender (1):
      media: mt9p031: Fix corrupted frame after restarting stream

Dmitriy Ulitin (1):
      media: stm32: Potential NULL pointer dereference in dcmi_irq_thread()

Dmitry Bogdanov (1):
      scsi: qla2xxx: Fix unmap of already freed sgl

Dominique Martinet (1):
      9p/net: fix missing error check in p9_check_errors

Dongli Zhang (2):
      xen/netfront: stop tx queues during live migration
      vmxnet3: do not stop tx queues after netif_device_detach()

Dongliang Mu (2):
      JFS: fix memleak in jfs_mount
      memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Dust Li (1):
      net/smc: fix sk_refcnt underflow on linkdown and fallback

Eiichi Tsukata (1):
      vsock: prevent unnecessary refcnt inc for nonblocking connect

Eric Badger (1):
      EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Eric Dumazet (3):
      net: annotate data-race in neigh_output()
      llc: fix out-of-bound array index in llc_sk_dev_hash()
      net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any

Eric W. Biederman (3):
      signal: Remove the bogus sigkill_pending in ptrace_stop
      signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT
      signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)

Erik Ekman (1):
      sfc: Don't use netif_info before net_device setup

Evgeny Novikov (2):
      media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()
      mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()

Filipe Manana (1):
      btrfs: fix lost error handling when replaying directory deletes

Florian Westphal (2):
      vrf: run conntrack only in context of lower/physdev for locally generated packets
      netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Geert Uytterhoeven (4):
      mips: cm: Convert to bitfield API to fix out-of-bounds access
      auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string
      auxdisplay: ht16k33: Connect backlight to fbdev
      auxdisplay: ht16k33: Fix frame buffer device blanking

Giovanni Cabiddu (2):
      crypto: qat - detect PFVF collision after ACK
      crypto: qat - disregard spurious PFVF interrupts

Greg Kroah-Hartman (1):
      Linux 5.4.160

Guangbin Huang (1):
      net: hns3: allow configure ETS bandwidth of all TCs

Guo Ren (1):
      irqchip/sifive-plic: Fixup EOI failed when masked

Halil Pasic (1):
      s390/cio: make ccw_device_dma_* more robust

Hannes Reinecke (1):
      nvme: drop scan_lock and always kick requeue list when removing namespaces

Hans de Goede (6):
      drm: panel-orientation-quirks: Update the Lenovo Ideapad D330 quirk (v2)
      drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
      drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6
      brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet
      power: supply: bq27xxx: Fix kernel crash on IRQ handler register error
      ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses

Helge Deller (4):
      parisc: Fix ptrace check on syscall return
      task_stack: Fix end_of_stack() for architectures with upwards-growing stack
      parisc: Fix backtrace to always include init funtion names
      parisc: Fix set_fixmap() on PA1.x CPUs

Henrik Grimler (1):
      power: supply: max17042_battery: use VFSOC for capacity when no rsns

Huang Guobin (1):
      bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Iago Toral Quiroga (1):
      drm/v3d: fix wait for TMU write combiner flush

Ian Rogers (1):
      perf bpf: Add missing free to bpf_event__print_bpf_prog_info()

Ingmar Klein (1):
      PCI: Mark Atheros QCA6174 to avoid bus reset

Israel Rukshin (2):
      nvmet: fix use-after-free when a port is removed
      nvmet-tcp: fix use-after-free when a port is removed

Jackie Liu (3):
      ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()
      MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT
      ar7: fix kernel builds for compiler test

Jaegeuk Kim (1):
      f2fs: should use GFP_NOFS for directory inodes

Jakob Hauser (1):
      power: supply: rt5033_battery: Change voltage values to µV

Jakub Kicinski (3):
      net: sched: update default qdisc visibility after Tx queue cnt changes
      net: stream: don't purge sk_error_queue in sk_stream_kill_queues()
      udp6: allow SO_MARK ctrl msg to affect routing

Jan Kara (1):
      ocfs2: fix data corruption on truncate

Jane Malalane (1):
      x86/cpu: Fix migration safety with X86_BUG_NULL_SEL

Janghyub Seo (1):
      r8169: Add device 10ec:8162 to driver r8169

Janis Schoetterl-Glausch (1):
      KVM: s390: Fix handle_sske page fault handling

Jaroslav Kysela (1):
      ALSA: hda/realtek: Add a quirk for Acer Spin SP513-54N

Jens Axboe (1):
      block: remove inaccurate requeue check

Jessica Zhang (1):
      drm/msm: Fix potential NULL dereference in DPU SSPP

Jia-Ju Bai (1):
      fs: orangefs: fix error return code of orangefs_revalidate_lookup()

Jiasheng Jiang (1):
      rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()

Johan Hovold (12):
      Input: iforce - fix control-message timeout
      ALSA: ua101: fix division by zero at probe
      ALSA: 6fire: fix control and bulk message timeouts
      ALSA: line6: fix control and interrupt message timeouts
      mwifiex: fix division by zero in fw download path
      ath6kl: fix division by zero in send path
      ath6kl: fix control-message timeout
      ath10k: fix control-message timeout
      ath10k: fix division by zero in send path
      rtl8187: fix control-message timeouts
      USB: iowarrior: fix control-message timeouts
      USB: chipidea: fix interrupt deadlock

Johannes Berg (1):
      iwlwifi: mvm: disable RX-diversity in powersave

John Fastabend (1):
      bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

Jon Maxwell (1):
      tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()

Jonas Dreßler (4):
      mwifiex: Read a PCI register after writing the TX ring write pointer
      mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
      mwifiex: Properly initialize private structure on interface type changes
      mwifiex: Send DELBA requests according to spec

Josef Bacik (1):
      btrfs: do not take the uuid_mutex in btrfs_rm_device

Juergen Gross (1):
      xen/balloon: add late_initcall_sync() for initial ballooning done

Junji Wei (1):
      RDMA/rxe: Fix wrong port_cap_flags

Kai-Heng Feng (1):
      ALSA: hda/realtek: Add quirk for HP EliteBook 840 G7 mute LED

Kalesh Singh (1):
      tracing/cfi: Fix cmp_entries_* functions signature mismatch

Kees Cook (5):
      leaking_addresses: Always print a trailing newline
      media: radio-wl1273: Avoid card name truncation
      media: si470x: Avoid card name truncation
      media: tm6000: Avoid card name truncation
      clocksource/drivers/timer-ti-dm: Select TIMER_OF

Krzysztof Kozlowski (2):
      regulator: s5m8767: do not use reset value as DVS voltage if GPIO DVS is disabled
      regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property

Lars-Peter Clausen (1):
      dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`

Lasse Collin (2):
      lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression
      lib/xz: Validate the value before assigning it to an enum variable

Leon Romanovsky (1):
      RDMA/mlx4: Return missed an error if device doesn't support steering

Li Zhang (1):
      btrfs: clear MISSING device status bit in btrfs_close_one_device

Linus Lüssing (1):
      ath9k: Fix potential interrupt storm on queue reset

Linus Walleij (1):
      net: dsa: rtl8366rb: Fix off-by-one bug

Loic Poulain (2):
      wcn36xx: Fix HT40 capability for 2Ghz band
      ath10k: Fix missing frame timestamp for beacon/probe-resp

Lorenz Bauer (2):
      bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
      bpf: Prevent increasing bpf_jit_limit above max

Lorenzo Bianconi (1):
      mt76: mt76x02: fix endianness warnings in mt76x02_mac.c

Marek Behún (4):
      PCI: pci-bridge-emul: Fix emulation of W1C bits
      PCI: aardvark: Fix return value of MSI domain .alloc() method
      PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG
      PCI: aardvark: Don't spam about PIO Response Status

Marek Vasut (2):
      rsi: Fix module dev_oper_mode parameter description
      video: backlight: Drop maximum brightness override for brightness zero

Marijn Suijten (1):
      ARM: dts: qcom: msm8974: Add xo_board reference clock to DSI0 PHY

Mario (1):
      drm: panel-orientation-quirks: Add quirk for GPD Win3

Mark Rutland (1):
      irq: mips: avoid nested irq_enter()

Markus Schneider-Pargmann (1):
      hwrng: mtk - Force runtime pm ops for sleep ops

Martin Fuzzey (3):
      rsi: fix occasional initialisation failure with BT coex
      rsi: fix key enabled check causing unwanted encryption for vap_id > 0
      rsi: fix rate mask set leading to P2P failure

Martin Kepplinger (1):
      media: imx: set a media_device bus_info string

Masami Hiramatsu (2):
      ia64: kprobes: Fix to pass correct trampoline address to the handler
      ARM: clang: Do not rely on lr register for stacktrace

Mathias Nyman (1):
      xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay

Maurizio Lombardi (1):
      nvmet-tcp: fix a memory leak when releasing a queue

Max Gurtovoy (1):
      nvme-rdma: fix error code in nvme_rdma_setup_ctrl

Maxim Kiselev (1):
      net: davinci_emac: Fix interrupt pacing disable

Menglong Dong (1):
      workqueue: make sysfs of unbound kworker cpumask more clever

Miaohe Lin (1):
      mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Michael Schmitz (1):
      block: ataflop: fix breakage introduced at blk-mq refactoring

Michael Walle (1):
      crypto: caam - disable pkc for non-E SoCs

Michal Hocko (1):
      mm, oom: do not trigger out_of_memory from the #PF

Michał Mirosław (1):
      ARM: 9155/1: fix early early_iounmap()

Miklos Szeredi (2):
      fuse: fix page stealing
      ovl: fix deadlock in splice write

Nadezda Lutovinova (2):
      media: s5p-mfc: Add checking to s5p_mfc_probe().
      media: rcar-csi2: Add checking to rcsi2_start_receiver()

Nathan Chancellor (1):
      platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Naveen N. Rao (5):
      powerpc/lib: Add helper to check if offset is within conditional branch range
      powerpc/bpf: Validate branch ranges
      powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
      powerpc/security: Add a helper to query stf_barrier type
      powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

Neeraj Upadhyay (1):
      rcu: Fix existing exp request check in sync_sched_exp_online_cleanup()

Nehal Bakulchandra Shah (1):
      usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

Olivier Moysan (1):
      ARM: dts: stm32: fix SAI sub nodes register range

Pablo Neira Ayuso (2):
      netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
      netfilter: nft_dynset: relax superfluous check on set updates

Pali Rohár (7):
      serial: core: Fix initializing and restoring termios speed
      PCI: aardvark: Do not clear status bits of masked interrupts
      PCI: aardvark: Fix checking for link up via LTSSM state
      PCI: aardvark: Do not unmask unused interrupts
      PCI: aardvark: Fix reporting Data Link Layer Link Active
      PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated bridge
      PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Pavel Skripkin (3):
      ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
      media: em28xx: add missing em28xx_close_extension
      media: dvb-usb: fix ununit-value in az6027_rc_query

Pawan Gupta (1):
      smackfs: Fix use-after-free in netlbl_catmap_walk()

Paweł Anikiel (1):
      reset: socfpga: add empty driver allowing consumers to probe

Pekka Korpinen (1):
      iio: dac: ad5446: Fix ad5622_write() return value

Peter Rosin (1):
      ARM: dts: at91: tse850: the emac<->phy interface is rmii

Peter Zijlstra (2):
      locking/lockdep: Avoid RCU-induced noinstr fail
      x86: Increase exception stack sizes

Phoenix Huang (1):
      Input: elantench - fix misreporting trackpoint coordinates

Punit Agrawal (1):
      kprobes: Do not use local variable when creating debugfs file

Quinn Tran (3):
      scsi: qla2xxx: Fix use after free in eh_abort path
      scsi: qla2xxx: Fix gnl list corruption
      scsi: qla2xxx: Turn off target reset during issue_lip

Rafael J. Wysocki (1):
      ACPICA: Avoid evaluating methods too early during system resume

Rahul Lakkireddy (1):
      cxgb4: fix eeprom len when diagnostics not implemented

Rajat Asthana (1):
      media: mceusb: return without resubmitting URB in case of -EPROTO error.

Randy Dunlap (3):
      mmc: winbond: don't build on M68K
      ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
      m68k: set a default value for MEMORY_RESERVE

Reimar Döffinger (1):
      libata: fix checking of DMA state

Ricardo Ribalda (6):
      media: v4l2-ioctl: Fix check_ext_ctrls
      media: uvcvideo: Set capability in s_param
      media: uvcvideo: Return -EIO for control errors
      media: uvcvideo: Set unique vdev name based in type
      media: ipu3-imgu: imgu_fmt: Handle properly try
      media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info

Richard Fitzgerald (2):
      ASoC: cs42l42: Correct some register default values
      ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER

Robert-Ionut Alexa (1):
      soc: fsl: dpaa2-console: free buffer before returning from dpaa2_console_read

Russell King (Oracle) (1):
      net: phylink: avoid mvneta warning when setting pause parameters

Sean Christopherson (2):
      x86/irq: Ensure PI wakeup handler is unregistered before module unload
      KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use

Sean Young (2):
      media: ite-cir: IR receiver stop working after receive overflow
      media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Selvin Xavier (1):
      RDMA/bnxt_re: Fix query SRQ failure

Shuah Khan (1):
      selftests: kvm: fix mismatched fclose() after popen()

Shyam Sundar S K (1):
      net: amd-xgbe: Toggle PLL settings during rate change

Simon Ser (1):
      drm/panel-orientation-quirks: add Valve Steam Deck

Stefan Agner (1):
      phy: micrel: ksz8041nl: do not use power down mode

Stephen Suryaputra (1):
      gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Steven Rostedt (VMware) (1):
      tracefs: Have tracefs directories not set OTH permission bits by default

Sukadev Bhattiprolu (2):
      ibmvnic: don't stop queue in xmit
      ibmvnic: Process crqs after enabling interrupts

Sven Eckelmann (1):
      ath10k: fix max antenna gain unit

Sven Schnelle (4):
      parisc: fix warning in flush_tlb_all
      parisc/unwind: fix unwinder when CONFIG_64BIT is enabled
      parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
      s390/tape: fix timer initialization in tape_std_assign()

Takashi Iwai (6):
      Input: i8042 - Add quirk for Fujitsu Lifebook T725
      ALSA: hda/realtek: Add quirk for ASUS UX550VE
      ALSA: timer: Unconditionally unlink slave instances, too
      ALSA: mixer: oss: Fix racy access to slots
      Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
      ALSA: hda: Reduce udelay() at SKL+ position reporting

Tang Bin (1):
      crypto: s5p-sss - Add error handling in s5p_aes_probe()

Tetsuo Handa (2):
      smackfs: use __GFP_NOFAIL for smk_cipso_doi()
      smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Thomas Perrot (1):
      spi: spl022: fix Microwire full duplex mode

Tiezhu Yang (1):
      samples/kretprobes: Fix return value if register_kretprobe() failed

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PC70HS

Todd Kjos (3):
      binder: use euid from cred instead of using task
      binder: use cred instead of task for selinux checks
      binder: use cred instead of task for getsecid

Tom Lendacky (1):
      x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c

Tom Rix (2):
      media: TDA1997x: handle short reads of hdmi info frame.
      apparmor: fix error check

Tong Zhang (1):
      scsi: dc395: Fix error case unwinding

Tony Lindgren (1):
      mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured

Trond Myklebust (3):
      NFS: Fix deadlocks in nfs_scan_commit_list()
      NFSv4: Fix a regression in nfs_set_open_stateid_locked()
      SUNRPC: Partial revert of commit 6f9f17287e78

Tuo Li (2):
      media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
      ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Vasant Hegde (1):
      powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module unload

Vasily Averin (1):
      mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Vegard Nossum (1):
      staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC

Vineeth Vijayan (1):
      s390/cio: check the subchannel validity for dev_busid

Vitaly Kuznetsov (1):
      x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted

Vladimir Zapolskiy (1):
      phy: qcom-qusb2: Fix a memory leak on probe

Waiman Long (1):
      cgroup: Make rebind_subsystems() disable v2 controllers all at once

Walter Stoll (1):
      watchdog: Fix OMAP watchdog early handling

Wang Hai (3):
      USB: serial: keyspan: fix memleak on probe errors
      libertas_tf: Fix possible memory leak in probe and disconnect
      libertas: Fix possible memory leak in probe and disconnect

Wang ShaoBo (1):
      Bluetooth: fix use-after-free error in lock_sock_nested()

Wang Wensheng (1):
      ALSA: timer: Fix use-after-free problem

Wen Gu (1):
      net/smc: Correct spelling mistake to TCPF_SYN_RECV

Willem de Bruijn (1):
      selftests/net: udpgso_bench_rx: fix port argument

Xiaoming Ni (1):
      powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found

Yajun Deng (1):
      net: net_namespace: Fix undefined member in key_remove_domain()

Yang Yingliang (3):
      pinctrl: core: fix possible memory leak in pinctrl_enable()
      spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
      hwmon: Fix possible memleak in __hwmon_device_register()

Yazen Ghannam (1):
      EDAC/amd64: Handle three rank interleaving mode

Ye Bin (1):
      PM: hibernate: Get block device exclusively in swsusp_check()

Yu Xiao (1):
      nfp: bpf: relax prog rejection for mtu check through max_pkt_offset

YueHaibing (2):
      opp: Fix return in _opp_add_static_v2()
      xen-pciback: Fix return in pm_ctrl_init()

Zev Weiss (3):
      hwmon: (pmbus/lm25066) Add offset coefficients
      hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff
      mtd: core: don't remove debugfs directory if device is in use

Zhang Changzhong (2):
      can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
      can: j1939: j1939_can_recv(): ignore messages with invalid source address

Zhang Yi (2):
      quota: check block number when reading the block in quota file
      quota: correct error number in free_dqentry()

Zheyu Ma (6):
      cavium: Return negative value when pci_alloc_irq_vectors() fails
      scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
      cavium: Fix return values of the probe function
      media: netup_unidvb: handle interrupt properly according to the firmware
      memstick: r592: Fix a UAF bug when removing the driver
      mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ziyang Xuan (2):
      rsi: stop thread firstly in rsi_91x_init() error handling
      net: vlan: fix a UAF in vlan_dev_real_dev()

jing yangyang (1):
      firmware/psci: fix application of sizeof to pointer

liuyuntao (1):
      virtio-gpu: fix possible memory allocation failure

