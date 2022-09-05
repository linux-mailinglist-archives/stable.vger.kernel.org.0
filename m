Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC45AD002
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 12:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiIEKMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 06:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiIEKML (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 06:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D5C4DF3C;
        Mon,  5 Sep 2022 03:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CEBFB80F9F;
        Mon,  5 Sep 2022 10:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CF9C433C1;
        Mon,  5 Sep 2022 10:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662372727;
        bh=1VL/XTFkmu+9hXElRggT7MH3mGSH1N14dnaXkYpOTgg=;
        h=From:To:Cc:Subject:Date:From;
        b=Hh1wIyfqHo7wxw6uzYFMC113+kEnCBjOpMoa4VliXbIZxg4OI+fBWMCZLIs+isOJk
         D1bpYHmeizWZ1LfkFvGN+7rrwK9Mrx6I3bYkSzpzMQfOL/sDyXdj4yTcsqKFf96s6P
         U4Z43npyw0BvKuu0/FbMgm6MvsGSI30oGYDrK9vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.327
Date:   Mon,  5 Sep 2022 12:12:03 +0200
Message-Id: <1662372723221228@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 4.9.327 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hw-vuln/processor_mmio_stale_data.rst |   14 ++++
 Makefile                                            |    2 
 arch/arm64/include/asm/mmu.h                        |    2 
 arch/arm64/kernel/kaslr.c                           |    5 -
 arch/arm64/kernel/setup.c                           |    9 ++-
 arch/arm64/mm/mmu.c                                 |   15 -----
 arch/parisc/kernel/unaligned.c                      |    2 
 arch/s390/hypfs/hypfs_diag.c                        |    2 
 arch/s390/hypfs/inode.c                             |    2 
 arch/s390/mm/fault.c                                |    4 +
 arch/x86/include/asm/cpufeatures.h                  |    1 
 arch/x86/include/asm/intel-family.h                 |    3 +
 arch/x86/kernel/cpu/bugs.c                          |   14 ++++
 arch/x86/kernel/cpu/common.c                        |   34 +++++++----
 drivers/block/loop.c                                |    5 +
 drivers/hid/hidraw.c                                |    3 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c             |    1 
 drivers/net/bonding/bond_3ad.c                      |   38 +++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c        |   59 +++++++++++++++-----
 drivers/video/fbdev/pm2fb.c                         |    5 +
 fs/btrfs/xattr.c                                    |    3 +
 include/asm-generic/sections.h                      |    7 +-
 include/linux/rmap.h                                |    7 +-
 include/net/busy_poll.h                             |    2 
 kernel/kprobes.c                                    |   10 ++-
 kernel/trace/ftrace.c                               |   10 +++
 lib/ratelimit.c                                     |   12 +++-
 mm/mmap.c                                           |   20 ++++++
 mm/rmap.c                                           |   31 +++++-----
 net/bluetooth/l2cap_core.c                          |   10 +--
 net/core/skbuff.c                                   |    2 
 net/core/sock.c                                     |    2 
 net/key/af_key.c                                    |    3 +
 net/netfilter/Kconfig                               |    1 
 net/netfilter/nft_payload.c                         |   10 ++-
 net/rose/rose_loopback.c                            |    3 -
 net/socket.c                                        |    2 
 net/xfrm/xfrm_policy.c                              |    1 
 scripts/Makefile.modpost                            |    3 -
 39 files changed, 244 insertions(+), 115 deletions(-)

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb not supporting softdirty tracking

Dongliang Mu (1):
      media: pvrusb2: fix memory leak in pvr_probe

Gayatri Kammela (1):
      x86/cpu: Add Tiger Lake to Intel family

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Gerald Schaefer (1):
      s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Goldwyn Rodrigues (1):
      btrfs: check if root is readonly while setting security xattr

Greg Kroah-Hartman (1):
      Linux 4.9.327

Helge Deller (1):
      parisc: Fix exception handler for fldw and fstw instructions

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Hsin-Yi Wang (1):
      arm64: map FDT as RW for early_init_dt_scan()

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

Karthik Alapati (1):
      HID: hidraw: fix memory leak in hidraw_release()

Kuniyuki Iwashima (6):
      ratelimit: Fix data-races in ___ratelimit().
      net: Fix a data-race around sysctl_tstamp_allow_data.
      net: Fix a data-race around sysctl_net_busy_poll.
      net: Fix a data-race around sysctl_net_busy_read.
      net: Fix a data-race around sysctl_somaxconn.
      kprobes: don't call disarm_kprobe() for disabled kprobes

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix build errors in some archs

Pablo Neira Ayuso (1):
      netfilter: nft_payload: report ERANGE for too long offset and length

Pawan Gupta (1):
      x86/bugs: Add "unknown" reporting for MMIO Stale Data

Quanyang Wang (1):
      asm-generic: sections: refactor memory_intersects

Siddh Raman Pant (1):
      loop: Check for overflow while configuring loop

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yang Jihong (1):
      ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

