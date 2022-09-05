Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319AA5ACFE2
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiIEKMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiIEKMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541C84E601;
        Mon,  5 Sep 2022 03:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B4DACE0EE9;
        Mon,  5 Sep 2022 10:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BF0C433D6;
        Mon,  5 Sep 2022 10:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372745;
        bh=ih8uvcOzkpgFsqEXJkz1eUym8miEV6tePtemBCrIXxw=;
        h=From:To:Cc:Subject:Date:From;
        b=W7eo4RRHxxFugjTTkr7COCVbS/6rB20YDgftF7SbX2oA4xoIyLKSpJVr4F9YUz/RT
         JVK/LVrmP0P0rllSdYMzKqiWGVjfA3ID60FRsAFQMOIg0A6IUTjAl+KY6Aydb86yOU
         h2R1vc1h5jQhM1mKIT89Ca//8VZxhhP8ozUWpzjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.257
Date:   Mon,  5 Sep 2022 12:12:11 +0200
Message-Id: <1662372732116209@kroah.com>
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

I'm announcing the release of the 4.19.257 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |   14 +
 Makefile                                                        |    2 
 arch/arm64/include/asm/mmu.h                                    |    2 
 arch/arm64/kernel/kaslr.c                                       |    5 
 arch/arm64/kernel/setup.c                                       |    9 
 arch/arm64/mm/mmu.c                                             |   15 -
 arch/parisc/kernel/unaligned.c                                  |    2 
 arch/s390/hypfs/hypfs_diag.c                                    |    2 
 arch/s390/hypfs/inode.c                                         |    2 
 arch/s390/kernel/process.c                                      |   22 +
 arch/s390/mm/fault.c                                            |    4 
 arch/x86/include/asm/cpufeatures.h                              |    3 
 arch/x86/kernel/cpu/bugs.c                                      |   14 -
 arch/x86/kernel/cpu/common.c                                    |   34 +-
 arch/x86/kernel/unwind_orc.c                                    |   15 -
 drivers/block/loop.c                                            |    5 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c               |    5 
 drivers/hid/hid-steam.c                                         |   10 
 drivers/hid/hidraw.c                                            |    3 
 drivers/md/md.c                                                 |    1 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                         |    1 
 drivers/net/bonding/bond_3ad.c                                  |   38 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                    |   59 +++-
 drivers/net/ipvlan/ipvtap.c                                     |    4 
 drivers/pinctrl/pinctrl-amd.c                                   |   11 
 drivers/scsi/storvsc_drv.c                                      |    2 
 drivers/video/fbdev/pm2fb.c                                     |    5 
 fs/btrfs/xattr.c                                                |    3 
 include/asm-generic/sections.h                                  |    7 
 include/linux/netfilter_bridge/ebtables.h                       |    4 
 include/linux/rmap.h                                            |    7 
 include/linux/sched.h                                           |   14 -
 include/net/busy_poll.h                                         |    2 
 kernel/audit_fsnotify.c                                         |    1 
 kernel/kprobes.c                                                |    9 
 kernel/sched/core.c                                             |   11 
 kernel/sched/deadline.c                                         |  131 ++++++----
 kernel/sys_ni.c                                                 |    1 
 kernel/trace/ftrace.c                                           |   10 
 lib/ratelimit.c                                                 |   12 
 mm/mmap.c                                                       |   20 +
 mm/rmap.c                                                       |   31 +-
 net/bluetooth/l2cap_core.c                                      |   10 
 net/bridge/netfilter/ebtable_broute.c                           |    8 
 net/bridge/netfilter/ebtable_filter.c                           |    8 
 net/bridge/netfilter/ebtable_nat.c                              |    8 
 net/bridge/netfilter/ebtables.c                                 |    8 
 net/core/dev.c                                                  |   14 -
 net/core/neighbour.c                                            |   27 +-
 net/core/skbuff.c                                               |    2 
 net/core/sock.c                                                 |    2 
 net/core/sysctl_net_core.c                                      |   15 -
 net/key/af_key.c                                                |    3 
 net/netfilter/Kconfig                                           |    1 
 net/netfilter/nft_osf.c                                         |   18 +
 net/netfilter/nft_payload.c                                     |   29 +-
 net/netfilter/nft_tunnel.c                                      |    1 
 net/rose/rose_loopback.c                                        |    3 
 net/sched/sch_generic.c                                         |    2 
 net/socket.c                                                    |    2 
 net/xfrm/xfrm_policy.c                                          |    1 
 scripts/Makefile.modpost                                        |    3 
 tools/testing/selftests/bpf/test_align.c                        |   27 +-
 tools/testing/selftests/bpf/test_verifier.c                     |   32 +-
 64 files changed, 492 insertions(+), 284 deletions(-)

Basavaraj Natikar (1):
      pinctrl: amd: Don't save/restore interrupt status and wake status bits

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Brian Foster (1):
      s390: fix double free of GS and RI CBs on fork() failure

Chen Zhongjin (1):
      x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

Daniel Bristot de Oliveira (1):
      sched/deadline: Unthrottle PI boosted threads while enqueuing

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

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
      Linux 4.19.257

Guoqing Jiang (1):
      md: call __md_stop_writes in md_stop

Helge Deller (1):
      parisc: Fix exception handler for fldw and fstw instructions

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Hsin-Yi Wang (1):
      arm64: map FDT as RW for early_init_dt_scan()

Hui Su (1):
      kernel/sched: Remove dl_boosted flag comment

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Jann Horn (2):
      mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
      mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Jing Leng (1):
      kbuild: Fix include path in scripts/Makefile.modpost

Jonathan Toppins (1):
      bonding: 802.3ad: fix no transmission of LACPDUs

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

Maxim Mikityanskiy (1):
      bpf: Fix the off-by-two error in range markings

Pablo Neira Ayuso (4):
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

Randy Dunlap (1):
      kernel/sys_ni: add compat entry for fadvise64_64

Saurabh Sengar (1):
      scsi: storvsc: Remove WQ_MEM_RECLAIM from storvsc_error_wq

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Stanislav Fomichev (1):
      selftests/bpf: Fix test_align verifier log patterns

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yang Jihong (1):
      ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Yang Yingliang (1):
      net: neigh: don't call kfree_skb() under spin_lock_irqsave()

