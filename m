Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D711273207
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgIUSgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:36:04 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:45879 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727430AbgIUSgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:36:03 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 14:36:03 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id DFEE5528;
        Mon, 21 Sep 2020 14:27:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Sep 2020 14:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:reply-to:mime-version
        :content-transfer-encoding; s=fm1; bh=vQz78zLug2nPyonhBdza0iCKZ2
        6zPALkAv9v8mHBXS8=; b=f5GtoI4rxECtP2jM9MIQ4i8e6eMxPsWI3BY2y0ZzGW
        JBxR2GwLgzmBp2a9vmHtLcfdbvJnSdD2OWM4L8/AHgzTsIe7I0SC4DAhcNZW9QEl
        02+JeYi7Eh0S+f9KXKN1xbrm3kI3SRLYxx3XJkIIsvHm9UZjXuGvnHmUEh94NsRk
        2qwppymaqzVJ67jOGgCKpTk62v59i5dwrYhQsXsuuRsDNLZf0SS1hI4ImeD256tx
        EjDI59xvBcvvwDZcakkieyUw/ZZ85QyH2pOke7KiZWZSFSHdUiAFMBXbdU8ErbHe
        F+zJXmRH922EAktRfFRIiM7QzAJauqwL27wJuPZkYWXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:reply-to:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vQz78z
        Lug2nPyonhBdza0iCKZ26zPALkAv9v8mHBXS8=; b=BCcQ2vhfTqqbWAzFLz1rba
        3UInQ+XuQQccQcqEujY5pWcvtgBTL1SFu6PMveHeztkXrtQUTPlm8S9QMb3M02os
        rzifCsWRz51qrKvtFAnc+XOt7js+qUb1I+vAW0FY1JLDNgoMCLE1Sm1N5gU3IO4P
        SHuCNg8FJn3xkR3cqN5+TpY0dE5syeocT6MXvOJ5xdzONf6TfcS/LwUDjuKEx0Qy
        r4kOPjKk58lPKGE4XonAv+U/IjoPwr3y/0HQCZtzbYjH941ttPsscrAZ2UsGsKcm
        uLmwOxML5tTq15nBYuyouhuwhd0memg9kcNXUxkBjSqlLfx/P66rnVORBsWf2XrA
        ==
X-ME-Sender: <xms:pvBoX8tDKEpQzzDe8RA2gXK6uF7W0utvfzc25nVaCREo4mmfEMRNHg>
    <xme:pvBoX5dbJ5EMrk24irpkK73WkIhL2jQ09bph5CgEs2wzluZdZ2_6228DS_TjWcVCf
    RKck9bSqGKodxYXQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfforhgggfestdekredtredttdenucfhrhhomhepkghiucgjrghn
    uceoiihirdihrghnsehsvghnthdrtghomheqnecuggftrfgrthhtvghrnheptedvkedthf
    fgvedufeeuuedvteevjeejleffkefhgeevgfegieffhfduveeiledtnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepuddvrdegiedruddtiedrudeigeenucevlhhush
    htvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpeiiihdrhigrnhesshgv
    nhhtrdgtohhm
X-ME-Proxy: <xmx:pvBoX3wBoIK1fJsKTItrnI-eQk3TmerghWa-mNukamk24uBsVTt6ww>
    <xmx:pvBoX_N1qYq6KdmwMO13j7ssc08J6SjXAHgFzflHErTq0WuHfBAEhw>
    <xmx:pvBoX89OZ_y3kiSIH-alrKIFAoqc8eGYz1q1p3HnxYCCIQbMkAsraw>
    <xmx:p_BoX3U-sUFooMPiijd37W1rZYlAIgmBPapQjTc3jcT2sDNE6GiPCCYuGeY>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9097F306467D;
        Mon, 21 Sep 2020 14:27:50 -0400 (EDT)
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
Date:   Mon, 21 Sep 2020 14:27:48 -0400
Message-Id: <20200921182748.2618107-1-zi.yan@sent.com>
X-Mailer: git-send-email 2.28.0
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

For 4.19.

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
index 1443ae6fee9b..811fb2477ecd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2145,7 +2145,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		put_page(page);
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
-	} else if (is_huge_zero_pmd(*pmd)) {
+	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
@@ -2233,26 +2233,29 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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

