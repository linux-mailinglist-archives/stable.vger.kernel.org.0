Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CFE14D74
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfEFOsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729488AbfEFOsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:48:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1273A2173B;
        Mon,  6 May 2019 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154114;
        bh=EQqNxaUIGKKqQ3AAQPn8Vxt8ARoVDnTyxWclRlJqS9k=;
        h=From:To:Cc:Subject:Date:From;
        b=oHkTcS3fDXw9Jrw2ARLofP4lU5xQxaNkIndW91w0GyRqe6EoUKwTPHVuIyVTWly5T
         jjwnoSkwfyR7L06Lx4BfiIYXhhXugRLUjofiVhi936p1+OEO0ZGc4Vst9dFWpiFs3H
         +FIslF96O7823uGEk39mrOs6BAmebg5AcuqRfIlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/62] 4.9.174-stable review
Date:   Mon,  6 May 2019 16:32:31 +0200
Message-Id: <20190506143051.102535767@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.174-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.174-rc1
X-KernelTest-Deadline: 2019-05-08T14:30+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.174 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 08 May 2019 02:29:15 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.174-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.174-rc1

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Tony Luck <tony.luck@intel.com>
    x86/mce: Improve error message when kernel cannot recover, p2

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: never allow relabeling on context mounts

Anson Huang <anson.huang@nxp.com>
    Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/srpt: Fix a credit leak for aborted commands

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Update generic hardware cache events for Family 17h

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

Randy Dunlap <rdunlap@infradead.org>
    sh: fix multiple function definition build errors

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Use NAPI_POLL_WEIGHT for hns driver

Liubin Shu <shuliubin@huawei.com>
    net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Xose Vazquez Perez <xose.vazquez@gmail.com>
    scsi: core: add new RDAC LENOVO/DE_Series device

Louis Taylor <louis@kragniz.eu>
    vfio/pci: use correct format characters

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: da9063: set uie_unsupported when relevant

Al Viro <viro@zeniv.linux.org.uk>
    debugfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't log oversized frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix dropping of multi-descriptor RX frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't overwrite discard_frame status

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Omri Kahalon <omrik@mellanox.com>
    net/mlx5: E-Switch, Fix esw manager vport indication for more vport commands

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_global hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_local hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce claim hash refcnt only for removed entry

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Kangjie Lu <kjlu@umn.edu>
    HID: logitech: check the return value of create_singlethread_workqueue

Yufen Yu <yuyufen@huawei.com>
    nvme-loop: init nvmet_ctrl fatal_err_work when allocate

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size with KASAN

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: mm: don't print out page table entries on EL0 faults

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: mm: print out correct page table entries

Andrey Konovalov <andreyknvl@google.com>
    kasan: prevent compiler from optimizing away memset in tests

Will Deacon <will.deacon@arm.com>
    arm64: proc: Set PTE_NG for table entries to avoid traversing them twice

Colin Ian King <colin.king@canonical.com>
    kasan: remove redundant initialization of variable 'real_size'

Arnd Bergmann <arnd@arndb.de>
    kasan: avoid -Wmaybe-uninitialized warning

Masami Hiramatsu <mhiramat@kernel.org>
    kasan: add a prototype of task_struct to avoid warning

Mark Rutland <mark.rutland@arm.com>
    arm64: kasan: avoid bad virt_to_pfn()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind: Disable KASAN checks for non-current tasks

Laura Abbott <labbott@redhat.com>
    mm/kasan: Switch to using __pa_symbol and lm_alias

Arnd Bergmann <arnd@arndb.de>
    kasan: rework Kconfig settings

Andrey Ryabinin <aryabinin@virtuozzo.com>
    kasan: turn on -fsanitize-address-use-after-scope

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/suspend: fix false positive KASAN warning on suspend/resume

Andrew Lunn <andrew@lunn.ch>
    net: phy: marvell: Fix buffer overrun with stats counters

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve multicast address setup logic.

Willem de Bruijn <willemb@google.com>
    packet: validate msg_namelen in send directly

Willem de Bruijn <willemb@google.com>
    ipv6: invert flowlabel sharing check in process and user mode

Eric Dumazet <edumazet@google.com>
    ipv6/flowlabel: wait rcu grace period before put_pid()

Shmulik Ladkani <shmulik@metanetworks.com>
    ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: line6: use dynamic buffers


-------------

Diffstat:

 Documentation/usb/power-management.txt            |  14 ++-
 Makefile                                          |   4 +-
 arch/arm/mach-iop13xx/setup.c                     |   8 +-
 arch/arm/mach-iop13xx/tpmi.c                      |  10 +-
 arch/arm/plat-iop/adma.c                          |   6 +-
 arch/arm/plat-orion/common.c                      |   4 +-
 arch/arm64/include/asm/system_misc.h              |   2 +-
 arch/arm64/mm/fault.c                             |  35 ++++---
 arch/arm64/mm/kasan_init.c                        |   2 +-
 arch/arm64/mm/proc.S                              |  14 ++-
 arch/sh/boards/of-generic.c                       |   4 +-
 arch/x86/events/amd/core.c                        | 111 +++++++++++++++++++++-
 arch/x86/include/asm/stacktrace.h                 |   5 +-
 arch/x86/kernel/acpi/wakeup_64.S                  |   9 ++
 arch/x86/kernel/cpu/mcheck/mce-severity.c         |   5 +
 arch/x86/kernel/unwind_frame.c                    |  20 +++-
 drivers/block/xsysace.c                           |   2 +
 drivers/hid/hid-debug.c                           |   5 +
 drivers/hid/hid-logitech-hidpp.c                  |   8 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c             |  11 +++
 drivers/input/keyboard/snvs_pwrkey.c              |   6 +-
 drivers/media/i2c/ov7670.c                        |  16 ++--
 drivers/net/bonding/bond_sysfs_slave.c            |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   9 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c         |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c     |  12 +--
 drivers/net/ethernet/intel/igb/e1000_defines.h    |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c         |  57 ++---------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |   6 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c    |  12 ++-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c   |   2 -
 drivers/net/phy/marvell.c                         |   6 +-
 drivers/nvme/target/core.c                        |  20 ++--
 drivers/rtc/rtc-da9063.c                          |   7 ++
 drivers/rtc/rtc-sh.c                              |   2 +-
 drivers/scsi/scsi_devinfo.c                       |   1 +
 drivers/scsi/scsi_dh.c                            |   1 +
 drivers/scsi/storvsc_drv.c                        |  13 ++-
 drivers/staging/iio/addac/adt7316.c               |  22 +++--
 drivers/usb/core/driver.c                         |  13 ---
 drivers/usb/core/message.c                        |   4 +-
 drivers/usb/misc/yurex.c                          |   1 +
 drivers/usb/storage/realtek_cr.c                  |  13 +--
 drivers/usb/usbip/stub_rx.c                       |  12 +--
 drivers/usb/usbip/usbip_common.h                  |   7 ++
 drivers/vfio/pci/vfio_pci.c                       |   4 +-
 drivers/w1/masters/ds2490.c                       |   6 +-
 fs/debugfs/inode.c                                |  13 ++-
 fs/hugetlbfs/inode.c                              |  20 ++--
 fs/jffs2/readinode.c                              |   5 -
 fs/jffs2/super.c                                  |   5 +-
 include/linux/kasan.h                             |   1 +
 include/linux/usb.h                               |   2 -
 include/net/caif/cfpkt.h                          |  27 ++++++
 lib/Kconfig.debug                                 |   1 +
 lib/Kconfig.kasan                                 |  11 +++
 lib/Makefile                                      |   1 +
 lib/test_kasan.c                                  |   2 +-
 mm/kasan/kasan.c                                  |   9 +-
 mm/kasan/kasan_init.c                             |  15 +--
 mm/kasan/report.c                                 |   1 +
 net/batman-adv/bridge_loop_avoidance.c            |  16 +++-
 net/batman-adv/translation-table.c                |  32 +++++--
 net/caif/cfctrl.c                                 |  50 +++++-----
 net/ipv4/ip_output.c                              |   1 +
 net/ipv6/ip6_flowlabel.c                          |  22 +++--
 net/packet/af_packet.c                            |  24 +++--
 scripts/Makefile.kasan                            |   4 +
 security/selinux/hooks.c                          |  40 ++++++--
 sound/usb/line6/driver.c                          |  60 +++++++-----
 sound/usb/line6/podhd.c                           |  21 ++--
 sound/usb/line6/toneport.c                        |  24 +++--
 72 files changed, 629 insertions(+), 319 deletions(-)


