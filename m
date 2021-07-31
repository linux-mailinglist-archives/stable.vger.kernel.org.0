Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0F3DC44B
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhGaHIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232459AbhGaHIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 03:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220B46103B;
        Sat, 31 Jul 2021 07:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627715295;
        bh=wv/eai9RrVEbafLG44rRXHugG+ueYAwvErnE0c/6hNY=;
        h=From:To:Cc:Subject:Date:From;
        b=2BLGjv2OFd92j3vZr8AaUK/VrZYOgsXZE4lKCqJu5nx5W9xGAOuvjzvC6+eiUoywt
         Admjh5zzrxI7aKaT/HU0aN6buRuB4Nkc9A8WND4n9Qz/HkgPTsl0RdjEdpj5z0xR/L
         HY0g/SYQLv20eM11IdkW0nI6oEQ42MfjSYJ9K4QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.7
Date:   Sat, 31 Jul 2021 09:08:12 +0200
Message-Id: <16277152925037@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.7 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/arm/boot/dts/versatile-ab.dts      |    5 --
 arch/arm/boot/dts/versatile-pb.dts      |    2 
 drivers/firmware/arm_scmi/driver.c      |   12 +++--
 drivers/gpu/drm/ttm/ttm_range_manager.c |    3 +
 drivers/nvme/host/pci.c                 |   66 ++++++++++++++++++++++++++++----
 fs/cifs/smb2ops.c                       |    4 -
 fs/hfs/bfind.c                          |   14 ++++++
 fs/hfs/bnode.c                          |   25 +++++++++---
 fs/hfs/btree.h                          |    7 +++
 fs/hfs/super.c                          |   10 ++--
 fs/internal.h                           |    1 
 fs/iomap/seek.c                         |   25 ++++--------
 include/linux/fs_context.h              |    1 
 include/net/busy_poll.h                 |    2 
 include/net/sctp/constants.h            |    4 -
 kernel/cgroup/cgroup-v1.c               |    4 -
 kernel/rcu/tasks.h                      |    6 --
 kernel/workqueue.c                      |   20 ++++++---
 net/802/garp.c                          |   14 ++++++
 net/802/mrp.c                           |   14 ++++++
 net/core/sock.c                         |    2 
 net/ipv6/ip6_output.c                   |   28 +++++++++++++
 net/sctp/protocol.c                     |    3 -
 net/unix/af_unix.c                      |   51 +++++++++++++++++++++++-
 25 files changed, 255 insertions(+), 70 deletions(-)

Casey Chen (1):
      nvme-pci: fix multiple races in nvme_setup_io_queues

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
      Linux 5.13.7

Hyunchul Lee (1):
      cifs: fix the out of range assignment to bit fields in parse_server_interfaces

Miklos Szeredi (1):
      af_unix: fix garbage collect vs MSG_PEEK

Paul E. McKenney (2):
      rcu-tasks: Don't delete holdouts within trc_inspect_reader()
      rcu-tasks: Don't delete holdouts within trc_wait_for_one_reader()

Paul Gortmaker (1):
      cgroup1: fix leaked context root causing sporadic NULL deref in LTP

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

Zheyu Ma (1):
      drm/ttm: add a check against null pointer dereference

