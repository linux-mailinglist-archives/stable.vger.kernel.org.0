Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0195181197
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfHEF1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:27:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38161 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:27:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 07FB22026A;
        Mon,  5 Aug 2019 01:27:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SRHrD3
        iLmucuB+TbqCYCjhZFhnPWHA/rmiG8x9Q+UUw=; b=pncHyJX2waYxyb5SqK5LVd
        bQke0kO2fKbw8a/PQ2fWtB7vNiHvM0i6bD4oYFozYXuxl/IZpGVkeoa7eOjvOnux
        XoDYLy0+N2W0tsyvJqw5GcwCys6lXiScv4qxCTKvHX2c9+OuLpWxY1XOjlDBLRgD
        +5iCqvJ91SNzaSx+7sNzNMAUMhZB83ReWSxN2IXc2jnG2NdytNqTsryrY8juo3Cf
        6y/+vU29gdhVVZzGm1FHIk/+tfIG6ZYLux20EBTAqJPTj5SoXhJgIajyuNe5qLCQ
        uu7Z08t3/f7XRZNQeTfGbVEXjFnbCcqlsKOiSUWNtpG85eHP7Ii2i5/Vis5F0wRw
        ==
X-ME-Sender: <xms:Kr5HXb17RYWg9r-eDefou11y5sKUg5yzlzBQ8EJStONngsPLbF_U3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Kr5HXeVyIsXJAYZOqYpjc6f6vdfeu_hBaBBuBPjo0Ctu7TiSe71yzg>
    <xmx:Kr5HXW6WqyWTyT2ojlQyLZnRaDLlcbbCsaQpZ6YaUpJy1O4ppZuHNQ>
    <xmx:Kr5HXVLqnFMqLRdK_XfvXqJjtmDa5bB56HX7WM6WMwpMgOAts5sW6w>
    <xmx:K75HXeNBRJ5cZ3mkQcbrcF-IoMA_YyDjyTKv13KHw-36Rs14qEhlzA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5FE3780059;
        Mon,  5 Aug 2019 01:27:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/migrate.c: initialize pud_entry in migrate_vma()" failed to apply to 4.19-stable tree
To:     rcampbell@nvidia.com, akpm@linux-foundation.org,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mgorman@techsingularity.net, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:27:04 +0200
Message-ID: <1564982824138137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 7b358c6f12dc82364f6d317f8c8f1d794adbc3f5 Mon Sep 17 00:00:00 2001
From: Ralph Campbell <rcampbell@nvidia.com>
Date: Fri, 2 Aug 2019 21:49:08 -0700
Subject: [PATCH] mm/migrate.c: initialize pud_entry in migrate_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
migrate_vma_collect() which initializes a struct mm_walk but didn't
initialize mm_walk.pud_entry.  (Found by code inspection) Use a C
structure initialization to make sure it is set to NULL.

Link: http://lkml.kernel.org/r/20190719233225.12243-1-rcampbell@nvidia.com
Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use with device memory")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/migrate.c b/mm/migrate.c
index 515718392b24..a42858d8e00b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2340,16 +2340,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 static void migrate_vma_collect(struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	struct mm_walk mm_walk;
-
-	mm_walk.pmd_entry = migrate_vma_collect_pmd;
-	mm_walk.pte_entry = NULL;
-	mm_walk.pte_hole = migrate_vma_collect_hole;
-	mm_walk.hugetlb_entry = NULL;
-	mm_walk.test_walk = NULL;
-	mm_walk.vma = migrate->vma;
-	mm_walk.mm = migrate->vma->vm_mm;
-	mm_walk.private = migrate;
+	struct mm_walk mm_walk = {
+		.pmd_entry = migrate_vma_collect_pmd,
+		.pte_hole = migrate_vma_collect_hole,
+		.vma = migrate->vma,
+		.mm = migrate->vma->vm_mm,
+		.private = migrate,
+	};
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,
 				migrate->start,

