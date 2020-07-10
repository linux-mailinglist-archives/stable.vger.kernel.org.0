Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09B21B7A4
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGJOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbgGJOCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:54 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD56207BB;
        Fri, 10 Jul 2020 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389774;
        bh=SZeK8rJC171YOU4lVXYMZlAdCO7KNrVW6K58H8wHpck=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ezpNIuMgrLhoeUXvxgpNxWpjfcRWqvhF+imrjaWguVtD9PVPcSMAJOD5aiselz/er
         oEw9EzXNq3Y9xj0Sl/mwJP4elaNWEs/S8s+W8uBqj7QrffflW2xCbLEbprhm08G5Fz
         KY1AR0pU+LhVrYkZrT8wvpVMFl7RQhYRFikeScvI=
Date:   Fri, 10 Jul 2020 14:02:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] arm64: Introduce a way to disable the 32bit vdso
In-Reply-To: <20200706163802.1836732-2-maz@kernel.org>
References: <20200706163802.1836732-2-maz@kernel.org>
Message-Id: <20200710140253.BDD56207BB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Failed to apply! Possible dependencies:
    04bb96427d4ee ("ARM: 8947/1: Fix __arch_get_hw_counter() access to CNTVCT")
    20e2fc42312f9 ("ARM: 8930/1: Add support for generic vDSO")
    31fdcac07f679 ("arm64: Introduce asm/vdso/clocksource.h")
    5e3c6a312a094 ("ARM/arm64: vdso: Use common vdso clock mode storage")

v4.19.131: Failed to apply! Possible dependencies:
    31fdcac07f679 ("arm64: Introduce asm/vdso/clocksource.h")
    5e3c6a312a094 ("ARM/arm64: vdso: Use common vdso clock mode storage")
    6bf752daca07c ("powerpc: implement CONFIG_DEBUG_VIRTUAL")
    942fa985e9f16 ("32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option")
    aef0f78e7460c ("binfmt_flat: add a ARCH_HAS_BINFMT_FLAT option")
    bdd15a288492f ("binfmt_flat: replace flat_argvp_envp_on_stack with a Kconfig variable")
    c32e64e852f3f ("csky: Build infrastructure")
    e0a9317d90042 ("hexagon: use generic dma_noncoherent_ops")
    ea6a37373f9ac ("MIPS: Avoid FP ELF checks when CONFIG_MIPS_FP_SUPPORT=n")
    f406f222d4b21 ("hexagon: implement the sync_sg_for_device DMA operation")

v4.14.187: Failed to apply! Possible dependencies:
    104daea149c45 ("kconfig: reference environment variables directly and remove 'option env='")
    18492685e479f ("kconfig: use yylineno option instead of manual lineno increments")
    21c54b7747447 ("kconfig: show compiler version text in the top comment")
    31fdcac07f679 ("arm64: Introduce asm/vdso/clocksource.h")
    32a94b8b0c3e5 ("kconfig: remove duplicated file name and lineno of recursive inclusion")
    379a8eb8eb1a5 ("kconfig: detect recursive inclusion earlier")
    5ae6fcc4bb82b ("kconfig: fix line number in recursive inclusion error message")
    5e3c6a312a094 ("ARM/arm64: vdso: Use common vdso clock mode storage")
    79b05c1f31e2e ("um: stop abusing KBUILD_KCONFIG")
    7f5c1ea3b707f ("c6x: use generic dma_noncoherent_ops")
    87a4c375995ed ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
    942fa985e9f16 ("32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option")
    9e3e10c725360 ("kconfig: send error messages to stderr")
    c32e64e852f3f ("csky: Build infrastructure")
    cd81fc82b93fa ("kconfig: add xstrdup() helper")
    d717f24d8c680 ("kconfig: add xrealloc() helper")
    e0a9317d90042 ("hexagon: use generic dma_noncoherent_ops")
    e2c75e7667c73 ("kconfig: tests: test if recursive inclusion is detected")
    e71ea3badae55 ("nds32: Build infrastructure")
    f163977d21a2b ("um: cleanup Kconfig files")
    fbe934d69eb7e ("RISC-V: Build Infrastructure")

v4.9.229: Failed to apply! Possible dependencies:
    2fbadc3002c5f ("arm/arm64: xen: Move shared architecture headers to include/xen/arm")
    31fdcac07f679 ("arm64: Introduce asm/vdso/clocksource.h")
    5299709d0a873 ("treewide: Constify most dma_map_ops structures")
    5e3c6a312a094 ("ARM/arm64: vdso: Use common vdso clock mode storage")
    7f5c1ea3b707f ("c6x: use generic dma_noncoherent_ops")
    942fa985e9f16 ("32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option")
    eb17726b00b32 ("m32r: add simple dma")

v4.4.229: Failed to apply! Possible dependencies:
    0cb0786bac159 ("ARM64: PCI: Support ACPI-based PCI host controller")
    1a4f93f7112fd ("PCI: Factor DT-specific pci_bus_find_domain_nr() code out")
    1bd37a6835bef ("iommu/arm-smmu: Workaround for ThunderX erratum #27704")
    1d8f51d41fc71 ("arm/arm64: arch_timer: Use archdata to indicate vdso suitability")
    21266be9ed542 ("arch: consolidate CONFIG_STRICT_DEVM in lib/Kconfig.debug")
    2ab51ddeca2fc ("ARM64: PCI: Add acpi_pci_bus_find_domain_nr()")
    31fdcac07f679 ("arm64: Introduce asm/vdso/clocksource.h")
    46fd5c6b30594 ("clocksource/drivers/arm_arch_timer: Control the evtstrm via the cmdline")
    4e3e9b6997b24 ("iommu/arm-smmu: Add support for 16 bit VMID")
    5e3c6a312a094 ("ARM/arm64: vdso: Use common vdso clock mode storage")
    75df1386557c2 ("iommu/arm-smmu: Invalidate TLBs properly")
    942fa985e9f16 ("32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option")
    9c7cb891ecfea ("PCI: Refactor pci_bus_assign_domain_nr() for CONFIG_PCI_DOMAINS_GENERIC")
    cd5f22d7967f6 ("arm64: arch_timer: simplify accessors")
    f6dc1576cd517 ("arm64: arch_timer: Work around QorIQ Erratum A-008585")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
