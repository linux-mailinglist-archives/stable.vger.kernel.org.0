Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092ED3C3BAE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhGKLLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhGKLLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Jul 2021 07:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D793611CB;
        Sun, 11 Jul 2021 11:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626001716;
        bh=st6HhwgwdP5QJVXB+o5Wg+ulbLX2voOe4vBQ1v6w2c8=;
        h=From:To:Cc:Subject:Date:From;
        b=Xf4darpmnXByb+ZE7du1cW3tq+9YNNMtM6ffzTTeIMjgbE7NuYctIHD4DnxfZUjMW
         Eq0nburQUMye5VKd1wbeiMD67Tcb4uziK17qe/AvBBYoFeyyp0Kves3g6Q52ahoviL
         bPYFMXgxKaDxFxLczgQY6wmGaGJKvsmjy1IDmHPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.275
Date:   Sun, 11 Jul 2021 13:08:31 +0200
Message-Id: <162600171022946@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.275 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 
 drivers/gpu/drm/nouveau/nouveau_bo.c |    4 -
 drivers/scsi/sr.c                    |    2 
 drivers/xen/events/events_base.c     |   23 ++++++++--
 include/linux/hugetlb.h              |   15 ------
 include/linux/mmdebug.h              |   21 +++++++--
 include/linux/pagemap.h              |   13 +++--
 kernel/futex.c                       |    2 
 kernel/kthread.c                     |   77 +++++++++++++++++++++++------------
 mm/huge_memory.c                     |   29 ++++---------
 mm/hugetlb.c                         |    5 --
 11 files changed, 111 insertions(+), 82 deletions(-)

Alex Shi (1):
      mm: add VM_WARN_ON_ONCE_PAGE() macro

Christian König (1):
      drm/nouveau: fix dma_address check for CPU/GPU sync

Greg Kroah-Hartman (1):
      Linux 4.9.275

Hugh Dickins (1):
      mm, futex: fix shared futex pgoff on shmem huge page

Juergen Gross (1):
      xen/events: reset active flag for lateeoi events later

ManYi Li (1):
      scsi: sr: Return appropriate error code when disk is ejected

Michal Hocko (1):
      include/linux/mmdebug.h: make VM_WARN* non-rvals

Petr Mladek (2):
      kthread_worker: split code for canceling the delayed work timer
      kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync()

Yang Shi (1):
      mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

