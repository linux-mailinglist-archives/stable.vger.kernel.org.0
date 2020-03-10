Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40BB17F824
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgCJMp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgCJMpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40D524691;
        Tue, 10 Mar 2020 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844321;
        bh=JVp3w6sVp/1KB6PVXw8rf2hFcM8CWm3fxEat2qrOqdM=;
        h=From:To:Cc:Subject:Date:From;
        b=IybJd2XBsR/GkFfhi0ZAFLYXgf9B+2vvw22rqhuU8ASqY5wkftGFi4/V8MGW3IKTU
         5lFbk564kR0ieh30jXodKZ6YP46dYp2K4Pn/oCJ971Gnc3cL6tY7DDicW7kHYCxdzH
         S3MXmN95RrEIqfI92EGJ2XMwMl+ffMfaMstOU7vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/88] 4.9.216-stable review
Date:   Tue, 10 Mar 2020 13:38:08 +0100
Message-Id: <20200310123606.543939933@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.216-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.216-rc1
X-KernelTest-Deadline: 2020-03-12T12:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.216 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.216-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.216-rc1

yangerkun <yangerkun@huawei.com>
    crypto: algif_skcipher - use ZERO_OR_NULL_PTR in skcipher_recvmsg_async

Mikulas Patocka <mpatocka@redhat.com>
    dm cache: fix a crash due to incorrect work item cancelling

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: build v7_cpu_resume() unconditionally

Jason Gunthorpe <jgg@mellanox.com>
    RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/iwcm: Fix iwcm work deallocation

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Matthias Reichl <hias@horus.com>
    ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path

Takashi Iwai <tiwai@suse.de>
    ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Vladimir Oltean <olteanv@gmail.com>
    ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Fix use-after-free

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push sel_lock up

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push console lock down

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

tangbin <tangbin@cmss.chinamobile.com>
    tty:serial:mvebu-uart:fix a wrong return

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix uninit-memory access for partial initialized inode

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    vgacon: Fix a UAF in vgacon_invert_region

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: port: do error out if usb_autopm_get_interface() fails

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: do error out if usb_autopm_get_interface() fails

Dan Lazewatsky <dlaz@chromium.org>
    usb: quirks: add NO_LPM quirk for Logitech Screen Share

Jim Lin <jilin@nvidia.com>
    usb: storage: Add quirk for Samsung Fit flash

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: don't leak -EAGAIN for stat() during reconnect

H.J. Lu <hjl.tools@gmail.com>
    x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Vasily Averin <vvs@virtuozzo.com>
    s390/cio: cio_ignore_proc_seq_next should increase position index

Marco Felsch <m.felsch@pengutronix.de>
    watchdog: da9062: do not ping the hw during stop()

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit IO operation

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix 16-bit data access

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Remove 8-bit bus accessors

Harigovindan P <harigovi@codeaurora.org>
    drm/msm/dsi: save pll state before dsi host is powered off

John Stultz <john.stultz@linaro.org>
    drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI

Sergey Organov <sorganov@gmail.com>
    usb: gadget: serial: fix Tx stall after buffer overflow

Lars-Peter Clausen <lars@metafoo.de>
    usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Support more than 500mA MaxPower

Daniel Golle <daniel@makrotopia.org>
    serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Eugenio Pérez <eperezma@redhat.com>
    vhost: Check docket sk_family instead of call getname

Paul Moore <paul@paul-moore.com>
    audit: always check the netlink payload length in audit_receive_msg()

Wei Yang <richardw.yang@linux.intel.com>
    mm/huge_memory.c: use head to check huge zero page

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers: net: xgene: Fix the order of the arguments of 'alloc_etherdev_mqs()'

Jason Wang <jasowang@redhat.com>
    tuntap: correctly set SOCKWQ_ASYNC_NOSPACE

yangerkun <yangerkun@huawei.com>
    slip: stop double free sl->dev in slip_open

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check for a bad hva before dropping into the ghc slow path

Aleksa Sarai <cyphar@cyphar.com>
    namei: only return -ECHILD from follow_dotdot_rcu()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: netlink: cap max groups which will be considered in netlink_bind()

Chris Wilson <chris@chris-wilson.co.uk>
    include/linux/bitops.h: introduce BITS_PER_TYPE

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250: Check UPF_IRQ_SHARED in advance

Nathan Chancellor <natechancellor@gmail.com>
    ecryptfs: Fix up bad backport of fe2e082f5da5b4a0a92ae32978f81507ef37ec66

Wolfram Sang <wsa@the-dreams.de>
    i2c: jz4780: silence log flood on txabrt

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'

dan.carpenter@oracle.com <dan.carpenter@oracle.com>
    HID: hiddev: Fix race in in hiddev_disconnect()

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: increase HID report buffer size to 8KiB

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: fix off-by-one memset in hid_report_raw_event()

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI: watchdog: Fix gas->access_width usage

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro

Paul Moore <paul@paul-moore.com>
    audit: fix error handling in audit_data_to_entry()

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()

Jason Baron <jbaron@akamai.com>
    net: sched: correct flower port blocking

Dmitry Osipenko <digetx@gmail.com>
    nfc: pn544: Fix occasional HW initialization failure

Xin Long <lucien.xin@gmail.com>
    sctp: move the format error check out of __sctp_sf_do_9_1_abort

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix route replacement with dev-only route

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix nlmsg_flags when splitting a multipath route

Arun Parameswaran <arun.parameswaran@broadcom.com>
    net: phy: restore mdio regs in the iproc mdio driver

Jethro Beekman <jethro@fortanix.com>
    net: fib_rules: Correctly set table field when table number exceeds 8 bits

Petr Mladek <pmladek@suse.com>
    sysrq: Remove duplicated sysrq message

Petr Mladek <pmladek@suse.com>
    sysrq: Restore original console_loglevel when sysrq disabled

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Frank Sorenson <sorenson@redhat.com>
    cifs: Fix mode output in debugging statements

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: ena-com.c: prevent NULL pointer dereference

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrectly saving queue numbers when setting RSS indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: rss: store hash function as values and not bits

Sameeh Jubran <sameehj@amazon.com>
    net: ena: rss: fix failure to get indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrect default RSS key

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: add missing ethtool TX timestamping indication

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix potential crash when rxfh key is NULL

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: re-add DW5821e pre-production variant

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: check wiphy driver existence for drvinfo report

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider more elements in parsing CRC

Sean Paul <seanpaul@chromium.org>
    drm/msm: Set dma maximum segment size for mdss

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Handle a possible NULL pointer reference

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_group_info online resizing and access

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_flex_groups online resizing and access

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential race between online resizing and write operations

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix rb_allocator workqueue allocation


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/boot/dts/ls1021a.dtsi                   |   4 +-
 arch/arm/mach-imx/Makefile                       |   2 +
 arch/arm/mach-imx/common.h                       |   4 +-
 arch/arm/mach-imx/resume-imx6.S                  |  24 ++++++
 arch/arm/mach-imx/suspend-imx6.S                 |  14 ---
 arch/mips/kernel/vpe.c                           |   2 +-
 arch/powerpc/kernel/cputable.c                   |   4 +-
 arch/x86/boot/compressed/pagetable.c             |   3 -
 arch/x86/kernel/cpu/common.c                     |   2 +-
 crypto/algif_skcipher.c                          |   2 +-
 drivers/acpi/acpi_watchdog.c                     |   3 +-
 drivers/char/ipmi/ipmi_ssif.c                    |  10 ++-
 drivers/dma/coh901318.c                          |   4 -
 drivers/dma/tegra20-apb-dma.c                    |   6 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c            |   7 +-
 drivers/gpu/drm/msm/msm_drv.c                    |   8 ++
 drivers/hid/hid-core.c                           |   4 +-
 drivers/hid/usbhid/hiddev.c                      |   2 +-
 drivers/hwmon/adt7462.c                          |   2 +-
 drivers/i2c/busses/i2c-jz4780.c                  |  36 +-------
 drivers/infiniband/core/cm.c                     |   1 +
 drivers/infiniband/core/iwcm.c                   |   4 +-
 drivers/md/dm-cache-target.c                     |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  48 +++++++++--
 drivers/net/ethernet/amazon/ena/ena_com.h        |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    |  42 ++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   2 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |   2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c         |  53 ++----------
 drivers/net/phy/mdio-bcm-iproc.c                 |  20 +++++
 drivers/net/slip/slip.c                          |   1 -
 drivers/net/tun.c                                |  19 ++++-
 drivers/net/usb/qmi_wwan.c                       |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c     |   6 +-
 drivers/nfc/pn544/i2c.c                          |   1 +
 drivers/s390/cio/blacklist.c                     |   5 +-
 drivers/tty/serial/8250/8250_core.c              |   5 +-
 drivers/tty/serial/8250/8250_port.c              |   4 +
 drivers/tty/serial/ar933x_uart.c                 |   8 ++
 drivers/tty/serial/mvebu-uart.c                  |   2 +-
 drivers/tty/sysrq.c                              |   8 +-
 drivers/tty/vt/selection.c                       |  26 +++++-
 drivers/tty/vt/vt.c                              |   2 -
 drivers/usb/core/hub.c                           |   6 +-
 drivers/usb/core/port.c                          |  10 ++-
 drivers/usb/core/quirks.c                        |   3 +
 drivers/usb/gadget/composite.c                   |  24 ++++--
 drivers/usb/gadget/function/f_fs.c               |   5 +-
 drivers/usb/gadget/function/u_serial.c           |   4 +-
 drivers/usb/storage/unusual_devs.h               |   6 ++
 drivers/vhost/net.c                              |  13 +--
 drivers/video/console/vgacon.c                   |   3 +
 drivers/watchdog/da9062_wdt.c                    |   7 --
 drivers/watchdog/wdat_wdt.c                      |   2 +-
 fs/cifs/cifsacl.c                                |   4 +-
 fs/cifs/connect.c                                |   2 +-
 fs/cifs/inode.c                                  |   8 +-
 fs/ecryptfs/keystore.c                           |   4 +-
 fs/ext4/balloc.c                                 |  14 ++-
 fs/ext4/ext4.h                                   |  30 +++++--
 fs/ext4/ialloc.c                                 |  23 +++--
 fs/ext4/mballoc.c                                |  61 +++++++++-----
 fs/ext4/resize.c                                 |  62 +++++++++++---
 fs/ext4/super.c                                  | 103 ++++++++++++++++-------
 fs/fat/inode.c                                   |  19 ++---
 fs/namei.c                                       |   2 +-
 include/acpi/actypes.h                           |   2 +
 include/linux/bitops.h                           |   3 +-
 include/linux/hid.h                              |   2 +-
 include/net/flow_dissector.h                     |   9 ++
 kernel/audit.c                                   |  40 ++++-----
 kernel/auditfilter.c                             |  71 +++++++++-------
 mm/huge_memory.c                                 |   2 +-
 net/core/fib_rules.c                             |   2 +-
 net/ipv6/ip6_fib.c                               |   7 +-
 net/ipv6/route.c                                 |   1 +
 net/mac80211/util.c                              |  18 ++--
 net/netlink/af_netlink.c                         |   5 +-
 net/sched/cls_flower.c                           |   1 +
 net/sctp/sm_statefuns.c                          |  27 ++++--
 net/wireless/ethtool.c                           |   8 +-
 net/wireless/nl80211.c                           |   1 +
 sound/soc/codecs/pcm512x.c                       |   8 +-
 sound/soc/soc-dapm.c                             |   2 +-
 sound/soc/soc-pcm.c                              |  16 ++--
 tools/perf/ui/browsers/hists.c                   |   1 +
 virt/kvm/kvm_main.c                              |  12 +--
 88 files changed, 689 insertions(+), 384 deletions(-)


