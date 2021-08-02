Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B43DD818
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhHBNtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234852AbhHBNtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C60D60F6D;
        Mon,  2 Aug 2021 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912149;
        bh=fPyrCM8urHiBgwT2hGNlhwyo8TC45qiv5v8eznjH+ow=;
        h=From:To:Cc:Subject:Date:From;
        b=u7+Z2q7rKU+cn/BX8xs1jk5cAFi/EeFh0fNkGe/whcEy04k8UFMpSorsvroK0PACV
         A2EWvP+4NQJUZHiyc/MA+Lp12k1ULEKWubb3ncVwOuPrhiRtqkJvY2p6zP7D/koM3A
         iBpR2HzRtGyRDruHYL3/i+E8ICM2sbVOV5cNhPkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/38] 4.14.242-rc1 review
Date:   Mon,  2 Aug 2021 15:44:22 +0200
Message-Id: <20210802134334.835358048@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.242-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.242-rc1
X-KernelTest-Deadline: 2021-08-04T13:43+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.242 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.242-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.242-rc1

Arnaldo Carvalho de Melo <acme@redhat.com>
    Revert "perf map: Fix dso->nsinfo refcounting"

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

Eric Dumazet <edumazet@google.com>
    gro: ensure frag0 meets IP header alignment

Eric Dumazet <edumazet@google.com>
    virtio_net: Do not pull payload in skb->head

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

Eric Dumazet <edumazet@google.com>
    net: annotate data race around sk_ll_usec

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

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: determine if an exception has an error code only when injecting it.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/versatile-ab.dts                |   5 +-
 arch/arm/boot/dts/versatile-pb.dts                |   2 +-
 arch/x86/include/asm/proto.h                      |   2 +
 arch/x86/kvm/ioapic.c                             |   2 +-
 arch/x86/kvm/ioapic.h                             |   4 +-
 arch/x86/kvm/x86.c                                |  13 +-
 drivers/net/can/spi/hi311x.c                      |   2 +-
 drivers/net/can/usb/ems_usb.c                     |  14 +-
 drivers/net/can/usb/esd_usb2.c                    |  16 ++-
 drivers/net/can/usb/mcba_usb.c                    |   2 +
 drivers/net/can/usb/usb_8dev.c                    |  15 ++-
 drivers/net/ethernet/dec/tulip/winbond-840.c      |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  10 +-
 drivers/net/ethernet/sis/sis900.c                 |   7 +-
 drivers/net/ethernet/sun/niu.c                    |   3 +-
 drivers/net/virtio_net.c                          |  10 +-
 drivers/nfc/nfcsim.c                              |   3 +-
 fs/hfs/bfind.c                                    |  14 +-
 fs/hfs/bnode.c                                    |  25 +++-
 fs/hfs/btree.h                                    |   7 +
 fs/hfs/super.c                                    |  10 +-
 fs/ocfs2/file.c                                   | 103 +++++++++------
 include/linux/skbuff.h                            |   9 ++
 include/linux/virtio_net.h                        |  14 +-
 include/net/af_unix.h                             |   1 +
 include/net/busy_poll.h                           |   2 +-
 include/net/llc_pdu.h                             |  31 +++--
 include/net/sctp/constants.h                      |   4 +-
 kernel/workqueue.c                                |  20 ++-
 net/802/garp.c                                    |  14 ++
 net/802/mrp.c                                     |  14 ++
 net/Makefile                                      |   2 +-
 net/can/raw.c                                     |  20 ++-
 net/core/dev.c                                    |   3 +-
 net/core/sock.c                                   |   2 +-
 net/llc/af_llc.c                                  |  10 +-
 net/llc/llc_s_ac.c                                |   2 +-
 net/netfilter/nf_conntrack_core.c                 |   7 +-
 net/netfilter/nft_nat.c                           |   4 +-
 net/sctp/input.c                                  |   2 +-
 net/sctp/protocol.c                               |   3 +-
 net/tipc/socket.c                                 |   9 +-
 net/unix/Kconfig                                  |   5 +
 net/unix/Makefile                                 |   2 +
 net/unix/af_unix.c                                | 102 +++++++--------
 net/unix/garbage.c                                |  68 +---------
 net/unix/scm.c                                    | 149 ++++++++++++++++++++++
 net/unix/scm.h                                    |  10 ++
 net/wireless/scan.c                               |   6 +-
 tools/perf/util/map.c                             |   2 -
 tools/testing/selftests/vm/userfaultfd.c          |   2 +-
 53 files changed, 540 insertions(+), 260 deletions(-)


