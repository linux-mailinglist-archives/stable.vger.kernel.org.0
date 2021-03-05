Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8426432EB04
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCEMla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhCEMlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEABE65027;
        Fri,  5 Mar 2021 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948079;
        bh=bZo97NyhEQoCcQP/c/Zz53WYNL/0a6LA3EYAj8dYtcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DXW+tNCjKjlAOPT0CAirAYpuuND7OeB7kHlDq7vAbNijtJYa3bJMVXmC+Bf5ydIie
         weqPGjIjSFYnvHkeW2IcYEyMxMFISY2aOYNW3ynM5nGWbSH1RT7Efs2w6OtgPtkWpU
         I17p3XFcoBoAaEHLlNjlicR6egosPobKX3eLgBSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/41] 4.9.260-rc1 review
Date:   Fri,  5 Mar 2021 13:22:07 +0100
Message-Id: <20210305120851.255002428@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.260-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.260-rc1
X-KernelTest-Deadline: 2021-03-07T12:08+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.260 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.260-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.260-rc1

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: ioctl: Fix memory leak in video_usercopy

Jens Axboe <axboe@kernel.dk>
    swap: fix swapfile read/write offset

Rokudo Yan <wu-yan@tcl.com>
    zsmalloc: account the number of compacted pages correctly

Jan Beulich <jbeulich@suse.com>
    xen-netback: respect gnttab_map_refs()'s return value

Jan Beulich <jbeulich@suse.com>
    Xen/gnttab: handle p2m update errors on a per-slot basis

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Verify lengths on passthrough PDUs

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE

Joe Perches <joe@perches.com>
    sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output

Lee Duncan <lduncan@suse.com>
    scsi: iscsi: Restrict sessions and handles to admin capabilities

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow entities with no pads

Christian Gromm <christian.gromm@microchip.com>
    staging: most: sound: add sanity check for function argument

Gopal Tiwari <gtiwari@redhat.com>
    Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Fangrui Song <maskray@google.com>
    x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix wmi mgmt tx queue full due to race condition

Di Zhu <zhudi21@huawei.com>
    pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Tony Lindgren <tony@atomide.com>
    wlcore: Fix command execute failure 19 for wl12xx

Jiri Slaby <jslaby@suse.cz>
    vt/consolemap: do font sum unsigned

Heiner Kallweit <hkallweit1@gmail.com>
    x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Dinghao Liu <dinghao.liu@zju.edu.cn>
    staging: fwserial: Fix error handling in fwserial_create

Li Xinhai <lixinhai.lxh@gmail.com>
    mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Marco Elver <elver@google.com>
    net: fix up truesize of cloned skb in skb_prepare_for_shift()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    smackfs: restrict bytes count in smackfs write functions

Yumei Huang <yuhuang@redhat.com>
    xfs: Fix assert failure in xfs_setattr_size()

Randy Dunlap <rdunlap@infradead.org>
    JFS: more checks for invalid superblock

Andrew Murray <andrew.murray@arm.com>
    arm64: Use correct ll/sc atomic constraints

Will Deacon <will.deacon@arm.com>
    arm64: cmpxchg: Use "K" instead of "L" for ll/sc immediate constraint

Will Deacon <will.deacon@arm.com>
    arm64: Avoid redundant type conversions in xchg() and cmpxchg()

Robin Murphy <robin.murphy@arm.com>
    arm64: Remove redundant mov from LL/SC cmpxchg

Muchun Song <songmuchun@bytedance.com>
    printk: fix deadlock when kernel panic

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix update_and_free_page contig page struct assumption

Rolf Eike Beer <eb@emlix.com>
    scripts: set proper OpenSSL include dir also for sign-file

Rolf Eike Beer <eb@emlix.com>
    scripts: use pkg-config to locate libcrypto

Masami Hiramatsu <mhiramat@kernel.org>
    arm: kprobes: Allow to handle reentered kprobe on single-stepping

Lech Perczak <lech.perczak@gmail.com>
    net: usb: qmi_wwan: support ZTE P685M modem

Ben Hutchings <ben@decadent.org.uk>
    futex: Don't enable IRQs unconditionally in put_pi_state()

Ben Hutchings <ben@decadent.org.uk>
    futex: Fix more put_pi_state() vs. exit_pi_state_list() races

Ben Hutchings <ben@decadent.org.uk>
    futex: Fix pi_state->owner serialization

Ben Hutchings <ben@decadent.org.uk>
    futex: Futex_unlock_pi() determinism

Ben Hutchings <ben@decadent.org.uk>
    futex: Pull rt_mutex_futex_unlock() out from under hb->lock

Ben Hutchings <ben@decadent.org.uk>
    futex: Cleanup refcounting

Ben Hutchings <ben@decadent.org.uk>
    futex: Cleanup variable names for futex_top_waiter()


-------------

Diffstat:

 Documentation/filesystems/sysfs.txt     |   8 +-
 Makefile                                |   4 +-
 arch/arm/probes/kprobes/core.c          |   6 +
 arch/arm/xen/p2m.c                      |  35 +++++-
 arch/arm64/include/asm/atomic_ll_sc.h   | 109 +++++++++---------
 arch/arm64/include/asm/atomic_lse.h     |  46 ++++----
 arch/arm64/include/asm/cmpxchg.h        | 116 ++++++++++----------
 arch/x86/kernel/module.c                |   1 +
 arch/x86/kernel/reboot.c                |   9 ++
 arch/x86/tools/relocs.c                 |  12 +-
 arch/x86/xen/p2m.c                      |  44 +++++++-
 drivers/block/zram/zram_drv.c           |   2 +-
 drivers/media/usb/uvc/uvc_driver.c      |   7 +-
 drivers/media/v4l2-core/v4l2-ioctl.c    |  19 ++--
 drivers/net/usb/qmi_wwan.c              |   1 +
 drivers/net/wireless/ath/ath10k/mac.c   |  15 +--
 drivers/net/wireless/ti/wl12xx/main.c   |   3 -
 drivers/net/wireless/ti/wlcore/main.c   |  15 +--
 drivers/net/wireless/ti/wlcore/wlcore.h |   3 -
 drivers/net/xen-netback/netback.c       |  12 +-
 drivers/scsi/libiscsi.c                 | 148 ++++++++++++-------------
 drivers/scsi/scsi_transport_iscsi.c     |  38 +++++--
 drivers/staging/fwserial/fwserial.c     |   2 +
 drivers/staging/most/aim-sound/sound.c  |   2 +
 drivers/tty/vt/consolemap.c             |   2 +-
 fs/jfs/jfs_filsys.h                     |   1 +
 fs/jfs/jfs_mount.c                      |  10 ++
 fs/sysfs/file.c                         |  55 ++++++++++
 fs/xfs/xfs_iops.c                       |   2 +-
 include/linux/sysfs.h                   |  16 +++
 include/linux/zsmalloc.h                |   2 +-
 kernel/futex.c                          | 188 ++++++++++++++++++++------------
 kernel/printk/nmi.c                     |  16 ++-
 mm/hugetlb.c                            |  28 +++--
 mm/page_io.c                            |  11 +-
 mm/swapfile.c                           |   2 +-
 mm/zsmalloc.c                           |  17 ++-
 net/bluetooth/amp.c                     |   3 +
 net/core/pktgen.c                       |   2 +-
 net/core/skbuff.c                       |  14 ++-
 scripts/Makefile                        |   9 +-
 security/smack/smackfs.c                |  21 +++-
 42 files changed, 669 insertions(+), 387 deletions(-)


