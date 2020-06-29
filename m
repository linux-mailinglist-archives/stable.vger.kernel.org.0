Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C0120D136
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgF2Sjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgF2Sji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:39:38 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB01C033C00
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 11:39:38 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id y22so2636694oie.8
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 11:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=6zsOe0RtfiJS9z/VKUnFXkhRo94DOY7cc6tNTMDWhXA=;
        b=FwCBAvRHwwk3FnO0LObaL0/h5GA+QTAWGZgtNosfO/1E/ZXoQiQSGDmkulzEhVVhWA
         eVlQlBnNS7h0lNYjv8M7Ctyk1bc3RZd0WklB2QY5lyKLFpqDhoV66kB1vP3nI/m881kn
         SVZQTgUONDaEtoqIZyeukogpzv5dS0gS4BDWWDVLwkH7c1BvHtrK3+pJoFO/SV7DJtrP
         KSbsOwDohVdcSGw04xjBJOTq9kTl/mPY4La65dwCZqy9r3coydN10ry0ML+A/lsyNHsF
         LlD35PWCmV1NPQ87gGxRvXmOksjUreBJZC3ZcOGf/AYCuuooGedsJnmgq19xMH4eKWFv
         /lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=6zsOe0RtfiJS9z/VKUnFXkhRo94DOY7cc6tNTMDWhXA=;
        b=ELTRNjjCK9Oaxfhrrwe1xpIC7kmXKmq8VWuukfevrERu1F6lRBuxMhjM04S6vxptoa
         YFNCuTfTP1J4KvHhk21rLcroDSTAdoq17DtKHcXKS7396CB8sfbNhrEwScZnkk1Z6Qhf
         4Bv2FXcMlKDUl0i3PFK/qjFE/mI6zhYyeeaOVIfvH5FgyRHWd+NHXwrjn6JDXBSGOgfM
         oS1utchr16/GHELavGr2l8vZm1lNKhqCCvavm69868pSJd9ntcz17UhAd+QhuHKOfBdN
         Bdk9kpJBkjuTL0AdD1Hj531J3HErHT7Lpl5NtChxSUAZZZxHqCzBFDL2k3shcw/t/iEl
         b0PQ==
X-Gm-Message-State: AOAM533XFdBixIfCNi+zHlsPPySD3CIc07zK5zdS6N9hWPSc2Gp9B3GK
        DGM77h8qg0tHiUFo/MGHJkQVuQ==
X-Google-Smtp-Source: ABdhPJxP9YELpoS492EO2px5wvTrnWHkDWwL/XxRQcTbSJoroepQ0Agji1QToGLA6O7Q9W0TxeF3jA==
X-Received: by 2002:aca:dcc2:: with SMTP id t185mr13562682oig.75.1593455977566;
        Mon, 29 Jun 2020 11:39:37 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 62sm171415ooa.25.2020.06.29.11.39.35
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 29 Jun 2020 11:39:36 -0700 (PDT)
Date:   Mon, 29 Jun 2020 11:39:34 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     hughd@google.com, akpm@linux-foundation.org,
        lists@colorremedies.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: fix swap cache node allocation mask"
 failed to apply to 4.9-stable tree
In-Reply-To: <159342975761243@kroah.com>
Message-ID: <alpine.LSU.2.11.2006291137280.3798@eggly.anvils>
References: <159342975761243@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
------------------ Please use the below for both v4.9 and v4.4

Original: 243bce09c91b0145aeaedd5afba799d81841c030
From: Hugh Dickins <hughd@google.com>
Date: Thu, 25 Jun 2020 20:29:59 -0700
Subject: [PATCH] mm: fix swap cache node allocation mask

Chris Murphy reports that a slightly overcommitted load, testing swap
and zram along with i915, splats and keeps on splatting, when it had
better fail less noisily:

  gnome-shell: page allocation failure: order:0,
  mode:0x400d0(__GFP_IO|__GFP_FS|__GFP_COMP|__GFP_RECLAIMABLE),
  nodemask=(null),cpuset=/,mems_allowed=0
  CPU: 2 PID: 1155 Comm: gnome-shell Not tainted 5.7.0-1.fc33.x86_64 #1
  Call Trace:
    dump_stack+0x64/0x88
    warn_alloc.cold+0x75/0xd9
    __alloc_pages_slowpath.constprop.0+0xcfa/0xd30
    __alloc_pages_nodemask+0x2df/0x320
    alloc_slab_page+0x195/0x310
    allocate_slab+0x3c5/0x440
    ___slab_alloc+0x40c/0x5f0
    __slab_alloc+0x1c/0x30
    kmem_cache_alloc+0x20e/0x220
    xas_nomem+0x28/0x70
    add_to_swap_cache+0x321/0x400
    __read_swap_cache_async+0x105/0x240
    swap_cluster_readahead+0x22c/0x2e0
    shmem_swapin+0x8e/0xc0
    shmem_swapin_page+0x196/0x740
    shmem_getpage_gfp+0x3a2/0xa60
    shmem_read_mapping_page_gfp+0x32/0x60
    shmem_get_pages+0x155/0x5e0 [i915]
    __i915_gem_object_get_pages+0x68/0xa0 [i915]
    i915_vma_pin+0x3fe/0x6c0 [i915]
    eb_add_vma+0x10b/0x2c0 [i915]
    i915_gem_do_execbuffer+0x704/0x3430 [i915]
    i915_gem_execbuffer2_ioctl+0x1ea/0x3e0 [i915]
    drm_ioctl_kernel+0x86/0xd0 [drm]
    drm_ioctl+0x206/0x390 [drm]
    ksys_ioctl+0x82/0xc0
    __x64_sys_ioctl+0x16/0x20
    do_syscall_64+0x5b/0xf0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported on 5.7, but it goes back really to 3.1: when
shmem_read_mapping_page_gfp() was implemented for use by i915, and
allowed for __GFP_NORETRY and __GFP_NOWARN flags in most places, but
missed swapin's "& GFP_KERNEL" mask for page tree node allocation in
__read_swap_cache_async() - that was to mask off HIGHUSER_MOVABLE bits
from what page cache uses, but GFP_RECLAIM_MASK is now what's needed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=208085
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2006151330070.11064@eggly.anvils
Fixes: 68da9f055755 ("tmpfs: pass gfp to shmem_getpage_gfp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Chris Murphy <lists@colorremedies.com>
Analyzed-by: Vlastimil Babka <vbabka@suse.cz>
Analyzed-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 35d7e0ee1c77..f5cb6b23ceda 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -19,6 +19,7 @@
 #include <linux/migrate.h>
 
 #include <asm/pgtable.h>
+#include "internal.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -326,7 +327,7 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		/*
 		 * call radix_tree_preload() while we can wait.
 		 */
-		err = radix_tree_maybe_preload(gfp_mask & GFP_KERNEL);
+		err = radix_tree_maybe_preload(gfp_mask & GFP_RECLAIM_MASK);
 		if (err)
 			break;
 
