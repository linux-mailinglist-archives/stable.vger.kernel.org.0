Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D287AF7CE
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfD3MCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbfD3Ln4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D139B21707;
        Tue, 30 Apr 2019 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624635;
        bh=73VhEmy6woEBZkKz9ujGyU0MaHzcAgS+5Qtm1EEIWXo=;
        h=From:To:Cc:Subject:Date:From;
        b=Hq2nXJOaugNfxpnT4wbnl4U5uhWmBy40VKeM/BHqsCkWmYSbEa0W3pTAZCazwOAiW
         /HqLA1kIFlloaJFQW2bfq1L8hGGJoIruIseTaMAuzO4VrAKLl/sh0L/QfRekVR2oTs
         vKOEk+F/frCBAK5lij7rHUN8Gzeb/wwsnHAdB+Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/100] 4.19.38-stable review
Date:   Tue, 30 Apr 2019 13:37:29 +0200
Message-Id: <20190430113608.616903219@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.38-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.38-rc1
X-KernelTest-Deadline: 2019-05-02T11:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.38 release.
There are 100 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 02 May 2019 11:34:55 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.38-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.38-rc1

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: don't leak IV and record seq when offload fails

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: avoid potential deadlock in tls_set_device_offload_rx()

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix use-after-free after xdp_return_frame

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix the max MTU check in case of XDP

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Put MC TCs into DWRR mode

Ido Schimmel <idosch@mellanox.com>
    mlxsw: pci: Reincrease PCI reset timeout

Jun Xiao <xiaojun2@hisilicon.com>
    net: hns: Fix WARNING when hns modules installed

Hangbin Liu <liuhangbin@gmail.com>
    team: fix possible recursive locking when add slaves

Su Bao Cheng <baocheng.su@siemens.com>
    stmmac: pci: Adjust IOT2000 matching

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix refcount adjustment in fallback

Vinod Koul <vkoul@kernel.org>
    net: stmmac: move stmmac_check_ether_addr() to driver probe

Eric Dumazet <edumazet@google.com>
    net/rose: fix unbound loop in rose_loopback_timer()

Zhu Yanjun <yanjun.zhu@oracle.com>
    net: rds: exchange of 8K and 1M pool

Erez Alfasi <ereza@mellanox.com>
    net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query

Amit Cohen <amitc@mellanox.com>
    mlxsw: spectrum: Fix autoneg status in ethtool

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    ipv4: set the tcp_min_rtt_wlen range from 0 to one day

Eric Dumazet <edumazet@google.com>
    ipv4: add sanity checks in ipv4_link_failure()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    x86/fpu: Don't export __kernel_fpu_{begin,end}()

Jan Kara <jack@suse.cz>
    mm: Fix warning in insert_pfn()

Daniel Borkmann <daniel@iogearbox.net>
    x86/retpolines: Disable switch jump tables when retpolines are enabled

Daniel Borkmann <daniel@iogearbox.net>
    x86, retpolines: Raise limit for generating indirect calls from switch-case

Al Viro <viro@zeniv.linux.org.uk>
    Fix aio_poll() races

Al Viro <viro@zeniv.linux.org.uk>
    aio: store event at final iocb_put()

Al Viro <viro@zeniv.linux.org.uk>
    aio: keep io_event in aio_kiocb

Al Viro <viro@zeniv.linux.org.uk>
    aio: fold lookup_kiocb() into its sole caller

Linus Torvalds <torvalds@linux-foundation.org>
    pin iocb through aio.

Linus Torvalds <torvalds@linux-foundation.org>
    aio: simplify - and fix - fget/fput for io_submit()

Mike Marshall <hubcap@omnibond.com>
    aio: initialize kiocb private in case any filesystems expect it.

Jens Axboe <axboe@kernel.dk>
    aio: abstract out io_event filler helper

Jens Axboe <axboe@kernel.dk>
    aio: split out iocb copy from io_submit_one()

Jens Axboe <axboe@kernel.dk>
    aio: use iocb_put() instead of open coding it

Jens Axboe <axboe@kernel.dk>
    aio: don't zero entire aio_kiocb aio_get_req()

Christoph Hellwig <hch@lst.de>
    aio: separate out ring reservation from req allocation

Jens Axboe <axboe@kernel.dk>
    aio: use assigned completion handler

Christoph Hellwig <hch@lst.de>
    aio: clear IOCB_HIPRI

Eric Dumazet <edumazet@google.com>
    rxrpc: fix race condition in rxrpc_input_packet()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/rds: Check address length before reading address family

YueHaibing <yuehaibing@huawei.com>
    net: netrom: Fix error cleanup path of nr_proto_init

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

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    workqueue: Try to catch flush_work() without INIT_WORK().

YueHaibing <yuehaibing@huawei.com>
    fs/proc/proc_sysctl.c: Fix a NULL pointer dereference

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: gth: Fix an off-by-one in output unassigning

Linus Torvalds <torvalds@linux-foundation.org>
    slip: make slhc_free() silently accept an error pointer

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

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/mm/radix: Make Radix require HUGETLB_PAGE

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the cache

Achim Dahlhoff <Achim.Dahlhoff@de.bosch.com>
    dmaengine: sh: rcar-dmac: Fix glitch in dmaengine_tx_status

Dirk Behme <dirk.behme@de.bosch.com>
    dmaengine: sh: rcar-dmac: With cyclic DMA residue 0 is valid

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Limit DMA mappings per container

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - write config register values to the right offset

Harry Pan <harry.pan@intel.com>
    perf/x86/intel: Update KBL Package C-state events to also include PC8/PC9/PC10 counters

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

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Do not allow the user to write to the clock page

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

Baolin Wang <baolin.wang@linaro.org>
    gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC

Jann Horn <jannh@google.com>
    tracing: Fix buffer_ref pipe ops

Wenwen Wang <wang6495@umn.edu>
    tracing: Fix a memory leak by early error exit in trace_pid_write()

Frank Sorenson <sorenson@redhat.com>
    cifs: do not attempt cifs operation on smb2+ rename error

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix memory leak in SMB2_read

Heiner Kallweit <hkallweit1@gmail.com>
    net: dsa: mv88e6xxx: add call to mv88e6xxx_ports_cmode_init to probe for new DSA framework

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix build error without CONFIG_PCI

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64

Andrea Claudi <aclaudi@redhat.com>
    ipvs: fix warning on unused variable

Adalbert Lazăr <alazar@bitdefender.com>
    vsock/virtio: fix kernel panic from virtio_transport_reset_no_sock

Damian Kos <dkos@cadence.com>
    drm/rockchip: fix for mailbox read validation.

Dongli Zhang <dongli.zhang@oracle.com>
    loop: do not print warn message if partition scan is successful

Xin Long <lucien.xin@gmail.com>
    tipc: handle the err returned from cmd header function

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: fix some error pointer dereferences

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix validate for PPv2.1

Thomas Falcon <tlfalcon@linux.ibm.com>
    net/ibmvnic: Fix RTNL deadlock during device reset

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bogus EBUSY in helper removal from transaction

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bogus EBUSY when deleting set after flush

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix set double-free in abort path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_compat: use .release_ops and remove list of extension

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: don't use refcount_inc on newly allocated entry

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: unbind set in rule from commit path

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: warn when expr implements only one of activate/deactivate

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: destroy function must not have side effects

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: split set destruction in deactivate and destroy phase

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: make lists per netns

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: use refcnt_t type for nft_xt reference count


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt             |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |  16 +-
 arch/mips/kernel/scall64-o32.S                     |   2 +-
 arch/powerpc/configs/skiroot_defconfig             |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   2 +-
 arch/powerpc/platforms/Kconfig.cputype             |   2 +-
 arch/x86/Makefile                                  |   9 +
 arch/x86/events/intel/cstate.c                     |  10 +-
 arch/x86/include/asm/efi.h                         |   6 +-
 arch/x86/include/asm/fpu/api.h                     |  15 +-
 arch/x86/kernel/fpu/core.c                         |   6 +-
 drivers/android/binder_alloc.c                     |  18 +-
 drivers/block/loop.c                               |   5 +-
 drivers/block/zram/zram_drv.c                      |   5 +-
 drivers/dma/sh/rcar-dmac.c                         |  30 +-
 drivers/gpio/gpio-eic-sprd.c                       |   1 +
 drivers/gpu/drm/i915/intel_fbdev.c                 |  12 +-
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   2 +-
 drivers/hwtracing/intel_th/gth.c                   |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +
 drivers/infiniband/sw/rdmavt/mr.c                  |  17 +-
 drivers/input/rmi4/rmi_f11.c                       |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  15 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |   2 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   4 -
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   8 +-
 drivers/net/slip/slhc.c                            |   2 +-
 drivers/net/team/team.c                            |   7 +
 drivers/usb/core/driver.c                          |  23 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/message.c                         |   3 +-
 drivers/usb/core/sysfs.c                           |   5 +-
 drivers/usb/core/usb.h                             |  10 +-
 drivers/vfio/vfio_iommu_type1.c                    |  14 +
 fs/aio.c                                           | 366 ++++++++++-----------
 fs/ceph/dir.c                                      |   6 +-
 fs/ceph/mds_client.c                               |  70 +++-
 fs/ceph/snap.c                                     |   7 +-
 fs/cifs/inode.c                                    |   4 +
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/ext4/xattr.c                                    |   3 +
 fs/nfs/super.c                                     |   3 +-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/state.h                                    |   1 +
 fs/proc/proc_sysctl.c                              |   6 +-
 fs/splice.c                                        |   4 +-
 include/linux/fs.h                                 |   8 +-
 include/linux/pipe_fs_i.h                          |   1 +
 include/net/netfilter/nf_tables.h                  |  29 +-
 include/net/netrom.h                               |   2 +-
 kernel/sched/deadline.c                            |   3 +-
 kernel/sched/fair.c                                |   4 +
 kernel/trace/ring_buffer.c                         |   2 +-
 kernel/trace/trace.c                               |  33 +-
 kernel/workqueue.c                                 |   3 +
 lib/Kconfig.debug                                  |   1 +
 mm/memory.c                                        |   9 +-
 net/bridge/netfilter/ebtables.c                    |   3 +-
 net/ipv4/route.c                                   |  32 +-
 net/ipv4/sysctl_net_ipv4.c                         |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   3 +-
 net/netfilter/nf_tables_api.c                      | 108 ++++--
 net/netfilter/nft_compat.c                         | 192 +++--------
 net/netfilter/nft_dynset.c                         |  22 +-
 net/netfilter/nft_immediate.c                      |   6 +-
 net/netfilter/nft_lookup.c                         |  21 +-
 net/netfilter/nft_objref.c                         |  40 ++-
 net/netrom/af_netrom.c                             |  76 +++--
 net/netrom/nr_loopback.c                           |   2 +-
 net/netrom/nr_route.c                              |   2 +-
 net/netrom/sysctl_net_netrom.c                     |   5 +-
 net/rds/af_rds.c                                   |   3 +
 net/rds/bind.c                                     |   2 +
 net/rds/ib_fmr.c                                   |  11 +
 net/rds/ib_rdma.c                                  |   3 -
 net/rose/rose_loopback.c                           |  27 +-
 net/rxrpc/input.c                                  |  12 +-
 net/rxrpc/local_object.c                           |   3 +-
 net/sunrpc/cache.c                                 |   3 +
 net/tipc/netlink_compat.c                          |  24 +-
 net/tls/tls_device.c                               |   4 +-
 net/tls/tls_device_fallback.c                      |  13 +-
 net/tls/tls_main.c                                 |   5 +-
 net/tls/tls_sw.c                                   |   3 +
 net/vmw_vsock/virtio_transport_common.c            |  22 +-
 sound/pci/hda/patch_ca0132.c                       |   4 +-
 98 files changed, 969 insertions(+), 593 deletions(-)


