Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592B75ACFE5
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbiIEKM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237511AbiIEKMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409C653D01;
        Mon,  5 Sep 2022 03:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AEDBB81002;
        Mon,  5 Sep 2022 10:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD8C433D6;
        Mon,  5 Sep 2022 10:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372752;
        bh=+yvbfMXJxpGO1cmSYTz64un5Q38GtmVpo+1UmtDLx60=;
        h=From:To:Cc:Subject:Date:From;
        b=m4X05dngewnH5mrVCTG/vHygJKLsPBN7jPUeAWJOAYWp8VkUKk2vPPE8MYLzCXGnF
         EqpdAHOqVEBBcr1A6LHzHLIOUbFVuOFQ0xoLjtVP6rNYNSIv+nW//grJwQNJ8t4E7S
         MhXmyfKlQ4dXvWEVOvOmH9fpDACEn4U+Decw3BZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.212
Date:   Mon,  5 Sep 2022 12:12:15 +0200
Message-Id: <166237273622589@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 5.4.212 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |   14 +
 Makefile                                                        |    2 
 arch/parisc/kernel/unaligned.c                                  |    2 
 arch/s390/hypfs/hypfs_diag.c                                    |    2 
 arch/s390/hypfs/inode.c                                         |    2 
 arch/s390/kernel/process.c                                      |   22 +
 arch/s390/mm/fault.c                                            |    4 
 arch/x86/events/intel/uncore_snb.c                              |   18 +
 arch/x86/include/asm/cpufeatures.h                              |    3 
 arch/x86/kernel/cpu/bugs.c                                      |   14 -
 arch/x86/kernel/cpu/common.c                                    |   40 +--
 arch/x86/kernel/unwind_orc.c                                    |   15 -
 drivers/acpi/processor_thermal.c                                |    2 
 drivers/android/binder.c                                        |    1 
 drivers/block/loop.c                                            |    5 
 drivers/dma-buf/udmabuf.c                                       |   18 +
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c           |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c                |    6 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c               |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c                |    6 
 drivers/hid/hid-steam.c                                         |   10 
 drivers/hid/hidraw.c                                            |    3 
 drivers/md/md.c                                                 |    1 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                         |    1 
 drivers/net/bonding/bond_3ad.c                                  |   38 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                 |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                    |   59 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                |    2 
 drivers/net/ethernet/moxa/moxart_ether.c                        |   11 
 drivers/net/ipvlan/ipvtap.c                                     |    4 
 drivers/pinctrl/pinctrl-amd.c                                   |   11 
 drivers/scsi/storvsc_drv.c                                      |    2 
 drivers/usb/cdns3/gadget.c                                      |    8 
 drivers/video/fbdev/pm2fb.c                                     |    5 
 fs/btrfs/ctree.h                                                |    2 
 fs/btrfs/dev-replace.c                                          |    5 
 fs/btrfs/dir-item.c                                             |  122 +++++----
 fs/btrfs/inode.c                                                |   48 +++
 fs/btrfs/root-tree.c                                            |    5 
 fs/btrfs/tree-checker.c                                         |   25 +
 fs/btrfs/tree-log.c                                             |   14 -
 fs/btrfs/xattr.c                                                |    3 
 fs/io_uring.c                                                   |    3 
 fs/signalfd.c                                                   |    1 
 include/asm-generic/sections.h                                  |    7 
 include/linux/fs.h                                              |    1 
 include/linux/netfilter_bridge/ebtables.h                       |    4 
 include/linux/rmap.h                                            |    7 
 include/linux/sched.h                                           |   14 -
 include/linux/skbuff.h                                          |    8 
 include/net/busy_poll.h                                         |    2 
 kernel/audit_fsnotify.c                                         |    1 
 kernel/kprobes.c                                                |    9 
 kernel/sched/core.c                                             |   11 
 kernel/sched/deadline.c                                         |  131 ++++++----
 kernel/sys_ni.c                                                 |    1 
 kernel/trace/ftrace.c                                           |   10 
 lib/ratelimit.c                                                 |   12 
 lib/vdso/gettimeofday.c                                         |   27 +-
 mm/mmap.c                                                       |   20 +
 mm/rmap.c                                                       |   31 +-
 net/bluetooth/l2cap_core.c                                      |   10 
 net/bpf/test_run.c                                              |    3 
 net/bridge/netfilter/ebtable_broute.c                           |    8 
 net/bridge/netfilter/ebtable_filter.c                           |    8 
 net/bridge/netfilter/ebtable_nat.c                              |    8 
 net/bridge/netfilter/ebtables.c                                 |    8 
 net/core/dev.c                                                  |   15 -
 net/core/neighbour.c                                            |   27 +-
 net/core/skbuff.c                                               |    2 
 net/core/sock.c                                                 |    2 
 net/core/sysctl_net_core.c                                      |   15 -
 net/key/af_key.c                                                |    3 
 net/netfilter/Kconfig                                           |    1 
 net/netfilter/nft_osf.c                                         |   18 +
 net/netfilter/nft_payload.c                                     |   29 +-
 net/netfilter/nft_tunnel.c                                      |    1 
 net/packet/af_packet.c                                          |    4 
 net/rose/rose_loopback.c                                        |    3 
 net/sched/sch_generic.c                                         |    2 
 net/socket.c                                                    |    2 
 net/sunrpc/clnt.c                                               |    2 
 net/xfrm/xfrm_policy.c                                          |    1 
 scripts/Makefile.modpost                                        |    3 
 tools/testing/selftests/bpf/test_align.c                        |   14 -
 85 files changed, 711 insertions(+), 342 deletions(-)

Anand Jain (2):
      btrfs: replace: drop assert for suspended replace
      btrfs: add info when mount fails due to stale replace target

Andrei Vagin (1):
      lib/vdso: Mark do_hres() and do_coarse() as __always_inline

Basavaraj Natikar (1):
      pinctrl: amd: Don't save/restore interrupt status and wake status bits

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Brian Foster (1):
      s390: fix double free of GS and RI CBs on fork() failure

Chen Zhongjin (1):
      x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Christophe Leroy (1):
      lib/vdso: Let do_coarse() return 0 to simplify the callsite

Daniel Bristot de Oliveira (1):
      sched/deadline: Unthrottle PI boosted threads while enqueuing

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

Filipe Manana (3):
      btrfs: fix silent failure when deleting root reference
      btrfs: do not pin logs too early during renames
      btrfs: unify lookup return value when dir entry is missing

Florian Westphal (1):
      netfilter: ebtables: reject blobs that don't provide all entry points

Fudong Wang (1):
      drm/amd/display: clear optc underflow before turn off odm clock

Gaosheng Cui (1):
      audit: fix potential double free on error path from fsnotify_add_inode_mark

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Gerald Schaefer (1):
      s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Goldwyn Rodrigues (1):
      btrfs: check if root is readonly while setting security xattr

Greg Kroah-Hartman (1):
      Linux 5.4.212

Guoqing Jiang (1):
      md: call __md_stop_writes in md_stop

Helge Deller (1):
      parisc: Fix exception handler for fldw and fstw instructions

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Hui Su (1):
      kernel/sched: Remove dl_boosted flag comment

Ilya Bakoulin (1):
      drm/amd/display: Fix pixel clock programming

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Jann Horn (2):
      mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
      mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Jean-Philippe Brucker (2):
      Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"
      Revert "selftests/bpf: Fix test_align verifier log patterns"

Jing Leng (1):
      kbuild: Fix include path in scripts/Makefile.modpost

Jonathan Toppins (1):
      bonding: 802.3ad: fix no transmission of LACPDUs

Josef Bacik (1):
      btrfs: tree-checker: check for overlapping extent items

Josip Pavic (1):
      drm/amd/display: Avoid MPC infinite loop

Juergen Gross (1):
      s390/hypfs: avoid error message under KVM

Juri Lelli (1):
      sched/deadline: Fix priority inheritance with multiple scheduling classes

Karthik Alapati (1):
      HID: hidraw: fix memory leak in hidraw_release()

Kuniyuki Iwashima (10):
      net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
      net: Fix data-races around netdev_tstamp_prequeue.
      ratelimit: Fix data-races in ___ratelimit().
      net: Fix a data-race around sysctl_tstamp_allow_data.
      net: Fix a data-race around sysctl_net_busy_poll.
      net: Fix a data-race around sysctl_net_busy_read.
      net: Fix a data-race around netdev_budget.
      net: Fix a data-race around netdev_budget_usecs.
      net: Fix a data-race around sysctl_somaxconn.
      kprobes: don't call disarm_kprobe() for disabled kprobes

Lee Jones (1):
      HID: steam: Prevent NULL pointer dereference in steam_{recv,send}_report

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Lucas Stach (1):
      sched/deadline: Fix stale throttling on de-/boosted tasks

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix build errors in some archs

Maciej Żenczykowski (1):
      net: ipvtap - add __init/__exit annotations to module init/exit funcs

Marcos Paulo de Souza (1):
      btrfs: introduce btrfs_lookup_match_dir

Pablo Neira Ayuso (4):
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family

Pavel Begunkov (1):
      io_uring: disable polling pollfree files

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Pawel Laszczak (1):
      usb: cdns3: Fix issue for clear halt endpoint

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

Randy Dunlap (1):
      kernel/sys_ni: add compat entry for fadvise64_64

Riwen Lu (1):
      ACPI: processor: Remove freq Qos request for all CPUs

Saurabh Sengar (1):
      scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Sergei Antonov (1):
      net: moxa: get rid of asymmetry in DMA mapping/unmapping

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Stephane Eranian (1):
      perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU

Trond Myklebust (1):
      SUNRPC: RPC level errors should set task->tk_rpc_status

Vikas Gupta (1):
      bnxt_en: fix NQ resource accounting during vf creation on 57500 chips

Vivek Kasireddy (1):
      udmabuf: Set the DMA mask for the udmabuf device (v2)

Vlad Buslov (1):
      net/mlx5e: Properly disable vlan strip on non-UL reps

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yang Jihong (1):
      ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Yang Yingliang (1):
      net: neigh: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao (2):
      bpf: Don't redirect packets with invalid pkt_len
      net/af_packet: check len when min_header_len equals to 0

