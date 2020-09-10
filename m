Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93789264AF1
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgIJRSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 13:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgIJQeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:17 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4D7214F1;
        Thu, 10 Sep 2020 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755656;
        bh=EbKsaHrMGipqdlkNMWrSDK54FgK7TIE8FE0oXp7PG6g=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=O8MBc4nUpWRIYSxsBuETqQN6Ya1GFvXlTEHttWKx1tCpsG1riZe3scftiLX9LeGXe
         AlnpvJdkmWLh8V0LvWhc8I0WLvf0G5Wp+KHM5jLoa03q0kF2XFLxDJ6UrxmCezDPmV
         43eZDL6q6SuEJQtSs6MON887lqs4vknyNMIUUFak=
Date:   Thu, 10 Sep 2020 16:34:15 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
In-Reply-To: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
Message-Id: <20200910163416.1D4D7214F1@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Failed to apply! Possible dependencies:
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")

v5.4.63: Failed to apply! Possible dependencies:
    268a2d600130 ("MIPS: Loongson64: Rename CPU TYPES")
    39b2d7565a47 ("MIPS: Kconfig: always select ARC_MEMORY and ARC_PROMLIB for platform")
    6fbde6b492df ("MIPS: Loongson64: Move files to the top-level directory")
    71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
    7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
    863be3c3ab73 ("MIPS: Add header files reference with path prefix")
    8bec3875c547 ("MIPS: Loongson64: Drop legacy IRQ code")
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")

v4.19.143: Failed to apply! Possible dependencies:
    05a0a3441869 ("rtc: mips: default to rtc-cmos on mips")
    69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
    863be3c3ab73 ("MIPS: Add header files reference with path prefix")
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
    eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")

v4.14.196: Failed to apply! Possible dependencies:
    3d8757b87d7f ("s390/sthyi: add s390_sthyi system call")
    69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
    71406883fd35 ("s390/kexec_file: Add kexec_file_load system call")
    840798a1f529 ("s390/kexec_file: Add purgatory")
    863be3c3ab73 ("MIPS: Add header files reference with path prefix")
    87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
    8e6d08e0a15e ("openrisc: initial SMP support")
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
    9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
    b7c92f1a4e13 ("s390/sthyi: reorganize sthyi implementation")
    c33eff600584 ("s390/perf: add perf_regs support and user stack dump")
    e71ea3badae5 ("nds32: Build infrastructure")
    eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
    fbe934d69eb7 ("RISC-V: Build Infrastructure")

v4.9.235: Failed to apply! Possible dependencies:
    043b42bcbbc6 ("arch/openrisc: add option to skip DMA sync as a part of mapping")
    07c75d7a6b9e ("drivers: dma-mapping: allow dma_common_mmap() for NOMMU")
    266c7fad1572 ("openrisc: Consolidate setup to use memblock instead of bootmem")
    34bbdcdcda88 ("openrisc: add NR_CPUS Kconfig default value")
    3e06a1633930 ("openrisc: add cache way information to cpuinfo")
    550116d21a65 ("scripts/spelling.txt: add "aligment" pattern and fix typo instances")
    63104c06a9ed ("openrisc: add l.lwa/l.swa emulation")
    69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
    6d526ee26ccd ("arm64: mm: enable CONFIG_HOLES_IN_ZONE for NUMA")
    7844572c6339 ("lib/dma-noop: Only build dma_noop_ops for s390 and m32r")
    863be3c3ab73 ("MIPS: Add header files reference with path prefix")
    87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
    8c9b7db0de3d ("openrisc: head: refactor out tlb flush into it's own function")
    8e6d08e0a15e ("openrisc: initial SMP support")
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
    da6b21e97e39 ("ARM: Drop fixed 200 Hz timer requirement from Samsung platforms")
    e1231b0e487c ("s390: add cma support")
    e71ea3badae5 ("nds32: Build infrastructure")
    eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")

v4.4.235: Failed to apply! Possible dependencies:
    0d4a619b64ba ("dma-mapping: make the generic coherent dma mmap implementation optional")
    1a2db300348b ("arm64, numa: Add NUMA support for arm64 platforms.")
    37eda9df5bd8 ("ARC: mm: Introduce explicit super page size support")
    42b510eb56de ("h8300: Add LZO compression")
    69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
    6d526ee26ccd ("arm64: mm: enable CONFIG_HOLES_IN_ZONE for NUMA")
    79387179e2e4 ("parisc: convert to dma_map_ops")
    7af3a0a99252 ("arm64/numa: support HAVE_SETUP_PER_CPU_AREA")
    863be3c3ab73 ("MIPS: Add header files reference with path prefix")
    87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
    910cd32e552e ("parisc: Fix and enable seccomp filter support")
    925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
    96ff2d7081cf ("h8300: Add KGDB support.")
    97a23beb8db9 ("clocksource/drivers/h8300_timer8: Separate the Kconfig option from the arch")
    da6b21e97e39 ("ARM: Drop fixed 200 Hz timer requirement from Samsung platforms")
    eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
    fff7fb0b2d90 ("lib/GCD.c: use binary GCD algorithm instead of Euclidean")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
