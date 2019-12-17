Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991AD1237CB
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfLQUl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbfLQUl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:41:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40452176D;
        Tue, 17 Dec 2019 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576615315;
        bh=AB3YmsSErHWTEEfXyAh6/VbNbvZ2paEliwQDgYGilbc=;
        h=Date:From:To:Cc:Subject:From;
        b=Fg54F/W2Xi49BbkgmsWceUGvl0j3yVLad/axelEDFppO1/iJgf6cJl1EFDhvvppTp
         EnidgE2CWiDEL6z1LI7CMKusdp7Sg2Ps/xaGvKnAT6xAQ0FoUgawPopIWsmIGShXnC
         8y5mR3p2E5P40N18jkeMk4+qBxCj/rZaT4w8+yB0=
Date:   Tue, 17 Dec 2019 21:41:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.159
Message-ID: <20191217204153.GA4153250@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.159 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt              |   22 +-
 Documentation/devicetree/bindings/rtc/abracon,abx80x.txt     |    2=20
 Makefile                                                     |   13 -
 arch/arm/Kconfig.debug                                       |   23 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts                    |    4=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts                    |    4=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                      |    5=20
 arch/arm/boot/dts/exynos3250.dtsi                            |    2=20
 arch/arm/boot/dts/mmp2.dtsi                                  |    2=20
 arch/arm/boot/dts/omap3-pandora-common.dtsi                  |   36 ++++
 arch/arm/boot/dts/omap3-tao3530.dtsi                         |    2=20
 arch/arm/boot/dts/pxa27x.dtsi                                |    2=20
 arch/arm/boot/dts/pxa2xx.dtsi                                |    7=20
 arch/arm/boot/dts/pxa3xx.dtsi                                |    2=20
 arch/arm/boot/dts/rk3288-rock2-som.dtsi                      |    2=20
 arch/arm/boot/dts/rv1108.dtsi                                |   10 -
 arch/arm/boot/dts/sun5i-a10s.dtsi                            |    2=20
 arch/arm/boot/dts/sun6i-a31.dtsi                             |    2=20
 arch/arm/boot/dts/sun7i-a20.dtsi                             |    2=20
 arch/arm/boot/dts/sun8i-v3s-licheepi-zero.dts                |    4=20
 arch/arm/boot/dts/sun8i-v3s.dtsi                             |   10 -
 arch/arm/include/asm/uaccess.h                               |   18 ++
 arch/arm/lib/getuser.S                                       |   11 +
 arch/arm/lib/putuser.S                                       |   20 +-
 arch/arm/mach-omap1/id.c                                     |    6=20
 arch/arm/mach-omap2/id.c                                     |    4=20
 arch/arm/mach-omap2/pdata-quirks.c                           |   93 ------=
-----
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts         |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts          |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts   |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts |    4=20
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi               |    2=20
 arch/mips/Kconfig                                            |    1=20
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c           |    2=20
 arch/mips/cavium-octeon/octeon-platform.c                    |    2=20
 arch/mips/include/asm/octeon/cvmx-pko.h                      |    2=20
 arch/powerpc/include/asm/sfp-machine.h                       |   92 +++---=
----
 arch/powerpc/include/asm/vdso_datapage.h                     |    2=20
 arch/powerpc/kernel/Makefile                                 |    4=20
 arch/powerpc/kernel/asm-offsets.c                            |    2=20
 arch/powerpc/kernel/misc_64.S                                |    4=20
 arch/powerpc/kernel/time.c                                   |    1=20
 arch/powerpc/kernel/vdso32/gettimeofday.S                    |    7=20
 arch/powerpc/kernel/vdso64/cacheflush.S                      |    4=20
 arch/powerpc/kernel/vdso64/gettimeofday.S                    |    7=20
 arch/powerpc/sysdev/xive/common.c                            |    9 +
 arch/powerpc/sysdev/xive/spapr.c                             |   12 +
 arch/powerpc/xmon/Makefile                                   |    4=20
 arch/s390/include/asm/pgtable.h                              |    4=20
 arch/sparc/net/bpf_jit_comp_64.c                             |   12 +
 arch/x86/kernel/cpu/mcheck/mce.c                             |   30 ---
 arch/x86/kernel/cpu/mcheck/mce_amd.c                         |   36 ++++
 arch/x86/kvm/cpuid.c                                         |    5=20
 arch/x86/kvm/x86.c                                           |   14 +
 arch/x86/pci/fixup.c                                         |   11 +
 block/blk-merge.c                                            |    2=20
 block/blk-mq-sysfs.c                                         |   15 +
 crypto/af_alg.c                                              |    2=20
 crypto/crypto_user.c                                         |    4=20
 crypto/ecc.c                                                 |   45 +++--
 drivers/acpi/bus.c                                           |    2=20
 drivers/acpi/device_pm.c                                     |   12 +
 drivers/acpi/osl.c                                           |   28 ++-
 drivers/android/binder_alloc.c                               |    8=20
 drivers/block/drbd/drbd_state.c                              |    6=20
 drivers/block/drbd/drbd_state.h                              |    3=20
 drivers/block/rsxx/core.c                                    |    2=20
 drivers/char/hw_random/omap-rng.c                            |    9 -
 drivers/char/ppdev.c                                         |   16 +
 drivers/char/tpm/tpm2-cmd.c                                  |    4=20
 drivers/clk/renesas/r8a77995-cpg-mssr.c                      |    4=20
 drivers/clk/rockchip/clk-rk3188.c                            |    8=20
 drivers/clk/rockchip/clk-rk3328.c                            |    2=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                        |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                          |    2=20
 drivers/cpufreq/powernv-cpufreq.c                            |   17 +-
 drivers/cpuidle/driver.c                                     |   15 -
 drivers/crypto/amcc/crypto4xx_core.c                         |    6=20
 drivers/crypto/bcm/cipher.c                                  |    6=20
 drivers/crypto/ccp/ccp-dmaengine.c                           |    1=20
 drivers/devfreq/devfreq.c                                    |   12 +
 drivers/dma/coh901318.c                                      |    5=20
 drivers/dma/dw/core.c                                        |    2=20
 drivers/dma/dw/platform.c                                    |    6=20
 drivers/dma/dw/regs.h                                        |    4=20
 drivers/extcon/extcon-max8997.c                              |   10 -
 drivers/firmware/qcom_scm-64.c                               |    2=20
 drivers/gpio/gpiolib-acpi.c                                  |   17 ++
 drivers/gpu/drm/i810/i810_dma.c                              |    4=20
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c          |   21 +-
 drivers/hwtracing/intel_th/core.c                            |    8=20
 drivers/hwtracing/intel_th/pci.c                             |   10 +
 drivers/i2c/busses/i2c-imx.c                                 |    3=20
 drivers/i2c/i2c-core-of.c                                    |    4=20
 drivers/iio/humidity/hdc100x.c                               |    2=20
 drivers/iio/imu/adis16480.c                                  |    1=20
 drivers/infiniband/hw/hfi1/chip.c                            |   47 +++++
 drivers/infiniband/hw/hfi1/vnic_sdma.c                       |   15 -
 drivers/infiniband/hw/hns/hns_roce_hem.h                     |    2=20
 drivers/infiniband/hw/mlx4/sysfs.c                           |   12 -
 drivers/infiniband/hw/qib/qib_sysfs.c                        |    6=20
 drivers/input/joystick/psxpad-spi.c                          |    2=20
 drivers/input/mouse/synaptics.c                              |    1=20
 drivers/input/rmi4/rmi_f34v7.c                               |    3=20
 drivers/input/rmi4/rmi_smbus.c                               |    2=20
 drivers/input/touchscreen/cyttsp4_core.c                     |    7=20
 drivers/input/touchscreen/goodix.c                           |    9 +
 drivers/isdn/gigaset/usb-gigaset.c                           |   23 ++
 drivers/md/dm-zoned-metadata.c                               |   29 ++-
 drivers/md/dm-zoned-reclaim.c                                |    8=20
 drivers/md/dm-zoned-target.c                                 |   54 ++++--
 drivers/md/dm-zoned.h                                        |    2=20
 drivers/md/raid0.c                                           |    2=20
 drivers/md/raid5.c                                           |    2=20
 drivers/media/cec/cec-adap.c                                 |    7=20
 drivers/media/platform/qcom/venus/vdec.c                     |    3=20
 drivers/media/platform/qcom/venus/venc.c                     |    3=20
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                |    3=20
 drivers/media/platform/vimc/vimc-common.c                    |    2=20
 drivers/media/platform/vimc/vimc-core.c                      |    7=20
 drivers/media/radio/radio-wl1273.c                           |    3=20
 drivers/media/usb/pulse8-cec/pulse8-cec.c                    |    2=20
 drivers/media/usb/stkwebcam/stk-webcam.c                     |    6=20
 drivers/misc/altera-stapl/altera.c                           |    3=20
 drivers/mmc/host/omap_hsmmc.c                                |   30 +++
 drivers/mtd/devices/spear_smi.c                              |   38 ++++
 drivers/net/can/slcan.c                                      |    1=20
 drivers/net/dsa/mv88e6xxx/chip.c                             |   21 +-
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h              |    4=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c              |    2=20
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c          |    6=20
 drivers/net/ethernet/cirrus/ep93xx_eth.c                     |    5=20
 drivers/net/ethernet/huawei/hinic/hinic_main.c               |    7=20
 drivers/net/ethernet/intel/e100.c                            |    4=20
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c               |   10 -
 drivers/net/ethernet/mellanox/mlx4/main.c                    |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                 |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c        |   78 ++++++=
++-
 drivers/net/ethernet/ti/cpts.c                               |    4=20
 drivers/net/wireless/ath/ar5523/ar5523.c                     |    3=20
 drivers/net/wireless/ath/ath10k/pci.c                        |    9 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c            |   15 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                 |   10 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c            |   20 --
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c          |    9 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c          |    1=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c         |   25 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h         |    2=20
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                      |    1=20
 drivers/nfc/nxp-nci/i2c.c                                    |    6=20
 drivers/of/unittest.c                                        |    4=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                     |    5=20
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c                     |   23 ++
 drivers/pinctrl/samsung/pinctrl-exynos.c                     |    4=20
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c                    |    6=20
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c                    |    6=20
 drivers/pinctrl/samsung/pinctrl-samsung.c                    |   10 -
 drivers/power/supply/cpcap-battery.c                         |   11 -
 drivers/rtc/rtc-max8997.c                                    |    2=20
 drivers/rtc/rtc-s3c.c                                        |    6=20
 drivers/s390/scsi/zfcp_dbf.c                                 |    8=20
 drivers/s390/scsi/zfcp_erp.c                                 |    3=20
 drivers/scsi/lpfc/lpfc.h                                     |    3=20
 drivers/scsi/lpfc/lpfc_attr.c                                |   12 +
 drivers/scsi/lpfc/lpfc_init.c                                |    3=20
 drivers/scsi/lpfc/lpfc_nvme.c                                |    2=20
 drivers/scsi/lpfc/lpfc_sli.c                                 |   14 -
 drivers/scsi/qla2xxx/qla_attr.c                              |    3=20
 drivers/scsi/qla2xxx/qla_bsg.c                               |   15 +
 drivers/scsi/qla2xxx/qla_init.c                              |    2=20
 drivers/scsi/qla2xxx/qla_isr.c                               |    6=20
 drivers/scsi/qla2xxx/qla_target.c                            |   11 -
 drivers/spi/spi-atmel.c                                      |    6=20
 drivers/staging/iio/addac/adt7316-i2c.c                      |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                  |    2=20
 drivers/staging/rtl8712/usb_intf.c                           |    2=20
 drivers/thermal/thermal_core.c                               |    4=20
 drivers/tty/n_hdlc.c                                         |    4=20
 drivers/tty/n_r3964.c                                        |    2=20
 drivers/tty/n_tty.c                                          |    8=20
 drivers/tty/serial/amba-pl011.c                              |    6=20
 drivers/tty/serial/fsl_lpuart.c                              |    4=20
 drivers/tty/serial/ifx6x60.c                                 |    3=20
 drivers/tty/serial/imx.c                                     |    2=20
 drivers/tty/serial/msm_serial.c                              |    6=20
 drivers/tty/serial/serial_core.c                             |    2=20
 drivers/tty/tty_ldisc.c                                      |    7=20
 drivers/tty/vt/keyboard.c                                    |    2=20
 drivers/usb/atm/ueagle-atm.c                                 |   18 +-
 drivers/usb/core/hub.c                                       |    5=20
 drivers/usb/core/urb.c                                       |    1=20
 drivers/usb/dwc3/core.c                                      |    3=20
 drivers/usb/dwc3/debug.h                                     |   29 +++
 drivers/usb/dwc3/debugfs.c                                   |   19 ++
 drivers/usb/dwc3/ep0.c                                       |    8=20
 drivers/usb/gadget/configfs.c                                |    1=20
 drivers/usb/gadget/function/u_serial.c                       |    2=20
 drivers/usb/gadget/udc/pch_udc.c                             |    1=20
 drivers/usb/host/xhci-hub.c                                  |    8=20
 drivers/usb/host/xhci-mem.c                                  |    4=20
 drivers/usb/host/xhci-pci.c                                  |   13 +
 drivers/usb/host/xhci-ring.c                                 |    3=20
 drivers/usb/host/xhci.c                                      |    9 -
 drivers/usb/host/xhci.h                                      |    1=20
 drivers/usb/misc/adutux.c                                    |    2=20
 drivers/usb/misc/idmouse.c                                   |    2=20
 drivers/usb/mon/mon_bin.c                                    |   32 ++-
 drivers/usb/mtu3/mtu3_qmu.c                                  |    2=20
 drivers/usb/serial/io_edgeport.c                             |   10 -
 drivers/usb/storage/uas.c                                    |   10 +
 drivers/video/hdmi.c                                         |    8=20
 drivers/virtio/virtio_balloon.c                              |   11 +
 drivers/watchdog/aspeed_wdt.c                                |   16 +
 fs/autofs4/expire.c                                          |    5=20
 fs/btrfs/delayed-inode.c                                     |   13 +
 fs/btrfs/file.c                                              |    2=20
 fs/btrfs/free-space-cache.c                                  |    6=20
 fs/btrfs/inode.c                                             |    3=20
 fs/btrfs/send.c                                              |   25 ++
 fs/btrfs/volumes.h                                           |    1=20
 fs/cifs/file.c                                               |    7=20
 fs/cifs/smb2misc.c                                           |    7=20
 fs/dlm/lockspace.c                                           |    1=20
 fs/dlm/member.c                                              |    2=20
 fs/dlm/memory.c                                              |    9 -
 fs/dlm/user.c                                                |    3=20
 fs/exportfs/expfs.c                                          |   31 ++-
 fs/ext2/inode.c                                              |    7=20
 fs/ext4/inode.c                                              |   25 ++
 fs/ext4/namei.c                                              |   11 -
 fs/f2fs/file.c                                               |    2=20
 fs/f2fs/gc.c                                                 |   10 -
 fs/fuse/dir.c                                                |   27 ++-
 fs/fuse/fuse_i.h                                             |    2=20
 fs/gfs2/log.c                                                |    8=20
 fs/gfs2/log.h                                                |    1=20
 fs/gfs2/lops.c                                               |    5=20
 fs/gfs2/trans.c                                              |    2=20
 fs/iomap.c                                                   |   18 +-
 fs/kernfs/dir.c                                              |    5=20
 fs/lockd/clnt4xdr.c                                          |   22 --
 fs/lockd/clntxdr.c                                           |   22 --
 fs/nfsd/nfs4recover.c                                        |   17 --
 fs/nfsd/vfs.c                                                |   17 +-
 fs/ocfs2/quota_global.c                                      |    2=20
 fs/overlayfs/dir.c                                           |    2=20
 fs/pstore/ram.c                                              |    2=20
 fs/quota/dquot.c                                             |   11 -
 fs/reiserfs/inode.c                                          |   12 +
 fs/reiserfs/namei.c                                          |    7=20
 fs/reiserfs/reiserfs.h                                       |    2=20
 fs/reiserfs/super.c                                          |    2=20
 fs/reiserfs/xattr.c                                          |   19 +-
 fs/reiserfs/xattr_acl.c                                      |    4=20
 include/dt-bindings/clock/rk3328-cru.h                       |    2=20
 include/linux/acpi.h                                         |    2=20
 include/linux/atalk.h                                        |    2=20
 include/linux/dma-mapping.h                                  |    3=20
 include/linux/jbd2.h                                         |    4=20
 include/linux/kernfs.h                                       |    1=20
 include/linux/mfd/rk808.h                                    |    2=20
 include/linux/mtd/mtd.h                                      |    2=20
 include/linux/platform_data/dma-dw.h                         |    6=20
 include/linux/qcom_scm.h                                     |    3=20
 include/linux/quotaops.h                                     |   10 +
 include/linux/regulator/consumer.h                           |    2=20
 include/linux/serial_core.h                                  |   37 ++++
 include/linux/tty.h                                          |    7=20
 include/math-emu/soft-fp.h                                   |    2=20
 include/uapi/linux/cec.h                                     |    4=20
 kernel/audit_watch.c                                         |    2=20
 kernel/cgroup/pids.c                                         |   11 -
 kernel/module.c                                              |    2=20
 kernel/sched/core.c                                          |    3=20
 kernel/sched/fair.c                                          |   36 ++--
 kernel/workqueue.c                                           |   38 +++-
 lib/raid6/unroll.awk                                         |    2=20
 mm/shmem.c                                                   |    2=20
 mm/vmstat.c                                                  |    7=20
 net/appletalk/aarp.c                                         |   15 +
 net/appletalk/ddp.c                                          |   21 +-
 net/ipv4/tcp_output.c                                        |    2=20
 net/ipv4/tcp_timer.c                                         |   20 +-
 net/smc/smc_wr.c                                             |    4=20
 net/sunrpc/cache.c                                           |    6=20
 net/x25/af_x25.c                                             |   18 +-
 net/xfrm/xfrm_input.c                                        |    3=20
 scripts/mod/modpost.c                                        |   12 +
 sound/core/oss/linear.c                                      |    2=20
 sound/core/oss/mulaw.c                                       |    2=20
 sound/core/oss/route.c                                       |    2=20
 sound/core/pcm_lib.c                                         |    8=20
 sound/pci/hda/hda_bind.c                                     |    4=20
 sound/pci/hda/hda_intel.c                                    |    3=20
 sound/pci/hda/patch_conexant.c                               |    1=20
 sound/pci/hda/patch_realtek.c                                |    7=20
 sound/soc/codecs/nau8540.c                                   |    2=20
 sound/soc/sh/rcar/core.c                                     |   12 +
 sound/soc/soc-jack.c                                         |    3=20
 virt/kvm/arm/vgic/vgic-v3.c                                  |    6=20
 301 files changed, 1736 insertions(+), 947 deletions(-)

Aaro Koskinen (3):
      MIPS: OCTEON: octeon-platform: fix typing
      ARM: OMAP1/2: fix SoC name printing
      MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible defi=
nition

Al Viro (3):
      autofs: fix a leak in autofs_expire_indirect()
      exportfs_decode_fh(): negative pinned may become positive without the=
 parent locked
      audit_get_nd(): don't unlock parent too early

Alastair D'Silva (2):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges=
 >4GB
      powerpc: Allow flush_icache_range to work across ranges >4GB

Aleksa Sarai (1):
      cgroup: pids: use atomic64_t for pids->limit

Alexander Shishkin (3):
      intel_th: Fix a double put_device() in error path
      intel_th: pci: Add Ice Lake CPU support
      intel_th: pci: Add Tiger Lake CPU support

Alexey Dobriyan (1):
      ACPI: fix acpi_find_child_device() invocation in acpi_preset_companio=
n()

Amir Goldstein (1):
      ovl: relax WARN_ON() on rename to self

Andreas Pape (1):
      media: stkwebcam: Bugfix for wrong return values

Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Work around mv886e6161 SERDES missing MII_PHYSID2

Ard Biesheuvel (1):
      crypto: ecdh - fix big endian bug in ECC library

Arjun Vynipadath (1):
      cxgb4vf: fix memleak in mac_hlist initialization

Arnd Bergmann (2):
      media: venus: remove invalid compat_ioctl32 handler
      ppdev: fix PPGETTIME/PPSETTIME ioctls

Ayush Sawal (1):
      crypto: af_alg - cast ki_complete ternary op to int

Bart Van Assche (3):
      scsi: qla2xxx: Fix session lookup in qlt_abort_work()
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return =
value

Baruch Siach (1):
      rtc: dt-binding: abx80x: fix resistance scale

Bob Peterson (1):
      gfs2: fix glock reference problem in gfs2_trans_remove_revoke

Brian Masney (1):
      pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Brian Norris (1):
      usb: dwc3: don't log probe deferrals; but do log other error codes

Chen Jun (1):
      mm/shmem.c: cast the type of unmap_start to u64

Chen-Yu Tsai (1):
      clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent

Chengguang Xu (1):
      ext2: check err when partial !=3D NULL

Chris Lesiak (1):
      iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Christian Lamparter (2):
      dmaengine: dw-dmac: implement dma protection control setting
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      rtc: max8997: Fix the returned value in case of error in 'max8997_rtc=
_read_alarm()'

Chuhong Yuan (3):
      serial: ifx6x60: add missed pm_runtime_disable
      rsxx: add missed destroy_workqueue calls in remove
      net: ep93xx_eth: fix mismatch of request_mem_region in remove

Cl=C3=A9ment P=C3=A9ron (1):
      ARM: debug: enable UART1 for socfpga Cyclone5

Colin Ian King (1):
      altera-stapl: check for a null key before strcasecmp'ing it

C=C3=A9dric Le Goater (2):
      powerpc/xive: Prevent page fault issues in the machine crash handler
      powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts

Dan Carpenter (2):
      drm/i810: Prevent underflow in ioctl
      md/raid0: Fix an error message in raid0_make_request()

Daniel Mack (1):
      ARM: dts: pxa: clean up USB controller nodes

Daniel Schultz (1):
      mfd: rk808: Fix RK818 ID template

Dave Chinner (1):
      iomap: sub-block dio needs to zeroout beyond EOF

David Hildenbrand (1):
      virtio-balloon: fix managed page counts when migrating pages between =
zones

David Miller (1):
      sparc: Correct ctx->saw_frame_pointer logic.

David Teigland (2):
      dlm: fix missing idr_destroy for recover_idr
      dlm: fix invalid cluster name warning

Denis Efremov (1):
      ar5523: check NULL before memcpy() in ar5523_cmd()

Denis V. Lunev (1):
      dlm: fix possible call to kfree() for non-initialized pointer

Dmitry Bogdanov (1):
      net: aquantia: fix RSS table and key sizes

Dmitry Fomichev (1):
      dm zoned: reduce overhead of backing device checks

Dmitry Monakhov (2):
      quota: Check that quota is not dirty before release
      quota: fix livelock in dquot_writeback_dquots

Dmitry Safonov (1):
      tty: Don't block on IO when ldisc change is pending

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Douglas Anderson (1):
      serial: core: Allow processing sysrq at port unlock time

Emiliano Ingrassia (1):
      usb: core: urb: fix URB structure initialization function

Eran Ben Elisha (1):
      net/mlx5e: Fix SFF 8472 eeprom length

Erez Alfasi (1):
      net/mlx4_core: Fix return codes of unsupported operations

Erhard Furtner (1):
      of: unittest: fix memory leak in attach_node_and_children

Eric Dumazet (1):
      tcp: exit if nothing to retransmit on RTO timeout

Filipe Manana (2):
      Btrfs: fix negative subv_writers counter and data space leak after bu=
ffered write
      Btrfs: send, skip backreference walking for extents with many referen=
ces

Finley Xiao (1):
      clk: rockchip: fix rk3188 sclk_smc gate data

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c

Geert Uytterhoeven (1):
      clk: renesas: r8a77995: Correct parent clock of DU

Gerald Schaefer (1):
      s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported

Greg Kroah-Hartman (2):
      lib: raid6: fix awk build warnings
      Linux 4.14.159

Gregory CLEMENT (1):
      spi: atmel: Fix CS high support

Guoqing Jiang (1):
      raid5: need to set STRIPE_HANDLE for batch head

Gustavo A. R. Silva (1):
      usb: gadget: pch_udc: fix use after free

H. Nikolaus Schaller (3):
      ARM: dts: pandora-common: define wl1251 as child node of mmc3
      mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid=
 of pandora_wl1251_init_card
      omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Hans Verkuil (5):
      media: pulse8-cec: return 0 when invalidating the logical address
      media: cec: report Vendor ID after initialization
      Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus
      Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers
      media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Hans de Goede (2):
      Input: goodix - add upside-down quirk for Teclast X89 tablet
      gpiolib: acpi: Add Terra Pad 1061 to the run_edge_events_on_boot_blac=
klist

Heiko Stuebner (1):
      clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Helen Fornazier (1):
      media: vimc: fix start stream when link is disabled

Helen Koike (1):
      media: vimc: fix component match compare

Henry Lin (1):
      usb: xhci: only set D3hot for pci device

Himanshu Madhani (2):
      scsi: qla2xxx: Fix DMA unmap leak
      scsi: qla2xxx: Fix message indicating vectors used by driver

Ido Schimmel (1):
      mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpts: correct debug for expired txq skb

J. Bruce Fields (1):
      lockd: fix decoding of TEST results

Jagan Teki (1):
      clk: sunxi-ng: a64: Fix gate bit of DSI DPHY

James Smart (2):
      scsi: lpfc: Cap NPIV vports to 256
      scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE

Jan Kara (3):
      jbd2: Fix possible overflow in jbd2_log_space_left()
      iomap: Fix pipe page leakage during splicing
      ext4: Fix credit estimate for final inode freeing

Jann Horn (1):
      binder: Handle start=3D=3DNULL in binder_update_page_range()

Janne Huttunen (1):
      mm/vmstat.c: fix NUMA statistics updates

Jarkko Nikula (1):
      ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polari=
ty

Jeff Mahoney (1):
      reiserfs: fix extended attributes on the root directory

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control

Jia-Ju Bai (1):
      dmaengine: coh901318: Fix a double-lock bug

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops

Joel Stanley (2):
      powerpc/math-emu: Update macros from GCC
      watchdog: aspeed: Fix clock behaviour for ast2600

Johan Hovold (11):
      staging: rtl8188eu: fix interface sanity check
      staging: rtl8712: fix interface sanity check
      staging: gigaset: fix general protection fault on probe
      staging: gigaset: fix illegal free on probe errors
      staging: gigaset: add endpoint-type sanity check
      USB: atm: ueagle-atm: add missing endpoint check
      USB: idmouse: fix interface sanity checks
      USB: serial: io_edgeport: fix epic endpoint lookup
      USB: adutux: fix interface sanity check
      media: bdisp: fix memleak on release
      media: radio: wl1273: fix interrupt masking on release

Johannes Berg (1):
      iwlwifi: mvm: synchronize TID queue removal

John Hubbard (1):
      cpufreq: powernv: fix stack bloat and hard limit on number of CPUs

John Keeping (1):
      ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name

Jon Hunter (1):
      arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Jonathan Marek (1):
      firmware: qcom: scm: fix compilation error when disabled

Josef Bacik (3):
      btrfs: check page->mapping when loading free space cache
      btrfs: use refcount_inc_not_zero in kill_all_nodes
      btrfs: record all roots for rename exchange on a subvol

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Kai-Heng Feng (4):
      ALSA: hda - Add mute led support for HP ProBook 645 G4
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
      usb: Allow USB device to be warm reset in suspended state
      xhci: Increase STS_HALT timeout in xhci_suspend()

Kaike Wan (1):
      IB/hfi1: Ignore LNI errors before DC8051 transitions to Polling state

Kailang Yang (1):
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Katsuhiro Suzuki (2):
      clk: rockchip: fix I2S1 clock gate register for rk3328
      clk: rockchip: fix ID of 8ch clock of I2S1 for rk3328

Kees Cook (1):
      pstore/ram: Avoid NULL deref in ftrace merging failure path

Konstantin Khorenko (1):
      kernel/module.c: wakeup processes in module_wq on module unload

Krzysztof Kozlowski (3):
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup co=
ntroller init
      pinctrl: samsung: Fix device node refcount leaks in init code
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup co=
ntroller init

Kuninori Morimoto (2):
      ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()
      ASoC: rsnd: fixup MIX kctrl registration

Larry Finger (3):
      rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address
      rtlwifi: rtl8192de: Fix missing callback that tests for hw release of=
 buffer
      rtlwifi: rtl8192de: Fix missing enable interrupt flag

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show

Lubomir Rintel (1):
      ARM: dts: mmp2: fix the gpio interrupt cell number

Lucas Stach (2):
      i2c: imx: don't print error message on probe defer
      Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Maciej W. Rozycki (1):
      MIPS: SiByte: Enable ZONE_DMA32 for LittleSur

Marek Szyprowski (3):
      extcon: max8997: Fix lack of path setting in USB device mode
      rtc: s3c-rtc: Avoid using broken ALMYEAR register
      ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module

Mark Brown (1):
      regulator: Fix return value of _set_load() stub

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Martin Schiller (2):
      net/x25: fix called/calling length calculation in x25_parse_address_b=
lock
      net/x25: fix null_x25_address handling

Masahiro Yamada (1):
      kbuild: fix single target build for external module

Mathias Nyman (2):
      xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behavi=
our.
      xhci: make sure interrupts are restored to correct state

Maxime Ripard (2):
      ARM: dts: sun5i: a10s: Fix HDMI output DTC warning
      ARM: dts: sun8i: v3s: Change pinctrl nodes to avoid warning

Miaoqing Pan (1):
      ath10k: fix fw crash by moving chip reset after napi disabled

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Mika Westerberg (1):
      xhci: Fix memory leak in xhci_add_in_port()

Mike Leach (1):
      coresight: etm4x: Fix input validation for sysfs.

Mike Marciniszyn (1):
      IB/hfi1: Close VNIC sdma_progress sleep window

Miklos Szeredi (2):
      fuse: verify nlink
      fuse: verify attributes

Ming Lei (3):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
      block: fix single range discard merge
      blk-mq: make sure that line break can be printed

Miquel Raynal (2):
      mtd: fix mtd_oobavail() incoherent returned value
      mtd: spear_smi: Fix Write Burst mode

Mitch Williams (1):
      i40e: don't restart nway if autoneg not supported

Moni Shoua (1):
      net/mlx5: Release resource on error flow

Mordechay Goodstein (1):
      iwlwifi: pcie: don't consider IV len in A-MSDU

Nathan Chancellor (2):
      drbd: Change drbd_request_detach_interruptible's return type to int
      powerpc: Avoid clang warnings around setjmp and longjmp

Navid Emamdoost (3):
      rsi: release skb if rsi_prepare_beacon fails
      Input: Fix memory leak in psxpad_spi_probe
      crypto: user - fix memory leak in crypto_report

Neil Armstrong (4):
      arm64: dts: meson-gxl-libretech-cc: fix GPIO lines names
      arm64: dts: meson-gxbb-nanopi-k2: fix GPIO lines names
      arm64: dts: meson-gxbb-odroidc2: fix GPIO lines names
      arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names

Niklas S=C3=B6derlund (1):
      dma-mapping: fix return type of dma_set_max_seg_size()

Nir Dotan (1):
      mlxsw: spectrum_router: Relax GRE decap matching check

Nishka Dasgupta (1):
      pinctrl: samsung: Add of_node_put() before return in error path

Nuno S=C3=A1 (1):
      iio: adis16480: Add debugfs_reg_access entry

Oliver Neukum (3):
      USB: uas: honor flag to avoid CAPACITY16
      USB: uas: heed CAPACITY_HEURISTICS
      USB: documentation: flags on usb-storage versus UAS

Otavio Salvador (2):
      ARM: dts: rockchip: Fix the PMU interrupt number for rv1108
      ARM: dts: rockchip: Assign the proper GPIO clocks for rv1108

Pan Bian (1):
      Input: cyttsp4_core - fix use after free bug

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019=
-19332)

Paul Walmsley (1):
      modpost: skip ELF local symbols during section mismatch check

Pavel Shilovsky (2):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
      CIFS: Fix SMB2 oplock break processing

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Peng Fan (1):
      tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Pete Zaitcev (1):
      usb: mon: Fix a deadlock in usbmon between mmap and read

Peter Zijlstra (1):
      sched/core: Avoid spurious lock dependencies

Qian Cai (1):
      mlx4: Use snprintf instead of complicated strcpy

Qu Wenruo (1):
      btrfs: Remove btrfs_bio::flags member

Quinn Tran (1):
      scsi: qla2xxx: Fix driver unload hang

Rafael J. Wysocki (1):
      ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Raveendra Padasalagi (1):
      crypto: bcm - fix normal/non key hash algorithm failure

Rob Herring (3):
      ARM: dts: realview-pbx: Fix duplicate regulator nodes
      ARM: dts: realview: Fix some more duplicate regulator nodes
      ARM: dts: sunxi: Fix PMU compatible strings

Sahitya Tummala (1):
      f2fs: fix to allow node segment for GC by ioctl path

Scott Mayhew (1):
      nfsd: fix a warning in __cld_pipe_upcall()

Shirish S (2):
      x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
      x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shreeya Patel (1):
      Staging: iio: adt7316: Fix i2c data reading, set the data field

Sirong Wang (1):
      RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Stefan Agner (1):
      serial: imx: fix error handling in console_setup

Steffen Maier (2):
      scsi: zfcp: drop default switch case which might paper over missing c=
ase
      scsi: zfcp: trace channel log even for FCP command responses

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication er=
ror

Sumit Garg (1):
      hwrng: omap - Fix RNG wait loop timeout

Tadeusz Struk (1):
      tpm: add check after commands attribs tab allocation

Takashi Iwai (2):
      ALSA: pcm: oss: Avoid potential buffer overflows
      ALSA: hda - Fix pending unsol events at shutdown

Tejun Heo (4):
      kernfs: fix ino wrap-around detection
      workqueue: Fix spurious sanity check failures in destroy_workqueue()
      workqueue: Fix pwq ref leak in rescuer_thread()
      workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink =3D=3D 0 safely

Thinh Nguyen (2):
      usb: dwc3: debugfs: Properly print/set link state for HS
      usb: dwc3: ep0: Clear started flag on completion

Tony Lindgren (1):
      power: supply: cpcap-battery: Fix signed counter sample register

Ursula Braun (1):
      net/smc: use after free fix in smc_wr_tx_put_slot()

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Ville Syrj=C3=A4l=C3=A4 (1):
      video/hdmi: Fix AVI bar unpack

Vincent Chen (1):
      math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Vincent Whitchurch (2):
      serial: pl011: Fix DMA ->flush_buffer()
      ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()

Vinod Koul (1):
      dmaengine: coh901318: Remove unused variable

Viresh Kumar (1):
      RDMA/qib: Validate ->show()/store() callbacks before calling them

Vitaly Chikunov (1):
      crypto: ecc - check for invalid values in the key verification test

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Wei Yongjun (1):
      usb: gadget: configfs: Fix missing spin_lock_init()

Wen Yang (2):
      i2c: core: fix use after free in of_i2c_notify
      dlm: NULL check before kmem_cache_destroy is not needed

Will Deacon (1):
      firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Xiaodong Xu (1):
      xfrm: release device reference for invalid state

Xue Chaojing (1):
      net-next/hinic:fix a bug in set mac address

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/per=
iod ratio precision

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Young_X (1):
      ASoC: au8540: use 64-bit arithmetic instead of 32-bit

Yuchung Cheng (3):
      tcp: fix off-by-one bug on aborting window-probing socket
      tcp: fix SNMP under-estimation on failed retransmission
      tcp: fix SNMP TCP timeout under-estimation

YueHaibing (4):
      usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler
      appletalk: Fix potential NULL pointer dereference in unregister_snap_=
client
      appletalk: Set error code if register_snap_client failed
      e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Yunlong Song (2):
      f2fs: fix count of seg_freed to make sec_freed correct
      f2fs: change segment to section in f2fs_ioc_gc_range

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already

paulhsia (1):
      ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

yangerkun (1):
      ext4: fix a bug in ext4_wait_for_tail_page_commit

zhengbin (1):
      nfsd: Return EPERM, not EACCES, in some SETATTR cases


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl35PZEACgkQONu9yGCS
aT5s6w/+OyNL6JJuYoD+B/9ivKCrFmBIgWgy4W1p3qPeMy9JUWtxDWAVjps84ftC
Z62spbkPY8F8R4tOyn3bJ5W2pfdqyDE0PZAbvwBRkW+aPcnEthNhhBT2nlrLGiVZ
h85/OmkUDRh9ZAlTgvLVIjQCVfInRZ3gsBxxzVE6gnQFQQ42QAILXKZVoxwyMnxl
tpLSATvi1XJPD5LYR0Lb8omJj0Z4yoLKs69h2JBE9buYWYQXHK1YN8ltxO0HChJ3
q6gyPBdL4RBJ9eCpKPeEDe5AwMcLd5NVyhXV3+M6uErCkYzNArDB74s9iFA8N0bT
+PVYR5OwALlNpwsv87Un5/dd29+8ahpa2ZSxiEZtUn5PngsDhW2bzNsylaG2QN4w
7TjC81a/8p116XzLs2nupcVPYZOWSdIlthwESqhOJyzU8y7FzMcpDO6hAbNK1F+o
BGSbiiytXaXcw7K2ERNWQ5/WwpBIoWKDCcTJi70TESs4lzCyd1lJO7PLQNObD/rc
QydWHzsR3xVa0LZdswrhDk+crBfudcYLizNR4l06EpctJutgVel2D9SYkubUIGQm
QLj5H3R7ifeGqJLS4Ufb/OehHGSchltuNnSBgqfMq8ORFgAiN9Am4TW/SjLA+zIP
aFOEqQUyCseHUQpV8V6LnsXkIXv0iQy9UEDxU2lBOE1B4gB9bRQ=
=S6wg
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
