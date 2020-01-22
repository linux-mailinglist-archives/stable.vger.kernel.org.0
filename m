Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB81451DB
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgAVJbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbgAVJbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:31:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 685B124680;
        Wed, 22 Jan 2020 09:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685495;
        bh=e5CR/xwvhTvjXup380lM8/cBtxscnNeJaiEo7pDgo6k=;
        h=From:To:Cc:Subject:Date:From;
        b=vl8AsMwplGB/ALagYmhgP60V3FXcNHzLiKtsR/osSEyIkQ09Al2r2PphA8mnxqKBW
         uV3+3DbNiynK2rJD2ru+rlwpcewIHaOOAtEU4l+dGy5/eWQlG12XhA73HjDmMmoYlH
         zKv7Awf0FXVeRlNaMS0T2bEcv24YaVOINcIKX/nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/76] 4.4.211-stable review
Date:   Wed, 22 Jan 2020 10:28:16 +0100
Message-Id: <20200122092751.587775548@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.211-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.211-rc1
X-KernelTest-Deadline: 2020-01-24T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.211 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.211-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.211-rc1

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix wrong address verification

Bart Van Assche <bvanassche@acm.org>
    scsi: core: scsi_trace: Use get_unaligned_be*()

Bart Van Assche <bvanassche@acm.org>
    scsi: target: core: Fix a pr_debug() argument

Pan Bian <bianpan2016@163.com>
    scsi: bnx2i: fix potential use after free

Pan Bian <bianpan2016@163.com>
    scsi: qla4xxx: fix double free bug

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check for set_wiphy_params

Dan Carpenter <dan.carpenter@oracle.com>
    cw1200: Fix a signedness bug in cw1200_load_firmware()

Nathan Chancellor <natechancellor@gmail.com>
    xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: limit size of local TSO packets

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix marked lost packets not being retransmitted

Johan Hovold <johan@kernel.org>
    r8152: add missing endpoint sanity check

Eric Dumazet <edumazet@google.com>
    macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix DAT candidate selection on little endian systems

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: fix a use-after-free in mtype_destroy()

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Arnd Bergmann <arnd@arndb.de>
    scsi: fnic: fix invalid stack access

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    scsi: fnic: use kernel's '%pM' format option to print MAC

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: handle unbound ports on URB completion

John Ogness <john.ogness@linutronix.de>
    USB: serial: io_edgeport: use irqsave() in USB's complete callback

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Enable 16KB buffer size

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: 16KB buffer must be 16 byte aligned

Wen Yang <wenyang@linux.alibaba.com>
    mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Disable paging at mixed mode entry

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    usb: core: hub: Improved device recognition on remote wakeup

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: mptfusion: Fix double fetch bug in ioctl

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: add missing active-port sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: handle unbound port at reset_resume

Johan Hovold <johan@kernel.org>
    USB: serial: suppress driver bind attributes

Johan Hovold <johan@kernel.org>
    USB: serial: opticon: fix control-message timeouts

Jerónimo Borque <jeronimo@borque.com.ar>
    USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Mikulas Patocka <mpatocka@redhat.com>
    block: fix an integer overflow in logical block size

Jari Ruusu <jari.ruusu@gmail.com>
    Fix built-in early-load Intel microcode alignment

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy access for queue timer in proc read

Kai Li <li.kai4@h3c.com>
    ocfs2: call journal flush to mark journal as empty after journal recovery when mount

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: work around compiler crash

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Turn off timeout setting

Kars de Jong <jongk@linux-m68k.org>
    rtc: msm6242: Fix reading of 10-hour digit

Nathan Chancellor <natechancellor@gmail.com>
    rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Mans Rullgard <mans@mansr.com>
    spi: atmel: fix handling of cs_change set on non-last xfer

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: Fix recursive locking in isp_video_release()

Peng Fan <peng.fan@nxp.com>
    tty: serial: pch_uart: correct usage of dma_unmap_sg

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: use the sg count from dma_map_sg

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: handle SIOCOUTQNSD

Marian Mihailescu <mihailescu2m@gmail.com>
    clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix modalias documentation

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: assign bias value only if operation succeeded

Jian-Hong Pan <jian-hong@endlessm.com>
    platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

James Bottomley <James.Bottomley@HansenPartnership.com>
    scsi: enclosure: Fix stale device oops with hot replug

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Report the SCSI residual to the initiator

Nathan Chancellor <natechancellor@gmail.com>
    cifs: Adjust indentation in smb2_open_file

Taehee Yoo <ap420073@gmail.com>
    hsr: reset network header when supervision frame is created

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix error message on out-of-range GPIO in lookup table

Jon Derrick <jonathan.derrick@intel.com>
    iommu: Remove device link to group on failure

Ran Bi <ran.bi@mediatek.com>
    rtc: mt6397: fix alarm register overwrite

YueHaibing <yuehaibing@huawei.com>
    dccp: Fix memleak in __feat_register_sp

Theodore Ts'o <tytso@mit.edu>
    ext4: add more paranoia checking in ext4_expand_extra_isize handling

Barret Rhoden <brho@google.com>
    ext4: fix use-after-free race with debug_want_extra_isize

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: fix memory leak

Juergen Gross <jgross@suse.com>
    xen: let alloc_xenballooned_pages() fail if not enough memory free

Igor Redko <redkoi@virtuozzo.com>
    mm/page_alloc.c: calculate 'available' memory in a separate function

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix memory leak at line6_init_pcm() error path

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix write on zero-sized buffer

Alan Stern <stern@rowland.harvard.edu>
    p54usb: Fix race between disconnect and firmware loading

Vandana BN <bnvandana@gmail.com>
    media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Do not send Layer 2 Update frame before authorization

Dedy Lansky <dlansky@codeaurora.org>
    cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Sanjay Konduri <sanjay.konduri@redpinesignals.com>
    rsi: add fix for crash during assertions

Jiri Kosina <jkosina@suse.cz>
    HID: hidraw, uhid: Always report EPOLLOUT

Marcel Holtmann <marcel@holtmann.org>
    HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Fabian Henneke <fabian.henneke@gmail.com>
    hidraw: Return EPOLLOUT from hidraw_poll


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-mei            |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 arch/hexagon/kernel/stacktrace.c                   |   4 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 block/blk-settings.c                               |   2 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/gpio/gpiolib.c                             |   5 +-
 drivers/hid/hidraw.c                               |   7 +-
 drivers/hid/uhid.c                                 |   5 +-
 drivers/iio/imu/adis16480.c                        |   6 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +++
 drivers/iommu/iommu.c                              |   1 +
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/message/fusion/mptctl.c                    | 213 +++++----------------
 drivers/misc/enclosure.c                           |   3 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/usb/r8152.c                            |   3 +
 drivers/net/wimax/i2400m/op-rfkill.c               |   1 +
 drivers/net/wireless/cw1200/fwio.c                 |   6 +-
 drivers/net/wireless/p54/p54usb.c                  |  43 ++---
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/rtc/rtc-mt6397.c                           |  47 +++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/fnic/vnic_dev.c                       |  30 ++-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 114 ++++-------
 drivers/scsi/sd.c                                  |   4 +-
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 drivers/usb/core/hub.c                             |   1 +
 drivers/usb/serial/ch341.c                         |   6 +-
 drivers/usb/serial/io_edgeport.c                   |  33 ++--
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/quatech2.c                      |   6 +
 drivers/usb/serial/usb-serial-simple.c             |   2 +
 drivers/usb/serial/usb-serial.c                    |   3 +
 drivers/xen/balloon.c                              |  16 +-
 firmware/Makefile                                  |   2 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/ext4/inode.c                                    |  15 ++
 fs/ext4/super.c                                    |  60 +++---
 fs/ocfs2/journal.c                                 |   8 +
 fs/proc/meminfo.c                                  |  31 +--
 include/linux/blkdev.h                             |   8 +-
 include/linux/mm.h                                 |   1 +
 include/linux/regulator/ab8500.h                   |   2 -
 include/net/cfg80211.h                             |  11 ++
 mm/page-writeback.c                                |   4 +-
 mm/page_alloc.c                                    |  43 +++++
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/dccp/feat.c                                    |   7 +-
 net/hsr/hsr_device.c                               |   2 +
 net/ipv4/tcp_input.c                               |   7 +-
 net/mac80211/cfg.c                                 |  55 +-----
 net/mac80211/sta_info.c                            |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/socket.c                                       |   1 +
 net/wireless/rdev-ops.h                            |   4 +
 net/wireless/util.c                                |  45 +++++
 sound/core/seq/seq_timer.c                         |  14 +-
 sound/usb/line6/pcm.c                              |  19 +-
 tools/perf/util/probe-finder.c                     |  32 +---
 tools/testing/selftests/rseq/settings              |   1 +
 78 files changed, 529 insertions(+), 533 deletions(-)


