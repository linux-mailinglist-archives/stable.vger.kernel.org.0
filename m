Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408122D8274
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407067AbgLKW4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407066AbgLKWzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:55:49 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4BBC0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:55:09 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id y8so5336415plp.8
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w94DrzOzYEYjNjmNtott/pTMMdd8CvD3UIcw0ipPsyo=;
        b=WzwomJ3JlWT0rNaE3a3SmemjOSvqBevAgEwpaQF4lU8GowyZ9hwQL62YeeQBagpG7Z
         IcW15ODs5OMwWcoXjalg9BS3lqoFAjUtsZi9wZUwh1dyP0JDrCy7aflwoiW79TUGQnuu
         J9J8jbCPJPwEzWwcU/Ma2U6ROabKpk6i/DpzpBsjTqmJ+maI6qxbhRTcDZSKU0e9CtNn
         vFhSSMUhddDQhE+/HiY7EqoD0l2fZZpr6aa7TKbiRH/8QDltIDdEXxMDwNHyxuoYksed
         yQvbrmZ8qJrOEHPdijuSRdVlinotnISf+FN2rYGXC1iV4qdJkM4jxlTm0Rnzi8tzFo5u
         GpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=w94DrzOzYEYjNjmNtott/pTMMdd8CvD3UIcw0ipPsyo=;
        b=Gk3+7oVkoZT0jEb0oyvkZ7MZ5Zi1nNKnqICf57Xcrt5o44SkqmDhJJZeIzi5ADWZoP
         aOsYlJ9nbNqYxCBwtlrVaYWUQckevARikwQxGIiIK9pZYJB/NQYdjmpqwCM1/7cVnJYI
         4ANxzOfQQ/hiLPMp4aP8+S0NNkYadhGeUr4EjFxOVyGQ0l9hil4p3X07hn4+SKkxzfYm
         3MZTMQ/ZoOf6gWElgONsSQNxZ5evyBMI43km6vEyYy91RtrCgCL+uUNTnGegRHyWgEjF
         hlA7SsZKatjqES78MiX0oNu87smHPOLHBK7n2IUeD1P+hzcURv/rnJOKZpWym5bRBlls
         RcYw==
X-Gm-Message-State: AOAM5307RDMpQyXxAZdwV/fO5AljgCr5Vo404c3+RoT72+64xhY1rA/J
        gr5RqKmx8OukO6jKN9ztyHM=
X-Google-Smtp-Source: ABdhPJzgoapBAgGD58UjfXvIb2e2S/xVxjdsB7udk4aBuv3OkKVR+a2zRQ0ueLcENFBszodssmIfGQ==
X-Received: by 2002:a17:90a:c203:: with SMTP id e3mr8447478pjt.8.1607727309240;
        Fri, 11 Dec 2020 14:55:09 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id v125sm8998982pgv.6.2020.12.11.14.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 14:55:07 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 11 Dec 2020 14:55:05 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.4-stable tree
Message-ID: <X9P4yZH8RQc2FGxM@google.com>
References: <160750482424034@kroah.com>
 <X9JgpjCx9CDIt8ye@google.com>
 <X9OFwvyRVQMTG2lI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9OFwvyRVQMTG2lI@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 03:44:18PM +0100, Greg KH wrote:
> On Thu, Dec 10, 2020 at 09:53:42AM -0800, Minchan Kim wrote:
> > On Wed, Dec 09, 2020 at 10:07:04AM +0100, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> > > From: Minchan Kim <minchan@kernel.org>
> > > Date: Sat, 5 Dec 2020 22:14:51 -0800
> > > Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> > > 
> > > While I was doing zram testing, I found sometimes decompression failed
> > > since the compression buffer was corrupted.  With investigation, I found
> > > below commit calls cond_resched unconditionally so it could make a
> > > problem in atomic context if the task is reschedule.
> > > 
> > >   BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> > >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> > >   3 locks held by memhog/946:
> > >    #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> > >    #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> > >    #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> > >   CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> > >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> > >   Call Trace:
> > >     unmap_kernel_range_noflush+0x2eb/0x350
> > >     unmap_kernel_range+0x14/0x30
> > >     zs_unmap_object+0xd5/0xe0
> > >     zram_bvec_rw.isra.0+0x38c/0x8e0
> > >     zram_rw_page+0x90/0x101
> > >     bdev_write_page+0x92/0xe0
> > >     __swap_writepage+0x94/0x4a0
> > >     pageout+0xe3/0x3a0
> > >     shrink_page_list+0xb94/0xd60
> > >     shrink_inactive_list+0x158/0x460
> > > 
> > > We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
> > > contains the offending calling code) from zsmalloc.
> > > 
> > > Even though this option showed some amount improvement(e.g., 30%) in
> > > some arm32 platforms, it has been headache to maintain since it have
> > > abused APIs[1](e.g., unmap_kernel_range in atomic context).
> > > 
> > > Since we are approaching to deprecate 32bit machines and already made
> > > the config option available for only builtin build since v5.8, lastly it
> > > has been not default option in zsmalloc, it's time to drop the option
> > > for better maintenance.
> > > 
> > > [1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org
> > > 
> > > Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
> > 
> > This patch fixex e47110e90584 which merged at v5.9 so we could drop it
> > for v5.4.
> 
> It was backported to 5.4.62, so are you _sure_?

Oops, the patch went into 5.4 as stable but missed it.
This is backport patch for 5.4.
original commit id is e91d8d78237de8d7120c320b3645b7100848f24d

Let me know unless it applies clean
Thank you!

From 29a6ece5ade445d776a58ff1a54ed50ed126fa70 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Sat, 5 Dec 2020 22:14:51 -0800
Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

While I was doing zram testing, I found sometimes decompression failed
since the compression buffer was corrupted.  With investigation, I found
below commit calls cond_resched unconditionally so it could make a
problem in atomic context if the task is reschedule.

  BUG: sleeping function called from invalid context at mm/vmalloc.c:108
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
  3 locks held by memhog/946:
   #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
   #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
   #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
  CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
  Call Trace:
    unmap_kernel_range_noflush+0x2eb/0x350
    unmap_kernel_range+0x14/0x30
    zs_unmap_object+0xd5/0xe0
    zram_bvec_rw.isra.0+0x38c/0x8e0
    zram_rw_page+0x90/0x101
    bdev_write_page+0x92/0xe0
    __swap_writepage+0x94/0x4a0
    pageout+0xe3/0x3a0
    shrink_page_list+0xb94/0xd60
    shrink_inactive_list+0x158/0x460

We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
contains the offending calling code) from zsmalloc.

Even though this option showed some amount improvement(e.g., 30%) in
some arm32 platforms, it has been headache to maintain since it have
abused APIs[1](e.g., unmap_kernel_range in atomic context).

Since we are approaching to deprecate 32bit machines and already made
the config option available for only builtin build since v5.8, lastly it
has been not default option in zsmalloc, it's time to drop the option
for better maintenance.

[1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org

Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Harish Sriram <harish@linux.ibm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201117202916.GA3856507@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/zsmalloc.h |  1 -
 mm/Kconfig               | 13 ------------
 mm/zsmalloc.c            | 46 ----------------------------------------
 3 files changed, 60 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 2219cce81ca4..4807ca4d52e0 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -20,7 +20,6 @@
  * zsmalloc mapping modes
  *
  * NOTE: These only make a difference when a mapped object spans pages.
- * They also have no effect when PGTABLE_MAPPING is selected.
  */
 enum zs_mapmode {
 	ZS_MM_RW, /* normal read-write mapping */
diff --git a/mm/Kconfig b/mm/Kconfig
index a5dae9a7eb51..fbdc5c70e487 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -576,19 +576,6 @@ config ZSMALLOC
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
 
-config PGTABLE_MAPPING
-	bool "Use page table mapping to access object in zsmalloc"
-	depends on ZSMALLOC
-	help
-	  By default, zsmalloc uses a copy-based object mapping method to
-	  access allocations that span two pages. However, if a particular
-	  architecture (ex, ARM) performs VM mapping faster than copying,
-	  then you should select this. This causes zsmalloc to use page table
-	  mapping rather than copying for object mapping.
-
-	  You can check speed with zsmalloc benchmark:
-	  https://github.com/spartacus06/zsmapbench
-
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
 	depends on ZSMALLOC
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 22d17ecfe7df..8a72a3b3837b 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -293,11 +293,7 @@ struct zspage {
 };
 
 struct mapping_area {
-#ifdef CONFIG_PGTABLE_MAPPING
-	struct vm_struct *vm; /* vm area for mapping object that span pages */
-#else
 	char *vm_buf; /* copy buffer for objects that span pages */
-#endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
@@ -1113,46 +1109,6 @@ static struct zspage *find_get_zspage(struct size_class *class)
 	return zspage;
 }
 
-#ifdef CONFIG_PGTABLE_MAPPING
-static inline int __zs_cpu_up(struct mapping_area *area)
-{
-	/*
-	 * Make sure we don't leak memory if a cpu UP notification
-	 * and zs_init() race and both call zs_cpu_up() on the same cpu
-	 */
-	if (area->vm)
-		return 0;
-	area->vm = alloc_vm_area(PAGE_SIZE * 2, NULL);
-	if (!area->vm)
-		return -ENOMEM;
-	return 0;
-}
-
-static inline void __zs_cpu_down(struct mapping_area *area)
-{
-	if (area->vm)
-		free_vm_area(area->vm);
-	area->vm = NULL;
-}
-
-static inline void *__zs_map_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	BUG_ON(map_vm_area(area->vm, PAGE_KERNEL, pages));
-	area->vm_addr = area->vm->addr;
-	return area->vm_addr + off;
-}
-
-static inline void __zs_unmap_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	unsigned long addr = (unsigned long)area->vm_addr;
-
-	unmap_kernel_range(addr, PAGE_SIZE * 2);
-}
-
-#else /* CONFIG_PGTABLE_MAPPING */
-
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -1233,8 +1189,6 @@ static void __zs_unmap_object(struct mapping_area *area,
 	pagefault_enable();
 }
 
-#endif /* CONFIG_PGTABLE_MAPPING */
-
 static int zs_cpu_prepare(unsigned int cpu)
 {
 	struct mapping_area *area;
-- 
2.29.2.576.ga3fc446d84-goog

