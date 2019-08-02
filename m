Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150C27F33C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406517AbfHBJzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406508AbfHBJzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35BD421726;
        Fri,  2 Aug 2019 09:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739717;
        bh=urSU2xPfyOztJhk9oiDwIpR3lc5OD4nRcbEDawmMOZY=;
        h=From:To:Cc:Subject:Date:From;
        b=ov5KuPqU6Ne9600Imp8E/iqbRYABViruKvSpvOMOJsD0DaKhgk/fiWaOSrw+WsuCK
         ENdPpThymiik3xycRA5rivuqMFCkctS/eP9goJ87g1REuiASao8/01ADuOqPw8xLgk
         9vqMX4mWkNIdHbJIkBsm51lI1Re5wYxi/Mg8nZDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/25] 4.14.136-stable review
Date:   Fri,  2 Aug 2019 11:39:32 +0200
Message-Id: <20190802092058.428079740@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.136-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.136-rc1
X-KernelTest-Deadline: 2019-08-04T09:21+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.136 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.136-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.136-rc1

Yan, Zheng <zyan@redhat.com>
    ceph: hold i_ceph_lock when removing caps for freeing inode

Yoshinori Sato <ysato@users.sourceforge.jp>
    Fix allyesconfig output.

Miroslav Lichvar <mlichvar@redhat.com>
    drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Jann Horn <jannh@google.com>
    sched/fair: Don't free p->numa_faults with concurrent readers

Vladis Dronov <vdronov@redhat.com>
    Bluetooth: hci_uart: check for missing tty operations

Sunil Muthuswamy <sunilmut@microsoft.com>
    hv_sock: Add support for delayed close

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

Abhishek Sahu <absahu@codeaurora.org>
    i2c: qup: fixed releasing dma without flush operation completion

allen yan <yanwei@marvell.com>
    arm64: dts: marvell: Fix A37xx UART0 register size

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix lookup revalidate of regular files

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Refactor nfs_lookup_revalidate()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix dentry revalidation on NFSv4 lookup

Sunil Muthuswamy <sunilmut@microsoft.com>
    vsock: correct removal of socket from the list

Stefan Hajnoczi <stefanha@redhat.com>
    VSOCK: use TCP state constants for sk_state


-------------

Diffstat:

 .../devicetree/bindings/serial/mvebu-uart.txt      |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/include/asm/compat.h                    |   1 +
 arch/sh/boards/Kconfig                             |  14 +-
 drivers/android/binder.c                           |  16 +-
 drivers/bluetooth/hci_ath.c                        |   3 +
 drivers/bluetooth/hci_bcm.c                        |   3 +
 drivers/bluetooth/hci_intel.c                      |   3 +
 drivers/bluetooth/hci_ldisc.c                      |  13 +
 drivers/bluetooth/hci_mrvl.c                       |   3 +
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/i2c/busses/i2c-qup.c                       |   2 +
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/iommu/iova.c                               |  18 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   3 +
 drivers/media/radio/radio-raremono.c               |  30 ++-
 drivers/media/usb/au0828/au0828-core.c             |  12 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |   2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   2 +-
 drivers/pps/pps.c                                  |   8 +
 fs/ceph/caps.c                                     |   7 +-
 fs/exec.c                                          |   2 +-
 fs/nfs/client.c                                    |   4 +-
 fs/nfs/dir.c                                       | 295 +++++++++++----------
 fs/nfs/nfs4proc.c                                  |  15 +-
 include/linux/iova.h                               |   6 +
 include/linux/sched/numa_balancing.h               |   4 +-
 include/net/af_vsock.h                             |   3 -
 kernel/fork.c                                      |   2 +-
 kernel/sched/fair.c                                |  24 +-
 net/vmw_vsock/af_vsock.c                           |  84 +++---
 net/vmw_vsock/hyperv_transport.c                   | 118 ++++++---
 net/vmw_vsock/virtio_transport.c                   |   2 +-
 net/vmw_vsock/virtio_transport_common.c            |  22 +-
 net/vmw_vsock/vmci_transport.c                     |  34 +--
 net/vmw_vsock/vmci_transport_notify.c              |   2 +-
 net/vmw_vsock/vmci_transport_notify_qstate.c       |   2 +-
 41 files changed, 472 insertions(+), 311 deletions(-)


