Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220E13C3BB2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhGKLLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhGKLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E75061206;
        Sun, 11 Jul 2021 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626001724;
        bh=nhy76+qIB2uc3jRQ6StL7ECRAA1TFFB+GmIO4rAWVVY=;
        h=From:To:Cc:Subject:Date:From;
        b=02yxixjUqD0D5Y70WGdsy0bYrr6BYaitNnjTHFtg+MfzZpwINGAeU6r/2BV2NSaSz
         yjCxgtodypl2op5kRFWp6+cLvNUGltmxT1apbx9mmunhgzzoZ0xOHUE4itlZtMlGQ2
         4mDPcivEyzewpn9UshIY8EZNBXscO8gRF7k8jS1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.239
Date:   Sun, 11 Jul 2021 13:08:39 +0200
Message-Id: <1626001718201109@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.239 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 
 drivers/gpu/drm/nouveau/nouveau_bo.c |    4 
 drivers/scsi/sr.c                    |    2 
 drivers/xen/events/events_base.c     |   23 ++++-
 include/linux/hugetlb.h              |   16 ---
 include/linux/kfifo.h                |    3 
 include/linux/mmdebug.h              |   21 +++-
 include/linux/pagemap.h              |   13 +-
 include/linux/rmap.h                 |    3 
 kernel/futex.c                       |    2 
 kernel/kthread.c                     |   77 +++++++++++-----
 mm/huge_memory.c                     |   26 +----
 mm/hugetlb.c                         |    5 -
 mm/internal.h                        |   53 ++++++++---
 mm/page_vma_mapped.c                 |  160 +++++++++++++++++++++--------------
 mm/rmap.c                            |   48 ++++++----
 16 files changed, 280 insertions(+), 178 deletions(-)

Alex Shi (1):
      mm: add VM_WARN_ON_ONCE_PAGE() macro

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Greg Kroah-Hartman (1):
      Linux 4.14.239

Hugh Dickins (13):
      mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
      mm/thp: fix vma_address() if virtual address below file offset
      mm: page_vma_mapped_walk(): use page for pvmw->page
      mm: page_vma_mapped_walk(): settle PageHuge on entry
      mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
      mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
      mm: page_vma_mapped_walk(): crossing page table boundary
      mm: page_vma_mapped_walk(): add a level of indentation
      mm: page_vma_mapped_walk(): use goto instead of while (1)
      mm: page_vma_mapped_walk(): get vma_address_end() earlier
      mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
      mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
      mm, futex: fix shared futex pgoff on shmem huge page

Jue Wang (1):
      mm/thp: fix page_address_in_vma() on file THP tails

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Miaohe Lin (2):
      mm/rmap: remove unneeded semicolon in page_not_mapped()
      mm/rmap: use page_not_mapped in try_to_unmap()

Michal Hocko (1):
      include/linux/mmdebug.h: make VM_WARN* non-rvals

Petr Mladek (2):
      kthread_worker: split code for canceling the delayed work timer
      kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Sean Young (1):
      kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit

Yang Shi (1):
      mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

