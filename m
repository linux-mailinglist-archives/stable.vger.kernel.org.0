Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317CD3EB8BE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbhHMPQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242647AbhHMPOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D66561102;
        Fri, 13 Aug 2021 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867644;
        bh=WpY040hsuDtK6MrqsoUzrYRXjD1pjWGRPreiBJVajSE=;
        h=From:To:Cc:Subject:Date:From;
        b=n8Wk5Un3U9/qP7wbbs2z9rMwzmwO5X5vpKYm/3x7V94/vePUR1aWV6dthvAVtTvxm
         cBcLcC17eSUhDhIo2D6lDuED57RViotXSlKWHRLoA5mBKuVqOXlmzJHdz38dyfkuho
         jCChls8dzhHT98uag0qlxOD6CZ/NaUgrWH9ek5h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/27] 5.4.141-rc1 review
Date:   Fri, 13 Aug 2021 17:06:58 +0200
Message-Id: <20210813150523.364549385@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.141-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.141-rc1
X-KernelTest-Deadline: 2021-08-15T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.141 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.141-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.141-rc1

Nikolay Borisov <nborisov@suse.com>
    btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Nikolay Borisov <nborisov@suse.com>
    btrfs: export and rename qgroup_reserve_meta

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: don't commit transaction when we already hold the handle

YueHaibing <yuehaibing@huawei.com>
    net: xilinx_emaclite: Do not print real IOMEM pointer

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when enabling and disabling qgroups

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve retry-after-EDQUOT

Qu Wenruo <wqu@suse.com>
    btrfs: transaction: Cleanup unused TRANS_STATE_BLOCKED

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: try to flush qgroup space when we get -EDQUOT

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: allow to unreserve range without releasing other ranges

Nikolay Borisov <nborisov@suse.com>
    btrfs: make btrfs_qgroup_reserve_data take btrfs_inode

Nikolay Borisov <nborisov@suse.com>
    btrfs: make qgroup_free_reserved_data take btrfs_inode

Miklos Szeredi <mszeredi@redhat.com>
    ovl: prevent private clone if bind mount is not allowed

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ppp unit id when ifname is not specified

Luke D Jones <luke@ljones.dev>
    ALSA: hda: Add quirk for ASUS Flow x13

Longfang Liu <liulongfang@huawei.com>
    USB:ehci:fix Kunpeng920 ehci hardware problem

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Avoid runtime resume if disabling pullup

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Disable gadget IRQ during pullup disable

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Prevent EP queuing while stopping transfers

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Allow runtime suspend if UDC unbinded

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: Stop active transfers before halting the controller

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Reject string operand in the histogram expression

Alexandre Courbot <gnurou@gmail.com>
    media: v4l2-mem2mem: always consider OUTPUT queue during poll

Sumit Garg <sumit.garg@linaro.org>
    tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB


-------------

Diffstat:

 Documentation/virt/kvm/mmu.txt                |   4 +-
 Makefile                                      |   4 +-
 arch/x86/kvm/paging_tmpl.h                    |  14 +-
 arch/x86/kvm/svm.c                            |   2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |   6 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   5 +-
 drivers/net/ppp/ppp_generic.c                 |  19 +-
 drivers/tee/optee/call.c                      |   2 +-
 drivers/tee/optee/core.c                      |   3 +-
 drivers/tee/optee/rpc.c                       |   5 +-
 drivers/tee/optee/shm_pool.c                  |   8 +-
 drivers/tee/tee_shm.c                         |   4 +-
 drivers/usb/dwc3/ep0.c                        |   2 +-
 drivers/usb/dwc3/gadget.c                     | 118 +++++++--
 drivers/usb/host/ehci-pci.c                   |   3 +
 fs/btrfs/ctree.h                              |  13 +-
 fs/btrfs/delalloc-space.c                     |   2 +-
 fs/btrfs/delayed-inode.c                      |   3 +-
 fs/btrfs/disk-io.c                            |   4 +-
 fs/btrfs/file.c                               |   7 +-
 fs/btrfs/inode.c                              |   2 +-
 fs/btrfs/qgroup.c                             | 328 +++++++++++++++++++-------
 fs/btrfs/qgroup.h                             |   5 +-
 fs/btrfs/transaction.c                        |  16 +-
 fs/btrfs/transaction.h                        |  15 --
 fs/namespace.c                                |  42 ++--
 include/linux/tee_drv.h                       |   1 +
 kernel/trace/trace_events_hist.c              |  20 +-
 sound/pci/hda/patch_realtek.c                 |   1 +
 29 files changed, 468 insertions(+), 190 deletions(-)


