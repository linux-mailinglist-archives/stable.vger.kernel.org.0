Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B123E3EB847
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242083AbhHMPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241821AbhHMPLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C362610FC;
        Fri, 13 Aug 2021 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867473;
        bh=bTagKZbyBioy5Khiriez8vXGOTqWZRljn1SXL1Liw38=;
        h=From:To:Cc:Subject:Date:From;
        b=wiojFZqIPdtBy6nng9OrZtA6BZcS8oy1yxLsoqjBbLRsXm04Mb7hxS0KRNSJW2yvr
         0qo+eULbEiUnAVsg0QOx7+KJGelycCUT26M52Gc4Viaoh3zvEOQi7PXTwD/hgUYVr2
         Ck/MaZCK/UQW9nyzQDquglFVvWPkfxH3SDpC4T7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/42] 4.14.244-rc1 review
Date:   Fri, 13 Aug 2021 17:06:26 +0200
Message-Id: <20210813150525.098817398@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.244-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.244-rc1
X-KernelTest-Deadline: 2021-08-15T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.244 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.244-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.244-rc1

YueHaibing <yuehaibing@huawei.com>
    net: xilinx_emaclite: Do not print real IOMEM pointer

Miklos Szeredi <mszeredi@redhat.com>
    ovl: prevent private clone if bind mount is not allowed

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ppp unit id when ifname is not specified

Longfang Liu <liulongfang@huawei.com>
    USB:ehci:fix Kunpeng920 ehci hardware problem

Letu Ren <fantasquex@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Prarit Bhargava <prarit@redhat.com>
    alpha: Send stop IPI to send to online CPUs

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    reiserfs: check directory items on read from disk

Yu Kuai <yukuai3@huawei.com>
    reiserfs: add check for root_inode in reiserfs_fill_super

Christoph Hellwig <hch@lst.de>
    libata: fix ata_pio_sector for CONFIG_HIGHMEM

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: add network device usage statistics for qmimux devices

Like Xu <likexu@tencent.com>
    perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: meson-spicc: fix memory leak in meson_spicc_remove

Zheyu Ma <zheyuma97@gmail.com>
    pcmcia: i82092: fix a null pointer dereference bug

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Mask out floating 16/32-bit bus bits

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree corruption when growing large_dir directories

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    pipe: increase minimum default pipe size to 2 pages

Johan Hovold <johan@kernel.org>
    media: rtl28xxu: fix zero-length control request

Xiangyang Zhang <xyz.sun.ok@gmail.com>
    staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Hui Su <suhui@zeku.com>
    scripts/tracing: fix the bug that can't parse raw_trace_func

Dmitry Osipenko <digetx@gmail.com>
    usb: otg-fsm: Fix hrtimer list corruption

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: idle uses the highest byte for duration

Phil Elwell <phil@raspberrypi.com>
    usb: gadget: f_hid: fixed NULL pointer dereference

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers

David Bauer <mail@david-bauer.net>
    USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Willy Tarreau <w@1wt.eu>
    USB: serial: ch341: fix character loss at high transfer rates

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FD980 composition 0x1056

Qiang.zhang <qiang.zhang@windriver.com>
    USB: usbtmc: Fix RCU stall warning

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    Bluetooth: defer cleanup of resources in hci_unregister_dev()

Pavel Skripkin <paskripkin@gmail.com>
    net: vxge: fix use-after-free in vxge_device_unregister

Pavel Skripkin <paskripkin@gmail.com>
    net: fec: fix use-after-free in fec_drv_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: pegasus: fix uninit-value in get_interrupt_interval

Dan Carpenter <dan.carpenter@oracle.com>
    bnx2x: fix an error code in bnx2x_nic_load()

H. Nikolaus Schaller <hns@goldelico.com>
    mips: Fix non-POSIX regexp

Fei Qin <fei.qin@corigine.com>
    nfp: update ethtool reporting of pauseframe control

Wang Hai <wanghai38@huawei.com>
    net: natsemi: Fix missing pci_disable_device() in probe and remove

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf2-core: dequeue if start_streaming fails

Li Manyi <limanyi@uniontech.com>
    scsi: sr: Return correct event when media event code is 3

H. Nikolaus Schaller <hns@goldelico.com>
    omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator

Dario Binacchi <dariobin@libero.it>
    clk: stm32f4: fix post divisor setup for I2S/SAI PLLs

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy deletion of subscriber

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPICA: Fix memory leak caused by _CID repair function"


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/alpha/kernel/smp.c                            |  2 +-
 arch/arm/boot/dts/omap5-board-common.dtsi          |  9 +--
 arch/mips/Makefile                                 |  2 +-
 arch/mips/mti-malta/malta-platform.c               |  3 +-
 arch/x86/events/perf_event.h                       |  3 +-
 drivers/acpi/acpica/nsrepair2.c                    |  7 --
 drivers/ata/libata-sff.c                           | 35 +++++++---
 drivers/clk/clk-stm32f4.c                          | 10 +--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            | 11 +++-
 drivers/media/v4l2-core/videobuf2-core.c           | 13 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  3 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |  8 +--
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |  6 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  2 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  6 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  5 +-
 drivers/net/ppp/ppp_generic.c                      | 19 ++++--
 drivers/net/usb/pegasus.c                          | 14 +++-
 drivers/net/usb/qmi_wwan.c                         | 76 ++++++++++++++++++++--
 drivers/pcmcia/i82092.c                            |  1 +
 drivers/scsi/sr.c                                  |  2 +-
 drivers/spi/spi-meson-spicc.c                      |  2 +
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |  2 +
 drivers/tty/serial/8250/8250_port.c                | 12 +++-
 drivers/usb/class/usbtmc.c                         |  8 +--
 drivers/usb/common/usb-otg-fsm.c                   |  6 +-
 drivers/usb/gadget/function/f_hid.c                | 44 +++++++++++--
 drivers/usb/host/ehci-pci.c                        |  3 +
 drivers/usb/serial/ch341.c                         |  1 +
 drivers/usb/serial/ftdi_sio.c                      |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  3 +
 drivers/usb/serial/option.c                        |  2 +
 fs/ext4/namei.c                                    |  2 +-
 fs/namespace.c                                     | 42 ++++++++----
 fs/pipe.c                                          | 19 +++++-
 fs/reiserfs/stree.c                                | 31 +++++++--
 fs/reiserfs/super.c                                |  8 +++
 include/linux/usb/otg-fsm.h                        |  1 +
 include/net/bluetooth/hci_core.h                   |  1 +
 net/bluetooth/hci_core.c                           | 16 ++---
 net/bluetooth/hci_sock.c                           | 49 +++++++++-----
 net/bluetooth/hci_sysfs.c                          |  3 +
 scripts/tracing/draw_functrace.py                  |  6 +-
 sound/core/seq/seq_ports.c                         | 39 +++++++----
 46 files changed, 400 insertions(+), 144 deletions(-)


