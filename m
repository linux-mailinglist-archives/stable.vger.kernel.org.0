Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C87F6B5CA8
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCKORJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCKORI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:17:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55103E9F32;
        Sat, 11 Mar 2023 06:17:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D443160C37;
        Sat, 11 Mar 2023 14:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63ADC433D2;
        Sat, 11 Mar 2023 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678544224;
        bh=iKRHT5d5BsE9fJuLr/zL2n2xSD3Jp5TW0GIXvadXWfs=;
        h=From:To:Cc:Subject:Date:From;
        b=11RkkWKDZXDkx6L6eilcBbaGyu2MFKUyotUL9/wBjHzfd05wm9if5ZAgSBOI20LSG
         OW7EEjzp/Mn+fs8HibxgFSagma10alB7/gcE/m6vq409Y6PugE9BFI9PgETQXTkoii
         94hyRi3A3vWiDZKKI2g3JNloi4OoVYV1Wpr7V+s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.5
Date:   Sat, 11 Mar 2023 15:16:59 +0100
Message-Id: <16785442206328@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.5 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/configfs-usb-gadget-uvc                |    2 
 Documentation/devicetree/bindings/usb/genesys,gl850g.yaml        |    1 
 Makefile                                                         |    2 
 arch/arm/boot/dts/aspeed-bmc-ibm-bonnell.dts                     |    2 
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts                     |    2 
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts                     |    2 
 arch/arm/boot/dts/spear320-hmi.dts                               |    2 
 arch/arm64/include/asm/efi.h                                     |    6 
 arch/arm64/kernel/efi.c                                          |    2 
 arch/mips/configs/mtx1_defconfig                                 |    1 
 arch/powerpc/configs/ppc6xx_defconfig                            |    1 
 arch/um/drivers/vector_kern.c                                    |    1 
 arch/um/drivers/virt-pci.c                                       |   26 
 arch/um/drivers/virtio_uml.c                                     |   18 
 arch/x86/include/asm/resctrl.h                                   |   12 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                           |    4 
 arch/x86/kernel/process_32.c                                     |    2 
 arch/x86/kernel/process_64.c                                     |    2 
 arch/x86/um/vdso/um_vdso.c                                       |   12 
 drivers/acpi/device_pm.c                                         |   19 
 drivers/auxdisplay/hd44780.c                                     |    2 
 drivers/base/cacheinfo.c                                         |   27 
 drivers/base/component.c                                         |    2 
 drivers/base/dd.c                                                |    2 
 drivers/block/loop.c                                             |    8 
 drivers/bus/mhi/ep/main.c                                        |    2 
 drivers/cpufreq/apple-soc-cpufreq.c                              |    4 
 drivers/firmware/efi/sysfb_efi.c                                 |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c        |    2 
 drivers/gpu/drm/display/drm_dp_mst_topology.c                    |   71 
 drivers/gpu/drm/i915/Kconfig                                     |    6 
 drivers/gpu/drm/i915/display/intel_display.c                     |    4 
 drivers/gpu/drm/i915/display/intel_dp_mst.c                      |   75 
 drivers/gpu/drm/i915/display/intel_dp_mst.h                      |    4 
 drivers/gpu/drm/i915/display/intel_fbdev.c                       |    8 
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c                           |    5 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                          |    2 
 drivers/iio/accel/mma9551_core.c                                 |   10 
 drivers/infiniband/core/cma.c                                    |   17 
 drivers/infiniband/hw/hfi1/chip.c                                |   59 
 drivers/iommu/iommu.c                                            |   70 
 drivers/media/usb/uvc/uvc_ctrl.c                                 |    5 
 drivers/media/usb/uvc/uvc_driver.c                               |   90 
 drivers/media/usb/uvc/uvc_entity.c                               |    2 
 drivers/media/usb/uvc/uvc_status.c                               |   37 
 drivers/media/usb/uvc/uvc_v4l2.c                                 |    2 
 drivers/media/usb/uvc/uvc_video.c                                |   15 
 drivers/media/usb/uvc/uvcvideo.h                                 |    4 
 drivers/memory/renesas-rpc-if.c                                  |  120 
 drivers/mfd/arizona-core.c                                       |    2 
 drivers/misc/mei/bus-fixup.c                                     |    8 
 drivers/misc/vmw_balloon.c                                       |    2 
 drivers/mtd/ubi/build.c                                          |    7 
 drivers/mtd/ubi/fastmap-wl.c                                     |   12 
 drivers/mtd/ubi/vmt.c                                            |   18 
 drivers/mtd/ubi/wl.c                                             |   25 
 drivers/net/dsa/ocelot/felix_vsc9959.c                           |    2 
 drivers/net/dsa/ocelot/seville_vsc9953.c                         |    4 
 drivers/net/ethernet/Kconfig                                     |   10 
 drivers/net/ethernet/Makefile                                    |    1 
 drivers/net/ethernet/fealnx.c                                    | 1953 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c          |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c           |   76 
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c                   |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c                 |   25 
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c               |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h               |    1 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c             |    1 
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c                  |    4 
 drivers/net/ethernet/sun/sunhme.c                                |    6 
 drivers/net/mdio/mdio-mscc-miim.c                                |    9 
 drivers/nfc/st-nci/se.c                                          |    6 
 drivers/nfc/st21nfca/se.c                                        |    6 
 drivers/nvme/host/core.c                                         |   35 
 drivers/nvme/host/fabrics.h                                      |    3 
 drivers/nvme/host/tcp.c                                          |    6 
 drivers/pci/controller/pci-loongson.c                            |   71 
 drivers/pci/hotplug/pciehp_hpc.c                                 |    2 
 drivers/pci/pci-acpi.c                                           |   45 
 drivers/pci/pci.c                                                |   10 
 drivers/pci/pcie/portdrv.c                                       |   16 
 drivers/pci/quirks.c                                             |   22 
 drivers/pci/setup-bus.c                                          |  236 -
 drivers/phy/rockchip/phy-rockchip-typec.c                        |    3 
 drivers/ptp/ptp_private.h                                        |    2 
 drivers/ptp/ptp_vclock.c                                         |   44 
 drivers/pwm/pwm-sifive.c                                         |    8 
 drivers/pwm/pwm-stm32-lp.c                                       |    2 
 drivers/rtc/interface.c                                          |    2 
 drivers/rtc/rtc-sun6i.c                                          |   16 
 drivers/scsi/ipr.c                                               |   41 
 drivers/scsi/mpi3mr/mpi3mr.h                                     |   10 
 drivers/scsi/mpi3mr/mpi3mr_fw.c                                  |   75 
 drivers/scsi/mpi3mr/mpi3mr_transport.c                           |    2 
 drivers/soc/mediatek/mt8186-pm-domains.h                         |    4 
 drivers/soc/mediatek/mtk-svs.c                                   |   48 
 drivers/soc/qcom/qcom_stats.c                                    |   10 
 drivers/soc/qcom/socinfo.c                                       |    6 
 drivers/soc/xilinx/xlnx_event_manager.c                          |    4 
 drivers/soundwire/bus_type.c                                     |    9 
 drivers/soundwire/cadence_master.c                               |   43 
 drivers/soundwire/cadence_master.h                               |   13 
 drivers/spi/spi-tegra210-quad.c                                  |   14 
 drivers/staging/emxx_udc/emxx_udc.c                              |    7 
 drivers/staging/pi433/pi433_if.c                                 |   11 
 drivers/thermal/intel/Kconfig                                    |    3 
 drivers/thermal/intel/intel_quark_dts_thermal.c                  |   12 
 drivers/tty/serial/fsl_lpuart.c                                  |   24 
 drivers/tty/serial/pch_uart.c                                    |    2 
 drivers/tty/serial/sc16is7xx.c                                   |   51 
 drivers/tty/tty_io.c                                             |    8 
 drivers/tty/vt/vc_screen.c                                       |    4 
 drivers/usb/chipidea/debug.c                                     |    2 
 drivers/usb/common/ulpi.c                                        |   14 
 drivers/usb/core/usb.c                                           |    2 
 drivers/usb/dwc3/core.h                                          |    2 
 drivers/usb/dwc3/debug.h                                         |    3 
 drivers/usb/dwc3/debugfs.c                                       |   19 
 drivers/usb/dwc3/gadget.c                                        |    4 
 drivers/usb/fotg210/fotg210-core.c                               |    2 
 drivers/usb/fotg210/fotg210-hcd.c                                |    2 
 drivers/usb/gadget/function/uvc_configfs.c                       |   59 
 drivers/usb/gadget/udc/bcm63xx_udc.c                             |    2 
 drivers/usb/gadget/udc/gr_udc.c                                  |    2 
 drivers/usb/gadget/udc/lpc32xx_udc.c                             |    2 
 drivers/usb/gadget/udc/pxa25x_udc.c                              |    2 
 drivers/usb/gadget/udc/pxa27x_udc.c                              |    2 
 drivers/usb/host/isp116x-hcd.c                                   |    2 
 drivers/usb/host/isp1362-hcd.c                                   |    2 
 drivers/usb/host/sl811-hcd.c                                     |    2 
 drivers/usb/host/uhci-hcd.c                                      |    6 
 drivers/usb/host/xhci-mvebu.c                                    |    2 
 drivers/usb/storage/ene_ub6250.c                                 |    2 
 drivers/vdpa/ifcvf/ifcvf_base.c                                  |   30 
 drivers/vdpa/ifcvf/ifcvf_base.h                                  |    6 
 drivers/vdpa/ifcvf/ifcvf_main.c                                  |  139 
 drivers/watchdog/at91sam9_wdt.c                                  |    7 
 drivers/watchdog/pcwd_usb.c                                      |    6 
 drivers/watchdog/rzg2l_wdt.c                                     |   45 
 drivers/watchdog/sbsa_gwdt.c                                     |    1 
 drivers/watchdog/watchdog_dev.c                                  |    2 
 fs/ext4/ext4.h                                                   |    1 
 fs/ext4/fast_commit.c                                            |   44 
 fs/ext4/super.c                                                  |   30 
 fs/f2fs/data.c                                                   |   49 
 fs/f2fs/file.c                                                   |   60 
 fs/f2fs/inode.c                                                  |   23 
 fs/f2fs/iostat.c                                                 |    6 
 fs/f2fs/segment.c                                                |   13 
 fs/f2fs/segment.h                                                |   23 
 fs/f2fs/super.c                                                  |   17 
 fs/f2fs/sysfs.c                                                  |    9 
 fs/f2fs/verity.c                                                 |    2 
 fs/jfs/jfs_dmap.c                                                |    3 
 fs/ubifs/budget.c                                                |    9 
 fs/ubifs/dir.c                                                   |    9 
 fs/ubifs/file.c                                                  |   31 
 fs/ubifs/super.c                                                 |   17 
 fs/ubifs/sysfs.c                                                 |    2 
 fs/ubifs/tnc.c                                                   |   24 
 fs/ubifs/ubifs.h                                                 |    5 
 include/acpi/acpi_bus.h                                          |    1 
 include/drm/display/drm_dp_mst_helper.h                          |    6 
 include/linux/bootconfig.h                                       |    2 
 include/linux/iommu.h                                            |    2 
 include/linux/mdio/mdio-mscc-miim.h                              |    2 
 include/linux/netfilter.h                                        |    5 
 include/linux/pci.h                                              |    1 
 include/linux/pci_ids.h                                          |    2 
 include/media/v4l2-uvc.h                                         |    8 
 include/memory/renesas-rpc-if.h                                  |   16 
 include/net/netns/conntrack.h                                    |    1 
 include/net/sctp/structs.h                                       |    1 
 include/net/tc_act/tc_pedit.h                                    |   81 
 include/net/tc_wrapper.h                                         |    5 
 include/trace/events/f2fs.h                                      |   37 
 include/uapi/linux/usb/video.h                                   |   30 
 include/uapi/linux/uvcvideo.h                                    |    2 
 io_uring/kbuf.c                                                  |    2 
 kernel/dma/swiotlb.c                                             |    3 
 kernel/fail_function.c                                           |    5 
 kernel/irq/ipi.c                                                 |    8 
 kernel/printk/index.c                                            |    2 
 kernel/trace/ring_buffer.c                                       |    7 
 net/9p/trans_rdma.c                                              |   15 
 net/9p/trans_xen.c                                               |   48 
 net/bridge/netfilter/ebtables.c                                  |    2 
 net/core/dev.c                                                   |    4 
 net/ipv4/netfilter/arp_tables.c                                  |    4 
 net/ipv4/netfilter/ip_tables.c                                   |    7 
 net/ipv4/tcp_minisocks.c                                         |    7 
 net/ipv6/netfilter/ip6_tables.c                                  |    7 
 net/ipv6/netfilter/ip6t_rpfilter.c                               |    4 
 net/ipv6/route.c                                                 |   11 
 net/netfilter/core.c                                             |    3 
 net/netfilter/nf_conntrack_bpf.c                                 |    1 
 net/netfilter/nf_conntrack_core.c                                |   25 
 net/netfilter/nf_conntrack_ecache.c                              |    2 
 net/netfilter/nf_conntrack_netlink.c                             |    8 
 net/netfilter/nf_tables_api.c                                    |    2 
 net/netfilter/nfnetlink.c                                        |    9 
 net/netfilter/xt_length.c                                        |    3 
 net/nfc/netlink.c                                                |    4 
 net/sched/Kconfig                                                |   11 
 net/sched/Makefile                                               |    1 
 net/sched/act_mpls.c                                             |   66 
 net/sched/act_pedit.c                                            |  178 
 net/sched/act_sample.c                                           |   11 
 net/sched/cls_tcindex.c                                          |  742 ---
 net/sctp/stream_sched_prio.c                                     |   52 
 net/tls/tls_sw.c                                                 |   26 
 sound/soc/apple/mca.c                                            |   31 
 sound/soc/codecs/Kconfig                                         |    1 
 sound/soc/codecs/adau7118.c                                      |   19 
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c                      |    3 
 tools/iio/iio_utils.c                                            |   23 
 tools/objtool/check.c                                            |    2 
 tools/testing/selftests/netfilter/rpath.sh                       |   32 
 tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json |  227 -
 221 files changed, 4261 insertions(+), 2205 deletions(-)

Akinobu Mita (1):
      nvme-tcp: don't access released socket during error recovery

Alexander Potapenko (1):
      fs: f2fs: initialize fsdata in pagecache_write()

Alexander Usyskin (1):
      mei: bus-fixup:upon error print return values of send and receive

Alexandre Belloni (1):
      rtc: allow rtc_read_alarm without read_alarm callback

Ammar Faizi (1):
      x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Anand Moon (1):
      dt-bindings: usb: Add device id for Genesys Logic hub controller

Arnd Bergmann (2):
      scsi: ipr: Work around fortify-string warning
      ASoC: zl38060 add gpiolib dependency

Benjamin Berg (4):
      um: virtio_uml: free command if adding to virtqueue failed
      um: virtio_uml: mark device as unregistered when breaking it
      um: virtio_uml: move device breaking into workqueue
      um: virt-pci: properly remove PCI device from bus

Chao Yu (8):
      f2fs: fix to avoid potential deadlock
      f2fs: introduce trace_f2fs_replace_atomic_write_block
      f2fs: clear atomic_write_task in f2fs_abort_atomic_write()
      f2fs: fix to do sanity check on extent cache correctly
      f2fs: fix to abort atomic write only during do_exist()
      f2fs: fix to handle F2FS_IOC_START_ATOMIC_REPLACE in f2fs_compat_ioctl()
      f2fs: fix to update age extent correctly during truncation
      f2fs: fix to update age extent in f2fs_do_zero_range()

Chen Jun (1):
      watchdog: Fix kmemleak in watchdog_cdev_register

Christoph Hellwig (2):
      f2fs: don't rely on F2FS_MAP_* in f2fs_iomap_begin
      nvme: bring back auto-removal of deleted namespaces during sequential scan

Daeho Jeong (1):
      f2fs: synchronize atomic write aborts

Dan Carpenter (2):
      thermal: intel: quark_dts: fix error pointer dereference
      cpufreq: apple-soc: Fix an IS_ERR() vs NULL check

Daniel Scally (2):
      usb: uvc: Enumerate valid values for color matching
      usb: gadget: uvc: Make bSourceID read/write

Daniel Wagner (1):
      nvme-fabrics: show well known discovery name

Darrell Kavanagh (1):
      firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Dean Luick (1):
      IB/hfi1: Update RMT size calculation

Deepak R Varma (1):
      octeontx2-pf: Use correct struct reference in test condition

Eddie James (1):
      ARM: dts: aspeed: p10bmc: Update battery node name

Emil Renner Berthing (1):
      pwm: sifive: Always let the first pwm_apply_state succeed

Eric Biggers (1):
      ext4: use ext4_fc_tl_mem in fast-commit replay path

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fabrice Gasnier (1):
      pwm: stm32-lp: fix the check on arr and cmp registers update

Fabrizio Castro (1):
      watchdog: rzg2l_wdt: Handle TYPE-B reset for RZ/V2M

Fedor Pchelkin (1):
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Westphal (3):
      netfilter: conntrack: fix rmmod double-free race
      netfilter: ebtables: fix table blob use-after-free
      netfilter: ctnetlink: make event listener tracking global

Gaosheng Cui (1):
      driver: soc: xilinx: fix memory leak in xlnx_add_cb_for_notify_event()

Geert Uytterhoeven (2):
      memory: renesas-rpc-if: Split-off private data from struct rpcif
      memory: renesas-rpc-if: Move resource acquisition to .probe()

Geetha sowjanya (1):
      octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

George Kennedy (2):
      ubi: ensure that VID header offset + VID header size <= alloc, size
      vc_screen: modify vcs_size() handling in vcs_read()

Greg Kroah-Hartman (22):
      kernel/printk/index.c: fix memory leak with using debugfs_lookup()
      USB: fix memory leak with using debugfs_lookup()
      staging: pi433: fix memory leak with using debugfs_lookup()
      USB: dwc3: fix memory leak with using debugfs_lookup()
      USB: chipidea: fix memory leak with using debugfs_lookup()
      USB: ULPI: fix memory leak with using debugfs_lookup()
      USB: uhci: fix memory leak with using debugfs_lookup()
      USB: sl811: fix memory leak with using debugfs_lookup()
      USB: fotg210: fix memory leak with using debugfs_lookup()
      USB: isp116x: fix memory leak with using debugfs_lookup()
      USB: isp1362: fix memory leak with using debugfs_lookup()
      USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()
      USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()
      USB: gadget: lpc32xx_udc: fix memory leak with using debugfs_lookup()
      USB: gadget: pxa25x_udc: fix memory leak with using debugfs_lookup()
      USB: gadget: pxa27x_udc: fix memory leak with using debugfs_lookup()
      tty: pcn_uart: fix memory leak with using debugfs_lookup()
      misc: vmw_balloon: fix memory leak with using debugfs_lookup()
      drivers: base: component: fix memory leak with using debugfs_lookup()
      drivers: base: dd: fix memory leak with using debugfs_lookup()
      kernel/fail_function: fix memory leak with using debugfs_lookup()
      Linux 6.2.5

Guenter Roeck (1):
      media: uvcvideo: Handle errors from calls to usb_string

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Harshit Mogalapalli (2):
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Huacai Chen (3):
      PCI/portdrv: Prevent LS7A Bus Master clearing on shutdown
      PCI: loongson: Prevent LS7A MRRS increases
      PCI: loongson: Add more devices that need MRRS quirk

Imre Deak (8):
      drm/display/dp_mst: Add drm_atomic_get_old_mst_topology_state()
      drm/display/dp_mst: Fix down/up message handling after sink disconnect
      drm/display/dp_mst: Fix down message handling after a packet reception error
      drm/display/dp_mst: Fix payload addition on a disconnected sink
      drm/i915/dp_mst: Add the MST topology state for modesetted CRTCs
      drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()
      drm/i915/dp_mst: Fix payload removal during output disabling
      drm/i915: Fix system suspend without fbdev being initialized

Isaac True (1):
      serial: sc16is7xx: setup GPIO controller later in probe

Jakub Kicinski (2):
      eth: fealnx: bring back this old driver
      net: tls: avoid hanging tasks on the tx_lock

Jamal Hadi Salim (1):
      net/sched: Retire tcindex classifier

Jason Gunthorpe (1):
      iommu: Remove deferred attach check from __iommu_detach_device()

Jia-Ju Bai (1):
      tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Jianglei Nie (1):
      auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()

Jiapeng Chong (1):
      phy: rockchip-typec: Fix unsigned comparison with less than zero

Juergen Gross (2):
      9p/xen: fix version parsing
      9p/xen: fix connection sequence

Kees Cook (4):
      media: uvcvideo: Silence memcpy() run-time false positive warnings
      usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
      USB: ene_usb6250: Allocate enough memory for full object
      RDMA/cma: Distinguish between sockaddr_in and sockaddr_in6 by size

Krishna Yarlagadda (2):
      spi: tegra210-quad: Fix validate combined sequence
      spi: tegra210-quad: Fix iterator outside loop

Krzysztof Kozlowski (1):
      ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Lad Prabhakar (1):
      watchdog: rzg2l_wdt: Issue a reset before we put the PM clocks

Laurent Pinchart (1):
      media: uvcvideo: Remove format descriptions

Li Hua (2):
      ubifs: Fix build errors as symbol undefined
      watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Li Zetao (3):
      ubi: Fix use-after-free when volume resizing failed
      ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()
      ubifs: Fix memory leak in alloc_wbufs()

Liang He (1):
      mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak

Linus Torvalds (1):
      x86/resctl: fix scheduler confusion with 'current'

Linus Walleij (1):
      usb: fotg210: List different variants

Liu Shixin (1):
      ubifs: Fix memory leak in ubifs_sysfs_init()

Liu Shixin via Jfs-discussion (1):
      fs/jfs: fix shift exponent db_agl2size negative

Lu Wei (1):
      ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

Maher Sanalla (1):
      net/mlx5: ECPF, wait for VF pages only after disabling host PFs

Manivannan Sadhasivam (2):
      bus: mhi: ep: Fix the debug message for MHI_PKT_TYPE_RESET_CHAN_CMD cmd
      PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Marek Vasut (1):
      media: uvcvideo: Add GUID for BGRA/X 8:8:8:8

Martin Povišer (3):
      ASoC: apple: mca: Fix final status read on SERDES reset
      ASoC: apple: mca: Fix SERDES reset sequence
      ASoC: apple: mca: Improve handling of unavailable DMA channels

Matt Roper (1):
      drm/i915/xelpmp: Consider GSI offset when doing MCR lookups

Mengyuan Lou (1):
      PCI: Add ACS quirk for Wangxun NICs

Miaoqian Lin (1):
      objtool: Fix memory leak in create_static_call_sections()

Mika Westerberg (3):
      PCI: Align extra resources for hotplug bridges properly
      PCI: Take other bus devices into account when distributing resources
      PCI: Distribute available resources for root buses, too

Nuno Sá (1):
      ASoC: adau7118: don't disable regulators on device unbind

Pablo Neira Ayuso (1):
      netfilter: nf_tables: allow to fetch set elements when table has an owner

Pavel Tikhomirov (1):
      netfilter: x_tables: fix percpu counter block leak on error path when creating new netns

Pedro Tammela (4):
      net/sched: transition act_pedit to rcu and percpu stats
      net/sched: act_pedit: fix action bind logic
      net/sched: act_mpls: fix action bind logic
      net/sched: act_sample: fix action bind logic

Phil Sutter (1):
      netfilter: ip6t_rpfilter: Fix regression with VRF interfaces

Pierre Gondois (1):
      arm64: efi: Make efi_rt_lock a raw_spinlock

Rafael J. Wysocki (1):
      PCI/ACPI: Account for _S0W of the target bridge in acpi_pci_bridge_d3()

Randy Dunlap (3):
      swiotlb: mark swiotlb_memblock_alloc() as __init
      drm/i915: move a Kconfig symbol to unbreak the menu presentation
      thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Ricardo Ribalda (4):
      soc: mediatek: mtk-svs: Enable the IRQ later
      media: uvcvideo: Handle cameras with invalid descriptors
      media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910
      media: uvcvideo: Fix race condition with usb_kill_urb

Richard Fitzgerald (3):
      soundwire: bus_type: Avoid lockdep assert in sdw_drv_probe()
      soundwire: cadence: Remove wasted space in response_buf
      soundwire: cadence: Drain the RX FIFO after an IO timeout

Roger Lu (2):
      soc: mediatek: mtk-svs: restore default voltages when svs_init02() fail
      soc: mediatek: mtk-svs: reset svs when svs_resume() fail

Roi Dayan (1):
      net/mlx5e: Verify flow_source cap before using it

Samuel Holland (1):
      rtc: sun6i: Always export the internal oscillator

Sean Anderson (1):
      net: sunhme: Fix region request

Sergey Shtylyov (1):
      genirq/ipi: Fix NULL pointer deref in irq_data_get_affinity_mask()

Shang XiaoJing (1):
      soc: mediatek: mtk-svs: Use pm_runtime_resume_and_get() in svs_init01()

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable the CTS when send break signal

Shin'ichiro Kawasaki (1):
      scsi: mpi3mr: Use number of bits to manage bitmap sizes

Souradeep Chowdhury (1):
      bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support

Stephan Gerhold (1):
      soc: qcom: socinfo: Fix soc_id order

Stephen Boyd (1):
      soc: qcom: stats: Populate all subsystem debugfs files

Sven Schnelle (1):
      tty: fix out-of-bounds access in tty_driver_lookup_tty()

Tinghan Shen (1):
      soc: mediatek: mtk-pm-domains: Allow mt8186 ADSP default power on

Tomas Henzl (1):
      scsi: mpi3mr: Fix an issue found by KASAN

Trevor Wu (1):
      ASoC: mediatek: mt8195: add missing initialization

Vadim Fedorenko (2):
      mlx5: fix skb leak while fifo resync and push
      mlx5: fix possible ptp queue fifo use-after-free

Vladimir Oltean (2):
      net: dsa: seville: ignore mscc-miim read errors from Lynx PCS
      net: dsa: felix: fix internal MDIO controller resource length

Wang Jianjian (1):
      ext4: don't show commit interval if it is zero

Wojciech Lukowicz (1):
      io_uring: fix size calculation when registering buf ring

Xiang Yang (1):
      um: vector: Fix memory leak in vector_config

Xin Long (2):
      netfilter: xt_length: use skb len to match in length_mt6
      sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Yang Yingliang (2):
      ubi: Fix possible null-ptr-deref in ubi_free_volume()
      usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails

Yangtao Li (4):
      f2fs: allow set compression option of files without blocks
      f2fs: fix to avoid potential memory corruption in __update_iostat_latency()
      f2fs: introduce IS_F2FS_IPU_* macro
      f2fs: fix to set ipu policy

Yong-Xuan Wang (1):
      cacheinfo: Fix shared_cpu_map to handle shared caches at different levels

Yuan Can (1):
      staging: emxx_udc: Add checks for dma_alloc_coherent()

Yulong Zhang (1):
      tools/iio/iio_utils:fix memory leak

Zhang Yi (1):
      ext4: fix incorrect options show of original mount_opt and extend mount_opt2

Zhengchao Shao (1):
      9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Zhihao Cheng (12):
      ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
      ubifs: Rectify space budget for ubifs_xrename()
      ubifs: Fix wrong dirty space budget for dirty inode
      ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1
      ubifs: Reserve one leb for each journal head while doing budget
      ubifs: Re-statistic cleaned znode count if commit failed
      ubifs: dirty_cow_znode: Fix memleak in error handling path
      ubifs: ubifs_writepage: Mark page dirty after writing inode failed
      ubifs: ubifs_releasepage: Remove ubifs_assert(0) to valid this process
      ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap
      ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
      ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

Zhong Jinghua (1):
      loop: loop_set_status_from_info() check before assignment

Zhu Lingshan (10):
      vDPA/ifcvf: decouple hw features manipulators from the adapter
      vDPA/ifcvf: decouple config space ops from the adapter
      vDPA/ifcvf: alloc the mgmt_dev before the adapter
      vDPA/ifcvf: decouple vq IRQ releasers from the adapter
      vDPA/ifcvf: decouple config IRQ releaser from the adapter
      vDPA/ifcvf: decouple vq irq requester from the adapter
      vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter
      vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
      vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
      vDPA/ifcvf: allocate the adapter in dev_add()

ruanjinjie (1):
      watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

Íñigo Huguet (1):
      ptp: vclock: use mutex to fix "sleep on atomic" bug

