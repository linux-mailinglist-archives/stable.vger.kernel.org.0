Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E5A5CB34
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfGBIJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbfGBIJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B73621852;
        Tue,  2 Jul 2019 08:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054980;
        bh=NSzTonMBiKCPb9gXx7Edd5QoNBlC2RBlWPEqXZ7Y0/g=;
        h=From:To:Cc:Subject:Date:From;
        b=vgNi4GAXfFECRL63e8xcLdudTBFtS+T7IpJXE3vNjjtN0kQmPGq+IUYZ06goDrRvU
         vTFrloyjqdkFKZo6zq2iaFsSdQz86sGfDFmCPnJrlw/mzxVsWDxviLU2B/d9zAOER5
         CjGz638Nrvaioc5imhO0yAJ4Jd9iCsm+lvd2oUPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/43] 4.14.132-stable review
Date:   Tue,  2 Jul 2019 10:01:40 +0200
Message-Id: <20190702080123.904399496@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.132-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.132-rc1
X-KernelTest-Deadline: 2019-07-04T08:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.132 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.132-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.132-rc1

Xin Long <lucien.xin@gmail.com>
    tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

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

YueHaibing <yuehaibing@huawei.com>
    bonding: Always enable vlan tx offload

YueHaibing <yuehaibing@huawei.com>
    team: Always enable vlan tx offload

Fei Li <lifei.shirley@bytedance.com>
    tun: wake up waitqueues after IFF_UP is set

Xin Long <lucien.xin@gmail.com>
    tipc: check msg->req data len in tipc_nl_compat_bearer_disable

Xin Long <lucien.xin@gmail.com>
    tipc: change to use register_pernet_device

Xin Long <lucien.xin@gmail.com>
    sctp: change to hold sk after auth shkey is created successfully

Roland Hii <roland.king.guan.hii@intel.com>
    net: stmmac: fixed new system time seconds value calculation

JingYi Hou <houjingyi647@gmail.com>
    net: remove duplicate fetch in sock_getsockopt

Eric Dumazet <edumazet@google.com>
    net/packet: fix memory leak in packet_set_ring()

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop

Neil Horman <nhorman@tuxdriver.com>
    af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET

Wang Xin <xin.wang7@cn.bosch.com>
    eeprom: at24: fix unexpected timeout under high load

Geert Uytterhoeven <geert@linux-m68k.org>
    cpu/speculation: Warn on unsupported mitigations= parameter

Trond Myklebust <trondmy@gmail.com>
    NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O

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

Jann Horn <jannh@google.com>
    fs/binfmt_flat.c: make load_flat_shared_library() work

zhong jiang <zhongjiang@huawei.com>
    mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask

John Ogness <john.ogness@linutronix.de>
    fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Sasha Levin <sashal@kernel.org>
    Revert "compiler.h: update definition of unreachable()"

Kristian Evensen <kristian.evensen@gmail.com>
    qmi_wwan: Fix out-of-bounds read

Adeodato Simó <dato@net.com.org.es>
    net/9p: include trans_common.h to fix missing prototype warning.

Dominique Martinet <dominique.martinet@cea.fr>
    9p: p9dirent_read: check network-provided name length

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: remove useless check in cm_event_handler

Dominique Martinet <dominique.martinet@cea.fr>
    9p: acl: fix uninitialized iattr access

Dominique Martinet <dominique.martinet@cea.fr>
    9p/rdma: do not disconnect on down_interruptible EAGAIN

Dominique Martinet <dominique.martinet@cea.fr>
    9p/xen: fix check for xenbus_read error in front_probe

Martin Wilck <mwilck@suse.com>
    block: bio_iov_iter_get_pages: pin more pages for multi-segment IOs

Christoph Hellwig <hch@lst.de>
    block: add a lower-level bio_add_page interface

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close PSM sdma_progress sleep window

Sasha Levin <sashal@kernel.org>
    Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"

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
 arch/arm64/include/asm/futex.h                     |   4 +-
 arch/arm64/include/asm/insn.h                      |   8 ++
 arch/arm64/kernel/insn.c                           |  40 +++++++
 arch/arm64/net/bpf_jit.h                           |   4 +
 arch/arm64/net/bpf_jit_comp.c                      |  28 +++--
 arch/x86/kernel/cpu/bugs.c                         |  11 +-
 arch/x86/kernel/cpu/microcode/core.c               |  15 ++-
 block/bio.c                                        | 131 +++++++++++++++------
 drivers/infiniband/hw/hfi1/user_sdma.c             |  12 +-
 drivers/infiniband/hw/hfi1/user_sdma.h             |   1 -
 drivers/md/dm-log-writes.c                         |  23 +++-
 drivers/misc/eeprom/at24.c                         | 107 ++++++++++++-----
 drivers/net/bonding/bond_main.c                    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   2 +-
 drivers/net/team/team.c                            |   2 +-
 drivers/net/tun.c                                  |  19 ++-
 drivers/net/usb/qmi_wwan.c                         |   4 +-
 drivers/scsi/vmw_pvscsi.c                          |   6 +-
 fs/9p/acl.c                                        |   2 +-
 fs/binfmt_flat.c                                   |  23 ++--
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/proc/array.c                                    |   2 +-
 include/asm-generic/futex.h                        |   8 +-
 include/linux/bio.h                                |   9 ++
 include/linux/compiler.h                           |   5 +-
 kernel/cpu.c                                       |   3 +
 kernel/trace/trace_branch.c                        |   4 -
 mm/mempolicy.c                                     |   2 +-
 mm/page_idle.c                                     |   4 +-
 net/9p/protocol.c                                  |  12 +-
 net/9p/trans_common.c                              |   1 +
 net/9p/trans_rdma.c                                |   7 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/core/sock.c                                    |   3 -
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/udp.c                                     |   4 +-
 net/packet/af_packet.c                             |  23 +++-
 net/packet/internal.h                              |   1 +
 net/sctp/endpointola.c                             |   8 +-
 net/tipc/core.c                                    |  12 +-
 net/tipc/netlink_compat.c                          |  18 ++-
 net/tipc/udp_media.c                               |   8 +-
 tools/perf/builtin-help.c                          |   2 +-
 tools/perf/ui/tui/helpline.c                       |   2 +-
 tools/perf/util/header.c                           |   2 +-
 48 files changed, 418 insertions(+), 187 deletions(-)


