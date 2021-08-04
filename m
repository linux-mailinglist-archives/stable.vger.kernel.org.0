Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43F3E010F
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhHDMYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 08:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237403AbhHDMYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 08:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A91760F22;
        Wed,  4 Aug 2021 12:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628079844;
        bh=BBf+Gmj7O4q5oqHxoIoIPt3bIXbwqEAQ3iZPDQXpJpo=;
        h=From:To:Cc:Subject:Date:From;
        b=FTQu8tKROr3+QSPZU7uk4UcdQWnabBFtJTxPdxCMktlS07zwNyWCr8iHs3jhsScl7
         TS2sSB/nlxLqEE34BGuEk9O5AIgQDtcgLDM7S7idSh8+uCt7wM1zutIx3yySQqWoJz
         gsVOT5+vWrSB+Zzca5VRMecxV3QH26B8m5cPZEyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.201
Date:   Wed,  4 Aug 2021 14:23:50 +0200
Message-Id: <162807983171201@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.201 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/powerpc/platforms/pseries/setup.c            |    2 
 arch/x86/include/asm/proto.h                      |    2 
 arch/x86/kvm/ioapic.c                             |    2 
 arch/x86/kvm/ioapic.h                             |    4 
 drivers/net/can/spi/hi311x.c                      |    2 
 drivers/net/can/usb/ems_usb.c                     |   14 ++
 drivers/net/can/usb/esd_usb2.c                    |   16 +++
 drivers/net/can/usb/mcba_usb.c                    |    2 
 drivers/net/can/usb/usb_8dev.c                    |   15 ++-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |    7 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c       |   60 +++++++-----
 drivers/net/ethernet/mellanox/mlx4/main.c         |    1 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   10 +-
 drivers/net/ethernet/sis/sis900.c                 |    7 -
 drivers/net/ethernet/sun/niu.c                    |    3 
 drivers/net/virtio_net.c                          |   10 +-
 drivers/nfc/nfcsim.c                              |    3 
 fs/btrfs/volumes.c                                |    1 
 fs/ocfs2/file.c                                   |  103 +++++++++++++---------
 include/linux/skbuff.h                            |    9 +
 include/linux/virtio_net.h                        |   14 +-
 include/net/llc_pdu.h                             |   31 ++++--
 net/can/raw.c                                     |   20 +++-
 net/core/dev.c                                    |    3 
 net/llc/af_llc.c                                  |   10 +-
 net/llc/llc_s_ac.c                                |    2 
 net/netfilter/nf_conntrack_core.c                 |    7 +
 net/netfilter/nft_nat.c                           |    4 
 net/sctp/input.c                                  |    2 
 net/tipc/socket.c                                 |    9 -
 net/wireless/scan.c                               |    6 -
 tools/perf/util/map.c                             |    2 
 34 files changed, 259 insertions(+), 128 deletions(-)

Arkadiusz Kubalewski (1):
      i40e: Fix logic of disabling queues

Arnaldo Carvalho de Melo (1):
      Revert "perf map: Fix dso->nsinfo refcounting"

Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Desmond Cheong Zhi Xi (1):
      btrfs: fix rw device counting in __btrfs_free_extra_devids

Eric Dumazet (2):
      virtio_net: Do not pull payload in skb->head
      gro: ensure frag0 meets IP header alignment

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Greg Kroah-Hartman (1):
      Linux 4.19.201

Hoang Le (1):
      tipc: fix sleeping in tipc accept routine

Jan Kiszka (1):
      x86/asm: Ensure asm/proto.h can be included stand-alone

Jedrzej Jagielski (1):
      i40e: Fix log TC creation failure when max num of queues is exceeded

Jiapeng Chong (1):
      mlx4: Fix missing error code in mlx4_load_one()

Juergen Gross (1):
      x86/kvm: fix vcpu-id indexed array sizes

Junxiao Bi (2):
      ocfs2: fix zero out valid data
      ocfs2: issue zeroout to EOF blocks

Krzysztof Kozlowski (1):
      nfc: nfcsim: fix use after free during module unload

Lukasz Cieplicki (1):
      i40e: Add additional info to PHY type error

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Marcelo Ricardo Leitner (1):
      sctp: fix return value check in __sctp_rcv_asconf_lookup

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

Srikar Dronamraju (1):
      powerpc/pseries: Fix regression while building external modules

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

