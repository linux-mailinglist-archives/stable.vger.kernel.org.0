Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B2E3B615F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhF1Ofr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhF1Ocn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0AF161C7B;
        Mon, 28 Jun 2021 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890458;
        bh=QUcUXl2TSA7HABT54P8HVtbuAJu/sH2Wc6I7GlpGw1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3QDlLuXKYUHWHMCQce/w1cntnlzZ5hncXdMDMX8Us9Kvt8nwk5xtfe+dp4BesUht
         CzFvm4U2Jo1LktkcgtQhtfjUAwAamk3uHn8GuxLl2ttXifWeHvurkOMhvUilx6cGYk
         ALOvEjEZzWGuudCckjzlV30l05R668zxXeblgKokpJiI5fq2a/CwGBIdePnqQrPtL0
         cgZL51JcYPpf8XY0132TIGeI5OcI+bfQgtvaSZ6/uH4Q2Yx7KWPiVOPMHByqStyoTF
         kcauFPZo5sJ9BKjqg0Jrr7lNAtIN3MzKGjee2POMuCQESaNiBm1c6YQH0eoWtNkhNe
         W89jbDD606tBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 087/101] mm: page_vma_mapped_walk(): add a level of indentation
Date:   Mon, 28 Jun 2021 10:25:53 -0400
Message-Id: <20210628142607.32218-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit b3807a91aca7d21c05d5790612e49969117a72b9 upstream.

page_vma_mapped_walk() cleanup: add a level of indentation to much of
the body, making no functional change in this commit, but reducing the
later diff when this is all converted to a loop.

[hughd@google.com: : page_vma_mapped_walk(): add a level of indentation fix]
  Link: https://lkml.kernel.org/r/7f817555-3ce1-c785-e438-87d8efdcaf26@google.com

Link: https://lkml.kernel.org/r/efde211-f3e2-fe54-977-ef481419e7f3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 105 ++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 50 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 36b40fd23f94..3c3a7cb2de85 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -172,62 +172,67 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->pte)
 		goto next_pte;
 restart:
-	pgd = pgd_offset(mm, pvmw->address);
-	if (!pgd_present(*pgd))
-		return false;
-	p4d = p4d_offset(pgd, pvmw->address);
-	if (!p4d_present(*p4d))
-		return false;
-	pud = pud_offset(p4d, pvmw->address);
-	if (!pud_present(*pud))
-		return false;
-	pvmw->pmd = pmd_offset(pud, pvmw->address);
-	/*
-	 * Make sure the pmd value isn't cached in a register by the
-	 * compiler and used as a stale value after we've observed a
-	 * subsequent update.
-	 */
-	pmde = READ_ONCE(*pvmw->pmd);
-	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
-		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-		pmde = *pvmw->pmd;
-		if (likely(pmd_trans_huge(pmde))) {
-			if (pvmw->flags & PVMW_MIGRATION)
-				return not_found(pvmw);
-			if (pmd_page(pmde) != page)
-				return not_found(pvmw);
-			return true;
-		}
-		if (!pmd_present(pmde)) {
-			swp_entry_t entry;
+	{
+		pgd = pgd_offset(mm, pvmw->address);
+		if (!pgd_present(*pgd))
+			return false;
+		p4d = p4d_offset(pgd, pvmw->address);
+		if (!p4d_present(*p4d))
+			return false;
+		pud = pud_offset(p4d, pvmw->address);
+		if (!pud_present(*pud))
+			return false;
 
-			if (!thp_migration_supported() ||
-			    !(pvmw->flags & PVMW_MIGRATION))
-				return not_found(pvmw);
-			entry = pmd_to_swp_entry(pmde);
-			if (!is_migration_entry(entry) ||
-			    migration_entry_to_page(entry) != page)
-				return not_found(pvmw);
-			return true;
-		}
-		/* THP pmd was split under us: handle on pte level */
-		spin_unlock(pvmw->ptl);
-		pvmw->ptl = NULL;
-	} else if (!pmd_present(pmde)) {
+		pvmw->pmd = pmd_offset(pud, pvmw->address);
 		/*
-		 * If PVMW_SYNC, take and drop THP pmd lock so that we
-		 * cannot return prematurely, while zap_huge_pmd() has
-		 * cleared *pmd but not decremented compound_mapcount().
+		 * Make sure the pmd value isn't cached in a register by the
+		 * compiler and used as a stale value after we've observed a
+		 * subsequent update.
 		 */
-		if ((pvmw->flags & PVMW_SYNC) && PageTransCompound(page)) {
-			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+		pmde = READ_ONCE(*pvmw->pmd);
 
-			spin_unlock(ptl);
+		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			if (likely(pmd_trans_huge(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (pmd_page(pmde) != page)
+					return not_found(pvmw);
+				return true;
+			}
+			if (!pmd_present(pmde)) {
+				swp_entry_t entry;
+
+				if (!thp_migration_supported() ||
+				    !(pvmw->flags & PVMW_MIGRATION))
+					return not_found(pvmw);
+				entry = pmd_to_swp_entry(pmde);
+				if (!is_migration_entry(entry) ||
+				    migration_entry_to_page(entry) != page)
+					return not_found(pvmw);
+				return true;
+			}
+			/* THP pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
+			/*
+			 * If PVMW_SYNC, take and drop THP pmd lock so that we
+			 * cannot return prematurely, while zap_huge_pmd() has
+			 * cleared *pmd but not decremented compound_mapcount().
+			 */
+			if ((pvmw->flags & PVMW_SYNC) &&
+			    PageTransCompound(page)) {
+				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+
+				spin_unlock(ptl);
+			}
+			return false;
 		}
-		return false;
+		if (!map_pte(pvmw))
+			goto next_pte;
 	}
-	if (!map_pte(pvmw))
-		goto next_pte;
 	while (1) {
 		unsigned long end;
 
-- 
2.30.2

