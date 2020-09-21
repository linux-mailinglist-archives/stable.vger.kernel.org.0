Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943422723DD
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIUM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:26:19 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54875 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgIUM0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 08:26:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 73C231940EF1;
        Mon, 21 Sep 2020 08:26:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 08:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DYM+SD
        4Czx7F3tyuRP4URLQ4HA1Bi09xEechnxJH03A=; b=T7NElau9I1So6JTmT30xKk
        XPEuC56S2/YfxAYfscLtCcFLO+Ea1fGKETxU6pdL0OOILV+MtFXFIDIiB4uS0kSu
        wRDaKyj6acc7QNYXxdpOCUyHX+9TOoyYZWtqrZBEnREi42UFTas5/ubgigz5z8UM
        2bAbg3wo1EeVZg0gahiMZUNQFFJ6aCLksiC6VGT5Z/vd8iXKExhw7weV7OcsGR0t
        i4lEtBJB1/i6MuRmoHZOt+Z1LBgBCBVJY6JXPmb5njG+PNzFaqr5oV97vrOirRqH
        GX3fbiIE18/u5AFUSU45066fKvzhWMiSyYf7nEZZCPn3VFJ+F6Xsua/MjMOqqTzA
        ==
X-ME-Sender: <xms:6ptoX0HGujUTxUDH2L-aVvfUtZGb3sOhoFxJmJcdMksjd0YWRzwRwg>
    <xme:6ptoX9Xrhhjz0DbIiS_MQMWgMaRTS1AiVQyhbT2V0jXWAUItXsOjub0AEdnqyAVwu
    V4ZVFbzskWCOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6ptoX-IfEL9IMU81BmWl5-lhR_ASwqOdiYCTJedPdZ644ZgbDVvgTQ>
    <xmx:6ptoX2ELvnvbgQ4CmA1qZWBaw54YrJyd4Frb9vupj0t8DvCPSb1eMQ>
    <xmx:6ptoX6XC00UEyBmhmNJQDPOcsTd6HFsP70G2v3-rTQ7ZCrMqydQ-5g>
    <xmx:6ptoXxOY4siDGHbYFaXfaVrdoIH6USpArBWmyxnyNYaD1BG-ljKjr3OT7Bw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9BE23280063;
        Mon, 21 Sep 2020 08:26:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PMD" failed to apply to 4.14-stable tree
To:     rcampbell@nvidia.com, akpm@linux-foundation.org,
        apopple@nvidia.com, bharata@linux.ibm.com, bskeggs@redhat.com,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, shuah@kernel.org, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Sep 2020 14:26:41 +0200
Message-ID: <1600691201239220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

