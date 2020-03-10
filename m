Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5817FEBD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJMlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgCJMlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D512B24691;
        Tue, 10 Mar 2020 12:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844070;
        bh=wtADKHxGmUWh7xx3WNn62nMwhd5poJI7boyk3TEWRPU=;
        h=From:To:Cc:Subject:Date:From;
        b=0sjGq+vFElEyaSao/P1WEg2CrS7vzkogbtZ6xHQyCKGEV4bj3xQRdtKV5VR8NOg0m
         Nw5Q6VKevto44fjvnsoGJzaL2whlxCbNHTsP4RKMG5a6qA/R/tjnzZbfJXrd06doLC
         D+FTQqr5rXZ5ok/HUjMzoHcAC3uHD8doGN2FGrDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/72] 4.4.216-stable review
Date:   Tue, 10 Mar 2020 13:38:13 +0100
Message-Id: <20200310123601.053680753@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.216-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.216-rc1
X-KernelTest-Deadline: 2020-03-12T12:36+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.216 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.216-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.216-rc1

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

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Fix use-after-free

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push sel_lock up

Jiri Slaby <jslaby@suse.cz>
    vt: selection, push console lock down

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

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

Daniel Golle <daniel@makrotopia.org>
    serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Paul Moore <paul@paul-moore.com>
    audit: always check the netlink payload length in audit_receive_msg()

Matthew Wilcox <willy@infradead.org>
    fs: prevent page refcount overflow in pipe_buf_get

Miklos Szeredi <mszeredi@redhat.com>
    pipe: add pipe_buf_get() helper

Linus Torvalds <torvalds@linux-foundation.org>
    mm: prevent get_user_pages() from overflowing page refcount

Punit Agrawal <punit.agrawal@arm.com>
    mm, gup: ensure real head page is ref-counted when using hugepages

Will Deacon <will.deacon@arm.com>
    mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

Linus Torvalds <torvalds@linux-foundation.org>
    mm: add 'try_get_page()' helper function

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make page ref count overflow check tighter and more explicit

yangerkun <yangerkun@huawei.com>
    slip: stop double free sl->dev in slip_open

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check for a bad hva before dropping into the ghc slow path

Aleksa Sarai <cyphar@cyphar.com>
    namei: only return -ECHILD from follow_dotdot_rcu()

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: netlink: cap max groups which will be considered in netlink_bind()

Chris Wilson <chris@chris-wilson.co.uk>
    include/linux/bitops.h: introduce BITS_PER_TYPE

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

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: check wiphy driver existence for drvinfo report

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider more elements in parsing CRC

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

 Makefile                                 |   4 +-
 arch/arm/mach-imx/Makefile               |   2 +
 arch/arm/mach-imx/common.h               |   4 +-
 arch/arm/mach-imx/resume-imx6.S          |  24 +++++++
 arch/arm/mach-imx/suspend-imx6.S         |  14 -----
 arch/mips/kernel/vpe.c                   |   2 +-
 arch/powerpc/kernel/cputable.c           |   4 +-
 arch/s390/mm/gup.c                       |   6 +-
 arch/x86/mm/gup.c                        |   9 ++-
 crypto/algif_skcipher.c                  |   2 +-
 drivers/char/ipmi/ipmi_ssif.c            |  10 ++-
 drivers/dma/coh901318.c                  |   4 --
 drivers/dma/tegra20-apb-dma.c            |   6 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c    |   7 ++-
 drivers/hid/hid-core.c                   |   4 +-
 drivers/hid/usbhid/hiddev.c              |   2 +-
 drivers/hwmon/adt7462.c                  |   2 +-
 drivers/i2c/busses/i2c-jz4780.c          |  36 +----------
 drivers/infiniband/core/cm.c             |   1 +
 drivers/infiniband/core/iwcm.c           |   4 +-
 drivers/md/dm-cache-target.c             |   4 +-
 drivers/net/ethernet/micrel/ks8851_mll.c |  53 +++-------------
 drivers/net/phy/mdio-bcm-iproc.c         |  20 ++++++
 drivers/net/slip/slip.c                  |   1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c   |   6 +-
 drivers/nfc/pn544/i2c.c                  |   1 +
 drivers/s390/cio/blacklist.c             |   5 +-
 drivers/tty/serial/ar933x_uart.c         |   8 +++
 drivers/tty/sysrq.c                      |   8 +--
 drivers/tty/vt/selection.c               |  24 ++++++-
 drivers/tty/vt/vt.c                      |   2 -
 drivers/usb/core/hub.c                   |   6 +-
 drivers/usb/core/port.c                  |  10 ++-
 drivers/usb/core/quirks.c                |   3 +
 drivers/usb/gadget/function/f_fs.c       |   5 +-
 drivers/usb/gadget/function/u_serial.c   |   4 +-
 drivers/usb/storage/unusual_devs.h       |   6 ++
 drivers/video/console/vgacon.c           |   3 +
 drivers/watchdog/da9062_wdt.c            |   7 ---
 fs/cifs/cifsacl.c                        |   4 +-
 fs/cifs/connect.c                        |   2 +-
 fs/cifs/inode.c                          |   8 ++-
 fs/ecryptfs/keystore.c                   |   4 +-
 fs/ext4/balloc.c                         |  14 ++++-
 fs/ext4/ext4.h                           |  30 +++++++--
 fs/ext4/ialloc.c                         |  23 ++++---
 fs/ext4/mballoc.c                        |  61 ++++++++++++------
 fs/ext4/resize.c                         |  62 +++++++++++++++----
 fs/ext4/super.c                          | 103 +++++++++++++++++++++----------
 fs/fat/inode.c                           |  19 +++---
 fs/fuse/dev.c                            |  12 ++--
 fs/namei.c                               |   2 +-
 fs/pipe.c                                |   4 +-
 fs/splice.c                              |  12 +++-
 include/linux/bitops.h                   |   3 +-
 include/linux/hid.h                      |   2 +-
 include/linux/mm.h                       |  23 ++++++-
 include/linux/pipe_fs_i.h                |  17 ++++-
 include/net/flow_dissector.h             |   9 +++
 kernel/audit.c                           |  40 ++++++------
 kernel/auditfilter.c                     |  71 +++++++++++----------
 kernel/trace/trace.c                     |   6 +-
 mm/gup.c                                 |  51 ++++++++++-----
 mm/hugetlb.c                             |  16 ++++-
 mm/internal.h                            |  28 ++++++++-
 net/core/fib_rules.c                     |   2 +-
 net/ipv6/ip6_fib.c                       |   7 ++-
 net/ipv6/route.c                         |   1 +
 net/mac80211/util.c                      |  18 ++++--
 net/netlink/af_netlink.c                 |   5 +-
 net/sched/cls_flower.c                   |   1 +
 net/sctp/sm_statefuns.c                  |  27 +++++---
 net/wireless/ethtool.c                   |   8 ++-
 net/wireless/nl80211.c                   |   1 +
 sound/soc/codecs/pcm512x.c               |   8 ++-
 sound/soc/soc-dapm.c                     |   2 +-
 sound/soc/soc-pcm.c                      |  16 ++---
 virt/kvm/kvm_main.c                      |  12 ++--
 78 files changed, 684 insertions(+), 373 deletions(-)


