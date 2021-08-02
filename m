Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA13DD83C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhHBNul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234737AbhHBNty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3983960551;
        Mon,  2 Aug 2021 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912184;
        bh=ftddxLerz1k2T+ZtEc6xwAyhL0lKS65ogvBnrn3MX5g=;
        h=From:To:Cc:Subject:Date:From;
        b=0bUmV0vWmPY0J9hD0PHHIfB5U3imaXubLMP7JlopobjUBdCAbb5ivXQ2HrayJfUk3
         WBtFV910NIwi9nfBOm+2RwMKDjgxmecTBBRMY1Cuc9UxO8VDD6FDIjM1jDPkC+cqKB
         uZjyJz54o+GWOLxRiF3Y0bem13WI/TmHw/ppjVxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/30] 4.19.201-rc1 review
Date:   Mon,  2 Aug 2021 15:44:38 +0200
Message-Id: <20210802134334.081433902@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.201-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.201-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.201 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.201-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.201-rc1

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Add additional info to PHY type error

Arnaldo Carvalho de Melo <acme@redhat.com>
    Revert "perf map: Fix dso->nsinfo refcounting"

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/pseries: Fix regression while building external modules

Dan Carpenter <dan.carpenter@oracle.com>
    can: hi311x: fix a signedness bug in hi3110_cmd()

Wang Hai <wanghai38@huawei.com>
    sis900: Fix missing pci_disable_device() in probe and remove

Wang Hai <wanghai38@huawei.com>
    tulip: windbond-840: Fix missing pci_disable_device() in probe and remove

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix return value check in __sctp_rcv_asconf_lookup

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix flow table chaining

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix sleeping in tipc accept routine

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix log TC creation failure when max num of queues is exceeded

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix logic of disabling queues

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: adjust stop timestamp to real expiry value

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: nfcsim: fix use after free during module unload

Paul Jakma <paul@jakma.org>
    NIU: fix incorrect error return, missed in previous revert

Pavel Skripkin <paskripkin@gmail.com>
    can: esd_usb2: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: ems_usb: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: usb_8dev: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb_start(): add missing urb->transfer_dma initialization

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: issue zeroout to EOF blocks

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix zero out valid data

Juergen Gross <jgross@suse.com>
    x86/kvm: fix vcpu-id indexed array sizes

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: fix rw device counting in __btrfs_free_extra_devids

Jan Kiszka <jan.kiszka@siemens.com>
    x86/asm: Ensure asm/proto.h can be included stand-alone

Eric Dumazet <edumazet@google.com>
    gro: ensure frag0 meets IP header alignment

Eric Dumazet <edumazet@google.com>
    virtio_net: Do not pull payload in skb->head


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/powerpc/platforms/pseries/setup.c            |   2 +-
 arch/x86/include/asm/proto.h                      |   2 +
 arch/x86/kvm/ioapic.c                             |   2 +-
 arch/x86/kvm/ioapic.h                             |   4 +-
 drivers/net/can/spi/hi311x.c                      |   2 +-
 drivers/net/can/usb/ems_usb.c                     |  14 ++-
 drivers/net/can/usb/esd_usb2.c                    |  16 +++-
 drivers/net/can/usb/mcba_usb.c                    |   2 +
 drivers/net/can/usb/usb_8dev.c                    |  15 +++-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  60 ++++++++-----
 drivers/net/ethernet/mellanox/mlx4/main.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  10 ++-
 drivers/net/ethernet/sis/sis900.c                 |   7 +-
 drivers/net/ethernet/sun/niu.c                    |   3 +-
 drivers/net/virtio_net.c                          |  10 ++-
 drivers/nfc/nfcsim.c                              |   3 +-
 fs/btrfs/volumes.c                                |   1 +
 fs/ocfs2/file.c                                   | 103 +++++++++++++---------
 include/linux/skbuff.h                            |   9 ++
 include/linux/virtio_net.h                        |  14 +--
 include/net/llc_pdu.h                             |  31 +++++--
 net/can/raw.c                                     |  20 ++++-
 net/core/dev.c                                    |   3 +-
 net/llc/af_llc.c                                  |  10 ++-
 net/llc/llc_s_ac.c                                |   2 +-
 net/netfilter/nf_conntrack_core.c                 |   7 +-
 net/netfilter/nft_nat.c                           |   4 +-
 net/sctp/input.c                                  |   2 +-
 net/tipc/socket.c                                 |   9 +-
 net/wireless/scan.c                               |   6 +-
 tools/perf/util/map.c                             |   2 -
 34 files changed, 260 insertions(+), 129 deletions(-)


