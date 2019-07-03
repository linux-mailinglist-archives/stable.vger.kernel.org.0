Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5615DE07
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 08:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfGCG06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 02:26:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41263 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfGCG06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 02:26:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id q4so651196pgj.8;
        Tue, 02 Jul 2019 23:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9AAjd9fQpuULgGCPfQkRoomZAmi9JXp0xsP8AoyR+38=;
        b=m0J1q/AReaYnrOcGxa07KoORxQYvc7reWahMm/WH07qJyI/m1tM0QhfEUOKOlOTLfR
         y+UHxI9mZiQyPQ23SGm+4TK/0fk9fEK6nkDa4UA8XdiSrgM/rR771YsgcqxS7h6id70w
         OkkEYsZcdX6QLjUpTucG/y4WsiGZ3vNU2HSjNiaMqBzASa8oop7VnAMXN0troJKsjxnW
         m/5VKXKDXeNYQ9VTnIjOiNEggIB5akWKe5WdFZLanNh9HKpRFHG9vHt+DMr9rF9jD44N
         kPfBWmSKo+XIWFWrKF1Q8CuMUzlckxw/yxtG1J/H2DJaMSK8Px1ZIzRLELTLeJ2rsYTY
         A9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9AAjd9fQpuULgGCPfQkRoomZAmi9JXp0xsP8AoyR+38=;
        b=Vds27ga2s8/764I1O+EXHxxMmV7ACES9DM02cm5SMc0sY3OBrikVuC2yEbSw28aJoN
         hYjbWhHar4lt6EC4oXR1P9ZkvWayMfWYdFOWyb3NdhOxXZBlDOakyhJRuchmmt3SeIjM
         S4Xo16dcJ3M477kKix/bRG+vmki0/HoRjBGkXaBAf3B88rpKJjDiYRKioH6SqZFKb7fr
         z84Axly9621nfNJo0M8OiWfDfWIgYQCKkgfkQTmkSZQexBgAaS7Ia086L+iotQbhNElo
         lXuSTNLS+Fqv9gecHz8++KC51o52jDhGnRNAL9hpd0xOhyEXe3bvgTWyRgAz1pv59Aol
         9j6Q==
X-Gm-Message-State: APjAAAVMDlBCw7lkZpgZrbPgek3Vdq0H2xEIC7fopMAEPVNEmhIhVstM
        I8PH0CXNXVKLCO34+Y+Y3dg=
X-Google-Smtp-Source: APXvYqyGvGKhJgwBrao1mhFtIw2jf+2yCdnYAvKFWU452RZ5EgH3SB6pTO7jwPcZkXUjU2FpLUUD3A==
X-Received: by 2002:a63:190d:: with SMTP id z13mr25992932pgl.191.1562135217185;
        Tue, 02 Jul 2019 23:26:57 -0700 (PDT)
Received: from Shreeya-Patel ([43.241.146.219])
        by smtp.googlemail.com with ESMTPSA id a21sm2542795pgd.45.2019.07.02.23.26.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 23:26:56 -0700 (PDT)
Message-ID: <9f516d1b8c51de7b1068200a56c3dbf194575860.camel@gmail.com>
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
From:   Shreeya Patel <shreeya.patel23498@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     skhan@linuxfoundation.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Wed, 03 Jul 2019 11:56:50 +0530
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-07-02 at 10:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.16 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions.

Thanks

> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.1.16-rc1
> 
> Xin Long <lucien.xin@gmail.com>
>     tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb
> 
> Amir Goldstein <amir73il@gmail.com>
>     fanotify: update connector fsid cache on add mark
> 
> Jason Gunthorpe <jgg@ziepe.ca>
>     RDMA: Directly cast the sockaddr union to sockaddr
> 
> Will Deacon <will.deacon@arm.com>
>     futex: Update comments and docs about return values of arch futex
> code
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd
> 
> Will Deacon <will.deacon@arm.com>
>     arm64: futex: Avoid copying out uninitialised stack in failed
> cmpxchg()
> 
> Martin KaFai Lau <kafai@fb.com>
>     bpf: udp: ipv6: Avoid running reuseport's bpf_prog from
> __udp6_lib_err
> 
> Martin KaFai Lau <kafai@fb.com>
>     bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: fix unconnected udp hooks
> 
> Matt Mullins <mmullins@fb.com>
>     bpf: fix nested bpf tracepoints with per-cpu data
> 
> Jonathan Lemon <jonathan.lemon@gmail.com>
>     bpf: lpm_trie: check left child of last leftmost node for NULL
> 
> Martynas Pumputis <m@lambda.lt>
>     bpf: simplify definition of BPF_FIB_LOOKUP related flags
> 
> Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
>     net: aquantia: fix vlans not working over bridged network
> 
> Fei Li <lifei.shirley@bytedance.com>
>     tun: wake up waitqueues after IFF_UP is set
> 
> Xin Long <lucien.xin@gmail.com>
>     tipc: check msg->req data len in tipc_nl_compat_bearer_disable
> 
> Xin Long <lucien.xin@gmail.com>
>     tipc: change to use register_pernet_device
> 
> YueHaibing <yuehaibing@huawei.com>
>     team: Always enable vlan tx offload
> 
> Xin Long <lucien.xin@gmail.com>
>     sctp: change to hold sk after auth shkey is created successfully
> 
> Dirk van der Merwe <dirk.vandermerwe@netronome.com>
>     net/tls: fix page double free on TX cleanup
> 
> Roland Hii <roland.king.guan.hii@intel.com>
>     net: stmmac: set IC bit when transmitting frames with HW
> timestamp
> 
> Roland Hii <roland.king.guan.hii@intel.com>
>     net: stmmac: fixed new system time seconds value calculation
> 
> JingYi Hou <houjingyi647@gmail.com>
>     net: remove duplicate fetch in sock_getsockopt
> 
> Eric Dumazet <edumazet@google.com>
>     net/packet: fix memory leak in packet_set_ring()
> 
> Stephen Suryaputra <ssuryaextr@gmail.com>
>     ipv4: Use return value of inet_iif() for __raw_v4_lookup in the
> while loop
> 
> YueHaibing <yuehaibing@huawei.com>
>     bonding: Always enable vlan tx offload
> 
> Neil Horman <nhorman@tuxdriver.com>
>     af_packet: Block execution of tasks waiting for transmit to
> complete in AF_PACKET
> 
> Paul Burton <paul.burton@mips.com>
>     irqchip/mips-gic: Use the correct local interrupt map registers
> 
> Trond Myklebust <trondmy@gmail.com>
>     SUNRPC: Fix up calculation of client message length
> 
> Geert Uytterhoeven <geert@linux-m68k.org>
>     cpu/speculation: Warn on unsupported mitigations= parameter
> 
> Trond Myklebust <trondmy@gmail.com>
>     NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O
> 
> Ard Biesheuvel <ard.biesheuvel@linaro.org>
>     efi/memreserve: deal with memreserve entries in unmapped memory
> 
> Johannes Weiner <hannes@cmpxchg.org>
>     mm: fix page cache convergence regression
> 
> Reinette Chatre <reinette.chatre@intel.com>
>     x86/resctrl: Prevent possible overrun during bitmap operations
> 
> Thomas Gleixner <tglx@linutronix.de>
>     x86/microcode: Fix the microcode load on CPU hotplug for real
> 
> Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>     x86/speculation: Allow guests to use SSBD even if host does not
> 
> Jan Kara <jack@suse.cz>
>     scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
> 
> Jens Axboe <axboe@kernel.dk>
>     io_uring: ensure req->file is cleared on allocation
> 
> zhangyi (F) <yi.zhang@huawei.com>
>     dm log writes: make sure super sector log updates are written in
> order
> 
> Gen Zhang <blackgod016574@gmail.com>
>     dm init: fix incorrect uses of kstrndup()
> 
> Huang Ying <ying.huang@intel.com>
>     mm, swap: fix THP swap out
> 
> Colin Ian King <colin.king@canonical.com>
>     mm/page_idle.c: fix oops because end_pfn is larger than max_pfn
> 
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero
> on !PageHuge
> 
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page()
> fails
> 
> Ville Syrjälä <ville.syrjala@linux.intel.com>
>     drm/i915: Skip modeset for cdclk changes if possible
> 
> Imre Deak <imre.deak@intel.com>
>     drm/i915: Remove redundant store of logical CDCLK state
> 
> Imre Deak <imre.deak@intel.com>
>     drm/i915: Save the old CDCLK atomic state
> 
> Ville Syrjälä <ville.syrjala@linux.intel.com>
>     drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio power is
> enabled
> 
> Dinh Nguyen <dinguyen@kernel.org>
>     clk: socfpga: stratix10: fix divider entry for the emac clocks
> 
> Jon Hunter <jonathanh@nvidia.com>
>     clk: tegra210: Fix default rates for HDA clocks
> 
> Jann Horn <jannh@google.com>
>     fs/binfmt_flat.c: make load_flat_shared_library() work
> 
> zhong jiang <zhongjiang@huawei.com>
>     mm/mempolicy.c: fix an incorrect rebind node in
> mpol_rebind_nodemask
> 
> John Ogness <john.ogness@linutronix.de>
>     fs/proc/array.c: allow reporting eip/esp for all coredumping
> threads
> 
> Bjørn Mork <bjorn@mork.no>
>     qmi_wwan: Fix out-of-bounds read
> 
> Sasha Levin <sashal@kernel.org>
>     Revert "x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP"
> 
> Nathan Chancellor <natechancellor@gmail.com>
>     arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS
> 
> 
> -------------
> 
> Diffstat:
> 
>  Documentation/robust-futexes.txt                   |   3 +-
>  Makefile                                           |   4 +-
>  arch/arm64/Makefile                                |   2 +-
>  arch/arm64/include/asm/futex.h                     |   4 +-
>  arch/arm64/include/asm/insn.h                      |   8 +
>  arch/arm64/kernel/insn.c                           |  40 +++++
>  arch/arm64/net/bpf_jit.h                           |   4 +
>  arch/arm64/net/bpf_jit_comp.c                      |  28 +++-
>  arch/mips/include/asm/mips-gic.h                   |  30 ++++
>  arch/x86/kernel/cpu/bugs.c                         |  11 +-
>  arch/x86/kernel/cpu/microcode/core.c               |  15 +-
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  35 ++--
>  drivers/clk/socfpga/clk-s10.c                      |   4 +-
>  drivers/clk/tegra/clk-tegra210.c                   |   2 +
>  drivers/firmware/efi/efi.c                         |  12 +-
>  drivers/gpu/drm/i915/i915_drv.h                    |   6 +-
>  drivers/gpu/drm/i915/intel_audio.c                 |  62 ++++++-
>  drivers/gpu/drm/i915/intel_cdclk.c                 | 185
> +++++++++++++++------
>  drivers/gpu/drm/i915/intel_display.c               |  57 ++++++-
>  drivers/gpu/drm/i915/intel_drv.h                   |  21 ++-
>  drivers/infiniband/core/addr.c                     |  16 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   5 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   5 +-
>  drivers/irqchip/irq-mips-gic.c                     |   4 +-
>  drivers/md/dm-init.c                               |   6 +-
>  drivers/md/dm-log-writes.c                         |  23 ++-
>  drivers/net/bonding/bond_main.c                    |   2 +-
>  .../net/ethernet/aquantia/atlantic/aq_filters.c    |  10 +-
>  drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   1 +
>  drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |   1 +
>  .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  19 ++-
>  .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 ++-
>  drivers/net/team/team.c                            |   2 +-
>  drivers/net/tun.c                                  |  19 +--
>  drivers/net/usb/qmi_wwan.c                         |   2 +-
>  drivers/scsi/vmw_pvscsi.c                          |   6 +-
>  fs/binfmt_flat.c                                   |  23 +--
>  fs/inode.c                                         |   2 +-
>  fs/io_uring.c                                      |   5 +-
>  fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
>  fs/notify/fanotify/fanotify.c                      |   4 +
>  fs/notify/mark.c                                   |  14 +-
>  fs/proc/array.c                                    |   2 +-
>  include/asm-generic/futex.h                        |   8 +-
>  include/linux/bpf-cgroup.h                         |   8 +
>  include/linux/fsnotify_backend.h                   |   4 +-
>  include/linux/xarray.h                             |   1 +
>  include/net/tls.h                                  |  15 --
>  include/uapi/linux/bpf.h                           |   6 +-
>  kernel/bpf/lpm_trie.c                              |   9 +-
>  kernel/bpf/syscall.c                               |   8 +
>  kernel/bpf/verifier.c                              |  12 +-
>  kernel/cpu.c                                       |   3 +
>  kernel/trace/bpf_trace.c                           | 100 +++++++++--
>  kernel/trace/trace_branch.c                        |   4 -
>  lib/xarray.c                                       |  12 +-
>  mm/hugetlb.c                                       |  29 +++-
>  mm/memory-failure.c                                |   7 +-
>  mm/mempolicy.c                                     |   2 +-
>  mm/page_idle.c                                     |   4 +-
>  mm/page_io.c                                       |   7 +-
>  net/core/filter.c                                  |   2 +
>  net/core/sock.c                                    |   3 -
>  net/ipv4/raw.c                                     |   2 +-
>  net/ipv4/udp.c                                     |  10 +-
>  net/ipv6/udp.c                                     |   8 +-
>  net/packet/af_packet.c                             |  23 ++-
>  net/packet/internal.h                              |   1 +
>  net/sctp/endpointola.c                             |   8 +-
>  net/sunrpc/xprtsock.c                              |  16 +-
>  net/tipc/core.c                                    |  12 +-
>  net/tipc/netlink_compat.c                          |  18 +-
>  net/tipc/udp_media.c                               |   8 +-
>  net/tls/tls_main.c                                 |   3 +-
>  tools/testing/selftests/bpf/test_lpm_map.c         |  41 ++++-
>  76 files changed, 830 insertions(+), 294 deletions(-)
> 
> 

