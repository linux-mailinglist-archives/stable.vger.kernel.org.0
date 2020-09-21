Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA182723DC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIUM0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:26:17 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:44135 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgIUM0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 08:26:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CC31C1940EC8;
        Mon, 21 Sep 2020 08:26:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 08:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fPEwm3
        5ZVE3UXt3h5h6NVqg77Ua+nr4iB2NSM3o6cmc=; b=MI4+kdd9GAFAT7EQ5fD/4M
        NzUEFa4gB4Z+fIppIP0ahh0czVrDbLLaEnjaZ0gKrxYchEJoTtKkhujMUI13IJln
        NT4aNfXcuVcn8JRsiXE/PDhElQKnW8o8Fui96DNnBzAU7ex526TyTn9M+fQhIW6t
        g4lTLEBw8NUb+BVQgOMlsTq7GoQXuclPpn9LLRzTYM2LwMemUZJRyfgtRXVacRRi
        LsNG56sJtETXziNjj0rDX8/PjK0aNhLHP1ekoSFOazzuotfVaYY9/dOM7d6vUbdL
        0olUTgRZhld8nEfn6xc/I23V4kd7ZIHaktdxSLgk0eNgwYodDo12ekr/PIKI8Yjg
        ==
X-ME-Sender: <xms:6JtoXygS8jjzL2xyfvmjVqtL5Hjm08zx4seGqLqlNq4ZA9iuT6PaaA>
    <xme:6JtoXzDHN3AAlPYUW-sfdMLKmIDe6h6cPA8bi4oMOLalbl3Ve4xi8v0QWjY--ctvL
    B6uvwU3f8tTDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6JtoX6FHVRwswqJntXEOdR-sZ9HNsCR_6Jh7Y3Yj0PTENq3tZOxoQw>
    <xmx:6JtoX7SR-ZnPYh2KOEAWZnSUkC_32RdFxaQGr7dp-iRAaLUL9O0GEg>
    <xmx:6JtoX_yFXm6mECB5cbpUsTrgqcQnMcEADvAVxTgjrZqfGiOO8nRyjg>
    <xmx:6JtoX96GqR_9NJOmI2wQn1SHCZh5DeB-RUiEEornTtft1Wzhk5e9Cx-sEdM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D69A3064674;
        Mon, 21 Sep 2020 08:26:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PMD" failed to apply to 4.19-stable tree
To:     rcampbell@nvidia.com, akpm@linux-foundation.org,
        apopple@nvidia.com, bharata@linux.ibm.com, bskeggs@redhat.com,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, shuah@kernel.org, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Sep 2020 14:26:40 +0200
Message-ID: <160069120043152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ec0abae6dcdf7ef88607c869bf35a4b63ce1b370 Mon Sep 17 00:00:00 2001
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

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7ff29cc3d55c..faadc449cca5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2022,7 +2022,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		put_page(page);
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
-	} else if (is_huge_zero_pmd(*pmd)) {
+	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
@@ -2116,30 +2116,34 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
 
-	lock_page_memcg(page);
-	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
-		/* Last compound_mapcount is gone. */
-		__dec_lruvec_page_state(page, NR_ANON_THPS);
-		if (TestClearPageDoubleMap(page)) {
-			/* No need in mapcount reference anymore */
+	if (!pmd_migration) {
+		/*
+		 * Set PG_double_map before dropping compound_mapcount to avoid
+		 * false-negative page_mapped().
+		 */
+		if (compound_mapcount(page) > 1 &&
+		    !TestSetPageDoubleMap(page)) {
 			for (i = 0; i < HPAGE_PMD_NR; i++)
-				atomic_dec(&page[i]._mapcount);
+				atomic_inc(&page[i]._mapcount);
+		}
+
+		lock_page_memcg(page);
+		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
+			/* Last compound_mapcount is gone. */
+			__dec_lruvec_page_state(page, NR_ANON_THPS);
+			if (TestClearPageDoubleMap(page)) {
+				/* No need in mapcount reference anymore */
+				for (i = 0; i < HPAGE_PMD_NR; i++)
+					atomic_dec(&page[i]._mapcount);
+			}
 		}
+		unlock_page_memcg(page);
 	}
-	unlock_page_memcg(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);

