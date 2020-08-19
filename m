Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B057324AA36
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHSX5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgHSX5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:57:06 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81746214F1;
        Wed, 19 Aug 2020 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881425;
        bh=wRIeCId+LGO7Hn8sD6X/dRYQCCdyvlfe/NUcIoPq9OE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=gH5pV1aUFjRriPe0EuUybV43Bue3tqhsSgulwu0xcJpYoRzSqAkliOA1YGXaHUVz6
         +8GFnvnLDPkkqhqNfU5KH1gAm2h/SVeKoOVAQdK4wp0NDCMnq8mjugTe/kroRuJmhS
         qEvtF+czTjBBRRYuqTl0WDF+J3uRZDp/NQWJykfw=
Date:   Wed, 19 Aug 2020 23:57:04 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
In-Reply-To: <20200811102725.7121-2-will@kernel.org>
References: <20200811102725.7121-2-will@kernel.org>
Message-Id: <20200819235705.81746214F1@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Build OK!
v4.19.139: Failed to apply! Possible dependencies:
    18fc7bf8e041 ("arm64: KVM: Allow for direct call of HYP functions when using VHE")
    208243c752a7 ("KVM: arm64: Move hyp-init.S to nVHE")
    25357de01b95 ("KVM: arm64: Clean up kvm makefiles")
    33e45234987e ("arm64: initialize and switch ptrauth kernel keys")
    396244692232 ("arm64: preempt: Provide our own implementation of asm/preempt.h")
    3f58bf634555 ("KVM: arm/arm64: Share common code in user_mem_abort()")
    6396b852e46e ("KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault")
    748c0e312fce ("KVM: Make kvm_set_spte_hva() return int")
    750319756256 ("arm64: add basic pointer authentication support")
    7621712918ad ("KVM: arm64: Add build rules for separate VHE/nVHE object files")
    7aa8d1464165 ("arm/arm64: KVM: Introduce kvm_call_hyp_ret()")
    86d0dd34eaff ("arm64: cpufeature: add feature for CRC32 instructions")
    90776dd1c427 ("arm64/efi: Move variable assignments after SECTIONS")
    95b861a4a6d9 ("arm64: arch_timer: Add workaround for ARM erratum 1188873")
    a0e50aa3f4a8 ("KVM: arm64: Factor out stage 2 page table data from struct kvm")
    b877e9849d41 ("KVM: arm64: Build hyp-entry.S separately for VHE/nVHE")
    bd4fb6d270bc ("arm64: Add support for SB barrier and patch in over DSB; ISB sequences")
    be1298425665 ("arm64: install user ptrauth keys at kernel exit time")
    d82755b2e781 ("KVM: arm64: Kill off CONFIG_KVM_ARM_HOST")
    f50b6f6ae131 ("KVM: arm64: Handle calls to prefixed hyp functions")
    f56063c51f9f ("arm64: add image head flag definitions")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")

v4.14.193: Failed to apply! Possible dependencies:
    0db9dd8a0fbd ("KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers")
    17ab9d57deba ("KVM: arm/arm64: Drop vcpu parameter from guest cache maintenance operartions")
    3f58bf634555 ("KVM: arm/arm64: Share common code in user_mem_abort()")
    6396b852e46e ("KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault")
    694556d54f35 ("KVM: arm/arm64: Clean dcache to PoC when changing PTE due to CoW")
    748c0e312fce ("KVM: Make kvm_set_spte_hva() return int")
    88dc25e8ea7c ("KVM: arm/arm64: Consolidate page-table accessors")
    91c703e0382a ("arm: KVM: Add optimized PIPT icache flushing")
    a15f693935a9 ("KVM: arm/arm64: Split dcache/icache flushing")
    a9c0e12ebee5 ("KVM: arm/arm64: Only clean the dcache on translation fault")
    d0e22b4ac3ba ("KVM: arm/arm64: Limit icache invalidation to prefetch aborts")
    f8df73388ee2 ("KVM: arm/arm64: Introduce helpers to manipulate page table entries")

v4.9.232: Failed to apply! Possible dependencies:
    1534b3964901 ("KVM: MIPS/MMU: Simplify ASID restoration")
    1581ff3dbf69 ("KVM: MIPS/MMU: Move preempt/ASID handling to implementation")
    1880afd6057f ("KVM: MIPS/T&E: Add lockless GVA access helpers")
    411740f5422a ("KVM: MIPS/MMU: Implement KVM_CAP_SYNC_MMU")
    748c0e312fce ("KVM: Make kvm_set_spte_hva() return int")
    91cdee5710d5 ("KVM: MIPS/T&E: Restore host asid on return to host")
    a2c046e40ff1 ("KVM: MIPS: Add vcpu_run() & vcpu_reenter() callbacks")
    a31b50d741bd ("KVM: MIPS/MMU: Invalidate GVA PTs on ASID changes")
    a60b8438bdba ("KVM: MIPS: Convert get/set_regs -> vcpu_load/put")
    a7ebb2e410f8 ("KVM: MIPS/T&E: active_mm = init_mm in guest context")
    aba8592950f1 ("KVM: MIPS/MMU: Invalidate stale GVA PTEs on TLBW")
    c550d53934d8 ("KVM: MIPS: Remove duplicated ASIDs from vcpu")

v4.4.232: Failed to apply! Possible dependencies:
    16d100db245a ("MIPS: Move Cause.ExcCode trap codes to mipsregs.h")
    1880afd6057f ("KVM: MIPS/T&E: Add lockless GVA access helpers")
    19d194c62b25 ("MIPS: KVM: Simplify TLB_* macros")
    411740f5422a ("KVM: MIPS/MMU: Implement KVM_CAP_SYNC_MMU")
    748c0e312fce ("KVM: Make kvm_set_spte_hva() return int")
    8cffd1974851 ("MIPS: KVM: Convert code to kernel sized types")
    9fbfb06a4065 ("MIPS: KVM: Arrayify struct kvm_mips_tlb::tlb_lo*")
    ba049e93aef7 ("kvm: rename pfn_t to kvm_pfn_t")
    bdb7ed8608f8 ("MIPS: KVM: Convert headers to kernel sized types")
    ca64c2beecd4 ("MIPS: KVM: Abstract guest ASID mask")
    caa1faa7aba6 ("MIPS: KVM: Trivial whitespace and style fixes")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
