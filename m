Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED92298AB
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbgGVMxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbgGVMxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:53:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F9120729;
        Wed, 22 Jul 2020 12:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422426;
        bh=e79cjx23a3nC6o76pkc40i7x12TjEzNvVmTcRGzL7rg=;
        h=From:To:Cc:Subject:Date:From;
        b=i9CW6/22wf8stz8LMtFdT+lVTpw2ORmUX2NSqbJ6PZLySc6AFWTVdQ2OjHjhzMmI3
         gXh3BL0LeWh/fFIHGpvhe0R3PdFS9IcQOSKCIIN00Gv+M0HuEsMpIr+NqwPswhfOQV
         BZ/R+2hevmI8KyMR60TQOcHsdb1tCrOsh+FxYnQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.53
Date:   Wed, 22 Jul 2020 14:53:41 +0200
Message-Id: <1595422420145236@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.53 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mailbox/xlnx,zynqmp-ipi-mailbox.txt |    2 
 Documentation/devicetree/bindings/usb/dwc3.txt                        |    2 
 Makefile                                                              |    2 
 arch/alpha/configs/defconfig                                          |    1 
 arch/arm/boot/dts/am437x-l4.dtsi                                      |   14 
 arch/arm/boot/dts/mt7623n-rfb-emmc.dts                                |    1 
 arch/arm/boot/dts/socfpga.dtsi                                        |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi                                |    2 
 arch/arm/configs/rpc_defconfig                                        |    1 
 arch/arm/configs/s3c2410_defconfig                                    |    1 
 arch/arm/include/asm/clocksource.h                                    |   11 
 arch/arm/kernel/vdso.c                                                |    2 
 arch/arm/mach-at91/pm_suspend.S                                       |    4 
 arch/arm/mach-omap2/omap-iommu.c                                      |   43 +
 arch/arm/mach-omap2/pdata-quirks.c                                    |   35 -
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi                     |    8 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi                     |    1 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts          |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts                  |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi                      |   24 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                            |    5 
 arch/arm64/include/asm/alternative.h                                  |   16 
 arch/arm64/include/asm/arch_timer.h                                   |    1 
 arch/arm64/include/asm/clocksource.h                                  |    5 
 arch/arm64/include/asm/debug-monitors.h                               |    2 
 arch/arm64/include/asm/syscall.h                                      |   12 
 arch/arm64/include/asm/thread_info.h                                  |    1 
 arch/arm64/include/asm/vdso/clocksource.h                             |   14 
 arch/arm64/include/asm/vdso/compat_gettimeofday.h                     |    5 
 arch/arm64/include/asm/vdso/gettimeofday.h                            |    6 
 arch/arm64/include/asm/vdso/vsyscall.h                                |    4 
 arch/arm64/kernel/alternative.c                                       |   16 
 arch/arm64/kernel/debug-monitors.c                                    |   20 
 arch/arm64/kernel/ptrace.c                                            |   29 
 arch/arm64/kernel/signal.c                                            |   11 
 arch/arm64/kernel/syscall.c                                           |    5 
 arch/arm64/kernel/vmlinux.lds.S                                       |    3 
 arch/ia64/configs/zx1_defconfig                                       |    1 
 arch/m68k/configs/amiga_defconfig                                     |    1 
 arch/m68k/configs/apollo_defconfig                                    |    1 
 arch/m68k/configs/atari_defconfig                                     |    1 
 arch/m68k/configs/bvme6000_defconfig                                  |    1 
 arch/m68k/configs/hp300_defconfig                                     |    1 
 arch/m68k/configs/mac_defconfig                                       |    1 
 arch/m68k/configs/multi_defconfig                                     |    1 
 arch/m68k/configs/mvme147_defconfig                                   |    1 
 arch/m68k/configs/mvme16x_defconfig                                   |    1 
 arch/m68k/configs/q40_defconfig                                       |    1 
 arch/m68k/configs/sun3_defconfig                                      |    1 
 arch/m68k/configs/sun3x_defconfig                                     |    1 
 arch/m68k/kernel/setup_no.c                                           |    3 
 arch/m68k/mm/mcfmmu.c                                                 |    2 
 arch/mips/configs/bigsur_defconfig                                    |    1 
 arch/mips/configs/fuloong2e_defconfig                                 |    1 
 arch/mips/configs/ip27_defconfig                                      |    1 
 arch/mips/configs/ip32_defconfig                                      |    1 
 arch/mips/configs/jazz_defconfig                                      |    1 
 arch/mips/configs/malta_defconfig                                     |    1 
 arch/mips/configs/malta_kvm_defconfig                                 |    1 
 arch/mips/configs/malta_kvm_guest_defconfig                           |    1 
 arch/mips/configs/maltaup_xpa_defconfig                               |    1 
 arch/mips/configs/rm200_defconfig                                     |    1 
 arch/powerpc/configs/85xx-hw.config                                   |    1 
 arch/powerpc/configs/amigaone_defconfig                               |    1 
 arch/powerpc/configs/chrp32_defconfig                                 |    1 
 arch/powerpc/configs/g5_defconfig                                     |    1 
 arch/powerpc/configs/maple_defconfig                                  |    1 
 arch/powerpc/configs/pasemi_defconfig                                 |    1 
 arch/powerpc/configs/pmac32_defconfig                                 |    1 
 arch/powerpc/configs/powernv_defconfig                                |    1 
 arch/powerpc/configs/ppc64_defconfig                                  |    1 
 arch/powerpc/configs/ppc64e_defconfig                                 |    1 
 arch/powerpc/configs/ppc6xx_defconfig                                 |    1 
 arch/powerpc/configs/pseries_defconfig                                |    1 
 arch/powerpc/configs/skiroot_defconfig                                |    1 
 arch/powerpc/kernel/paca.c                                            |    2 
 arch/powerpc/mm/book3s64/pkeys.c                                      |   12 
 arch/riscv/include/asm/thread_info.h                                  |    4 
 arch/sh/configs/sh03_defconfig                                        |    1 
 arch/sparc/configs/sparc64_defconfig                                  |    1 
 arch/x86/configs/i386_defconfig                                       |    1 
 arch/x86/configs/x86_64_defconfig                                     |    1 
 arch/x86/include/asm/fpu/internal.h                                   |    5 
 arch/x86/kernel/apic/vector.c                                         |   22 
 arch/x86/kernel/fpu/core.c                                            |    6 
 arch/x86/kernel/fpu/xstate.c                                          |    2 
 block/blk-merge.c                                                     |   23 
 block/blk-mq-debugfs.c                                                |    3 
 crypto/asymmetric_keys/public_key.c                                   |    1 
 drivers/acpi/video_detect.c                                           |   19 
 drivers/base/regmap/regmap-debugfs.c                                  |   52 -
 drivers/block/zram/zram_drv.c                                         |    3 
 drivers/bus/ti-sysc.c                                                 |  331 ++++++----
 drivers/char/tpm/tpm_tis_core.c                                       |    2 
 drivers/char/virtio_console.c                                         |    3 
 drivers/clk/clk-ast2600.c                                             |   49 +
 drivers/clk/mvebu/Kconfig                                             |    1 
 drivers/clk/qcom/gcc-sm8150.c                                         |  148 ++++
 drivers/clocksource/arm_arch_timer.c                                  |   19 
 drivers/crypto/Kconfig                                                |    8 
 drivers/dma/dmatest.c                                                 |    2 
 drivers/dma/dw/core.c                                                 |   12 
 drivers/dma/fsl-edma-common.h                                         |    2 
 drivers/dma/fsl-edma.c                                                |    7 
 drivers/dma/mcf-edma.c                                                |    7 
 drivers/dma/sh/usb-dmac.c                                             |    2 
 drivers/gpio/gpio-pca953x.c                                           |    1 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c                                |   26 
 drivers/gpu/drm/exynos/exynos_drm_dma.c                               |    4 
 drivers/gpu/drm/exynos/exynos_drm_mic.c                               |    4 
 drivers/gpu/drm/i915/gt/intel_lrc.c                                   |    1 
 drivers/gpu/drm/i915/gvt/handlers.c                                   |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                           |    4 
 drivers/gpu/drm/msm/msm_submitqueue.c                                 |    4 
 drivers/gpu/drm/sun4i/sun4i_tcon.c                                    |    2 
 drivers/hid/hid-ids.h                                                 |    3 
 drivers/hid/hid-logitech-hidpp.c                                      |    2 
 drivers/hid/hid-magicmouse.c                                          |    6 
 drivers/hid/hid-quirks.c                                              |    5 
 drivers/hwmon/emc2103.c                                               |    2 
 drivers/hwtracing/intel_th/core.c                                     |   21 
 drivers/hwtracing/intel_th/pci.c                                      |   15 
 drivers/hwtracing/intel_th/sth.c                                      |    4 
 drivers/i2c/busses/i2c-eg20t.c                                        |    1 
 drivers/iio/accel/mma8452.c                                           |    5 
 drivers/iio/adc/ad7780.c                                              |    2 
 drivers/iio/health/afe4403.c                                          |   13 
 drivers/iio/health/afe4404.c                                          |    8 
 drivers/iio/humidity/hdc100x.c                                        |   10 
 drivers/iio/humidity/hts221.h                                         |    7 
 drivers/iio/humidity/hts221_buffer.c                                  |    9 
 drivers/iio/industrialio-core.c                                       |    2 
 drivers/iio/magnetometer/ak8974.c                                     |   29 
 drivers/iio/pressure/ms5611_core.c                                    |   11 
 drivers/iio/pressure/zpa2326.c                                        |    4 
 drivers/infiniband/hw/mlx5/qp.c                                       |    2 
 drivers/input/serio/i8042-x86ia64io.h                                 |    7 
 drivers/input/touchscreen/goodix.c                                    |   22 
 drivers/input/touchscreen/mms114.c                                    |   17 
 drivers/iommu/Kconfig                                                 |    2 
 drivers/misc/atmel-ssc.c                                              |   24 
 drivers/misc/habanalabs/goya/goya_security.c                          |   99 ++
 drivers/misc/mei/bus.c                                                |    3 
 drivers/mmc/host/mmci.c                                               |   34 -
 drivers/mmc/host/mmci.h                                               |    8 
 drivers/mmc/host/sdhci.c                                              |    2 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                              |   24 
 drivers/mtd/nand/raw/marvell_nand.c                                   |   27 
 drivers/mtd/nand/raw/nand_timings.c                                   |    5 
 drivers/mtd/nand/raw/oxnas_nand.c                                     |   24 
 drivers/net/dsa/bcm_sf2.c                                             |    2 
 drivers/net/dsa/microchip/ksz8795.c                                   |    3 
 drivers/net/dsa/microchip/ksz9477.c                                   |    3 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c            |    4 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h   |    2 
 drivers/net/ethernet/cadence/macb_main.c                              |    6 
 drivers/net/ethernet/marvell/mvneta.c                                 |   24 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                       |    1 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c                    |   19 
 drivers/net/phy/sfp-bus.c                                             |   79 ++
 drivers/net/usb/qmi_wwan.c                                            |    1 
 drivers/of/of_mdio.c                                                  |    9 
 drivers/pci/pci.c                                                     |    4 
 drivers/phy/allwinner/phy-sun4i-usb.c                                 |    5 
 drivers/scsi/Kconfig                                                  |    9 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                           |    2 
 drivers/scsi/sr_vendor.c                                              |    8 
 drivers/slimbus/core.c                                                |    1 
 drivers/soc/qcom/rpmh-rsc.c                                           |   98 +-
 drivers/soc/qcom/rpmh.c                                               |   56 -
 drivers/soc/qcom/socinfo.c                                            |    2 
 drivers/soundwire/intel.c                                             |    5 
 drivers/spi/spi-fsl-dspi.c                                            |   15 
 drivers/spi/spi-sprd-adi.c                                            |    2 
 drivers/spi/spi-sun6i.c                                               |   14 
 drivers/staging/comedi/drivers/addi_apci_1500.c                       |   10 
 drivers/thermal/cpu_cooling.c                                         |    6 
 drivers/thermal/imx_thermal.c                                         |    7 
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c               |    2 
 drivers/thermal/mtk_thermal.c                                         |    6 
 drivers/tty/serial/mxs-auart.c                                        |   12 
 drivers/tty/serial/xilinx_uartps.c                                    |    1 
 drivers/uio/uio_pdrv_genirq.c                                         |    4 
 drivers/usb/c67x00/c67x00-sched.c                                     |    2 
 drivers/usb/chipidea/core.c                                           |   24 
 drivers/usb/dwc2/platform.c                                           |    3 
 drivers/usb/gadget/function/f_uac1_legacy.c                           |    2 
 drivers/usb/gadget/udc/atmel_usba_udc.c                               |    2 
 drivers/usb/host/ehci-platform.c                                      |    4 
 drivers/usb/host/ohci-platform.c                                      |    5 
 drivers/usb/host/xhci-plat.c                                          |   10 
 drivers/usb/serial/ch341.c                                            |    1 
 drivers/usb/serial/cypress_m8.c                                       |    2 
 drivers/usb/serial/cypress_m8.h                                       |    3 
 drivers/usb/serial/iuu_phoenix.c                                      |    8 
 drivers/usb/serial/option.c                                           |    6 
 drivers/virt/vboxguest/vboxguest_core.c                               |    6 
 drivers/virt/vboxguest/vboxguest_core.h                               |   15 
 drivers/virt/vboxguest/vboxguest_linux.c                              |    3 
 drivers/virt/vboxguest/vmmdev.h                                       |    2 
 fs/cifs/transport.c                                                   |    2 
 fs/fuse/file.c                                                        |   14 
 fs/fuse/inode.c                                                       |   15 
 fs/gfs2/ops_fstype.c                                                  |   12 
 fs/nfs/nfs4proc.c                                                     |   20 
 fs/overlayfs/export.c                                                 |    2 
 fs/overlayfs/file.c                                                   |   10 
 fs/overlayfs/super.c                                                  |   23 
 include/linux/blkdev.h                                                |    1 
 include/linux/cgroup-defs.h                                           |    8 
 include/linux/cgroup.h                                                |    4 
 include/linux/if_vlan.h                                               |   29 
 include/linux/input/elan-i2c-ids.h                                    |    7 
 include/linux/platform_data/ti-sysc.h                                 |    1 
 include/net/dst.h                                                     |   10 
 include/net/genetlink.h                                               |    8 
 include/net/inet_ecn.h                                                |   25 
 include/net/pkt_sched.h                                               |   11 
 include/trace/events/rxrpc.h                                          |    2 
 include/uapi/linux/vboxguest.h                                        |    4 
 kernel/cgroup/cgroup.c                                                |   31 
 kernel/irq/manage.c                                                   |   37 +
 kernel/sched/core.c                                                   |    2 
 kernel/sched/fair.c                                                   |   16 
 kernel/time/timer.c                                                   |   21 
 net/bridge/br_multicast.c                                             |    2 
 net/ceph/osd_client.c                                                 |    1 
 net/core/filter.c                                                     |   10 
 net/core/sock.c                                                       |    2 
 net/ipv4/icmp.c                                                       |    4 
 net/ipv4/ip_output.c                                                  |    2 
 net/ipv4/ping.c                                                       |    3 
 net/ipv4/tcp.c                                                        |   15 
 net/ipv4/tcp_cong.c                                                   |    2 
 net/ipv4/tcp_input.c                                                  |    2 
 net/ipv4/tcp_ipv4.c                                                   |   15 
 net/ipv4/tcp_output.c                                                 |    8 
 net/ipv6/icmp.c                                                       |    4 
 net/ipv6/route.c                                                      |    7 
 net/l2tp/l2tp_core.c                                                  |    5 
 net/llc/af_llc.c                                                      |   10 
 net/netlink/genetlink.c                                               |   49 -
 net/sched/act_connmark.c                                              |    9 
 net/sched/act_csum.c                                                  |    2 
 net/sched/act_ct.c                                                    |    9 
 net/sched/act_ctinfo.c                                                |    9 
 net/sched/act_mpls.c                                                  |    2 
 net/sched/act_skbedit.c                                               |    2 
 net/sched/cls_api.c                                                   |    2 
 net/sched/cls_flow.c                                                  |    8 
 net/sched/cls_flower.c                                                |    2 
 net/sched/em_ipset.c                                                  |    2 
 net/sched/em_ipt.c                                                    |    2 
 net/sched/em_meta.c                                                   |    2 
 net/sched/sch_atm.c                                                   |    8 
 net/sched/sch_cake.c                                                  |    4 
 net/sched/sch_dsmark.c                                                |    6 
 net/sched/sch_teql.c                                                  |    2 
 net/sunrpc/xprtrdma/rpc_rdma.c                                        |    4 
 security/apparmor/match.c                                             |    5 
 sound/pci/hda/patch_realtek.c                                         |   27 
 sound/usb/card.c                                                      |   12 
 sound/usb/clock.c                                                     |   59 +
 sound/usb/line6/capture.c                                             |    2 
 sound/usb/line6/driver.c                                              |    2 
 sound/usb/line6/playback.c                                            |    2 
 sound/usb/midi.c                                                      |   17 
 sound/usb/pcm.c                                                       |    7 
 sound/usb/quirks-table.h                                              |   86 --
 sound/usb/quirks.c                                                    |   67 +-
 sound/usb/quirks.h                                                    |    2 
 tools/perf/util/stat.c                                                |    6 
 tools/testing/selftests/net/fib_nexthops.sh                           |   13 
 273 files changed, 2040 insertions(+), 934 deletions(-)

AceLan Kao (2):
      net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
      USB: serial: option: add Quectel EG95 LTE modem

Aharon Landau (1):
      RDMA/mlx5: Verify that QP is created with RQ or SQ

Alex Hung (1):
      thermal: int3403_thermal: Downgrade error message

Alexander Lobakin (1):
      virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Alexander Shishkin (4):
      intel_th: pci: Add Jasper Lake CPU support
      intel_th: pci: Add Tiger Lake PCH-H support
      intel_th: pci: Add Emmitsburg PCH support
      intel_th: Fix a NULL dereference when hub driver is not loaded

Alexander Tsoy (1):
      ALSA: usb-audio: Add support for MOTU MicroBook IIc

Alexander Usyskin (1):
      mei: bus: don't clean driver pointer

Amir Goldstein (3):
      ovl: fix regression with re-formatted lower squashfs
      ovl: relax WARN_ON() when decoding lower directory file handle
      ovl: fix unneeded call to ovl_change_flags()

Andreas Schwab (1):
      riscv: use 16KB kernel stack on 64-bit

Andrey Lebedev (1):
      drm/sun4i: tcon: Separate quirks for tcon0 and tcon1 on A20

Andy Shevchenko (3):
      i2c: eg20t: Load module automatically if ID matches
      dmaengine: dw: Initialize channel before each transfer
      gpio: pca953x: disable regmap locking for automatic address incrementing

Aneesh Kumar K.V (1):
      powerpc/book3s64/pkeys: Fix pkey_access_permitted() for execute disable pkey

Angelo Dureghello (1):
      m68k: mm: fix node memblock init

Anna Schumaker (1):
      NFS: Fix interrupted slots by sending a solo SEQUENCE operation

Anson Huang (1):
      thermal/drivers: imx: Fix missing of_node_put() at probe time

Ard Biesheuvel (2):
      arm64/alternatives: use subsections for replacement sequences
      arm64/alternatives: don't patch up internal branches

Armas Spann (1):
      ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G14(G401) series with ALC289

Bernard Zhao (1):
      drm/msm: fix potential memleak in error branch

Bjorn Helgaas (1):
      PCI/PM: Call .bridge_d3() hook only if non-NULL

Bob Peterson (1):
      gfs2: read-only mounts should grab the sd_freeze_gl glock

Chandrakanth Patil (1):
      scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro

Chirantan Ekbote (1):
      fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Chris Wilson (1):
      drm/i915/gt: Ignore irq enabling on the virtual engines

Chris Wulff (1):
      ALSA: usb-audio: Create a registration quirk for Kingston HyperX Amp (0951:16d8)

Christoffer Nielsen (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S

Christoph Paasch (1):
      tcp: make sure listeners don't initialize congestion-control state

Christophe JAILLET (1):
      iio: adc: ad7780: Fix a resource handling path in 'ad7780_probe()'

Chuhong Yuan (2):
      iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()
      serial: mxs-auart: add missed iounmap() in probe failure and remove

Claudiu Beznea (1):
      ARM: at91: pm: add quirk for sam9x60's ulp1

Codrin Ciubotariu (1):
      net: dsa: microchip: set the correct number of ports

Colin Ian King (2):
      phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked
      xprtrdma: fix incorrect header size calculations

Colin Xu (1):
      drm/i915/gvt: Fix two CFL MMIO handling caused by regression.

Cong Wang (3):
      net_sched: fix a memory leak in atm_tc_init()
      cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
      cgroup: Fix sock_cgroup_data on big-endian.

Dan Carpenter (1):
      staging: comedi: verify array index is correct before using it

Dave Wang (1):
      Input: elan_i2c - add more hardware ID for Lenovo laptops

David Ahern (2):
      ipv6: fib6_select_path can not use out path for nexthop objects
      ipv6: Fix use of anycast address with loopback

David Howells (1):
      rxrpc: Fix trace string

David Pedersen (1):
      Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list

Diego Elio Pettenò (1):
      scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled

Dinghao Liu (1):
      iio: magnetometer: ak8974: Fix runtime PM imbalance on error

Dmitry Bogdanov (1):
      net: atlantic: fix ip dst and ipv6 address filters

Dmitry Torokhov (1):
      HID: magicmouse: do not set up autorepeat

Douglas Anderson (1):
      regmap: debugfs: Don't sleep while atomic for fast_io regmaps

Eddie James (1):
      clk: AST2600: Add mux for EMMC clock

Emmanuel Pescosta (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Alpha S

Enric Balletbo i Serra (1):
      Revert "thermal: mediatek: fix register index error"

Eric Dumazet (6):
      llc: make sure applications use ARPHRD_ETHER
      tcp: fix SO_RCVLOWAT possible hangs under high mem pressure
      tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
      tcp: md5: do not send silly options in SYNCOOKIES
      tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
      tcp: md5: allow changing MD5 keys in all socket states

Esben Haabendal (2):
      uio_pdrv_genirq: Remove warning when irq is not specified
      uio_pdrv_genirq: fix use without device tree and no interrupt

Finley Xiao (1):
      thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix node reference count
      of: of_mdio: Correct loop scanning logic

Frederic Weisbecker (2):
      timer: Prevent base->clk from moving backward
      timer: Fix wheel index calculation on last level

Greg Kroah-Hartman (1):
      Linux 5.4.53

Gregor Pintar (1):
      ALSA: usb-audio: Add quirk for Focusrite Scarlett 2i2

Haibo Chen (1):
      mmc: sdhci: do not enable card detect interrupt for gpio cd type

Hans de Goede (4):
      HID: quirks: Remove ITE 8595 entry from hid_have_special_driver
      ACPI: video: Use native backlight on Acer Aspire 5783z
      virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and _LOG req numbers to match upstream
      virt: vbox: Fix guest capabilities mask check

Hou Tao (1):
      blk-mq-debugfs: update blk_queue_flag_name[] accordingly for new flags

Igor Moura (1):
      USB: serial: ch341: add new Product ID for CH340

Ilya Dryomov (1):
      libceph: don't omit recovery_deletes in target_copy()

James Hilliard (2):
      HID: quirks: Ignore Simply Automated UPB PIM
      USB: serial: cypress_m8: enable Simply Automated UPB PIM

Jan Kiszka (1):
      Revert "tty: xilinx_uartps: Fix missing id assignment to the console"

Jerome Brunet (1):
      arm64: dts: meson: add missing gxl rng clock

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable headset mic of Acer TravelMate B311R-31 with ALC256

Jin Yao (1):
      perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Johan Hovold (1):
      USB: serial: iuu_phoenix: fix memory corruption

John Johansen (1):
      apparmor: ensure that dfa state tables have entries

Jonathan Cameron (6):
      iio:magnetometer:ak8974: Fix alignment and data leak issues
      iio:humidity:hdc100x Fix alignment and data leak issues
      iio:humidity:hts221 Fix alignment and data leak issues
      iio:pressure:ms5611 Fix buffer element alignment
      iio:health:afe4403 Fix timestamp alignment and prevent data leak.
      iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Jörgen Storvist (1):
      USB: serial: option: add GosunCn GM500 series

Kailang Yang (3):
      ALSA: hda/realtek - change to suitable link model for ASUS platform
      ALSA: hda/realtek - Enable Speaker for ASUS UX533 and UX534
      ALSA: hda/realtek - Enable Speaker for ASUS UX563

Kangmin Park (1):
      dt-bindings: mailbox: zynqmp_ipi: fix unit address

Kevin Buettner (1):
      copy_xstate_to_kernel: Fix typo which caused GDB regression

Krishna Manikandan (1):
      drm/msm/dpu: allow initialization of encoder locks during encoder init

Krzysztof Kozlowski (5):
      spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
      ARM: dts: socfpga: Align L2 cache-controller nodename with dtschema
      arm64: dts: spcfpga: Align GIC, NAND and UART nodenames with dtschema
      dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler
      dmaengine: mcf-edma: Fix NULL pointer exception in mcf_edma_tx_handler

Lingling Xu (1):
      spi: sprd: switch the sequence of setting WDG_LOAD_LOW and _HIGH

Linus Lüssing (1):
      bridge: mcast: Fix MLD2 Report IPv6 payload length check

Linus Walleij (1):
      mmc: mmci: Support any block sizes for ux500v2 and qcom variant

Lu Baolu (1):
      iommu/vt-d: Make Intel SVM code 64-bit only

Maciej S. Szmigiero (1):
      HID: logitech-hidpp: avoid repeated "multiplier = " log messages

Marc Kleine-Budde (1):
      spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Marc Zyngier (3):
      arm64: Introduce a way to disable the 32bit vdso
      arm64: arch_timer: Allow an workaround descriptor to disable compat vdso
      arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040

Marek Szyprowski (1):
      drm/exynos: Properly propagate return value in drm_iommu_attach_device()

Martin Varghese (1):
      net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Mathieu Desnoyers (1):
      sched: Fix unreliable rseq cpu_id for new tasks

Matt Ranostay (1):
      iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers

Maulik Shah (3):
      soc: qcom: rpmh: Update dirty flag only when data changes
      soc: qcom: rpmh: Invalidate SLEEP and WAKE TCSes before flushing new data
      soc: qcom: rpmh-rsc: Allow using free WAKE TCS for active request

Michał Mirosław (2):
      usb: gadget: udc: atmel: fix uninitialized read in debug printk
      misc: atmel-ssc: lock with mutex instead of spinlock

Mike Rapoport (1):
      m68k: nommu: register start of the memory with memblock

Miklos Szeredi (2):
      fuse: ignore 'data' argument of mount(..., MS_REMOUNT)
      fuse: use ->reconfigure() instead of ->remount_fs()

Minas Harutyunyan (1):
      usb: dwc2: Fix shutdown callback in platform

Ming Lei (2):
      block: fix splitting segments on boundary masks
      block: fix get_max_segment_size() overflow on 32bit arch

Miquel Raynal (7):
      mtd: rawnand: marvell: Fix the condition on a return code
      mtd: rawnand: marvell: Use nand_cleanup() when the device is not yet registered
      mtd: rawnand: marvell: Fix probe error path
      mtd: rawnand: timings: Fix default tR_max and tCCS_min timings
      mtd: rawnand: oxnas: Keep track of registered devices
      mtd: rawnand: oxnas: Unregister all devices on error
      mtd: rawnand: oxnas: Release all devices in the _remove() path

Nathan Chancellor (1):
      clk: mvebu: ARMADA_AP_CPU_CLK needs to select ARMADA_AP_CP_HELPER

Navid Emamdoost (2):
      drm/exynos: fix ref count leak in mic_pre_enable
      iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Neil Armstrong (3):
      arm64: dts: g12-common: add parkmode_disable_ss_quirk on DWC3 controller
      doc: dt: bindings: usb: dwc3: Update entries for disabling SS instances in park mode
      arm64: dts: meson-gxl-s805x: reduce initial Mali450 core frequency

Paul Menzel (1):
      ACPI: video: Use native backlight on Acer TravelMate 5735Z

Peter Chen (1):
      usb: chipidea: core: add wakeup support for extcon

Peter Ujfalusi (1):
      dmaengine: dmatest: stop completed threads when running without set channel

Petteri Aimonen (1):
      x86/fpu: Reset MXCSR to default in kernel_fpu_begin()

Pierre-Louis Bossart (1):
      soundwire: intel: fix memory leak with devm_kasprintf

Raju P.L.S.S.S.N (1):
      soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS

Robin Gong (1):
      dmaengine: fsl-edma-common: correct DSIZE_32BYTE

Ronnie Sahlberg (1):
      cifs: prevent truncation from long to int in wait_for_free_credits

Russell King (2):
      net: sfp: add support for module quirks
      net: sfp: add some quirks for GPON modules

Sabrina Dubroca (1):
      ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Saravana Kannan (1):
      slimbus: core: Fix mismatch in of_node_get/put

Sascha Hauer (2):
      net: ethernet: mvneta: Do not error out in non serdes modes
      net: ethernet: mvneta: Add back interface mode validation

Sasha Levin (4):
      net: macb: call pm_runtime_put_sync on failure path
      Revert "usb/ohci-platform: Fix a warning when hibernating"
      Revert "usb/ehci-platform: Set PM runtime as active on resume"
      Revert "usb/xhci-plat: Set PM runtime as active on resume"

Satheesh Rajendran (1):
      powerpc/pseries/svm: Fix incorrect check for shared_lppaca_size

Sean Tranchetti (1):
      genetlink: remove genl_bind

Sean Wang (1):
      arm: dts: mt7623: add phy-mode property for gmac2

Sebastian Parschauer (1):
      HID: quirks: Always poll Obins Anne Pro 2 keyboard

Sergei A. Trusov (1):
      Input: goodix - fix touch coordinates on Cube I15-TC

Shannon Nelson (1):
      ionic: export features for vlans to use

Srinivas Kandagatla (1):
      soc: qcom: socinfo: add missing soc_id sysfs entry

Stephan Gerhold (1):
      Input: mms114 - add extra compatible for mms345l

Suman Anna (2):
      ARM: OMAP2+: Add workaround for DRA7 DSP MStandby errata i879
      ARM: OMAP2+: use separate IOMMU pdata to fix DRA7 IPU1 boot

Taehee Yoo (1):
      net: rmnet: fix lower interface leak

Takashi Iwai (4):
      ALSA: usb-audio: Rewrite registration quirk handling
      ALSA: line6: Perform sanity check for each URB creation
      ALSA: line6: Sync the pending work cancel at disconnection
      ALSA: usb-audio: Fix race against the error recovery URB submission

Tero Kristo (1):
      ARM: OMAP4+: remove pdata quirks for omap4+ iommus

Thomas Gleixner (1):
      genirq/affinity: Handle affinity setting on inactive interrupts correctly

Toke Høiland-Jørgensen (2):
      sched: consistently handle layer3 header accesses in the presence of VLANs
      vlan: consolidate VLAN parsing code and limit max parsing depth

Tom Rix (1):
      USB: c67x00: fix use after free in c67x00_giveback_urb

Tomer Tayar (1):
      habanalabs: Align protection bits configuration of all TPCs

Tony Lindgren (9):
      bus: ti-sysc: Rename clk related quirks to pre_reset and post_reset quirks
      bus: ti-sysc: Consider non-existing registers too when matching quirks
      bus: ti-sysc: Handle module unlock quirk needed for some RTC
      bus: ti-sysc: Detect display subsystem related devices
      bus: ti-sysc: Detect EDMA and set quirk flags for tptc
      bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit
      bus: ti-sysc: Fix wakeirq sleeping function called from invalid context
      bus: ti-sysc: Fix sleeping function called from invalid context for RTC quirk
      bus: ti-sysc: Do not disable on suspend for no-idle

Tudor Ambarus (1):
      crypto: atmel - Fix selection of CRYPTO_AUTHENC

Vasily Averin (2):
      tpm_tis: extra chip->ops check on error path in tpm_tis_core_init
      fuse: don't ignore errors from fuse_writepages_fill()

Vincent Guittot (1):
      sched/fair: handle case of task_h_load() returning 0

Vinod Koul (2):
      clk: qcom: gcc: Add GPU and NPU clocks for SM8150
      clk: qcom: gcc: Add missing UFS clocks for SM8150

Vishwas M (1):
      hwmon: (emc2103) fix unable to change fan pwm1_enable attribute

Wade Mealing (1):
      Revert "zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()"

Wei Yongjun (1):
      keys: asymmetric: fix error return code in software_key_query()

Will Deacon (3):
      arm64: ptrace: Override SPSR.SS when single-stepping is enabled
      arm64: ptrace: Consistently use pseudo-singlestep exceptions
      arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return

Willem de Bruijn (1):
      ip: Fix SO_MARK in RST, ACK and ICMP packets

Xiaojie Yuan (1):
      drm/amdgpu/sdma5: fix wptr overwritten in ->get_wptr()

Xin Long (1):
      l2tp: remove skb_dst_set() from l2tp_xmit_skb()

Yoshihiro Shimoda (1):
      dmaengine: sh: usb-dmac: set tx_result parameters

YueHaibing (1):
      crypto: atmel - Fix build error of CRYPTO_AUTHENC

Zhang Qiang (1):
      usb: gadget: function: fix missing spinlock in f_uac1_legacy

dillon min (1):
      ARM: dts: Fix dcan driver probe failed on am437x platform

youngjun (1):
      ovl: inode reference leak in ovl_is_inuse true case.

Álvaro Fernández Rojas (2):
      mtd: rawnand: brcmnand: correctly verify erased pages
      mtd: rawnand: brcmnand: fix CS0 layout

