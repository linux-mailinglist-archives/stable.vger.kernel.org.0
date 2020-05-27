Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34C1E4B2D
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgE0Q6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgE0Q6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:58:00 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FD82088E;
        Wed, 27 May 2020 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590598680;
        bh=hVDbqyunzoY5eUjoD+ZZlE5Jv2a7JNgahubQFoF36cU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=v9VY/fJ11OaNqD+cUZB7csfy2So+3PZ4DSS78XzUlw22ujaY2vlJ3YVTo8nrSgHMD
         CUmew/bRAoIHF1FN0nIwiasKvoI66+vMJm6uSCsY4H0hL/jauhPL2Nz3HQ6moyG1mz
         k+T3K3vAaqy+PM1+s1x0TmJYtuOhEC8i0MflrMQA=
Date:   Wed, 27 May 2020 16:57:59 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     James Morse <james.morse@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
In-Reply-To: <20200526161834.29165-2-james.morse@arm.com>
References: <20200526161834.29165-2-james.morse@arm.com>
Message-Id: <20200527165800.64FD82088E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Failed to apply! Possible dependencies:
    f7f2b15c3d42 ("arm64: KVM: Expose sanitised cache type register to guest")

v4.14.181: Failed to apply! Possible dependencies:
    005781be127f ("arm64: KVM: Move CPU ID reg trap setup off the world switch path")
    93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")
    f7f2b15c3d42 ("arm64: KVM: Expose sanitised cache type register to guest")

v4.9.224: Failed to apply! Possible dependencies:
    005781be127f ("arm64: KVM: Move CPU ID reg trap setup off the world switch path")
    016f98afd050 ("irqchip/gic-v3: Use nops macro for Cavium ThunderX erratum 23154")
    0d449541c185 ("KVM: arm64: use common invariant sysreg definitions")
    0e9884fe63c6 ("arm64: sysreg: subsume GICv3 sysreg definitions")
    14ae7518dd55 ("arm64: sysreg: add register encodings used by KVM")
    47863d41ecf8 ("arm64: sysreg: sort by encoding")
    82e0191a1aa1 ("arm64: Support systems without FP/ASIMD")
    851050a573e1 ("KVM: arm64: Use common sysreg definitions")
    93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")
    bca8f17f57bd ("arm64: Get rid of asm/opcodes.h")
    c7a3c61fc606 ("arm64: sysreg: add performance monitor registers")
    c9a3c58f01fb ("KVM: arm64: Add the EL1 physical timer access handler")
    cd9e1927a525 ("arm64: Work around broken .inst when defective gas is detected")
    f7f2b15c3d42 ("arm64: KVM: Expose sanitised cache type register to guest")

v4.4.224: Failed to apply! Possible dependencies:
    005781be127f ("arm64: KVM: Move CPU ID reg trap setup off the world switch path")
    06282fd2c2bf ("arm64: KVM: Implement vgic-v2 save/restore")
    068a17a5805d ("arm64: mm: create new fine-grained mappings at boot")
    072f0a633838 ("arm64: Introduce raw_{d,i}cache_line_size")
    0a28714c53fd ("arm64: Use PoU cache instr for I/D coherency")
    116c81f427ff ("arm64: Work around systems with mismatched cache line sizes")
    1431af367e52 ("arm64: KVM: Implement timer save/restore")
    157962f5a8f2 ("arm64: decouple early fixmap init from linear mapping")
    1e48ef7fcc37 ("arm64: add support for building vmlinux as a relocatable PIE binary")
    2a803c4db615 ("arm64: head.S: use memset to clear BSS")
    57f4959bad0a ("arm64: kernel: Add support for User Access Override")
    6d6ec20fcf28 ("arm64: KVM: Implement system register save/restore")
    7b7293ae3dbd ("arm64: Fold proc-macros.S into assembler.h")
    82869ac57b5d ("arm64: kernel: Add support for hibernate/suspend-to-disk")
    82e0191a1aa1 ("arm64: Support systems without FP/ASIMD")
    8eb992674c9e ("arm64: KVM: Implement debug save/restore")
    910917bb7db0 ("arm64: KVM: Map the kernel RO section into HYP")
    93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")
    9e8e865bbe29 ("arm64: unify idmap removal")
    a0bf9776cd0b ("arm64: kvm: deal with kernel symbols outside of linear mapping")
    a7f8de168ace ("arm64: allow kernel Image to be loaded anywhere in physical memory")
    ab893fb9f1b1 ("arm64: introduce KIMAGE_VADDR as the virtual base of the kernel region")
    adc9b2dfd009 ("arm64: kernel: Rework finisher callback out of __cpu_suspend_enter()")
    b3122023df93 ("arm64: Fix an enum typo in mm/dump.c")
    b97b66c14b96 ("arm64: KVM: Implement guest entry")
    be901e9b15cd ("arm64: KVM: Implement the core world switch")
    c1a88e9124a4 ("arm64: kasan: avoid TLB conflicts")
    c76a0a6695c6 ("arm64: KVM: Add a HYP-specific header file")
    d5370f754875 ("arm64: prefetch: add alternative pattern for CPUs without a prefetcher")
    f68d2b1b73cc ("arm64: KVM: Implement vgic-v3 save/restore")
    f7f2b15c3d42 ("arm64: KVM: Expose sanitised cache type register to guest")
    f80fb3a3d508 ("arm64: add support for kernel ASLR")
    f9040773b7bb ("arm64: move kernel image to base of vmalloc area")
    fd045f6cd98e ("arm64: add support for module PLTs")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
