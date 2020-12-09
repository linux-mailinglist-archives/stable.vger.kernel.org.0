Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388D62D45FA
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgLIPyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:33 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60883 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731296AbgLIPya (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 55B981943533;
        Wed,  9 Dec 2020 04:05:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=M37voV
        nofpwhmZQvTqs0GULbURy9CWNd0Oo1pbZpXGE=; b=RxGLrZSnvBIf2RIYJeCpnp
        CYWry7r9unEVo5qthvbUNInU7y/PrAsSj4cUxR4KXlwTwzeSo6vS2Er2U6UjeGt4
        pa9V4ERuiCuw4ebbaJzIMxtvJ24xR+wE/EjnHaQJ54If3RjlhlCxbuNO4i37xX1e
        UaKRC3Mat6dcMfqNJ2ZDNDm6Q26Lks+EWnscZ4cchgIxrNUZDOJ0Grv/86p2Zb15
        sgow0HjETNA2xnW4Af7XzN/WdbfM3f+TS1xB34pJvAkJHzUQh1h1Vo8i1h6m0p1v
        HjKWDhZxu7xtXq1/ODBmvd96ri7BcBqYu8I/xEwL/WNXKvuRlpCh9+tHZsExYQyw
        ==
X-ME-Sender: <xms:apPQX7P0mGL_HD3NffWL4bEw3y3Xl1XnRlaS_vHYP4zqKsAyh3KfMg>
    <xme:apPQX18e833STjQEN1SDJXHqJI1o0DULn9ewmeZOOPJDhCyWMIOwH0sV4jZLjaXvT
    y0hKL0EcVJUPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpedtgffftddugedufeetjeefkeehtddvieevgffgudejieefff
    ffgeekfeejueffteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdr
    tghomhenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:apPQX6SgwWa0VaPUEB0rhMLHD_1TR3Uks6N8rh-yP7jAJsKI5VXT7A>
    <xmx:apPQX_sp2EpxX3rmTi8lYdF7lgzw8oDAnCuwx4QsQ0m8jGt4pkukMA>
    <xmx:apPQXzcmaa3iW3zpOIFfdFORKmSAhhggKMAoA4Ay7hwl2vdwEWmqpQ>
    <xmx:bJPQX7TsSOchsOhHPukayY-gYAruS2ChAcaLu71Qnwls7_-TiZs-Yw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AEBF24005A;
        Wed,  9 Dec 2020 04:05:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.4-stable tree
To:     minchan@kernel.org, akpm@linux-foundation.org,
        harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:07:04 +0100
Message-ID: <160750482424034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
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

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 34793aabdb65..58df9fd79a76 100644
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
index d42423f884a7..390165ffbb0f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -707,19 +707,6 @@ config ZSMALLOC
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
index 918c7b019b3d..cdfaaadea8ff 100644
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
@@ -1113,54 +1109,6 @@ static struct zspage *find_get_zspage(struct size_class *class)
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
-	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
-	if (!area->vm)
-		return -ENOMEM;
-
-	/*
-	 * Populate ptes in advance to avoid pte allocation with GFP_KERNEL
-	 * in non-preemtible context of zs_map_object.
-	 */
-	return apply_to_page_range(&init_mm, (unsigned long)area->vm->addr,
-			PAGE_SIZE * 2, NULL, NULL);
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
@@ -1241,8 +1189,6 @@ static void __zs_unmap_object(struct mapping_area *area,
 	pagefault_enable();
 }
 
-#endif /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static int zs_cpu_prepare(unsigned int cpu)
 {
 	struct mapping_area *area;

