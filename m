Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA15CA9D
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfGBIGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfGBIGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F07C21479;
        Tue,  2 Jul 2019 08:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054760;
        bh=/GO2ZUvyDqdhntdSdfyLPK8UAUu07W6IXVdYtqu3Oe4=;
        h=From:To:Cc:Subject:Date:From;
        b=dixqrh/DPzPOjhkAchFWQ/X+MogCLaDzKta7+juRj85iyZPzgHZOR5ElHBmsop9Ag
         UlqhZPlLtOQG0uhaH7Rwe38ntQGAA6qiO2vp9adJcGkPEu+sxKWFuOl+ruYbgqril1
         fa+8ebi19zHXyYuznV9URNLJ+cE+RuIQ9vUZ+4mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/72] 4.19.57-stable review
Date:   Tue,  2 Jul 2019 10:01:01 +0200
Message-Id: <20190702080124.564652899@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.57-rc1
X-KernelTest-Deadline: 2019-07-04T08:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.57 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.57-rc1

Xin Long <lucien.xin@gmail.com>
    tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA: Directly cast the sockaddr union to sockaddr

Will Deacon <will.deacon@arm.com>
    futex: Update comments and docs about return values of arch futex code

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd

Will Deacon <will.deacon@arm.com>
    arm64: futex: Avoid copying out uninitialised stack in failed cmpxchg()

Martin KaFai Lau <kafai@fb.com>
    bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Martin KaFai Lau <kafai@fb.com>
    bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix unconnected udp hooks

Matt Mullins <mmullins@fb.com>
    bpf: fix nested bpf tracepoints with per-cpu data

Jonathan Lemon <jonathan.lemon@gmail.com>
    bpf: lpm_trie: check left child of last leftmost node for NULL

Martynas Pumputis <m@lambda.lt>
    bpf: simplify definition of BPF_FIB_LOOKUP related flags

Fei Li <lifei.shirley@bytedance.com>
    tun: wake up waitqueues after IFF_UP is set

Xin Long <lucien.xin@gmail.com>
    tipc: check msg->req data len in tipc_nl_compat_bearer_disable

Xin Long <lucien.xin@gmail.com>
    tipc: change to use register_pernet_device

YueHaibing <yuehaibing@huawei.com>
    team: Always enable vlan tx offload

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold sk after auth shkey is created successfully

Roland Hii <roland.king.guan.hii@intel.com>
    net: stmmac: set IC bit when transmitting frames with HW timestamp

Roland Hii <roland.king.guan.hii@intel.com>
    net: stmmac: fixed new system time seconds value calculation

JingYi Hou <houjingyi647@gmail.com>
    net: remove duplicate fetch in sock_getsockopt

Eric Dumazet <edumazet@google.com>
    net/packet: fix memory leak in packet_set_ring()

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop

YueHaibing <yuehaibing@huawei.com>
    bonding: Always enable vlan tx offload

Neil Horman <nhorman@tuxdriver.com>
    af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET

Wang Xin <xin.wang7@cn.bosch.com>
    eeprom: at24: fix unexpected timeout under high load

Paul Burton <paul.burton@mips.com>
    irqchip/mips-gic: Use the correct local interrupt map registers

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Clean up initialisation of the struct rpc_rqst

Geert Uytterhoeven <geert@linux-m68k.org>
    cpu/speculation: Warn on unsupported mitigations= parameter

Trond Myklebust <trondmy@gmail.com>
    NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Prevent possible overrun during bitmap operations

Thomas Gleixner <tglx@linutronix.de>
    x86/microcode: Fix the microcode load on CPU hotplug for real

Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
    x86/speculation: Allow guests to use SSBD even if host does not

Jan Kara <jack@suse.cz>
    scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

zhangyi (F) <yi.zhang@huawei.com>
    dm log writes: make sure super sector log updates are written in order

Colin Ian King <colin.king@canonical.com>
    mm/page_idle.c: fix oops because end_pfn is larger than max_pfn

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on !PageHuge

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fails

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: stratix10: fix divider entry for the emac clocks

Jann Horn <jannh@google.com>
    fs/binfmt_flat.c: make load_flat_shared_library() work

zhong jiang <zhongjiang@huawei.com>
    mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask

John Ogness <john.ogness@linutronix.de>
    fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: remove wait_end_transfer

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: move requests to cancelled_list

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: introduce cancelled_list

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: track number of TRBs per request

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: combine unaligned and zero flags

John Stultz <john.stultz@linaro.org>
    Revert "usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup"

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: Fix out-of-bounds read

Adeodato Simó <dato@net.com.org.es>
    net/9p: include trans_common.h to fix missing prototype warning.

Dominique Martinet <dominique.martinet@cea.fr>
    9p/trans_fd: put worker reqs on destroy

Dominique Martinet <dominique.martinet@cea.fr>
    9p/trans_fd: abort p9_read_work if req status changed

Dan Carpenter <dan.carpenter@oracle.com>
    9p: potential NULL dereference

Dominique Martinet <dominique.martinet@cea.fr>
    9p: p9dirent_read: check network-provided name length

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: remove useless check in cm_event_handler

Dominique Martinet <dominique.martinet@cea.fr>
    9p: acl: fix uninitialized iattr access

Tomas Bortoli <tomasbortoli@gmail.com>
    9p: Rename req to rreq in trans_fd

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: do not disconnect on down_interruptible EAGAIN

Tomas Bortoli <tomasbortoli@gmail.com>
    9p: Add refcount to p9_req_t

Tomas Bortoli <tomasbortoli@gmail.com>
    9p: rename p9_free_req() function

Dominique Martinet <dominique.martinet@cea.fr>
    9p: add a per-client fcall kmem_cache

Dominique Martinet <dominique.martinet@cea.fr>
    9p: embed fcall in req to round down buffer allocs

Matthew Wilcox <willy@infradead.org>
    9p: Use a slab for allocating requests

Dominique Martinet <dominique.martinet@cea.fr>
    9p/xen: fix check for xenbus_read error in front_probe

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close PSM sdma_progress sleep window

Sasha Levin <sashal@kernel.org>
    Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"

Nathan Chancellor <natechancellor@gmail.com>
    arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf header: Fix unchecked usage of strncpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf help: Remove needless use of strncpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui helpline: Use strlcpy() as a shorter form of strncpy() + explicit set nul


-------------

Diffstat:

 Documentation/robust-futexes.txt                   |   3 +-
 Makefile                                           |   4 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/include/asm/futex.h                     |   4 +-
 arch/arm64/include/asm/insn.h                      |   8 +
 arch/arm64/kernel/insn.c                           |  40 ++
 arch/arm64/net/bpf_jit.h                           |   4 +
 arch/arm64/net/bpf_jit_comp.c                      |  28 +-
 arch/mips/include/asm/mips-gic.h                   |  30 ++
 arch/x86/kernel/cpu/bugs.c                         |  11 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           |  35 +-
 arch/x86/kernel/cpu/microcode/core.c               |  15 +-
 arch/x86/kvm/mmu.c                                 |  11 +-
 drivers/clk/socfpga/clk-s10.c                      |   4 +-
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |  12 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   5 +-
 drivers/irqchip/irq-mips-gic.c                     |   4 +-
 drivers/md/dm-log-writes.c                         |  23 +-
 drivers/misc/eeprom/at24.c                         |  43 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 drivers/net/team/team.c                            |   2 +-
 drivers/net/tun.c                                  |  19 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +-
 drivers/scsi/vmw_pvscsi.c                          |   6 +-
 drivers/usb/dwc3/core.h                            |  15 +-
 drivers/usb/dwc3/gadget.c                          | 158 ++----
 drivers/usb/dwc3/gadget.h                          |  15 +
 fs/9p/acl.c                                        |   2 +-
 fs/binfmt_flat.c                                   |  23 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/proc/array.c                                    |   2 +-
 include/asm-generic/futex.h                        |   8 +-
 include/linux/bpf-cgroup.h                         |   8 +
 include/linux/sunrpc/xprt.h                        |   1 -
 include/net/9p/9p.h                                |   4 +
 include/net/9p/client.h                            |  71 +--
 include/uapi/linux/bpf.h                           |   6 +-
 kernel/bpf/lpm_trie.c                              |   9 +-
 kernel/bpf/syscall.c                               |   8 +
 kernel/bpf/verifier.c                              |  12 +-
 kernel/cpu.c                                       |   3 +
 kernel/trace/bpf_trace.c                           | 100 +++-
 kernel/trace/trace_branch.c                        |   4 -
 mm/hugetlb.c                                       |  29 +-
 mm/memory-failure.c                                |   7 +-
 mm/mempolicy.c                                     |   2 +-
 mm/page_idle.c                                     |   4 +-
 net/9p/client.c                                    | 551 +++++++++++----------
 net/9p/mod.c                                       |   9 +-
 net/9p/protocol.c                                  |  12 +-
 net/9p/trans_common.c                              |   1 +
 net/9p/trans_fd.c                                  |  64 ++-
 net/9p/trans_rdma.c                                |  37 +-
 net/9p/trans_virtio.c                              |  44 +-
 net/9p/trans_xen.c                                 |  17 +-
 net/core/filter.c                                  |   2 +
 net/core/sock.c                                    |   3 -
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/udp.c                                     |   8 +-
 net/packet/af_packet.c                             |  23 +-
 net/packet/internal.h                              |   1 +
 net/sctp/endpointola.c                             |   8 +-
 net/sunrpc/clnt.c                                  |   1 -
 net/sunrpc/xprt.c                                  |  91 ++--
 net/tipc/core.c                                    |  12 +-
 net/tipc/netlink_compat.c                          |  18 +-
 net/tipc/udp_media.c                               |   8 +-
 tools/perf/builtin-help.c                          |   2 +-
 tools/perf/ui/tui/helpline.c                       |   2 +-
 tools/perf/util/header.c                           |   2 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |  41 +-
 77 files changed, 1072 insertions(+), 747 deletions(-)


