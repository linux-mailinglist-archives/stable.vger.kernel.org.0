Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45A3341C86
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhCSMVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231313AbhCSMVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACECC64F65;
        Fri, 19 Mar 2021 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156461;
        bh=p+L8uf7MxH16BIO37BZ5oGmOh5GkKGlL5aeK2jkGGyI=;
        h=From:To:Cc:Subject:Date:From;
        b=VOYqAI3NnJs40T6l3LKJBoQ0/oENC7PgqawbWdCydr6gwNpj17a5CuD0geuIBlb8V
         LbAZh43t9Iu8EaZMi444DOTPryRQmXN219YobZ5cZKisid06qbsd97xyLMqhiZMzJt
         aMFir5ifWwhjjAWAZhevSs++566QtNbKkrHz4CTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/31] 5.11.8-rc1 review
Date:   Fri, 19 Mar 2021 13:18:54 +0100
Message-Id: <20210319121747.203523570@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.8-rc1
X-KernelTest-Deadline: 2021-03-21T12:17+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.8 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.8-rc1

Ard Biesheuvel <ardb@kernel.org>
    crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Support setting learning on port

J. Bruce Fields <bfields@redhat.com>
    Revert "nfsd4: a client's own opens needn't prevent delegations"

J. Bruce Fields <bfields@redhat.com>
    Revert "nfsd4: remove check_conflicting_opens warning"

Amir Goldstein <amir73il@gmail.com>
    fuse: fix live lock in fuse_iget()

Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
    RDMA/srp: Fix support for unpopulated and unbalanced NUMA nodes

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: Unconditionally set virtual cpu id registers

Piotr Krysiuk <piotras@gmail.com>
    bpf, selftests: Fix up some test_verifier cases for unprivileged

Piotr Krysiuk <piotras@gmail.com>
    bpf: Add sanity check for upper ptr_limit

Piotr Krysiuk <piotras@gmail.com>
    bpf: Simplify alu_limit masking for pointer arithmetic

Piotr Krysiuk <piotras@gmail.com>
    bpf: Fix off-by-one for area size in creating mask to left

Piotr Krysiuk <piotras@gmail.com>
    bpf: Prohibit alu ops for pointer types not defining ptr_limit

Bob Peterson <rpeterso@redhat.com>
    gfs2: bypass signal_our_withdraw if no journal

Bob Peterson <rpeterso@redhat.com>
    gfs2: move freeze glock outside the make_fs_rw and _ro functions

Bob Peterson <rpeterso@redhat.com>
    gfs2: Add common helper for holding and releasing the freeze glock

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Enable system reset on WDOG_B assertion

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Add SD_VSEL GPIO for LDO5

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: bonding: fix error return code of bond_neigh_init()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Read "gpio-line-names" from a firmware node

Jens Axboe <axboe@kernel.dk>
    io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: simplify do_read return parsing

Jens Axboe <axboe@kernel.dk>
    io_uring: don't keep looping for more events if we can't flush overflow

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: refactor io_cqring_wait

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: refactor scheduling in io_cqring_wait

Florian Westphal <fw@strlen.de>
    mptcp: dispose initial struct socket when its subflow is closed

Florian Westphal <fw@strlen.de>
    mptcp: pm: add lockdep assertions

Geliang Tang <geliangtang@gmail.com>
    mptcp: send ack for every add_addr

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Expand on the comment in kvm_vcpu_ad_need_write_protect()

Jens Axboe <axboe@kernel.dk>
    io_uring: don't attempt IO reissue from the ring exit path


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/el2_setup.h                 |   4 +-
 arch/x86/crypto/aesni-intel_asm.S                  | 115 +++++++++++++--------
 arch/x86/crypto/aesni-intel_glue.c                 |  25 +++--
 arch/x86/kvm/mmu/mmu_internal.h                    |  13 ++-
 drivers/gpio/gpiolib.c                             |  12 +--
 drivers/infiniband/ulp/srp/ib_srp.c                | 110 ++++++++------------
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/dsa/b53/b53_common.c                   |  18 ++++
 drivers/net/dsa/b53/b53_regs.h                     |   1 +
 drivers/net/dsa/bcm_sf2.c                          |  15 +--
 drivers/regulator/pca9450-regulator.c              |  30 ++++++
 fs/fuse/fuse_i.h                                   |   1 +
 fs/gfs2/ops_fstype.c                               |  33 +++---
 fs/gfs2/recovery.c                                 |   8 +-
 fs/gfs2/super.c                                    |  45 +-------
 fs/gfs2/util.c                                     |  58 +++++++++--
 fs/gfs2/util.h                                     |   3 +
 fs/io_uring.c                                      |  84 ++++++++-------
 fs/locks.c                                         |   3 -
 fs/nfsd/nfs4state.c                                |  53 +++-------
 include/linux/regulator/pca9450.h                  |  10 ++
 kernel/bpf/verifier.c                              |  33 +++---
 net/mptcp/pm.c                                     |   5 +-
 net/mptcp/pm_netlink.c                             |  23 +++--
 net/mptcp/protocol.c                               |  20 +++-
 net/mptcp/protocol.h                               |   5 +
 .../selftests/bpf/verifier/bounds_deduction.c      |  27 +++--
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   4 +
 tools/testing/selftests/bpf/verifier/unpriv.c      |  15 ++-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 ++++-
 31 files changed, 472 insertions(+), 336 deletions(-)


