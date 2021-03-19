Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB9341C26
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCSMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhCSMTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D623664F65;
        Fri, 19 Mar 2021 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156341;
        bh=eqlRLtR8Cu3pIlMmS2OHmOP/L+Bt94bG7J8FhpfX61M=;
        h=From:To:Cc:Subject:Date:From;
        b=zTdg3de6tiBxmnzFDRAHrQ16/czjBw0t7Zeo4w+7jOqir4BFTRJbLyWvAVd5XmTri
         V1Cb/NqkzregIGatLzabCKxdoFITMihHHpdIdUxTaLfzgXtsMVVrYUpeWuoo/DQFwd
         ORLEQtn9mLTuuuhz5/ulPtBHyMxm6phW0bDz7MMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/18] 5.4.107-rc1 review
Date:   Fri, 19 Mar 2021 13:18:38 +0100
Message-Id: <20210319121745.449875976@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.107-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.107-rc1
X-KernelTest-Deadline: 2021-03-21T12:17+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.107 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.107-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.107-rc1

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Support setting learning on port

DENG Qingfang <dqfext@gmail.com>
    net: dsa: tag_mtk: fix 802.1ad VLAN egress

Ard Biesheuvel <ardb@kernel.org>
    crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Uros Bizjak <ubizjak@gmail.com>
    crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

Kees Cook <keescook@chromium.org>
    crypto: x86 - Regularize glue function prototypes

Amir Goldstein <amir73il@gmail.com>
    fuse: fix live lock in fuse_iget()

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Fix vfio_edid issue for BXT/APL

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Fix port number for BDW on EDID region setup

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Fix virtual display setup for BXT/APL

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Fix mmio handler break on BXT/APL.

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Set SNOOP for PAT3 on BXT/APL to workaround GPU BB hang

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: Don't check free space before marking a block group RO

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

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: nvhe: Save the SPE context early


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   3 +
 arch/arm64/kvm/hyp/debug-sr.c                      |  24 ++-
 arch/arm64/kvm/hyp/switch.c                        |  13 +-
 arch/x86/crypto/aesni-intel_asm.S                  | 137 +++++++------
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |  20 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  54 +++---
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |  74 ++++---
 arch/x86/crypto/camellia_aesni_avx_glue.c          |  72 ++++---
 arch/x86/crypto/camellia_glue.c                    |  45 +++--
 arch/x86/crypto/cast6_avx_glue.c                   |  68 +++----
 arch/x86/crypto/glue_helper.c                      |  23 ++-
 arch/x86/crypto/serpent_avx2_glue.c                |  65 +++----
 arch/x86/crypto/serpent_avx_glue.c                 |  63 +++---
 arch/x86/crypto/serpent_sse2_glue.c                |  30 +--
 arch/x86/crypto/twofish_avx_glue.c                 |  75 ++++----
 arch/x86/crypto/twofish_glue_3way.c                |  37 ++--
 arch/x86/include/asm/crypto/camellia.h             |  63 +++---
 arch/x86/include/asm/crypto/glue_helper.h          |  18 +-
 arch/x86/include/asm/crypto/serpent-avx.h          |  20 +-
 arch/x86/include/asm/crypto/serpent-sse2.h         |  28 ++-
 arch/x86/include/asm/crypto/twofish.h              |  19 +-
 crypto/cast6_generic.c                             |  18 +-
 crypto/serpent_generic.c                           |   6 +-
 drivers/gpu/drm/i915/gvt/display.c                 | 212 +++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/handlers.c                |  40 +++-
 drivers/gpu/drm/i915/gvt/mmio.c                    |   5 +
 drivers/gpu/drm/i915/gvt/vgpu.c                    |   5 +-
 drivers/net/dsa/b53/b53_common.c                   |  18 ++
 drivers/net/dsa/b53/b53_regs.h                     |   1 +
 drivers/net/dsa/bcm_sf2.c                          |   5 -
 fs/btrfs/block-group.c                             |  48 +++--
 fs/btrfs/block-group.h                             |   3 +-
 fs/btrfs/relocation.c                              |   2 +-
 fs/btrfs/scrub.c                                   |  21 +-
 fs/fuse/fuse_i.h                                   |   1 +
 include/crypto/cast6.h                             |   4 +-
 include/crypto/serpent.h                           |   4 +-
 include/crypto/xts.h                               |   2 -
 kernel/bpf/verifier.c                              |  33 ++--
 net/dsa/tag_mtk.c                                  |  19 +-
 .../selftests/bpf/verifier/bounds_deduction.c      |  27 ++-
 tools/testing/selftests/bpf/verifier/unpriv.c      |  15 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  23 ++-
 44 files changed, 920 insertions(+), 547 deletions(-)


