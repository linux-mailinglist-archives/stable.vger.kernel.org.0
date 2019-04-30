Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A8FF801
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfD3Lmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfD3Lmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8D9217D7;
        Tue, 30 Apr 2019 11:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624557;
        bh=r2w+PBfnx47CgPVpcg9tD2mystB7cwHRux/mG4kiUZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=DbHcAST6Fl8Z2roOQD2RFyU2Sw6kGWJKCRW7P4B+ccINGamV4L11qSp61DslIZX2D
         FvdUHvnkACUc6YYe/OS71Me299+8vI5gG7zFD9C4h/5PEu3TAdsC7sIcdHQCXQmwIG
         dG6Bkna77bhcspBSDt2//q6uGTgztW9rMbiNOD/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/53] 4.14.115-stable review
Date:   Tue, 30 Apr 2019 13:38:07 +0200
Message-Id: <20190430113549.400132183@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.115-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.115-rc1
X-KernelTest-Deadline: 2019-05-02T11:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.115 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 02 May 2019 11:34:49 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.115-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.115-rc1

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Eric Dumazet <edumazet@google.com>
    net/rose: fix unbound loop in rose_loopback_timer()

Kees Cook <keescook@chromium.org>
    net/rose: Convert timers to use timer_setup()

Hangbin Liu <liuhangbin@gmail.com>
    team: fix possible recursive locking when add slaves

Su Bao Cheng <baocheng.su@siemens.com>
    stmmac: pci: Adjust IOT2000 matching

Vinod Koul <vkoul@kernel.org>
    net: stmmac: move stmmac_check_ether_addr() to driver probe

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

Jan Kara <jack@suse.cz>
    mm: Fix warning in insert_pfn()

Daniel Borkmann <daniel@iogearbox.net>
    x86/retpolines: Disable switch jump tables when retpolines are enabled

Daniel Borkmann <daniel@iogearbox.net>
    x86, retpolines: Raise limit for generating indirect calls from switch-case

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: change memcmp to strncmp in dm_integrity_ctr

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

luca abeni <luca.abeni@santannapisa.it>
    sched/deadline: Correctly handle active 0-lag timers

Todd Kjos <tkjos@android.com>
    binder: fix handling of misaligned binder object

Andrea Claudi <aclaudi@redhat.com>
    ipvs: fix warning on unused variable

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

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: fix some error pointer dereferences

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Consolidate LPM checks to avoid enabling LPM twice

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add new USB LPM helpers

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/vc4: Fix compilation error reported by kbuild test bot

Dave Airlie <airlied@redhat.com>
    Revert "drm/i915/fbdev: Actually configure untiled displays"

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/vc4: Fix memory leak during gpu reset.

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the cache

Dirk Behme <dirk.behme@de.bosch.com>
    dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Limit DMA mappings per container

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

Jeff Layton <jlayton@kernel.org>
    ceph: only use d_name directly when parent is locked

Xie XiuQi <xiexiuqi@huawei.com>
    sched/numa: Fix a possible divide-by-zero

Josh Collier <josh.d.collier@intel.com>
    IB/rdmavt: Fix frwr memory registration

Peter Zijlstra <peterz@infradead.org>
    trace: Fix preempt_enable_no_resched() abuse

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: scall64-o32: Fix indirect syscall number load

YueHaibing <yuehaibing@huawei.com>
    lib/Kconfig.debug: fix build error without CONFIG_BLOCK

Jérôme Glisse <jglisse@redhat.com>
    zram: pass down the bvec we need to read into in the work struct

Jann Horn <jannh@google.com>
    tracing: Fix buffer_ref pipe ops

Wenwen Wang <wang6495@umn.edu>
    tracing: Fix a memory leak by early error exit in trace_pid_write()

Frank Sorenson <sorenson@redhat.com>
    cifs: do not attempt cifs operation on smb2+ rename error

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: simplify ld-option implementation


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt             |  1 +
 Makefile                                           |  4 +-
 arch/arm/boot/compressed/head.S                    | 16 ++++-
 arch/mips/kernel/scall64-o32.S                     |  2 +-
 arch/x86/Makefile                                  |  9 +++
 drivers/android/binder_alloc.c                     | 18 +++---
 drivers/block/loop.c                               | 58 +++++++++---------
 drivers/block/loop.h                               |  1 +
 drivers/block/zram/zram_drv.c                      |  5 +-
 drivers/dma/sh/rcar-dmac.c                         |  4 +-
 drivers/gpu/drm/i915/intel_fbdev.c                 | 12 ++--
 drivers/gpu/drm/vc4/vc4_crtc.c                     |  2 +-
 drivers/hwtracing/intel_th/gth.c                   |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c                  | 17 +++---
 drivers/input/rmi4/rmi_f11.c                       |  2 +-
 drivers/md/dm-integrity.c                          |  6 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  4 --
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |  8 ++-
 drivers/net/slip/slhc.c                            |  2 +-
 drivers/net/team/team.c                            |  6 ++
 drivers/usb/core/driver.c                          | 23 +++++--
 drivers/usb/core/hub.c                             | 16 ++---
 drivers/usb/core/message.c                         |  3 +-
 drivers/usb/core/sysfs.c                           |  5 +-
 drivers/usb/core/usb.h                             | 10 +++-
 drivers/vfio/vfio_iommu_type1.c                    | 14 +++++
 fs/ceph/dir.c                                      |  6 +-
 fs/ceph/mds_client.c                               | 70 ++++++++++++++++++----
 fs/ceph/snap.c                                     |  7 ++-
 fs/cifs/inode.c                                    |  4 ++
 fs/ext4/xattr.c                                    |  3 +
 fs/nfs/super.c                                     |  3 +-
 fs/nfsd/nfs4callback.c                             |  8 ++-
 fs/nfsd/state.h                                    |  1 +
 fs/proc/proc_sysctl.c                              |  6 +-
 fs/splice.c                                        |  4 +-
 include/linux/pipe_fs_i.h                          |  1 +
 kernel/sched/deadline.c                            |  3 +-
 kernel/sched/fair.c                                |  4 ++
 kernel/trace/ring_buffer.c                         |  2 +-
 kernel/trace/trace.c                               | 33 +++++-----
 lib/Kconfig.debug                                  |  1 +
 mm/memory.c                                        |  9 ++-
 net/bridge/netfilter/ebtables.c                    |  3 +-
 net/ipv4/route.c                                   | 32 +++++++---
 net/ipv4/sysctl_net_ipv4.c                         |  5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  3 +-
 net/rds/ib_fmr.c                                   | 11 ++++
 net/rds/ib_rdma.c                                  |  3 -
 net/rose/af_rose.c                                 | 17 +++---
 net/rose/rose_link.c                               | 16 +++--
 net/rose/rose_loopback.c                           | 36 +++++------
 net/rose/rose_route.c                              |  8 +--
 net/rose/rose_timer.c                              | 30 ++++------
 net/sunrpc/cache.c                                 |  3 +
 net/tipc/netlink_compat.c                          | 24 ++++++--
 net/vmw_vsock/virtio_transport_common.c            | 22 ++++---
 scripts/Kbuild.include                             |  4 +-
 62 files changed, 424 insertions(+), 220 deletions(-)


