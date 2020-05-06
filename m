Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCE1C7E12
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgEFXmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgEFXmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:13 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1232420746;
        Wed,  6 May 2020 23:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808533;
        bh=r2PjVq08MkI4sCeFSCkFgm4ZwqlJIAaMJRQlBvCzcj0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Di4L43qTVHhmhV+wkQS3BCL93hw1eHIzdybD9XufTujPt3dmBOrO6Cta4U9ALDLBa
         l4tNFD+yTleSE6yXgiocKJB2zVVGkNV/fLdaifWDGu/nQDxo7d49MLEndSwSaKDdDI
         RaoOp3Kgk57JtlMJaukH4wRE3ohyg6yZupw3LMeU=
Date:   Wed, 06 May 2020 23:42:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: arm64: Fix 32bit PC wrap-around
In-Reply-To: <20200501101204.364798-5-maz@kernel.org>
References: <20200501101204.364798-5-maz@kernel.org>
Message-Id: <20200506234213.1232420746@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.8, v5.4.36, v4.19.119, v4.14.177, v4.9.220, v4.4.220.

v5.6.8: Build OK!
v5.4.36: Build OK!
v4.19.119: Build OK!
v4.14.177: Failed to apply! Possible dependencies:
    00536ec47660 ("KVM: arm/arm64: Prepare to handle deferred save/restore of SPSR_EL1")
    256c0960b7b6 ("kvm/arm: use PSR_AA32 definitions")
    52f6c4f02164 ("KVM: arm64: Change 32-bit handling of VM system registers")
    54ceb1bcf8d8 ("KVM: arm64: Move debug dirty flag calculation out of world switch")
    623e1528d409 ("KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation")
    74a64a981662 ("KVM: arm/arm64: Unify 32bit fault injection")
    8d404c4c2461 ("KVM: arm64: Rewrite system register accessors to read/write functions")
    a892819560c4 ("KVM: arm64: Prepare to handle deferred save/restore of 32-bit registers")
    b220244d4179 ("arm64: vgic-v2: Fix proxying of cpuif access")

v4.9.220: Failed to apply! Possible dependencies:
    021234ef3752 ("KVM: arm64: Make kvm_condition_valid32() accessible from EL2")
    256c0960b7b6 ("kvm/arm: use PSR_AA32 definitions")
    3dbbdf78636e ("KVM: arm/arm64: Report PMU overflow interrupts to userspace irqchip")
    52f6c4f02164 ("KVM: arm64: Change 32-bit handling of VM system registers")
    54ceb1bcf8d8 ("KVM: arm64: Move debug dirty flag calculation out of world switch")
    623e1528d409 ("KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation")
    6c0070366dea ("arm64: KVM: PMU: Refactor pmu_*_el0_disabled")
    74a64a981662 ("KVM: arm/arm64: Unify 32bit fault injection")
    8d404c4c2461 ("KVM: arm64: Rewrite system register accessors to read/write functions")
    9171fa2e0951 ("KVM: arm/arm64: Decouple kvm timer functions from virtual timer")
    a5a1d1c2914b ("clocksource: Use a plain u64 instead of cycle_t")
    b7484931e4a8 ("KVM: arm/arm64: PMU: remove request-less vcpu kick")
    d9e139778376 ("KVM: arm/arm64: Support arch timers with a userspace gic")
    d9f89b4e9290 ("KVM: arm/arm64: PMU: Fix overflow interrupt injection")
    f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when entering/leaving a VM")

v4.4.220: Failed to apply! Possible dependencies:
    08dcbfda0774 ("ARM: KVM: Add a HYP-specific header file")
    1d58d2cbf723 ("ARM: KVM: Add TLB invalidation code")
    33280b4cd1dc ("ARM: KVM: Add banked registers save/restore")
    3c29568768df ("ARM: KVM: Add system register accessor macros")
    59cbcdb5d83b ("ARM: KVM: Add VFP save/restore")
    623e1528d409 ("KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation")
    68130cb5db09 ("ARM: KVM: Use common version of timer-sr.c")
    b5fa5d3e628b ("ARM: KVM: Use common version of vgic-v2-sr.c")
    c0c2cdbffef2 ("ARM: KVM: Add vgic v2 save/restore")
    c7ce6c63a05f ("ARM: KVM: Add CP15 save/restore code")
    e59bff9bf302 ("ARM: KVM: Add timer save/restore")
    f1c9cad7c508 ("ARM: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
