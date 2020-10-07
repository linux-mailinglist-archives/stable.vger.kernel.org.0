Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA5285B6F
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgJGI6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 04:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgJGI6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 04:58:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9952080A;
        Wed,  7 Oct 2020 08:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061116;
        bh=eaUMKdoqjlDG6Zp+8kr/pt0/Zb2VaD3+5xEFPkEv9xI=;
        h=From:To:Cc:Subject:Date:From;
        b=yy3l0yduajbYDwhoP5ZUb5Hd2eHARQR/hlF9LfSwdfOFj78un8WgRlFL570k8JiNr
         XtDsXOzWMhAUe8nvluaO0uwXO3ORUlh2gGWuij/S1xfq13aG0TZ33pRHCWlYSxmXOy
         usnP561OXk2+yu9JPDfnLHk+OGIBVuhUgR/TQz5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.14
Date:   Wed,  7 Oct 2020 10:59:15 +0200
Message-Id: <160206115643114@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.14 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/gpio/sgpio-aspeed.txt |    5 
 Makefile                                                |    2 
 block/blk-mq.c                                          |   18 +-
 block/blk-settings.c                                    |   46 +++++
 drivers/clk/samsung/clk-exynos4.c                       |    4 
 drivers/clk/samsung/clk-exynos5420.c                    |    5 
 drivers/clk/socfpga/clk-s10.c                           |    2 
 drivers/clk/tegra/clk-pll.c                             |    3 
 drivers/clk/tegra/clk-tegra210-emc.c                    |    2 
 drivers/clocksource/timer-gx6605s.c                     |    1 
 drivers/cpuidle/cpuidle-psci.c                          |    4 
 drivers/dma/dmatest.c                                   |   26 ++-
 drivers/gpio/gpio-amd-fch.c                             |    2 
 drivers/gpio/gpio-aspeed-sgpio.c                        |  134 ++++++++++------
 drivers/gpio/gpio-aspeed.c                              |    4 
 drivers/gpio/gpio-mockup.c                              |    2 
 drivers/gpio/gpio-pca953x.c                             |    7 
 drivers/gpio/gpio-siox.c                                |    1 
 drivers/gpio/gpio-sprd.c                                |    3 
 drivers/gpio/gpio-tc3589x.c                             |    2 
 drivers/gpio/gpiolib.c                                  |   34 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c             |    2 
 drivers/gpu/drm/i915/gvt/vgpu.c                         |    6 
 drivers/gpu/drm/sun4i/sun8i_mixer.c                     |    2 
 drivers/i2c/busses/i2c-cpm.c                            |    3 
 drivers/i2c/busses/i2c-i801.c                           |    1 
 drivers/i2c/busses/i2c-npcm7xx.c                        |    9 +
 drivers/iio/adc/qcom-spmi-adc5.c                        |    2 
 drivers/input/mouse/trackpoint.c                        |    2 
 drivers/input/serio/i8042-x86ia64io.h                   |    7 
 drivers/iommu/amd/init.c                                |   56 +-----
 drivers/iommu/exynos-iommu.c                            |    8 
 drivers/memstick/core/memstick.c                        |    4 
 drivers/mmc/host/sdhci-pci-core.c                       |    3 
 drivers/net/dsa/ocelot/felix_vsc9959.c                  |   16 -
 drivers/net/ethernet/dec/tulip/de2104x.c                |    2 
 drivers/net/hyperv/hyperv_net.h                         |    3 
 drivers/net/hyperv/netvsc_drv.c                         |   21 ++
 drivers/net/usb/rndis_host.c                            |    2 
 drivers/net/wan/hdlc_cisco.c                            |    1 
 drivers/net/wan/hdlc_fr.c                               |    6 
 drivers/net/wan/hdlc_ppp.c                              |    1 
 drivers/net/wan/lapbether.c                             |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c        |    8 
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c         |    2 
 drivers/net/wireless/ti/wlcore/cmd.h                    |    1 
 drivers/net/wireless/ti/wlcore/main.c                   |    4 
 drivers/nvme/host/core.c                                |   15 +
 drivers/nvme/host/fc.c                                  |    6 
 drivers/nvme/host/pci.c                                 |   17 +-
 drivers/phy/ti/phy-am654-serdes.c                       |    6 
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c        |    4 
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c               |    2 
 drivers/pinctrl/qcom/pinctrl-sm8250.c                   |    2 
 drivers/scsi/iscsi_tcp.c                                |   22 +-
 drivers/scsi/sd.c                                       |   34 ++--
 drivers/scsi/sd.h                                       |   14 -
 drivers/scsi/sd_zbc.c                                   |  131 ++++++++-------
 drivers/spi/spi-fsl-espi.c                              |    5 
 drivers/target/target_core_transport.c                  |    3 
 drivers/usb/core/driver.c                               |   50 ++++-
 drivers/usb/gadget/function/f_ncm.c                     |   30 ---
 drivers/usb/usbip/stub_dev.c                            |    6 
 drivers/xen/events/events_base.c                        |   29 ++-
 fs/autofs/waitq.c                                       |    2 
 fs/btrfs/dev-replace.c                                  |   40 ++++
 fs/eventpoll.c                                          |   72 +++-----
 fs/fuse/file.c                                          |   25 +-
 fs/io_uring.c                                           |    8 
 fs/nfs/dir.c                                            |    3 
 fs/nfs/flexfilelayout/flexfilelayout.c                  |   11 -
 fs/nfs/nfs42proc.c                                      |   10 +
 fs/pipe.c                                               |   62 ++++---
 fs/read_write.c                                         |    8 
 fs/splice.c                                             |    8 
 fs/vboxsf/super.c                                       |    2 
 include/linux/blkdev.h                                  |    2 
 include/linux/memstick.h                                |    1 
 include/linux/pipe_fs_i.h                               |    5 
 kernel/trace/ftrace.c                                   |    6 
 kernel/trace/trace.c                                    |   48 ++---
 kernel/trace/trace_output.c                             |   12 -
 lib/random32.c                                          |    2 
 net/mac80211/rx.c                                       |    3 
 net/mac80211/vht.c                                      |    8 
 scripts/dtc/Makefile                                    |    2 
 scripts/kallsyms.c                                      |   16 +
 tools/io_uring/io_uring-bench.c                         |    4 
 tools/lib/bpf/Makefile                                  |    2 
 89 files changed, 760 insertions(+), 461 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the overwritten field in IVMD header

Ahmad Fatoum (1):
      gpio: siox: explicitly support only threaded irqs

Al Viro (5):
      fuse: fix the ->direct_IO() treatment of iov_iter
      epoll: do not insert into poll queues until all sanity checks are done
      epoll: replace ->visited/visited_list with generation count
      epoll: EPOLL_CTL_ADD: close the race in decision to take fast path
      ep_create_wakeup_source(): dentry name can change under you...

Aloka Dixit (1):
      mac80211: Fix radiotap header channel flag for 6GHz band

Andy Shevchenko (2):
      gpio: pca953x: Correctly initialize registers 6 and 7 for PCA957x
      gpiolib: Fix line event handling in syscall compatible mode

Bartosz Golaszewski (1):
      gpio: mockup: fix resource leak in error path

Bryan O'Donoghue (1):
      USB: gadget: f_ncm: Fix NDP16 datagram validation

Chaitanya Kulkarni (1):
      nvme-core: get/put ctrl and transport module in nvme_dev_open/release()

Chris Packham (2):
      spi: fsl-espi: Only process interrupts for expected events
      pinctrl: mvebu: Fix i2c sda definition for 98DX3236

Damien Le Moal (2):
      scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks
      scsi: sd: sd_zbc: Fix ZBC disk initialization

Dan Carpenter (1):
      phy: ti: am654: Fix a leak in serdes_am654_probe()

David Milburn (1):
      nvme-pci: disable the write zeros command for Intel 600P/P3100

Dexuan Cui (1):
      hv_netvsc: Cache the current data path to avoid duplicate call and message

Dinh Nguyen (1):
      clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk

Dmitry Baryshkov (2):
      iio: adc: qcom-spmi-adc5: fix driver name
      pinctrl: qcom: sm8250: correct sdc2_clk

Douglas Gilbert (1):
      tools/io_uring: fix compile breakage

Ed Wildgoose (1):
      gpio: amd-fch: correct logic of GPIO_LINE_DIRECTION

Felix Fietkau (2):
      mt76: mt7915: use ieee80211_free_txskb to free tx skbs
      mac80211: do not allow bigger VHT MPDUs than the hardware supports

Filipe Manana (1):
      btrfs: fix filesystem corruption after a device replace

Greg Kroah-Hartman (1):
      Linux 5.8.14

Guo Ren (1):
      clocksource/drivers/timer-gx6605s: Fixup counter reload

Hanks Chen (1):
      pinctrl: mediatek: check mtk_is_virt_gpio input parameter

Hans de Goede (2):
      mmc: sdhci: Workaround broken command queuing on Intel GLK based IRBIS models
      vboxsf: Fix the check for the old binary mount-arguments struct

James Smart (1):
      nvme-fc: fail new connections to a deleted host or remote port

Jean Delvare (2):
      i2c: i801: Exclude device from suspend direct complete optimization
      drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Jeffrey Mitchell (1):
      nfs: Fix security label length not being reset

Jens Axboe (2):
      io_uring: always delete double poll wait entry on match
      io_uring: mark statx/files_update/epoll_ctl as non-SQPOLL

Jeremy Kerr (2):
      gpio/aspeed-sgpio: enable access to all 80 input & output sgpios
      gpio/aspeed-sgpio: don't enable all interrupts by default

Jiri Kosina (1):
      Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

Juergen Gross (1):
      xen/events: don't use chip_data for legacy IRQs

Kai-Heng Feng (1):
      memstick: Skip allocating card when removing host

Linus Torvalds (2):
      autofs: use __kernel_write() for the autofs pipe writing
      pipe: remove pipe_wait() and fix wakeup race with splice

Lucy Yan (1):
      net: dec: de2104x: Increase receive ring size for Tulip

M. Vefa Bicakci (4):
      Revert "usbip: Implement a match function to fix usbip"
      usbcore/driver: Fix specific driver selection
      usbcore/driver: Fix incorrect downcast
      usbcore/driver: Accommodate usbip

Marek Szyprowski (2):
      clk: samsung: Keep top BPLL mux on Exynos542x enabled
      clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Mark Mielke (1):
      scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()

Martin Cerveny (1):
      drm/sun4i: mixer: Extend regmap max_register

Masahiro Yamada (1):
      scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*

Mauro Carvalho Chehab (1):
      Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"

Naveen N. Rao (1):
      libbpf: Remove arch-specific include path in Makefile

Nicolas VINCENT (1):
      i2c: cpm: Fix i2c_ram structure

Olga Kornievskaia (1):
      NFSv4.2: fix client's attribute cache management for copy_file_range

Olympia Giannou (1):
      rndis_host: increase sleep time in the query-response loop

Sebastian Andrzej Siewior (1):
      tracing: Make the space reserved for the pid wider

Steven Rostedt (VMware) (2):
      ftrace: Move RCU is watching check after recursion check
      tracing: Fix trace_find_next_entry() accounting of temp buffer size

Sudhakar Panneerselvam (1):
      scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case

Taiping Lai (1):
      gpio: sprd: Clear interrupt when setting the type as edge

Tali Perry (1):
      i2c: npcm7xx: Clear LAST bit after a failed transaction.

Tao Ren (1):
      gpio: aspeed: fix ast2600 bank properties

Thibaut Sautereau (1):
      random32: Restore __latent_entropy attribute on net_rand_state

Thierry Reding (2):
      clk: tegra: Always program PLL_E when enabled
      clk: tegra: Fix missing prototype for tegra210_clk_register_emc()

Trond Myklebust (1):
      pNFS/flexfiles: Ensure we initialise the mirror bsizes correctly on read

Ulf Hansson (1):
      cpuidle: psci: Fix suspicious RCU usage

Uwe Kleine-König (1):
      scripts/dtc: only append to HOST_EXTRACFLAGS instead of overwriting

Vincent Huang (1):
      Input: trackpoint - enable Synaptics trackpoints

Vladimir Murzin (1):
      dmaengine: dmatest: Prevent to run on misconfigured channel

Xianting Tian (1):
      nvme-pci: fix NULL req in completion handler

Xiaoliang Yang (1):
      net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries

Xie He (3):
      drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
      drivers/net/wan/lapbether: Make skb->protocol consistent with the header
      drivers/net/wan/hdlc: Set skb->protocol before transmitting

Ye Li (1):
      gpio: pca953x: Fix uninitialized pending variable

Yu Kuai (1):
      iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

Zhenyu Wang (1):
      drm/i915/gvt: Fix port number for BDW on EDID region setup

dillon min (1):
      gpio: tc35894: fix up tc35894 interrupt configuration

yangerkun (1):
      blk-mq: call commit_rqs while list empty but error happen

