Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1903DC444
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhGaHIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhGaHIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 03:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00A36103B;
        Sat, 31 Jul 2021 07:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627715290;
        bh=QMGz+rNi+H6J+WdnUWiPf1MDaCnjolX02ne26pxo3dA=;
        h=From:To:Cc:Subject:Date:From;
        b=WBLXHbkiau26zwRpKIIWCrk8TpfOSipQ+D61jc2zX0jpMm6rRHeA1RC/r7utGYqYA
         4haM8NvwAi8zuot5TIOXgFrmWrbFvq6WHxj5yuj/7uCeINullmLN/D6gTbVc3lko46
         GByMVloAJA+QtwT3/BUfy7Sil6uPZkgRm4JfXrHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.55
Date:   Sat, 31 Jul 2021 09:08:04 +0200
Message-Id: <16277152851011@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.55 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 -
 arch/arm/boot/dts/versatile-ab.dts      |    5 +--
 arch/arm/boot/dts/versatile-pb.dts      |    2 -
 arch/x86/kvm/x86.c                      |   13 +++++---
 drivers/firmware/arm_scmi/driver.c      |   12 ++++---
 drivers/gpu/drm/ttm/ttm_range_manager.c |    3 +
 fs/cifs/smb2ops.c                       |    4 +-
 fs/hfs/bfind.c                          |   14 ++++++++
 fs/hfs/bnode.c                          |   25 ++++++++++++---
 fs/hfs/btree.h                          |    7 ++++
 fs/hfs/super.c                          |   10 +++---
 fs/internal.h                           |    1 
 fs/io_uring.c                           |    1 
 fs/iomap/seek.c                         |   25 +++++----------
 include/linux/fs_context.h              |    1 
 include/net/busy_poll.h                 |    2 -
 include/net/sctp/constants.h            |    4 --
 kernel/cgroup/cgroup-v1.c               |    4 --
 kernel/rcu/tasks.h                      |    6 +--
 kernel/workqueue.c                      |   20 ++++++++----
 net/802/garp.c                          |   14 ++++++++
 net/802/mrp.c                           |   14 ++++++++
 net/core/sock.c                         |    2 -
 net/ipv6/ip6_output.c                   |   28 +++++++++++++++++
 net/sctp/protocol.c                     |    3 +
 net/unix/af_unix.c                      |   51 ++++++++++++++++++++++++++++++--
 tools/scripts/Makefile.include          |   12 ++++++-
 27 files changed, 216 insertions(+), 69 deletions(-)

Christoph Hellwig (2):
      iomap: remove the length variable in iomap_seek_data
      iomap: remove the length variable in iomap_seek_hole

Cristian Marussi (1):
      firmware: arm_scmi: Fix range check for the maximum number of pending messages

Desmond Cheong Zhi Xi (3):
      hfs: add missing clean-up in hfs_fill_super
      hfs: fix high memory mapping in hfs_bnode_read
      hfs: add lock nesting notation to hfs_find_init

Eric Dumazet (1):
      net: annotate data race around sk_ll_usec

Greg Kroah-Hartman (1):
      Linux 5.10.55

Hyunchul Lee (1):
      cifs: fix the out of range assignment to bit fields in parse_server_interfaces

Maxim Levitsky (1):
      KVM: x86: determine if an exception has an error code only when injecting it.

Miklos Szeredi (1):
      af_unix: fix garbage collect vs MSG_PEEK

Paul E. McKenney (2):
      rcu-tasks: Don't delete holdouts within trc_inspect_reader()
      rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()

Paul Gortmaker (1):
      cgroup1: fix leaked context root causing sporadic NULL deref in LTP

Pavel Begunkov (1):
      io_uring: fix link timeout refs

Sudeep Holla (2):
      firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
      ARM: dts: versatile: Fix up interrupt controller node names

Vasily Averin (2):
      ipv6: allocate enough headroom in ip6_finish_output2()
      ipv6: ip6_finish_output2: set sk into newly allocated nskb

Xin Long (1):
      sctp: move 198 addresses from unusable to private scope

Yang Yingliang (3):
      workqueue: fix UAF in pwq_unbound_release_workfn()
      net/802/mrp: fix memleak in mrp_request_join()
      net/802/garp: fix memleak in garp_request_join()

Yonghong Song (1):
      tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include

Zheyu Ma (1):
      drm/ttm: add a check against null pointer dereference

