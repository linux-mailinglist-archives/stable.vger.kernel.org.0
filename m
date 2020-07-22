Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425C02298AC
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732458AbgGVMxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbgGVMxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C65720771;
        Wed, 22 Jul 2020 12:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422429;
        bh=5FLwsPCwEAlWxwkOQMvmY0efUd+xMy0Tjp+GFEoLNFI=;
        h=From:To:Cc:Subject:Date:From;
        b=ylsVanv7sFFB4eoZ/p5zeu4iQVWNMjgYVcxDRDBtVuCsaoMFVrJ6ZUmQHjD8XTfqD
         4FFuLaPcW7X8Wvb81snjBHBgMv6m5HXhVNKsK1s4u+fD1GVK9H5pNwpHttUT3KciVe
         FIfBXtNdvlnoVKqGZAwhYWkKZFZUPw8bYyE6bL34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.10
Date:   Wed, 22 Jul 2020 14:53:46 +0200
Message-Id: <159542242685238@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.10 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                                   |    8 
 Documentation/devicetree/bindings/Makefile                               |    5 
 Documentation/devicetree/bindings/bus/socionext,uniphier-system-bus.yaml |    4 
 Documentation/devicetree/bindings/mailbox/xlnx,zynqmp-ipi-mailbox.txt    |    2 
 Makefile                                                                 |    2 
 arch/arm/boot/dts/am437x-l4.dtsi                                         |   14 
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi                                    |    2 
 arch/arm/boot/dts/mt7623n-rfb-emmc.dts                                   |    1 
 arch/arm/boot/dts/socfpga.dtsi                                           |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi                                   |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi                        |    8 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts                   |    1 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts              |    7 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dts             |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dts                     |    2 
 arch/arm64/boot/dts/amlogic/meson-gxl-s805x.dtsi                         |   24 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi                               |    5 
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts                       |    1 
 arch/arm64/include/asm/alternative.h                                     |   16 
 arch/arm64/include/asm/cputype.h                                         |    2 
 arch/arm64/include/asm/debug-monitors.h                                  |    2 
 arch/arm64/include/asm/syscall.h                                         |   12 
 arch/arm64/include/asm/thread_info.h                                     |    1 
 arch/arm64/kernel/alternative.c                                          |   16 
 arch/arm64/kernel/cpu_errata.c                                           |   22 -
 arch/arm64/kernel/cpufeature.c                                           |    2 
 arch/arm64/kernel/debug-monitors.c                                       |   20 -
 arch/arm64/kernel/ptrace.c                                               |   29 +
 arch/arm64/kernel/signal.c                                               |   11 
 arch/arm64/kernel/syscall.c                                              |    5 
 arch/arm64/kernel/vmlinux.lds.S                                          |    3 
 arch/m68k/kernel/setup_no.c                                              |    3 
 arch/m68k/mm/mcfmmu.c                                                    |    2 
 arch/powerpc/kernel/paca.c                                               |    2 
 arch/powerpc/mm/book3s64/pkeys.c                                         |   12 
 arch/riscv/include/asm/thread_info.h                                     |    4 
 arch/x86/include/asm/fpu/internal.h                                      |    5 
 arch/x86/include/asm/io_bitmap.h                                         |   16 
 arch/x86/include/asm/paravirt.h                                          |    5 
 arch/x86/include/asm/paravirt_types.h                                    |    1 
 arch/x86/kernel/apic/vector.c                                            |   22 -
 arch/x86/kernel/fpu/core.c                                               |    6 
 arch/x86/kernel/fpu/xstate.c                                             |    2 
 arch/x86/kernel/paravirt.c                                               |    3 
 arch/x86/kernel/process.c                                                |   18 -
 arch/x86/xen/enlighten_pv.c                                              |   12 
 block/blk-mq-debugfs.c                                                   |    3 
 crypto/asymmetric_keys/public_key.c                                      |    1 
 drivers/acpi/dptf/dptf_power.c                                           |    1 
 drivers/base/regmap/regmap-debugfs.c                                     |   52 +--
 drivers/block/zram/zram_drv.c                                            |    3 
 drivers/bus/ti-sysc.c                                                    |   23 -
 drivers/char/tpm/tpm_tis_core.c                                          |    2 
 drivers/char/virtio_console.c                                            |    3 
 drivers/clk/clk-ast2600.c                                                |   49 ++
 drivers/clk/mvebu/Kconfig                                                |    1 
 drivers/clk/qcom/gcc-msm8998.c                                           |   27 +
 drivers/clk/qcom/gcc-sc7180.c                                            |   73 ++--
 drivers/clk/qcom/gcc-sm8150.c                                            |  148 ++++++++
 drivers/counter/104-quad-8.c                                             |   22 +
 drivers/dma-buf/dma-buf.c                                                |   11 
 drivers/dma/dmatest.c                                                    |    2 
 drivers/dma/dw/core.c                                                    |   12 
 drivers/dma/fsl-edma-common.h                                            |    2 
 drivers/dma/fsl-edma.c                                                   |    7 
 drivers/dma/idxd/cdev.c                                                  |   19 -
 drivers/dma/idxd/device.c                                                |   25 +
 drivers/dma/idxd/idxd.h                                                  |    1 
 drivers/dma/idxd/irq.c                                                   |    3 
 drivers/dma/idxd/sysfs.c                                                 |    5 
 drivers/dma/mcf-edma.c                                                   |    7 
 drivers/dma/sh/usb-dmac.c                                                |    2 
 drivers/dma/ti/k3-udma.c                                                 |    8 
 drivers/gpio/gpio-pca953x.c                                              |    1 
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c                                   |   26 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                        |   14 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h                        |   11 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c              |   53 +--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h              |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c                          |   19 -
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c                               |    2 
 drivers/gpu/drm/exynos/exynos_drm_dma.c                                  |    4 
 drivers/gpu/drm/exynos/exynos_drm_mic.c                                  |    4 
 drivers/gpu/drm/i915/display/intel_hdmi.c                                |   10 
 drivers/gpu/drm/i915/gt/intel_lrc.c                                      |   19 -
 drivers/gpu/drm/i915/gvt/handlers.c                                      |    4 
 drivers/gpu/drm/i915/i915_perf.c                                         |    1 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                              |    4 
 drivers/gpu/drm/msm/msm_submitqueue.c                                    |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c                                     |    8 
 drivers/hid/hid-ids.h                                                    |    3 
 drivers/hid/hid-logitech-hidpp.c                                         |    2 
 drivers/hid/hid-magicmouse.c                                             |    6 
 drivers/hid/hid-quirks.c                                                 |    2 
 drivers/hwmon/drivetemp.c                                                |   43 ++
 drivers/hwmon/emc2103.c                                                  |    2 
 drivers/hwtracing/coresight/coresight-etm4x.c                            |   82 +++-
 drivers/hwtracing/intel_th/core.c                                        |   21 +
 drivers/hwtracing/intel_th/pci.c                                         |   15 
 drivers/hwtracing/intel_th/sth.c                                         |    4 
 drivers/i2c/busses/i2c-eg20t.c                                           |    1 
 drivers/iio/accel/mma8452.c                                              |    5 
 drivers/iio/adc/ad7780.c                                                 |    2 
 drivers/iio/health/afe4403.c                                             |   13 
 drivers/iio/health/afe4404.c                                             |    8 
 drivers/iio/humidity/hdc100x.c                                           |   10 
 drivers/iio/humidity/hts221.h                                            |    7 
 drivers/iio/humidity/hts221_buffer.c                                     |    9 
 drivers/iio/industrialio-core.c                                          |    2 
 drivers/iio/magnetometer/ak8974.c                                        |   29 -
 drivers/iio/pressure/ms5611_core.c                                       |   11 
 drivers/iio/pressure/zpa2326.c                                           |    4 
 drivers/infiniband/hw/mlx5/qp.c                                          |    2 
 drivers/infiniband/sw/rxe/rxe.c                                          |    1 
 drivers/infiniband/sw/rxe/rxe_param.h                                    |    3 
 drivers/input/serio/i8042-x86ia64io.h                                    |    7 
 drivers/input/touchscreen/elants_i2c.c                                   |    1 
 drivers/input/touchscreen/mms114.c                                       |   17 
 drivers/iommu/Kconfig                                                    |    2 
 drivers/misc/atmel-ssc.c                                                 |   24 -
 drivers/misc/habanalabs/goya/goya_security.c                             |   99 +++++
 drivers/misc/mei/bus.c                                                   |    3 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                                 |   24 -
 drivers/mtd/nand/raw/marvell_nand.c                                      |   27 -
 drivers/mtd/nand/raw/nand_timings.c                                      |    5 
 drivers/mtd/nand/raw/oxnas_nand.c                                        |   24 +
 drivers/mtd/spi-nor/sfdp.c                                               |    4 
 drivers/mtd/spi-nor/sfdp.h                                               |    6 
 drivers/mtd/spi-nor/spansion.c                                           |   25 +
 drivers/mtd/spi-nor/winbond.c                                            |   29 +
 drivers/net/dsa/microchip/ksz8795.c                                      |    3 
 drivers/net/dsa/microchip/ksz9477.c                                      |    3 
 drivers/net/ethernet/marvell/mvneta.c                                    |   24 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                          |    4 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c                       |    5 
 drivers/net/ipa/gsi.c                                                    |   13 
 drivers/net/ipa/ipa_cmd.c                                                |   15 
 drivers/net/ipa/ipa_cmd.h                                                |    8 
 drivers/net/ipa/ipa_endpoint.c                                           |    2 
 drivers/net/usb/qmi_wwan.c                                               |    1 
 drivers/nvme/host/core.c                                                 |    1 
 drivers/nvme/host/nvme.h                                                 |   13 
 drivers/opp/of.c                                                         |    4 
 drivers/pci/pci.c                                                        |    4 
 drivers/phy/allwinner/phy-sun4i-usb.c                                    |    5 
 drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c                         |    4 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                              |    2 
 drivers/scsi/qla2xxx/qla_def.h                                           |    4 
 drivers/slimbus/core.c                                                   |    1 
 drivers/soc/qcom/rpmh-rsc.c                                              |   98 +++--
 drivers/soc/qcom/rpmh.c                                                  |   56 +--
 drivers/soc/qcom/socinfo.c                                               |    2 
 drivers/soundwire/intel.c                                                |    5 
 drivers/spi/spi-fsl-dspi.c                                               |   15 
 drivers/spi/spi-sprd-adi.c                                               |    2 
 drivers/spi/spi-sun6i.c                                                  |   14 
 drivers/staging/comedi/drivers/addi_apci_1500.c                          |   10 
 drivers/thermal/imx_thermal.c                                            |    7 
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c                  |    2 
 drivers/thermal/mtk_thermal.c                                            |    6 
 drivers/thunderbolt/tunnel.c                                             |   12 
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                              |    9 
 drivers/tty/serial/mxs-auart.c                                           |   12 
 drivers/tty/serial/serial_core.c                                         |  112 ------
 drivers/tty/serial/sh-sci.c                                              |    3 
 drivers/tty/serial/xilinx_uartps.c                                       |    1 
 drivers/uio/uio_pdrv_genirq.c                                            |    4 
 drivers/usb/c67x00/c67x00-sched.c                                        |    2 
 drivers/usb/chipidea/core.c                                              |   24 +
 drivers/usb/dwc2/platform.c                                              |    3 
 drivers/usb/gadget/function/f_uac1_legacy.c                              |    2 
 drivers/usb/gadget/udc/atmel_usba_udc.c                                  |    2 
 drivers/usb/serial/ch341.c                                               |    1 
 drivers/usb/serial/cypress_m8.c                                          |    2 
 drivers/usb/serial/cypress_m8.h                                          |    3 
 drivers/usb/serial/iuu_phoenix.c                                         |    8 
 drivers/usb/serial/option.c                                              |    6 
 drivers/virt/vboxguest/vboxguest_core.c                                  |    6 
 drivers/virt/vboxguest/vboxguest_core.h                                  |   15 
 drivers/virt/vboxguest/vboxguest_linux.c                                 |    3 
 drivers/virt/vboxguest/vmmdev.h                                          |    2 
 drivers/xen/xenbus/xenbus_client.c                                       |  171 ++++------
 fs/cifs/transport.c                                                      |    2 
 fs/fuse/file.c                                                           |   14 
 fs/fuse/inode.c                                                          |   15 
 fs/gfs2/glops.c                                                          |   10 
 fs/gfs2/incore.h                                                         |    1 
 fs/gfs2/log.c                                                            |   15 
 fs/gfs2/log.h                                                            |    4 
 fs/gfs2/main.c                                                           |    1 
 fs/gfs2/ops_fstype.c                                                     |   13 
 fs/gfs2/recovery.c                                                       |    4 
 fs/gfs2/super.c                                                          |   20 -
 fs/io_uring.c                                                            |   10 
 fs/nfs/nfs4proc.c                                                        |   20 +
 fs/overlayfs/export.c                                                    |    2 
 fs/overlayfs/file.c                                                      |   10 
 fs/overlayfs/super.c                                                     |   23 +
 include/dt-bindings/clock/qcom,gcc-msm8998.h                             |    1 
 include/linux/blkdev.h                                                   |    1 
 include/linux/bpf.h                                                      |   13 
 include/linux/cgroup-defs.h                                              |    8 
 include/linux/cgroup.h                                                   |    4 
 include/linux/dma-buf.h                                                  |    1 
 include/linux/if_vlan.h                                                  |   29 +
 include/linux/input/elan-i2c-ids.h                                       |    7 
 include/linux/serial_core.h                                              |  102 +++++
 include/linux/skmsg.h                                                    |   13 
 include/net/dst.h                                                        |   10 
 include/net/genetlink.h                                                  |   10 
 include/net/inet_ecn.h                                                   |   25 -
 include/net/pkt_sched.h                                                  |   11 
 include/trace/events/rxrpc.h                                             |    2 
 include/uapi/linux/vboxguest.h                                           |    4 
 kernel/bpf/syscall.c                                                     |    2 
 kernel/cgroup/cgroup.c                                                   |   31 +
 kernel/irq/manage.c                                                      |   37 ++
 kernel/sched/core.c                                                      |    2 
 kernel/sched/fair.c                                                      |   15 
 kernel/time/timer.c                                                      |   21 -
 mm/memory.c                                                              |   21 -
 net/bridge/br_multicast.c                                                |    2 
 net/ceph/osd_client.c                                                    |    1 
 net/core/filter.c                                                        |   10 
 net/core/sock.c                                                          |    2 
 net/core/sock_map.c                                                      |   53 ++-
 net/ethtool/netlink.c                                                    |   27 -
 net/hsr/hsr_device.c                                                     |   11 
 net/ipv4/icmp.c                                                          |    4 
 net/ipv4/ip_output.c                                                     |    2 
 net/ipv4/ping.c                                                          |    3 
 net/ipv4/route.c                                                         |    2 
 net/ipv4/tcp.c                                                           |   15 
 net/ipv4/tcp_cong.c                                                      |    2 
 net/ipv4/tcp_input.c                                                     |    2 
 net/ipv4/tcp_ipv4.c                                                      |   15 
 net/ipv4/tcp_output.c                                                    |    8 
 net/ipv6/icmp.c                                                          |    4 
 net/ipv6/route.c                                                         |    7 
 net/l2tp/l2tp_core.c                                                     |    5 
 net/llc/af_llc.c                                                         |   10 
 net/mptcp/options.c                                                      |    6 
 net/netlink/genetlink.c                                                  |   97 -----
 net/qrtr/qrtr.c                                                          |    4 
 net/sched/act_connmark.c                                                 |    9 
 net/sched/act_csum.c                                                     |    2 
 net/sched/act_ct.c                                                       |    9 
 net/sched/act_ctinfo.c                                                   |    9 
 net/sched/act_mpls.c                                                     |    2 
 net/sched/act_skbedit.c                                                  |    2 
 net/sched/cls_api.c                                                      |    2 
 net/sched/cls_flow.c                                                     |    8 
 net/sched/cls_flower.c                                                   |    2 
 net/sched/em_ipset.c                                                     |    2 
 net/sched/em_ipt.c                                                       |    2 
 net/sched/em_meta.c                                                      |    2 
 net/sched/sch_atm.c                                                      |    8 
 net/sched/sch_cake.c                                                     |    4 
 net/sched/sch_dsmark.c                                                   |    6 
 net/sched/sch_teql.c                                                     |    2 
 net/sunrpc/xprtrdma/rpc_rdma.c                                           |    4 
 net/sunrpc/xprtrdma/transport.c                                          |    5 
 net/sunrpc/xprtrdma/verbs.c                                              |   35 --
 security/apparmor/match.c                                                |    5 
 sound/pci/hda/patch_realtek.c                                            |   27 +
 sound/usb/line6/capture.c                                                |    2 
 sound/usb/line6/driver.c                                                 |    2 
 sound/usb/line6/playback.c                                               |    2 
 sound/usb/midi.c                                                         |   17 
 tools/perf/util/stat.c                                                   |    6 
 tools/testing/selftests/net/fib_nexthops.sh                              |   13 
 271 files changed, 2280 insertions(+), 1100 deletions(-)

AceLan Kao (2):
      net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
      USB: serial: option: add Quectel EG95 LTE modem

Aharon Landau (1):
      RDMA/mlx5: Verify that QP is created with RQ or SQ

Alex Deucher (1):
      drm/amdgpu/display: create fake mst encoders ahead of time (v4)

Alex Elder (2):
      net: ipa: always check for stopped channel
      net: ipa: introduce ipa_cmd_tag_process()

Alex Hung (1):
      thermal: int3403_thermal: Downgrade error message

Alexander Lobakin (1):
      virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Alexander Shishkin (4):
      intel_th: pci: Add Jasper Lake CPU support
      intel_th: pci: Add Tiger Lake PCH-H support
      intel_th: pci: Add Emmitsburg PCH support
      intel_th: Fix a NULL dereference when hub driver is not loaded

Alexander Usyskin (1):
      mei: bus: don't clean driver pointer

Amir Goldstein (3):
      ovl: fix regression with re-formatted lower squashfs
      ovl: relax WARN_ON() when decoding lower directory file handle
      ovl: fix unneeded call to ovl_change_flags()

Andreas Schwab (1):
      riscv: use 16KB kernel stack on 64-bit

Andy Lutomirski (1):
      x86/ioperm: Fix io bitmap invalidation on Xen PV

Andy Shevchenko (4):
      i2c: eg20t: Load module automatically if ID matches
      dmaengine: dw: Initialize channel before each transfer
      serial: core: Initialise spin lock before use in uart_configure_port()
      gpio: pca953x: disable regmap locking for automatic address incrementing

Aneesh Kumar K.V (1):
      powerpc/book3s64/pkeys: Fix pkey_access_permitted() for execute disable pkey

Angelo Dureghello (1):
      m68k: mm: fix node memblock init

Anna Schumaker (1):
      NFS: Fix interrupted slots by sending a solo SEQUENCE operation

Anson Huang (1):
      thermal/drivers: imx: Fix missing of_node_put() at probe time

Anthony Iliopoulos (1):
      nvme: explicitly update mpath disk capacity on revalidation

Ard Biesheuvel (2):
      arm64/alternatives: use subsections for replacement sequences
      arm64/alternatives: don't patch up internal branches

Arjun Roy (1):
      mm/memory.c: properly pte_offset_map_lock/unlock in vm_insert_pages()

Armas Spann (1):
      ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G14(G401) series with ALC289

Bernard Zhao (1):
      drm/msm: fix potential memleak in error branch

Bjorn Helgaas (1):
      PCI/PM: Call .bridge_d3() hook only if non-NULL

Bob Peterson (5):
      gfs2: eliminate GIF_ORDERED in favor of list_empty
      gfs2: freeze should work on read-only mounts
      gfs2: read-only mounts should grab the sd_freeze_gl glock
      gfs2: When freezing gfs2, use GL_EXACT and not GL_NOCACHE
      gfs2: The freeze glock should never be frozen

Carl Huang (1):
      net: qrtr: free flow in __qrtr_node_release

Chandrakanth Patil (1):
      scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro

Charan Teja Kalla (1):
      dmabuf: use spinlock to access dmabuf->name

Chirantan Ekbote (1):
      fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Chris Wilson (2):
      drm/i915/gt: Ignore irq enabling on the virtual engines
      drm/i915/gt: Only swap to a random sibling once upon creation

Christoph Paasch (1):
      tcp: make sure listeners don't initialize congestion-control state

Christophe JAILLET (1):
      iio: adc: ad7780: Fix a resource handling path in 'ad7780_probe()'

Christophe Leroy (1):
      tty: serial: cpm_uart: Fix behaviour for non existing GPIOs

Chuck Lever (4):
      xprtrdma: Fix double-free in rpcrdma_ep_create()
      xprtrdma: Fix recursion into rpcrdma_xprt_disconnect()
      xprtrdma: Fix return code from rpcrdma_xprt_connect()
      xprtrdma: Fix handling of connect errors

Chuhong Yuan (2):
      iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()
      serial: mxs-auart: add missed iounmap() in probe failure and remove

Codrin Ciubotariu (1):
      net: dsa: microchip: set the correct number of ports

Colin Ian King (3):
      scsi: qla2xxx: make 1-bit bit-fields unsigned int
      phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked
      xprtrdma: fix incorrect header size calculations

Colin Xu (1):
      drm/i915/gvt: Fix two CFL MMIO handling caused by regression.

Cong Wang (4):
      net_sched: fix a memory leak in atm_tc_init()
      cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
      cgroup: Fix sock_cgroup_data on big-endian.
      genetlink: get rid of family->attrbuf

Dan Carpenter (2):
      xen/xenbus: Fix a double free in xenbus_map_ring_pv()
      staging: comedi: verify array index is correct before using it

Dave Jiang (2):
      dmaengine: idxd: cleanup workqueue config after disabling
      dmaengine: idxd: fix misc interrupt handler thread unmasking

Dave Wang (1):
      Input: elan_i2c - add more hardware ID for Lenovo laptops

David Ahern (2):
      ipv6: fib6_select_path can not use out path for nexthop objects
      ipv6: Fix use of anycast address with loopback

David Howells (1):
      rxrpc: Fix trace string

David Pedersen (1):
      Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list

Dinghao Liu (1):
      iio: magnetometer: ak8974: Fix runtime PM imbalance on error

Dinh Nguyen (3):
      arm64: dts: agilex: add status to qspi dts node
      arm64: dts: stratix10: add status to qspi dts node
      arm64: dts: stratix10: increase QSPI reg address in nand dts file

Dmitry Torokhov (2):
      HID: magicmouse: do not set up autorepeat
      Revert "Input: elants_i2c - report resolution information for touch major"

Douglas Anderson (1):
      regmap: debugfs: Don't sleep while atomic for fast_io regmaps

Eddie James (1):
      clk: AST2600: Add mux for EMMC clock

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

Florian Fainelli (1):
      arm64: Add missing sentinel to erratum_1463225

Frederic Weisbecker (2):
      timer: Prevent base->clk from moving backward
      timer: Fix wheel index calculation on last level

Greg Kroah-Hartman (1):
      Linux 5.7.10

Hans de Goede (2):
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

Jeffrey Hugo (1):
      clk: qcom: Add missing msm8998 ufs_unipro_core_clk_src

Jerome Brunet (1):
      arm64: dts: meson: add missing gxl rng clock

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable headset mic of Acer TravelMate B311R-31 with ALC256

Jin Yao (1):
      perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Johan Hovold (3):
      USB: serial: iuu_phoenix: fix memory corruption
      Revert "serial: core: Refactor uart_unlock_and_check_sysrq()"
      serial: core: fix sysrq overhead regression

John Johansen (1):
      apparmor: ensure that dfa state tables have entries

Jonathan Cameron (6):
      iio:magnetometer:ak8974: Fix alignment and data leak issues
      iio:humidity:hdc100x Fix alignment and data leak issues
      iio:humidity:hts221 Fix alignment and data leak issues
      iio:pressure:ms5611 Fix buffer element alignment
      iio:health:afe4403 Fix timestamp alignment and prevent data leak.
      iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Josip Pavic (1):
      drm/amd/display: handle failed allocation during stream construction

Juergen Gross (2):
      xen/xenbus: avoid large structs and arrays on the stack
      xen/xenbus: let xenbus_map_ring_valloc() return errno values only

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

Lad Prabhakar (1):
      serial: sh-sci: Initialize spinlock for uart console

Lingling Xu (1):
      spi: sprd: switch the sequence of setting WDG_LOAD_LOW and _HIGH

Linus Lüssing (1):
      bridge: mcast: Fix MLD2 Report IPv6 payload length check

Lorenz Bauer (2):
      bpf: sockmap: Check value of unused args to BPF_PROG_ATTACH
      bpf: sockmap: Require attach_bpf_fd when detaching a program

Lu Baolu (1):
      iommu/vt-d: Make Intel SVM code 64-bit only

Maarten Lankhorst (1):
      drm/i915: Move cec_notifier to intel_hdmi_connector_unregister, v2.

Maciej S. Szmigiero (2):
      HID: logitech-hidpp: avoid repeated "multiplier = " log messages
      hwmon: (drivetemp) Avoid SCT usage on Toshiba DT01ACA family drives

Mantas Pucka (1):
      mtd: spi-nor: winbond: Fix 4-byte opcode support for w25q256

Marc Kleine-Budde (1):
      spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Marek Szyprowski (1):
      drm/exynos: Properly propagate return value in drm_iommu_attach_device()

Martin Varghese (1):
      net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Masahiro Yamada (2):
      dt-bindings: bus: uniphier-system-bus: fix warning in example
      dt-bindings: fix error in 'make clean' after 'make dt_binding_check'

Mathieu Desnoyers (1):
      sched: Fix unreliable rseq cpu_id for new tasks

Matt Ranostay (1):
      iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers

Maulik Shah (3):
      soc: qcom: rpmh: Update dirty flag only when data changes
      soc: qcom: rpmh: Invalidate SLEEP and WAKE TCSes before flushing new data
      soc: qcom: rpmh-rsc: Allow using free WAKE TCS for active request

Miaohe Lin (1):
      net: ipv4: Fix wrong type conversion from hint to rt in ip_route_use_hint()

Michal Kubecek (1):
      ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()

Michał Mirosław (2):
      usb: gadget: udc: atmel: fix uninitialized read in debug printk
      misc: atmel-ssc: lock with mutex instead of spinlock

Mika Westerberg (1):
      thunderbolt: Fix path indices used in USB3 tunnel discovery

Mike Leach (1):
      coresight: etmv4: Fix CPU power management setup in probe() function

Mike Rapoport (1):
      m68k: nommu: register start of the memory with memblock

Miklos Szeredi (2):
      fuse: ignore 'data' argument of mount(..., MS_REMOUNT)
      fuse: use ->reconfigure() instead of ->remount_fs()

Minas Harutyunyan (1):
      usb: dwc2: Fix shutdown callback in platform

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

Neil Armstrong (1):
      arm64: dts: meson-gxl-s805x: reduce initial Mali450 core frequency

Nikhil Rao (1):
      dmaengine: idxd: fix cdev locking for open and release

Paolo Abeni (1):
      mptcp: fix DSS map generation on fin retransmission

Pavel Begunkov (1):
      io_uring: fix recvmsg memory leak with buffer selection

Peter Chen (1):
      usb: chipidea: core: add wakeup support for extcon

Peter Ujfalusi (4):
      dmaengine: ti: k3-udma: Use correct node to read "ti,udma-atype"
      dmaengine: ti: k3-udma: Fix delayed_work usage for tx drain workaround
      dmaengine: dmatest: stop completed threads when running without set channel
      dmaengine: ti: k3-udma: Disable memcopy via MCU NAVSS on am654

Petteri Aimonen (1):
      x86/fpu: Reset MXCSR to default in kernel_fpu_begin()

Pierre-Louis Bossart (1):
      soundwire: intel: fix memory leak with devm_kasprintf

Raju P.L.S.S.S.N (1):
      soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS

Robin Gong (1):
      dmaengine: fsl-edma-common: correct DSIZE_32BYTE

Roland Scheidegger (1):
      drm/vmwgfx: fix update of display surface when resolution changes

Ronnie Sahlberg (1):
      cifs: prevent truncation from long to int in wait_for_free_credits

Sabrina Dubroca (1):
      ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Sai Prakash Ranjan (3):
      arm64: Add MIDR value for KRYO4XX gold CPU cores
      arm64: Add KRYO4XX gold CPU cores to erratum list 1463225 and 1418040
      arm64: Add KRYO4XX silver CPU cores to erratum list 1530923 and 1024718

Saravana Kannan (1):
      slimbus: core: Fix mismatch in of_node_get/put

Sascha Hauer (2):
      net: ethernet: mvneta: Do not error out in non serdes modes
      net: ethernet: mvneta: Add back interface mode validation

Satheesh Rajendran (1):
      powerpc/pseries/svm: Fix incorrect check for shared_lppaca_size

Sean Tranchetti (1):
      genetlink: remove genl_bind

Sean Wang (1):
      arm: dts: mt7623: add phy-mode property for gmac2

Sebastian Parschauer (1):
      HID: quirks: Always poll Obins Anne Pro 2 keyboard

Sergei Shtylyov (1):
      mtd: spi-nor: spansion: fix writes on S25FS512S

Shannon Nelson (2):
      ionic: no link check while resetting queues
      ionic: export features for vlans to use

Srinivas Kandagatla (1):
      soc: qcom: socinfo: add missing soc_id sysfs entry

Srinivas Pandruvada (1):
      ACPI: DPTF: Add battery participant for TigerLake

Stephan Gerhold (1):
      Input: mms114 - add extra compatible for mms345l

Syed Nayyar Waris (2):
      counter: 104-quad-8: Add lock guards - differential encoder
      counter: 104-quad-8: Add lock guards - filter clock prescaler

Taehee Yoo (2):
      net: rmnet: do not allow to add multiple bridge interfaces
      hsr: fix interface leak in error path of hsr_dev_finalize()

Takashi Iwai (3):
      ALSA: line6: Perform sanity check for each URB creation
      ALSA: line6: Sync the pending work cancel at disconnection
      ALSA: usb-audio: Fix race against the error recovery URB submission

Taniya Das (1):
      clk: qcom: gcc: Add support for a new frequency for SC7180

Thomas Gleixner (1):
      genirq/affinity: Handle affinity setting on inactive interrupts correctly

Tiezhu Yang (1):
      phy: rockchip: Fix return value of inno_dsidphy_probe()

Tim Harvey (1):
      ARM: dts: imx6qdl-gw551x: fix audio SSI

Toke Høiland-Jørgensen (2):
      sched: consistently handle layer3 header accesses in the presence of VLANs
      vlan: consolidate VLAN parsing code and limit max parsing depth

Tom Rix (1):
      USB: c67x00: fix use after free in c67x00_giveback_urb

Tomer Tayar (1):
      habanalabs: Align protection bits configuration of all TPCs

Tony Lindgren (3):
      bus: ti-sysc: Fix wakeirq sleeping function called from invalid context
      bus: ti-sysc: Fix sleeping function called from invalid context for RTC quirk
      bus: ti-sysc: Do not disable on suspend for no-idle

Umesh Nerlige Ramappa (1):
      drm/i915/perf: Use GTT when saving/restoring engine GPR

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

Walter Lozano (1):
      opp: Increase parsed_static_opps in _of_add_opp_table_v1()

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

Zhang Qiang (1):
      usb: gadget: function: fix missing spinlock in f_uac1_legacy

Zhu Yanjun (1):
      RDMA/rxe: Set default vendor ID

chen gong (1):
      drm/amdgpu/powerplay: Modify SMC message name for setting power profile mode

dillon min (1):
      ARM: dts: Fix dcan driver probe failed on am437x platform

hersen wu (1):
      drm/amd/display: OLED panel backlight adjust not work with external display connected

youngjun (1):
      ovl: inode reference leak in ovl_is_inuse true case.

Álvaro Fernández Rojas (2):
      mtd: rawnand: brcmnand: correctly verify erased pages
      mtd: rawnand: brcmnand: fix CS0 layout

