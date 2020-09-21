Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA133273208
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgIUSgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:36:04 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:55449 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727475AbgIUSgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:36:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 34F584FB;
        Mon, 21 Sep 2020 14:27:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Sep 2020 14:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:reply-to:mime-version
        :content-transfer-encoding; s=fm1; bh=IzZB//QV9JGG+wl/WkCMJlU/R7
        ILM8c5yMDxhwndAiE=; b=Q93p3HxRPYJlxODgTKlvWduim8lyTqBOSdtrLqPrv6
        KvBRygqXUHkbum6d1OLpK4j6o0Gxv9quD64C9KgZDtVvBCgp7I8LlZdohq8QQ0ru
        uUaldSqTwn7HnPikNL+yoBMOix5LXVTUpdQe3cQKQ73m4pq0+80SqHSbpnYeg4e8
        IIWVphhmuWOr2OGOu7GloYQGDAHxHYMY2gpfSKp+HgwPJWmM8rMpgn4NfpEr+/O1
        XoAFqUO54kqXokqsBQWIF/rbpj19Wqmc0wOL0W/KVF7C83Az4ucBhpr8x9zWN+M4
        W88VLY18Zd/aTo2ItFB4fiwc4jEBwWNxrsQHQ2Q25pAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:reply-to:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IzZB//
        QV9JGG+wl/WkCMJlU/R7ILM8c5yMDxhwndAiE=; b=f5OKr/kwuid2APqztPS9ZH
        f3Sw4930DEo7cDH77vKdc039IjguzdDqGzHTyRqM6c+s9jn69tKY2LFZZ7E27P0N
        LyZfCibpdNoZfDiLIu+Y3eGEE9zn/L/JKn+TvLVulRHI+bLPmZfvDg4h+f2JqHnc
        Gs0h+M0WRcP953zeWiDb2mqppKLFbZyWxbYjef6Ppg3fdAxVhRmVG6s9IlF9ra42
        DJHWVjhDk55bG0yzC2ly14hLDZddiTAa7xbfHMiahUwXu4XODn7nw6GsANEjvMxe
        CfK6H5pWpVTpRUG7InyfwM7iHs2FT0J+V5+M5wvoufHQyV5UwR3ZHV05AGLN+ASA
        ==
X-ME-Sender: <xms:e_BoX2FGNpXLKd9ygAgjvgVG3oOlLTx4BhL95woVeWshZ4c2oMFP1w>
    <xme:e_BoX3U5uZL1vkFKNKJdq17aLMtiLuPqjJaPYWeRcNJXTVy_lRPMxJgkn_79gb0dI
    hqzKFiEc4KQhs6qlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfforhgggfestdekredtredttdenucfhrhhomhepkghiucgjrghn
    uceoiihirdihrghnsehsvghnthdrtghomheqnecuggftrfgrthhtvghrnheptedvkedthf
    fgvedufeeuuedvteevjeejleffkefhgeevgfegieffhfduveeiledtnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepuddvrdegiedruddtiedrudeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeiiihdrhigrnhesshgv
    nhhtrdgtohhm
X-ME-Proxy: <xmx:e_BoXwLtuEcmK251oY9Hl2CSYMfXQjHJB2sA1GiayIwcrkEO6Z6J4w>
    <xmx:e_BoXwEiaC02XG2-Zo5x0-widg2yqhaSp_mmGdc14KP7ueBYHdcEIg>
    <xmx:e_BoX8UkE1ckzVXo7488a1cyJvGqdD3MYWbhAeMR6vF0GEP00NvbJQ>
    <xmx:e_BoX7NHefGWm9WrlMIGoukJeeZORquEK_8qhipd5eEmPShf9Z3gvQ5014o>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2CEA3064610;
        Mon, 21 Sep 2020 14:27:06 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     stable@vger.kernel.org
Cc:     Zi Yan <ziy@nvidia.com>, Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <shy828301@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ben Skeggs <bskeggs@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PMD
Date:   Mon, 21 Sep 2020 14:27:01 -0400
Message-Id: <20200921182701.2617910-1-zi.yan@sent.com>
X-Mailer: git-send-email 2.28.0
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

For 4.14.

[Upstream commitid ec0abae6dcdf7ef88607c869bf35a4b63ce1b370]

From: Ralph Campbell <rcampbell@nvidia.com>
Date: Fri, 18 Sep 2020 21:20:24 -0700
Subject: [PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PMD

A migrating transparent huge page has to already be unmapped.  Otherwise,
the page could be modified while it is being copied to a new page and data
could be lost.  The function __split_huge_pmd() checks for a PMD migration
entry before calling __split_huge_pmd_locked() leading one to think that
__split_huge_pmd_locked() can handle splitting a migrating PMD.

However, the code always increments the page->_mapcount and adjusts the
memory control group accounting assuming the page is mapped.

Also, if the PMD entry is a migration PMD entry, the call to
is_huge_zero_pmd(*pmd) is incorrect because it calls pmd_pfn(pmd) instead
of migration_entry_to_pfn(pmd_to_swp_entry(pmd)).  Fix these problems by
checking for a PMD migration entry.

Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[4.14+]
Link: https://lkml.kernel.org/r/20200903183140.19055-1-rcampbell@nvidia.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/huge_memory.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9f3d4f84032b..0aeadebb6f79 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2078,7 +2078,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		put_page(page);
 		add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		return;
-	} else if (is_huge_zero_pmd(*pmd)) {
+	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
@@ -2131,26 +2131,29 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		pte = pte_offset_map(&_pmd, addr);
 		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, entry);
-		atomic_inc(&page[i]._mapcount);
-		pte_unmap(pte);
-	}
-
-	/*
-	 * Set PG_double_map before dropping compound_mapcount to avoid
-	 * false-negative page_mapped().
-	 */
-	if (compound_mapcount(page) > 1 && !TestSetPageDoubleMap(page)) {
-		for (i = 0; i < HPAGE_PMD_NR; i++)
+		if (!pmd_migration)
 			atomic_inc(&page[i]._mapcount);
+		pte_unmap(pte);
 	}
 
-	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
-		/* Last compound_mapcount is gone. */
-		__dec_node_page_state(page, NR_ANON_THPS);
-		if (TestClearPageDoubleMap(page)) {
-			/* No need in mapcount reference anymore */
+	if (!pmd_migration) {
+		/*
+		 * Set PG_double_map before dropping compound_mapcount to avoid
+		 * false-negative page_mapped().
+		 */
+		if (compound_mapcount(page) > 1 && !TestSetPageDoubleMap(page)) {
 			for (i = 0; i < HPAGE_PMD_NR; i++)
-				atomic_dec(&page[i]._mapcount);
+				atomic_inc(&page[i]._mapcount);
+		}
+
+		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
+			/* Last compound_mapcount is gone. */
+			__dec_node_page_state(page, NR_ANON_THPS);
+			if (TestClearPageDoubleMap(page)) {
+				/* No need in mapcount reference anymore */
+				for (i = 0; i < HPAGE_PMD_NR; i++)
+					atomic_dec(&page[i]._mapcount);
+			}
 		}
 	}
 
-- 
2.28.0

