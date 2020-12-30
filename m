Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1397E2E781D
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgL3Leh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 06:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3Leg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 06:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E574E20715;
        Wed, 30 Dec 2020 11:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609328034;
        bh=BkmPreYfu1bfmXT2juukCS1218s4B9BX1F6Jyva30UQ=;
        h=From:To:Cc:Subject:Date:From;
        b=svqSS9+mZB5ckRMFuW8emGuq92YSX59WwIBay8+06inMFu3+9CCK/9zeb3ZMS5sE/
         oCOhnoAg1yuZew1jPYcsVgPqLmJ06oJ2SEVdYuFdTOEf8jGuGxmb9GOZ7zYZnQYhBo
         Fx/MBhIpRZLGAw2uaLLIsbWstM/VSXsTajkFGuY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.164
Date:   Wed, 30 Dec 2020 12:35:19 +0100
Message-Id: <16093281191712@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.164 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt       |    1 
 Makefile                                              |    5 
 arch/arc/kernel/stacktrace.c                          |   23 ++-
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi             |    5 
 arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dts        |    4 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts           |    7 +
 arch/arm/boot/dts/at91-sama5d4_xplained.dts           |    7 +
 arch/arm/boot/dts/at91sam9rl.dtsi                     |   19 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts             |    6 
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi             |   28 ++++
 arch/arm/boot/dts/exynos5410.dtsi                     |    4 
 arch/arm/boot/dts/omap4-panda-es.dts                  |    2 
 arch/arm/boot/dts/sama5d2.dtsi                        |    7 -
 arch/arm/boot/dts/sun8i-v3s.dtsi                      |    2 
 arch/arm/kernel/head.S                                |    6 
 arch/arm/mach-shmobile/pm-rmobile.c                   |    1 
 arch/arm/mach-sunxi/sunxi.c                           |    1 
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts |    2 
 arch/arm64/boot/dts/exynos/exynos7.dtsi               |   12 -
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts        |    1 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi              |   16 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi              |    3 
 arch/arm64/include/asm/atomic_lse.h                   |   76 ++++++++--
 arch/arm64/include/asm/kvm_host.h                     |    1 
 arch/arm64/include/asm/lse.h                          |    6 
 arch/arm64/kernel/syscall.c                           |    2 
 arch/arm64/kvm/sys_regs.c                             |    1 
 arch/arm64/lib/memcpy.S                               |    3 
 arch/arm64/lib/memmove.S                              |    3 
 arch/arm64/lib/memset.S                               |    3 
 arch/mips/bcm47xx/Kconfig                             |    1 
 arch/powerpc/Makefile                                 |    1 
 arch/powerpc/include/asm/book3s/32/pgtable.h          |    4 
 arch/powerpc/include/asm/cputable.h                   |    5 
 arch/powerpc/include/asm/nohash/pgtable.h             |    4 
 arch/powerpc/kernel/head_64.S                         |    8 -
 arch/powerpc/kernel/rtas.c                            |    2 
 arch/powerpc/kernel/setup-common.c                    |    4 
 arch/powerpc/perf/core-book3s.c                       |   10 +
 arch/powerpc/platforms/powernv/memtrace.c             |   44 +++++-
 arch/powerpc/platforms/pseries/suspend.c              |    4 
 arch/powerpc/xmon/nonstdio.c                          |    2 
 arch/s390/kernel/smp.c                                |   18 --
 arch/s390/purgatory/head.S                            |    9 -
 arch/um/drivers/chan_user.c                           |    4 
 arch/um/drivers/xterm.c                               |    5 
 arch/um/os-Linux/irq.c                                |    2 
 arch/x86/include/asm/apic.h                           |    1 
 arch/x86/include/asm/pgtable_types.h                  |    1 
 arch/x86/include/asm/sync_core.h                      |    9 -
 arch/x86/kernel/apic/apic.c                           |   14 +-
 arch/x86/kernel/apic/vector.c                         |   24 ++-
 arch/x86/kernel/apic/x2apic_phys.c                    |    9 +
 arch/x86/kernel/cpu/intel_rdt.h                       |    2 
 arch/x86/kernel/cpu/intel_rdt_monitor.c               |    7 -
 arch/x86/kernel/kprobes/core.c                        |    5 
 arch/x86/lib/memcpy_64.S                              |    6 
 arch/x86/lib/memmove_64.S                             |    4 
 arch/x86/lib/memset_64.S                              |    6 
 arch/x86/mm/ident_map.c                               |   12 +
 arch/x86/mm/mem_encrypt_identity.c                    |    4 
 arch/x86/mm/tlb.c                                     |   10 +
 block/blk-mq.c                                        |   29 ++--
 crypto/af_alg.c                                       |   10 +
 crypto/ecdh.c                                         |    9 -
 drivers/acpi/acpi_pnp.c                               |    3 
 drivers/acpi/device_pm.c                              |   41 +----
 drivers/acpi/resource.c                               |    2 
 drivers/block/xen-blkback/xenbus.c                    |    4 
 drivers/bluetooth/hci_h5.c                            |    3 
 drivers/bus/fsl-mc/fsl-mc-allocator.c                 |    4 
 drivers/bus/mips_cdmm.c                               |    4 
 drivers/clk/clk-s2mps11.c                             |    1 
 drivers/clk/mvebu/armada-37xx-xtal.c                  |    4 
 drivers/clk/renesas/r9a06g032-clocks.c                |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                 |    1 
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                   |    1 
 drivers/clk/tegra/clk-id.h                            |    1 
 drivers/clk/tegra/clk-tegra-periph.c                  |    2 
 drivers/clk/ti/fapll.c                                |   11 +
 drivers/clocksource/arm_arch_timer.c                  |   23 ++-
 drivers/clocksource/cadence_ttc_timer.c               |   18 +-
 drivers/cpufreq/highbank-cpufreq.c                    |    7 +
 drivers/cpufreq/loongson1-cpufreq.c                   |    1 
 drivers/cpufreq/mediatek-cpufreq.c                    |    1 
 drivers/cpufreq/scpi-cpufreq.c                        |    1 
 drivers/cpufreq/sti-cpufreq.c                         |    7 +
 drivers/crypto/amcc/crypto4xx_core.c                  |    2 
 drivers/crypto/inside-secure/safexcel.c               |    2 
 drivers/crypto/omap-aes.c                             |    3 
 drivers/crypto/qat/qat_common/qat_hal.c               |    2 
 drivers/crypto/talitos.c                              |   10 -
 drivers/dma/mv_xor_v2.c                               |    4 
 drivers/edac/amd64_edac.c                             |   26 ++-
 drivers/extcon/extcon-max77693.c                      |    2 
 drivers/gpio/gpio-eic-sprd.c                          |    2 
 drivers/gpio/gpio-mvebu.c                             |   16 +-
 drivers/gpu/drm/drm_dp_aux_dev.c                      |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    7 -
 drivers/gpu/drm/gma500/cdv_intel_dp.c                 |    2 
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c            |    8 +
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c              |    1 
 drivers/gpu/drm/tegra/drm.c                           |    2 
 drivers/gpu/drm/tegra/sor.c                           |   10 +
 drivers/gpu/drm/tve200/tve200_drv.c                   |    4 
 drivers/gpu/drm/xen/xen_drm_front.c                   |    2 
 drivers/gpu/drm/xen/xen_drm_front_gem.c               |    8 -
 drivers/gpu/drm/xen/xen_drm_front_kms.c               |    2 
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c              |    8 +
 drivers/hsi/controllers/omap_ssi_core.c               |    2 
 drivers/hwtracing/coresight/coresight-tmc-etr.c       |    2 
 drivers/iio/adc/rockchip_saradc.c                     |    2 
 drivers/iio/imu/bmi160/bmi160_core.c                  |    4 
 drivers/iio/industrialio-buffer.c                     |    6 
 drivers/iio/light/rpr0521.c                           |   17 +-
 drivers/iio/light/st_uvis25.h                         |    5 
 drivers/iio/light/st_uvis25_core.c                    |    8 -
 drivers/iio/pressure/mpl3115.c                        |    9 +
 drivers/infiniband/core/cm.c                          |    2 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c              |    1 
 drivers/infiniband/hw/cxgb4/cq.c                      |    3 
 drivers/infiniband/hw/mthca/mthca_cq.c                |    2 
 drivers/infiniband/hw/mthca/mthca_dev.h               |    1 
 drivers/infiniband/sw/rxe/rxe_req.c                   |    3 
 drivers/input/keyboard/cros_ec_keyb.c                 |    1 
 drivers/input/keyboard/omap4-keypad.c                 |   89 +++++++-----
 drivers/input/misc/cm109.c                            |    7 -
 drivers/input/mouse/cyapa_gen6.c                      |    2 
 drivers/input/serio/i8042-x86ia64io.h                 |   42 ++++++
 drivers/input/touchscreen/ads7846.c                   |   52 ++++---
 drivers/input/touchscreen/goodix.c                    |   12 +
 drivers/irqchip/irq-alpine-msi.c                      |    3 
 drivers/irqchip/irq-gic-v3-its.c                      |   16 --
 drivers/md/dm-ioctl.c                                 |    1 
 drivers/md/dm-table.c                                 |    6 
 drivers/md/md-cluster.c                               |   67 +++++----
 drivers/md/md.c                                       |   21 ++-
 drivers/media/common/siano/smsdvb-main.c              |    5 
 drivers/media/i2c/max2175.c                           |    2 
 drivers/media/pci/intel/ipu3/ipu3-cio2.c              |   62 ++++----
 drivers/media/pci/intel/ipu3/ipu3-cio2.h              |    1 
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c     |    5 
 drivers/media/pci/saa7146/mxb.c                       |   19 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c            |    2 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c |    1 
 drivers/media/rc/sunxi-cir.c                          |    2 
 drivers/media/usb/gspca/gspca.c                       |    1 
 drivers/media/usb/msi2500/msi2500.c                   |    2 
 drivers/media/usb/tm6000/tm6000-video.c               |    5 
 drivers/memstick/core/memstick.c                      |    1 
 drivers/memstick/host/r592.c                          |   12 +
 drivers/mmc/core/block.c                              |    2 
 drivers/mtd/cmdlinepart.c                             |   14 +-
 drivers/mtd/nand/raw/qcom_nandc.c                     |    2 
 drivers/mtd/nand/spi/core.c                           |    4 
 drivers/net/can/softing/softing_main.c                |    9 +
 drivers/net/ethernet/allwinner/sun4i-emac.c           |    7 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |   24 ++-
 drivers/net/ethernet/korina.c                         |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c        |   21 ++-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c            |   40 ++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h          |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c        |    6 
 drivers/net/ethernet/microchip/lan743x_ethtool.c      |    9 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c   |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |   27 +++
 drivers/net/vxlan.c                                   |    3 
 drivers/net/wireless/ath/ath10k/usb.c                 |    7 -
 drivers/net/wireless/ath/ath10k/wmi-tlv.c             |    4 
 drivers/net/wireless/ath/ath10k/wmi.c                 |    9 +
 drivers/net/wireless/ath/ath10k/wmi.h                 |    1 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   36 +++--
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c   |   14 +-
 drivers/net/wireless/marvell/mwifiex/main.c           |    2 
 drivers/net/wireless/st/cw1200/main.c                 |    2 
 drivers/net/xen-netback/xenbus.c                      |    6 
 drivers/nfc/s3fwrn5/firmware.c                        |    4 
 drivers/nvdimm/label.c                                |   13 +
 drivers/pci/controller/dwc/pcie-qcom.c                |   12 +
 drivers/pci/controller/pcie-iproc.c                   |   10 -
 drivers/pci/pci-acpi.c                                |    4 
 drivers/pci/pci.c                                     |   14 +-
 drivers/pci/slot.c                                    |    6 
 drivers/pinctrl/intel/pinctrl-baytrail.c              |    8 +
 drivers/pinctrl/intel/pinctrl-merrifield.c            |    8 +
 drivers/pinctrl/pinctrl-amd.c                         |    7 -
 drivers/pinctrl/pinctrl-falcon.c                      |   14 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                 |    6 
 drivers/platform/x86/acer-wmi.c                       |    1 
 drivers/platform/x86/dell-smbios-base.c               |    1 
 drivers/platform/x86/intel-vbtn.c                     |   12 +
 drivers/platform/x86/mlx-platform.c                   |   27 +--
 drivers/platform/x86/thinkpad_acpi.c                  |   10 +
 drivers/power/supply/axp288_charger.c                 |   28 ++--
 drivers/power/supply/bq24190_charger.c                |   20 ++
 drivers/ps3/ps3stor_lib.c                             |    2 
 drivers/pwm/pwm-lp3943.c                              |    1 
 drivers/pwm/pwm-zx.c                                  |    1 
 drivers/s390/block/dasd_alias.c                       |   22 ++-
 drivers/scsi/be2iscsi/be_main.c                       |    4 
 drivers/scsi/bnx2i/Kconfig                            |    1 
 drivers/scsi/fnic/fnic_main.c                         |    1 
 drivers/scsi/lpfc/lpfc_mem.c                          |    6 
 drivers/scsi/lpfc/lpfc_sli.c                          |   10 +
 drivers/scsi/megaraid/megaraid_sas_base.c             |   16 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                   |    2 
 drivers/scsi/pm8001/pm8001_init.c                     |    3 
 drivers/scsi/qedi/qedi_main.c                         |    4 
 drivers/scsi/scsi_lib.c                               |  126 ++++++++++++------
 drivers/scsi/ufs/ufshcd.c                             |    7 +
 drivers/slimbus/qcom-ngd-ctrl.c                       |    6 
 drivers/soc/fsl/dpio/dpio-driver.c                    |    5 
 drivers/soc/mediatek/mtk-scpsys.c                     |    5 
 drivers/soc/qcom/qcom-geni-se.c                       |   17 ++
 drivers/soc/qcom/smp2p.c                              |    5 
 drivers/soc/tegra/fuse/speedo-tegra210.c              |    2 
 drivers/soc/ti/knav_dma.c                             |   13 +
 drivers/soc/ti/knav_qmss_queue.c                      |    4 
 drivers/spi/spi-bcm2835aux.c                          |   17 --
 drivers/spi/spi-bcm63xx-hsspi.c                       |    4 
 drivers/spi/spi-davinci.c                             |    2 
 drivers/spi/spi-img-spfi.c                            |    4 
 drivers/spi/spi-mxs.c                                 |    1 
 drivers/spi/spi-pic32.c                               |    1 
 drivers/spi/spi-rb4xx.c                               |    2 
 drivers/spi/spi-sc18is602.c                           |   13 -
 drivers/spi/spi-sh.c                                  |   13 -
 drivers/spi/spi-st-ssc4.c                             |    5 
 drivers/spi/spi-tegra114.c                            |    2 
 drivers/spi/spi-tegra20-sflash.c                      |    1 
 drivers/spi/spi-tegra20-slink.c                       |    2 
 drivers/spi/spi-ti-qspi.c                             |    1 
 drivers/spi/spi.c                                     |   19 +-
 drivers/staging/comedi/drivers/mf6x4.c                |    3 
 drivers/staging/gasket/gasket_interrupt.c             |   15 +-
 drivers/staging/greybus/audio_codec.c                 |    2 
 drivers/staging/mt7621-spi/spi-mt7621.c               |    2 
 drivers/staging/speakup/speakup_dectlk.c              |    2 
 drivers/tty/serial/8250/8250_omap.c                   |    5 
 drivers/tty/serial/serial_core.c                      |    4 
 drivers/usb/chipidea/ci_hdrc_imx.c                    |    3 
 drivers/usb/core/quirks.c                             |    3 
 drivers/usb/gadget/function/f_acm.c                   |    2 
 drivers/usb/gadget/function/f_fs.c                    |    5 
 drivers/usb/gadget/function/f_midi.c                  |    6 
 drivers/usb/gadget/function/f_rndis.c                 |    4 
 drivers/usb/gadget/udc/dummy_hcd.c                    |    2 
 drivers/usb/host/ehci-omap.c                          |    1 
 drivers/usb/host/max3421-hcd.c                        |    3 
 drivers/usb/host/oxu210hp-hcd.c                       |    4 
 drivers/usb/host/xhci-hub.c                           |    4 
 drivers/usb/misc/sisusbvga/Kconfig                    |    2 
 drivers/usb/serial/digi_acceleport.c                  |   45 +-----
 drivers/usb/serial/keyspan_pda.c                      |   63 ++++-----
 drivers/usb/serial/mos7720.c                          |    2 
 drivers/usb/serial/option.c                           |   23 +++
 drivers/usb/storage/uas.c                             |    3 
 drivers/usb/storage/unusual_uas.h                     |    7 -
 drivers/usb/storage/usb.c                             |    3 
 drivers/vfio/pci/vfio_pci.c                           |    4 
 drivers/video/fbdev/atmel_lcdfb.c                     |    2 
 drivers/watchdog/Kconfig                              |    3 
 drivers/watchdog/qcom-wdt.c                           |    2 
 drivers/watchdog/sprd_wdt.c                           |   34 ++--
 drivers/watchdog/watchdog_core.c                      |   22 +--
 drivers/xen/xen-pciback/xenbus.c                      |    2 
 drivers/xen/xenbus/xenbus.h                           |    2 
 drivers/xen/xenbus/xenbus_client.c                    |    8 +
 drivers/xen/xenbus/xenbus_probe.c                     |    1 
 drivers/xen/xenbus/xenbus_probe_backend.c             |    7 +
 drivers/xen/xenbus/xenbus_xs.c                        |   34 +++-
 fs/ceph/caps.c                                        |   11 +
 fs/cifs/smb2ops.c                                     |    3 
 fs/cifs/smb2pdu.c                                     |    7 -
 fs/cifs/smb2pdu.h                                     |   14 +-
 fs/ext4/inode.c                                       |   19 ++
 fs/ext4/mballoc.c                                     |    1 
 fs/jffs2/readinode.c                                  |   16 ++
 fs/jfs/jfs_dmap.h                                     |    2 
 fs/lockd/host.c                                       |   20 +-
 fs/nfs/inode.c                                        |    2 
 fs/nfs/nfs4proc.c                                     |   10 +
 fs/nfs_common/grace.c                                 |    6 
 fs/nfsd/nfssvc.c                                      |    3 
 fs/quota/quota_v2.c                                   |   19 ++
 fs/ubifs/io.c                                         |   13 +
 include/acpi/acpi_bus.h                               |    5 
 include/linux/build_bug.h                             |    5 
 include/linux/compiler-clang.h                        |    1 
 include/linux/compiler-gcc.h                          |   19 --
 include/linux/compiler.h                              |   18 ++
 include/linux/netfilter/x_tables.h                    |    5 
 include/linux/security.h                              |    2 
 include/linux/seq_buf.h                               |    2 
 include/linux/sunrpc/xprt.h                           |    1 
 include/linux/trace_seq.h                             |    4 
 include/linux/usb_usual.h                             |    2 
 include/uapi/linux/if_alg.h                           |   16 ++
 include/xen/xenbus.h                                  |   15 ++
 kernel/cpu.c                                          |    6 
 kernel/irq/irqdomain.c                                |   11 +
 kernel/sched/core.c                                   |    6 
 kernel/sched/deadline.c                               |    5 
 kernel/sched/sched.h                                  |   42 ++----
 net/bluetooth/hci_event.c                             |   17 +-
 net/bridge/br_vlan.c                                  |    4 
 net/core/lwt_bpf.c                                    |    8 -
 net/ipv4/netfilter/arp_tables.c                       |   14 +-
 net/ipv4/netfilter/ip_tables.c                        |   14 +-
 net/ipv4/tcp_input.c                                  |    3 
 net/ipv4/tcp_output.c                                 |    9 -
 net/ipv6/netfilter/ip6_tables.c                       |   14 +-
 net/mac80211/mesh_pathtbl.c                           |    4 
 net/mac80211/vht.c                                    |   14 +-
 net/netfilter/x_tables.c                              |   49 ++-----
 net/sunrpc/xprt.c                                     |   65 +++++++--
 net/sunrpc/xprtrdma/module.c                          |    1 
 net/sunrpc/xprtrdma/transport.c                       |    1 
 net/sunrpc/xprtsock.c                                 |    4 
 net/wireless/nl80211.c                                |    2 
 net/xdp/xsk.c                                         |    8 -
 samples/bpf/lwt_len_hist.sh                           |    2 
 scripts/checkpatch.pl                                 |    2 
 scripts/kconfig/preprocess.c                          |    2 
 security/integrity/ima/ima_crypto.c                   |   20 --
 security/selinux/hooks.c                              |   16 +-
 sound/core/oss/pcm_oss.c                              |   28 ++--
 sound/pci/hda/hda_codec.c                             |    2 
 sound/pci/hda/hda_sysfs.c                             |    2 
 sound/pci/hda/patch_ca0132.c                          |    2 
 sound/pci/hda/patch_realtek.c                         |    4 
 sound/soc/codecs/wm8997.c                             |    2 
 sound/soc/codecs/wm8998.c                             |    4 
 sound/soc/codecs/wm_adsp.c                            |    5 
 sound/soc/jz4740/jz4740-i2s.c                         |    4 
 sound/soc/meson/Kconfig                               |    2 
 sound/soc/soc-pcm.c                                   |    2 
 sound/usb/clock.c                                     |    6 
 sound/usb/format.c                                    |    2 
 sound/usb/quirks.c                                    |    1 
 sound/usb/stream.c                                    |    6 
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c       |    8 -
 tools/perf/util/cs-etm.c                              |   29 +++-
 tools/perf/util/cs-etm.h                              |   10 +
 tools/perf/util/parse-regs-options.c                  |    2 
 tools/testing/ktest/ktest.pl                          |    7 -
 tools/testing/selftests/bpf/test_offload.py           |    1 
 350 files changed, 2087 insertions(+), 1115 deletions(-)

Alan Stern (1):
      media: gspca: Fix memory leak in probe

Alexander Sverdlin (1):
      serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Alexandre Belloni (1):
      ARM: dts: at91: at91sam9rl: fix ADC triggers

Alexey Kardashevskiy (1):
      serial_core: Check for port state when tty is in error state

Amadej Kastelic (1):
      ALSA: usb-audio: Add VID to support native DSD reproduction on FiiO devices

Anant Thazhemadam (1):
      Bluetooth: hci_h5: fix memory leak in h5_close

Andy Lutomirski (1):
      x86/membarrier: Get rid of a dubious optimization

Andy Shevchenko (2):
      pinctrl: merrifield: Set default bias in case no particular value given
      pinctrl: baytrail: Avoid clearing debounce value when turning it off

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Ansuel Smith (1):
      PCI: qcom: Add missing reset for ipq806x

Anton Ivanov (3):
      um: Monitor error events in IRQ controller
      um: tty: Fix handling of close in tty lines
      um: chan_xterm: Fix fd leak

Antti Palosaari (1):
      media: msi2500: assign SPI bus number dynamically

Ard Biesheuvel (2):
      ARM: p2v: fix handling of LPAE translation in BE mode
      crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()

Arnd Bergmann (7):
      kbuild: avoid static_assert for genksyms
      scsi: megaraid_sas: Check user-provided offsets
      RDMa/mthca: Work around -Wenum-conversion warning
      seq_buf: Avoid type mismatch for seq_buf_init
      watchdog: coh901327: add COMMON_CLK dependency
      Input: cyapa_gen6 - fix out-of-bounds stack access
      platform/x86: mlx-platform: remove an unused variable

Artem Lapkin (1):
      arm64: dts: meson: fix spi-max-frequency on Khadas VIM2

Arvind Sankar (3):
      x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
      compiler.h: fix barrier_data() on clang
      x86/mm/ident_map: Check for errors from ident_pud_init()

Athira Rajeev (1):
      powerpc/perf: Exclude kernel samples while counting events in user space.

Baruch Siach (1):
      gpio: mvebu: fix potential user-after-free on probe

Bean Huo (1):
      mmc: block: Fixup condition for CMD13 polling for RPMB requests

Bharat Gooty (1):
      PCI: iproc: Fix out-of-bound array accesses

Bjorn Andersson (1):
      slimbus: qcom-ngd-ctrl: Avoid sending power requests without QMI

Bjorn Helgaas (1):
      PCI: Bounds-check command-line resource alignment requests

Björn Töpel (1):
      ixgbe: avoid premature Rx buffer reuse

Bob Pearson (1):
      RDMA/rxe: Compute PSN windows correctly

Bongsu Jeon (1):
      nfc: s3fwrn5: Release the nfc firmware

Borislav Petkov (1):
      EDAC/amd64: Fix PCI component registration

Bui Quang Minh (1):
      USB: dummy-hcd: Fix uninitialized array use in init()

Calum Mackay (1):
      lockd: don't use interval-based rebinding over TCP

Can Guo (1):
      scsi: ufs: Make sure clk scaling happens only when HBA is runtime ACTIVE

Carlos Garnacho (1):
      platform/x86: intel-vbtn: Allow switch events on Acer Switch Alpha 12

Cezary Rojewski (1):
      ASoC: pcm: DRAIN support reactivation

Chen-Yu Tsai (2):
      arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
      arm64: dts: rockchip: Fix UART pull-ups on rk3328

Cheng Lin (1):
      nfs_common: need lock during iterate through the list

Chris Chiu (4):
      Input: i8042 - add Acer laptops to the i8042 reset list
      ALSA: hda/realtek - Enable headset mic of ASUS X430UN with ALC256
      ALSA: hda/realtek - Enable headset mic of ASUS Q524UQK with ALC255
      ALSA: hda/realtek: Apply jack fixup for Quanta NL3

Chris Packham (1):
      ARM: dts: Remove non-existent i2c1 from 98dx3236

Christophe JAILLET (5):
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
      clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Christophe Leroy (4):
      crypto: talitos - Endianess in current_desc_hdr()
      crypto: talitos - Fix return type of current_desc_hdr()
      powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32
      powerpc/xmon: Change printk() to pr_cont()

Chuhong Yuan (1):
      ASoC: jz4740-i2s: add missed checks for clk_get()

Chunguang Xu (1):
      ext4: fix a memory leak of ext4_free_data

Chunyan Zhang (1):
      gpio: eic-sprd: break loop when getting NULL device resource

Claudiu Beznea (1):
      ARM: dts: at91: sama5d2: map securam as device

Coiby Xu (1):
      pinctrl: amd: remove debounce filter setting in IRQ type setting

Colin Ian King (3):
      crypto: inside-secure - Fix sizeof() mismatch
      media: tm6000: Fix sizeof() mismatches
      PCI: Fix overflow in command-line resource alignment requests

Connor McAdams (1):
      ALSA: hda/ca0132 - Change Input Source enum strings.

Cristian Birsan (2):
      ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
      ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Dae R. Jeong (1):
      md: fix a warning caused by a race between concurrent md_ioctl()s

Dan Carpenter (6):
      scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"
      soc: renesas: rmobile-sysc: Fix some leaks in rmobile_init_pm_domains()
      media: max2175: fix max2175_set_csm_mode() error code
      media: saa7146: fix array overflow in vidioc_s_audio()
      ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
      qlcnic: Fix error code in probe

Dan Williams (1):
      libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels

Daniel Scally (1):
      Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Daniel T. Lee (1):
      samples: bpf: Fix lwt_len_hist reusing previous BPF map

Dave Kleikamp (1):
      jfs: Fix array index bounds check in dbAdjTree

David Hildenbrand (2):
      powerpc/powernv/memtrace: Don't leak kernel memory to user space
      powerpc/powernv/memtrace: Fix crashing the kernel when enabling concurrently

David Jander (1):
      Input: ads7846 - fix race that causes missing releases

David Woodhouse (1):
      x86/apic: Fix x2apic enablement without interrupt remapping

Deepak R Varma (1):
      drm/tegra: replace idr_init() by idr_init_base()

Dmitry Baryshkov (1):
      drm/msm/dsi_pll_10nm: restore VCO rate during restore_state

Dmitry Osipenko (1):
      clk: tegra: Fix duplicated SE clock entry

Dmitry Torokhov (3):
      Input: cm109 - do not stomp on control URB
      Input: ads7846 - fix unaligned access on 7845
      Input: cros_ec_keyb - send 'scancodes' in addition to key events

Dongdong Wang (1):
      lwt: Disable BH too in run_lwt_bpf()

Douglas Anderson (1):
      soc: qcom: geni: More properly switch to DMA mode

Dwaipayan Ray (1):
      checkpatch: fix unescaped left brace

Eric Biggers (1):
      crypto: af_alg - avoid undefined behavior accessing salg_name

Eric Dumazet (2):
      mac80211: mesh: fix mesh_pathtbl_init() error path
      tcp: select sane initial rcvq_space.space for big MSS

Evan Green (1):
      soc: qcom: smp2p: Safely acquire spinlock without IRQs

Fabio Estevam (1):
      usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Fangrui Song (2):
      x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
      arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S

Fugang Duan (2):
      net: stmmac: free tx skb buffer in stmmac_resume()
      net: stmmac: delete the eee_ctrl_timer after napi disabled

Geert Uytterhoeven (1):
      clk: renesas: r9a06g032: Drop __packed for portability

Greg Kroah-Hartman (1):
      Linux 4.19.164

Guenter Roeck (1):
      watchdog: sirfsoc: Add missing dependency on HAS_IOMEM

H. Nikolaus Schaller (1):
      ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES

Hans de Goede (3):
      platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e
      platform/x86: thinkpad_acpi: Add BAT1 is primary battery quirk for Thinkpad Yoga 11e 4th gen
      power: supply: axp288_charger: Fix HP Pavilion x2 10 DMI matching

Hao Si (1):
      soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)

Hui Wang (1):
      ACPI: PNP: compare the string length in the matching_id()

Ian Abbott (1):
      staging: comedi: mf6x4: Fix AI end-of-conversion detection

Icenowy Zheng (1):
      ARM: dts: sun8i: v3s: fix GIC node memory range

Jack Pham (1):
      usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Jack Xu (1):
      crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()

James Morse (1):
      x86/resctrl: Remove unused struct mbm_state::chunks_bw

James Smart (2):
      scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()
      scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()

Jan Kara (2):
      quota: Sanity-check quota file headers on load
      ext4: fix deadlock with fs freezing and EA inodes

Jason Gunthorpe (1):
      vfio-pci: Use io_remap_pfn_range() for PCI IO memory

Jernej Skrabec (1):
      clk: sunxi-ng: Make sure divider tables have sentinel

Jerome Brunet (1):
      ASoC: meson: fix COMPILE_TEST error

Jing Xiangfeng (3):
      staging: gasket: interrupt: fix the missed eventfd_ctx_put() in gasket_interrupt.c
      HSI: omap_ssi: Don't jump to free ID in ssi_add_controller()
      memstick: r592: Fix error return in r592_probe()

Joel Stanley (1):
      ARM: dts: aspeed: s2600wf: Fix VGA memory region location

Johan Hovold (9):
      USB: serial: option: add interface-number sanity check to flag handling
      USB: serial: mos7720: fix parallel-port state restore
      USB: serial: digi_acceleport: fix write-wakeup deadlocks
      USB: serial: keyspan_pda: fix dropped unthrottle interrupts
      USB: serial: keyspan_pda: fix write deadlock
      USB: serial: keyspan_pda: fix stalled writes
      USB: serial: keyspan_pda: fix write-wakeup use-after-free
      USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
      USB: serial: keyspan_pda: fix write unthrottling

Johannes Berg (2):
      iwlwifi: pcie: limit memory read spin time
      mac80211: don't set set TDLS STA bandwidth wider than possible

Johannes Thumshirn (1):
      block: factor out requeue handling from dispatch code

Jonathan Cameron (4):
      iio:light:rpr0521: Fix timestamp alignment and prevent data leak.
      iio:light:st_uvis25: Fix timestamp alignment and prevent data leak.
      iio:pressure:mpl3115: Force alignment of buffer
      iio:imu:bmi160: Fix too large a buffer.

Jordan Niethe (1):
      powerpc/64: Set up a kernel stack for secondaries before cpu_restore()

Jubin Zhong (1):
      PCI: Fix pci_slot_release() NULL pointer dereference

Julian Sax (1):
      HID: i2c-hid: add Vero K147 to descriptor override

Kamal Heib (2):
      RDMA/bnxt_re: Set queue pair state when being queried
      RDMA/cxgb4: Validate the number of CQEs

Keita Suzuki (1):
      media: siano: fix memory leak of debugfs members in smsdvb_hotplug

Keqian Zhu (1):
      clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Krzysztof Kozlowski (4):
      ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
      ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410
      ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU
      drm/tve200: Fix handling of platform_get_irq() error

Leo Yan (2):
      perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata
      perf cs-etm: Move definition of 'traceid_list' global variable from header file

Leon Romanovsky (2):
      RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait
      net/mlx5: Properly convey driver version to firmware

Li Jun (1):
      xhci: Give USB2 ports time to enter U3 in bus suspend

Lingling Xu (2):
      watchdog: sprd: remove watchdog disable from resume fail path
      watchdog: sprd: check busy bit before new loading rather than after that

Lokesh Vutla (1):
      pwm: lp3943: Dynamically allocate PWM chip base

Luc Van Oostenryck (1):
      xsk: Fix xsk_poll()'s return type

Luis Henriques (1):
      ceph: fix race in concurrent __ceph_remove_cap invocations

Lukas Wunner (8):
      spi: bcm2835aux: Fix use-after-free on unbind
      media: netup_unidvb: Don't leak SPI master in probe error path
      spi: spi-sh: Fix use-after-free on unbind
      spi: davinci: Fix use-after-free on unbind
      spi: pic32: Don't leak DMA channels in probe error path
      spi: rb4xx: Don't leak SPI master in probe error path
      spi: sc18is602: Don't leak SPI master in probe error path
      spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path

Manivannan Sadhasivam (1):
      watchdog: qcom: Avoid context switch in restart handler

Mao Jinlong (1):
      coresight: tmc-etr: Check if page is valid before dma_map_page()

Marc Zyngier (3):
      genirq/irqdomain: Don't try to free an interrupt that has no mapping
      irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
      KVM: arm64: Introduce handling of AArch32 TTBCR2 traps

Marek Szyprowski (1):
      extcon: max77693: Fix modalias string

Mark Rutland (1):
      arm64: syscall: exit userspace before unmasking exceptions

Markus Reichl (1):
      arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux

Martin Wilck (1):
      scsi: core: Fix VPD LUN ID designator priorities

Masahiro Yamada (1):
      kconfig: fix return value of do_error_if()

Masami Hiramatsu (1):
      x86/kprobes: Restore BTF if the single-stepping is cancelled

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Max Verevkin (1):
      platform/x86: intel-vbtn: Support for tablet mode on HP Pavilion 13 x360 PC

Michael Ellerman (1):
      powerpc: Drop -me200 addition to build flags

Miquel Raynal (1):
      mtd: spinand: Fix OOB read

Moshe Shemesh (2):
      net/mlx4_en: Avoid scheduling restart task if it is already running
      net/mlx4_en: Handle TX error CQE

Nathan Chancellor (2):
      spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe
      crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd

Nathan Lynch (2):
      powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops
      powerpc/pseries/hibernation: remove redundant cacheinfo update

Neal Cardwell (1):
      tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Necip Fazil Yildiran (1):
      MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

NeilBrown (1):
      NFS: switch nfsiod to be an UNBOUND workqueue.

Nicholas Piggin (1):
      kernel/cpu: add arch override for clear_tasks_mm_cpumask() mm handling

Nick Desaulniers (1):
      Kbuild: do not emit debug info for assembly with LLVM_IAS=1

Nicolas Boichat (1):
      soc: mediatek: Check if power domains can be powered on at boot time

Nicolas Ferre (1):
      ARM: dts: at91: sama5d2: fix CAN message ram offset and size

Nicolin Chen (1):
      soc/tegra: fuse: Fix index bug in get_process_id

Nuno Sá (1):
      iio: buffer: Fix demux update

Oleksandr Andrushchenko (1):
      drm/xen-front: Fix misused IS_ERR_OR_NULL checks

Oleksij Rempel (1):
      Input: ads7846 - fix integer overflow on Rt calculation

Olga Kornievskaia (1):
      NFSv4.2: condition READDIR's mask for security label based on LSM state

Oliver Neukum (2):
      USB: add RESET_RESUME quirk for Snapscan 1212
      USB: UAS: introduce a quirk to set no_write_same

Pali Rohár (5):
      cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
      cpufreq: mediatek: Add missing MODULE_DEVICE_TABLE
      cpufreq: st: Add missing MODULE_DEVICE_TABLE
      cpufreq: loongson1: Add missing MODULE_ALIAS
      cpufreq: scpi: Add missing MODULE_ALIAS

Paul Kocialkowski (1):
      ARM: sunxi: Add machine match for the Allwinner V3 SoC

Paul Moore (1):
      selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling

Pawel Wieczorkiewicz (1):
      xen-blkback: set ring->xenblkd to NULL after kthread_stop()

Paweł Chmiel (2):
      arm64: dts: exynos: Include common syscon restart/poweroff for Exynos7
      arm64: dts: exynos: Correct psci compatible used on Exynos7

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Peng Liu (1):
      sched/deadline: Fix sched_dl_global_validate()

Philipp Rudo (1):
      s390/kexec_file: fix diag308 subcode when loading crash kernel

Praveenkumar I (1):
      mtd: rawnand: qcom: Fix DMA sync on FLASH_STATUS register read

Qinglang Miao (11):
      drm/tegra: sor: Disable clocks on error in tegra_sor_init()
      spi: bcm63xx-hsspi: fix missing clk_disable_unprepare() on error in bcm63xx_hsspi_resume
      media: solo6x10: fix missing snd_card_free in error handling case
      memstick: fix a double-free bug in memstick_check
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
      mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
      platform/x86: dell-smbios-base: Fix error return code in dell_smbios_init
      dm ioctl: fix error return code in target_message
      scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
      spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
      iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Rafael J. Wysocki (1):
      PM: ACPI: PCI: Drop acpi_pm_set_bridge_wakeup()

Rakesh Pillai (1):
      ath10k: Fix the parsing error in service available event

Randy Dunlap (1):
      scsi: bnx2i: Requires MMU

Richard Weinberger (1):
      ubifs: wbuf: Don't leak kernel memory to flash

Roberto Sassu (1):
      ima: Don't modify file descriptor mode on the fly

Sakari Ailus (5):
      media: ipu3-cio2: Remove traces of returned buffers
      media: ipu3-cio2: Return actual subdev format
      media: ipu3-cio2: Serialise access to pad format
      media: ipu3-cio2: Validate mbus format in setting subdev format
      media: ipu3-cio2: Make the field on subdev format V4L2_FIELD_NONE

Sami Tolvanen (1):
      arm64: lse: fix LSE atomics with LLVM's integrated assembler

Sara Sharon (2):
      iwlwifi: mvm: fix kernel panic in case of assert during CSA
      cfg80211: initialize rekey_data

Sean Young (1):
      media: sunxi-cir: ensure IR is handled when it is continuous

Sebastian Andrzej Siewior (1):
      orinoco: Move context allocation after processing the skb

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Serge Hallyn (1):
      fix namespaced fscaps when !CONFIG_SECURITY

Sergej Bauer (1):
      lan743x: fix for potential NULL pointer dereference with bare card

Simon Beginn (1):
      Input: goodix - add upside-down quirk for Teclast X98 Pro tablet

Sreekanth Reddy (1):
      scsi: mpt3sas: Increase IOCInit request timeout to 30s

Stefan Haberland (4):
      s390/dasd: fix hanging device offline processing
      s390/dasd: prevent inconsistent LCU device data
      s390/dasd: fix list corruption of pavgroup group list
      s390/dasd: fix list corruption of lcu list

Steve French (2):
      SMB3: avoid confusing warning message on mount to Azure
      SMB3.1.1: do not log warning message if server doesn't populate salt

Steven Rostedt (VMware) (1):
      ktest.pl: If size of log is too big to email, email error message

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Switch synchronization to RCU

Sven Eckelmann (3):
      vxlan: Add needed_headroom for lower device
      vxlan: Copy needed_tailroom from lowerdev
      mtd: parser: cmdline: Fix parsing of part-names with colons

Sven Schnelle (1):
      s390/smp: perform initial CPU reset also for SMT siblings

Takashi Iwai (7):
      ALSA: usb-audio: Fix potential out-of-bounds shift
      ALSA: usb-audio: Fix control 'access overflow' errors from chmap
      ALSA: pcm: oss: Fix potential out-of-bounds shift
      ALSA: hda: Fix regressions on clear and reconfig sysfs
      ALSA: pcm: oss: Fix a few more UBSAN fixes
      ALSA: hda/realtek: Add quirk for MSI-GP73
      ALSA: usb-audio: Disable sample read check if firmware doesn't give back

Terry Zhou (1):
      clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9

Thomas Gleixner (4):
      x86/apic/vector: Fix ordering in vector assignment
      USB: sisusbvga: Make console support depend on BROKEN
      dm table: Remove BUG_ON(in_interrupt())
      sched: Reenable interrupts in do_sched_yield()

Tianyue Ren (1):
      selinux: fix error initialization in inode_doinit_with_dentry()

Timo Witte (1):
      platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Toke Høiland-Jørgensen (1):
      selftests/bpf/test_offload.py: Reset ethtool features after failed setting

Tom Rix (1):
      drm/gma500: fix double free of gma_connector

Trond Myklebust (1):
      SUNRPC: xprt_load_transport() needs to support the netid "rdma6"

Tsuchiya Yuto (1):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure

Tyrel Datwyler (1):
      powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter

Uwe Kleine-König (2):
      spi: fix resource leak for drivers without .remove callback
      pwm: zx: Add missing cleanup in error path

Vadim Pasternak (3):
      platform/x86: mlx-platform: Remove PSU EEPROM from default platform configuration
      platform/x86: mlx-platform: Remove PSU EEPROM from MSN274x platform configuration
      platform/x86: mlx-platform: Fix item counter assignment for MSN2700, MSN24xx systems

Vincent Stehlé (2):
      powerpc/ps3: use dma_mapping_error()
      net: korina: fix return value

Vincenzo Frascino (1):
      arm64: lse: Fix LSE atomics with LLVM

Vineet Gupta (1):
      ARC: stack unwinding: don't assume non-current task is sleeping

Wang Wensheng (1):
      watchdog: Fix potential dereferencing of null pointer

Will McVicker (2):
      USB: gadget: f_midi: setup SuperSpeed Plus descriptors
      USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Xiaochen Shen (1):
      x86/resctrl: Fix incorrect local bandwidth when mba_sc is enabled

Xin Xiong (1):
      drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi

Xu Qiang (1):
      irqchip/gic-v3-its: Unconditionally save/restore the ITS state on suspend

Yang Yingliang (4):
      video: fbdev: atmel_lcdfb: fix return error code in atmel_lcdfb_of_init()
      drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
      usb/max3421: fix return error code in max3421_probe()
      speakup: fix uninitialized flush_lock

Yangtao Li (1):
      pinctrl: sunxi: Always call chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler

Yu Kuai (3):
      media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()
      clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()
      pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Zhang Changzhong (3):
      net: bridge: vlan: fix error return code in __vlan_add()
      scsi: fnic: Fix error return code in fnic_probe()
      bus: fsl-mc: fix error return code in fsl_mc_object_allocate()

Zhang Qilong (20):
      can: softing: softing_netdev_open(): fix error handling
      spi: img-spfi: fix reference leak in img_spfi_resume
      spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
      spi: tegra20-slink: fix reference leak in slink ops of tegra20
      spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
      spi: tegra114: fix reference leak in tegra spi ops
      ASoC: wm8998: Fix PM disable depth imbalance on error
      ASoC: arizona: Fix a wrong free in wm8997_probe
      staging: greybus: codecs: Fix reference counter leak in error handling
      spi: mxs: fix reference leak in mxs_spi_probe
      crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
      soc: ti: knav_qmss: fix reference leak in knav_queue_probe
      soc: ti: Fix reference imbalance in knav_dma_probe
      Input: omap4-keypad - fix runtime PM error handling
      power: supply: bq24190_charger: fix reference leak
      scsi: pm80xx: Fix error return in pm8001_pci_probe()
      usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
      usb: oxu210hp-hcd: Fix memory leak in oxu_create
      libnvdimm/label: Return -ENXIO for no slot in __blk_label_update
      clk: ti: Fix memleak in ti_fapll_synth_setup

Zhao Heming (2):
      md/cluster: block reshape with remote resync job
      md/cluster: fix deadlock when node is doing resync job

Zhe Li (1):
      jffs2: Fix GC exit abnormally

Zheng Zengkai (1):
      perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhihao Cheng (2):
      drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe
      dmaengine: mv_xor_v2: Fix error return code in mv_xor_v2_probe()

Zwane Mwaikambo (1):
      drm/dp_aux_dev: check aux_dev before use in drm_dp_aux_dev_get_by_minor()

kazuo ito (1):
      nfsd: Fix message level for normal termination

taehyun.cho (1):
      USB: gadget: f_acm: add support for SuperSpeed Plus

