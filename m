Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADB32E9CF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 02:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfE3AqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 20:46:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfE3AqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 20:46:11 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3847281F12;
        Thu, 30 May 2019 00:46:10 +0000 (UTC)
Received: from localhost (ovpn-12-25.pek2.redhat.com [10.72.12.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93290617BE;
        Thu, 30 May 2019 00:46:09 +0000 (UTC)
Date:   Thu, 30 May 2019 08:46:01 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@kernel.org, bp@alien8.de, stable@vger.kernel.org
Subject: Re: [PATCH v5] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190530004601.GT3805@MiWiFi-R3L-srv>
References: <20190523025744.3756-1-bhe@redhat.com>
 <20190529131454.9818321019@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529131454.9818321019@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 30 May 2019 00:46:10 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 05/29/19 at 01:14pm, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178, v4.4.180, v3.18.140.

I marked below commit with 'Fixes' tag.
Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")

[bhe@ linux]$ git describe --contains eedb92abb9bb
v4.17-rc1~171^2~51

You can see that it was added in kernel 4.17-rc1, as above. Can we just
apply this patch to stable trees after 4.17?

> 
> v5.1.4: Build OK!
> v5.0.18: Build OK!
> v4.19.45: Build OK!

We just apply it to above three trees which are after 4.17, and the build
for them is OK. Can we?

Thanks
Baoquan

> v4.14.121: Failed to apply! Possible dependencies:
>     4c2b4058ab325 ("x86/mm: Initialize 'pgtable_l5_enabled' at boot-time")
>     4fa5662b6b496 ("x86/mm: Initialize 'page_offset_base' at boot-time")
>     5c7919bb1994f ("x86/mm: Make LDT_BASE_ADDR dynamic")
>     a7412546d8cb5 ("x86/mm: Adjust vmalloc base and size at boot-time")
>     b16e770bfa534 ("x86/mm: Initialize 'pgdir_shift' and 'ptrs_per_p4d' at boot-time")
>     c65e774fb3f6a ("x86/mm: Make PGDIR_SHIFT and PTRS_PER_P4D variable")
>     e626e6bb0dfac ("x86/mm: Introduce 'pgtable_l5_enabled'")
>     eedb92abb9bb0 ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")
> 
> v4.9.178: Failed to apply! Possible dependencies:
>     4c7c44837be77 ("x86/mm: Define virtual memory map for 5-level paging")
>     5c7919bb1994f ("x86/mm: Make LDT_BASE_ADDR dynamic")
>     69218e47994da ("x86: Remap GDT tables in the fixmap section")
>     92a0f81d89571 ("x86/cpu_entry_area: Move it out of the fixmap")
>     a7412546d8cb5 ("x86/mm: Adjust vmalloc base and size at boot-time")
>     aaeed3aeb39c1 ("x86/entry/gdt: Put per-CPU GDT remaps in ascending order")
>     b23adb7d3f7d1 ("x86/xen/gdt: Use X86_FEATURE_XENPV instead of globals for the GDT fixup")
>     b7ffc44d5b2ea ("x86/kvm/vmx: Defer TR reload after VM exit")
>     b9b1a9c363ff7 ("x86/boot/smp/32: Fix initial idle stack location on 32-bit kernels")
>     ed1bbc40a0d10 ("x86/cpu_entry_area: Move it to a separate unit")
>     ef8813ab28050 ("x86/mm/fixmap: Generalize the GDT fixmap mechanism, introduce struct cpu_entry_area")
> 
> v4.4.180: Failed to apply! Possible dependencies:
>     021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory regions")
>     0483e1fa6e09d ("x86/mm: Implement ASLR for kernel memory regions")
>     071a74930e60d ("x86/KASLR: Add virtual address choosing function")
>     206f25a8319b3 ("x86/KASLR: Remove unneeded boot_params argument")
>     2bc1cd39fa9f6 ("x86/boot: Clean up pointer casting")
>     3a94707d7a7bb ("x86/KASLR: Build identity mappings on demand")
>     4252db10559fc ("x86/KASLR: Update description for decompressor worst case size")
>     4c7c44837be77 ("x86/mm: Define virtual memory map for 5-level paging")
>     5c7919bb1994f ("x86/mm: Make LDT_BASE_ADDR dynamic")
>     6655e0aaf768c ("x86/boot: Rename "real_mode" to "boot_params"")
>     7de828dfe6070 ("x86/KASLR: Clarify purpose of kaslr.c")
>     8665e6ff21072 ("x86/boot: Clean up indenting for asm/boot.h")
>     9016875df408f ("x86/KASLR: Rename "random" to "random_addr"")
>     92a0f81d89571 ("x86/cpu_entry_area: Move it out of the fixmap")
>     9b238748cb6e9 ("x86/KASLR: Rename aslr.c to kaslr.c")
>     9dc1969c24eff ("x86/KASLR: Consolidate mem_avoid[] entries")
>     a7412546d8cb5 ("x86/mm: Adjust vmalloc base and size at boot-time")
>     d2d3462f9f08d ("x86/KASLR: Clarify purpose of each get_random_long()")
>     d899a7d146a2e ("x86/mm: Refactor KASLR entropy functions")
>     ed09acde44e30 ("x86/KASLR: Improve comments around the mem_avoid[] logic")
> 
> v3.18.140: Failed to apply! Possible dependencies:
>     021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory regions")
>     0b24becc810dc ("kasan: add kernel address sanitizer infrastructure")
>     2aa79af642631 ("locking/qspinlock: Revert to test-and-set on hypervisors")
>     3a94707d7a7bb ("x86/KASLR: Build identity mappings on demand")
>     4c7c44837be77 ("x86/mm: Define virtual memory map for 5-level paging")
>     4ea1636b04dbd ("x86/asm/tsc: Rename native_read_tsc() to rdtsc()")
>     5c7919bb1994f ("x86/mm: Make LDT_BASE_ADDR dynamic")
>     87be28aaf1458 ("x86/asm/tsc: Replace rdtscll() with native_read_tsc()")
>     9261e050b686c ("x86/asm/tsc, x86/paravirt: Remove read_tsc() and read_tscp() paravirt hooks")
>     92a0f81d89571 ("x86/cpu_entry_area: Move it out of the fixmap")
>     9b238748cb6e9 ("x86/KASLR: Rename aslr.c to kaslr.c")
>     a33fda35e3a76 ("locking/qspinlock: Introduce a simple generic 4-byte queued spinlock")
>     a7412546d8cb5 ("x86/mm: Adjust vmalloc base and size at boot-time")
>     c6e5ca35c4685 ("x86/asm/tsc: Inline native_read_tsc() and remove __native_read_tsc()")
>     cf991de2f614f ("x86/asm/msr: Make wrmsrl_safe() a function")
>     d6f2d75a7ae06 ("x86/kasan: Move KASAN_SHADOW_OFFSET to the arch Kconfig")
>     d73a33973f16a ("locking/qspinlock, x86: Enable x86-64 to use queued spinlocks")
>     d84b6728c54dc ("locking/mcs: Better differentiate between MCS variants")
>     ef7f0d6a6ca8c ("x86_64: add KASan support")
>     f233f7f1581e7 ("locking/pvqspinlock, x86: Implement the paravirt qspinlock call patching")
> 
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
