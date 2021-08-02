Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660253DD7A6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhHBNrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhHBNqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B294260F6D;
        Mon,  2 Aug 2021 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627911989;
        bh=e6PekA7Irec1lEjiPv97qbqcAsPUFP/IHOnPpEKJqK4=;
        h=From:To:Cc:Subject:Date:From;
        b=ZKvoSgdbR4jsXJmMxXaNGpFAR5RegcNGq+X2Vw+s7TIv8XBxXUJ83jwglZ3bcU2+L
         YMEs/Ii/DQ6EoGRkLjuH3rWAB541045GOEKEGInT4zcmxK9QstZyfLxuTJI/nxcBfi
         T8MPR38b2BMa6w08laO122ojP5u0NjdHxlllibHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/26] 4.4.278-rc1 review
Date:   Mon,  2 Aug 2021 15:44:10 +0200
Message-Id: <20210802134332.033552261@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.278-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.278-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.278 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.278-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.278-rc1

Wang Hai <wanghai38@huawei.com>
    sis900: Fix missing pci_disable_device() in probe and remove

Wang Hai <wanghai38@huawei.com>
    tulip: windbond-840: Fix missing pci_disable_device() in probe and remove

Pavel Skripkin <paskripkin@gmail.com>
    net: llc: fix skb_over_panic

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    mlx4: Fix missing error code in mlx4_load_one()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix sleeping in tipc accept routine

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: Fix possible memory leak in function cfg80211_bss_update

Jan Kiszka <jan.kiszka@siemens.com>
    x86/asm: Ensure asm/proto.h can be included stand-alone

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


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/boot/dts/versatile-ab.dts           |   5 +-
 arch/arm/boot/dts/versatile-pb.dts           |   2 +-
 arch/arm/kernel/signal.c                     |  14 ++-
 arch/x86/include/asm/proto.h                 |   2 +
 drivers/net/can/usb/ems_usb.c                |  14 ++-
 drivers/net/can/usb/esd_usb2.c               |  16 ++-
 drivers/net/can/usb/usb_8dev.c               |  15 ++-
 drivers/net/ethernet/dec/tulip/winbond-840.c |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c    |   1 +
 drivers/net/ethernet/sis/sis900.c            |   7 +-
 drivers/net/ethernet/sun/niu.c               |   3 +-
 fs/hfs/bfind.c                               |  14 ++-
 fs/hfs/bnode.c                               |  25 ++++-
 fs/hfs/btree.h                               |   7 ++
 fs/hfs/super.c                               |  10 +-
 fs/ocfs2/file.c                              | 103 ++++++++++-------
 include/linux/string.h                       |  30 +++++
 include/net/af_unix.h                        |   1 +
 include/net/llc_pdu.h                        |  31 ++++--
 include/net/sctp/constants.h                 |   4 +-
 kernel/workqueue.c                           |  20 ++--
 lib/string.c                                 |  66 +++++++++++
 net/802/garp.c                               |  14 +++
 net/802/mrp.c                                |  14 +++
 net/Makefile                                 |   2 +-
 net/llc/af_llc.c                             |  10 +-
 net/llc/llc_s_ac.c                           |   2 +-
 net/netfilter/nft_nat.c                      |   4 +-
 net/sctp/protocol.c                          |   3 +-
 net/tipc/socket.c                            |   9 +-
 net/unix/Kconfig                             |   5 +
 net/unix/Makefile                            |   2 +
 net/unix/af_unix.c                           | 115 ++++++++-----------
 net/unix/garbage.c                           |  68 +----------
 net/unix/scm.c                               | 161 +++++++++++++++++++++++++++
 net/unix/scm.h                               |  10 ++
 net/wireless/scan.c                          |   6 +-
 38 files changed, 579 insertions(+), 247 deletions(-)


