Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5540276D61
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389625AbfGZPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389223AbfGZPdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:33:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C411320644;
        Fri, 26 Jul 2019 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155199;
        bh=h67+uXT6sbm9y238+F0NWa0H/3M1k6uwS2jIekTjE0E=;
        h=From:To:Cc:Subject:Date:From;
        b=vfzGe8alZCNTBkTIVlHWrL3yqpE2/yNn7kTE8yha/6vGUPC+nBcmf+iXBtJtoU+jx
         1OYYpdQwqZk7/jUq+H5k3ipGRyH9WwAH/NYywHWL9KkPDCAjC5Y6VXiCsYW3h2h/pS
         1Q0BKoUZY/Wc/yBxywpndS95ad52sQql0PvMCvWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/50] 4.19.62-stable review
Date:   Fri, 26 Jul 2019 17:24:35 +0200
Message-Id: <20190726152300.760439618@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.62-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.62-rc1
X-KernelTest-Deadline: 2019-07-28T15:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.62 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.62-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.62-rc1

Kuo-Hsin Yang <vovoy@chromium.org>
    mm: vmscan: scan anonymous pages on file refaults

Jan Kiszka <jan.kiszka@siemens.com>
    KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: do not use dangling shadow VMCS after guest reset

Theodore Ts'o <tytso@mit.edu>
    ext4: allow directory holes

Ross Zwisler <zwisler@chromium.org>
    ext4: use jbd2_inode dirty range scoping

Ross Zwisler <zwisler@chromium.org>
    jbd2: introduce jbd2_inode dirty range scoping

Ross Zwisler <zwisler@chromium.org>
    mm: add filemap_fdatawait_range_keep_errors()

Theodore Ts'o <tytso@mit.edu>
    ext4: enforce the immutable flag on open files

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: don't allow any modifications to an immutable file

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix race between close() and fork()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/core: Fix exclusive events' grouping

Paul Cercueil <paul@crapouillou.net>
    MIPS: lb60: Fix pin mappings

Keerthy <j-keerthy@ti.com>
    gpio: davinci: silence error prints in case of EPROBE_DEFER

Chris Wilson <chris@chris-wilson.co.uk>
    dma-buf: Discard old fence_excl on retrying get_fences_rcu for realloc

Jérôme Glisse <jglisse@redhat.com>
    dma-buf: balance refcount inbalance

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: stp: don't cache eth dest pointer before skb pull

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: don't cache ether dest pointer on input

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling

Xin Long <lucien.xin@gmail.com>
    sctp: not bind the socket in sctp_connect

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: make sure offload also gets the keys wiped

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: unset TCQ_F_CAN_BYPASS when adding filters

Cong Wang <xiyou.wangcong@gmail.com>
    netrom: hold sock when setting skb->destructor

Cong Wang <xiyou.wangcong@gmail.com>
    netrom: fix a memory leak in nr_rx_frame()

Andreas Steinmetz <ast@domdv.de>
    macsec: fix checksumming after decryption

Andreas Steinmetz <ast@domdv.de>
    macsec: fix use-after-free of skb during RX

Aya Levin <ayal@mellanox.com>
    net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn

Peter Kosyh <p.kosyh@gmail.com>
    vrf: make sure skb->data contains ip header to make routing

Christoph Paasch <cpaasch@apple.com>
    tcp: Reset bytes_acked and bytes_received when disconnecting

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_set_congestion_control() use from bpf hook

Eric Dumazet <edumazet@google.com>
    tcp: be more careful in tcp_fragment()

Takashi Iwai <tiwai@suse.de>
    sky2: Disable MSI on ASUS P6T

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix error handling on stream scheduler initialization

David Howells <dhowells@redhat.com>
    rxrpc: Fix send on a connected, but unbound socket

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix issue with confused RX unit after PHY power-down on RTL8411b

Yang Wei <albin_yang@163.com>
    nfc: fix potential illegal memory access

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Re-work the queue selection for TSO packets

Andrew Lunn <andrew@lunn.ch>
    net: phy: sfp: hwmon: Fix scaling of RX power

John Hurley <john.hurley@netronome.com>
    net: openvswitch: fix csum updates for MPLS actions

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    net: neigh: fix multiple neigh timer scheduling

Florian Westphal <fw@strlen.de>
    net: make skb_dst_force return true when dst is refcounted

Baruch Siach <baruch@tkos.co.il>
    net: dsa: mv88e6xxx: wait after reset deactivation

Justin Chen <justinpopo6@gmail.com>
    net: bcmgenet: use promisc for unsupported filters

Ido Schimmel <idosch@mellanox.com>
    ipv6: Unlink sibling route in case of failure

David Ahern <dsahern@gmail.com>
    ipv6: rt6_check should return NULL if 'from' is NULL

Matteo Croce <mcroce@redhat.com>
    ipv4: don't set IPv6 only flags to IPv4 addresses

Eric Dumazet <edumazet@google.com>
    igmp: fix memory leak in igmpv3_del_delrec()

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix extra rcu_read_unlock in netvsc_recv_callback()

Taehee Yoo <ap420073@gmail.com>
    caif-hsi: fix possible deadlock in cfhsi_exit_module()

Brian King <brking@linux.vnet.ibm.com>
    bnx2x: Prevent load reordering in tx completion processing


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/jz4740/board-qi_lb60.c                   |  16 +--
 arch/x86/kvm/vmx.c                                 |  10 +-
 drivers/dma-buf/dma-buf.c                          |   1 +
 drivers/dma-buf/reservation.c                      |   4 +
 drivers/gpio/gpio-davinci.c                        |   5 +-
 drivers/net/caif/caif_hsi.c                        |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  57 ++++-----
 drivers/net/ethernet/marvell/sky2.c                |   7 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   9 +-
 drivers/net/ethernet/realtek/r8169.c               | 137 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  29 +++--
 drivers/net/hyperv/netvsc_drv.c                    |   1 -
 drivers/net/macsec.c                               |   6 +-
 drivers/net/phy/sfp.c                              |   2 +-
 drivers/net/vrf.c                                  |  58 +++++----
 fs/ext4/dir.c                                      |  19 ++-
 fs/ext4/ext4_jbd2.h                                |  12 +-
 fs/ext4/file.c                                     |   4 +
 fs/ext4/inode.c                                    |  24 +++-
 fs/ext4/ioctl.c                                    |  46 ++++++-
 fs/ext4/move_extent.c                              |   3 +-
 fs/ext4/namei.c                                    |  45 +++++--
 fs/jbd2/commit.c                                   |  23 +++-
 fs/jbd2/journal.c                                  |   4 +
 fs/jbd2/transaction.c                              |  49 ++++----
 include/linux/fs.h                                 |   2 +
 include/linux/jbd2.h                               |  22 ++++
 include/linux/perf_event.h                         |   5 +
 include/net/dst.h                                  |   5 +-
 include/net/tcp.h                                  |   8 +-
 include/net/tls.h                                  |   1 +
 kernel/events/core.c                               |  83 ++++++++++---
 mm/filemap.c                                       |  22 ++++
 mm/vmscan.c                                        |   6 +-
 net/bridge/br_input.c                              |   8 +-
 net/bridge/br_multicast.c                          |  32 ++---
 net/bridge/br_stp_bpdu.c                           |   3 +-
 net/core/filter.c                                  |   2 +-
 net/core/neighbour.c                               |   2 +
 net/ipv4/devinet.c                                 |   8 ++
 net/ipv4/igmp.c                                    |   8 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_cong.c                                |   6 +-
 net/ipv4/tcp_output.c                              |  13 +-
 net/ipv6/ip6_fib.c                                 |  18 ++-
 net/ipv6/route.c                                   |   2 +-
 net/netfilter/nf_queue.c                           |   6 +-
 net/netrom/af_netrom.c                             |   4 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/openvswitch/actions.c                          |   6 +-
 net/rxrpc/af_rxrpc.c                               |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_fq_codel.c                           |   2 -
 net/sched/sch_sfq.c                                |   2 -
 net/sctp/socket.c                                  |  20 +--
 net/sctp/stream.c                                  |   9 +-
 net/tls/tls_device.c                               |   2 +-
 net/tls/tls_main.c                                 |   2 +-
 61 files changed, 669 insertions(+), 235 deletions(-)


