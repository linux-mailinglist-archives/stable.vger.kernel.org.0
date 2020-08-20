Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FAD24AC38
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHTAc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHTAc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 20:32:26 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E1AC061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:32:24 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id q9so131675oth.5
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=S6th1oIQofn5o2kuD9PeOUOd4Hyhdc75+f9/Y6OxSIo=;
        b=o+CoOfxrnUig7v0PwKOu/kURNnFsVf+gouBI6MK2Ii1T1PPL9p7mSSswygQPFqXKr4
         wNs2rC+dNvj0xv3m3viXGYrEFYWOgpaRmIxbU3N8pkSHauhAQ8XdMTdJSLILsdTLUEW9
         lbsUL7z7R3Bj6BUoT06EFh8AQg4ffFk16IzGM2pb/nRp+G3wJxK8Z+v1cakAgTsdb9Ai
         iUu5svsKXuUzKNn4Ete1ALA5np7e6XjJPNqofOb8+PE65AWKnGCG7UW2NJ2IvnGTVPev
         R66gOm78PP/F/RySkhtIoFhxxnaRivD9Pz0cGRxLm/IdWgyVLtaBdTYdV/pa+uzsbccU
         iPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=S6th1oIQofn5o2kuD9PeOUOd4Hyhdc75+f9/Y6OxSIo=;
        b=fLf4z04QuNXthLW8cukuVTS3VFjV/MeGe+v5QSuFLO5SaKnU626XLQXh7UZB+2SGLe
         Cj14u3AbHwVpoZo/Kak6lWw77WfzDKxN+fcaEEPpy00SPxeS26l3niiEFKUYkYqZxQpJ
         E6T+YN+w4/49L7Sb7K7VlWrs5K8An6d7UERWyH2PkdKbMZ14IuTe0MjAWdujbhhm1ot7
         Adc4BJhiGoHRDIYiPR6bkfUq77ch3fK8YdvI55RX6sGqYiVGtJKb+rc/oq8K1SiMjh1C
         gmzPGzVUU5Dan3YQQ4KUQ5GkBg6N6NCE4eW5AhPGzqTogYBPxf7uNg/zx/FZYPYLEEyO
         b+JQ==
X-Gm-Message-State: AOAM530F601dBtwXM4kdXkadR9GhhEBvCF72zO4WRU4GDVJJJIW1Vsc8
        7ItCSZhm6Ie7XB20bTb6f50VEA==
X-Google-Smtp-Source: ABdhPJwDiIlSAFTtJKEsdqG2WRkFARdKI0Lm4DYwRnmpNcJJtLz4DVa9UdSSzBmPYqaU7Zpc1ncynw==
X-Received: by 2002:a9d:f29:: with SMTP id 38mr352101ott.281.1597883543909;
        Wed, 19 Aug 2020 17:32:23 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id u20sm108251ots.0.2020.08.19.17.32.22
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 19 Aug 2020 17:32:22 -0700 (PDT)
Date:   Wed, 19 Aug 2020 17:32:21 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     hughd@google.com, aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] khugepaged: retract_page_tables() remember
 to test exit" failed to apply to 4.19-stable tree
In-Reply-To: <15978398677194@kroah.com>
Message-ID: <alpine.LSU.2.11.2008191730500.24973@eggly.anvils>
References: <15978398677194@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

------------------ rebased commit in Linus's tree ------------------

From 18e77600f7a1ed69f8ce46c9e11cad0985712dfa Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 6 Aug 2020 23:26:22 -0700
Subject: [PATCH] khugepaged: retract_page_tables() remember to test exit

Only once have I seen this scenario (and forgot even to notice what forced
the eventual crash): a sequence of "BUG: Bad page map" alerts from
vm_normal_page(), from zap_pte_range() servicing exit_mmap();
pmd:00000000, pte values corresponding to data in physical page 0.

The pte mappings being zapped in this case were supposed to be from a huge
page of ext4 text (but could as well have been shmem): my belief is that
it was racing with collapse_file()'s retract_page_tables(), found *pmd
pointing to a page table, locked it, but *pmd had become 0 by the time
start_pte was decided.

In most cases, that possibility is excluded by holding mmap lock; but
exit_mmap() proceeds without mmap lock.  Most of what's run by khugepaged
checks khugepaged_test_exit() after acquiring mmap lock:
khugepaged_collapse_pte_mapped_thps() and hugepage_vma_revalidate() do so,
for example.  But retract_page_tables() did not: fix that.

The fix is for retract_page_tables() to check khugepaged_test_exit(),
after acquiring mmap lock, before doing anything to the page table.
Getting the mmap lock serializes with __mmput(), which briefly takes and
drops it in __khugepaged_exit(); then the khugepaged_test_exit() check on
mm_users makes sure we don't touch the page table once exit_mmap() might
reach it, since exit_mmap() will be proceeding without mmap lock, not
expecting anyone to be racing with it.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021215400.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ecefdba4b0dd..483c4573695a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1251,6 +1251,7 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
 
@@ -1264,7 +1265,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 			continue;
 		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
 			continue;
-		pmd = mm_find_pmd(vma->vm_mm, addr);
+		mm = vma->vm_mm;
+		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			continue;
 		/*
@@ -1273,14 +1275,16 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * re-fault. Not ideal, but it's more important to not disturb
 		 * the system too much.
 		 */
-		if (down_write_trylock(&vma->vm_mm->mmap_sem)) {
-			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
-			/* assume page table is clear */
-			_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			spin_unlock(ptl);
-			up_write(&vma->vm_mm->mmap_sem);
-			mm_dec_nr_ptes(vma->vm_mm);
-			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
+		if (down_write_trylock(&mm->mmap_sem)) {
+			if (!khugepaged_test_exit(mm)) {
+				spinlock_t *ptl = pmd_lock(mm, pmd);
+				/* assume page table is clear */
+				_pmd = pmdp_collapse_flush(vma, addr, pmd);
+				spin_unlock(ptl);
+				mm_dec_nr_ptes(mm);
+				pte_free(mm, pmd_pgtable(_pmd));
+			}
+			up_write(&mm->mmap_sem);
 		}
 	}
 	i_mmap_unlock_write(mapping);
