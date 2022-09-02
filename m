Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690015AAE39
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiIBMVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiIBMVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB24937F86;
        Fri,  2 Sep 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA42620EB;
        Fri,  2 Sep 2022 12:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C03CC433D6;
        Fri,  2 Sep 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121215;
        bh=NEb01V7EyB+mV5/s4TeSfr67gO3EQiiQ0gLsSRsOOXM=;
        h=From:To:Cc:Subject:Date:From;
        b=ukDsvRSWGPyfYpQIm5mXPcYXAIUUNr/OL4OleJtsoVwk4NOP87CC8HbXRpaBwznAV
         oki3Ag5tpEZ88ioxLCNTRvp54d+dNNIs4IE1Cr+wLKjVjhlh2qRB83X3Dm94Xc3F08
         8ABef45F1+sF6Zbst+fj04H6M4iJzZcg+gCnm29Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/31] 4.9.327-rc1 review
Date:   Fri,  2 Sep 2022 14:18:26 +0200
Message-Id: <20220902121356.732130937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.327-rc1
X-KernelTest-Deadline: 2022-09-04T12:13+00:00
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

This is the start of the stable review cycle for the 4.9.327 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.327-rc1

Kuniyuki Iwashima <kuniyu@amazon.com>
    kprobes: don't call disarm_kprobe() for disabled kprobes

Jann Horn <jannh@google.com>
    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse

Geert Uytterhoeven <geert@linux-m68k.org>
    netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Juergen Gross <jgross@suse.com>
    s390/hypfs: avoid error message under KVM

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: map FDT as RW for early_init_dt_scan()

Yang Jihong <yangjihong1@huawei.com>
    ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead

Letu Ren <fantasquex@gmail.com>
    fbdev: fb_pm2fb: Avoid potential divide by zero error

Karthik Alapati <mail@karthek.com>
    HID: hidraw: fix memory leak in hidraw_release()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: pvrusb2: fix memory leak in pvr_probe

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix build errors in some archs

Jing Leng <jleng@ambarella.com>
    kbuild: Fix include path in scripts/Makefile.modpost

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add "unknown" reporting for MMIO Stale Data

Gayatri Kammela <gayatri.kammela@intel.com>
    x86/cpu: Add Tiger Lake to Intel family

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: do not trigger write fault when vma does not allow VM_WRITE

Jann Horn <jannh@google.com>
    mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix hugetlb not supporting softdirty tracking

Quanyang Wang <quanyang.wang@windriver.com>
    asm-generic: sections: refactor memory_intersects

Siddh Raman Pant <code@siddh.me>
    loop: Check for overflow while configuring loop

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: check if root is readonly while setting security xattr

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_somaxconn.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_read.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_net_busy_poll.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix a data-race around sysctl_tstamp_allow_data.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ratelimit: Fix data-races in ___ratelimit().

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: report ERANGE for too long offset and length

Jonathan Toppins <jtoppins@redhat.com>
    bonding: 802.3ad: fix no transmission of LACPDUs

Bernard Pidoux <f6bvp@free.fr>
    rose: check NULL rose_loopback_neigh->loopback

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Do not call xfrm_probe_algs in parallel

Xin Xiong <xiongx18@fudan.edu.cn>
    xfrm: fix refcount leak in __xfrm_policy_check()

Helge Deller <deller@gmx.de>
    parisc: Fix exception handler for fldw and fstw instructions


-------------

Diffstat:

 .../hw-vuln/processor_mmio_stale_data.rst          | 14 +++++
 Makefile                                           |  4 +-
 arch/arm64/include/asm/mmu.h                       |  2 +-
 arch/arm64/kernel/kaslr.c                          |  5 +-
 arch/arm64/kernel/setup.c                          |  9 +++-
 arch/arm64/mm/mmu.c                                | 15 +-----
 arch/parisc/kernel/unaligned.c                     |  2 +-
 arch/s390/hypfs/hypfs_diag.c                       |  2 +-
 arch/s390/hypfs/inode.c                            |  2 +-
 arch/s390/mm/fault.c                               |  4 +-
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/include/asm/intel-family.h                |  3 ++
 arch/x86/kernel/cpu/bugs.c                         | 14 ++++-
 arch/x86/kernel/cpu/common.c                       | 34 +++++++++----
 drivers/block/loop.c                               |  5 ++
 drivers/hid/hidraw.c                               |  3 ++
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  1 +
 drivers/net/bonding/bond_3ad.c                     | 38 ++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 59 +++++++++++++++++-----
 drivers/video/fbdev/pm2fb.c                        |  5 ++
 fs/btrfs/xattr.c                                   |  3 ++
 include/asm-generic/sections.h                     |  7 ++-
 include/linux/rmap.h                               |  7 ++-
 include/net/busy_poll.h                            |  2 +-
 kernel/kprobes.c                                   | 10 ++--
 kernel/trace/ftrace.c                              | 10 ++++
 lib/ratelimit.c                                    | 12 +++--
 mm/mmap.c                                          | 20 +++++++-
 mm/rmap.c                                          | 31 +++++++-----
 net/bluetooth/l2cap_core.c                         | 10 ++--
 net/core/skbuff.c                                  |  2 +-
 net/core/sock.c                                    |  2 +-
 net/key/af_key.c                                   |  3 ++
 net/netfilter/Kconfig                              |  1 -
 net/netfilter/nft_payload.c                        | 10 +++-
 net/rose/rose_loopback.c                           |  3 +-
 net/socket.c                                       |  2 +-
 net/xfrm/xfrm_policy.c                             |  1 +
 scripts/Makefile.modpost                           |  3 +-
 39 files changed, 245 insertions(+), 116 deletions(-)


