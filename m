Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9595AAF6C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbiIBMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiIBMhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:37:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B6F5B07E;
        Fri,  2 Sep 2022 05:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B00B82A9D;
        Fri,  2 Sep 2022 12:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FD6C433D7;
        Fri,  2 Sep 2022 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121674;
        bh=r6FeWRx7xrmk2PuoWSai+ht1kUpwPfk6nSP4/MVeNGc=;
        h=From:To:Cc:Subject:Date:From;
        b=vYXTzswkTqjDNw0I9KCoXLnWArr7JpEsDxv9ZlwUTmTfiVXIsg/A0QDRqbijnwEfo
         YSmdVwNfGKoB4AHYW6xb2eNMnYxs+yiLdCjeVbi1VRD4B/YpgNFIPTw7C0Us4k0ePy
         SylX6Lxaha7usodHD3P1tOZro2WdcqfWsoQeZFZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/77] 5.4.212-rc1 review
Date:   Fri,  2 Sep 2022 14:18:09 +0200
Message-Id: <20220902121403.569927325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.212-rc1
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

This is the start of the stable review cycle for the 5.4.212 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.212-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.212-rc1

Yang Yingliang <yangyingliang@huawei.com>
    net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    net/af_packet: check len when min_header_len equals to 0

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: disable polling pollfree files

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

Andrei Vagin <avagin@gmail.com>
    lib/vdso: Mark do_hres() and do_coarse() as __always_inline

Christophe Leroy <christophe.leroy@c-s.fr>
    lib/vdso: Let do_coarse() return 0 to simplify the callsite

Josef Bacik <josef@toxicpanda.com>
    btrfs: tree-checker: check for overlapping extent items

Geert Uytterhoeven <geert@linux-m68k.org>
    netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix pixel clock programming

Juergen Gross <jgross@suse.com>
    s390/hypfs: avoid error message under KVM

Denis V. Lunev <den@openvz.org>
    neigh: fix possible DoS due to net iface start/stop loop

Fudong Wang <Fudong.Wang@amd.com>
    drm/amd/display: clear optc underflow before turn off odm clock

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: Avoid MPC infinite loop

Filipe Manana <fdmanana@suse.com>
    btrfs: unify lookup return value when dir entry is missing

Filipe Manana <fdmanana@suse.com>
    btrfs: do not pin logs too early during renames

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: introduce btrfs_lookup_match_dir

Jann Horn <jannh@google.com>
    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Zhengchao Shao <shaozhengchao@huawei.com>
    bpf: Don't redirect packets with invalid pkt_len

Yang Jihong <yangjihong1@huawei.com>
    ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error

Karthik Alapati <mail@karthek.com>
    HID: hidraw: fix memory leak in hidraw_release()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: pvrusb2: fix memory leak in pvr_probe

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: Set the DMA mask for the udmabuf device (v2)

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

Jann Horn <jannh@google.com>
    mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()

Saurabh Sengar <ssengar@linux.microsoft.com>
    scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Stephane Eranian <eranian@google.com>
    perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU

Guoqing Jiang <guoqing.jiang@linux.dev>
    md: call __md_stop_writes in md_stop

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Riwen Lu <luriwen@kylinos.cn>
    ACPI: processor: Remove freq Qos request for all CPUs

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

Anand Jain <anand.jain@oracle.com>
    btrfs: add info when mount fails due to stale replace target

Anand Jain <anand.jain@oracle.com>
    btrfs: replace: drop assert for suspended replace

Filipe Manana <fdmanana@suse.com>
    btrfs: fix silent failure when deleting root reference

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

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: reject blobs that don't provide all entry points

Maciej Żenczykowski <maze@google.com>
    net: ipvtap - add __init/__exit annotations to module init/exit funcs

Jonathan Toppins <jtoppins@redhat.com>
    bonding: 802.3ad: fix no transmission of LACPDUs

Sergei Antonov <saproj@gmail.com>
    net: moxa: get rid of asymmetry in DMA mapping/unmapping

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Properly disable vlan strip on non-UL reps

Bernard Pidoux <f6bvp@free.fr>
    rose: check NULL rose_loopback_neigh->loopback

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: RPC level errors should set task->tk_rpc_status

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

Jean-Philippe Brucker <jean-philippe@linaro.org>
    Revert "selftests/bpf: Fix test_align verifier log patterns"

Jean-Philippe Brucker <jean-philippe@linaro.org>
    Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue for clear halt endpoint

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
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/s390/hypfs/hypfs_diag.c                       |   2 +-
 arch/s390/hypfs/inode.c                            |   2 +-
 arch/s390/kernel/process.c                         |  22 +++-
 arch/s390/mm/fault.c                               |   4 +-
 arch/x86/events/intel/uncore_snb.c                 |  18 ++-
 arch/x86/include/asm/cpufeatures.h                 |   3 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 ++-
 arch/x86/kernel/cpu/common.c                       |  40 ++++---
 arch/x86/kernel/unwind_orc.c                       |  15 ++-
 drivers/acpi/processor_thermal.c                   |   2 +-
 drivers/android/binder.c                           |   1 +
 drivers/block/loop.c                               |   5 +
 drivers/dma-buf/udmabuf.c                          |  18 ++-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   2 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c   |   6 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c  |   5 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c   |   6 +
 drivers/hid/hid-steam.c                            |  10 ++
 drivers/hid/hidraw.c                               |   3 +
 drivers/md/md.c                                    |   1 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   1 +
 drivers/net/bonding/bond_3ad.c                     |  38 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |  59 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 drivers/net/ethernet/moxa/moxart_ether.c           |  11 +-
 drivers/net/ipvlan/ipvtap.c                        |   4 +-
 drivers/pinctrl/pinctrl-amd.c                      |  11 +-
 drivers/scsi/storvsc_drv.c                         |   2 +-
 drivers/usb/cdns3/gadget.c                         |   8 +-
 drivers/video/fbdev/pm2fb.c                        |   5 +
 fs/btrfs/ctree.h                                   |   2 +-
 fs/btrfs/dev-replace.c                             |   5 +-
 fs/btrfs/dir-item.c                                | 122 +++++++++++--------
 fs/btrfs/inode.c                                   |  48 +++++++-
 fs/btrfs/root-tree.c                               |   5 +-
 fs/btrfs/tree-checker.c                            |  25 +++-
 fs/btrfs/tree-log.c                                |  14 +--
 fs/btrfs/xattr.c                                   |   3 +
 fs/io_uring.c                                      |   3 +
 fs/signalfd.c                                      |   1 +
 include/asm-generic/sections.h                     |   7 +-
 include/linux/fs.h                                 |   1 +
 include/linux/netfilter_bridge/ebtables.h          |   4 -
 include/linux/rmap.h                               |   7 +-
 include/linux/sched.h                              |  14 ++-
 include/linux/skbuff.h                             |   8 ++
 include/net/busy_poll.h                            |   2 +-
 kernel/audit_fsnotify.c                            |   1 +
 kernel/kprobes.c                                   |   9 +-
 kernel/sched/core.c                                |  11 +-
 kernel/sched/deadline.c                            | 131 +++++++++++++--------
 kernel/sys_ni.c                                    |   1 +
 kernel/trace/ftrace.c                              |  10 ++
 lib/ratelimit.c                                    |  12 +-
 lib/vdso/gettimeofday.c                            |  27 +++--
 mm/mmap.c                                          |  20 +++-
 mm/rmap.c                                          |  31 ++---
 net/bluetooth/l2cap_core.c                         |  10 +-
 net/bpf/test_run.c                                 |   3 +
 net/bridge/netfilter/ebtable_broute.c              |   8 --
 net/bridge/netfilter/ebtable_filter.c              |   8 --
 net/bridge/netfilter/ebtable_nat.c                 |   8 --
 net/bridge/netfilter/ebtables.c                    |   8 +-
 net/core/dev.c                                     |  15 +--
 net/core/neighbour.c                               |  27 ++++-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock.c                                    |   2 +-
 net/core/sysctl_net_core.c                         |  15 ++-
 net/key/af_key.c                                   |   3 +
 net/netfilter/Kconfig                              |   1 -
 net/netfilter/nft_osf.c                            |  18 ++-
 net/netfilter/nft_payload.c                        |  29 +++--
 net/netfilter/nft_tunnel.c                         |   1 +
 net/packet/af_packet.c                             |   4 +-
 net/rose/rose_loopback.c                           |   3 +-
 net/sched/sch_generic.c                            |   2 +-
 net/socket.c                                       |   2 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/xfrm/xfrm_policy.c                             |   1 +
 scripts/Makefile.modpost                           |   3 +-
 tools/testing/selftests/bpf/test_align.c           |  14 +--
 85 files changed, 712 insertions(+), 343 deletions(-)


