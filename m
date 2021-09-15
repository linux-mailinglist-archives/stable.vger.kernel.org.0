Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DE540C148
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhIOIKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 04:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236898AbhIOIKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 04:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24859611AF;
        Wed, 15 Sep 2021 08:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631693372;
        bh=0V9T+Uooy6ZFQ7EHXWk+3PY5x0VKNQLwTG2DILUGXPw=;
        h=From:To:Cc:Subject:Date:From;
        b=o2Iu1leWwLVZVPUT7mTRj35SEFVHKp7H3IVT9lAF2IRZok+2Xt3FFx9IwKAjXUABY
         cJasuANyWxfLi7bY69Gy6kkX5viVk9j+tu1m/d8/in9DDOYoUxSWH9058ccJlCxZOi
         ZR6y73hEmigriFVcZ3phFZpxtbMHBMLCUCo0uBnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.17
Date:   Wed, 15 Sep 2021 10:09:26 +0200
Message-Id: <163169336668242@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.17 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/fault-injection/provoke-crashes.rst          |    2 
 Makefile                                                   |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                   |    4 
 arch/arm/boot/dts/at91-sam9x60ek.dts                       |   16 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts                |   29 ++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts                |   19 +
 arch/arm/boot/dts/meson8.dtsi                              |    5 
 arch/arm/boot/dts/meson8b-ec100.dts                        |    4 
 arch/arm/boot/dts/meson8b-mxq.dts                          |    4 
 arch/arm/boot/dts/meson8b-odroidc1.dts                     |    4 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                    |    2 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts     |   17 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi               |   11 
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi        |    2 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                       |    2 
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi            |    1 
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts             |    4 
 arch/arm64/kvm/arm.c                                       |    7 
 arch/m68k/Kconfig.cpu                                      |    8 
 arch/m68k/coldfire/clk.c                                   |    2 
 arch/m68k/emu/nfeth.c                                      |    4 
 arch/s390/include/asm/kvm_host.h                           |    1 
 arch/s390/kernel/debug.c                                   |  176 ++++++++-----
 arch/s390/kvm/interrupt.c                                  |   12 
 arch/s390/kvm/kvm-s390.c                                   |    2 
 arch/s390/kvm/kvm-s390.h                                   |    2 
 arch/s390/mm/kasan_init.c                                  |   41 +--
 arch/s390/pci/pci.c                                        |    7 
 arch/s390/pci/pci_clp.c                                    |   33 +-
 arch/x86/boot/compressed/efi_thunk_64.S                    |   30 +-
 arch/x86/boot/compressed/head_64.S                         |    3 
 arch/x86/crypto/aesni-intel_glue.c                         |    5 
 arch/x86/events/amd/ibs.c                                  |    1 
 arch/x86/include/asm/mce.h                                 |    1 
 arch/x86/kernel/cpu/mce/core.c                             |   11 
 arch/x86/kernel/cpu/resctrl/monitor.c                      |    6 
 arch/x86/kvm/mmu/mmu.c                                     |   19 -
 arch/x86/kvm/mmu/tdp_mmu.c                                 |   20 -
 arch/x86/kvm/vmx/nested.c                                  |    7 
 arch/x86/kvm/vmx/vmx.c                                     |    3 
 arch/x86/kvm/x86.c                                         |    4 
 block/bfq-iosched.c                                        |    3 
 block/bio.c                                                |   15 -
 block/blk-crypto.c                                         |    2 
 block/blk-merge.c                                          |   18 -
 block/blk-throttle.c                                       |   32 ++
 block/blk.h                                                |    2 
 block/elevator.c                                           |    3 
 block/mq-deadline.c                                        |    2 
 certs/Makefile                                             |    8 
 crypto/Makefile                                            |    1 
 crypto/ecc.h                                               |    5 
 crypto/tcrypt.c                                            |   29 +-
 drivers/ata/libata-core.c                                  |    2 
 drivers/auxdisplay/hd44780.c                               |    2 
 drivers/base/dd.c                                          |   16 -
 drivers/base/firmware_loader/main.c                        |   20 -
 drivers/base/regmap/regmap.c                               |    2 
 drivers/bcma/main.c                                        |    6 
 drivers/block/nbd.c                                        |   16 +
 drivers/bluetooth/btusb.c                                  |   18 -
 drivers/char/tpm/Kconfig                                   |    1 
 drivers/char/tpm/tpm_ibmvtpm.c                             |   26 +
 drivers/char/tpm/tpm_ibmvtpm.h                             |    2 
 drivers/clk/mvebu/kirkwood.c                               |    1 
 drivers/clocksource/sh_cmt.c                               |   30 +-
 drivers/counter/104-quad-8.c                               |    5 
 drivers/crypto/hisilicon/sec2/sec.h                        |    5 
 drivers/crypto/hisilicon/sec2/sec_main.c                   |   34 --
 drivers/crypto/mxs-dcp.c                                   |   45 ++-
 drivers/crypto/omap-aes.c                                  |    8 
 drivers/crypto/omap-des.c                                  |    8 
 drivers/crypto/omap-sham.c                                 |   14 -
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       |    4 
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         |    4 
 drivers/crypto/qat/qat_common/adf_common_drv.h             |    8 
 drivers/crypto/qat/qat_common/adf_init.c                   |    5 
 drivers/crypto/qat/qat_common/adf_isr.c                    |    7 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c              |    3 
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c              |   12 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                 |    7 
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c |    4 
 drivers/edac/i10nm_base.c                                  |    6 
 drivers/edac/mce_amd.c                                     |    3 
 drivers/firmware/raspberrypi.c                             |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c                    |   54 +--
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c                     |    4 
 drivers/gpu/drm/drm_of.c                                   |    6 
 drivers/gpu/drm/gma500/oaktrail_lvds.c                     |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c                 |   10 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                   |   68 ++---
 drivers/gpu/drm/msm/dp/dp_display.c                        |   31 +-
 drivers/gpu/drm/msm/dsi/dsi.c                              |    6 
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                          |    3 
 drivers/gpu/drm/mxsfb/mxsfb_drv.h                          |    1 
 drivers/gpu/drm/mxsfb/mxsfb_kms.c                          |   40 ++
 drivers/gpu/drm/mxsfb/mxsfb_regs.h                         |    9 
 drivers/gpu/drm/panfrost/panfrost_device.c                 |    3 
 drivers/gpu/drm/rcar-du/rcar_du_drv.c                      |    2 
 drivers/hwmon/Makefile                                     |    1 
 drivers/hwmon/pmbus/bpa-rs600.c                            |   25 -
 drivers/i2c/busses/i2c-highlander.c                        |    2 
 drivers/i2c/busses/i2c-hix5hd2.c                           |    2 
 drivers/i2c/busses/i2c-iop3xx.c                            |    6 
 drivers/i2c/busses/i2c-mt65xx.c                            |    2 
 drivers/i2c/busses/i2c-s3c2410.c                           |    2 
 drivers/i2c/busses/i2c-synquacer.c                         |    2 
 drivers/i2c/busses/i2c-xlp9xx.c                            |    2 
 drivers/infiniband/hw/mlx5/mr.c                            |    2 
 drivers/irqchip/irq-apple-aic.c                            |    2 
 drivers/irqchip/irq-gic-v3.c                               |   23 +
 drivers/irqchip/irq-loongson-pch-pic.c                     |   19 +
 drivers/leds/blink/leds-lgm-sso.c                          |   23 +
 drivers/leds/flash/leds-rt8515.c                           |    4 
 drivers/leds/leds-is31fl32xx.c                             |    1 
 drivers/leds/leds-lt3593.c                                 |    5 
 drivers/leds/trigger/ledtrig-audio.c                       |   37 ++
 drivers/md/bcache/super.c                                  |   16 -
 drivers/md/raid1.c                                         |   19 +
 drivers/md/raid10.c                                        |   14 -
 drivers/media/i2c/tda1997x.c                               |    1 
 drivers/media/platform/coda/coda-bit.c                     |   18 -
 drivers/media/platform/omap3isp/isp.c                      |    4 
 drivers/media/platform/qcom/venus/helpers.c                |    3 
 drivers/media/platform/qcom/venus/hfi_msgs.c               |    2 
 drivers/media/platform/qcom/venus/venc.c                   |    2 
 drivers/media/platform/rockchip/rga/rga-buf.c              |    3 
 drivers/media/platform/rockchip/rga/rga.c                  |   29 +-
 drivers/media/spi/cxd2880-spi.c                            |    7 
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c                    |    9 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                   |    2 
 drivers/media/usb/dvb-usb/nova-t-usb2.c                    |    6 
 drivers/media/usb/dvb-usb/vp702x.c                         |   12 
 drivers/media/usb/em28xx/em28xx-input.c                    |    1 
 drivers/media/usb/go7007/go7007-driver.c                   |   26 -
 drivers/media/usb/go7007/go7007-usb.c                      |    2 
 drivers/misc/lkdtm/core.c                                  |    2 
 drivers/mmc/host/dw_mmc.c                                  |    1 
 drivers/mmc/host/moxart-mmc.c                              |    1 
 drivers/mmc/host/sdhci.c                                   |    1 
 drivers/net/dsa/b53/b53_common.c                           |   10 
 drivers/net/dsa/b53/b53_priv.h                             |    2 
 drivers/net/dsa/bcm_sf2.c                                  |    1 
 drivers/net/dsa/mt7530.c                                   |   13 
 drivers/net/dsa/mv88e6xxx/chip.c                           |   18 -
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c       |    3 
 drivers/net/ethernet/google/gve/gve_adminq.c               |    6 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |   23 +
 drivers/net/ethernet/intel/ice/ice_main.c                  |   13 
 drivers/net/ethernet/marvell/octeontx2/af/common.h         |    2 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c      |   31 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c        |   22 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c   |   16 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h   |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c    |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       |    4 
 drivers/net/ethernet/mellanox/mlx5/core/dev.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c          |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h            |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c           |   15 -
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h           |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c            |   10 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |   18 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |   18 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c  |    1 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    5 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      |   18 -
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c        |   14 -
 drivers/net/ethernet/qualcomm/qca_spi.c                    |    2 
 drivers/net/ethernet/qualcomm/qca_uart.c                   |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c           |    5 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                   |   47 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h                   |    2 
 drivers/net/phy/marvell10g.c                               |    8 
 drivers/net/wireless/ath/ath6kl/wmi.c                      |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    2 
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c               |   14 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c              |    1 
 drivers/net/wireless/rsi/rsi_91x_hal.c                     |    4 
 drivers/net/wireless/rsi/rsi_91x_usb.c                     |    1 
 drivers/nvme/host/rdma.c                                   |    4 
 drivers/nvme/host/tcp.c                                    |    4 
 drivers/nvme/target/fabrics-cmd.c                          |    9 
 drivers/pci/pci.c                                          |   25 +
 drivers/power/supply/axp288_fuel_gauge.c                   |    4 
 drivers/power/supply/cw2015_battery.c                      |    4 
 drivers/power/supply/max17042_battery.c                    |    2 
 drivers/power/supply/smb347-charger.c                      |   10 
 drivers/regulator/tps65910-regulator.c                     |   10 
 drivers/regulator/vctrl-regulator.c                        |   73 +++--
 drivers/s390/cio/css.c                                     |   17 +
 drivers/s390/crypto/ap_bus.c                               |   25 -
 drivers/s390/crypto/ap_bus.h                               |   10 
 drivers/s390/crypto/ap_queue.c                             |   20 -
 drivers/s390/crypto/zcrypt_ccamisc.c                       |    8 
 drivers/soc/mediatek/mt8183-mmsys.h                        |   21 +
 drivers/soc/mediatek/mtk-mmsys.c                           |    7 
 drivers/soc/mediatek/mtk-mmsys.h                           |  133 ++++++---
 drivers/soc/qcom/rpmhpd.c                                  |    5 
 drivers/soc/qcom/smsm.c                                    |   11 
 drivers/soc/rockchip/Kconfig                               |    4 
 drivers/spi/spi-coldfire-qspi.c                            |    2 
 drivers/spi/spi-davinci.c                                  |    8 
 drivers/spi/spi-fsl-dspi.c                                 |    1 
 drivers/spi/spi-pic32.c                                    |    1 
 drivers/spi/spi-sprd-adi.c                                 |    2 
 drivers/spi/spi-zynq-qspi.c                                |    8 
 drivers/staging/clocking-wizard/Kconfig                    |    2 
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c        |   11 
 drivers/tty/serial/fsl_lpuart.c                            |    2 
 drivers/tty/tty_io.c                                       |    4 
 drivers/usb/dwc3/dwc3-meson-g12a.c                         |    2 
 drivers/usb/dwc3/dwc3-qcom.c                               |    4 
 drivers/usb/gadget/udc/at91_udc.c                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_core.c                      |   30 +-
 drivers/usb/gadget/udc/mv_u3d_core.c                       |   19 -
 drivers/usb/gadget/udc/renesas_usb3.c                      |   17 -
 drivers/usb/gadget/udc/s3c2410_udc.c                       |    4 
 drivers/usb/host/ehci-orion.c                              |    8 
 drivers/usb/host/ohci-tmio.c                               |    3 
 drivers/usb/misc/brcmstb-usb-pinmap.c                      |    2 
 drivers/usb/phy/phy-fsl-usb.c                              |    2 
 drivers/usb/phy/phy-tahvo.c                                |    4 
 drivers/usb/phy/phy-twl6030-usb.c                          |    5 
 drivers/video/backlight/pwm_bl.c                           |   54 ++-
 drivers/video/fbdev/core/fbmem.c                           |    6 
 fs/cifs/cifs_unicode.c                                     |    9 
 fs/cifs/fs_context.c                                       |   11 
 fs/cifs/readdir.c                                          |   23 +
 fs/debugfs/file.c                                          |    8 
 fs/f2fs/file.c                                             |    5 
 fs/f2fs/super.c                                            |   11 
 fs/fcntl.c                                                 |   18 -
 fs/fuse/file.c                                             |   30 +-
 fs/fuse/fuse_i.h                                           |   19 +
 fs/fuse/inode.c                                            |   60 ++++
 fs/gfs2/ops_fstype.c                                       |   43 +++
 fs/gfs2/super.c                                            |   61 ----
 fs/io-wq.c                                                 |  105 +++++--
 fs/io_uring.c                                              |   16 -
 fs/iomap/swapfile.c                                        |    6 
 fs/isofs/inode.c                                           |   27 -
 fs/isofs/isofs.h                                           |    1 
 fs/isofs/joliet.c                                          |    4 
 fs/lockd/svclock.c                                         |    2 
 fs/nfsd/nfs4state.c                                        |    4 
 fs/udf/misc.c                                              |   13 
 fs/udf/super.c                                             |   75 ++---
 fs/udf/udf_sb.h                                            |    2 
 fs/udf/unicode.c                                           |    4 
 include/linux/blkdev.h                                     |   16 +
 include/linux/energy_model.h                               |   16 +
 include/linux/hrtimer.h                                    |    5 
 include/linux/local_lock_internal.h                        |   42 +--
 include/linux/mlx5/mlx5_ifc.h                              |    3 
 include/linux/power/max17042_battery.h                     |    2 
 include/linux/sunrpc/svc.h                                 |    1 
 include/linux/time64.h                                     |    9 
 include/net/dsa.h                                          |    2 
 include/net/pkt_cls.h                                      |    3 
 include/trace/events/io_uring.h                            |    6 
 include/trace/events/sunrpc.h                              |    8 
 include/uapi/linux/bpf.h                                   |    2 
 kernel/bpf/verifier.c                                      |   31 +-
 kernel/cgroup/cpuset.c                                     |   95 ++++---
 kernel/cpu_pm.c                                            |   50 ++-
 kernel/irq/timings.c                                       |    2 
 kernel/locking/mutex.c                                     |   15 -
 kernel/power/energy_model.c                                |    4 
 kernel/rcu/tree_stall.h                                    |   26 +
 kernel/sched/core.c                                        |   25 +
 kernel/sched/deadline.c                                    |    8 
 kernel/sched/debug.c                                       |    7 
 kernel/sched/fair.c                                        |    2 
 kernel/sched/sched.h                                       |    2 
 kernel/sched/topology.c                                    |   65 ++++
 kernel/time/hrtimer.c                                      |   92 +++++-
 kernel/time/posix-cpu-timers.c                             |    2 
 kernel/time/tick-internal.h                                |    3 
 lib/mpi/mpiutil.c                                          |    2 
 net/6lowpan/debugfs.c                                      |    3 
 net/bluetooth/cmtp/cmtp.h                                  |    2 
 net/bluetooth/hci_core.c                                   |   14 +
 net/bluetooth/mgmt.c                                       |    2 
 net/bluetooth/sco.c                                        |   11 
 net/core/devlink.c                                         |   36 +-
 net/dsa/dsa_priv.h                                         |    2 
 net/dsa/port.c                                             |   21 -
 net/dsa/slave.c                                            |    6 
 net/ipv4/route.c                                           |   48 ++-
 net/ipv4/tcp_ipv4.c                                        |    5 
 net/ipv6/route.c                                           |    5 
 net/mac80211/tx.c                                          |    4 
 net/netlabel/netlabel_cipso_v4.c                           |    8 
 net/qrtr/qrtr.c                                            |    8 
 net/sched/sch_cbq.c                                        |    2 
 net/sched/sch_htb.c                                        |   97 ++++---
 net/sunrpc/svc.c                                           |   15 +
 samples/bpf/xdp_redirect_cpu_user.c                        |    2 
 samples/pktgen/pktgen_sample04_many_flows.sh               |   12 
 samples/pktgen/pktgen_sample05_flow_per_thread.sh          |   12 
 security/integrity/ima/Kconfig                             |    1 
 security/integrity/ima/ima_mok.c                           |    2 
 sound/soc/codecs/rt5682-i2c.c                              |   20 +
 sound/soc/codecs/wcd9335.c                                 |   23 +
 sound/soc/fsl/fsl_rpmsg.c                                  |   20 -
 sound/soc/intel/boards/kbl_da7219_max98927.c               |   55 ----
 sound/soc/intel/common/soc-acpi-intel-cml-match.c          |    2 
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c          |    2 
 sound/soc/intel/skylake/skl-topology.c                     |   25 -
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c                 |   43 +--
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c                 |   27 +
 tools/bpf/bpftool/prog.c                                   |    5 
 tools/include/uapi/linux/bpf.h                             |    2 
 tools/lib/bpf/Makefile                                     |   10 
 tools/lib/bpf/libbpf.c                                     |   16 -
 tools/perf/util/bpf-event.c                                |    4 
 tools/perf/util/bpf_counter.c                              |    3 
 tools/testing/selftests/bpf/prog_tests/btf.c               |    1 
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c          |    2 
 tools/testing/selftests/bpf/progs/test_core_autosize.c     |   20 +
 tools/testing/selftests/bpf/test_maps.c                    |    4 
 323 files changed, 2705 insertions(+), 1554 deletions(-)

Abhishek Naik (1):
      iwlwifi: skip first element in the WTAS ACPI table

Adrian Ratiu (1):
      char: tpm: Kconfig: remove bad i2c cr50 select

Ahmad Fatoum (1):
      brcmfmac: pcie: fix oops on failure to resume and reprobe

Alexander Gordeev (1):
      s390/kasan: fix large PMD pages address alignment check

Amit Engel (1):
      nvmet: pass back cntlid on successful completion

Anand Moon (3):
      ARM: dts: meson8b: odroidc1: Fix the pwm regulator supply properties
      ARM: dts: meson8b: mxq: Fix the pwm regulator supply properties
      ARM: dts: meson8b: ec100: Fix the pwm regulator supply properties

Andrey Ignatov (1):
      bpf: Fix possible out of bound write in narrow load handling

Andrii Nakryiko (1):
      libbpf: Re-build libbpf.so when libbpf.map changes

Andy Duan (1):
      tty: serial: fsl_lpuart: fix the wrong mapbase value

Andy Shevchenko (5):
      leds: lgm-sso: Put fwnode in any case during ->probe()
      leds: lgm-sso: Don't spam logs when probe is deferred
      leds: lt3593: Put fwnode in any case during ->probe()
      leds: rt8515: Put fwnode in any case during ->probe()
      leds: lgm-sso: Propagate error codes from callee to caller

Ard Biesheuvel (1):
      crypto: x86/aes-ni - add missing error checks in XTS code

Austin Kim (1):
      IMA: remove -Wmissing-prototypes warning

Babu Moger (1):
      x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Baokun Li (1):
      nbd: add the check to prevent overflow in __nbd_ioctl()

Ben Hutchings (1):
      crypto: omap - Fix inconsistent locking of device lists

Benjamin Coddington (1):
      lockd: Fix invalid lockowner cast after vfs_test_lock

Biju Das (1):
      arm64: dts: renesas: hihope-rzg2-ex: Add EtherAVB internal rx delay

Bjorn Andersson (1):
      soc: qcom: rpmhpd: Use corner in power_off

Bob Peterson (1):
      gfs2: init system threads before freeze lock

Borislav Petkov (1):
      x86/mce: Defer processing of early errors

Brett Creeley (1):
      ice: Only lock to update netdev dev_addr

CK Hu (1):
      soc: mmsys: mediatek: add mask to mmsys routes

Cezary Rojewski (3):
      ASoC: Intel: kbl_da7219_max98927: Fix format selection for max98373
      ASoC: Intel: Skylake: Leave data as is when invoking TLV IPCs
      ASoC: Intel: Skylake: Fix module resource and format selection

Chen-Yu Tsai (3):
      irqchip/gic-v3: Fix priority comparison when non-secure priorities are used
      regulator: vctrl: Use locked regulator_get_voltage in probe path
      regulator: vctrl: Avoid lockdep warning in enable/disable ops

Chih-Kang Chang (1):
      mac80211: Fix insufficient headroom issue for AMSDU

Chris Packham (1):
      hwmon: (pmbus/bpa-rs600) Don't use rated limits as warn limits

Christoph Hellwig (1):
      bcache: add proper error unwinding in bcache_device_init

Christophe JAILLET (9):
      spi: coldfire-qspi: Use clk_disable_unprepare in the remove function
      media: cxd2880-spi: Fix an error handling path
      drm/msm/dsi: Fix some reference counted resource leaks
      firmware: raspberrypi: Fix a leak in 'rpi_firmware_get()'
      usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available
      usb: bdc: Fix a resource leak in the error handling path of 'bdc_probe()'
      ASoC: wcd9335: Fix a double irq free in the remove function
      ASoC: wcd9335: Fix a memory leak in the error handling path of the probe function
      ASoC: wcd9335: Disable irq on slave ports in the remove function

Chuck Lever (1):
      SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()

Chunguang Xu (1):
      blk-throtl: optimize IOPS throttle for large IO scenarios

Chunyan Zhang (1):
      spi: sprd: Fix the wrong WDG_LOAD_VAL

Claudiu Beznea (1):
      ARM: dts: at91: add pinctrl-{names, 0} for all gpios

Colin Ian King (4):
      gfs2: Fix memory leak of object lsi on error return path
      6lowpan: iphc: Fix an off-by-one check of array index
      media: venus: venc: Fix potential null pointer dereference on pointer fmt
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Curtis Malainey (1):
      ASoC: Intel: Fix platform ID matching

Damien Le Moal (1):
      libata: fix ata_host_start()

Dan Carpenter (7):
      media: rockchip/rga: fix error handling in probe
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
      rsi: fix error code in rsi_load_9116_firmware()
      rsi: fix an error code in rsi_probe()
      m68k: coldfire: return success for clk_enable(NULL)
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()
      net: qrtr: make checks in qrtr_endpoint_post() stricter

Daniel Thompson (1):
      backlight: pwm_bl: Improve bootloader/kernel device handover

Darren Powell (1):
      amdgpu/pm: add extra info to SMU msg pre-check failed message

David Heidelberg (2):
      drm/msm/mdp4: refactor HW revision detection into read_mdp_hw_revision
      drm/msm/mdp4: move HW revision detection to earlier phase

Desmond Cheong Zhi Xi (3):
      fcntl: fix potential deadlocks for &fown_struct.lock
      fcntl: fix potential deadlock for &fasync_struct.fa_lock
      Bluetooth: fix repeated calls to sco_sock_kill

Dietmar Eggemann (1):
      sched/deadline: Fix missing clock update in migrate_task_rq_dl()

Dmitry Baryshkov (2):
      arm64: dts: qcom: sm8250: fix usb2 qmp phy node
      drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

Dmitry Osipenko (2):
      regulator: tps65910: Silence deferred probe error
      power: supply: smb347-charger: Add missing pin control activation

Dmytro Linkin (1):
      net/mlx5e: Use correct eswitch for stack devices with lag

Dongliang Mu (4):
      media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init
      media: dvb-usb: fix uninit-value in vp702x_read_mac_addr
      media: dvb-usb: Fix error handling in dvb_usb_i2c_init
      media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

Douglas Anderson (2):
      ASoC: rt5682: Properly turn off regulators if wrong device ID
      ASoC: rt5682: Remove unused variable in rt5682_i2c_remove()

Dylan Hung (1):
      ARM: dts: aspeed-g6: Fix HVI3C function-group in pinctrl dtsi

Eric Biggers (1):
      blk-crypto: fix check for too-large dun_bytes

Eric Dumazet (3):
      ipv6: make exception cache less predictible
      ipv4: make exception cache less predictible
      ipv4: fix endianness issue in inet_rtm_getroute_build_skb()

Evgeny Novikov (1):
      usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Frederic Weisbecker (1):
      posix-cpu-timers: Force next expiration recalc after itimer reset

Geert Uytterhoeven (4):
      m68k: Fix invalid RMW_INSNS on CPUs that lack CAS
      soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally
      arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties
      usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse

Giovanni Cabiddu (4):
      crypto: qat - do not ignore errors from enable_vf2pf_comms()
      crypto: qat - handle both source of interrupt in VF ISR
      crypto: qat - do not export adf_iov_putmsg()
      crypto: qat - use proper type for vf_mask

Greg Kroah-Hartman (1):
      Linux 5.13.17

Guoqing Jiang (1):
      raid1: ensure write behind bio has less than BIO_MAX_VECS sectors

Haiyue Wang (1):
      gve: fix the wrong AdminQ buffer overflow check

Halil Pasic (1):
      KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Hans de Goede (2):
      power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
      leds: trigger: audio: Add an activate callback to ensure the initial brightness is set

Harald Freudenberger (2):
      s390/zcrypt: fix wrong offset index for APKA master key valid state
      s390/ap: fix state machine hang after failure to enable irq

Harshvardhan Jha (1):
      drm/gma500: Fix end of loop tests for list_for_each_entry

He Fengqing (1):
      bpf: Fix potential memleak and UAF in the verifier.

Hongbo Li (1):
      lib/mpi: use kcalloc in mpi_resize

Huacai Chen (1):
      irqchip/loongson-pch-pic: Improve edge triggered interrupt support

Ilya Leoshkevich (1):
      selftests/bpf: Fix test_core_autosize on big-endian machines

J. Bruce Fields (1):
      nfsd4: Fix forced-expiry locking

Jaegeuk Kim (1):
      f2fs: guarantee to write dirty data when enabling checkpoint back

Jan Kara (1):
      udf: Check LVID earlier

Jens Axboe (4):
      io-wq: remove GFP_ATOMIC allocation off schedule out path
      io_uring: IORING_OP_WRITE needs hash_reg_file set
      io_uring: io_uring_complete() trace should take an integer
      io-wq: check max_worker limits if a worker transitions bound state

Jeongtae Park (1):
      regmap: fix the offset of register error log

Jiapeng Chong (2):
      leds: is31fl32xx: Fix missing error code in is31fl32xx_parse_dt()
      net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()

Joerg Roedel (1):
      x86/efi: Restore Firmware IDT before calling ExitBootServices()

John Fastabend (1):
      bpf, selftests: Fix test_maps now that sockmap supports UDP

Jose Blanquicet (1):
      selftests/bpf: Fix bpf-iter-tcp4 test to print correctly the dest IP

Judy Hsiao (1):
      arm64: dts: qcom: sc7180: Set adau wakeup delay to 80 ms

Juhee Kang (1):
      samples: pktgen: add missing IPv6 option to pktgen scripts

Julia Lawall (1):
      drm/of: free the right object

Jun Miao (1):
      Bluetooth: btusb: Fix a unspported condition to set available debug features

Justin M. Forbes (1):
      iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha

Kai Ye (2):
      crypto: hisilicon/sec - fix the abnormal exiting process
      crypto: hisilicon/sec - modify the hardware endian configuration

Kai-Heng Feng (2):
      drm/amdgpu/acp: Make PM domain really work
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kevin Mitchell (1):
      lkdtm: replace SCSI_DISPATCH_CMD with SCSI_QUEUE_RQ

Kim Phillips (1):
      perf/x86/amd/ibs: Extend PERF_PMU_CAP_NO_EXCLUDE to IBS Op

Krzysztof Hałasa (1):
      media: TDA1997x: enable EDID support

Krzysztof Kozlowski (1):
      arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7

Kuniyuki Iwashima (1):
      bpf: Fix a typo of reuseport map in bpf.h.

Kuogee Hsieh (2):
      drm/msm/dp: update is_connected status base on sink count at dp_pm_resume()
      drm/msm/dp: replug event is converted into an unplug followed by an plug events

Lars Poeschel (1):
      auxdisplay: hd44780: Fix oops on module unloading

Laurent Pinchart (1):
      drm: rcar-du: Don't put reference to drm_device in rcar_du_remove()

Len Baker (1):
      CIFS: Fix a potencially linear read overflow

Leon Romanovsky (5):
      ionic: cleanly release devlink instance
      net: ti: am65-cpsw-nuss: fix wrong devlink release order
      devlink: Break parameter notification sequence to be before/after unload/load driver
      devlink: Clear whole devlink_flash_notify struct
      net/mlx5: Remove all auxiliary devices at the unregister event

Linus Walleij (1):
      clk: kirkwood: Fix a clocking boot regression

Lukas Bulwahn (3):
      crypto: rmd320 - remove rmd320 in Makefile
      clk: staging: correct reference to config IOMEM to config HAS_IOMEM
      hwmon: remove amd_energy driver in Makefile

Lukas Hannen (1):
      time: Handle negative seconds correctly in timespec64_to_ns()

Lukasz Luba (1):
      PM: EM: Increase energy calculation precision

Mansur Alisha Shaik (1):
      media: venus: helper: do not set constrained parameters for UBWC

Maor Dickman (1):
      net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group

Marc Zyngier (1):
      KVM: arm64: Unregister HYP sections from kmemleak in protected mode

Marco Chiappero (2):
      crypto: qat - fix reuse of completion variable
      crypto: qat - fix naming for init/shutdown VF to PF notifications

Marek Vasut (3):
      drm: mxsfb: Enable recovery on underflow
      drm: mxsfb: Increase number of outstanding requests on V4 and newer HW
      drm: mxsfb: Clear FIFO_CLEAR bit

Martin Blumenstingl (1):
      ARM: dts: meson8: Use a higher default GPU clock frequency

Martin KaFai Lau (1):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Martynas Pumputis (1):
      libbpf: Fix removal of inner map in bpf_object__create_map

Matija Glavinic Pecotic (1):
      spi: davinci: invoke chipselect callback

Matthew Cover (1):
      bpf, samples: Add missing mprog-disable to xdp_redirect_cpu's optstring

Mauro Carvalho Chehab (1):
      media: rockchip/rga: use pm_runtime_resume_and_get()

Maxim Levitsky (1):
      KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation

Maxim Mikityanskiy (3):
      net/mlx5e: Prohibit inner indir TIRs in IPoIB
      net/mlx5e: Block LRO if firmware asks for tunneled LRO
      sch_htb: Fix inconsistency when leaf qdisc creation fails

Mian Yousaf Kaukab (1):
      crypto: ecc - handle unaligned input buffer in ecc_swap_digits

Mika Penttilä (1):
      sched/numa: Fix is_core_idle()

Miklos Szeredi (3):
      fuse: truncate pagecache on atomic_o_trunc
      fuse: flush extending writes
      fuse: wait for writepages in syncfs

Ming Lei (1):
      block: return ELEVATOR_DISCARD_MERGE if possible

Nadezda Lutovinova (1):
      usb: gadget: mv_u3d: request_irq() after initializing UDC

Naveen Mamindlapalli (1):
      octeontx2-pf: send correct vlan priority mask to npc_install_flow_req

Nguyen Dinh Phi (1):
      tty: Fix data race between tiocsti() and flush_to_ldisc()

Niklas Schnelle (2):
      s390/pci: fix misleading rc in clp_set_pci_fn()
      RDMA/mlx5: Fix number of allocated XLT entries

Pali Rohár (3):
      udf: Fix iocharset=utf8 mount option
      isofs: joliet: Fix iocharset=utf8 mount option
      arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

Paolo Bonzini (1):
      KVM: x86: clamp host mapping level to max_level in kvm_mmu_max_mapping_level

Parav Pandit (1):
      net/mlx5: Fix unpublish devlink parameters

Pavel Begunkov (3):
      io_uring: refactor io_submit_flush_completions()
      io_uring: limit fixed table size by RLIMIT_NOFILE
      bio: fix page leak bio_add_hw_page failure

Pavel Skripkin (6):
      m68k: emu: Fix invalid free in nfeth_cleanup()
      block: nbd: add sanity check for first_minor
      media: go7007: fix memory leak in go7007_usb_probe
      media: go7007: remove redundant initialization
      net: cipso: fix warnings in netlbl_cipsov4_add_std
      Bluetooth: add timeout sanity check to hci_inquiry

Peter Oberparleiter (2):
      s390/debug: keep debug data on resize
      s390/debug: fix debug area life cycle

Peter Robinson (1):
      power: supply: cw2015: use dev_err_probe to allow deferred probe

Peter Zijlstra (1):
      locking/mutex: Fix HANDOFF condition

Philipp Zabel (1):
      media: coda: fix frame_mem_ctrl for YUV420 and YVU420 formats

Phong Hoang (1):
      clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Qiuxu Zhuo (1):
      EDAC/i10nm: Fix NVDIMM detection

Quanyang Wang (1):
      spi: spi-zynq-qspi: use wait_for_completion_timeout to make zynq_qspi_exec_mem_op not interruptible

Quentin Monnet (1):
      tools: Free BTF objects at various locations

Quentin Perret (2):
      sched/deadline: Fix reset_on_fork reporting of DL tasks
      sched: Fix UCLAMP_FLAG_IDLE setting

Rafael J. Wysocki (2):
      PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently
      PCI: PM: Enable PME if it can be signaled from D3cold

Roi Dayan (1):
      net/mlx5e: Fix possible use-after-free deleting fdb rule

Ronnie Sahlberg (1):
      cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED

Ruozhu Li (2):
      nvme-tcp: don't update queue count when failing to set io queues
      nvme-rdma: don't update queue count when failing to set io queues

Sean Anderson (1):
      crypto: mxs-dcp - Check for DMA mapping errors

Sean Christopherson (3):
      Revert "KVM: x86: mmu: Add guest physical address check in translate_gpa()"
      KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU lpage stats
      KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: fix typo in MAx17042_TOFF

Sergey Senozhatsky (1):
      rcu/tree: Handle VM stoppage in stall detection

Sergey Shtylyov (16):
      i2c: highlander: add IRQ check
      usb: dwc3: meson-g12a: add IRQ check
      usb: dwc3: qcom: add IRQ check
      usb: gadget: udc: at91: add IRQ check
      usb: gadget: udc: s3c2410: add IRQ check
      usb: misc: brcmstb-usb-pinmap: add IRQ check
      usb: phy: fsl-usb: add IRQ check
      usb: phy: twl6030: add IRQ checks
      usb: host: ohci-tmio: add IRQ check
      usb: phy: tahvo: add IRQ check
      i2c: synquacer: fix deferred probing
      i2c: iop3xx: fix deferred probing
      i2c: s3c2410: fix IRQ check
      i2c: hix5hd2: fix IRQ check
      i2c: mt65xx: fix IRQ check
      i2c: xlp9xx: fix main IRQ check

Shengjiu Wang (1):
      ASoC: fsl_rpmsg: Check -EPROBE_DEFER for getting clocks

Shuyi Cheng (1):
      libbpf: Fix the possible memory leak on error

Smita Koralahalli (1):
      EDAC/mce_amd: Do not load edac_mce_amd module on guests

Stefan Assmann (1):
      i40e: improve locking of mac_filter_hash

Stefan Berger (2):
      certs: Trigger creation of RSA module signing key if it's not an RSA key
      tpm: ibmvtpm: Avoid error message when process gets signal while waiting

Stefan Wahren (1):
      net: qualcomm: fix QCA7000 checksum handling

Stephan Gerhold (1):
      soc: qcom: smsm: Fix missed interrupts if state changes while masked

Stephen Boyd (1):
      ASoC: rt5682: Implement remove callback

Steve French (1):
      smb3: fix posix extensions mount option

Steven Price (1):
      drm/of: free the iterator object on failure

Stian Skjelstad (1):
      udf_get_extendedattr() had no boundary checks.

Subbaraya Sundeep (4):
      octeontx2-af: cn10k: Fix SDP base channel number
      octeontx2-af: Fix loop in free and unmap counter
      octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
      octeontx2-af: Fix static code analyzer reported issues

Sudarsana Reddy Kalluru (1):
      atlantic: Fix driver resume flow.

Sunil Goutham (3):
      octeontx2-pf: Don't install VLAN offload rule if netdev is down
      octeontx2-pf: Fix algorithm index in MCAM rules with RSS action
      octeontx2-af: Set proper errorcode for IPv4 checksum errors

Sven Eckelmann (1):
      debugfs: Return error during {full/open}_proxy_open() on rmmod

Sven Peter (1):
      irqchip/apple-aic: Fix irq_disable from within irq handlers

THOBY Simon (1):
      IMA: remove the dependency on CRYPTO_MD5

Tedd Ho-Jeong An (1):
      Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd

Tetsuo Handa (1):
      fbmem: don't allow too huge resolutions

Thomas Gleixner (3):
      hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()
      hrtimer: Ensure timerfd notification for HIGHRES=n
      locking/local_lock: Add missing owner initialization

Tianjia Zhang (1):
      crypto: tcrypt - Fix missing return value check

Tony Lindgren (6):
      crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
      spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config
      spi: spi-pic32: Fix issue with uninitialized dma_slave_config
      mmc: sdhci: Fix issue with uninitialized dma_slave_config
      mmc: dw_mmc: Fix issue with uninitialized dma_slave_config
      mmc: moxart: Fix issue with uninitialized dma_slave_config

Valentin Schneider (3):
      sched/topology: Skip updating masks for non-online nodes
      sched/debug: Don't update sched_domain debug directories before sched_debug_init()
      PM: cpu: Make notifier chain use a raw_spinlock_t

Vignesh Raghavendra (1):
      net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()

Vineeth Vijayan (1):
      s390/cio: add dev_busid sysfs entry for each subchannel

Vladimir Oltean (4):
      net: dsa: stop syncing the bridge mcast_router attribute at join time
      net: dsa: mt7530: remove the .port_set_mrouter implementation
      net: dsa: don't disable multicast flooding to the CPU even without an IGMP querier
      net: phy: marvell10g: fix broken PHY interrupts for anyone after us in the driver probe list

Voon Weifeng (1):
      net: stmmac: fix INTR TBU status affecting irq count statistic

Waiman Long (3):
      cgroup/cpuset: Fix a partition bug with hotplug
      cgroup/cpuset: Miscellaneous code cleanup
      cgroup/cpuset: Fix violation of cpuset locking rule

Wei Yongjun (2):
      drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()
      media: omap3isp: Fix missing unlock in isp_subdev_notifier_complete()

William Breathitt Gray (1):
      counter: 104-quad-8: Return error when invalid mode during ceiling_write

Xiao Ni (1):
      md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard

Xiyu Yang (1):
      net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Xu Yu (1):
      mm/swap: consider max pages in iomap_swapfile_add_extent

Yanfei Xu (2):
      rcu: Fix to include first blocked task in stall warning
      rcu: Fix stall-warning deadlock due to non-release of rcu_node ->lock

Yang Yingliang (1):
      octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()

Yizhuo (1):
      media: atomisp: fix the uninitialized use and rename "retvalue"

Zelin Deng (1):
      KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Zenghui Yu (1):
      bcma: Fix memory leak for internally-handled cores

Zhang Qilong (2):
      ASoC: mediatek: mt8192:Fix Unbalanced pm_runtime_enable in mt8192_afe_pcm_dev_probe
      ASoC: mediatek: mt8183: Fix Unbalanced pm_runtime_enable in mt8183_afe_pcm_dev_probe

Zhen Lei (4):
      genirq/timings: Fix error return code in irq_timings_test_irqs()
      firmware: fix theoretical UAF race with firmware cache and resume
      driver core: Fix error return code in really_probe()
      media: venus: hfi: fix return value check in sys_get_prop_image_version()

