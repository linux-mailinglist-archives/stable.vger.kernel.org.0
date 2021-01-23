Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938C301646
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbhAWPVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbhAWPVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:21:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAA9233FA;
        Sat, 23 Jan 2021 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611415242;
        bh=AyedIDBQTikrHgftE6FrQm4bw7/2IX9U+qPVgw5S6BA=;
        h=From:To:Cc:Subject:Date:From;
        b=qmavp51O9a7dOYRYZBqcPbaTbAiokkNUb7a85uWNkMe4jzVtUUrZDYwp9bx7IFVT4
         8XdlBPTHnV2yLT+IKc4YgC2R/kdn26hLAdFOlA/H7krgRRGk7oraAcUZ3W41+Y57ru
         evCahCXMKIv2jwRBGzt/r4X+AkSyTBnC4m4hye5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.170
Date:   Sat, 23 Jan 2021 16:20:30 +0100
Message-Id: <161141523097171@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.170 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S            |    2 
 drivers/md/dm-bufio.c                                |    6 ++
 drivers/md/dm-integrity.c                            |   50 +++++++++++++++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |    2 
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    7 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    3 -
 drivers/net/usb/rndis_host.c                         |    2 
 drivers/spi/spi-cadence.c                            |    6 +-
 drivers/usb/host/ohci-hcd.c                          |    2 
 fs/nfsd/nfs3xdr.c                                    |    7 ++
 include/linux/compiler-gcc.h                         |    6 ++
 include/linux/dm-bufio.h                             |    1 
 include/linux/skbuff.h                               |    5 +
 net/core/skbuff.c                                    |    9 ++-
 net/core/sock_reuseport.c                            |    2 
 net/dcb/dcbnl.c                                      |    2 
 net/ipv4/esp4.c                                      |    7 --
 net/ipv6/esp6.c                                      |    7 --
 net/ipv6/ip6_output.c                                |   40 ++++++++++++++-
 net/ipv6/sit.c                                       |    5 +
 net/rxrpc/input.c                                    |    2 
 net/rxrpc/key.c                                      |    6 +-
 net/tipc/link.c                                      |    9 ++-
 24 files changed, 147 insertions(+), 43 deletions(-)

Andrey Zhizhikin (1):
      rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Arnd Bergmann (1):
      crypto: x86/crc32c - fix building with clang ias

Aya Levin (1):
      net: ipv6: Validate GSO SKB before finish IPv6 processing

Baptiste Lepers (2):
      udp: Prevent reuseport_select_sock from reading uninitialized socks
      rxrpc: Call state should be read with READ_ONCE() under some circumstances

David Howells (1):
      rxrpc: Fix handling of an unsupported token type in rxrpc_read()

David Wu (1):
      net: stmmac: Fixed mtu channged by cache aligned

Eric Dumazet (1):
      net: avoid 32 x truesize under-estimation for tiny skbs

Greg Kroah-Hartman (1):
      Linux 4.19.170

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

Manish Chopra (1):
      netxen_nic: fix MSI/MSI-x interrupts

Michael Hennerich (1):
      spi: cadence: cache reference clock rate during probe

Mikulas Patocka (1):
      dm integrity: fix flush with external metadata device

Petr Machata (2):
      net: dcb: Validate netlink message in DCB handler
      net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Stefan Chulski (1):
      net: mvpp2: Remove Pause and Asym_Pause support

Will Deacon (1):
      compiler.h: Raise minimum version of GCC to 5.1 for arm64

Willem de Bruijn (1):
      esp: avoid unneeded kmap_atomic call

