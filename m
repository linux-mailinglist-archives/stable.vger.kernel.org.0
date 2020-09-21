Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2927245C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgIUMzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgIUMzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:55:04 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A1E21789;
        Mon, 21 Sep 2020 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692902;
        bh=jEPUMnMNEhxcA9p47EsJfqeURv7EsDLkgiABrGWl3EY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=JDeiMHR3ucc6DelQiKsEUU7xYMHRLnfupudCnSsgo9Kq3g4JT7pKC4FJOlBV71Wpg
         LzKM/LlTPAofjBiuW22+vdPC2ZxbV2cPsneWuyd6hd/q6aCRtRC/5hCwQvbbUNASoJ
         TOQtWSanRUGOXzPUUPjNL2Zc/wH1RIRrSxULHRyI=
Date:   Mon, 21 Sep 2020 12:55:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [v2 1/2] mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
In-Reply-To: <1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com>
References: <1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com>
Message-Id: <20200921125501.C8A1E21789@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f000565adb77 ("thp: set recommended min free kbytes").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Failed to apply! Possible dependencies:
    013de2d6671d ("csky: MMU and page table management")
    27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
    426dcd4b600f ("hexagon: switch to NO_BOOTMEM")
    6471f52af786 ("alpha: switch to NO_BOOTMEM")
    9143a9359d05 ("csky: Kernel booting")
    aca52c398389 ("mm: remove CONFIG_HAVE_MEMBLOCK")
    bc3ec75de545 ("dma-mapping: merge direct and noncoherent ops")
    c32e64e852f3 ("csky: Build infrastructure")
    ca9a46f8a4f0 ("mm/memory_hotplug: online_pages cannot be 0 in online_pages()")
    de1193f0be66 ("mm, memory_hotplug: update pcp lists everytime onlining a memory block")
    e0a9317d9004 ("hexagon: use generic dma_noncoherent_ops")
    e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
    f3ecc0ff0457 ("dma-mapping: move the dma_coherent flag to struct device")
    f406f222d4b2 ("hexagon: implement the sync_sg_for_device DMA operation")

v4.14.198: Failed to apply! Possible dependencies:
    008ef0969dd9 ("btrfs: drop lock parameter from update_ioctl_balance_args and rename")
    17ef445f9bef ("Documentation/filesystems: update documentation of file_operations")
    27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
    3d8f7615319b ("vfs: implement readahead(2) using POSIX_FADV_WILLNEED")
    45cd0faae371 ("vfs: add the fadvise() file operation")
    5740c99e9d30 ("vfs: dedupe: return int")
    6e8b704df584 ("fs: update documentation to mention __poll_t and match the code")
    87eb5eb24232 ("vfs: dedupe: rationalize args")
    b4e98d9ac775 ("mm: account pud page tables")
    c4812909f5d5 ("mm: introduce wrappers to access mm->nr_ptes")
    ca9a46f8a4f0 ("mm/memory_hotplug: online_pages cannot be 0 in online_pages()")
    de1193f0be66 ("mm, memory_hotplug: update pcp lists everytime onlining a memory block")
    e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
    f51d2b59120f ("btrfs: allow to set compression level for zlib")
    f5c29bd9dbd3 ("Btrfs: add __init macro to btrfs init functions")

v4.9.236: Failed to apply! Possible dependencies:
    0b89ede62963 ("s390/mm: fork vs. 5 level page tabel")
    27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
    505a60e22560 ("asm-generic: introduce 5level-fixup.h")
    a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
    b4e98d9ac775 ("mm: account pud page tables")
    c2febafc6773 ("mm: convert generic code to 5-level paging")
    c4812909f5d5 ("mm: introduce wrappers to access mm->nr_ptes")
    c763ea2650df ("x86/kconfig: Sort the 'config X86' selects alphabetically")
    d94e068573f2 ("x86/kconfig: Move 64-bit only arch Kconfig selects to 'config X86_64'")

v4.4.236: Failed to apply! Possible dependencies:
    0b57d6ba0bd1 ("mm/mmap.c: remove redundant local variables for may_expand_vm()")
    1170532bb49f ("mm: convert printk(KERN_<LEVEL> to pr_<level>")
    27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
    5a6e75f8110c ("shmem: prepare huge= mount option and sysfs knob")
    756a025f0009 ("mm: coalesce split strings")
    84638335900f ("mm: rework virtual memory accounting")
    8cee852ec53f ("mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status")
    b46e756f5e47 ("thp: extract khugepaged from mm/huge_memory.c")
    d07e22597d1d ("mm: mmap: add new /proc tunable for mmap_base ASLR")
    d977d56ce5b3 ("mm: warn about VmData over RLIMIT_DATA")
    d9fe4fab1197 ("x86/mm/pat: Add untrack_pfn_moved for mremap")
    eca56ff906bd ("mm, shmem: add internal shmem resident memory accounting")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
