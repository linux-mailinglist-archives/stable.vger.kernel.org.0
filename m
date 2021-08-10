Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA573E7D34
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhHJQLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 12:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhHJQLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 12:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 384EF610CC;
        Tue, 10 Aug 2021 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628611882;
        bh=jAyO1V9QJmGiJlPj5quiq12mSL1nH51cFhN8vuVvmIs=;
        h=From:To:Cc:Subject:Date:From;
        b=dXkJJKnNxYaXnIYrCGrpyQBn+xitFtr2vdyqhztHQhmZ7vOl/ZGWekiqMc4NS2/Ll
         nMhzIWuSe+JpWcsdGof9LWMIX468PK9+I+gPhaE62lphGWx0ZuEIlSISlpRAgy21L0
         VzRpx5H4TW+oMT87LCNMvXCzg4kRZNrlqSvOzpqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.280
Date:   Tue, 10 Aug 2021 18:11:19 +0200
Message-Id: <1628611879145216@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.280 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 
 include/linux/rcupdate.h        |    4 
 kernel/futex.c                  |  245 ++++++++++++++++++++++++++--------------
 kernel/locking/rtmutex.c        |  185 ++++++++++++++++--------------
 kernel/locking/rtmutex_common.h |    2 
 5 files changed, 263 insertions(+), 175 deletions(-)

Anna-Maria Gleixner (1):
      rcu: Update documentation of rcu_read_unlock()

Greg Kroah-Hartman (1):
      Linux 4.4.280

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Peter Zijlstra (6):
      futex: Cleanup refcounting
      futex,rt_mutex: Introduce rt_mutex_init_waiter()
      futex: Pull rt_mutex_futex_unlock() out from under hb->lock
      futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
      futex: Futex_unlock_pi() determinism
      futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()

Thomas Gleixner (3):
      futex: Rename free_pi_state() to put_pi_state()
      rtmutex: Make wait_lock irq safe
      futex: Avoid freeing an active timer

