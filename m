Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE52300652
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbhAVO5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbhAVOX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F412B23B74;
        Fri, 22 Jan 2021 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325030;
        bh=VkkzzlZw4X4C93irwhwJIlLtlgamSjBFlqcCEnqEAAw=;
        h=From:To:Cc:Subject:Date:From;
        b=iQtrcoqoL4hdoZ2eniTk9esSpIgsFJlN9aF7zwp8RR8YmdN8cixYUBLbpo3O8BfHS
         9HknNpLz75/YdFeJ54idkUp3378spHe91OZCVRHJ1+QNGRoSSCwMPXVn+1lz+fXrBB
         R+XIwdWiT7xCLwdlPTUvWeTAhKecbeoC6Bmu1v58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/33] 5.4.92-rc1 review
Date:   Fri, 22 Jan 2021 15:12:16 +0100
Message-Id: <20210122135733.565501039@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.92-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.92-rc1
X-KernelTest-Deadline: 2021-01-24T13:57+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.92 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.92-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.92-rc1

Michael Hennerich <michael.hennerich@analog.com>
    spi: cadence: cache reference clock rate during probe

Lorenzo Bianconi <lorenzo@kernel.org>
    mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Felix Fietkau <nbd@nbd.name>
    mac80211: do not drop tx nulldata packets on encrypted links

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix NULL deref in tipc_link_xmit()

Daniel Borkmann <daniel@iogearbox.net>
    net, sctp, filter: remap copy_from_user failure error

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

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: core: Increase critical threshold for ASIC thermal zone

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: core: Add validation of transceiver temperature thresholds

Aya Levin <ayal@nvidia.com>
    net: ipv6: Validate GSO SKB before finish IPv6 processing

Jason A. Donenfeld <Jason@zx2c4.com>
    net: skbuff: disambiguate argument and member for skb_list_walk_safe helper

Jason A. Donenfeld <Jason@zx2c4.com>
    net: introduce skb_list_walk_safe for skb segment walking

Manish Chopra <manishc@marvell.com>
    netxen_nic: fix MSI/MSI-x interrupts

Baptiste Lepers <baptiste.lepers@gmail.com>
    udp: Prevent reuseport_select_sock from reading uninitialized socks

Mircea Cirjaliu <mcirjaliu@bitdefender.com>
    bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback

Stanislav Fomichev <sdf@google.com>
    bpf: Don't leak memory in bpf getsockopt when optlen == 0

J. Bruce Fields <bfields@redhat.com>
    nfsd4: readdirplus shouldn't return parent of export

Lukas Wunner <lukas@wunner.de>
    spi: npcm-fiu: Disable clock in probe error path

Qinglang Miao <miaoqinglang@huawei.com>
    spi: npcm-fiu: simplify the return expression of npcm_fiu_probe()

YueHaibing <yuehaibing@huawei.com>
    scsi: lpfc: Make lpfc_defer_acc_rsp static

zhengbin <zhengbin13@huawei.com>
    scsi: lpfc: Make function lpfc_defer_pt2pt_acc static

Arnd Bergmann <arnd@arndb.de>
    elfcore: fix building with clang

Roger Pau Monne <roger.pau@citrix.com>
    xen/privcmd: allow fetching resource sizes

Will Deacon <will@kernel.org>
    compiler.h: Raise minimum version of GCC to 5.1 for arm64

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Make distrust_firmware param default to false


-------------

Diffstat:

 Makefile                                           |  4 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 --
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 13 ++++---
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  7 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  3 +-
 drivers/net/usb/rndis_host.c                       |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  4 +--
 drivers/spi/spi-cadence.c                          |  6 ++--
 drivers/spi/spi-npcm-fiu.c                         |  7 ++--
 drivers/usb/host/ohci-hcd.c                        |  2 +-
 drivers/xen/privcmd.c                              | 25 +++++++++----
 fs/nfsd/nfs3xdr.c                                  |  7 +++-
 include/linux/compiler-gcc.h                       |  6 ++++
 include/linux/elfcore.h                            | 22 ++++++++++++
 include/linux/skbuff.h                             |  5 +++
 kernel/Makefile                                    |  1 -
 kernel/bpf/cgroup.c                                |  5 +--
 kernel/bpf/helpers.c                               |  2 +-
 kernel/elfcore.c                                   | 26 --------------
 net/core/filter.c                                  |  2 +-
 net/core/skbuff.c                                  |  9 +++--
 net/core/sock_reuseport.c                          |  2 +-
 net/dcb/dcbnl.c                                    |  2 ++
 net/ipv4/esp4.c                                    |  7 +---
 net/ipv6/esp6.c                                    |  7 +---
 net/ipv6/ip6_output.c                              | 41 +++++++++++++++++++++-
 net/ipv6/sit.c                                     |  5 ++-
 net/mac80211/tx.c                                  |  4 +--
 net/rxrpc/input.c                                  |  2 +-
 net/rxrpc/key.c                                    |  6 ++--
 net/sctp/socket.c                                  |  2 +-
 net/tipc/link.c                                    |  9 +++--
 32 files changed, 158 insertions(+), 89 deletions(-)


