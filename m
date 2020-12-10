Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02D52D641C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392759AbgLJRxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 12:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392613AbgLJRxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 12:53:24 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18367C061793
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 09:52:44 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w16so4888655pga.9
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 09:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3KvvdSEQE0FQcqAy1pgvYaVlo9UfFi5iwrh0ktloEpU=;
        b=s1FHSCaYmrm9ygDzWV5QWPFhb+gjAh3bZKn39PeC0v/cQ57EhLXwXxjdluatY9IlLZ
         8icw58hUuSSZm9AvNsfyzB7xxYVwdzGu19jYCidGNBgmyAqSwV7KVtPz+5D6Y8pXV0Qe
         Lt93UtGpXz22zGFn68Wc07IEDZuWlmv7TEdQp47X+03Ste5dFoxc35Bopq5eiTBX2Ow0
         XQx7vikH6sIkPpHMyvH/vk/Qt7IPZIR6KWl1/WvLTpqUKlN5Ss6YufugpvHHAJ+9uajt
         EENqPHGavSX5bDA2bYK6vjqyw4wGOoVnwDV4jLqTeNIXsim9ijPrfC+yDakNnnvdSSQd
         hAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3KvvdSEQE0FQcqAy1pgvYaVlo9UfFi5iwrh0ktloEpU=;
        b=IN8D2IBBYpptdT1ngH20lKoa7kSDJIAHjdGyN4NpLeMfPq62xeNHBbETZ4tCw0zR13
         yVXVkMa13lBv0+dIswnMwyUR2IEbF+h3bQ0TekU9BC0cLBq5ZIB2CUa7gC5F9lNRVk9S
         PFegq3gnY77ECFZXPGlPkpEf4dJg6Nm9Uz8J4XGJ5X7KODQD7YX9KMvb31GcuEJ/FWaV
         1J7oVCRsMqLOFzEH/eSDfkQt0lx8azfK5MGbC1pKqvHNNrx1gA3RQ47iw3Xg+hOfiWip
         DkMHJx8EyXl2KUCqv4OzE9KeIG8VAMPxGc4b6+uuhg0W3dlD2HsetFF/A8Ec740JmfE9
         l6hg==
X-Gm-Message-State: AOAM53281DAP9uIybPdnQQ0MD9SWj6SMOHuvsEom3TuA609K0FRIp2r1
        /b+nzdAGZUyGFnSjY/dO02M=
X-Google-Smtp-Source: ABdhPJxEaNNCybBkWWAcS3bAysa96IRXWbVum79HXK/bBHPeBrIHPIikohMcYpLWIxe5eTG/u9AwXw==
X-Received: by 2002:a63:1d0b:: with SMTP id d11mr7492405pgd.330.1607622763629;
        Thu, 10 Dec 2020 09:52:43 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id y129sm7069830pfb.3.2020.12.10.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 09:52:42 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 10 Dec 2020 09:52:40 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.9-stable tree
Message-ID: <X9JgaCe2gGRdSNot@google.com>
References: <160750482613828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160750482613828@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:07:06AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Sat, 5 Dec 2020 22:14:51 -0800
> Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

original commit id is e91d8d78237de8d7120c320b3645b7100848f24d and this
is backport patch for v5.9.
If it has a problem to apply, let me know.

Thanks.

From b0ffba8208b1c8be80d2a87380b6078b65d795c1 Mon Sep 17 00:00:00 2001
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
 arch/arm/configs/omap2plus_defconfig |  1 -
 include/linux/zsmalloc.h             |  1 -
 mm/Kconfig                           | 13 --------
 mm/zsmalloc.c                        | 48 ----------------------------
 4 files changed, 63 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index fe383f5a92fb..50bc1ccc3074 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -81,7 +81,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_BINFMT_MISC=y
 CONFIG_CMA=y
 CONFIG_ZSMALLOC=m
-CONFIG_ZSMALLOC_PGTABLE_MAPPING=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 0fdbf653b173..4807ca4d52e0 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -20,7 +20,6 @@
  * zsmalloc mapping modes
  *
  * NOTE: These only make a difference when a mapped object spans pages.
- * They also have no effect when ZSMALLOC_PGTABLE_MAPPING is selected.
  */
 enum zs_mapmode {
 	ZS_MM_RW, /* normal read-write mapping */
diff --git a/mm/Kconfig b/mm/Kconfig
index 6c974888f86f..92501712ea26 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -706,19 +706,6 @@ config ZSMALLOC
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
 
-config ZSMALLOC_PGTABLE_MAPPING
-	bool "Use page table mapping to access object in zsmalloc"
-	depends on ZSMALLOC=y
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
index c36fdff9a371..cdfaaadea8ff 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -293,11 +293,7 @@ struct zspage {
 };
 
 struct mapping_area {
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
-	struct vm_struct *vm; /* vm area for mapping object that span pages */
-#else
 	char *vm_buf; /* copy buffer for objects that span pages */
-#endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
@@ -1113,48 +1109,6 @@ static struct zspage *find_get_zspage(struct size_class *class)
 	return zspage;
 }
 
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
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
-	unsigned long addr = (unsigned long)area->vm->addr;
-
-	BUG_ON(map_kernel_range(addr, PAGE_SIZE * 2, PAGE_KERNEL, pages) < 0);
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
-#else /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -1235,8 +1189,6 @@ static void __zs_unmap_object(struct mapping_area *area,
 	pagefault_enable();
 }
 
-#endif /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static int zs_cpu_prepare(unsigned int cpu)
 {
 	struct mapping_area *area;
-- 
2.29.2.576.ga3fc446d84-goog

