Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3673DD7B9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhHBNr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234340AbhHBNrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 670E9610CC;
        Mon,  2 Aug 2021 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912022;
        bh=U4epJX3qSAkkyk1GJPUuRPvqPiIqAgwQsTAYfMNdjNE=;
        h=From:To:Cc:Subject:Date:From;
        b=DgbWyvYKW+dyTg/gkACRHvN1b5LkRFDGg3hqqp6t9m5Fp7YvrwoANI9ylIm54PRvX
         HEA6/FFj3lZFz4w11wML5j5oWNGqXNHSQ4hXyi/8vGH9difVGS5WVjARjN62ODHn2j
         LQbjGM5F3PP+e2LgYkZ8Y5tSvD/+RwLZjpkhExts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/32] 4.9.278-rc1 review
Date:   Mon,  2 Aug 2021 15:44:20 +0200
Message-Id: <20210802134332.931915241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.278-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.278-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.278 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.278-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.278-rc1

Wang Hai <wanghai38@huawei.com>
    sis900: Fix missing pci_disable_device() in probe and remove

Wang Hai <wanghai38@huawei.com>
    tulip: windbond-840: Fix missing pci_disable_device() in probe and remove

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix flow table chaining

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix sleeping in tipc accept routine

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: adjust stop timestamp to real expiry value

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Jan Kiszka <jan.kiszka@siemens.com>
    x86/asm: Ensure asm/proto.h can be included stand-alone

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

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: issue zeroout to EOF blocks

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix zero out valid data

Juergen Gross <jgross@suse.com>
    x86/kvm: fix vcpu-id indexed array sizes

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: ensure the signal page contains defined contents

Matthew Wilcox <mawilcox@microsoft.com>
    lib/string.c: add multibyte memset functions

Sudeep Holla <sudeep.holla@arm.com>
    ARM: dts: versatile: Fix up interrupt controller node names

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: add lock nesting notation to hfs_find_init

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: fix high memory mapping in hfs_bnode_read

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    hfs: add missing clean-up in hfs_fill_super

Xin Long <lucien.xin@gmail.com>
    sctp: move 198 addresses from unusable to private scope

Yang Yingliang <yangyingliang@huawei.com>
    net/802/garp: fix memleak in garp_request_join()

Yang Yingliang <yangyingliang@huawei.com>
    net/802/mrp: fix memleak in mrp_request_join()

Yang Yingliang <yangyingliang@huawei.com>
    workqueue: fix UAF in pwq_unbound_release_workfn()

Miklos Szeredi <mszeredi@redhat.com>
    af_unix: fix garbage collect vs MSG_PEEK

Jens Axboe <axboe@kernel.dk>
    net: split out functions related to registering inflight socket files

Nathan Chancellor <nathan@kernel.org>
    tipc: Fix backport of b77413446408fdd256599daf00d5be72b5f3e7c6

Nathan Chancellor <nathan@kernel.org>
    iommu/amd: Fix backport of 140456f994195b568ecd7fc2287a34eadffef3ca


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/versatile-ab.dts                |   5 +-
 arch/arm/boot/dts/versatile-pb.dts                |   2 +-
 arch/arm/kernel/signal.c                          |  14 +-
 arch/x86/include/asm/proto.h                      |   2 +
 arch/x86/kvm/ioapic.c                             |   2 +-
 arch/x86/kvm/ioapic.h                             |   4 +-
 drivers/iommu/amd_iommu.c                         |   2 +-
 drivers/net/can/usb/ems_usb.c                     |  14 +-
 drivers/net/can/usb/esd_usb2.c                    |  16 ++-
 drivers/net/can/usb/usb_8dev.c                    |  15 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  10 +-
 drivers/net/ethernet/sis/sis900.c                 |   7 +-
 drivers/net/ethernet/sun/niu.c                    |   3 +-
 drivers/nfc/nfcsim.c                              |   3 +-
 fs/hfs/bfind.c                                    |  14 +-
 fs/hfs/bnode.c                                    |  25 +++-
 fs/hfs/btree.h                                    |   7 +
 fs/hfs/super.c                                    |  10 +-
 fs/ocfs2/file.c                                   | 103 ++++++++------
 include/linux/string.h                            |  30 ++++
 include/net/af_unix.h                             |   1 +
 include/net/llc_pdu.h                             |  31 +++--
 include/net/sctp/constants.h                      |   4 +-
 kernel/workqueue.c                                |  20 ++-
 lib/string.c                                      |  66 +++++++++
 net/802/garp.c                                    |  14 ++
 net/802/mrp.c                                     |  14 ++
 net/Makefile                                      |   2 +-
 net/llc/af_llc.c                                  |  10 +-
 net/llc/llc_s_ac.c                                |   2 +-
 net/netfilter/nf_conntrack_core.c                 |   7 +-
 net/netfilter/nft_nat.c                           |   4 +-
 net/sctp/protocol.c                               |   3 +-
 net/tipc/link.c                                   |   2 +-
 net/tipc/socket.c                                 |   9 +-
 net/unix/Kconfig                                  |   5 +
 net/unix/Makefile                                 |   2 +
 net/unix/af_unix.c                                | 115 ++++++----------
 net/unix/garbage.c                                |  68 +--------
 net/unix/scm.c                                    | 161 ++++++++++++++++++++++
 net/unix/scm.h                                    |  10 ++
 net/wireless/scan.c                               |   6 +-
 45 files changed, 597 insertions(+), 259 deletions(-)


