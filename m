Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEAA3443E2
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCVMzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhCVMxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20ACD61A06;
        Mon, 22 Mar 2021 12:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417227;
        bh=3vDgv3g8Fvg5mZhkqd5Y2kqvpjEg1fX/ijoXtkA5/bg=;
        h=From:To:Cc:Subject:Date:From;
        b=BS/X/ICA5lYvZlH4i4Z2n3JyDfy6HleE1c6BQvl4dd5Th2ia0xH8mM2gq1d+sGu18
         Vbd/vskCz8rxtAdSq/W5I7l1BV7B1nrlC3Tld9u08lE7F4xtWVCrW1eTgolKrrrrmd
         RCBFdrjcz86FemqbMYmSnDuV4vK/2H1/jSVcao2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/25] 4.9.263-rc1 review
Date:   Mon, 22 Mar 2021 13:28:50 +0100
Message-Id: <20210322121920.399826335@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.263-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.263-rc1
X-KernelTest-Deadline: 2021-03-24T12:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.263 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.263-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.263-rc1

Thomas Gleixner <tglx@linutronix.de>
    genirq: Disable interrupts for force threaded handlers

Shijie Luo <luoshijie1@huawei.com>
    ext4: fix potential error in ext4_do_update_inode

zhangyi (F) <yi.zhang@huawei.com>
    ext4: find old entry again if failed to rename whiteout

Oleg Nesterov <oleg@redhat.com>
    x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Oleg Nesterov <oleg@redhat.com>
    x86: Move TS_COMPAT back to asm/thread_info.h

Oleg Nesterov <oleg@redhat.com>
    kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Ignore IRQ2 again

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix a crash caused by zero PEBS status

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpadlpar: Fix potential drc_name corruption in store functions

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adis16400: Fix an error code in adis16400_initial_setup()

Jim Lin <jilin@nvidia.com>
    usb: gadget: configfs: Fix KASAN use-after-free

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: replace hardcode maximum usb string length by definition

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix some error codes in debugfs

Pavel Skripkin <paskripkin@gmail.com>
    net/qrtr: fix __netdev_alloc_skb call

Daniel Kobras <kobras@puzzle-itc.de>
    sunrpc: fix refcount leak for rpc auth modules

Timo Rothenpieler <timo@rothenpieler.org>
    svcrdma: disable timeouts on rdma backchannel

Joe Korty <joe.korty@concurrent-rt.com>
    NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Sagi Grimberg <sagi@grimberg.me>
    nvmet: don't check iosqes,iocqes for discovery controllers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when cloning extent buffer during rewind of an old root

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: prevent ptp_rx_hang from running when in FILTER_ALL mode

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: check for Tx timestamp timeouts during watchdog

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Support setting learning on port

Jan Kara <jack@suse.cz>
    ext4: check journal inode extents more carefully

Jan Kara <jack@suse.cz>
    ext4: don't allow overlapping system zones

Jan Kara <jack@suse.cz>
    ext4: handle error of ext4_setup_system_zone() on remount


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/x86/events/intel/ds.c                    |  2 +-
 arch/x86/include/asm/processor.h              |  9 ----
 arch/x86/include/asm/thread_info.h            | 23 ++++++++-
 arch/x86/kernel/apic/io_apic.c                | 10 ++++
 arch/x86/kernel/signal.c                      | 24 +--------
 drivers/iio/imu/adis16400_core.c              |  3 +-
 drivers/net/dsa/b53/b53_common.c              | 20 ++++++++
 drivers/net/dsa/b53/b53_regs.h                |  1 +
 drivers/net/dsa/bcm_sf2.c                     |  5 ++
 drivers/net/dsa/bcm_sf2_regs.h                |  2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 27 ++++++++++
 drivers/nvme/target/core.c                    | 17 +++++--
 drivers/pci/hotplug/rpadlpar_sysfs.c          | 14 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c              |  4 +-
 drivers/usb/gadget/composite.c                |  4 +-
 drivers/usb/gadget/configfs.c                 | 16 ++++--
 drivers/usb/gadget/usbstring.c                |  4 +-
 fs/btrfs/ctree.c                              |  2 +
 fs/ext4/block_validity.c                      | 71 +++++++++++++--------------
 fs/ext4/ext4.h                                |  6 +--
 fs/ext4/extents.c                             | 16 +++---
 fs/ext4/indirect.c                            |  6 +--
 fs/ext4/inode.c                               | 13 +++--
 fs/ext4/mballoc.c                             |  4 +-
 fs/ext4/namei.c                               | 29 ++++++++++-
 fs/ext4/super.c                               |  5 +-
 fs/select.c                                   | 10 ++--
 include/linux/thread_info.h                   | 13 +++++
 include/uapi/linux/usb/ch9.h                  |  3 ++
 kernel/futex.c                                |  3 +-
 kernel/irq/manage.c                           |  4 ++
 kernel/time/alarmtimer.c                      |  2 +-
 kernel/time/hrtimer.c                         |  2 +-
 kernel/time/posix-cpu-timers.c                |  2 +-
 net/qrtr/qrtr.c                               |  2 +-
 net/sunrpc/svc.c                              |  6 ++-
 net/sunrpc/svc_xprt.c                         |  4 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c    |  6 +--
 41 files changed, 256 insertions(+), 147 deletions(-)


