Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1949E22B430
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGWRJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 13:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgGWRJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 13:09:56 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE50020792;
        Thu, 23 Jul 2020 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595524196;
        bh=zWBramFwfIq96ZanHlzrQMRyCizT60I84HwMEnDiE9w=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=UMSbWQVjXwXhk1PhANbTm9ErnldbGyI5qIKyHLwgstgUtR/b3GHcDpYDm5J+BgFRe
         xYKQaD9wX24MFrs1IhzvWHo8OJuN0EUW2c6/1QZ05ebX3r24SiWhMa+voMZyjbeTVO
         //yPY2ltHZLz5CtXER5BChTkv4/mxybUqyDELI9E=
Date:   Thu, 23 Jul 2020 17:09:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, james.morse@arm.com
Cc:     Marc Zyngier <maz@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Don't inherit exec permission across page-table levels
In-Reply-To: <20200723101714.15873-1-will@kernel.org>
References: <20200723101714.15873-1-will@kernel.org>
Message-Id: <20200723170955.DE50020792@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Build OK!
v4.19.134: Failed to apply! Possible dependencies:
    3f58bf634555 ("KVM: arm/arm64: Share common code in user_mem_abort()")
    4ea5af531140 ("KVM: arm64: Support dirty page tracking for PUD hugepages")
    6396b852e46e ("KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault")
    7788a28062ac ("kvm: arm/arm64: Remove spurious WARN_ON")
    86d1c55ea605 ("KVM: arm64: Support PUD hugepage in stage2_is_exec()")
    b8e0ba7c8bea ("KVM: arm64: Add support for creating PUD hugepages at stage 2")
    e55cac5bf2a9 ("kvm: arm/arm64: Prepare for VM specific stage2 translations")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")

v4.14.189: Failed to apply! Possible dependencies:
    0db9dd8a0fbd ("KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers")
    17ab9d57deba ("KVM: arm/arm64: Drop vcpu parameter from guest cache maintenance operartions")
    3f58bf634555 ("KVM: arm/arm64: Share common code in user_mem_abort()")
    4ea5af531140 ("KVM: arm64: Support dirty page tracking for PUD hugepages")
    6396b852e46e ("KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault")
    86d1c55ea605 ("KVM: arm64: Support PUD hugepage in stage2_is_exec()")
    88dc25e8ea7c ("KVM: arm/arm64: Consolidate page-table accessors")
    91c703e0382a ("arm: KVM: Add optimized PIPT icache flushing")
    a15f693935a9 ("KVM: arm/arm64: Split dcache/icache flushing")
    a9c0e12ebee5 ("KVM: arm/arm64: Only clean the dcache on translation fault")
    d0e22b4ac3ba ("KVM: arm/arm64: Limit icache invalidation to prefetch aborts")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")

v4.9.231: Failed to apply! Possible dependencies:
    0966253d7ccd ("kvm: arm64: Convert kvm_set_s2pte_readonly() from inline asm to cmpxchg()")
    0db9dd8a0fbd ("KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers")
    13b7756cec3d ("arm/arm64: KVM: Stop propagating cacheability status of a faulted page")
    155433cb365e ("arm64: cache: Remove support for ASID-tagged VIVT I-caches")
    196f878a7ac2 ("KVM: arm/arm64: Signal SIGBUS when stage2 discovers hwpoison memory")
    3689c75af2a3 ("arm64: cpuinfo: remove I-cache VIPT aliasing detection")
    3bbf7157ac66 ("arm64: Convert pte handling from inline asm to using (cmp)xchg")
    3f58bf634555 ("KVM: arm/arm64: Share common code in user_mem_abort()")
    4ea5af531140 ("KVM: arm64: Support dirty page tracking for PUD hugepages")
    6396b852e46e ("KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault")
    6d332747fa5f ("arm64: Fix potential race with hardware DBM in ptep_set_access_flags()")
    73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
    86d1c55ea605 ("KVM: arm64: Support PUD hugepage in stage2_is_exec()")
    87da236ebc71 ("arm64: KVM: Add support for VPIPT I-caches")
    88dc25e8ea7c ("KVM: arm/arm64: Consolidate page-table accessors")
    a15f693935a9 ("KVM: arm/arm64: Split dcache/icache flushing")
    b20d1ba3cf4b ("arm64: cpufeature: allow for version discrepancy in PMU implementations")
    b389d7997acb ("arm64: cpufeature: treat unknown fields as RES0")
    d0e22b4ac3ba ("KVM: arm/arm64: Limit icache invalidation to prefetch aborts")
    e7c600f149b8 ("arm64: hwpoison: add VM_FAULT_HWPOISON[_LARGE] handling")
    eab43e88734f ("arm64: cpufeature: Cleanup feature bit tables")
    f31deaadff0d ("arm64: cpufeature: Don't enforce system-wide SPE capability")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")
    fe4fbdbcddea ("arm64: cpufeature: Track user visible fields")

v4.4.231: Failed to apply! Possible dependencies:
    06282fd2c2bf ("arm64: KVM: Implement vgic-v2 save/restore")
    064850532444 ("kvm: arm64: Enable hardware updates of the Access Flag for Stage 2 page tables")
    0db9dd8a0fbd ("KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers")
    0f54b14e76f5 ("arm64: cpufeature: Change read_cpuid() to use sysreg's mrs_s macro")
    1431af367e52 ("arm64: KVM: Implement timer save/restore")
    20475f784d29 ("arm64: KVM: Add support for 16-bit VMID")
    35a2491a624a ("arm/arm64: KVM: Add hook for C-based stage2 init")
    3a3604bc5eb4 ("arm64: KVM: Switch to C-based stage2 init")
    406e308770a9 ("arm64: add ARMv8.2 id_aa64mmfr2 boiler plate")
    4ea5af531140 ("KVM: arm64: Support dirty page tracking for PUD hugepages")
    6d6ec20fcf28 ("arm64: KVM: Implement system register save/restore")
    8420dcd37ef3 ("arm: KVM: Make kvm_arm.h friendly to assembly code")
    86d1c55ea605 ("KVM: arm64: Support PUD hugepage in stage2_is_exec()")
    8eb992674c9e ("arm64: KVM: Implement debug save/restore")
    a563f7598198 ("arm64: Reuse TCR field definitions for EL1 and EL2")
    bbb3b6b35087 ("kvm-arm: Replace kvm_pmd_huge with pmd_thp_or_huge")
    c13d1683df16 ("arm64: KVM: Implement fpsimd save/restore")
    c76a0a6695c6 ("arm64: KVM: Add a HYP-specific header file")
    cb678d601651 ("arm64: kvm: 4.6-rc1: Fix VTCR_EL2 VS setting")
    d5370f754875 ("arm64: prefetch: add alternative pattern for CPUs without a prefetcher")
    f68d2b1b73cc ("arm64: KVM: Implement vgic-v3 save/restore")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
