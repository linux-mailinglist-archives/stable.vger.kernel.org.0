Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE597F3A0
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406747AbfHBJ4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406739AbfHBJ4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AF22064A;
        Fri,  2 Aug 2019 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739795;
        bh=3/ftI1F64L7MU50EZ4JrnQm3j9tTyy3fmxX/xmaM7Ao=;
        h=From:To:Cc:Subject:Date:From;
        b=VCRKDxChSS7J9OjnbcfosKNt9AMRxcNTj8Z1fOBJ+vcgBb9F7IrsOnd4S19fZ/rKB
         2rLjWfk6WpJ+DQHrDSLVy+avnyLWiyIAlcCW1rVLaT4G7SxrDAb8Gi9mcOglNvK3FO
         gSCohE0JWLiJIwndc03xoH3Se6h2lNzdRMTUQlwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/32] 4.19.64-stable review
Date:   Fri,  2 Aug 2019 11:39:34 +0200
Message-Id: <20190802092101.913646560@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.64-rc1
X-KernelTest-Deadline: 2019-08-04T09:21+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.64 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.64-rc1

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Avoid that a kernel warning appears during system resume

Bart Van Assche <bvanassche@acm.org>
    block, scsi: Change the preempt-only flag into a counter

Yan, Zheng <zyan@redhat.com>
    ceph: hold i_ceph_lock when removing caps for freeing inode

Yoshinori Sato <ysato@users.sourceforge.jp>
    Fix allyesconfig output.

Miroslav Lichvar <mlichvar@redhat.com>
    drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Linus Torvalds <torvalds@linux-foundation.org>
    /proc/<pid>/cmdline: add back the setproctitle() special case

Linus Torvalds <torvalds@linux-foundation.org>
    /proc/<pid>/cmdline: remove all the special cases

Jann Horn <jannh@google.com>
    sched/fair: Use RCU accessors consistently for ->numa_group

Jann Horn <jannh@google.com>
    sched/fair: Don't free p->numa_faults with concurrent readers

Jason Wang <jasowang@redhat.com>
    vhost: scsi: add weight support

Jason Wang <jasowang@redhat.com>
    vhost: vsock: add weight support

Jason Wang <jasowang@redhat.com>
    vhost_net: fix possible infinite loop

Jason Wang <jasowang@redhat.com>
    vhost: introduce vhost_exceeds_weight()

Vladis Dronov <vdronov@redhat.com>
    Bluetooth: hci_uart: check for missing tty operations

Joerg Roedel <jroedel@suse.de>
    iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA

Dmitry Safonov <dima@arista.com>
    iommu/vt-d: Don't queue_iova() if there is no flush queue

Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
    media: radio-raremono: change devm_k*alloc to k*alloc

Benjamin Coddington <bcodding@redhat.com>
    NFS: Cleanup if nfs_match_client is interrupted

Andrey Konovalov <andreyknvl@google.com>
    media: pvrusb2: use a different format for warnings

Oliver Neukum <oneukum@suse.com>
    media: cpia2_usb: first wake up, then free in disconnect

Fabio Estevam <festevam@gmail.com>
    ath10k: Change the warning message string

Sean Young <sean@mess.org>
    media: au0828: fix null dereference in error path

Phong Tran <tranmanphong@gmail.com>
    ISDN: hfcsusb: checking idx of ep configuration

Todd Kjos <tkjos@android.com>
    binder: fix possible UAF when freeing buffer

Will Deacon <will.deacon@arm.com>
    arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ

Minas Harutyunyan <minas.harutyunyan@synopsys.com>
    usb: dwc2: Fix disable all EP's on disconnect

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Disable all EP's on disconnect

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix lookup revalidate of regular files

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Refactor nfs_lookup_revalidate()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix dentry revalidation on NFSv4 lookup

Sunil Muthuswamy <sunilmut@microsoft.com>
    vsock: correct removal of socket from the list

Sunil Muthuswamy <sunilmut@microsoft.com>
    hv_sock: Add support for delayed close


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm64/include/asm/compat.h              |   1 +
 arch/sh/boards/Kconfig                       |  14 +-
 block/blk-core.c                             |  35 ++--
 block/blk-mq-debugfs.c                       |  10 +-
 drivers/android/binder.c                     |  16 +-
 drivers/bluetooth/hci_ath.c                  |   3 +
 drivers/bluetooth/hci_bcm.c                  |   3 +
 drivers/bluetooth/hci_intel.c                |   3 +
 drivers/bluetooth/hci_ldisc.c                |  13 ++
 drivers/bluetooth/hci_mrvl.c                 |   3 +
 drivers/bluetooth/hci_qca.c                  |   3 +
 drivers/bluetooth/hci_uart.h                 |   1 +
 drivers/iommu/intel-iommu.c                  |   2 +-
 drivers/iommu/iova.c                         |  18 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c        |   3 +
 drivers/media/radio/radio-raremono.c         |  30 ++-
 drivers/media/usb/au0828/au0828-core.c       |  12 +-
 drivers/media/usb/cpia2/cpia2_usb.c          |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-std.c      |   2 +-
 drivers/net/wireless/ath/ath10k/usb.c        |   2 +-
 drivers/pps/pps.c                            |   8 +
 drivers/scsi/scsi_lib.c                      |  15 +-
 drivers/usb/dwc2/gadget.c                    |  41 +++-
 drivers/vhost/net.c                          |  41 ++--
 drivers/vhost/scsi.c                         |  15 +-
 drivers/vhost/vhost.c                        |  20 +-
 drivers/vhost/vhost.h                        |   5 +-
 drivers/vhost/vsock.c                        |  28 ++-
 fs/ceph/caps.c                               |   7 +-
 fs/exec.c                                    |   2 +-
 fs/nfs/client.c                              |   4 +-
 fs/nfs/dir.c                                 | 295 +++++++++++++++------------
 fs/nfs/nfs4proc.c                            |  15 +-
 fs/proc/base.c                               | 132 ++++++------
 include/linux/blkdev.h                       |  14 +-
 include/linux/iova.h                         |   6 +
 include/linux/sched.h                        |  10 +-
 include/linux/sched/numa_balancing.h         |   4 +-
 kernel/fork.c                                |   2 +-
 kernel/sched/fair.c                          | 144 +++++++++----
 net/vmw_vsock/af_vsock.c                     |  38 +---
 net/vmw_vsock/hyperv_transport.c             | 108 +++++++---
 45 files changed, 719 insertions(+), 426 deletions(-)


