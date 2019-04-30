Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6226EF854
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfD3Lk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfD3Lk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2DD2177B;
        Tue, 30 Apr 2019 11:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624426;
        bh=Uurc2KSK68HYg73eWvnYk+ZB4MvHKeAaDWlzoobd1kY=;
        h=From:To:Cc:Subject:Date:From;
        b=vSI99ZcZB9cx7UrKhfZ8yjzlEOn97Fh0MMBPO2V3CYngYxpLju5j6DU25LlUOVcoX
         9pWvBg5+JxZBkPDOa/jA/WDZwKPpZnNC8bdF427Zg3h3WUFw9G8A260Tt4XpGSS0DI
         ix9rcdrWmiQ3rUlfEhVWnnDFA9hjR6pmXMj7ECY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/41] 4.9.172-stable review
Date:   Tue, 30 Apr 2019 13:38:11 +0200
Message-Id: <20190430113524.451237916@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.172-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.172-rc1
X-KernelTest-Deadline: 2019-05-02T11:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.172 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 02 May 2019 11:34:41 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.172-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.172-rc1

Peter Oskolkov <posk@google.com>
    net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c

Peter Oskolkov <posk@google.com>
    net: IP6 defrag: use rbtrees for IPv6 defrag

Florian Westphal <fw@strlen.de>
    ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module

Peter Oskolkov <posk@google.com>
    net: IP defrag: encapsulate rbtree defrag code into callable functions

Eric Dumazet <edumazet@google.com>
    ipv6: frags: fix a lockdep false positive

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Vinod Koul <vkoul@kernel.org>
    net: stmmac: move stmmac_check_ether_addr() to driver probe

Hangbin Liu <liuhangbin@gmail.com>
    team: fix possible recursive locking when add slaves

Zhu Yanjun <yanjun.zhu@oracle.com>
    net: rds: exchange of 8K and 1M pool

Erez Alfasi <ereza@mellanox.com>
    net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query

Amit Cohen <amitc@mellanox.com>
    mlxsw: spectrum: Fix autoneg status in ethtool

Eric Dumazet <edumazet@google.com>
    ipv4: add sanity checks in ipv4_link_failure()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "block/loop: Use global lock for ioctl() operation."

Xin Long <lucien.xin@gmail.com>
    tipc: check link name with right length in tipc_nl_compat_link_set

Xin Long <lucien.xin@gmail.com>
    tipc: check bearer name with right length in tipc_nl_compat_bearer_enable

Yue Haibing <yuehaibing@huawei.com>
    fm10k: Fix a potential NULL pointer dereference

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

YueHaibing <yuehaibing@huawei.com>
    fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: gth: Fix an off-by-one in output unassigning

Linus Torvalds <torvalds@linux-foundation.org>
    slip: make slhc_free() silently accept an error pointer

Xin Long <lucien.xin@gmail.com>
    tipc: handle the err returned from cmd header function

Adalbert Lazăr <alazar@bitdefender.com>
    vsock/virtio: fix kernel panic from virtio_transport_reset_no_sock

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Consolidate LPM checks to avoid enabling LPM twice

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add new USB LPM helpers

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/vc4: Fix compilation error reported by kbuild test bot

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/vc4: Fix memory leak during gpu reset.

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the cache

Dirk Behme <dirk.behme@de.bosch.com>
    dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - write config register values to the right offset

NeilBrown <neilb@suse.com>
    sunrpc: don't mark uninitialised items as VALID.

Trond Myklebust <trondmy@gmail.com>
    nfsd: Don't release the callback slot unless it was actually held

Yan, Zheng <zyan@redhat.com>
    ceph: fix ci->i_head_snapc leak

Jeff Layton <jlayton@kernel.org>
    ceph: ensure d_name stability in ceph_dentry_hash()

Xie XiuQi <xiexiuqi@huawei.com>
    sched/numa: Fix a possible divide-by-zero

Josh Collier <josh.d.collier@intel.com>
    IB/rdmavt: Fix frwr memory registration

Peter Zijlstra <peterz@infradead.org>
    trace: Fix preempt_enable_no_resched() abuse

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: scall64-o32: Fix indirect syscall number load

Wenwen Wang <wang6495@umn.edu>
    tracing: Fix a memory leak by early error exit in trace_pid_write()

Frank Sorenson <sorenson@redhat.com>
    cifs: do not attempt cifs operation on smb2+ rename error

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: simplify ld-option implementation


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt             |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |  16 +-
 arch/mips/kernel/scall64-o32.S                     |   2 +-
 drivers/block/loop.c                               |  42 +--
 drivers/block/loop.h                               |   1 +
 drivers/dma/sh/rcar-dmac.c                         |   4 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   2 +-
 drivers/hwtracing/intel_th/gth.c                   |   2 +-
 drivers/infiniband/sw/rdmavt/mr.c                  |  17 +-
 drivers/input/rmi4/rmi_f11.c                       |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   4 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/slip/slhc.c                            |   2 +-
 drivers/net/team/team.c                            |   6 +
 drivers/usb/core/driver.c                          |  23 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/message.c                         |   3 +-
 drivers/usb/core/sysfs.c                           |   5 +-
 drivers/usb/core/usb.h                             |  10 +-
 fs/ceph/dir.c                                      |   6 +-
 fs/ceph/mds_client.c                               |   9 +
 fs/ceph/snap.c                                     |   7 +-
 fs/cifs/inode.c                                    |   4 +
 fs/nfs/super.c                                     |   3 +-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/state.h                                    |   1 +
 fs/proc/proc_sysctl.c                              |   6 +-
 include/net/inet_frag.h                            |  16 +-
 include/net/ipv6.h                                 |  29 --
 include/net/ipv6_frag.h                            | 111 +++++++
 kernel/sched/fair.c                                |   4 +
 kernel/trace/ring_buffer.c                         |   2 +-
 kernel/trace/trace.c                               |   5 +-
 net/bridge/netfilter/ebtables.c                    |   3 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/inet_fragment.c                           | 293 +++++++++++++++++
 net/ipv4/ip_fragment.c                             | 295 ++---------------
 net/ipv4/route.c                                   |  32 +-
 net/ipv4/sysctl_net_ipv4.c                         |   5 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            | 273 +++++-----------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |   3 +-
 net/ipv6/reassembly.c                              | 361 ++++++---------------
 net/openvswitch/conntrack.c                        |   1 +
 net/rds/ib_fmr.c                                   |  11 +
 net/rds/ib_rdma.c                                  |   3 -
 net/sunrpc/cache.c                                 |   3 +
 net/tipc/netlink_compat.c                          |  24 +-
 net/vmw_vsock/virtio_transport_common.c            |  22 +-
 scripts/Kbuild.include                             |   4 +-
 53 files changed, 866 insertions(+), 854 deletions(-)


