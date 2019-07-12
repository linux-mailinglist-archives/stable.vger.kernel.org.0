Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 283426661F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfGLF27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:28:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36211 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:28:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so4004427pgm.3
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4K3r/5Wdr254iLjYKSl69adV6yZJbIJ2hn1Lrtk7Kc=;
        b=NVZkQnegNPxlwCIn65MKGGF1GbTaF2uq76158O65kFUb/fzFE3jaNOLclUX5mHjiSA
         PY0AmYOnElCI40huQj2m0igYf0aXGmsqC9EIIaN/zKG/40BCA2cnv3kjOkX1RIFdaDOC
         kTlPfw/+Be3mBlX3RN19zgjogVPJdLxGP80m+SA5J1QEW+dN0KVzHQEW4l9TeOEYRD8N
         tW5zHUzWxKIeERgRy955GAOWXeushpf/7r8a0sR3vOBH4rzvNr6EC20S4yLTS/Fcn5zn
         1LbXJup+dlE5PR0yjTTCU2MQPpl9d7IGFsEg9mucBeA4gatXg56vypLOwNo0v4E5dDR/
         07Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m4K3r/5Wdr254iLjYKSl69adV6yZJbIJ2hn1Lrtk7Kc=;
        b=h6kPrT/0OCtMRYO1aP5N31sJ0t/WZ+LWVVTxQAuZrKMspa6Um55G2MV5uzD6St1Cyu
         hvTVrXqg82BJSsWjqtrqEhVyzUw3bXeYQVateVe2Qim2l+FhptE1tg7/LamWEXC1Q6tt
         g8nPKObY7obCYdZotrtEkaNMxxxNzt4vX61FLxp0ttQ2y7fEhwUQIzVKbe1NNmuoHccN
         aSIv1ugc0i/mwBIy5vzFHEdfatwyu1SG3rR1ST5D8SA43F02a7bXiG/bR5d9lBKD7jrZ
         yq84Mach8Amf3FDvNfXyMiUIGmSfGwSA1xdMYRMFossXBW9e6AgqLoCCOYTAEEAGf+cG
         lAoA==
X-Gm-Message-State: APjAAAXca0PlPqMI9MeByznQtzlCVq3HPXrnqAJTZtqn8LiocqFcHf/n
        g9uqT6sAAGeN+Ai2O2UmKiAHhbMJSVs=
X-Google-Smtp-Source: APXvYqywonG0vwrNWjfd5sbvfhrvcqS+98gsO6IsK9GIg7HPMbNgUHc61Zc7g3j9ZjVrhTwPn8qY8Q==
X-Received: by 2002:a17:90a:346c:: with SMTP id o99mr9237495pjb.20.1562909338144;
        Thu, 11 Jul 2019 22:28:58 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id d15sm14642756pjc.8.2019.07.11.22.28.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:28:55 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 00/43] V4.4 backport of arm64 Spectre patches
Date:   Fri, 12 Jul 2019 10:57:48 +0530
Message-Id: <cover.1562908074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

This series backports arm64 spectre patches to v4.4 stable kernel. I
have started this backport with Mark Rutland's backport of Spectre to
4.9 [1] and tried applying the upstream version of them over 4.4 and
resolved conflicts by checking how they have been resolved in 4.9.

The KVM changes are mostly dropped as the KVM code in v4.4 is quite
different and it makes backport more complex. This was suggested by the
ARM team.

I had to pick few extra upstream patches to avoid conflicts and to make
things work:

  mm/kasan: add API to check memory regions
  arm64: kasan: instrument user memory access API
  arm64: cpufeature: Add scope for capability check
  arm64: cputype info for Broadcom Vulcan
  arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
  ARM: 8478/2: arm/arm64: add arm-smccc
  arm64: cpufeature: Test 'matches' pointer to find the end of the list
  arm64: Introduce cpu_die_early
  arm64: Move cpu_die_early to smp.c
  arm64: Verify CPU errata work arounds on hotplugged CPU
  arm64: errata: Calling enable functions for CPU errata too
  arm64: Rearrange CPU errata workaround checks


I also had to drop few patches as they weren't getting applied properly
due to missing files/features or they were KVM related:

  arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
  arm64: KVM: Use per-CPU vector when BP hardening is enabled
  arm64: KVM: Make PSCI_VERSION a fast path
  mm: Introduce lm_alias
  arm64: KVM: Increment PC after handling an SMC trap
  arm/arm64: KVM: Consolidate the PSCI include files
  arm/arm64: KVM: Add PSCI_VERSION helper
  arm/arm64: KVM: Add smccc accessors to PSCI code
  arm/arm64: KVM: Implement PSCI 1.0 support
  arm/arm64: KVM: Turn kvm_psci_version into a static inline
  arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling

I have dropped arch/arm64/crypto/sha256-core.S and sha512-core.S files
as they weren't part of the upstream commit. Not sure why it was
included by Mark as the commit log doesn't provide any reasoning for it.

The patches in this series are pushed here [2].

This is tested on Hikey board (octa A53) and I verified that BP
hardening code is getting hit for CPUs (had to hack a bit and enable
BP hardening support for A53 for this).

Changes V1->V2:

- Rebased over 4.4.184 (was 4.4.180 earlier).

- Fixed an build issue with CONFIG_KASAN (Julien).

- Dropped few patches, mostly KVM stuff (Julien):

  arm64: remove duplicate macro __KERNEL__ check
  mm: Introduce lm_alias
  arm64: KVM: Increment PC after handling an SMC trap
  arm/arm64: KVM: Consolidate the PSCI include files
  arm/arm64: KVM: Add PSCI_VERSION helper
  arm/arm64: KVM: Add smccc accessors to PSCI code
  arm/arm64: KVM: Implement PSCI 1.0 support
  arm/arm64: KVM: Turn kvm_psci_version into a static inline
  arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling


- Added few patches to fix issues reported by Julien:

  arm64: cpufeature: Test 'matches' pointer to find the end of the list
  arm64: Introduce cpu_die_early
  arm64: Move cpu_die_early to smp.c
  arm64: Verify CPU errata work arounds on hotplugged CPU
  arm64: errata: Calling enable functions for CPU errata too
  arm64: Rearrange CPU errata workaround checks

--
viresh

[1] https://patches.linaro.org/cover/133195/ with top commit in 4.9 stable tree:
    a3b292fe0560 arm64: futex: Mask __user pointers prior to dereference

[2] https://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git stable/v4.4.y/spectre

-------------------------8<-------------------------

Andre Przywara (1):
  arm64: errata: Calling enable functions for CPU errata too

Andrey Ryabinin (1):
  mm/kasan: add API to check memory regions

Catalin Marinas (1):
  arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm
    macro

James Morse (1):
  arm64: cpufeature: Test 'matches' pointer to find the end of the list

Jayachandran C (3):
  arm64: cputype info for Broadcom Vulcan
  arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
  arm64: Branch predictor hardening for Cavium ThunderX2

Jens Wiklander (1):
  ARM: 8478/2: arm/arm64: add arm-smccc

Marc Zyngier (11):
  arm64: Move post_ttbr_update_workaround to C code
  arm64: Move BP hardening to check_and_switch_context
  arm64: cpu_errata: Allow an erratum to be match for all revisions of a
    core
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm/arm64: smccc: Make function identifiers an unsigned quantity
  arm/arm64: smccc: Implement SMCCC v1.1 inline primitive
  arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
  arm64: Kill PSCI_GET_VERSION as a variant-2 workaround

Robin Murphy (3):
  arm64: Implement array_index_mask_nospec()
  arm64: Make USER_DS an inclusive limit
  arm64: Use pointer masking to limit uaccess speculation

Suzuki K Poulose (6):
  arm64: cpufeature: Add scope for capability check
  arm64: Introduce cpu_die_early
  arm64: Move cpu_die_early to smp.c
  arm64: Verify CPU errata work arounds on hotplugged CPU
  arm64: Rearrange CPU errata workaround checks
  arm64: Run enable method for errata work arounds on late CPUs

Will Deacon (13):
  arm64: barrier: Add CSDB macros to control data-value prediction
  arm64: entry: Ensure branch through syscall table is bounded under
    speculation
  arm64: uaccess: Prevent speculative use of the current addr_limit
  arm64: uaccess: Don't bother eliding access_ok checks in __{get,
    put}_user
  arm64: uaccess: Mask __user pointers for __arch_{clear, copy_*}_user
  arm64: cpufeature: Pass capability structure to ->enable callback
  drivers/firmware: Expose psci_get_version through psci_ops structure
  arm64: Add skeleton to harden the branch predictor against aliasing
    attacks
  arm64: entry: Apply BP hardening for high-priority synchronous
    exceptions
  arm64: entry: Apply BP hardening for suspicious interrupts from EL0
  arm64: cputype: Add missing MIDR values for Cortex-A72 and Cortex-A75
  arm64: Implement branch predictor hardening for affected Cortex-A CPUs
  arm64: futex: Mask __user pointers prior to dereference

Yang Shi (1):
  arm64: kasan: instrument user memory access API

Yury Norov (1):
  arm64: move TASK_* definitions to <asm/processor.h>

 MAINTAINERS                         |  14 ++
 arch/arm64/Kconfig                  |  17 ++
 arch/arm64/include/asm/assembler.h  |  18 ++
 arch/arm64/include/asm/barrier.h    |  23 +++
 arch/arm64/include/asm/cpufeature.h |  24 ++-
 arch/arm64/include/asm/cputype.h    |  12 ++
 arch/arm64/include/asm/futex.h      |   9 +-
 arch/arm64/include/asm/memory.h     |  15 --
 arch/arm64/include/asm/mmu.h        |  39 ++++
 arch/arm64/include/asm/processor.h  |  24 +++
 arch/arm64/include/asm/smp.h        |   1 +
 arch/arm64/include/asm/sysreg.h     |   2 +
 arch/arm64/include/asm/uaccess.h    | 175 ++++++++++++------
 arch/arm64/kernel/Makefile          |   5 +
 arch/arm64/kernel/arm64ksyms.c      |   8 +-
 arch/arm64/kernel/bpi.S             |  75 ++++++++
 arch/arm64/kernel/cpu_errata.c      | 213 +++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c      | 186 +++++++++----------
 arch/arm64/kernel/cpuinfo.c         |   2 -
 arch/arm64/kernel/entry.S           |  26 ++-
 arch/arm64/kernel/smp.c             |  33 +++-
 arch/arm64/lib/clear_user.S         |   6 +-
 arch/arm64/lib/copy_from_user.S     |   4 +-
 arch/arm64/lib/copy_in_user.S       |   4 +-
 arch/arm64/lib/copy_to_user.S       |   4 +-
 arch/arm64/mm/context.c             |  12 ++
 arch/arm64/mm/fault.c               |  31 ++++
 arch/arm64/mm/proc.S                |  12 +-
 drivers/firmware/Kconfig            |   3 +
 drivers/firmware/psci.c             |  58 +++++-
 include/linux/arm-smccc.h           | 267 ++++++++++++++++++++++++++++
 include/linux/kasan-checks.h        |  12 ++
 include/linux/psci.h                |  14 ++
 mm/kasan/kasan.c                    |  12 ++
 34 files changed, 1147 insertions(+), 213 deletions(-)
 create mode 100644 arch/arm64/kernel/bpi.S
 create mode 100644 include/linux/arm-smccc.h
 create mode 100644 include/linux/kasan-checks.h

-- 
2.21.0.rc0.269.g1a574e7a288b

