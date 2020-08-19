Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB90249DAF
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHSMVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:21:05 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44821 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbgHSMVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:21:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 89085A6D;
        Wed, 19 Aug 2020 08:21:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d+ZM7E
        Xlci9v/l+XVTdMVUzjeGLwREgN8a0f7rKKwfM=; b=JCI8Bi6m5mwY6Ztk6Q6TgX
        E4w4urVoZbn6Fssp93+pEB+5/yaiaFx2Cmo7aZQ0OyogFOi7xLHT/UfiVQcVgFvt
        9dQX53uUn3QW5O6ckzDIYdlZ+kH3G8CHvKwQZXUPSeZKt2KVHpHnvbN8Q4rpZYfi
        FPPjsjGC0+aAREHcHAzMb8mF46YJGzk9mLZ9XmQekLk18dCqNh53icjwUnwExG4p
        qIPOA3eMo/m3tntp4Y++FZkQx/exxRwPA2sc8G5C0387HbAyVnDPx0KUmyj4gs5A
        m0hWQ0uBRzA/YE2d/hAo22nNI5KASloTkp9XKVn4dYs3d4mGqlZ0ly0QG1i4alFg
        ==
X-ME-Sender: <xms:LRk9X6cW9-XVCfRYlF0YTyb9NxsQ2UIVtWTfMPJIv8x5HhFETzICmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LRk9X0PLeOTs24En3F2l1m5ut66xCyOL06eS2VazfQwEvjMrj2RFHw>
    <xmx:LRk9X7gVMUFqBCCY98Me1dfxr080hCdYw9HMB9ZNjhyW7kC3d0Ii4Q>
    <xmx:LRk9X3_77LXykBgG70_13Arxrhnq-79-MENp1v2jG5Kl3jY9wmdHYg>
    <xmx:LRk9X6LjUfWiPkS8rgzwJICKmkR7N0n-_iXSv1GUrFf0f4BKBot56qkRKj4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C18563060067;
        Wed, 19 Aug 2020 08:21:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hugetlb: fix calculation of" failed to apply to 4.19-stable tree
To:     peterx@redhat.com, aarcange@redhat.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:21:21 +0200
Message-ID: <159783968115990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 75802ca66354a39ab8e35822747cd08b3384a99a Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Thu, 6 Aug 2020 23:26:11 -0700
Subject: [PATCH] mm/hugetlb: fix calculation of
 adjust_range_if_pmd_sharing_possible

This is found by code observation only.

Firstly, the worst case scenario should assume the whole range was covered
by pmd sharing.  The old algorithm might not work as expected for ranges
like (1g-2m, 1g+2m), where the adjusted range should be (0, 1g+2m) but the
expected range should be (0, 2g).

Since at it, remove the loop since it should not be required.  With that,
the new code should be faster too when the invalidating range is huge.

Mike said:

: With range (1g-2m, 1g+2m) within a vma (0, 2g) the existing code will only
: adjust to (0, 1g+2m) which is incorrect.
:
: We should cc stable.  The original reason for adjusting the range was to
: prevent data corruption (getting wrong page).  Since the range is not
: always adjusted correctly, the potential for corruption still exists.
:
: However, I am fairly confident that adjust_range_if_pmd_sharing_possible
: is only gong to be called in two cases:
:
: 1) for a single page
: 2) for range == entire vma
:
: In those cases, the current code should produce the correct results.
:
: To be safe, let's just cc stable.

Fixes: 017b1660df89 ("mm: migration: fix migration of huge PMD shared pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200730201636.74778-1-peterx@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 27556d4d49fe..e52c878940bb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5314,25 +5314,21 @@ static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long check_addr;
+	unsigned long a_start, a_end;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	for (check_addr = *start; check_addr < *end; check_addr += PUD_SIZE) {
-		unsigned long a_start = check_addr & PUD_MASK;
-		unsigned long a_end = a_start + PUD_SIZE;
+	/* Extend the range to be PUD aligned for a worst case scenario */
+	a_start = ALIGN_DOWN(*start, PUD_SIZE);
+	a_end = ALIGN(*end, PUD_SIZE);
 
-		/*
-		 * If sharing is possible, adjust start/end if necessary.
-		 */
-		if (range_in_vma(vma, a_start, a_end)) {
-			if (a_start < *start)
-				*start = a_start;
-			if (a_end > *end)
-				*end = a_end;
-		}
-	}
+	/*
+	 * Intersect the range with the vma range, since pmd sharing won't be
+	 * across vma after all
+	 */
+	*start = max(vma->vm_start, a_start);
+	*end = min(vma->vm_end, a_end);
 }
 
 /*

