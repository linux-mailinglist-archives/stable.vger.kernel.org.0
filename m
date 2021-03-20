Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E34342BF9
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCTLSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhCTLSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3155E619CA;
        Sat, 20 Mar 2021 10:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616235808;
        bh=9Tzohl38WydHRfVtmY3NoTeEResPx+HTvqbVMVelexs=;
        h=From:To:Cc:Subject:Date:From;
        b=xUA9E15VoK1uNKV7leh1mJP2h3OK7/h4+T51paB+lZmn0Jn84Fd0aZor2kJlYCQGl
         hceY8cl0j8BKc7doOWCkSNAhgOcwJ5yHqRD+f91LMMPnz+zNKuXh/5kKBUuBdBXM3X
         StkPGyJVA52XVvp/WmIDVqBrio0xM4mhIvFoDvLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.8
Date:   Sat, 20 Mar 2021 11:23:22 +0100
Message-Id: <16162358021172@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.8 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm64/include/asm/el2_setup.h                      |    4 
 arch/x86/crypto/aesni-intel_asm.S                       |  115 +++++++++-------
 arch/x86/crypto/aesni-intel_glue.c                      |   25 +--
 arch/x86/kvm/mmu/mmu_internal.h                         |   13 +
 drivers/infiniband/ulp/srp/ib_srp.c                     |  110 ++++++---------
 drivers/net/dsa/b53/b53_common.c                        |   18 ++
 drivers/net/dsa/b53/b53_regs.h                          |    1 
 drivers/net/dsa/bcm_sf2.c                               |   15 --
 drivers/regulator/pca9450-regulator.c                   |   30 ++++
 fs/fuse/fuse_i.h                                        |    1 
 fs/gfs2/ops_fstype.c                                    |   33 ++--
 fs/gfs2/recovery.c                                      |    8 -
 fs/gfs2/super.c                                         |   45 ------
 fs/gfs2/util.c                                          |   58 +++++++-
 fs/gfs2/util.h                                          |    3 
 fs/io_uring.c                                           |   84 ++++++-----
 fs/locks.c                                              |    3 
 fs/nfsd/nfs4state.c                                     |   53 +------
 include/linux/regulator/pca9450.h                       |   10 +
 kernel/bpf/verifier.c                                   |   33 ++--
 net/mptcp/pm.c                                          |    5 
 net/mptcp/pm_netlink.c                                  |   23 ++-
 net/mptcp/protocol.c                                    |   20 ++
 net/mptcp/protocol.h                                    |    5 
 tools/testing/selftests/bpf/verifier/bounds_deduction.c |   27 ++-
 tools/testing/selftests/bpf/verifier/map_ptr.c          |    4 
 tools/testing/selftests/bpf/verifier/unpriv.c           |   15 +-
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c  |   23 +++
 29 files changed, 461 insertions(+), 325 deletions(-)

Amir Goldstein (1):
      fuse: fix live lock in fuse_iget()

Ard Biesheuvel (1):
      crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Bob Peterson (3):
      gfs2: Add common helper for holding and releasing the freeze glock
      gfs2: move freeze glock outside the make_fs_rw and _ro functions
      gfs2: bypass signal_our_withdraw if no journal

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Florian Westphal (2):
      mptcp: pm: add lockdep assertions
      mptcp: dispose initial struct socket when its subflow is closed

Frieder Schrempf (3):
      regulator: pca9450: Add SD_VSEL GPIO for LDO5
      regulator: pca9450: Enable system reset on WDOG_B assertion
      regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting

Geliang Tang (1):
      mptcp: send ack for every add_addr

Greg Kroah-Hartman (1):
      Linux 5.11.8

J. Bruce Fields (2):
      Revert "nfsd4: remove check_conflicting_opens warning"
      Revert "nfsd4: a client's own opens needn't prevent delegations"

Jens Axboe (3):
      io_uring: don't attempt IO reissue from the ring exit path
      io_uring: don't keep looping for more events if we can't flush overflow
      io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return

Nicolas Morey-Chaisemartin (1):
      RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes

Pavel Begunkov (3):
      io_uring: refactor scheduling in io_cqring_wait
      io_uring: refactor io_cqring_wait
      io_uring: simplify do_read return parsing

Piotr Krysiuk (5):
      bpf: Prohibit alu ops for pointer types not defining ptr_limit
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit
      bpf, selftests: Fix up some test_verifier cases for unprivileged

Sean Christopherson (2):
      KVM: x86/mmu: Expand on the comment in kvm_vcpu_ad_need_write_protect()
      KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled

Vladimir Murzin (1):
      arm64: Unconditionally set virtual cpu id registers

