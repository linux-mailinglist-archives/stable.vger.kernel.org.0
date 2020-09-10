Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6112649EA
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIJQfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 12:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgIJQeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:19 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDFD921D40;
        Thu, 10 Sep 2020 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755659;
        bh=2QMH3EaTgyySQCirLwLGtnA3PRfG10C3TFBpM29IzL4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=OgwqIrQU51rq8aXzHmXhhbK0esBMKz5Y2L92cG2JMfzwPBZeDkMEKNCY1mRVfJtC6
         Nuv0K5+bxnjGoSDtYMKOrMdfwF2Ebf7msKzFxGpuYmL1s227jSPy0VGr14Bu4ZYEUc
         pEl1D1/g9+1AK7sFQfg0/53F+sH9aNfO0P4IBoxg=
Date:   Thu, 10 Sep 2020 16:34:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
In-Reply-To: <20200909210527.1926996-1-maz@kernel.org>
References: <20200909210527.1926996-1-maz@kernel.org>
Message-Id: <20200910163418.EDFD921D40@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Failed to apply! Possible dependencies:
    0e20f5e25556 ("KVM: arm/arm64: Cleanup MMIO handling")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    5ffdfaedfa0a ("arm64: mm: Support Common Not Private translations")
    86d0dd34eaff ("arm64: cpufeature: add feature for CRC32 instructions")
    caab277b1de0 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 234")
    d94d71cb45fd ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 266")

v4.14.196: Failed to apply! Possible dependencies:
    1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
    2e0f2478ea37 ("arm64/sve: Probe SVE capabilities and usable vector lengths")
    43994d824e84 ("arm64/sve: Detect SVE and activate runtime support")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    611a7bc74ed2 ("arm64: docs: describe ELF hwcaps")
    746647c75afb ("arm64: entry.S convert el0_sync")
    7582e22038a2 ("arm64/sve: Backend logic for setting the vector length")
    79ab047c75d6 ("arm64/sve: Support vector length resetting for new processes")
    94ef7ecbdf6f ("arm64: fpsimd: Correctly annotate exception helpers called from asm")
    bc0ee4760364 ("arm64/sve: Core task context handling")
    ddd25ad1fde8 ("arm64/sve: Kconfig update and conditional compilation support")

v4.9.235: Failed to apply! Possible dependencies:
    016f98afd050 ("irqchip/gic-v3: Use nops macro for Cavium ThunderX erratum 23154")
    0e9884fe63c6 ("arm64: sysreg: subsume GICv3 sysreg definitions")
    328191c05ed7 ("irqchip/gic-v3-its: Specialise flush_dcache operation")
    38fd94b0275c ("arm64: Work around Falkor erratum 1003")
    43994d824e84 ("arm64/sve: Detect SVE and activate runtime support")
    47863d41ecf8 ("arm64: sysreg: sort by encoding")
    4aa8a472c33f ("arm64: Documentation - Expose CPU feature registers")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    611a7bc74ed2 ("arm64: docs: describe ELF hwcaps")
    6e01398fe450 ("arm64: arch_timer: document Hisilicon erratum 161010101")
    b20d1ba3cf4b ("arm64: cpufeature: allow for version discrepancy in PMU implementations")
    b389d7997acb ("arm64: cpufeature: treat unknown fields as RES0")
    bca8f17f57bd ("arm64: Get rid of asm/opcodes.h")
    c7a3c61fc606 ("arm64: sysreg: add performance monitor registers")
    cd9e1927a525 ("arm64: Work around broken .inst when defective gas is detected")
    d9ff80f83ecb ("arm64: Work around Falkor erratum 1009")
    eab43e88734f ("arm64: cpufeature: Cleanup feature bit tables")
    eeb1efbcb83c ("arm64: cpu_errata: Add capability to advertise Cortex-A73 erratum 858921")
    f31deaadff0d ("arm64: cpufeature: Don't enforce system-wide SPE capability")
    fe4fbdbcddea ("arm64: cpufeature: Track user visible fields")

v4.4.235: Failed to apply! Possible dependencies:
    06282fd2c2bf ("arm64: KVM: Implement vgic-v2 save/restore")
    0e9884fe63c6 ("arm64: sysreg: subsume GICv3 sysreg definitions")
    1b8e83c04ee2 ("arm64: KVM: vgic-v3: Avoid accessing ICH registers")
    2d81d425b6d5 ("irqchip/gicv3-its: Introduce two helper functions for accessing BASERn")
    328191c05ed7 ("irqchip/gic-v3-its: Specialise flush_dcache operation")
    3c13b8f435ac ("KVM: arm/arm64: vgic-v3: Make the LR indexing macro public")
    3faf24ea894a ("irqchip/gicv3-its: Implement two-level(indirect) device table support")
    466b7d168881 ("irqchip/gicv3-its: Don't allow devices whose ID is outside range")
    4b75c4598b5b ("irqchip/gicv3-its: Add a new function for parsing device table BASERn")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    91ef84428a86 ("irqchip/gic-v3: Reset BPR during initialization")
    9347359ad0ae ("irqchip/gicv3-its: Split its_alloc_tables() into two functions")
    b5525ce898eb ("arm64: KVM: Move GIC accessors to arch_gicv3.h")
    c76a0a6695c6 ("arm64: KVM: Add a HYP-specific header file")
    d44ffa5ae70a ("irqchip/gic-v3: Convert arm64 GIC accessors to {read,write}_sysreg_s")
    f68d2b1b73cc ("arm64: KVM: Implement vgic-v3 save/restore")
    fd451b90e78c ("arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
