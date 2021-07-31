Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AC3DC43D
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhGaHID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhGaHIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 03:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A0A86103B;
        Sat, 31 Jul 2021 07:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627715277;
        bh=9mpDDPQdhS+DaI2bj8l92WM7lmK5+lg/yY/eUsOMpQI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ao8GokU4i2pZEAT42TIZNjIhUYVvajYjOYOTSewg536tnGKF1YSFtdycjLOjIdAIP
         S5YecxlrsNeNToQOu+AcWgF+jiNdlMkAq0qkiNBrc2JQ0t3G1rFHKWFZ088jdMUXdg
         L69p0DGlh7DRBgVsW2e0c4BOLZ8/KPSISKKFW9es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.200
Date:   Sat, 31 Jul 2021 09:07:53 +0200
Message-Id: <162771527342248@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.200 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/boot/dts/versatile-ab.dts       |    5 -
 arch/arm/boot/dts/versatile-pb.dts       |    2 
 arch/x86/kvm/x86.c                       |   13 +-
 drivers/firmware/arm_scmi/driver.c       |   12 +-
 drivers/iio/dac/ds4424.c                 |    6 -
 fs/cifs/smb2ops.c                        |    4 
 fs/hfs/bfind.c                           |   14 ++
 fs/hfs/bnode.c                           |   25 ++++-
 fs/hfs/btree.h                           |    7 +
 fs/hfs/super.c                           |   10 +-
 include/net/af_unix.h                    |    1 
 include/net/busy_poll.h                  |    2 
 include/net/sctp/constants.h             |    4 
 kernel/workqueue.c                       |   20 ++--
 net/802/garp.c                           |   14 ++
 net/802/mrp.c                            |   14 ++
 net/Makefile                             |    2 
 net/core/sock.c                          |    2 
 net/sctp/protocol.c                      |    3 
 net/unix/Kconfig                         |    5 +
 net/unix/Makefile                        |    2 
 net/unix/af_unix.c                       |  102 +++++++++------------
 net/unix/garbage.c                       |   68 --------------
 net/unix/scm.c                           |  148 +++++++++++++++++++++++++++++++
 net/unix/scm.h                           |   10 ++
 tools/testing/selftests/vm/userfaultfd.c |    2 
 27 files changed, 328 insertions(+), 171 deletions(-)

Cristian Marussi (1):
      firmware: arm_scmi: Fix range check for the maximum number of pending messages

Desmond Cheong Zhi Xi (3):
      hfs: add missing clean-up in hfs_fill_super
      hfs: fix high memory mapping in hfs_bnode_read
      hfs: add lock nesting notation to hfs_find_init

Eric Dumazet (1):
      net: annotate data race around sk_ll_usec

Greg Kroah-Hartman (2):
      selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
      Linux 4.19.200

Hyunchul Lee (1):
      cifs: fix the out of range assignment to bit fields in parse_server_interfaces

Jens Axboe (1):
      net: split out functions related to registering inflight socket files

Maxim Levitsky (1):
      KVM: x86: determine if an exception has an error code only when injecting it.

Miklos Szeredi (1):
      af_unix: fix garbage collect vs MSG_PEEK

Ruslan Babayev (1):
      iio: dac: ds4422/ds4424 drop of_node check

Sudeep Holla (2):
      firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
      ARM: dts: versatile: Fix up interrupt controller node names

Xin Long (1):
      sctp: move 198 addresses from unusable to private scope

Yang Yingliang (3):
      workqueue: fix UAF in pwq_unbound_release_workfn()
      net/802/mrp: fix memleak in mrp_request_join()
      net/802/garp: fix memleak in garp_request_join()

