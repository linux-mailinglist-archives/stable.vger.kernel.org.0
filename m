Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57230164A
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbhAWPWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbhAWPVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:21:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B799233FC;
        Sat, 23 Jan 2021 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611415249;
        bh=xmFzje4Sr8frI6bqpQw4yrmnUNKLNE6OMCVt/Ko5AZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=kFD6MEj91YWk0I13aGtGBc2UTZUoYSAvZRpB+saD/KXE2oIyOB8jDfjeK2CiFjvsj
         u5fFm+7spxJfeNRZjbFH8joSfsAS0eB3eUSTETFYl9iVKb6VUO4Qsq1zZa1rv4Z2jy
         SushPuRm1Wy8hkjlGWP/M364UBR6Rq7IsUwRxn4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.92
Date:   Sat, 23 Jan 2021 16:20:46 +0100
Message-Id: <161141524616954@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.92 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |    2 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c   |   13 +++---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    7 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    3 -
 drivers/net/usb/rndis_host.c                         |    2 
 drivers/scsi/lpfc/lpfc_nportdisc.c                   |    4 -
 drivers/spi/spi-cadence.c                            |    6 +-
 drivers/spi/spi-npcm-fiu.c                           |    7 +--
 drivers/usb/host/ohci-hcd.c                          |    2 
 drivers/xen/privcmd.c                                |   25 ++++++++---
 fs/nfsd/nfs3xdr.c                                    |    7 ++-
 include/linux/compiler-gcc.h                         |    6 ++
 include/linux/elfcore.h                              |   22 ++++++++++
 include/linux/skbuff.h                               |    5 ++
 kernel/Makefile                                      |    1 
 kernel/bpf/cgroup.c                                  |    5 +-
 kernel/bpf/helpers.c                                 |    2 
 kernel/elfcore.c                                     |   26 ------------
 net/core/filter.c                                    |    2 
 net/core/skbuff.c                                    |    9 +++-
 net/core/sock_reuseport.c                            |    2 
 net/dcb/dcbnl.c                                      |    2 
 net/ipv4/esp4.c                                      |    7 ---
 net/ipv6/esp6.c                                      |    7 ---
 net/ipv6/ip6_output.c                                |   41 ++++++++++++++++++-
 net/ipv6/sit.c                                       |    5 +-
 net/mac80211/tx.c                                    |    4 -
 net/rxrpc/input.c                                    |    2 
 net/rxrpc/key.c                                      |    6 +-
 net/sctp/socket.c                                    |    2 
 net/tipc/link.c                                      |    9 +++-
 32 files changed, 157 insertions(+), 88 deletions(-)

Andrey Zhizhikin (1):
      rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Arnd Bergmann (1):
      elfcore: fix building with clang

Aya Levin (1):
      net: ipv6: Validate GSO SKB before finish IPv6 processing

Baptiste Lepers (2):
      udp: Prevent reuseport_select_sock from reading uninitialized socks
      rxrpc: Call state should be read with READ_ONCE() under some circumstances

Daniel Borkmann (1):
      net, sctp, filter: remap copy_from_user failure error

David Howells (1):
      rxrpc: Fix handling of an unsupported token type in rxrpc_read()

David Wu (1):
      net: stmmac: Fixed mtu channged by cache aligned

Eric Dumazet (1):
      net: avoid 32 x truesize under-estimation for tiny skbs

Felix Fietkau (1):
      mac80211: do not drop tx nulldata packets on encrypted links

Greg Kroah-Hartman (1):
      Linux 5.4.92

Hamish Martin (1):
      usb: ohci: Make distrust_firmware param default to false

Hoang Le (1):
      tipc: fix NULL deref in tipc_link_xmit()

J. Bruce Fields (1):
      nfsd4: readdirplus shouldn't return parent of export

Jakub Kicinski (1):
      net: sit: unregister_netdevice on newlink's error path

Jason A. Donenfeld (2):
      net: introduce skb_list_walk_safe for skb segment walking
      net: skbuff: disambiguate argument and member for skb_list_walk_safe helper

Lorenzo Bianconi (1):
      mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Lukas Wunner (1):
      spi: npcm-fiu: Disable clock in probe error path

Manish Chopra (1):
      netxen_nic: fix MSI/MSI-x interrupts

Michael Hennerich (1):
      spi: cadence: cache reference clock rate during probe

Mircea Cirjaliu (1):
      bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback

Petr Machata (2):
      net: dcb: Validate netlink message in DCB handler
      net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Qinglang Miao (1):
      spi: npcm-fiu: simplify the return expression of npcm_fiu_probe()

Roger Pau Monne (1):
      xen/privcmd: allow fetching resource sizes

Stanislav Fomichev (1):
      bpf: Don't leak memory in bpf getsockopt when optlen == 0

Stefan Chulski (1):
      net: mvpp2: Remove Pause and Asym_Pause support

Vadim Pasternak (2):
      mlxsw: core: Add validation of transceiver temperature thresholds
      mlxsw: core: Increase critical threshold for ASIC thermal zone

Will Deacon (1):
      compiler.h: Raise minimum version of GCC to 5.1 for arm64

Willem de Bruijn (1):
      esp: avoid unneeded kmap_atomic call

YueHaibing (1):
      scsi: lpfc: Make lpfc_defer_acc_rsp static

zhengbin (1):
      scsi: lpfc: Make function lpfc_defer_pt2pt_acc static

