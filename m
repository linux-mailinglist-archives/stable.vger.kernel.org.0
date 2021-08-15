Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A6D3EC8CA
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhHOLl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238364AbhHOLlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48F061042;
        Sun, 15 Aug 2021 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027638;
        bh=BpAfCnU5Y1QYitnGKrrFeMElz/khL2UmQ44gqxgyCUw=;
        h=From:To:Cc:Subject:Date:From;
        b=1G06wpptVwIpneQDwZYcYHf/oJDp4K/S9F5lgLSUPnoT2EV1gC7X9azGO2bxcjhfI
         hn+qD03ZIijYo9opO6EtqiDK7/8ifwfiEYFazwYV0bmJ6SsxF1RdfuAAQ1rLY2Hi5m
         8b7nIC5pv3fBaKU77ORHky1eENTQ3QiFue3hP8Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.141
Date:   Sun, 15 Aug 2021 13:40:32 +0200
Message-Id: <162902763226212@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.141 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/mmu.txt                |    4 
 Makefile                                      |    2 
 arch/x86/kvm/paging_tmpl.h                    |   14 -
 arch/x86/kvm/svm.c                            |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c        |    6 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    5 
 drivers/net/ppp/ppp_generic.c                 |   19 +
 drivers/tee/optee/call.c                      |    2 
 drivers/tee/optee/core.c                      |    3 
 drivers/tee/optee/rpc.c                       |    5 
 drivers/tee/optee/shm_pool.c                  |    8 
 drivers/tee/tee_shm.c                         |    4 
 drivers/usb/dwc3/ep0.c                        |    2 
 drivers/usb/dwc3/gadget.c                     |  118 +++++++--
 drivers/usb/host/ehci-pci.c                   |    3 
 fs/btrfs/ctree.h                              |   13 -
 fs/btrfs/delalloc-space.c                     |    2 
 fs/btrfs/delayed-inode.c                      |    3 
 fs/btrfs/disk-io.c                            |    4 
 fs/btrfs/file.c                               |    7 
 fs/btrfs/inode.c                              |    2 
 fs/btrfs/qgroup.c                             |  328 +++++++++++++++++++-------
 fs/btrfs/qgroup.h                             |    5 
 fs/btrfs/transaction.c                        |   16 -
 fs/btrfs/transaction.h                        |   15 -
 fs/namespace.c                                |   42 ++-
 include/linux/tee_drv.h                       |    1 
 kernel/trace/trace_events_hist.c              |   20 +
 sound/pci/hda/patch_realtek.c                 |    1 
 29 files changed, 467 insertions(+), 189 deletions(-)

Alexandre Courbot (1):
      media: v4l2-mem2mem: always consider OUTPUT queue during poll

Filipe Manana (1):
      btrfs: fix lockdep splat when enabling and disabling qgroups

Greg Kroah-Hartman (1):
      Linux 5.4.141

Lai Jiangshan (1):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Longfang Liu (1):
      USB:ehci:fix Kunpeng920 ehci hardware problem

Luke D Jones (1):
      ALSA: hda: Add quirk for ASUS Flow x13

Masami Hiramatsu (1):
      tracing: Reject string operand in the histogram expression

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Nikolay Borisov (4):
      btrfs: make qgroup_free_reserved_data take btrfs_inode
      btrfs: make btrfs_qgroup_reserve_data take btrfs_inode
      btrfs: export and rename qgroup_reserve_meta
      btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Qu Wenruo (5):
      btrfs: qgroup: allow to unreserve range without releasing other ranges
      btrfs: qgroup: try to flush qgroup space when we get -EDQUOT
      btrfs: transaction: Cleanup unused TRANS_STATE_BLOCKED
      btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve retry-after-EDQUOT
      btrfs: qgroup: don't commit transaction when we already hold the handle

Sean Christopherson (1):
      KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB

Sumit Garg (1):
      tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Wesley Cheng (7):
      usb: dwc3: Stop active transfers before halting the controller
      usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
      usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
      usb: dwc3: gadget: Prevent EP queuing while stopping transfers
      usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
      usb: dwc3: gadget: Disable gadget IRQ during pullup disable
      usb: dwc3: gadget: Avoid runtime resume if disabling pullup

YueHaibing (1):
      net: xilinx_emaclite: Do not print real IOMEM pointer

