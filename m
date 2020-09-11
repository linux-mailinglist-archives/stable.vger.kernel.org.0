Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEE92655F7
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 02:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725298AbgIKAL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 20:11:56 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:39014 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKALz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 20:11:55 -0400
Received: by mail-il1-f196.google.com with SMTP id u20so7464626ilk.6;
        Thu, 10 Sep 2020 17:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HrLOasL3P/79xVGXjr92GV0KbeWbK4QLTc4TRGP5iQ=;
        b=EpPi5zo64i3+ZrnfOkue/tKqD68BrrRA4n2qQ82/ROPys57Y9/NUq3fnAbsdiN1TFW
         SaxttGKpbRZ29mCPkQqwuT19Ek2UEN5HJoQcFCkTXcR9eBWEx91OXohcRZiPVUXBai2S
         AWvw+OllEOmiJ4PtLSX+T5RtrBBQNP9JnbMEQ0LBVW9OqQRCPbPuqHFraI3tCQ60Ifjf
         lU49nCxDy2JayjaL8Hy9VIZChFmnS6F2DSCUsCcabzSw9HXm7iT+AQ80ObUGb9lcvVdN
         /pZ0M5FtbNWsYXq0MuYM2APGvQOkaOLZvpPHgrQaPt0xpuoimDu4UQIXshlf7cGO2qfG
         zGOw==
X-Gm-Message-State: AOAM530x4gja2XUrecURpTPwGAwqxikbAFJuh5/w/Lj44zMZjeowsPOh
        l0EZHr6qSRQ7u1EabZQCLSASMgrpH1f49E6Wuk0eUqXwL1Y=
X-Google-Smtp-Source: ABdhPJwmramD28LvRjqdLoZhq9sRBYXdRymIiyg1T9stG+kEjGN3ykPMGYGjDZCUIlyBUN96vUThi9wM0FzGxfFLkdc=
X-Received: by 2002:a92:c083:: with SMTP id h3mr10384588ile.208.1599783114271;
 Thu, 10 Sep 2020 17:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com> <20200910163416.1D4D7214F1@mail.kernel.org>
In-Reply-To: <20200910163416.1D4D7214F1@mail.kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 08:11:42 +0800
Message-ID: <CAAhV-H5Uz_twuTE5cW_jS5eniwCtccPJuMXKB1axUBJhhdr2hQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
To:     Sasha Levin <sashal@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

On Fri, Sep 11, 2020 at 1:21 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.
>
> v5.8.7: Failed to apply! Possible dependencies:
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>
> v5.4.63: Failed to apply! Possible dependencies:
>     268a2d600130 ("MIPS: Loongson64: Rename CPU TYPES")
>     39b2d7565a47 ("MIPS: Kconfig: always select ARC_MEMORY and ARC_PROMLIB for platform")
>     6fbde6b492df ("MIPS: Loongson64: Move files to the top-level directory")
>     71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
>     7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
>     863be3c3ab73 ("MIPS: Add header files reference with path prefix")
>     8bec3875c547 ("MIPS: Loongson64: Drop legacy IRQ code")
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>
> v4.19.143: Failed to apply! Possible dependencies:
>     05a0a3441869 ("rtc: mips: default to rtc-cmos on mips")
>     69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
>     863be3c3ab73 ("MIPS: Add header files reference with path prefix")
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>     eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
>
> v4.14.196: Failed to apply! Possible dependencies:
>     3d8757b87d7f ("s390/sthyi: add s390_sthyi system call")
>     69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
>     71406883fd35 ("s390/kexec_file: Add kexec_file_load system call")
>     840798a1f529 ("s390/kexec_file: Add purgatory")
>     863be3c3ab73 ("MIPS: Add header files reference with path prefix")
>     87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
>     8e6d08e0a15e ("openrisc: initial SMP support")
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>     9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
>     b7c92f1a4e13 ("s390/sthyi: reorganize sthyi implementation")
>     c33eff600584 ("s390/perf: add perf_regs support and user stack dump")
>     e71ea3badae5 ("nds32: Build infrastructure")
>     eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
>     fbe934d69eb7 ("RISC-V: Build Infrastructure")
>
> v4.9.235: Failed to apply! Possible dependencies:
>     043b42bcbbc6 ("arch/openrisc: add option to skip DMA sync as a part of mapping")
>     07c75d7a6b9e ("drivers: dma-mapping: allow dma_common_mmap() for NOMMU")
>     266c7fad1572 ("openrisc: Consolidate setup to use memblock instead of bootmem")
>     34bbdcdcda88 ("openrisc: add NR_CPUS Kconfig default value")
>     3e06a1633930 ("openrisc: add cache way information to cpuinfo")
>     550116d21a65 ("scripts/spelling.txt: add "aligment" pattern and fix typo instances")
>     63104c06a9ed ("openrisc: add l.lwa/l.swa emulation")
>     69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
>     6d526ee26ccd ("arm64: mm: enable CONFIG_HOLES_IN_ZONE for NUMA")
>     7844572c6339 ("lib/dma-noop: Only build dma_noop_ops for s390 and m32r")
>     863be3c3ab73 ("MIPS: Add header files reference with path prefix")
>     87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
>     8c9b7db0de3d ("openrisc: head: refactor out tlb flush into it's own function")
>     8e6d08e0a15e ("openrisc: initial SMP support")
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>     da6b21e97e39 ("ARM: Drop fixed 200 Hz timer requirement from Samsung platforms")
>     e1231b0e487c ("s390: add cma support")
>     e71ea3badae5 ("nds32: Build infrastructure")
>     eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
>
> v4.4.235: Failed to apply! Possible dependencies:
>     0d4a619b64ba ("dma-mapping: make the generic coherent dma mmap implementation optional")
>     1a2db300348b ("arm64, numa: Add NUMA support for arm64 platforms.")
>     37eda9df5bd8 ("ARC: mm: Introduce explicit super page size support")
>     42b510eb56de ("h8300: Add LZO compression")
>     69a07a41d908 ("MIPS: SGI-IP27: rework HUB interrupts")
>     6d526ee26ccd ("arm64: mm: enable CONFIG_HOLES_IN_ZONE for NUMA")
>     79387179e2e4 ("parisc: convert to dma_map_ops")
>     7af3a0a99252 ("arm64/numa: support HAVE_SETUP_PER_CPU_AREA")
>     863be3c3ab73 ("MIPS: Add header files reference with path prefix")
>     87a4c375995e ("kconfig: include kernel/Kconfig.preempt from init/Kconfig")
>     910cd32e552e ("parisc: Fix and enable seccomp filter support")
>     925a567542c5 ("MIPS: Loongson64: Adjust IRQ layout")
>     96ff2d7081cf ("h8300: Add KGDB support.")
>     97a23beb8db9 ("clocksource/drivers/h8300_timer8: Separate the Kconfig option from the arch")
>     da6b21e97e39 ("ARM: Drop fixed 200 Hz timer requirement from Samsung platforms")
>     eb01d42a7778 ("PCI: consolidate PCI config entry in drivers/pci")
>     fff7fb0b2d90 ("lib/GCD.c: use binary GCD algorithm instead of Euclidean")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
I'm sorry that this patch is only needed in 5.9+, please ignore my noise.

Huacai
>
> --
> Thanks
> Sasha
