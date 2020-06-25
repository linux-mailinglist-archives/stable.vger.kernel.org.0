Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C21209FF5
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404918AbgFYNce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 09:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404872AbgFYNcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 09:32:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D612120781;
        Thu, 25 Jun 2020 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593091950;
        bh=PNY+5v4CO3LU6wNNQ5TINZ6ASIhl5ryw5Q4ckuttFKg=;
        h=From:To:Cc:Subject:Date:From;
        b=WAYGJkZ8uH0HM7z4qp6rwBKN/zfFFv/95KdidVyyjYbJgIq5VUMnqstS071DoIeYJ
         wNMx9sGgHUppm69kPxbi41gfh/c0Rh/AoaIt2XSWORVaZ4L7w/orhmUzly/nPIG6j2
         ZGI4e2dP+oMOQKd7GgWi79WanlgE2NXGpytI57L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.49
Date:   Thu, 25 Jun 2020 15:32:25 +0200
Message-Id: <159309194526196@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.49 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/r8a7743.dtsi                                 |   12 
 arch/arm/boot/dts/r8a7744.dtsi                                 |   12 
 arch/arm/boot/dts/r8a7745.dtsi                                 |   12 
 arch/arm/boot/dts/r8a7790.dtsi                                 |   12 
 arch/arm/boot/dts/r8a7791.dtsi                                 |   14 
 arch/arm/boot/dts/r8a7793.dtsi                                 |   14 
 arch/arm/boot/dts/r8a7794.dtsi                                 |   12 
 arch/arm/boot/dts/stm32mp157a-avenger96.dts                    |    3 
 arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts           |    2 
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi                        |   10 
 arch/arm/mach-integrator/Kconfig                               |    7 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                     |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                      |   10 
 arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi               |    2 
 arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi               |    8 
 arch/arm64/boot/dts/arm/foundation-v8.dtsi                     |   92 +--
 arch/arm64/boot/dts/arm/juno-base.dtsi                         |   50 +-
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi                  |    6 
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi           |    2 
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi               |    6 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts         |    4 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                       |   22 
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi                 |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                       |   12 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                          |    8 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                          |   20 
 arch/arm64/boot/dts/qcom/pm8150.dtsi                           |   14 
 arch/arm64/boot/dts/qcom/pm8150b.dtsi                          |   14 
 arch/arm64/boot/dts/qcom/pm8150l.dtsi                          |   14 
 arch/arm64/kernel/hw_breakpoint.c                              |   44 +
 arch/m68k/coldfire/pci.c                                       |    4 
 arch/openrisc/kernel/entry.S                                   |    4 
 arch/powerpc/Kconfig                                           |    1 
 arch/powerpc/include/asm/book3s/64/pgtable.h                   |   23 
 arch/powerpc/include/asm/processor.h                           |    1 
 arch/powerpc/kernel/exceptions-64s.S                           |   14 
 arch/powerpc/kernel/head_64.S                                  |    9 
 arch/powerpc/kernel/machine_kexec.c                            |    8 
 arch/powerpc/kernel/process.c                                  |   20 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                         |   16 
 arch/powerpc/kvm/book3s_64_vio.c                               |   18 
 arch/powerpc/mm/book3s32/mmu.c                                 |    6 
 arch/powerpc/mm/ptdump/shared.c                                |    5 
 arch/powerpc/perf/hv-24x7.c                                    |   10 
 arch/powerpc/platforms/4xx/pci.c                               |    4 
 arch/powerpc/platforms/ps3/mm.c                                |   22 
 arch/powerpc/platforms/pseries/ras.c                           |    5 
 arch/s390/include/asm/syscall.h                                |   12 
 arch/sparc/mm/srmmu.c                                          |    1 
 arch/x86/boot/Makefile                                         |    2 
 arch/x86/kernel/apic/apic.c                                    |    2 
 arch/x86/kernel/idt.c                                          |    6 
 arch/x86/kernel/kprobes/core.c                                 |   16 
 arch/x86/purgatory/Makefile                                    |    5 
 crypto/algboss.c                                               |    2 
 crypto/algif_skcipher.c                                        |    6 
 drivers/ata/libata-core.c                                      |   11 
 drivers/base/platform.c                                        |    2 
 drivers/block/ps3disk.c                                        |    1 
 drivers/char/ipmi/ipmi_msghandler.c                            |    7 
 drivers/char/mem.c                                             |  101 ++++
 drivers/clk/bcm/clk-bcm2835.c                                  |   10 
 drivers/clk/clk-ast2600.c                                      |   31 +
 drivers/clk/meson/meson8b.c                                    |  100 ++--
 drivers/clk/meson/meson8b.h                                    |    4 
 drivers/clk/qcom/gcc-msm8916.c                                 |    8 
 drivers/clk/renesas/renesas-cpg-mssr.c                         |    8 
 drivers/clk/samsung/clk-exynos5420.c                           |   16 
 drivers/clk/samsung/clk-exynos5433.c                           |    3 
 drivers/clk/sprd/pll.c                                         |    2 
 drivers/clk/st/clk-flexgen.c                                   |    1 
 drivers/clk/sunxi/clk-sunxi.c                                  |    2 
 drivers/clk/ti/composite.c                                     |    1 
 drivers/clk/zynqmp/clkc.c                                      |   15 
 drivers/crypto/omap-sham.c                                     |   64 +-
 drivers/extcon/extcon-adc-jack.c                               |    3 
 drivers/firmware/imx/imx-scu.c                                 |    1 
 drivers/firmware/qcom_scm.c                                    |    9 
 drivers/fpga/dfl-afu-dma-region.c                              |    4 
 drivers/gpio/gpio-dwapb.c                                      |   34 -
 drivers/gpio/gpio-pca953x.c                                    |   44 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |   11 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c              |    7 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c             |    8 
 drivers/gpu/drm/amd/display/dc/core/dc.c                       |   12 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c        |    2 
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c               |    2 
 drivers/gpu/drm/drm_connector.c                                |    5 
 drivers/gpu/drm/drm_dp_mst_topology.c                          |   58 +-
 drivers/gpu/drm/drm_encoder_slave.c                            |    5 
 drivers/gpu/drm/drm_sysfs.c                                    |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                        |    5 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c                      |   15 
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |    4 
 drivers/gpu/drm/i915/i915_irq.c                                |    1 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                          |    6 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                          |    8 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                          |    7 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c                       |    3 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c           |    4 
 drivers/gpu/drm/qxl/qxl_kms.c                                  |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                             |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c                     |    2 
 drivers/hid/hid-ids.h                                          |    3 
 drivers/hid/hid-quirks.c                                       |    1 
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c                    |    2 
 drivers/hwtracing/coresight/coresight-tmc-etf.c                |   16 
 drivers/i2c/busses/i2c-icy.c                                   |    1 
 drivers/i2c/busses/i2c-piix4.c                                 |    3 
 drivers/i2c/busses/i2c-pxa.c                                   |   13 
 drivers/iio/pressure/bmp280-core.c                             |    7 
 drivers/infiniband/core/cma_configfs.c                         |   13 
 drivers/infiniband/core/sysfs.c                                |   10 
 drivers/infiniband/hw/cxgb4/device.c                           |    1 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                     |   34 -
 drivers/infiniband/hw/mlx5/devx.c                              |    5 
 drivers/infiniband/hw/mlx5/srq.c                               |   10 
 drivers/input/serio/i8042-ppcio.h                              |   57 --
 drivers/input/serio/i8042.h                                    |    2 
 drivers/input/touchscreen/edt-ft5x06.c                         |   12 
 drivers/mailbox/zynqmp-ipi-mailbox.c                           |   20 
 drivers/md/bcache/btree.c                                      |    8 
 drivers/md/dm-mpath.c                                          |    2 
 drivers/md/dm-zoned-metadata.c                                 |    4 
 drivers/md/dm-zoned-reclaim.c                                  |    4 
 drivers/mfd/stmfx.c                                            |   22 
 drivers/mfd/wm8994-core.c                                      |    1 
 drivers/misc/fastrpc.c                                         |   13 
 drivers/misc/habanalabs/habanalabs.h                           |    2 
 drivers/misc/xilinx_sdfec.c                                    |   27 -
 drivers/net/dsa/lantiq_gswip.c                                 |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |    2 
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c               |    5 
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   14 
 drivers/net/ethernet/intel/iavf/iavf.h                         |   14 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c                 |   14 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |   25 -
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |   88 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                |    7 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c     |    2 
 drivers/net/geneve.c                                           |    7 
 drivers/net/hamradio/yam.c                                     |    1 
 drivers/net/phy/marvell.c                                      |    2 
 drivers/ntb/core.c                                             |    9 
 drivers/ntb/test/ntb_perf.c                                    |   30 -
 drivers/ntb/test/ntb_pingpong.c                                |   14 
 drivers/ntb/test/ntb_tool.c                                    |    9 
 drivers/nvme/host/pci.c                                        |    6 
 drivers/of/kobj.c                                              |    3 
 drivers/pci/controller/dwc/pci-meson.c                         |    4 
 drivers/pci/controller/dwc/pcie-designware-host.c              |    2 
 drivers/pci/controller/pci-aardvark.c                          |    4 
 drivers/pci/controller/pci-v3-semi.c                           |    2 
 drivers/pci/controller/pcie-rcar.c                             |    9 
 drivers/pci/controller/vmd.c                                   |    6 
 drivers/pci/pci-bridge-emul.c                                  |    6 
 drivers/pci/pci.c                                              |   30 -
 drivers/pci/pcie/aspm.c                                        |   10 
 drivers/pci/pcie/ptm.c                                         |   22 
 drivers/pci/probe.c                                            |    5 
 drivers/pci/setup-res.c                                        |    9 
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c                   |    2 
 drivers/phy/broadcom/phy-bcm-sr-usb.c                          |   55 --
 drivers/pinctrl/freescale/pinctrl-imx.c                        |   19 
 drivers/pinctrl/freescale/pinctrl-imx1-core.c                  |    1 
 drivers/pinctrl/pinctrl-ocelot.c                               |    3 
 drivers/pinctrl/pinctrl-rockchip.c                             |    7 
 drivers/pinctrl/pinctrl-rza1.c                                 |    2 
 drivers/power/supply/Kconfig                                   |    2 
 drivers/power/supply/lp8788-charger.c                          |   18 
 drivers/power/supply/smb347-charger.c                          |    1 
 drivers/pwm/pwm-img.c                                          |    8 
 drivers/pwm/pwm-jz4740.c                                       |    4 
 drivers/remoteproc/qcom_q6v5_mss.c                             |   31 -
 drivers/remoteproc/remoteproc_core.c                           |    3 
 drivers/rtc/rtc-mc13xxx.c                                      |    4 
 drivers/rtc/rtc-rv3028.c                                       |    2 
 drivers/s390/cio/qdio.h                                        |    1 
 drivers/s390/cio/qdio_setup.c                                  |    1 
 drivers/s390/cio/qdio_thinint.c                                |   14 
 drivers/scsi/arm/acornscsi.c                                   |    4 
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                             |   18 
 drivers/scsi/hisi_sas/hisi_sas_main.c                          |    5 
 drivers/scsi/ibmvscsi/ibmvscsi.c                               |    2 
 drivers/scsi/iscsi_boot_sysfs.c                                |    2 
 drivers/scsi/lpfc/lpfc_els.c                                   |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                            |    2 
 drivers/scsi/qedf/qedf.h                                       |    1 
 drivers/scsi/qedf/qedf_main.c                                  |   35 +
 drivers/scsi/qedi/qedi_iscsi.c                                 |    7 
 drivers/scsi/qla2xxx/qla_os.c                                  |    1 
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                             |    2 
 drivers/scsi/scsi_lib.c                                        |   16 
 drivers/scsi/sr.c                                              |    6 
 drivers/scsi/ufs/ufs-qcom.c                                    |    6 
 drivers/scsi/ufs/ufs_bsg.c                                     |    4 
 drivers/scsi/ufs/ufshcd.c                                      |    1 
 drivers/slimbus/qcom-ngd-ctrl.c                                |    4 
 drivers/soundwire/slave.c                                      |    2 
 drivers/staging/gasket/gasket_sysfs.c                          |    2 
 drivers/staging/greybus/light.c                                |    3 
 drivers/staging/sm750fb/sm750.c                                |    1 
 drivers/staging/wilc1000/wilc_hif.c                            |    4 
 drivers/target/loopback/tcm_loop.c                             |   36 -
 drivers/target/target_core_user.c                              |  154 ++----
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c             |    6 
 drivers/tty/hvc/hvc_console.c                                  |   16 
 drivers/tty/n_gsm.c                                            |   26 -
 drivers/tty/serial/8250/8250_port.c                            |    4 
 drivers/tty/serial/amba-pl011.c                                |    1 
 drivers/usb/class/usblp.c                                      |    5 
 drivers/usb/dwc2/core_intr.c                                   |    7 
 drivers/usb/dwc3/gadget.c                                      |   60 ++
 drivers/usb/gadget/composite.c                                 |   78 ++-
 drivers/usb/gadget/udc/core.c                                  |    2 
 drivers/usb/gadget/udc/lpc32xx_udc.c                           |   11 
 drivers/usb/gadget/udc/m66592-udc.c                            |    2 
 drivers/usb/gadget/udc/s3c2410_udc.c                           |    4 
 drivers/usb/host/ehci-mxc.c                                    |    2 
 drivers/usb/host/ehci-platform.c                               |  131 +++++
 drivers/usb/host/ohci-platform.c                               |    5 
 drivers/usb/host/ohci-sm501.c                                  |    7 
 drivers/usb/host/xhci-plat.c                                   |   10 
 drivers/vfio/mdev/mdev_sysfs.c                                 |    2 
 drivers/vfio/pci/vfio_pci_config.c                             |   14 
 drivers/vhost/scsi.c                                           |    1 
 drivers/video/backlight/lp855x_bl.c                            |   20 
 drivers/watchdog/da9062_wdt.c                                  |    5 
 fs/afs/dir.c                                                   |    9 
 fs/afs/fsclient.c                                              |   88 +--
 fs/afs/inode.c                                                 |   12 
 fs/afs/internal.h                                              |    1 
 fs/afs/misc.c                                                  |    1 
 fs/afs/proc.c                                                  |    1 
 fs/afs/rxrpc.c                                                 |    4 
 fs/afs/write.c                                                 |    5 
 fs/afs/yfsclient.c                                             |   85 +--
 fs/block_dev.c                                                 |   12 
 fs/ceph/export.c                                               |    9 
 fs/cifs/connect.c                                              |   18 
 fs/dlm/dlm_internal.h                                          |    1 
 fs/ext4/dir.c                                                  |   16 
 fs/ext4/extents.c                                              |    2 
 fs/ext4/super.c                                                |   23 
 fs/f2fs/checkpoint.c                                           |    4 
 fs/f2fs/dir.c                                                  |   80 +--
 fs/f2fs/f2fs.h                                                 |   13 
 fs/f2fs/file.c                                                 |    9 
 fs/f2fs/node.c                                                 |    8 
 fs/f2fs/super.c                                                |    5 
 fs/fuse/file.c                                                 |   43 +
 fs/fuse/fuse_i.h                                               |    1 
 fs/fuse/virtio_fs.c                                            |  106 ++--
 fs/gfs2/log.c                                                  |   11 
 fs/gfs2/ops_fstype.c                                           |    2 
 fs/jbd2/journal.c                                              |  103 +---
 fs/nfs/inode.c                                                 |   14 
 fs/nfs/nfs4proc.c                                              |    2 
 fs/nfsd/cache.h                                                |    2 
 fs/nfsd/netns.h                                                |    1 
 fs/nfsd/nfs4callback.c                                         |    2 
 fs/nfsd/nfscache.c                                             |   32 -
 fs/nfsd/nfsctl.c                                               |    6 
 include/linux/bitops.h                                         |    2 
 include/linux/genhd.h                                          |    2 
 include/linux/ioport.h                                         |    6 
 include/linux/jbd2.h                                           |    1 
 include/linux/kprobes.h                                        |    4 
 include/linux/libata.h                                         |    3 
 include/linux/mfd/stmfx.h                                      |    1 
 include/linux/nfs_fs.h                                         |    1 
 include/linux/usb/composite.h                                  |    3 
 include/linux/usb/ehci_def.h                                   |    2 
 include/linux/usb/gadget.h                                     |    2 
 include/uapi/linux/magic.h                                     |    1 
 kernel/kprobes.c                                               |   27 +
 kernel/resource.c                                              |    5 
 kernel/trace/blktrace.c                                        |   30 -
 kernel/trace/trace_kprobe.c                                    |    2 
 kernel/trace/trace_probe.c                                     |    4 
 kernel/trace/trace_uprobe.c                                    |    2 
 lib/zlib_inflate/inffast.c                                     |   91 +--
 net/core/dev.c                                                 |   40 -
 net/core/filter.c                                              |   16 
 net/core/sock_map.c                                            |   28 +
 net/ipv4/tcp_bpf.c                                             |    3 
 net/rxrpc/proc.c                                               |    6 
 net/sunrpc/addr.c                                              |    4 
 net/xdp/xsk.c                                                  |    4 
 scripts/headers_install.sh                                     |   11 
 scripts/mksysmap                                               |    2 
 security/apparmor/domain.c                                     |    9 
 security/apparmor/include/label.h                              |    1 
 security/apparmor/label.c                                      |   37 +
 security/apparmor/lsm.c                                        |    5 
 security/selinux/ss/services.c                                 |    4 
 sound/firewire/amdtp-am824.c                                   |    3 
 sound/isa/wavefront/wavefront_synth.c                          |    8 
 sound/pci/hda/patch_realtek.c                                  |   14 
 sound/soc/codecs/max98373.c                                    |    2 
 sound/soc/codecs/rt5645.c                                      |   14 
 sound/soc/fsl/fsl_asrc_dma.c                                   |    1 
 sound/soc/fsl/fsl_esai.c                                       |    4 
 sound/soc/img/img-i2s-in.c                                     |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   24 
 sound/soc/meson/axg-fifo.c                                     |   10 
 sound/soc/qcom/qdsp6/q6asm-dai.c                               |    4 
 sound/soc/sh/rcar/gen.c                                        |    8 
 sound/soc/sh/rcar/rsnd.h                                       |    9 
 sound/soc/sh/rcar/ssi.c                                        |  145 +++++
 sound/soc/soc-core.c                                           |   22 
 sound/soc/sof/core.c                                           |    1 
 sound/soc/sof/imx/Kconfig                                      |    2 
 sound/soc/sof/nocodec.c                                        |    6 
 sound/soc/sof/pm.c                                             |   10 
 sound/soc/tegra/tegra_wm8903.c                                 |    6 
 sound/soc/ti/davinci-mcasp.c                                   |    4 
 sound/soc/ti/omap-mcbsp.c                                      |    8 
 sound/soc/ux500/mop500.c                                       |   11 
 sound/usb/card.h                                               |    5 
 sound/usb/endpoint.c                                           |  244 +++++++++-
 sound/usb/endpoint.h                                           |    1 
 sound/usb/pcm.c                                                |    7 
 tools/lib/bpf/btf_dump.c                                       |   33 -
 tools/perf/builtin-report.c                                    |    3 
 tools/perf/util/stat-display.c                                 |    4 
 tools/testing/selftests/networking/timestamping/timestamping.c |   10 
 tools/testing/selftests/ntb/ntb_test.sh                        |    2 
 tools/testing/selftests/x86/protection_keys.c                  |    3 
 330 files changed, 2964 insertions(+), 1653 deletions(-)

Adam Honse (1):
      i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Aharon Landau (1):
      RDMA/mlx5: Add init2init as a modify command

Ahmed S. Darwish (2):
      block: nr_sects_write(): Disable preemption on seqcount write
      net: core: device_rename: Use rwsem instead of a seqcount

Alain Volmat (1):
      clk: clk-flexgen: fix clock-critical handling

Alex Elder (1):
      remoteproc: Fix IDR initialisation in rproc_alloc()

Alex Williamson (1):
      vfio-pci: Mask cap zero

Alexander Sverdlin (1):
      net: octeon: mgmt: Repair filling of RX ring

Alexander Tsoy (1):
      ALSA: usb-audio: Improve frames size computation

Amelie Delaunay (3):
      mfd: stmfx: Reset chip on resume as supply was disabled
      mfd: stmfx: Fix stmfx_irq_init error path
      mfd: stmfx: Disable IRQ in suspend to avoid spurious interrupt

Amit Kucheria (1):
      arm64: dts: qcom: msm8916: remove unit name for thermal trip points

Andre Przywara (3):
      arm64: dts: juno: Fix GIC child nodes
      arm64: dts: fvp: Fix GIC child nodes
      arm64: dts: fvp/juno: Fix node address fields

Andreas Klinger (1):
      iio: bmp280: fix compensation of humidity

Andrew Murray (1):
      PCI: rcar: Fix incorrect programming of OB windows

Andrey Ignatov (1):
      bpf: Fix memlock accounting for sock_hash

Andrii Nakryiko (1):
      libbpf: Handle GCC noreturn-turned-volatile quirk

Andy Shevchenko (3):
      iio: pressure: bmp280: Tolerate IRQ before registering
      gpio: dwapb: Call acpi_gpiochip_free_interrupts() on GPIO chip de-registration
      gpio: dwapb: Append MODULE_ALIAS for platform driver

Aneesh Kumar K.V (1):
      powerpc: Fix kernel crash in show_instructions() w/DEBUG_VIRTUAL

Ard Biesheuvel (2):
      PCI: Allow pci_resize_resource() for devices on root bus
      x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Arnd Bergmann (3):
      HID: intel-ish-hid: avoid bogus uninitialized-variable warning
      dlm: remove BUG() before panic()
      include/linux/bitops.h: avoid clang shift-count-overflow warnings

Bard Liao (1):
      ASoC: core: only convert non DPCM link to DPCM link

Ben Skeggs (1):
      drm/nouveau/disp/gm200-: fix NV_PDISP_SOR_HDMI2_CTRL(n) selection

Bharat Gooty (1):
      drivers: phy: sr-usb: do not use internal fsm for USB2 phy init

Bjorn Helgaas (1):
      PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Bob Peterson (2):
      gfs2: Allow lock_nolock mount to specify jid=X
      gfs2: fix use-after-free on transaction ail lists

Bodo Stroesser (2):
      scsi: target: loopback: Fix READ with data and sensebytes
      scsi: target: tcmu: Userspace must not complete queued commands

Borislav Petkov (1):
      x86/apic: Make TSC deadline timer detection message visible

Brett Creeley (1):
      iavf: fix speed reporting over virtchnl

Bryan O'Donoghue (1):
      clk: qcom: msm8916: Fix the address location of pll->config_reg

Can Guo (1):
      scsi: ufs: Don't update urgent bkops level when toggling auto bkops

Chad Dupuis (1):
      scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing

Chaitanya Kulkarni (3):
      blktrace: use errno instead of bi_status
      blktrace: fix endianness in get_pdu_int()
      blktrace: fix endianness for blk_log_remap()

Chao Yu (1):
      f2fs: handle readonly filesystem in f2fs_ioc_shutdown()

Chen Yu (1):
      e1000e: Do not wake up the system via WOL if device wakeup is disabled

Chen Zhou (1):
      staging: greybus: fix a missing-check bug in gb_lights_light_config()

Chris Wilson (2):
      drm/i915/gem: Avoid iterating an empty list
      drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Christoph Hellwig (2):
      firmware: qcom_scm: fix bogous abuse of dma-direct internals
      nvme-pci: use simple suspend when a HMB is enabled

Christophe JAILLET (9):
      m68k/PCI: Fix a memory leak in an error handling path
      PCI: v3-semi: Fix a memory leak in v3_pci_probe() error handling paths
      power: supply: lp8788: Fix an error handling path in 'lp8788_charger_probe()'
      ASoC: ux500: mop500: Fix some refcounted resources issues
      ASoC: ti: omap-mcbsp: Fix an error handling path in 'asoc_mcbsp_probe()'
      extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
      pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'
      pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'
      scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Christophe Leroy (3):
      powerpc/kasan: Fix stack overflow by increasing THREAD_SHIFT
      powerpc/ptdump: Add _PAGE_COHERENT flag
      powerpc/32s: Don't warn when mapping RO data ROX.

Chuhong Yuan (1):
      rtc: rv3028: Add missed check for devm_regmap_init_i2c()

Chunyan Zhang (1):
      clk: sprd: return correct type of value for _sprd_pll_recalc_rate

Colin Ian King (1):
      usb: gadget: lpc32xx_udc: don't dereference ep pointer before null check

Cristian Klein (1):
      HID: Add quirks for Trust Panora Graphic Tablet

Dafna Hirschfeld (1):
      pinctrl: rockchip: fix memleak in rockchip_dt_node_to_map

Dan Carpenter (5):
      scsi: qedi: Check for buffer overflow in qedi_set_path()
      ALSA: isa/wavefront: prevent out of bounds write in ioctl
      scsi: cxgb3i: Fix some leaks in init_act_open()
      scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
      of: Fix a refcounting bug in __of_attach_node_sysfs()

Dan Murphy (1):
      net: marvell: Fix OF_MDIO config check

Dan Williams (1):
      /dev/mem: Revoke mappings when a driver claims the region

Daniel Baluta (1):
      ASoC: SOF: Do nothing when DSP PM callbacks are not set

David Howells (7):
      rxrpc: Adjust /proc/net/rxrpc/calls to display call->debug_id not user_ID
      afs: Fix non-setting of mtime when writing into mmap
      afs: afs_write_end() should change i_size under the right lock
      afs: Fix EOF corruption
      afs: Always include dir in bulk status fetch from afs_do_lookup()
      afs: Set error flag rather than return error from file status decode
      afs: Fix the mapping of the UAEOVERFLOW abort code

Denis Efremov (2):
      net/mlx5: DR, Fix freeing in dr_create_rc_qp()
      drm/amd/display: Use kvfree() to free coeff in build_regamma()

Dinghao Liu (1):
      scsi: ufs-bsg: Fix runtime PM imbalance on error

Dmitry Osipenko (2):
      ASoC: tegra: tegra_wm8903: Support nvidia, headset property
      power: supply: smb347-charger: IRQSTAT_D is volatile

Dmitry V. Levin (1):
      s390: fix syscall_get_error for compat processes

Eddie James (1):
      clk: ast2600: Fix AHB clock divider for A1

Emmanuel Nicolet (1):
      ps3disk: use the default segment boundary

Enric Balletbo i Serra (1):
      power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select

Eric Biggers (5):
      f2fs: don't return vmalloc() memory from f2fs_kmalloc()
      ext4: avoid utf8_strncasecmp() with unstable name
      f2fs: split f2fs_d_compare() from f2fs_match_name()
      f2fs: avoid utf8_strncasecmp() with unstable name
      crypto: algboss - don't wait during notifier callback

Erwin Burema (1):
      ALSA: usb-audio: Add duplex sound support for USB devices using implicit feedback

Fabrice Gasnier (1):
      usb: dwc2: gadget: move gadget resume after the core is in L0 state

Fedor Tokarev (1):
      net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Feng Tang (1):
      ipmi: use vzalloc instead of kmalloc for user creation

Gaurav Singh (1):
      perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Geert Uytterhoeven (1):
      clk: renesas: cpg-mssr: Fix STBCR suspend/resume handling

Geoff Levand (1):
      powerpc/ps3: Fix kexec shutdown hang

Greg Kroah-Hartman (1):
      Linux 5.4.49

Gregory CLEMENT (3):
      tty: n_gsm: Fix SOF skipping
      tty: n_gsm: Fix waking up upper tty layer when room available
      tty: n_gsm: Fix bogus i++ in gsm_data_kick

Hannes Reinecke (1):
      dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Hans de Goede (4):
      x86/purgatory: Disable various profiling and sanitizing options
      ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT8-A tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT10-A tablet
      ASoC: rt5645: Add platform-data for Asus T101HA

Harry Wentland (1):
      Revert "drm/amd/display: disable dcn20 abm feature for bring up"

Herbert Xu (1):
      crypto: algif_skcipher - Cap recv SG list at ctx->used

Hongbo Yao (1):
      perf stat: Fix NULL pointer dereference

Hsin-Yi Wang (1):
      arm64: dts: mt8173: fix unit name warnings

Huacai Chen (1):
      drm/qxl: Use correct notify port address when creating cursor ring

Imre Deak (2):
      drm/i915: Fix AUX power domain toggling across TypeC mode resets
      drm/i915/icl+: Fix hotplug interrupt disabling after storm detection

J. Bruce Fields (2):
      nfsd4: make drc_slab global, not per-net
      nfsd: safer handling of corrupted c_type

Jakub Sitnicki (2):
      bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free
      bpf, sockhash: Synchronize delete from bucket list on map free

Jann Horn (1):
      lib/zlib: remove outdated and incorrect pre-increment optimization

Jason Yan (2):
      pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries
      block: Fix use-after-free in blkdev_get()

Jean-Philippe Brucker (1):
      tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes

Jeffle Xu (1):
      ext4: fix partial cluster initialization when splitting extent

Jeffrey Hugo (1):
      scsi: ufs-qcom: Fix scheduling while atomic issue

Jernej Skrabec (1):
      drm/sun4i: hdmi ddc clk: Fix size of m divider

Jeykumar Sankaran (1):
      drm/connector: notify userspace on hotplug after register complete

Jiri Benc (1):
      geneve: change from tx_error to tx_dropped on missing metadata

Jiri Olsa (1):
      kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

Johannes Thumshirn (1):
      scsi: core: free sgtables in case command setup fails

John Hubbard (1):
      misc: xilinx-sdfec: improve get_user_pages_fast() error handling

John Johansen (2):
      apparmor: fix introspection of of task mode for unconfined tasks
      apparmor: fix nnp subset test for unconfined

John Stultz (2):
      ASoC: qcom: q6asm-dai: kCFI fix
      serial: amba-pl011: Make sure we initialize the port.lock spinlock

Jon Derrick (2):
      PCI: pci-bridge-emul: Fix PCIe bit conflicts
      PCI: vmd: Filter resource type bits from shadow register

Jon Hunter (2):
      backlight: lp855x: Ensure regulators are disabled on probe failure
      arm64: tegra: Fix ethernet phy-mode for Jetson Xavier

Jonathan Marek (1):
      arm64: dts: qcom: fix pm8150 gpio interrupts

Jordan Crouse (1):
      drm/msm: Check for powered down HW in the devfreq callbacks

Julian Wiedmann (1):
      s390/qdio: put thinint indicator after early error

Kai-Heng Feng (3):
      ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
      PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges
      libata: Use per port sync for detach

Kajol Jain (1):
      powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run

Konstantin Khlebnikov (1):
      f2fs: report delalloc reserve as non-free in statfs for project quota

Kuppuswamy Sathyanarayanan (1):
      drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish

Lang Cheng (1):
      RDMA/hns: Fix cmdq parameter of querying pf timer resource

Lars Povlsen (1):
      pinctrl: ocelot: Fix GPIO interrupt decoding on Jaguar2

Li RongQing (1):
      xdp: Fix xsk_generic_xmit errno

Lijun Ou (1):
      RDMA/hns: Bugfix for querying qkey

Linus Walleij (1):
      ARM: integrator: Add some Kconfig selections

Logan Gunthorpe (8):
      NTB: ntb_pingpong: Choose doorbells based on port number
      NTB: Fix the default port and peer numbers for legacy drivers
      NTB: ntb_tool: reading the link file should not end in a NULL byte
      NTB: Revert the change to use the NTB device dev for DMA allocations
      NTB: perf: Don't require one more memory window than number of peers
      NTB: perf: Fix support for hardware that doesn't have port numbers
      NTB: perf: Fix race condition when run with ntb_test
      NTB: ntb_test: Fix bug when counting remote files

Loic Poulain (1):
      arm64: dts: msm8996: Fix CSI IRQ types

Luis Henriques (1):
      ceph: don't return -ESTALE if there's still an open file

Luo Jiaxing (1):
      scsi: hisi_sas: Do not reset phy timer to wait for stray phy up

Lyude Paul (2):
      drm/dp_mst: Reformat drm_dp_check_act_status() a bit
      drm/dp_mst: Increase ACT retry timeout to 3s

Maor Gottlieb (1):
      IB/cma: Fix ports memory leak in cma_configfs

Marc Zyngier (2):
      PCI: dwc: Fix inner MSI IRQ domain registration
      PCI: amlogic: meson: Don't use FAST_LINK_MODE to set up link

Marco Felsch (1):
      Input: edt-ft5x06 - fix get_default register write access

Marek Behún (2):
      arm64: dts: armada-3720-turris-mox: forbid SDR104 on SDIO for FCC purposes
      arm64: dts: armada-3720-turris-mox: fix SFP binding

Marek Szyprowski (3):
      clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical
      mfd: wm8994: Fix driver operation if loaded as modules
      clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Marek Vasut (1):
      ARM: dts: stm32: Add missing ethernet PHY reset on AV96

Mark Zhang (1):
      IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command

Martin Blumenstingl (5):
      net: dsa: lantiq_gswip: fix and improve the unsupported interface error
      clk: meson: meson8b: Fix the first parent of vid_pll_in_sel
      clk: meson: meson8b: Fix the polarity of the RESET_N lines
      clk: meson: meson8b: Fix the vclk_div{1, 2, 4, 6, 12}_en gate bits
      clk: meson: meson8b: Don't rely on u-boot to init all GP_PLL registers

Martin Wilck (1):
      dm mpath: switch paths in dm_blk_ioctl() code path

Masami Hiramatsu (1):
      kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Matej Dujava (1):
      staging: sm750fb: add missing case while setting FB_VISUAL

Mauricio Faria de Oliveira (1):
      apparmor: check/put label on apparmor_sk_clone_security()

Max Staudt (1):
      i2c: icy: Fix build with CONFIG_AMIGA_PCMCIA=n

Michael Ellerman (1):
      powerpc/64: Don't initialise init_task->thread.regs

Mika Westerberg (1):
      PCI/PM: Assume ports without DLL Link Active train links in 100 ms

Miklos Szeredi (2):
      fuse: fix copy_file_range cache issues
      fuse: copy_file_range should truncate cache

Nathan Chancellor (3):
      USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke
      clk: bcm2835: Fix return type of bcm2835_register_gate
      input: i8042 - Remove special PowerPC handling

Navid Emamdoost (1):
      pwm: img: Call pm_runtime_put() in pm_runtime_get_sync() failed case

Neil Armstrong (1):
      arm64: dts: meson: fixup SCP sram nodes

Nicholas Kazlauskas (1):
      drm/amd/display: Revalidate bandwidth before commiting DC updates

Nicholas Piggin (2):
      powerpc/64s/exception: Fix machine check no-loss idle wakeup
      powerpc/pseries/ras: Fix FWNMI_VALID off by one

Nilesh Javali (1):
      scsi: qedi: Do not flush offload work if ARP not resolved

Oded Gabbay (1):
      habanalabs: increase timeout during reset

Olga Kornievskaia (1):
      NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION

Oliver Neukum (1):
      usblp: poison URBs upon disconnect

Oscar Carter (1):
      staging: wilc1000: Increase the size of wid_list array

Pali Rohár (1):
      PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register

Paul Cercueil (1):
      pwm: jz4740: Enhance precision in calculation of duty cycle

Paulo Alcantara (1):
      cifs: set up next DFS target before generic_ip_connect()

Pavel Machek (CIP) (1):
      ASoC: meson: add missing free_irq() in error path

Pawel Laszczak (1):
      usb: gadget: Fix issue with config_ep_by_speed function

Peter Chen (1):
      usb: gadget: core: sync interrupt before unbind the udc

Pierre-Louis Bossart (2):
      soundwire: slave: don't init debugfs on device registration error
      ASoC: SOF: nocodec: conditionally set dpcm_capture/dpcm_playback flags

Pingfan Liu (1):
      powerpc/crashkernel: Take "mem=" option into account

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove

Qais Yousef (3):
      usb/ohci-platform: Fix a warning when hibernating
      usb/xhci-plat: Set PM runtime as active on resume
      usb/ehci-platform: Set PM runtime as active on resume

Qian Cai (4):
      vfio/pci: fix memory leaks in alloc_perm_bits()
      powerpc/64s/pgtable: fix an undefined behaviour
      KVM: PPC: Book3S HV: Ignore kmemleak false positives
      KVM: PPC: Book3S: Fix some RCU-list locks

Qiushi Wu (6):
      rtc: mc13xxx: fix a double-unlock issue
      RDMA/core: Fix several reference count leaks.
      usb: gadget: fix potential double-free in m66592_probe.
      ASoC: fix incomplete error-handling in img_i2s_in_probe.
      vfio/mdev: Fix reference count leak in add_mdev_supported_type
      scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj

Quanyang Wang (1):
      clk: zynqmp: fix memory leak in zynqmp_register_clocks

Raghavendra Rao Ananta (1):
      tty: hvc: Fix data abort due to race in hvc_open

Ram Pai (1):
      selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

Rikard Falkeborn (1):
      clk: sunxi: Fix incorrect usage of round_down()

Rob Herring (1):
      PCI: Fix pci_register_host_bridge() device_register() error handling

Roy Spliet (1):
      drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation

Russell King (2):
      i2c: pxa: clear all master action bits in i2c_pxa_stop_message()
      i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output

Sai Prakash Ranjan (1):
      coresight: tmc: Fix TMC mode read in tmc_read_prepare_etb()

Sandeep Raghuraman (1):
      drm/amdgpu: Replace invalid device ID with a valid device ID

Sanjay R Mehta (2):
      ntb_perf: pass correct struct device to dma_alloc_coherent
      ntb_tool: pass correct struct device to dma_alloc_coherent

Serge Semin (1):
      serial: 8250: Fix max baud limit in generic 8250 port

Shaokun Zhang (1):
      drivers/perf: hisi: Fix wrong value for all counters enable

Shengjiu Wang (1):
      ASoC: fsl_esai: Disable exception interrupt before scheduling tasklet

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: map/unmap mpss segments before/after use

Siddharth Gupta (1):
      scripts: headers_install: Exit with error on config leak

Simon Arlott (1):
      scsi: sr: Fix sr_probe() missing deallocate of device minor

Souptick Joarder (1):
      fpga: dfl: afu: Corrected error handling levels

Srinivas Kandagatla (3):
      misc: fastrpc: Fix an incomplete memory release in fastrpc_rpmsg_probe()
      misc: fastrpc: fix potential fastrpc_invoke_ctx leak
      slimbus: ngd: get drvdata from correct device

Stafford Horne (1):
      openrisc: Fix issue with argument clobbering for clone/fork

Stefan Riedmueller (1):
      watchdog: da9062: No need to ping manually before setting timeout

Sudhakar Panneerselvam (1):
      scsi: vhost: Notify TCM about the maximum sg entries supported per command

Sudip Mukherjee (1):
      thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Suganath Prabu S (1):
      scsi: mpt3sas: Fix double free warnings

Sven Auhagen (1):
      mvpp2: remove module bugfix

Takashi Iwai (1):
      ALSA: usb-audio: Fix racy list management in output queue

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix invalid assignment to union data for directional parameter

Tang Bin (1):
      USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

Tero Kristo (2):
      clk: ti: composite: fix memory leak
      crypto: omap-sham - add proper load balancing support for multicore

Theodore Ts'o (1):
      ext4: avoid race conditions when remounting with options that change dax

Thinh Nguyen (2):
      usb: dwc3: gadget: Properly handle ClearFeature(halt)
      usb: dwc3: gadget: Properly handle failed kick_transfer

Thomas Gleixner (1):
      sched/rt, net: Use CONFIG_PREEMPTION.patch

Tom Rix (1):
      selinux: fix double free

Tyrel Datwyler (1):
      scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Uwe Kleine-König (1):
      gpio: pca953x: fix handling of automatic address incrementing

Vamshi K Sthambamkadi (1):
      tracing/probe: Fix memleak in fetch_op_data operations

Vasundhara Volam (1):
      bnxt_en: Return from timer if interface is not in open state.

Viacheslav Dubeyko (2):
      scsi: qla2xxx: Fix issue with adapter's stopping state
      scsi: qla2xxx: Fix warning after FC target reset

Vidya Sagar (1):
      arm64: tegra: Fix flag for 64-bit resources in 'ranges' property

Ville Syrjälä (1):
      drm/amd/display: Use swap() where appropriate

Vincent Stehlé (1):
      ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity

Vitaly Kuznetsov (1):
      x86/idt: Keep spurious entries unset in system_vectors

Vivek Goyal (1):
      virtiofs: schedule blocking async replies in separate worker

Wang Hai (1):
      yam: fix possible memory leak in yam_init_driver

Wei Yongjun (4):
      ASoC: SOF: core: fix error return code in sof_probe_continue()
      USB: ohci-sm501: fix error return code in ohci_hcd_sm501_drv_probe()
      firmware: imx: scu: Fix possible memory leak in imx_scu_probe()
      mailbox: zynqmp-ipi: Fix NULL vs IS_ERR() check in zynqmp_ipi_mbox_probe()

Will Deacon (2):
      sparc32: mm: Don't try to free page-table pages if ctor() fails
      arm64: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Wolfram Sang (1):
      drm: encoder_slave: fix refcouting error for modules

Xiyu Yang (6):
      ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type
      scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
      nfsd: Fix svc_xprt refcnt leak when setup callback client failed
      staging: gasket: Fix mapping refcnt leak when put attribute fails
      staging: gasket: Fix mapping refcnt leak when register/store fails
      ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

YiFei Zhu (1):
      net/filter: Permit reading NET in load_bytes_relative when MAC not set

Yishai Hadas (1):
      RDMA/mlx5: Fix udata response upon SRQ creation

Yong Zhi (1):
      ASoC: max98373: reorder max98373_reset() in resume

Yongbo Zhang (1):
      SoC: rsnd: add interrupt support for SSI BUSIF buffer

Yoshihiro Shimoda (2):
      ARM: dts: renesas: Fix IOMMU device node names
      usb: host: ehci-platform: add a quirk to avoid stuck

YueHaibing (1):
      ASoC: SOF: imx8: Fix randbuild error

Zheng Bin (1):
      nfs: set invalid blocks after NFSv4 writes

Zhihao Cheng (1):
      afs: Fix memory leak in afs_put_sysnames()

Zhiqiang Liu (1):
      bcache: fix potential deadlock problem in btree_gc_coalesce

ashimida (1):
      mksysmap: Fix the mismatch of '.L' symbols in System.map

dihu (1):
      bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg

huhai (1):
      powerpc/4xx: Don't unmap NULL mbase

tannerlove (1):
      selftests/net: in timestamping, strncpy needs to preserve null byte

yangerkun (1):
      ext4: stop overwrite the errcode in ext4_setup_super

zhangyi (F) (1):
      jbd2: clean __jbd2_journal_abort_hard() and __journal_abort_soft()

