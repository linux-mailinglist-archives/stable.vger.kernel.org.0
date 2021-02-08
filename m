Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79EE31304C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 12:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhBHLLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 06:11:36 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54005 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232677AbhBHLHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 06:07:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C2189AAE;
        Mon,  8 Feb 2021 06:05:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 06:05:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F16Am4
        TaGkkuXtCNjHBvKFLbwUuTr6hKs1n6JO60Qr4=; b=QuKnAev2BEpLObiV48Wpdk
        IgIinOxhO/aJqH7jXUcLyRAVdn4g2bD34Hw6TWOEqA8euDQl9Yg88bmKQZTWCSnx
        F/U+kZNgYRmUFMNfAB7agKwsACOP3DEfUJXBnDqit27esdz0JAbV5YIMQtwiCpRZ
        UEAm1+HJFS7hhH17oAFRbmebKQ5iI/1BEz5y0yZmxytmj8Rmb8f6W6KCK04sBC7p
        9X6AN/V+vIzAIAlL/IbU56VQNLbpHwO4334UJJM+Oamu9PSCTLn15XC28ZzFpH7m
        QTvxD9SZzlH8Bl4jOg0fvYZBQhL651WJ/Jurfp8jMdlwUKnXTOEBXio8wAJN8mgg
        ==
X-ME-Sender: <xms:DRshYDwxX6jez1xJIkDcwoHLNgRbMAnrkig3FX8dKkCFBYjdsyU6og>
    <xme:DRshYLT6CerUxKUnbJFyupvc8PD9CJKupl4r61ZMXL27PyWWAaeSL22BU2WshpBQN
    pLm5tFtMeXMDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DRshYNXOzcp73HD2zDgFCqgmufn7wBnVEb5yipFwV2wMa0dVNVhcKA>
    <xmx:DRshYNjas-iF6I3ItzJoTgFj24ROOOnyJt7_aJdkYnfU5jC_s-UkjA>
    <xmx:DRshYFAClvbmL2VwOTeEXSme97GrFiOC4HeVWcbTuJRsybjMcpx8ag>
    <xmx:DhshYPCZd4yczzSq_FlUjalLyHFsFZx6JJcKZMU4VRP6K9vBUmVq1m-kYt0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3D8C240069;
        Mon,  8 Feb 2021 06:05:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] memblock: do not start bottom-up allocations with kernel_end" failed to apply to 4.9-stable tree
To:     guro@fb.com, akpm@linux-foundation.org, bauerman@linux.ibm.com,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org, riel@surriel.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org,
        vvghjk1234@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 12:05:45 +0100
Message-ID: <1612782345240174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2dcb3964544177c51853a210b6ad400de78ef17d Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 4 Feb 2021 18:32:36 -0800
Subject: [PATCH] memblock: do not start bottom-up allocations with kernel_end

With kaslr the kernel image is placed at a random place, so starting the
bottom-up allocation with the kernel_end can result in an allocation
failure and a warning like this one:

  hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
  ------------[ cut here ]------------
  memblock: bottom-up allocation failed, memory hotremove may be affected
  WARNING: CPU: 0 PID: 0 at mm/memblock.c:332 memblock_find_in_range_node+0x178/0x25a
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0+ #1169
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  RIP: 0010:memblock_find_in_range_node+0x178/0x25a
  Code: e9 6d ff ff ff 48 85 c0 0f 85 da 00 00 00 80 3d 9b 35 df 00 00 75 15 48 c7 c7 c0 75 59 88 c6 05 8b 35 df 00 01 e8 25 8a fa ff <0f> 0b 48 c7 44 24 20 ff ff ff ff 44 89 e6 44 89 ea 48 c7 c1 70 5c
  RSP: 0000:ffffffff88803d18 EFLAGS: 00010086 ORIG_RAX: 0000000000000000
  RAX: 0000000000000000 RBX: 0000000240000000 RCX: 00000000ffffdfff
  RDX: 00000000ffffdfff RSI: 00000000ffffffea RDI: 0000000000000046
  RBP: 0000000100000000 R08: ffffffff88922788 R09: 0000000000009ffb
  R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
  R13: 0000000000000000 R14: 0000000080000000 R15: 00000001fb42c000
  FS:  0000000000000000(0000) GS:ffffffff88f71000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffa080fb401000 CR3: 00000001fa80a000 CR4: 00000000000406b0
  Call Trace:
    memblock_alloc_range_nid+0x8d/0x11e
    cma_declare_contiguous_nid+0x2c4/0x38c
    hugetlb_cma_reserve+0xdc/0x128
    flush_tlb_one_kernel+0xc/0x20
    native_set_fixmap+0x82/0xd0
    flat_get_apic_id+0x5/0x10
    register_lapic_address+0x8e/0x97
    setup_arch+0x8a5/0xc3f
    start_kernel+0x66/0x547
    load_ucode_bsp+0x4c/0xcd
    secondary_startup_64_no_verify+0xb0/0xbb
  random: get_random_bytes called from __warn+0xab/0x110 with crng_init=0
  ---[ end trace f151227d0b39be70 ]---

At the same time, the kernel image is protected with memblock_reserve(),
so we can just start searching at PAGE_SIZE.  In this case the bottom-up
allocation has the same chances to success as a top-down allocation, so
there is no reason to fallback in the case of a failure.  All together it
simplifies the logic.

Link: https://lkml.kernel.org/r/20201217201214.3414100-2-guro@fb.com
Fixes: 8fabc623238e ("powerpc: Ensure that swiotlb buffer is allocated from low memory")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memblock.c b/mm/memblock.c
index 1eaaec1e7687..8d9b5f1e7040 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -275,14 +275,6 @@ __memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
- * When allocation direction is bottom-up, the @start should be greater
- * than the end of the kernel image. Otherwise, it will be trimmed. The
- * reason is that we want the bottom-up allocation just near the kernel
- * image so it is highly likely that the allocated memory and the kernel
- * will reside in the same node.
- *
- * If bottom-up allocation failed, will try to allocate memory top-down.
- *
  * Return:
  * Found address on success, 0 on failure.
  */
@@ -291,8 +283,6 @@ static phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 					phys_addr_t end, int nid,
 					enum memblock_flags flags)
 {
-	phys_addr_t kernel_end, ret;
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE ||
 	    end == MEMBLOCK_ALLOC_KASAN)
@@ -301,40 +291,13 @@ static phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
-	kernel_end = __pa_symbol(_end);
-
-	/*
-	 * try bottom-up allocation only when bottom-up mode
-	 * is set and @end is above the kernel image.
-	 */
-	if (memblock_bottom_up() && end > kernel_end) {
-		phys_addr_t bottom_up_start;
-
-		/* make sure we will allocate above the kernel */
-		bottom_up_start = max(start, kernel_end);
 
-		/* ok, try bottom-up allocation first */
-		ret = __memblock_find_range_bottom_up(bottom_up_start, end,
-						      size, align, nid, flags);
-		if (ret)
-			return ret;
-
-		/*
-		 * we always limit bottom-up allocation above the kernel,
-		 * but top-down allocation doesn't have the limit, so
-		 * retrying top-down allocation may succeed when bottom-up
-		 * allocation failed.
-		 *
-		 * bottom-up allocation is expected to be fail very rarely,
-		 * so we use WARN_ONCE() here to see the stack trace if
-		 * fail happens.
-		 */
-		WARN_ONCE(IS_ENABLED(CONFIG_MEMORY_HOTREMOVE),
-			  "memblock: bottom-up allocation failed, memory hotremove may be affected\n");
-	}
-
-	return __memblock_find_range_top_down(start, end, size, align, nid,
-					      flags);
+	if (memblock_bottom_up())
+		return __memblock_find_range_bottom_up(start, end, size, align,
+						       nid, flags);
+	else
+		return __memblock_find_range_top_down(start, end, size, align,
+						      nid, flags);
 }
 
 /**

