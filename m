Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A14220D169
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgF2Slv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:41:51 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:32969 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbgF2Slu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A70E777A;
        Mon, 29 Jun 2020 07:22:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aTm8zY
        7jyAjV5h3lJ5HjlHbRZMBU/OitwHH6LSlRqAY=; b=pRdEvxb45wQDO15GNmJMit
        guIrnJp358lSPRYlwb8nEhFyM7TCtecFlpeeU+IuLk3oaYLVFHhmWU7WH8h3MIZr
        x8JEKywYOSQYV8MFjqoy0pcscm7SVtH9PkZn0SCU/L9KiPrMX2tlsVZN1DYLG1L4
        QGgh/0S4b57YvUBmxNOXDnm3yYnvrbwYr+MivQeyhRr07yT/LNvD9VkIvnSkTrRu
        XoxN2UqE8n1+nxgBUPr1XqR0Ro7veY8orjWyyXPXFZGJYaR2UCNrxW8RQ/LjVIR/
        4at6XHv/KD9+2OsYz6rEc9/4qyzNOc6pQcBGML2Lpy3oLlMOw5pXmLeG6gotD2Qw
        ==
X-ME-Sender: <xms:A8_5Xtx9C68sCtcHehgCSRZSU5kl13QPsd3HzwSmcwdQZONMSVz_mA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A8_5XtRavvGri1DA2YWRhvvK32GoCXWGwX-CcHREAk8Fnx14iPgGcw>
    <xmx:A8_5XnV8d37Afz2PxVwsXJU1cJ0EQI8jeD9R9svHvibLkuNTwVO8UQ>
    <xmx:A8_5XviHcKmXbZLmpSCDhmQpvWPsq5PUQMftiNLBUjHBsPjkYlnLpQ>
    <xmx:A8_5XmMuACRDl9qQL5Awi4a7qNMr2Z_TokYq7JApuXyWOpRLJSQjPGErEzI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C87603067C57;
        Mon, 29 Jun 2020 07:22:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: fix swap cache node allocation mask" failed to apply to 5.4-stable tree
To:     hughd@google.com, akpm@linux-foundation.org,
        lists@colorremedies.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:22:33 +0200
Message-ID: <159342975315237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 243bce09c91b0145aeaedd5afba799d81841c030 Mon Sep 17 00:00:00 2001
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
index e98ff460e9e9..05889e8e3c97 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
-
+#include "internal.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -429,7 +429,7 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	__SetPageSwapBacked(page);
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL)) {
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK)) {
 		put_swap_page(page, entry);
 		goto fail_unlock;
 	}

