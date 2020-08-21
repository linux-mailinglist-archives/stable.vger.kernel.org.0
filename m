Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3DA24D435
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHULjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 07:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgHULjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 07:39:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A63207DF;
        Fri, 21 Aug 2020 11:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598009930;
        bh=1TO7tiaKp58hqQAts51VxwhJxLvwJw54BMDdAblXj54=;
        h=From:To:Cc:Subject:Date:From;
        b=1LnAtFbRCINUFEniQsxnT+HZNWWVl2BYMBGWtUbPG5qBi3cAQwIFwx1fsIwQtwSVI
         MG9d+TNhiIxve3KBunTV5+lnBn3xBFylFSlLXlBzZxoTnIhNWjvFvuxPQPgsbObDXP
         K7v1Cf9E2DjSu1hyyQyDj/27tJUozI0zcT/X5qKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.194
Date:   Fri, 21 Aug 2020 13:39:03 +0200
Message-Id: <159800994416237@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.194 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                              |    3 
 Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt |    2 
 Makefile                                                             |    2 
 arch/arm/kernel/stacktrace.c                                         |   24 +
 arch/arm/mach-at91/pm.c                                              |   11 
 arch/arm/mach-socfpga/pm.c                                           |    8 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts                      |    1 
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts                    |   11 
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts                       |    2 
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi                           |   10 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                        |    4 
 arch/m68k/mac/iop.c                                                  |   21 -
 arch/mips/cavium-octeon/octeon-usb.c                                 |    5 
 arch/mips/kernel/topology.c                                          |    2 
 arch/parisc/include/asm/barrier.h                                    |   61 +++
 arch/powerpc/include/asm/percpu.h                                    |    4 
 arch/powerpc/kernel/vdso.c                                           |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c                      |    2 
 arch/sh/boards/mach-landisk/setup.c                                  |    3 
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S                              |   14 
 arch/x86/kernel/apic/io_apic.c                                       |    5 
 arch/x86/kernel/apic/vector.c                                        |    4 
 arch/x86/kernel/cpu/mcheck/mce-inject.c                              |    2 
 arch/x86/kernel/ptrace.c                                             |    2 
 arch/xtensa/kernel/perf_event.c                                      |    2 
 drivers/acpi/acpica/exprep.c                                         |    4 
 drivers/acpi/acpica/utdelete.c                                       |    6 
 drivers/android/binder.c                                             |   15 
 drivers/atm/atmtcp.c                                                 |   10 
 drivers/bluetooth/hci_serdev.c                                       |    3 
 drivers/char/agp/intel-gtt.c                                         |    4 
 drivers/clk/sirf/clk-atlas6.c                                        |    2 
 drivers/crypto/cavium/cpt/cptvf_algs.c                               |    1 
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c                         |   12 
 drivers/crypto/cavium/cpt/request_manager.h                          |    2 
 drivers/crypto/ccp/ccp-dev.h                                         |    1 
 drivers/crypto/ccp/ccp-ops.c                                         |   37 +-
 drivers/crypto/qat/qat_common/qat_uclo.c                             |    9 
 drivers/edac/edac_device_sysfs.c                                     |    1 
 drivers/edac/edac_pci_sysfs.c                                        |    2 
 drivers/gpu/drm/arm/malidp_planes.c                                  |    2 
 drivers/gpu/drm/bridge/sil-sii8620.c                                 |    2 
 drivers/gpu/drm/drm_debugfs.c                                        |    8 
 drivers/gpu/drm/drm_mipi_dsi.c                                       |    6 
 drivers/gpu/drm/imx/imx-ldb.c                                        |    7 
 drivers/gpu/drm/imx/imx-tve.c                                        |   20 -
 drivers/gpu/drm/nouveau/nouveau_drm.c                                |    8 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                              |    3 
 drivers/gpu/drm/nouveau/nouveau_gem.c                                |    4 
 drivers/gpu/drm/panel/panel-simple.c                                 |    2 
 drivers/gpu/drm/radeon/ci_dpm.c                                      |    2 
 drivers/gpu/drm/radeon/radeon_display.c                              |    4 
 drivers/gpu/drm/radeon/radeon_drv.c                                  |    4 
 drivers/gpu/drm/radeon/radeon_kms.c                                  |    4 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c                                |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                  |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                                  |    5 
 drivers/gpu/host1x/debug.c                                           |    4 
 drivers/gpu/ipu-v3/ipu-image-convert.c                               |   58 +--
 drivers/hid/hid-input.c                                              |    6 
 drivers/hv/channel_mgmt.c                                            |   21 -
 drivers/hv/vmbus_drv.c                                               |    4 
 drivers/hwtracing/coresight/coresight-tmc-etf.c                      |   13 
 drivers/i2c/busses/i2c-rcar.c                                        |   15 
 drivers/i2c/i2c-core-slave.c                                         |    7 
 drivers/iio/dac/ad5592r-base.c                                       |    4 
 drivers/infiniband/ulp/ipoib/ipoib.h                                 |    2 
 drivers/infiniband/ulp/ipoib/ipoib_ib.c                              |    4 
 drivers/input/mouse/sentelic.c                                       |    2 
 drivers/iommu/intel_irq_remapping.c                                  |    8 
 drivers/iommu/omap-iommu-debug.c                                     |    3 
 drivers/irqchip/irq-gic-v3-its.c                                     |    5 
 drivers/irqchip/irq-mtk-sysirq.c                                     |    8 
 drivers/leds/led-class.c                                             |    1 
 drivers/leds/leds-88pm860x.c                                         |   14 
 drivers/leds/leds-da903x.c                                           |   14 
 drivers/leds/leds-lm3533.c                                           |   12 
 drivers/leds/leds-lm355x.c                                           |    7 
 drivers/leds/leds-wm831x-status.c                                    |   14 
 drivers/md/bcache/bset.c                                             |    2 
 drivers/md/bcache/btree.c                                            |    2 
 drivers/md/bcache/journal.c                                          |    4 
 drivers/md/bcache/super.c                                            |   11 
 drivers/md/dm-cache-target.c                                         |  166 +++-------
 drivers/md/dm-rq.c                                                   |    3 
 drivers/md/md-cluster.c                                              |    1 
 drivers/md/raid5.c                                                   |    3 
 drivers/media/firewire/firedtv-fw.c                                  |    2 
 drivers/media/platform/exynos4-is/media-dev.c                        |    3 
 drivers/media/platform/omap3isp/isppreview.c                         |    4 
 drivers/mfd/arizona-core.c                                           |   18 +
 drivers/mfd/dln2.c                                                   |    4 
 drivers/misc/cxl/sysfs.c                                             |    2 
 drivers/mtd/mtdchar.c                                                |   56 ++-
 drivers/mtd/nand/qcom_nandc.c                                        |    7 
 drivers/net/dsa/mv88e6xxx/chip.c                                     |    1 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c            |    2 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c              |    2 
 drivers/net/ethernet/freescale/fman/fman.c                           |    3 
 drivers/net/ethernet/freescale/fman/fman_dtsec.c                     |    4 
 drivers/net/ethernet/freescale/fman/fman_mac.h                       |    2 
 drivers/net/ethernet/freescale/fman/fman_memac.c                     |    3 
 drivers/net/ethernet/freescale/fman/fman_port.c                      |    9 
 drivers/net/ethernet/freescale/fman/fman_tgec.c                      |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                            |    9 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                     |    2 
 drivers/net/ethernet/qualcomm/emac/emac.c                            |   17 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                  |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c                 |    3 
 drivers/net/ethernet/toshiba/spider_net.c                            |    4 
 drivers/net/hyperv/netvsc_drv.c                                      |    7 
 drivers/net/usb/hso.c                                                |    5 
 drivers/net/usb/lan78xx.c                                            |  117 +------
 drivers/net/vxlan.c                                                  |   10 
 drivers/net/wan/lapbether.c                                          |   10 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h        |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c          |    4 
 drivers/net/wireless/intel/iwlegacy/common.c                         |    4 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c                   |   22 -
 drivers/net/wireless/ti/wl1251/event.c                               |    2 
 drivers/parisc/sba_iommu.c                                           |    2 
 drivers/pci/access.c                                                 |    8 
 drivers/pci/host/vmd.c                                               |    3 
 drivers/pci/hotplug/acpiphp_glue.c                                   |   14 
 drivers/pci/pcie/aspm.c                                              |    1 
 drivers/pci/quirks.c                                                 |    2 
 drivers/pinctrl/pinctrl-single.c                                     |   11 
 drivers/platform/x86/intel-hid.c                                     |    2 
 drivers/platform/x86/intel-vbtn.c                                    |    2 
 drivers/power/supply/88pm860x_battery.c                              |    6 
 drivers/pwm/pwm-bcm-iproc.c                                          |    9 
 drivers/s390/net/qeth_l2_main.c                                      |    4 
 drivers/scsi/arm/cumana_2.c                                          |    2 
 drivers/scsi/arm/eesox.c                                             |    2 
 drivers/scsi/arm/powertec.c                                          |    2 
 drivers/scsi/mesh.c                                                  |    8 
 drivers/scsi/scsi_debug.c                                            |    6 
 drivers/spi/spi-lantiq-ssc.c                                         |   10 
 drivers/spi/spidev.c                                                 |   21 -
 drivers/staging/android/ashmem.c                                     |   12 
 drivers/staging/rtl8192u/r8192U_core.c                               |    2 
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c                   |    2 
 drivers/usb/dwc2/platform.c                                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_core.c                                |   13 
 drivers/usb/gadget/udc/bdc/bdc_ep.c                                  |   16 
 drivers/usb/gadget/udc/net2280.c                                     |    4 
 drivers/usb/host/xhci-pci.c                                          |   10 
 drivers/usb/misc/iowarrior.c                                         |   35 +-
 drivers/usb/serial/cp210x.c                                          |   19 +
 drivers/usb/serial/ftdi_sio.c                                        |   37 +-
 drivers/usb/serial/iuu_phoenix.c                                     |   14 
 drivers/usb/serial/qcserial.c                                        |    1 
 drivers/video/console/newport_con.c                                  |   12 
 drivers/video/console/vgacon.c                                       |    4 
 drivers/video/fbdev/neofb.c                                          |    1 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c                           |    2 
 drivers/video/fbdev/pxafb.c                                          |    4 
 drivers/video/fbdev/sm712fb.c                                        |    2 
 drivers/watchdog/f71808e_wdt.c                                       |   13 
 drivers/xen/balloon.c                                                |   12 
 fs/9p/v9fs.c                                                         |    5 
 fs/btrfs/disk-io.c                                                   |   13 
 fs/btrfs/extent_io.c                                                 |    2 
 fs/btrfs/free-space-cache.c                                          |    4 
 fs/btrfs/tree-log.c                                                  |    8 
 fs/cifs/smb2pdu.c                                                    |    2 
 fs/dlm/lockspace.c                                                   |    6 
 fs/ext2/ialloc.c                                                     |    3 
 fs/minix/inode.c                                                     |   36 ++
 fs/minix/itree_common.c                                              |    8 
 fs/nfs/nfs4proc.c                                                    |    2 
 fs/nfs/nfs4xdr.c                                                     |    6 
 fs/ocfs2/ocfs2.h                                                     |    4 
 fs/ocfs2/suballoc.c                                                  |    4 
 fs/ocfs2/super.c                                                     |    4 
 fs/ufs/super.c                                                       |    2 
 fs/xattr.c                                                           |   84 ++++-
 fs/xfs/xfs_reflink.c                                                 |   21 -
 include/linux/bitfield.h                                             |    2 
 include/linux/hyperv.h                                               |    2 
 include/linux/intel-iommu.h                                          |    4 
 include/linux/irq.h                                                  |   12 
 include/linux/tracepoint.h                                           |    2 
 include/linux/xattr.h                                                |    2 
 include/net/addrconf.h                                               |    1 
 include/net/inet_connection_sock.h                                   |    4 
 include/net/ip_vs.h                                                  |   10 
 include/net/sock.h                                                   |    4 
 kernel/cgroup/cgroup.c                                               |    2 
 kernel/irq/manage.c                                                  |   41 ++
 kernel/kprobes.c                                                     |    7 
 kernel/sched/topology.c                                              |    2 
 kernel/trace/ftrace.c                                                |   15 
 kernel/trace/trace_events.c                                          |    4 
 kernel/trace/trace_hwlat.c                                           |    5 
 lib/dynamic_debug.c                                                  |   23 -
 lib/test_kmod.c                                                      |    2 
 mm/khugepaged.c                                                      |   22 -
 mm/mmap.c                                                            |    1 
 net/9p/trans_fd.c                                                    |   24 -
 net/bluetooth/6lowpan.c                                              |    5 
 net/bluetooth/hci_event.c                                            |   11 
 net/compat.c                                                         |    1 
 net/core/sock.c                                                      |   21 +
 net/ipv4/fib_trie.c                                                  |    2 
 net/ipv4/gre_offload.c                                               |   13 
 net/ipv4/inet_connection_sock.c                                      |   93 +++--
 net/ipv4/inet_hashtables.c                                           |    1 
 net/ipv6/anycast.c                                                   |   17 -
 net/ipv6/ipv6_sockglue.c                                             |    1 
 net/mac80211/sta_info.c                                              |    2 
 net/netfilter/ipvs/ip_vs_core.c                                      |   12 
 net/nfc/rawsock.c                                                    |    7 
 net/openvswitch/conntrack.c                                          |   38 +-
 net/packet/af_packet.c                                               |    9 
 net/rxrpc/call_object.c                                              |   27 +
 net/rxrpc/conn_object.c                                              |    8 
 net/rxrpc/recvmsg.c                                                  |    2 
 net/rxrpc/sendmsg.c                                                  |    3 
 net/socket.c                                                         |    2 
 net/wireless/nl80211.c                                               |    6 
 security/smack/smackfs.c                                             |   19 -
 sound/core/seq/oss/seq_oss.c                                         |    8 
 sound/pci/echoaudio/echoaudio.c                                      |    2 
 sound/soc/intel/boards/bxt_rt298.c                                   |    2 
 sound/usb/card.h                                                     |    1 
 sound/usb/mixer_quirks.c                                             |    1 
 sound/usb/pcm.c                                                      |    6 
 sound/usb/quirks-table.h                                             |   64 +++
 sound/usb/quirks.c                                                   |    3 
 sound/usb/stream.c                                                   |    1 
 tools/build/Build.include                                            |    3 
 tools/build/Makefile.feature                                         |    2 
 tools/build/feature/Makefile                                         |    2 
 tools/lib/traceevent/event-parse.c                                   |    1 
 tools/perf/bench/mem-functions.c                                     |   21 -
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                  |   21 -
 tools/testing/selftests/net/msg_zerocopy.c                           |    5 
 tools/testing/selftests/powerpc/benchmarks/context_switch.c          |   21 -
 tools/testing/selftests/powerpc/utils.c                              |   37 +-
 241 files changed, 1596 insertions(+), 818 deletions(-)

Adam Ford (1):
      omapfb: dss: Fix max fclk divider for omap36xx

Aditya Pakki (2):
      drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync
      drm/nouveau: fix multiple instances of reference count leaks

Adrian Hunter (1):
      perf intel-pt: Fix FUP packet state

Ahmad Fatoum (3):
      watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options
      watchdog: f71808e_wdt: remove use of wrong watchdog_info option
      watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Alexandru Ardelean (1):
      iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Alim Akhtar (1):
      arm64: dts: exynos: Fix silent hang after boot on Espresso

Andrii Nakryiko (1):
      tools, build: Propagate build failures from tools/build/Makefile.build

Andy Shevchenko (1):
      mfd: dln2: Run event handler loop under spinlock

Anton Blanchard (1):
      pseries: Fix 64 bit logical memory block panic

Arnd Bergmann (1):
      leds: lm355x: avoid enum conversion warning

Bartosz Golaszewski (1):
      irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Ben Skeggs (2):
      drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason
      drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Bjorn Helgaas (1):
      PCI: Fix pci_cfg_wait queue locking problem

Bolarinwa Olayemi Saheed (1):
      iwlegacy: Check the return value of pcie_capability_read_*()

Brant Merryman (2):
      USB: serial: cp210x: re-enable auto-RTS on open
      USB: serial: cp210x: enable usb generic throttle/unthrottle

ChangSyun Peng (1):
      md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Charles Keepax (1):
      mfd: arizona: Ensure 32k clock is put on driver unbind and error

Chengming Zhou (1):
      ftrace: Setup correct FTRACE_FL_REGS flags for module

Chris Packham (1):
      net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Christian Eggers (2):
      spi: spidev: Align buffers for DMA
      dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Christoph Hellwig (1):
      net/9p: validate fds in p9_fd_open

Christophe JAILLET (5):
      video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call
      scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
      scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Chuhong Yuan (2):
      media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()
      media: exynos4-is: Add missed check for pinctrl_lookup_state()

Colin Ian King (6):
      drm/arm: fix unintentional integer overflow on left shift
      drm/radeon: fix array out-of-bounds read and write issues
      staging: rtl8192u: fix a dubious looking mask before a shift
      iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
      Input: sentelic - fix error return when fsp_reg_write fails
      fs/ufs: avoid potential u32 multiplication overflow

Coly Li (2):
      bcache: fix super block seq numbers comparision in register_cache_set()
      bcache: allocate meta data pages as compound pages

Cong Wang (1):
      ipv6: fix memory leaks on IPV6_ADDRFORM path

Dan Carpenter (7):
      media: firewire: Using uninitialized values in node_probe()
      mwifiex: Prevent memory corruption handling keys
      thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()
      Smack: fix another vsscanf out of bounds
      Smack: prevent underflow in smk_set_cipso()
      drm/vmwgfx: Use correct vmw_legacy_display_unit pointer
      drm/vmwgfx: Fix two list_for_each loop exit tests

Danesh Petigara (1):
      usb: bdc: Halt controller on suspend

Daniel Díaz (1):
      tools build feature: Quote CC and CXX for their arguments

Darrick J. Wong (1):
      xfs: fix reflink quota reservation accounting error

David Howells (1):
      rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Dejin Zheng (2):
      video: fbdev: sm712fb: fix an issue about iounmap for a wrong address
      console: newport_con: fix an issue about leak related system resources

Dexuan Cui (1):
      Drivers: hv: vmbus: Ignore CHANNELMSG_TL_CONNECT_RESULT(23)

Dilip Kota (1):
      spi: lantiq: fix: Rx overflow error in full duplex mode

Dinghao Liu (1):
      ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Dmitry Osipenko (1):
      gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Drew Fustini (1):
      pinctrl-single: fix pcs_parse_pinconf() return value

Emil Velikov (1):
      drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Eric Biggers (4):
      Smack: fix use-after-free in smk_write_relabel_self()
      fs/minix: check return value of sb_getblk()
      fs/minix: don't allow getting deleted inodes
      fs/minix: reject too-large maximum file size

Eric Dumazet (1):
      x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Erik Ekman (1):
      USB: serial: qcserial: add EM7305 QDL product ID

Erik Kaneda (1):
      ACPICA: Do not increment operation_region reference counts for field units

Evgeny Novikov (2):
      video: fbdev: neofb: fix memory leak in neo_scan_monitor()
      usb: gadget: net2280: fix memory leak on probe error handling paths

Filipe Manana (1):
      btrfs: fix memory leaks after failure to lookup checksums during inode logging

Finn Thain (3):
      m68k: mac: Don't send IOP message until channel is idle
      m68k: mac: Fix IOP status/control register writes
      scsi: mesh: Fix panic after host or bus reset

Florinel Iordache (5):
      fsl/fman: use 32-bit unsigned integer
      fsl/fman: fix dereference null return value
      fsl/fman: fix unreachable code
      fsl/fman: check dereferencing null pointer
      fsl/fman: fix eth hash table allocation

Forest Crossman (2):
      usb: xhci: define IDs for various ASMedia host controllers
      usb: xhci: Fix ASMedia ASM1142 DMA addressing

Francesco Ruggeri (1):
      igb: reinit_locked() should be called with rtnl_lock

Frank van der Linden (1):
      xattr: break delegations in {set,remove}xattr

Geert Uytterhoeven (1):
      sh: landisk: Add missing initialization of sh_io_port_base

Grant Likely (1):
      HID: input: Fix devices that return multiple bytes in battery report

Greg Kroah-Hartman (3):
      USB: iowarrior: fix up report size handling for some devices
      mtd: properly check all write ioctls for permissions
      Linux 4.14.194

Hangbin Liu (1):
      Revert "vxlan: fix tos value before xmit"

Hanjun Guo (1):
      PCI: Release IVRS table in AMD ACS quirk

Harish (1):
      selftests/powerpc: Fix CPU affinity for child process

Hector Martin (3):
      ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
      ALSA: usb-audio: add quirk for Pioneer DDJ-RB
      ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109

Heiko Stuebner (2):
      arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio
      arm64: dts: rockchip: fix rk3399-puma gmac reset gpio

Huacai Chen (1):
      MIPS: CPU#0 is not hotpluggable

Hugh Dickins (1):
      khugepaged: retract_page_tables() remember to test exit

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      vxlan: Ensure FDB dump is performed under RCU

Jakub Kicinski (1):
      bitfield.h: don't compile-time validate _val in FIELD_FIT

Jann Horn (1):
      binder: Prevent context manager from incrementing ref 0

Jeffrey Mitchell (1):
      nfs: Fix getxattr kernel panic and memory overflow

Jian Cai (1):
      crypto: aesni - add compatibility with IAS

Jim Cromie (1):
      dyndbg: fix a BUG_ON in ddebug_describe_flags

Johan Hovold (8):
      leds: wm831x-status: fix use-after-free on unbind
      leds: da903x: fix use-after-free on unbind
      leds: lm3533: fix use-after-free on unbind
      leds: 88pm860x: fix use-after-free on unbind
      net: lan78xx: replace bogus endpoint lookup
      USB: serial: iuu_phoenix: fix led-activity helpers
      USB: serial: ftdi_sio: make process-packet buffer unsigned
      USB: serial: ftdi_sio: clean up receive processing

Johannes Berg (1):
      mac80211: fix misplaced while instead of if

John Allen (1):
      crypto: ccp - Fix use of merged scatterlists

John David Anglin (1):
      parisc: Implement __smp_store_release and __smp_load_acquire barriers

John Garry (1):
      scsi: scsi_debug: Add check for sdebug_max_queue during module init

John Ogness (1):
      af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jon Derrick (1):
      irqdomain/treewide: Free firmware node after domain removal

Jonathan McDowell (2):
      net: ethernet: stmmac: Disable hardware multicast filter
      net: stmmac: dwmac1000: provide multicast filter fallback

Josef Bacik (1):
      btrfs: only search for left_info if there is no right_info in try_merge_free_space

Julian Anastasov (1):
      ipvs: allow connection reuse for unconfirmed conntrack

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Julian Wiedmann (1):
      s390/qeth: don't process empty bridge port events

Junxiao Bi (1):
      ocfs2: change slot number type s16 to u16

Kai-Heng Feng (1):
      leds: core: Flush scheduled work for system suspend

Kamal Heib (1):
      RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Kees Cook (1):
      net/compat: Add missing sock updates for SCM_RIGHTS

Kevin Hao (1):
      tracing/hwlat: Honor the tracing_cpumask

Landen Chao (1):
      net: ethernet: mtk_eth_soc: fix MTU warnings

Laurent Pinchart (1):
      drm: panel: simple: Fix bpc for LG LB070WV8 panel

Lihong Kou (1):
      Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Liu Yi L (1):
      iommu/vt-d: Enforce PASID devTLB field mask

Liu Ying (1):
      drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Lorenzo Bianconi (1):
      net: gre: recompute gre csum for sctp over gre tunnels

Lu Wei (2):
      platform/x86: intel-hid: Fix return value check in check_acpi_dev()
      platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()

Marco Felsch (1):
      drm/imx: tve: fix regulator_disable error path

Marek Szyprowski (1):
      usb: dwc2: Fix error path in gadget registration

Max Filippov (1):
      xtensa: fix xtensa_pmu_setup prototype

Miaohe Lin (1):
      net: Set fput_needed iff FDPUT_FPUT is set

Michael Ellerman (1):
      powerpc: Fix circular dependency between percpu.h and mmu.h

Michael Tretter (1):
      drm/debugfs: fix plain echo to connector "force" attribute

Mike Snitzer (3):
      dm cache: pass cache structure to mode functions
      dm cache: submit writethrough writes in parallel to origin and cache
      dm cache: remove all obsolete writethrough-specific code

Mikulas Patocka (2):
      crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
      ext2: fix missing percpu_counter_inc

Milton Miller (1):
      powerpc/vdso: Fix vdso cpu truncation

Ming Lei (1):
      dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Mirko Dietrich (1):
      ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Muchun Song (1):
      kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Nathan Huckleberry (1):
      ARM: 8992/1: Fix unwind_frame for clang-built kernels

Nick Desaulniers (1):
      tracepoint: Mark __tracepoint_string's __used

Nicolas Boichat (1):
      Bluetooth: hci_serdev: Only unregister device if it was registered

Paul E. McKenney (2):
      fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls
      mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Peilin Ye (4):
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()
      openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Peng Liu (1):
      sched: correct SD_flags returned by tl->sd_flags()

Philippe Duplessis-Guindon (1):
      tools lib traceevent: Fix memory leak in process_dynamic_array_len

Pierre-Louis Bossart (1):
      ASoC: Intel: bxt_rt298: add missing .owner field

Prasanna Kerekoppa (1):
      brcmfmac: To fix Bss Info flag definition Bug

Qingyu Li (1):
      net/nfc/rawsock.c: add CAP_NET_RAW check.

Qiushi Wu (2):
      EDAC: Fix reference count leaks
      agp/intel: Fix a memory leak on module initialisation failure

Qu Wenruo (1):
      btrfs: don't allocate anonymous block device for user invisible roots

Rafael J. Wysocki (1):
      PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Rayagonda Kokatanur (1):
      pwm: bcm-iproc: handle clk_get_rate() return

Ricardo Cañuelo (1):
      arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Roger Pau Monne (2):
      xen/balloon: fix accounting in alloc_xenballooned_pages error path
      xen/balloon: make the balloon wait interruptible

Roi Dayan (1):
      net/mlx5e: Don't support phys switch id if not in switchdev mode

Rustam Kovhaev (1):
      usb: hso: check for return value in hso_serial_common_create()

Sai Prakash Ranjan (1):
      coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Sandipan Das (1):
      selftests/powerpc: Fix online CPU selection

Sasi Kumar (1):
      bdc: Fix bug causing crash after multiple disconnects

Sivaprakash Murugesan (1):
      mtd: rawnand: qcom: avoid write to unavailable register

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

Stephen Hemminger (1):
      hv_netvsc: do not use VF device if link is down

Steve French (1):
      smb3: warn on confusing error scenario with sec=krb5

Steve Longerbeam (1):
      gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Steven Rostedt (VMware) (1):
      tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Suren Baghdasaryan (1):
      staging: android: ashmem: Fix lockdep warning for write operation

Sven Schnelle (1):
      parisc: mask out enable and reserved bits from sba imask

Takashi Iwai (1):
      ALSA: seq: oss: Serialize ioctls

Thomas Gleixner (2):
      genirq/affinity: Handle affinity setting on inactive interrupts correctly
      genirq/affinity: Make affinity setting if activated opt-in

Thomas Hebb (1):
      tools build feature: Use CC and CXX from parent

Tianjia Zhang (2):
      net: ethernet: aquantia: Fix wrong return value
      liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tiezhu Yang (1):
      test_kmod: avoid potential double free in trigger_config_run_type()

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tom Rix (3):
      drm/bridge: sil_sii8620: initialize return of sii8620_readb
      power: supply: check if calc_soc succeeded in pm860x_init_battery
      crypto: qat - fix double free in qat_uclo_create_batch_init_list

Tomasz Duszynski (1):
      iio: improve IIO_CONCENTRATION channel type description

Tomi Valkeinen (1):
      drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Vincent Whitchurch (1):
      perf bench mem: Always memset source before memcpy

Wang Hai (4):
      cxl: Fix kobject memleak
      wl1251: fix always return 0 error
      dlm: Fix kobject memleak
      net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Willem de Bruijn (1):
      selftests/net: relax cpu affinity requirement in msg_zerocopy test

Wolfram Sang (4):
      i2c: slave: improve sanity check when registering
      i2c: slave: add sanity check when unregistering
      i2c: rcar: slave: only send STOP event when we have been addressed
      i2c: rcar: avoid race when unregistering slave

Wright Feng (1):
      brcmfmac: set state of hanger slot to FREE when flushing PSQ

Xie He (1):
      drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

Xin Xiong (1):
      atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Xiongfeng Wang (1):
      PCI/ASPM: Add missing newline in sysfs 'policy'

Xu Wang (1):
      clk: clk-atlas6: fix return value check in atlas6_clk_init()

Yang Yingliang (1):
      cgroup: add missing skcd->no_refcnt check in cgroup_sk_clone()

Yu Kuai (2):
      ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()
      MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

Yunhai Zhang (1):
      vgacon: Fix for missing check in scrollback handling

Zhao Heming (1):
      md-cluster: fix wild pointer of unlock_all_bitmaps()

Zheng Bin (1):
      9p: Fix memory leak in v9fs_mount

Zhenzhong Duan (1):
      x86/mce/inject: Fix a wrong assignment of i_mce.status

yu kuai (1):
      ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

