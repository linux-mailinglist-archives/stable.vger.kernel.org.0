Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D651463C2
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAWIp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 03:45:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA912073A;
        Thu, 23 Jan 2020 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579769127;
        bh=uDb0Wmkvb62f7YPo2uC4Zd01UV6O5od81j5UcW54/Q0=;
        h=Date:From:To:Cc:Subject:From;
        b=XRKLZZTucNAJLuCxw8wiiP1EHBlmemAaXKQ06KxX3LlZZtfr/iAocNgwEDse6RZHF
         kAm8tQ+J/HCJyxjJfiUvnCNFtp9pE0OOdR8vyRWAb9n8UfCSEjHC4TJ5KhNwfM9UpC
         b9fK4ox29YHHaLOvChh9GaY6NX104d/P7jsc2Z2c=
Date:   Thu, 23 Jan 2020 09:45:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.211
Message-ID: <20200123084525.GA435086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.211 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-mei            |    2 
 Makefile                                           |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |    8 
 arch/hexagon/kernel/stacktrace.c                   |    4 
 arch/x86/boot/compressed/head_64.S                 |    5 
 block/blk-settings.c                               |    2 
 drivers/block/xen-blkfront.c                       |    4 
 drivers/clk/samsung/clk-exynos5420.c               |    2 
 drivers/gpio/gpiolib.c                             |    5 
 drivers/hid/hidraw.c                               |    7 
 drivers/hid/uhid.c                                 |    5 
 drivers/iio/imu/adis16480.c                        |    6 
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   24 ++
 drivers/iommu/iommu.c                              |    1 
 drivers/md/dm-snap-persistent.c                    |    2 
 drivers/md/raid0.c                                 |    2 
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 
 drivers/media/usb/zr364xx/zr364xx.c                |    3 
 drivers/message/fusion/mptctl.c                    |  213 ++++-----------------
 drivers/misc/enclosure.c                           |    3 
 drivers/net/ethernet/stmicro/stmmac/common.h       |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    4 
 drivers/net/macvlan.c                              |    5 
 drivers/net/usb/lan78xx.c                          |    1 
 drivers/net/usb/r8152.c                            |    3 
 drivers/net/wimax/i2400m/op-rfkill.c               |    1 
 drivers/net/wireless/cw1200/fwio.c                 |    6 
 drivers/net/wireless/p54/p54usb.c                  |   43 +---
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    2 
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    1 
 drivers/platform/x86/asus-wmi.c                    |    8 
 drivers/rtc/rtc-msm6242.c                          |    3 
 drivers/rtc/rtc-mt6397.c                           |   47 +++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 
 drivers/scsi/esas2r/esas2r_flash.c                 |    1 
 drivers/scsi/fnic/vnic_dev.c                       |   30 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    3 
 drivers/scsi/scsi_trace.c                          |  114 +++--------
 drivers/scsi/sd.c                                  |    4 
 drivers/spi/spi-atmel.c                            |   10 
 drivers/target/target_core_fabric_lib.c            |    2 
 drivers/tty/serial/imx.c                           |    2 
 drivers/tty/serial/pch_uart.c                      |    5 
 drivers/usb/core/hub.c                             |    1 
 drivers/usb/serial/ch341.c                         |    6 
 drivers/usb/serial/io_edgeport.c                   |   33 +--
 drivers/usb/serial/keyspan.c                       |    4 
 drivers/usb/serial/opticon.c                       |    2 
 drivers/usb/serial/quatech2.c                      |    6 
 drivers/usb/serial/usb-serial-simple.c             |    2 
 drivers/usb/serial/usb-serial.c                    |    3 
 drivers/xen/balloon.c                              |   16 +
 firmware/Makefile                                  |    2 
 fs/cifs/smb2file.c                                 |    2 
 fs/ext4/inode.c                                    |   15 +
 fs/ext4/super.c                                    |   60 +++--
 fs/ocfs2/journal.c                                 |    8 
 fs/proc/meminfo.c                                  |   31 ---
 include/linux/blkdev.h                             |    8 
 include/linux/mm.h                                 |    1 
 include/linux/regulator/ab8500.h                   |    2 
 include/net/cfg80211.h                             |   11 +
 mm/page-writeback.c                                |    4 
 mm/page_alloc.c                                    |   43 ++++
 net/batman-adv/distributed-arp-table.c             |    4 
 net/dccp/feat.c                                    |    7 
 net/hsr/hsr_device.c                               |    2 
 net/ipv4/tcp_input.c                               |    7 
 net/mac80211/cfg.c                                 |   55 -----
 net/mac80211/sta_info.c                            |    4 
 net/netfilter/ipset/ip_set_bitmap_gen.h            |    2 
 net/socket.c                                       |    1 
 net/wireless/rdev-ops.h                            |    4 
 net/wireless/util.c                                |   45 ++++
 sound/core/seq/seq_timer.c                         |   14 -
 sound/usb/line6/pcm.c                              |   19 +
 tools/perf/util/probe-finder.c                     |   32 ---
 tools/testing/selftests/rseq/settings              |    1 
 78 files changed, 528 insertions(+), 532 deletions(-)

Alan Stern (1):
      p54usb: Fix race between disconnect and firmware loading

Alexander Usyskin (1):
      mei: fix modalias documentation

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded

Andy Shevchenko (1):
      scsi: fnic: use kernel's '%pM' format option to print MAC

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (2):
      compat_ioctl: handle SIOCOUTQNSD
      scsi: fnic: fix invalid stack access

Barret Rhoden (1):
      ext4: fix use-after-free race with debug_want_extra_isize

Bart Van Assche (3):
      RDMA/srpt: Report the SCSI residual to the initiator
      scsi: target: core: Fix a pr_debug() argument
      scsi: core: scsi_trace: Use get_unaligned_be*()

Cong Wang (1):
      netfilter: fix a use-after-free in mtype_destroy()

Dan Carpenter (3):
      scsi: mptfusion: Fix double fetch bug in ioctl
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Eric Dumazet (2):
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net: usb: lan78xx: limit size of local TSO packets

Fabian Henneke (1):
      hidraw: Return EPOLLOUT from hidraw_poll

Geert Uytterhoeven (1):
      gpio: Fix error message on out-of-range GPIO in lookup table

Greg Kroah-Hartman (1):
      Linux 4.4.211

Igor Redko (1):
      mm/page_alloc.c: calculate 'available' memory in a separate function

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jerónimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT

Johan Hovold (8):
      USB: serial: opticon: fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: quatech2: handle unbound ports
      USB: serial: io_edgeport: handle unbound ports on URB completion
      USB: serial: keyspan: handle unbound ports
      r8152: add missing endpoint sanity check

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

John Ogness (1):
      USB: serial: io_edgeport: use irqsave() in USB's complete callback

Jon Derrick (1):
      iommu: Remove device link to group on failure

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size

Jouni Malinen (1):
      mac80211: Do not send Layer 2 Update frame before authorization

Juergen Gross (1):
      xen: let alloc_xenballooned_pages() fail if not enough memory free

Kai Li (1):
      ocfs2: call journal flush to mark journal as empty after journal recovery when mount

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer

Marcel Holtmann (1):
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume

Masami Hiramatsu (1):
      perf probe: Fix wrong address verification

Mathieu Desnoyers (1):
      rseq/selftests: Turn off timeout setting

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Nathan Chancellor (3):
      cifs: Adjust indentation in smb2_open_file
      rtlwifi: Remove unnecessary NULL check in rtl_regd_init
      xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Navid Emamdoost (2):
      wimax: i2400: fix memory leak
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Nick Desaulniers (1):
      hexagon: work around compiler crash

Pan Bian (2):
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
      tty: serial: pch_uart: correct usage of dma_unmap_sg

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Ran Bi (1):
      rtc: mt6397: fix alarm register overwrite

Sanjay Konduri (1):
      rsi: add fix for crash during assertions

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()

Stephan Gerhold (1):
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Taehee Yoo (1):
      hsr: reset network header when supervision frame is created

Takashi Iwai (3):
      ALSA: line6: Fix write on zero-sized buffer
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
      ALSA: seq: Fix racy access for queue timer in proc read

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Wen Yang (1):
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

YueHaibing (1):
      dccp: Fix memleak in __feat_register_sp

