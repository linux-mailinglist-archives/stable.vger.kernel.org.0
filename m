Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CAD3443C1
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhCVMxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231582AbhCVMvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B545961A02;
        Mon, 22 Mar 2021 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417187;
        bh=tz2b2WYOM9Z4kb5YCilU09n3DbCCl66/iOOZH0ChIOQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Aj4gDDqvlbj0Ndp0nPWze0yPvzWKptk9rVKDzXn5/m3S8NK6f+kkUHONKWtyLD6cD
         WZW5cz526G+J1N3/4YtLfFGH3wkfFmUPl4iWL3wKwQPGqdYJJnv01NlszSNtlrFXAA
         aPoHVu9WTcjSCJNdGcNTLdul4YqGSEYX7AYqD8xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/14] 4.4.263-rc1 review
Date:   Mon, 22 Mar 2021 13:28:54 +0100
Message-Id: <20210322121919.202392464@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.263-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.263-rc1
X-KernelTest-Deadline: 2021-03-24T12:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.263 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.263-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.263-rc1

Thomas Gleixner <tglx@linutronix.de>
    genirq: Disable interrupts for force threaded handlers

Shijie Luo <luoshijie1@huawei.com>
    ext4: fix potential error in ext4_do_update_inode

zhangyi (F) <yi.zhang@huawei.com>
    ext4: find old entry again if failed to rename whiteout

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Ignore IRQ2 again

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpadlpar: Fix potential drc_name corruption in store functions

Jim Lin <jilin@nvidia.com>
    usb: gadget: configfs: Fix KASAN use-after-free

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: replace hardcode maximum usb string length by definition

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix some error codes in debugfs

Joe Korty <joe.korty@concurrent-rt.com>
    NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when cloning extent buffer during rewind of an old root

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_dev - Fix security issue

Jan Kara <jack@suse.cz>
    ext4: check journal inode extents more carefully

Jan Kara <jack@suse.cz>
    ext4: don't allow overlapping system zones

Jan Kara <jack@suse.cz>
    ext4: handle error of ext4_setup_system_zone() on remount


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/x86/kernel/apic/io_apic.c          | 10 +++++
 drivers/pci/hotplug/rpadlpar_sysfs.c    | 14 +++----
 drivers/platform/chrome/cros_ec_dev.c   |  4 ++
 drivers/platform/chrome/cros_ec_proto.c |  4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c        |  4 +-
 drivers/usb/gadget/composite.c          |  4 +-
 drivers/usb/gadget/configfs.c           | 16 +++++---
 drivers/usb/gadget/usbstring.c          |  4 +-
 fs/btrfs/ctree.c                        |  2 +
 fs/ext4/block_validity.c                | 71 +++++++++++++++------------------
 fs/ext4/ext4.h                          |  6 +--
 fs/ext4/extents.c                       | 16 +++-----
 fs/ext4/indirect.c                      |  6 +--
 fs/ext4/inode.c                         | 13 +++---
 fs/ext4/mballoc.c                       |  4 +-
 fs/ext4/namei.c                         | 29 +++++++++++++-
 fs/ext4/super.c                         |  5 ++-
 include/linux/mfd/cros_ec.h             |  6 ++-
 include/uapi/linux/usb/ch9.h            |  3 ++
 kernel/irq/manage.c                     |  4 ++
 net/sunrpc/svc_xprt.c                   |  4 +-
 22 files changed, 139 insertions(+), 94 deletions(-)


