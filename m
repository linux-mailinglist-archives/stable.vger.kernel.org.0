Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED11272451
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgIUMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgIUMyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:55 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5A12193E;
        Mon, 21 Sep 2020 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692895;
        bh=tUOAi7nnQKKX4YJUGYChn0wreuaQBIIRVFl7Y4wIK6k=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=vSHT1gzPexSvQ7tnIQAh0ez4pEvU9irsSNwi17EjSf3lkvouHtna52btAsVnlaCpO
         euhxkkbxj8S4QMuXa4RsOj5TgfsZnOTeKsmKUW4DpAXEU65q3sOSmmfLV66l1M4/qg
         mUzu+Rrnfe8h1/PXgEFLcJahWE5Dq7E1NzbnAKRk=
Date:   Mon, 21 Sep 2020 12:54:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [v3 2/2] mm: khugepaged: avoid overriding min_free_kbytes set by user
In-Reply-To: <1600305709-2319-3-git-send-email-vijayb@linux.microsoft.com>
References: <1600305709-2319-3-git-send-email-vijayb@linux.microsoft.com>
Message-Id: <20200921125455.0D5A12193E@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Failed to apply! Possible dependencies:
    1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
    24512228b7a3 ("mm: do not boost watermarks to avoid fragmentation for the DISCONTIG memory model")
    426dcd4b600f ("hexagon: switch to NO_BOOTMEM")
    6471f52af786 ("alpha: switch to NO_BOOTMEM")
    6bb154504f8b ("mm, page_alloc: spread allocations across zones before introducing fragmentation")
    9705bea5f833 ("mm: convert zone->managed_pages to atomic variable")
    a921444382b4 ("mm: move zone watermark accesses behind an accessor")
    b4a991ec584b ("mm: remove CONFIG_NO_BOOTMEM")
    bc3ec75de545 ("dma-mapping: merge direct and noncoherent ops")
    bda49a81164a ("mm: remove nobootmem")
    c32e64e852f3 ("csky: Build infrastructure")
    e0a9317d9004 ("hexagon: use generic dma_noncoherent_ops")
    f406f222d4b2 ("hexagon: implement the sync_sg_for_device DMA operation")

v4.14.198: Failed to apply! Possible dependencies:
    1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
    1d47a3ec09b5 ("mm/cma: remove ALLOC_CMA")
    24512228b7a3 ("mm: do not boost watermarks to avoid fragmentation for the DISCONTIG memory model")
    3d2054ad8c2d ("ARM: CMA: avoid double mapping to the CMA area if CONFIG_HIGHMEM=y")
    453f85d43fa9 ("mm: remove __GFP_COLD")
    6bb154504f8b ("mm, page_alloc: spread allocations across zones before introducing fragmentation")
    85ccc8fa81af ("mm/page_alloc: make sure __rmqueue() etc are always inline")
    a921444382b4 ("mm: move zone watermark accesses behind an accessor")
    bad8c6c0b114 ("mm/cma: manage the memory of the CMA area by using the ZONE_MOVABLE")

v4.9.236: Failed to apply! Possible dependencies:
    14b468791fa9 ("mm: workingset: move shadow entry tracking to radix tree exceptional tracking")
    1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
    24512228b7a3 ("mm: do not boost watermarks to avoid fragmentation for the DISCONTIG memory model")
    2a2e48854d70 ("mm: vmscan: fix IO/refault regression in cache workingset transition")
    31176c781508 ("mm: memcontrol: clean up memory.events counting function")
    6bb154504f8b ("mm, page_alloc: spread allocations across zones before introducing fragmentation")
    8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
    9d998b4f1e39 ("mm, vmscan: add active list aging tracepoint")
    a921444382b4 ("mm: move zone watermark accesses behind an accessor")
    cd04ae1e2dc8 ("mm, oom: do not rely on TIF_MEMDIE for memory reserves access")
    d6622f6365db ("mm/vmscan: more restrictive condition for retry in do_try_to_free_pages")
    dcec0b60a821 ("mm, vmscan: add mm_vmscan_inactive_list_is_low tracepoint")
    df0e53d0619e ("mm: memcontrol: re-use global VM event enum")
    f7942430e40f ("lib: radix-tree: native accounting of exceptional entries")

v4.4.236: Failed to apply! Possible dependencies:
    0b57d6ba0bd1 ("mm/mmap.c: remove redundant local variables for may_expand_vm()")
    1170532bb49f ("mm: convert printk(KERN_<LEVEL> to pr_<level>")
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
