Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D093E0109
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 14:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhHDMYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 08:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhHDMYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 08:24:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2747460F22;
        Wed,  4 Aug 2021 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628079832;
        bh=4ylRegfHRw69soIf1hEiZSOw0NhH/r/QM37Gu6tZzvk=;
        h=From:To:Cc:Subject:Date:From;
        b=020tCh9PnFhp6IKwLjw0ahVmzwP9lxHbmyQ8SSBBzJfqJQLWavjGyvBbvXdbUvHHQ
         Zeq0RxhugHF/0RQnBiaF5UcenwFk7mQUy+/r8asHUb1S49Ht3fSYOxXBYPPtyOdlkU
         2sQ4M2eKnapNDjDXd9RNHSc6rnAlbT2pL9wiwtAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.242
Date:   Wed,  4 Aug 2021 14:23:45 +0200
Message-Id: <162807982692255@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.242 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/boot/dts/versatile-ab.dts                |    5 
 arch/arm/boot/dts/versatile-pb.dts                |    2 
 arch/x86/include/asm/proto.h                      |    2 
 arch/x86/kvm/ioapic.c                             |    2 
 arch/x86/kvm/ioapic.h                             |    4 
 arch/x86/kvm/x86.c                                |   13 +
 drivers/net/can/spi/hi311x.c                      |    2 
 drivers/net/can/usb/ems_usb.c                     |   14 +-
 drivers/net/can/usb/esd_usb2.c                    |   16 ++
 drivers/net/can/usb/mcba_usb.c                    |    2 
 drivers/net/can/usb/usb_8dev.c                    |   15 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |    7 -
 drivers/net/ethernet/mellanox/mlx4/main.c         |    1 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   10 -
 drivers/net/ethernet/sis/sis900.c                 |    7 -
 drivers/net/ethernet/sun/niu.c                    |    3 
 drivers/net/virtio_net.c                          |   10 +
 drivers/nfc/nfcsim.c                              |    3 
 fs/hfs/bfind.c                                    |   14 +-
 fs/hfs/bnode.c                                    |   25 ++-
 fs/hfs/btree.h                                    |    7 +
 fs/hfs/super.c                                    |   10 -
 fs/ocfs2/file.c                                   |  103 +++++++++------
 include/linux/skbuff.h                            |    9 +
 include/linux/virtio_net.h                        |   14 +-
 include/net/af_unix.h                             |    1 
 include/net/busy_poll.h                           |    2 
 include/net/llc_pdu.h                             |   31 +++-
 include/net/sctp/constants.h                      |    4 
 kernel/workqueue.c                                |   20 +-
 net/802/garp.c                                    |   14 ++
 net/802/mrp.c                                     |   14 ++
 net/Makefile                                      |    2 
 net/can/raw.c                                     |   20 ++
 net/core/dev.c                                    |    3 
 net/core/sock.c                                   |    2 
 net/llc/af_llc.c                                  |   10 +
 net/llc/llc_s_ac.c                                |    2 
 net/netfilter/nf_conntrack_core.c                 |    7 -
 net/netfilter/nft_nat.c                           |    4 
 net/sctp/input.c                                  |    2 
 net/sctp/protocol.c                               |    3 
 net/tipc/socket.c                                 |    9 -
 net/unix/Kconfig                                  |    5 
 net/unix/Makefile                                 |    2 
 net/unix/af_unix.c                                |  102 ++++++---------
 net/unix/garbage.c                                |   68 ----------
 net/unix/scm.c                                    |  149 ++++++++++++++++++++++
 net/unix/scm.h                                    |   10 +
 net/wireless/scan.c                               |    6 
 tools/perf/util/map.c                             |    2 
 tools/testing/selftests/vm/userfaultfd.c          |    2 
 53 files changed, 539 insertions(+), 259 deletions(-)

Arnaldo Carvalho de Melo (1):
      Revert "perf map: Fix dso->nsinfo refcounting"

Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Desmond Cheong Zhi Xi (3):
      hfs: add missing clean-up in hfs_fill_super
      hfs: fix high memory mapping in hfs_bnode_read
      hfs: add lock nesting notation to hfs_find_init

Eric Dumazet (3):
      net: annotate data race around sk_ll_usec
      virtio_net: Do not pull payload in skb->head
      gro: ensure frag0 meets IP header alignment

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Greg Kroah-Hartman (2):
      selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
      Linux 4.14.242

Hoang Le (1):
      tipc: fix sleeping in tipc accept routine

Jan Kiszka (1):
      x86/asm: Ensure asm/proto.h can be included stand-alone

Jens Axboe (1):
      net: split out functions related to registering inflight socket files

Jiapeng Chong (1):
      mlx4: Fix missing error code in mlx4_load_one()

Juergen Gross (1):
      x86/kvm: fix vcpu-id indexed array sizes

Junxiao Bi (2):
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Krzysztof Kozlowski (1):
      nfc: nfcsim: fix use after free during module unload

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Marcelo Ricardo Leitner (1):
      sctp: fix return value check in __sctp_rcv_asconf_lookup

Maxim Levitsky (1):
      KVM: x86: determine if an exception has an error code only when injecting it.

Miklos Szeredi (1):
      af_unix: fix garbage collect vs MSG_PEEK

Nguyen Dinh Phi (1):
      cfg80211: Fix possible memory leak in function cfg80211_bss_update

Pablo Neira Ayuso (1):
      netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Paul Jakma (1):
      NIU: fix incorrect error return, missed in previous revert

Pavel Skripkin (5):
      can: mcba_usb_start(): add missing urb->transfer_dma initialization
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak
      net: llc: fix skb_over_panic

Sudeep Holla (1):
      ARM: dts: versatile: Fix up interrupt controller node names

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Xin Long (1):
      sctp: move 198 addresses from unusable to private scope

Yang Yingliang (3):
      workqueue: fix UAF in pwq_unbound_release_workfn()
      net/802/mrp: fix memleak in mrp_request_join()
      net/802/garp: fix memleak in garp_request_join()

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

