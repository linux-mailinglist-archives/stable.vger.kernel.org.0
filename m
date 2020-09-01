Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AEC25907E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgIAOcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbgIAObn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 10:31:43 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F4720767;
        Tue,  1 Sep 2020 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598970702;
        bh=w8876BCZ23jR3JgqwFoAHXPZLMwDI/nNkGuNSx7HoVI=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=uItXSD5YZLavSJYvs1N4Qa/cui2uEKRdSrj+dsmyL0F98V7ehl/5q4w8XmKf7DtLc
         8okNb4kiqhbr9o346dIYwRKnJel7KhAJUJv7Xh6zPqXLbuTXgEErN7SeUnVJk3xICs
         sa5d/OcrdhlKLFeYVkxGtOGoq7iE84x/r9vXoNU0=
Date:   Tue, 01 Sep 2020 14:31:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: drain per-cpu pages again during memory offline
In-Reply-To: <20200901124615.137200-1-pasha.tatashin@soleen.com>
References: <20200901124615.137200-1-pasha.tatashin@soleen.com>
Message-Id: <20200901143142.B3F4720767@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.5, v5.4.61, v4.19.142, v4.14.195, v4.9.234, v4.4.234.

v5.8.5: Build OK!
v5.4.61: Build OK!
v4.19.142: Failed to apply! Possible dependencies:
    2932c8b05056 ("mm, memory_hotplug: be more verbose for memory offline failures")
    5557c766abad ("mm, memory_hotplug: cleanup memory offline path")
    7960509329c2 ("mm, memory_hotplug: print reason for the offlining failure")
    7c2ee349cf79 ("memblock: rename __free_pages_bootmem to memblock_free_pages")
    9b7ea46a82b3 ("mm/hotplug: fix offline undo_isolate_page_range()")
    a9cd410a3d29 ("mm/page_alloc.c: memory hotplug: free pages as higher order")
    bb8965bd82fd ("mm, memory_hotplug: deobfuscate migration part of offlining")
    d381c54760dc ("mm: only report isolation failures when offlining memory")

v4.14.195: Failed to apply! Possible dependencies:
    1b7176aea0a9 ("memory hotplug: fix comments when adding section")
    24e6d5a59ac7 ("mm: pass the vmem_altmap to arch_add_memory and __add_pages")
    2f47a91f4dab ("mm: deferred_init_memmap improvements")
    381eab4a6ee8 ("mm/memory_hotplug: fix online/offline_pages called w.o. mem_hotplug_lock")
    7960509329c2 ("mm, memory_hotplug: print reason for the offlining failure")
    7b73d978a5d0 ("mm: pass the vmem_altmap to vmemmap_populate")
    80b1f41c0957 ("mm: split deferred_init_range into initializing and freeing parts")
    9bb5a391f9a5 ("mm, memory_hotplug: fix memmap initialization")
    b9ff036082cd ("mm/memory_hotplug.c: make add_memory_resource use __try_online_node")
    bb8965bd82fd ("mm, memory_hotplug: deobfuscate migration part of offlining")
    d0dc12e86b31 ("mm/memory_hotplug: optimize memory hotplug")
    e8b098fc5747 ("mm: kernel-doc: add missing parameter descriptions")
    f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")

v4.9.234: Failed to apply! Possible dependencies:
    1b862aecfbd4 ("mm, memory_hotplug: get rid of is_zone_device_section")
    381eab4a6ee8 ("mm/memory_hotplug: fix online/offline_pages called w.o. mem_hotplug_lock")
    385386cff4c6 ("mm: vmstat: move slab statistics from zone to node counters")
    438cc81a41e8 ("powerpc/pseries: Automatically resize HPT for memory hot add/remove")
    72675e131eb4 ("mm, memory_hotplug: drop zone from build_all_zonelists")
    7960509329c2 ("mm, memory_hotplug: print reason for the offlining failure")
    88ed365ea227 ("mm: don't steal highatomic pageblock")
    a6ffdc07847e ("mm: use is_migrate_highatomic() to simplify the code")
    b93e0f329e24 ("mm, memory_hotplug: get rid of zonelists_mutex")
    bb8965bd82fd ("mm, memory_hotplug: deobfuscate migration part of offlining")
    c8f9565716e3 ("mm, memory_hotplug: use node instead of zone in can_online_high_movable")
    f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")

v4.4.234: Failed to apply! Possible dependencies:
    0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    1b862aecfbd4 ("mm, memory_hotplug: get rid of is_zone_device_section")
    260ae3f7db61 ("mm: skip memory block registration for ZONE_DEVICE")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    381eab4a6ee8 ("mm/memory_hotplug: fix online/offline_pages called w.o. mem_hotplug_lock")
    4a65429457a5 ("s390/mm: fix zone calculation in arch_add_memory()")
    4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
    7960509329c2 ("mm, memory_hotplug: print reason for the offlining failure")
    87ba05dff351 ("libnvdimm: don't fail init for full badblocks list")
    ad9a8bde2cb1 ("libnvdimm, pmem: move definition of nvdimm_namespace_add_poison to nd.h")
    b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
    bb8965bd82fd ("mm, memory_hotplug: deobfuscate migration part of offlining")
    f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
