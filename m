Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D452F5AAF24
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiIBMeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbiIBMde (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:33:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF7D83C1;
        Fri,  2 Sep 2022 05:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8504FB82A9E;
        Fri,  2 Sep 2022 12:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8244DC433D7;
        Fri,  2 Sep 2022 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121517;
        bh=b1GPo0vnchsMNvlyxujAoR9CsGG9G5sI5nZeKUrzhpI=;
        h=From:To:Cc:Subject:Date:From;
        b=MJQYE9aiCwWEKNYq5ho/k/e1eEXsnQjwLDBXUuRVFbzm+GR0kOX8YbBZ3FYzqanRT
         cMJyT0oHBVHrTEjeIExk5mXT+eO5NjCl6r9lVVCBtcfw2XJSaIAaU+msRzfzQXl4u+
         FR2i0VLLa9BXNUgno5P/bIhXfqoLI1W2Kpq6iYl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/56] 4.19.257-rc1 review
Date:   Fri,  2 Sep 2022 14:18:20 +0200
Message-Id: <20220902121400.219861128@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.257-rc1
X-KernelTest-Deadline: 2022-09-04T12:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.257 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.257-rc1

Yang Yingliang <yangyingliang@huawei.com>
    net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

Geert Uytterhoeven <geert@linux-m68k.org>
    netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Juergen Gross <jgross@suse.com>
    s390/hypfs: avoid error message under KVM

Denis V. Lunev <den@openvz.org>
    neigh: fix possible DoS due to net iface start/stop loop

Fudong Wang <Fudong.Wang@amd.com>
    drm/amd/display: clear optc underflow before turn off odm clock

Jann Horn <jannh@google.com>
    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Yang Jihong <yangjihong1@huawei.com>
    ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error

Karthik Alapati <mail@karthek.com>
    HID: hidraw: fix memory leak in hidraw_release()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: pvrusb2: fix memory leak in pvr_probe

Lee Jones <lee.jones@linaro.org>
    HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix build errors in some archs

Jing Leng <jleng@ambarella.com>
    kbuild: Fix include path in scripts/Makefile.modpost

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add "unknown" reporting for MMIO Stale Data

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Fix test_align verifier log patterns

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: map FDT as RW for early_init_dt_scan()

Jann Horn <jannh@google.com>
    mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Guoqing Jiang <guoqing.jiang@linux.dev>
    md: call __md_stop_writes in md_stop

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Brian Foster <bfoster@redhat.com>
    s390: fix double free of GS and RI CBs on fork() failure

Quanyang Wang <quanyang.wang@windriver.com>
    asm-generic: sections: refactor memory_intersects

Siddh Raman Pant <code@siddh.me>
    loop: Check for overflow while configuring loop

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: check if root is readonly while setting security xattr

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_somaxconn.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_budget_usecs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around netdev_budget.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_read.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_poll.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_tstamp_allow_data.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ratelimit: Fix data-races in ___ratelimit().

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around netdev_tstamp_prequeue.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around weight_p and dev_weight_[rt]x_bias.

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_tunnel: restrict it to netdev family

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: do not truncate csum_offset and csum_type

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: report ERANGE for too long offset and length

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: reject blobs that don't provide all entry points

Maciej Żenczykowski <maze@google.com>
    net: ipvtap - add __init/__exit annotations to module init/exit funcs

Jonathan Toppins <jtoppins@redhat.com>
    bonding: 802.3ad: fix no transmission of LACPDUs

Bernard Pidoux <f6bvp@free.fr>
    rose: check NULL rose_loopback_neigh->loopback

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Do not call xfrm_probe_algs in parallel

Xin Xiong <xiongx18@fudan.edu.cn>
    xfrm: fix refcount leak in __xfrm_policy_check()

Hui Su <suhui_kernel@163.com>
    kernel/sched: Remove dl_boosted flag comment

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix priority inheritance with multiple scheduling classes

Lucas Stach <l.stach@pengutronix.de>
    sched/deadline: Fix stale throttling on de-/boosted tasks

Daniel Bristot de Oliveira <bristot@redhat.com>
    sched/deadline: Unthrottle PI boosted threads while enqueuing

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    pinctrl: amd: Don't save/restore interrupt status and wake status bits

Randy Dunlap <rdunlap@infradead.org>
    kernel/sys_ni: add compat entry for fadvise64_64

Helge Deller <deller@gmx.de>
    parisc: Fix exception handler for fldw and fstw instructions

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix potential double free on error path from fsnotify_add_inode_mark


-------------

Diffstat:

 .../hw-vuln/processor_mmio_stale_data.rst          |  14 +++
 Makefile                                           |   4 +-
 arch/arm64/include/asm/mmu.h                       |   2 +-
 arch/arm64/kernel/kaslr.c                          |   5 +-
 arch/arm64/kernel/setup.c                          |   9 +-
 arch/arm64/mm/mmu.c                                |  15 +--
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/s390/hypfs/hypfs_diag.c                       |   2 +-
 arch/s390/hypfs/inode.c                            |   2 +-
 arch/s390/kernel/process.c                         |  22 +++-
 arch/s390/mm/fault.c                               |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 ++-
 arch/x86/kernel/cpu/common.c                       |  34 ++++--
 arch/x86/kernel/unwind_orc.c                       |  15 ++-
 drivers/block/loop.c                               |   5 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |   5 +
 drivers/hid/hid-steam.c                            |  10 ++
 drivers/hid/hidraw.c                               |   3 +
 drivers/md/md.c                                    |   1 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   1 +
 drivers/net/bonding/bond_3ad.c                     |  38 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |  59 ++++++++--
 drivers/net/ipvlan/ipvtap.c                        |   4 +-
 drivers/pinctrl/pinctrl-amd.c                      |  11 +-
 drivers/scsi/storvsc_drv.c                         |   2 +-
 drivers/video/fbdev/pm2fb.c                        |   5 +
 fs/btrfs/xattr.c                                   |   3 +
 include/asm-generic/sections.h                     |   7 +-
 include/linux/netfilter_bridge/ebtables.h          |   4 -
 include/linux/rmap.h                               |   7 +-
 include/linux/sched.h                              |  14 ++-
 include/net/busy_poll.h                            |   2 +-
 kernel/audit_fsnotify.c                            |   1 +
 kernel/kprobes.c                                   |   9 +-
 kernel/sched/core.c                                |  11 +-
 kernel/sched/deadline.c                            | 131 +++++++++++++--------
 kernel/sys_ni.c                                    |   1 +
 kernel/trace/ftrace.c                              |  10 ++
 lib/ratelimit.c                                    |  12 +-
 mm/mmap.c                                          |  20 +++-
 mm/rmap.c                                          |  31 ++---
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bridge/netfilter/ebtable_broute.c              |   8 --
 net/bridge/netfilter/ebtable_filter.c              |   8 --
 net/bridge/netfilter/ebtable_nat.c                 |   8 --
 net/bridge/netfilter/ebtables.c                    |   8 +-
 net/core/dev.c                                     |  14 +--
 net/core/neighbour.c                               |  27 ++++-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock.c                                    |   2 +-
 net/core/sysctl_net_core.c                         |  15 ++-
 net/key/af_key.c                                   |   3 +
 net/netfilter/Kconfig                              |   1 -
 net/netfilter/nft_osf.c                            |  18 ++-
 net/netfilter/nft_payload.c                        |  29 +++--
 net/netfilter/nft_tunnel.c                         |   1 +
 net/rose/rose_loopback.c                           |   3 +-
 net/sched/sch_generic.c                            |   2 +-
 net/socket.c                                       |   2 +-
 net/xfrm/xfrm_policy.c                             |   1 +
 scripts/Makefile.modpost                           |   3 +-
 tools/testing/selftests/bpf/test_align.c           |  27 +++--
 tools/testing/selftests/bpf/test_verifier.c        |  32 ++---
 64 files changed, 493 insertions(+), 285 deletions(-)


