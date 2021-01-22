Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D7300BA6
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbhAVSnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbhAVOWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591AB23B32;
        Fri, 22 Jan 2021 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324932;
        bh=RNCqSgvI8xYm1XbENm9mg9ix/P8SGjVd3IE4Rr9YMps=;
        h=From:To:Cc:Subject:Date:From;
        b=Tyvismn05HlYr/fQ/9sKXP0njhWnUJUpmQhy0K5Mn97u8s1rNYvyhEswtCO1xOY07
         42XEbp35nDjztGOEyIqI9vgRtlbA0mDWDDA56SQStodl0LWoNl1fdjtZ6KBGTr9Zi4
         yS4TG3YAC/o7WDhyeMTrVYJXgWU8a27dXbGQOkzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/22] 4.19.170-rc1 review
Date:   Fri, 22 Jan 2021 15:12:18 +0100
Message-Id: <20210122135731.921636245@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.170-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.170-rc1
X-KernelTest-Deadline: 2021-01-24T13:57+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.170 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.170-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.170-rc1

Michael Hennerich <michael.hennerich@analog.com>
    spi: cadence: cache reference clock rate during probe

Aya Levin <ayal@nvidia.com>
    net: ipv6: Validate GSO SKB before finish IPv6 processing

Jason A. Donenfeld <Jason@zx2c4.com>
    net: skbuff: disambiguate argument and member for skb_list_walk_safe helper

Jason A. Donenfeld <Jason@zx2c4.com>
    net: introduce skb_list_walk_safe for skb segment walking

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix NULL deref in tipc_link_xmit()

David Howells <dhowells@redhat.com>
    rxrpc: Fix handling of an unsupported token type in rxrpc_read()

Eric Dumazet <edumazet@google.com>
    net: avoid 32 x truesize under-estimation for tiny skbs

Jakub Kicinski <kuba@kernel.org>
    net: sit: unregister_netdevice on newlink's error path

David Wu <david.wu@rock-chips.com>
    net: stmmac: Fixed mtu channged by cache aligned

Baptiste Lepers <baptiste.lepers@gmail.com>
    rxrpc: Call state should be read with READ_ONCE() under some circumstances

Petr Machata <petrm@nvidia.com>
    net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Willem de Bruijn <willemb@google.com>
    esp: avoid unneeded kmap_atomic call

Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
    rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Remove Pause and Asym_Pause support

Manish Chopra <manishc@marvell.com>
    netxen_nic: fix MSI/MSI-x interrupts

Baptiste Lepers <baptiste.lepers@gmail.com>
    udp: Prevent reuseport_select_sock from reading uninitialized socks

J. Bruce Fields <bfields@redhat.com>
    nfsd4: readdirplus shouldn't return parent of export

Arnd Bergmann <arnd@arndb.de>
    crypto: x86/crc32c - fix building with clang ias

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix flush with external metadata device

Will Deacon <will@kernel.org>
    compiler.h: Raise minimum version of GCC to 5.1 for arm64

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Make distrust_firmware param default to false


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  2 +-
 drivers/md/dm-bufio.c                              |  6 +++
 drivers/md/dm-integrity.c                          | 50 +++++++++++++++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 -
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  7 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  3 +-
 drivers/net/usb/rndis_host.c                       |  2 +-
 drivers/spi/spi-cadence.c                          |  6 ++-
 drivers/usb/host/ohci-hcd.c                        |  2 +-
 fs/nfsd/nfs3xdr.c                                  |  7 ++-
 include/linux/compiler-gcc.h                       |  6 +++
 include/linux/dm-bufio.h                           |  1 +
 include/linux/skbuff.h                             |  5 +++
 net/core/skbuff.c                                  |  9 +++-
 net/core/sock_reuseport.c                          |  2 +-
 net/dcb/dcbnl.c                                    |  2 +
 net/ipv4/esp4.c                                    |  7 +--
 net/ipv6/esp6.c                                    |  7 +--
 net/ipv6/ip6_output.c                              | 40 ++++++++++++++++-
 net/ipv6/sit.c                                     |  5 ++-
 net/rxrpc/input.c                                  |  2 +-
 net/rxrpc/key.c                                    |  6 ++-
 net/tipc/link.c                                    |  9 +++-
 24 files changed, 148 insertions(+), 44 deletions(-)


