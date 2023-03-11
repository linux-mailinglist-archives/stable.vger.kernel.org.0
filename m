Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A746B5CBA
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCKOTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCKORu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:17:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960A82ED76;
        Sat, 11 Mar 2023 06:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF78960C3E;
        Sat, 11 Mar 2023 14:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A5C433D2;
        Sat, 11 Mar 2023 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678544247;
        bh=valHDEXoSQsx+P3ZS1NQOqTPUbnwqjfJrZfk93UTtkY=;
        h=From:To:Cc:Subject:Date:From;
        b=QOkatWQmuG+rpwcgapHxu0sIPL7YAyD3FsaXcRx7/OWHkSkHpubY6DbMhpXDvWWrF
         GMa8wPUokPSrBZ4Ft+RaldsZS3K5fMkqY2G6+Yg9bc8HVu77y3bi52HmC1TUJiNUvs
         1fJWsMZ9kQu6eScYsqevaIuWjZprfbi1Jwx/Hdos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.100
Date:   Sat, 11 Mar 2023 15:17:09 +0100
Message-Id: <167854423054246@kroah.com>
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

I'm announcing the release of the 5.15.100 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/configfs-usb-gadget-uvc          |    2 
 Makefile                                                   |    2 
 arch/alpha/kernel/irq.c                                    |    2 
 arch/arm/boot/dts/spear320-hmi.dts                         |    2 
 arch/ia64/kernel/iosapic.c                                 |    2 
 arch/ia64/kernel/irq.c                                     |    4 
 arch/ia64/kernel/msi_ia64.c                                |    4 
 arch/parisc/kernel/irq.c                                   |    2 
 arch/um/drivers/vector_kern.c                              |    1 
 arch/um/drivers/virt-pci.c                                 |   26 
 arch/um/drivers/virtio_uml.c                               |   18 
 arch/x86/include/asm/resctrl.h                             |   12 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                     |    4 
 arch/x86/kernel/process_32.c                               |    2 
 arch/x86/kernel/process_64.c                               |    2 
 arch/x86/um/vdso/um_vdso.c                                 |   12 
 drivers/auxdisplay/hd44780.c                               |    2 
 drivers/base/component.c                                   |    2 
 drivers/base/dd.c                                          |    2 
 drivers/block/loop.c                                       |    8 
 drivers/firmware/efi/sysfb_efi.c                           |    8 
 drivers/gpu/drm/arm/malidp_planes.c                        |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                      |    5 
 drivers/gpu/drm/virtio/virtgpu_object.c                    |    3 
 drivers/iio/accel/mma9551_core.c                           |   10 
 drivers/infiniband/hw/hfi1/chip.c                          |   59 -
 drivers/iommu/amd/iommu.c                                  |   12 
 drivers/irqchip/irq-bcm6345-l1.c                           |    4 
 drivers/media/usb/uvc/uvc_ctrl.c                           |    5 
 drivers/media/usb/uvc/uvc_driver.c                         |   90 -
 drivers/media/usb/uvc/uvc_entity.c                         |    2 
 drivers/media/usb/uvc/uvc_status.c                         |   37 
 drivers/media/usb/uvc/uvc_v4l2.c                           |    2 
 drivers/media/usb/uvc/uvc_video.c                          |   15 
 drivers/media/usb/uvc/uvcvideo.h                           |    4 
 drivers/mfd/arizona-core.c                                 |    2 
 drivers/misc/mei/bus-fixup.c                               |    8 
 drivers/misc/vmw_balloon.c                                 |    2 
 drivers/mtd/ubi/build.c                                    |    7 
 drivers/mtd/ubi/fastmap-wl.c                               |   12 
 drivers/mtd/ubi/vmt.c                                      |   18 
 drivers/mtd/ubi/wl.c                                       |   25 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c    |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c       |    1 
 drivers/nfc/st-nci/se.c                                    |    6 
 drivers/nfc/st21nfca/se.c                                  |    6 
 drivers/parisc/iosapic.c                                   |    2 
 drivers/pci/controller/pci-loongson.c                      |   71 -
 drivers/pci/pci.c                                          |   10 
 drivers/pci/quirks.c                                       |   22 
 drivers/pci/setup-bus.c                                    |  179 +--
 drivers/phy/rockchip/phy-rockchip-typec.c                  |    3 
 drivers/pwm/pwm-sifive.c                                   |   16 
 drivers/pwm/pwm-stm32-lp.c                                 |    2 
 drivers/rtc/interface.c                                    |    2 
 drivers/rtc/rtc-sun6i.c                                    |   16 
 drivers/scsi/ipr.c                                         |   41 
 drivers/scsi/mpt3sas/mpt3sas_base.c                        |   20 
 drivers/sh/intc/chip.c                                     |    2 
 drivers/soundwire/bus_type.c                               |    9 
 drivers/soundwire/cadence_master.c                         |   43 
 drivers/soundwire/cadence_master.h                         |   13 
 drivers/staging/emxx_udc/emxx_udc.c                        |    7 
 drivers/thermal/intel/Kconfig                              |    3 
 drivers/thermal/intel/intel_quark_dts_thermal.c            |   12 
 drivers/tty/serial/fsl_lpuart.c                            |   24 
 drivers/tty/serial/pch_uart.c                              |    2 
 drivers/tty/serial/sc16is7xx.c                             |   51 
 drivers/tty/tty_io.c                                       |    8 
 drivers/tty/vt/vc_screen.c                                 |    4 
 drivers/usb/chipidea/debug.c                               |    2 
 drivers/usb/core/usb.c                                     |    2 
 drivers/usb/dwc3/core.h                                    |    2 
 drivers/usb/dwc3/debug.h                                   |    3 
 drivers/usb/dwc3/debugfs.c                                 |   19 
 drivers/usb/dwc3/gadget.c                                  |    4 
 drivers/usb/gadget/function/uvc_configfs.c                 |   59 -
 drivers/usb/gadget/udc/bcm63xx_udc.c                       |    2 
 drivers/usb/gadget/udc/gr_udc.c                            |    2 
 drivers/usb/gadget/udc/lpc32xx_udc.c                       |    2 
 drivers/usb/gadget/udc/pxa25x_udc.c                        |    2 
 drivers/usb/gadget/udc/pxa27x_udc.c                        |    2 
 drivers/usb/host/fotg210-hcd.c                             |    2 
 drivers/usb/host/isp116x-hcd.c                             |    2 
 drivers/usb/host/isp1362-hcd.c                             |    2 
 drivers/usb/host/sl811-hcd.c                               |    2 
 drivers/usb/host/uhci-hcd.c                                |    6 
 drivers/usb/host/xhci-mvebu.c                              |    2 
 drivers/usb/storage/ene_ub6250.c                           |    2 
 drivers/watchdog/at91sam9_wdt.c                            |    7 
 drivers/watchdog/pcwd_usb.c                                |    6 
 drivers/watchdog/sbsa_gwdt.c                               |    1 
 drivers/watchdog/watchdog_dev.c                            |    2 
 drivers/xen/events/events_base.c                           |    7 
 fs/ext4/fast_commit.c                                      |   44 
 fs/f2fs/file.c                                             |    2 
 fs/f2fs/inline.c                                           |   15 
 fs/f2fs/iostat.c                                           |    6 
 fs/f2fs/super.c                                            |   11 
 fs/f2fs/verity.c                                           |   12 
 fs/jfs/jfs_dmap.c                                          |    3 
 fs/ubifs/budget.c                                          |    9 
 fs/ubifs/dir.c                                             |    9 
 fs/ubifs/file.c                                            |   12 
 fs/ubifs/super.c                                           |   17 
 fs/ubifs/tnc.c                                             |   24 
 fs/ubifs/ubifs.h                                           |    5 
 include/linux/bootconfig.h                                 |    2 
 include/linux/irq.h                                        |   18 
 include/linux/pci.h                                        |    1 
 include/linux/pci_ids.h                                    |    2 
 include/net/sctp/structs.h                                 |    1 
 include/net/tc_act/tc_pedit.h                              |   81 +
 include/uapi/linux/usb/video.h                             |   30 
 include/uapi/linux/uvcvideo.h                              |    2 
 kernel/fail_function.c                                     |    5 
 kernel/printk/index.c                                      |    2 
 kernel/trace/ring_buffer.c                                 |    7 
 net/9p/trans_rdma.c                                        |   15 
 net/9p/trans_xen.c                                         |   48 
 net/bluetooth/hci_sock.c                                   |   11 
 net/bridge/netfilter/ebtables.c                            |    2 
 net/core/dev.c                                             |    4 
 net/ipv4/netfilter/arp_tables.c                            |    4 
 net/ipv4/netfilter/ip_tables.c                             |    7 
 net/ipv4/tcp_minisocks.c                                   |    7 
 net/ipv6/netfilter/ip6_tables.c                            |    7 
 net/ipv6/route.c                                           |   11 
 net/netfilter/nf_conntrack_netlink.c                       |    5 
 net/netfilter/nf_tables_api.c                              |    2 
 net/nfc/netlink.c                                          |    4 
 net/sched/Kconfig                                          |   11 
 net/sched/Makefile                                         |    1 
 net/sched/act_mpls.c                                       |   66 -
 net/sched/act_pedit.c                                      |  178 +--
 net/sched/act_sample.c                                     |   11 
 net/sched/cls_tcindex.c                                    |  756 -------------
 net/sctp/stream_sched_prio.c                               |   52 
 net/tls/tls_sw.c                                           |   26 
 sound/soc/codecs/Kconfig                                   |    2 
 sound/soc/codecs/adau7118.c                                |   19 
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c                |    3 
 tools/iio/iio_utils.c                                      |   23 
 tools/objtool/check.c                                      |    2 
 145 files changed, 1267 insertions(+), 1495 deletions(-)

Alexander Potapenko (1):
      fs: f2fs: initialize fsdata in pagecache_write()

Alexander Usyskin (1):
      mei: bus-fixup:upon error print return values of send and receive

Alexandre Belloni (1):
      rtc: allow rtc_read_alarm without read_alarm callback

Ammar Faizi (1):
      x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Arnd Bergmann (2):
      scsi: ipr: Work around fortify-string warning
      ASoC: zl38060 add gpiolib dependency

Benjamin Berg (4):
      um: virtio_uml: free command if adding to virtqueue failed
      um: virtio_uml: mark device as unregistered when breaking it
      um: virtio_uml: move device breaking into workqueue
      um: virt-pci: properly remove PCI device from bus

Chen Jun (1):
      watchdog: Fix kmemleak in watchdog_cdev_register

Dan Carpenter (1):
      thermal: intel: quark_dts: fix error pointer dereference

Daniel Scally (2):
      usb: uvc: Enumerate valid values for color matching
      usb: gadget: uvc: Make bSourceID read/write

Darrell Kavanagh (1):
      firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Dean Luick (1):
      IB/hfi1: Update RMT size calculation

Deepak R Varma (1):
      octeontx2-pf: Use correct struct reference in test condition

Emil Renner Berthing (1):
      pwm: sifive: Always let the first pwm_apply_state succeed

Eric Biggers (2):
      f2fs: use memcpy_{to,from}_page() where possible
      ext4: use ext4_fc_tl_mem in fast-commit replay path

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fabrice Gasnier (1):
      pwm: stm32-lp: fix the check on arr and cmp registers update

Fedor Pchelkin (1):
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Westphal (1):
      netfilter: ebtables: fix table blob use-after-free

George Cherian (1):
      watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

George Kennedy (2):
      ubi: ensure that VID header offset + VID header size <= alloc, size
      vc_screen: modify vcs_size() handling in vcs_read()

Greg Kroah-Hartman (20):
      kernel/printk/index.c: fix memory leak with using debugfs_lookup()
      USB: fix memory leak with using debugfs_lookup()
      USB: dwc3: fix memory leak with using debugfs_lookup()
      USB: chipidea: fix memory leak with using debugfs_lookup()
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
      Linux 5.15.100

Guenter Roeck (1):
      media: uvcvideo: Handle errors from calls to usb_string

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Harshit Mogalapalli (3):
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()
      iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()
      drm/virtio: Fix error code in virtio_gpu_object_shmem_init()

Huacai Chen (2):
      PCI: loongson: Prevent LS7A MRRS increases
      PCI: loongson: Add more devices that need MRRS quirk

Imre Deak (2):
      drm/display/dp_mst: Fix down/up message handling after sink disconnect
      drm/display/dp_mst: Fix down message handling after a packet reception error

Isaac True (1):
      serial: sc16is7xx: setup GPIO controller later in probe

Jakub Kicinski (1):
      net: tls: avoid hanging tasks on the tx_lock

Jamal Hadi Salim (1):
      net/sched: Retire tcindex classifier

Jia-Ju Bai (1):
      tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Jianglei Nie (1):
      auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()

Jiapeng Chong (1):
      phy: rockchip-typec: Fix unsigned comparison with less than zero

Juergen Gross (2):
      9p/xen: fix version parsing
      9p/xen: fix connection sequence

Kees Cook (3):
      media: uvcvideo: Silence memcpy() run-time false positive warnings
      usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math
      USB: ene_usb6250: Allocate enough memory for full object

Krzysztof Kozlowski (1):
      ARM: dts: spear320-hmi: correct STMPE GPIO compatible

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

Liu Shixin via Jfs-discussion (1):
      fs/jfs: fix shift exponent db_agl2size negative

Lu Wei (1):
      ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Mark Brown (1):
      ASoC: zl38060: Remove spurious gpiolib select

Mengyuan Lou (1):
      PCI: Add ACS quirk for Wangxun NICs

Miaoqian Lin (2):
      objtool: Fix memory leak in create_static_call_sections()
      malidp: Fix NULL vs IS_ERR() checking

Mika Westerberg (2):
      PCI: Align extra resources for hotplug bridges properly
      PCI: Take other bus devices into account when distributing resources

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

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

Randy Dunlap (1):
      thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Ricardo Ribalda (3):
      media: uvcvideo: Handle cameras with invalid descriptors
      media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910
      media: uvcvideo: Fix race condition with usb_kill_urb

Richard Fitzgerald (3):
      soundwire: bus_type: Avoid lockdep assert in sdw_drv_probe()
      soundwire: cadence: Remove wasted space in response_buf
      soundwire: cadence: Drain the RX FIFO after an IO timeout

Roi Dayan (1):
      net/mlx5e: Verify flow_source cap before using it

Salvatore Bonaccorso (1):
      Revert "scsi: mpt3sas: Fix return value check of dma_get_required_mask()"

Samuel Holland (3):
      rtc: sun6i: Always export the internal oscillator
      genirq: Refactor accessors to use irq_data_get_affinity_mask
      genirq: Add and use an irq_data_update_affinity helper

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable the CTS when send break signal

Souradeep Chowdhury (1):
      bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support

Sreekanth Reddy (3):
      scsi: mpt3sas: Don't change DMA mask while reallocating pools
      scsi: mpt3sas: re-do lost mpt3sas DMA mask fix
      scsi: mpt3sas: Remove usage of dma_get_required_mask() API

Sven Schnelle (1):
      tty: fix out-of-bounds access in tty_driver_lookup_tty()

Trevor Wu (1):
      ASoC: mediatek: mt8195: add missing initialization

Uwe Kleine-König (1):
      pwm: sifive: Reduce time the controller lock is held

Vasant Hegde (1):
      iommu/amd: Fix error handling for pdev_pri_ats_enable()

Xiang Yang (1):
      um: vector: Fix memory leak in vector_config

Xin Long (1):
      sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Yang Yingliang (2):
      ubi: Fix possible null-ptr-deref in ubi_free_volume()
      usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails

Yangtao Li (2):
      f2fs: allow set compression option of files without blocks
      f2fs: fix to avoid potential memory corruption in __update_iostat_latency()

Yuan Can (1):
      staging: emxx_udc: Add checks for dma_alloc_coherent()

Yulong Zhang (1):
      tools/iio/iio_utils:fix memory leak

Zhengchao Shao (1):
      9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Zhihao Cheng (11):
      ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted
      ubifs: Rectify space budget for ubifs_xrename()
      ubifs: Fix wrong dirty space budget for dirty inode
      ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1
      ubifs: Reserve one leb for each journal head while doing budget
      ubifs: Re-statistic cleaned znode count if commit failed
      ubifs: dirty_cow_znode: Fix memleak in error handling path
      ubifs: ubifs_writepage: Mark page dirty after writing inode failed
      ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap
      ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()
      ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

Zhong Jinghua (1):
      loop: loop_set_status_from_info() check before assignment

ruanjinjie (1):
      watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

