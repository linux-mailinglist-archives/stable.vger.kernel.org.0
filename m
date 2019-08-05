Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7415581198
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfHEF1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:27:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51623 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfHEF1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:27:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 66EC2209E5;
        Mon,  5 Aug 2019 01:27:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GkYx/5
        51CX+Kf6XsytKIX7RhSNathBw3QydafG3jMbE=; b=DwZlOZfHOFnzZvJUkPs3yn
        08KUbJsBy8aCceI41k2c3yiaX+zgCC0vLgg4X2HLSgnUznAaz3jAbaNIdlIEDyQ6
        I5wuMjMfYJHzVRZNZAVIZzv5jiySOkQ89zPPJ/49JsahkCHNhZdx+D2rx7/SHeDe
        nc8z9QSdCmxOOqN34/vwd9Br50dkYnZZ/hmFUqhs73T3+VfKQ2f/7ySO1Ncar+ty
        /zZx/yNRt30ETlN7C5lwVrRgN0Qj4GPFfzx1nzTbUKW6ae2PFKwhZgCT84RBWXYN
        nTIozIpoui+B8h90PJV6Y+V/ey2Ep4ZPFXe7IheucQN4/8dCPkWn6Xa2kSC76u1g
        ==
X-ME-Sender: <xms:NL5HXfX-HiqG8XDnbPzvwz0zSUZwZ10wNurWaejcCVlni_lLIb8-3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:NL5HXc21HVezk5BbWszDA56oaFNRm9mCVrayN4id_a6pjyEKf1Ey-A>
    <xmx:NL5HXdE1jADihMeQ0vo0kidtUFcCxRF5u-R24Lbd6kQkIHCHPDB24g>
    <xmx:NL5HXSimAUPdEyHOYibr2-7Ee_I2-xzszklu-dJs_LhzC8py-aEZTA>
    <xmx:NL5HXV6LH8gRO_BfWPYcDM6j5E8qAqRfxaUMfatsmOQGvqjGLEythw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C90B2380086;
        Mon,  5 Aug 2019 01:27:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/migrate.c: initialize pud_entry in migrate_vma()" failed to apply to 4.14-stable tree
To:     rcampbell@nvidia.com, akpm@linux-foundation.org,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mgorman@techsingularity.net, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:27:06 +0200
Message-ID: <1564982826146134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

