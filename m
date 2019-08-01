Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051257D714
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfHAITh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37596 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbfHAITh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so914871pgp.4
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bhUQ8CbBxnutQFMCz2w4dwMypfrLtFZ8t2rl5QcIMUU=;
        b=F1n3TvtiV8FBSBJzc4RL3P9w7OsvZRL1G9sv0KMkmvxKv+KUmyWuUMObng6sV+MrOG
         mm6IXetH04vdKG/l3lSTZL9QFyZy9Zxkd0cHcrni1j2/YIdjGFrQTFoTrWjvhyp3ksvV
         ThMJ95KIV8EMnjFrzS7i073Vyz0Pi9FsneWsk6rxXnyDHIpK9jMPRYv4YefP5bv9LAUv
         UgGzk7q+wnHARtuhTLcks9/NVAsQOR+WNIQ13/dLerUzfrNAUAsvOe2ZWSUcFBVX9EmI
         8UzFSrndPYpmVN0wJXitcBIvZHfuy2a0nDQkyvMehDVp8F4PrZVpAi0jZO0SX2dLGnrF
         xfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bhUQ8CbBxnutQFMCz2w4dwMypfrLtFZ8t2rl5QcIMUU=;
        b=my9GeY1nOVO9lAXiMuGxrTj5jyoYkypWJI89R2X9p1Ac6T4uKOcPq4BASYuvATZvsV
         pEPUXpMVK/H08bRPN8v3decytMIq3do8I9CRPWioboa0mHbvPPyuG6zP+sU1KEmvXgfD
         DtSO/4UF8lutxI0uFrD47PVnjxRtujIkgKGyBE3+S6s8bG46PfbGGu3zw4xzjcXvCD1G
         ZOrS18ZqwS7TuMvFWuGceLNEoVpHs0lbdJZR/oTu7dAVM21YjZC/spsglOvWqrc6P2NN
         Vnj87PWbUfKjGmz4/C1t+acIzciblmq4o9Q0n07MMKYjvxK4+KdUtYnzJq13gKbaJ02B
         jjBw==
X-Gm-Message-State: APjAAAXMB34ijXWmgN+INH0Xyo4rP/uy9Dt9xTAKZZftI3zu1lyXJ/dX
        +gkPBw79Sv37CVyfmOIP6x8TvcGRiM0=
X-Google-Smtp-Source: APXvYqzqh2cq2nbxSE3V6/uTwv+GNJMkSI/7I3/C99ClaCU+Mj94EeDY8pr/PaBXgYo/NP2XN5kDyA==
X-Received: by 2002:a17:90a:30cf:: with SMTP id h73mr7374254pjb.42.1564647575852;
        Thu, 01 Aug 2019 01:19:35 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id e124sm116491472pfh.181.2019.08.01.01.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:35 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 00/47] V4.4 backport of arm32 Spectre patches
Date:   Thu,  1 Aug 2019 13:45:44 +0530
Message-Id: <cover.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Here is an attempt to backport arm32 spectre patches to v4.4 stable
tree. This was last tried around an year back by David Long [1]. He was
backporting only a subset (18) of patches and this series include a lot
of other patches present in Russell's spectre branch.

Just like arm64 backport [2], KVM patches are dropped and they can be
backported separately if required.

Dropped patches (compared to Russell's spectre branch):
 KVM related:
  3f7e8e2e1ebd ARM: KVM: invalidate BTB on guest exit for Cortex-A12/A17
  0c47ac8cd157 ARM: KVM: invalidate icache on guest exit for Cortex-A15
  3c908e16396d ARM: spectre-v2: KVM: invalidate icache on guest exit for Brahma B15
  b800acfc70d9 ARM: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
  add5609877c6 ARM: KVM: report support for SMCCC_ARCH_WORKAROUND_1
 
 Dropped in 4.9 backport as well:
  73839798af7e ARM: 8790/1: signal: always use __copy_to_user to save iwmmxt context


Additional patches picked to avoid rebase conflicts and build issues:

 9f73bd8bb445 ARM: uaccess: remove put_user() code duplication
 122e022eebb3 arch: Introduce post-init read-only memory
 7b90ba3eb4af ARM: 8595/2: apply more __ro_after_init
 
 SMCCC related patches, are part of arm64 backport [2] as well and all
 KVM related changes are dropped from them:
 
  56b35dfda10c ARM: 8478/2: arm/arm64: add arm-smccc
  e6e9cc47cea9 arm/arm64: KVM: Advertise SMCCC v1.1
  91958fe7a4eb arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  1b232ad7ca05 drivers/firmware: Expose psci_get_version through psci_ops structure
  df2030616c6f firmware/psci: Expose PSCI conduit
  30f8c32765fd firmware/psci: Expose SMCCC version through psci_ops
  17f6f98d5069 arm/arm64: smccc: Make function identifiers an unsigned quantity
  e6d9b2fef81e arm/arm64: smccc: Implement SMCCC v1.1 inline primitive


All the patches are pushed here [3].

This is tested in Linaro Lava on Qemu_arm and X15 platforms and the
results are here [4]. Lava also check for some Spectre tests and one of
the test fails on x15 with this message:

CVE-2018-3640: VULN (an up-to-date CPU microcode is needed to mitigate
this vulnerability).

Perhaps this is an issue with x15 setup and not the patches themselves ?

I have also pushed this to be tested by kernel-ci, looks like my branch
isn't getting tested there currently. I am co-ordinating with them to
get it tested soon, we can start the review process until that time
though.

--
Viresh

[1] https://lore.kernel.org/stable/20181031140436.2964-1-dave.long@linaro.org/
[2] https://lore.kernel.org/stable/cover.1562908074.git.viresh.kumar@linaro.org/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git stable/arm32/v4.4.y/spectre
[4] https://staging-qa-reports.linaro.org/lkft/vishal.bhoj-stable-arm32-v4.4.y-spectre/build/v3.16-rc2-119419-g4ba6a2292f0e/


Ard Biesheuvel (1):
  ARM: 8809/1: proc-v7: fix Thumb annotation of cpu_v7_hvc_switch_mm

Jens Wiklander (1):
  ARM: 8478/2: arm/arm64: add arm-smccc

Julien Thierry (9):
  ARM: 8789/1: signal: copy registers using __copy_to_user()
  ARM: 8791/1: vfp: use __copy_to_user() when saving VFP state
  ARM: 8792/1: oabi-compat: copy oabi events using __copy_to_user()
  ARM: 8793/1: signal: replace __put_user_error with __put_user
  ARM: 8794/1: uaccess: Prevent speculative use of the current
    addr_limit
  ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()
  ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
  ARM: 8797/1: spectre-v1.1: harden __copy_to_user
  ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc

Kees Cook (2):
  arch: Introduce post-init read-only memory
  ARM: 8595/2: apply more __ro_after_init

Marc Zyngier (6):
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm/arm64: smccc: Make function identifiers an unsigned quantity
  arm/arm64: smccc: Implement SMCCC v1.1 inline primitive

Russell King (27):
  ARM: add more CPU part numbers for Cortex and Brahma B15 CPUs
  ARM: bugs: prepare processor bug infrastructure
  ARM: bugs: hook processor bug checking into SMP and suspend paths
  ARM: bugs: add support for per-processor bug checking
  ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
  ARM: spectre-v2: harden branch predictor on context switches
  ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit
  ARM: spectre-v2: harden user aborts in kernel space
  ARM: spectre-v2: add firmware based hardening
  ARM: spectre-v2: warn about incorrect context switching functions
  ARM: spectre-v1: add speculation barrier (csdb) macros
  ARM: spectre-v1: add array_index_mask_nospec() implementation
  ARM: spectre-v1: fix syscall entry
  ARM: signal: copy registers using __copy_from_user()
  ARM: vfp: use __copy_from_user() when restoring VFP state
  ARM: oabi-compat: copy semops using __copy_from_user()
  ARM: use __inttype() in get_user()
  ARM: spectre-v1: use get_user() for __get_user()
  ARM: spectre-v1: mitigate user accesses
  ARM: uaccess: remove put_user() code duplication
  ARM: make lookup_processor_type() non-__init
  ARM: split out processor lookup
  ARM: clean up per-processor check_bugs method call
  ARM: add PROC_VTABLE and PROC_TABLE macros
  ARM: spectre-v2: per-CPU vtables to work around big.Little systems
  ARM: ensure that processor vtables is not lost after boot
  ARM: fix the cockup in the previous patch

Will Deacon (1):
  drivers/firmware: Expose psci_get_version through psci_ops structure

 arch/arm/include/asm/assembler.h   |  23 +++
 arch/arm/include/asm/barrier.h     |  32 ++++
 arch/arm/include/asm/bugs.h        |   6 +-
 arch/arm/include/asm/cp15.h        |  18 ++
 arch/arm/include/asm/cputype.h     |   9 +
 arch/arm/include/asm/proc-fns.h    |  65 +++++--
 arch/arm/include/asm/system_misc.h |  15 ++
 arch/arm/include/asm/thread_info.h |   8 +-
 arch/arm/include/asm/uaccess.h     | 176 +++++++++++--------
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/bugs.c             |  18 ++
 arch/arm/kernel/cpuidle.c          |   2 +-
 arch/arm/kernel/entry-common.S     |  18 +-
 arch/arm/kernel/entry-header.S     |  25 +++
 arch/arm/kernel/head-common.S      |   6 +-
 arch/arm/kernel/setup.c            |  50 +++---
 arch/arm/kernel/signal.c           | 126 +++++++-------
 arch/arm/kernel/smp.c              |  38 +++-
 arch/arm/kernel/suspend.c          |   2 +
 arch/arm/kernel/sys_oabi-compat.c  |  16 +-
 arch/arm/lib/copy_from_user.S      |   5 +
 arch/arm/lib/copy_to_user.S        |   6 +-
 arch/arm/lib/delay.c               |   2 +-
 arch/arm/lib/uaccess_with_memcpy.c |   3 +-
 arch/arm/mm/Kconfig                |  23 +++
 arch/arm/mm/Makefile               |   2 +-
 arch/arm/mm/fault.c                |   3 +
 arch/arm/mm/mmu.c                  |   2 +-
 arch/arm/mm/proc-macros.S          |  13 +-
 arch/arm/mm/proc-v7-2level.S       |   6 -
 arch/arm/mm/proc-v7-bugs.c         | 161 +++++++++++++++++
 arch/arm/mm/proc-v7.S              | 154 +++++++++++++----
 arch/arm/vfp/vfpmodule.c           |  37 ++--
 arch/parisc/include/asm/cache.h    |   3 +
 drivers/firmware/Kconfig           |   3 +
 drivers/firmware/psci.c            |  58 ++++++-
 include/asm-generic/vmlinux.lds.h  |   1 +
 include/linux/arm-smccc.h          | 267 +++++++++++++++++++++++++++++
 include/linux/cache.h              |  14 ++
 include/linux/psci.h               |  14 ++
 40 files changed, 1174 insertions(+), 257 deletions(-)
 create mode 100644 arch/arm/kernel/bugs.c
 create mode 100644 arch/arm/mm/proc-v7-bugs.c
 create mode 100644 include/linux/arm-smccc.h

-- 
2.21.0.rc0.269.g1a574e7a288b

