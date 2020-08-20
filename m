Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4F24AC33
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHTAak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgHTAah (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 20:30:37 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC985C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:30:35 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id n128so600151oif.0
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=rNI2fGhTAMI3aNGG8cFdI5ZmWgWvDArCXdDy1b59P7g=;
        b=hhTNMtHwgOf3OUJSsiINJuTebh8d6hsTS5fDB8jenyc6xsxw9RiuwH6Ij1IPG8nk6f
         4yD7SX2e5vQFrBrXq3QuKiEKZtozm8PaQXaZtrZK4GK0wN+T6NAKL7Pf+xW9AtgS7xCp
         /jkx0dyIPYWhlEqcA3cdJuBSA3D78qsmtRNvu8Iw8H6RKttnLln8JhtLJGOTkTL63aqg
         YegQURGhoOJ9O9ZJeaQZxFu6jhmFOJhKNgqTI1smI2uWsQDVzp41PH/d7TQZ3rkZC2tr
         0H8wchyy5c++sUh3q/lmFE5QnkeHKuaZ7z0hveQcs8spqaKw9SAZb4fneTxleBsYhEP4
         yqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=rNI2fGhTAMI3aNGG8cFdI5ZmWgWvDArCXdDy1b59P7g=;
        b=LSoEv43haH119sh+fDrB4Vlw9V7VMfcWtFBYt3Okmcx2ypm9lMnY/yCPYVl3GBoybO
         GxkL1NvkyEyV1tVtNzt1MEoMqaZ6uhRDcaR2W9OsR5BuGOgNRWsQlr1jlj9wvVG9rUU6
         O2GUhp1Z0mOXIC47Wuj/yOZhV0ciXSSZpMqxnFKpaiAikB8tHZ1A2sWsSvpEzoCNEri9
         WIYcko5IgqkUisTYiS56T+izvXwCiF4CcXSqtvQ/mStw3odjNcn6vsc5spyOs4KoHd43
         HE6npqr1Ddkj5dqhZVWGaLYR8z9jIt7FsQZOu4SVlmeq8M4BYNubOIQ7iT7yAvNwlWiq
         db0w==
X-Gm-Message-State: AOAM532O1+Woq5RKAJZm03XK+Qy0plpiyPVEo4ycF/3fSWN1i6oI6Xk+
        8bE4bNONH4HmkGPkod7ADFDsig==
X-Google-Smtp-Source: ABdhPJzrUE09yTxybH5OmeZItfLCIkFBgWtdRocXdWvlIlzycOApjejW8CQyy4jeilnZ1SuZ5VC8Bg==
X-Received: by 2002:aca:c4cb:: with SMTP id u194mr429948oif.106.1597883435014;
        Wed, 19 Aug 2020 17:30:35 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id x11sm93451otk.51.2020.08.19.17.30.32
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 19 Aug 2020 17:30:34 -0700 (PDT)
Date:   Wed, 19 Aug 2020 17:30:30 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     hughd@google.com, aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] khugepaged: retract_page_tables() remember
 to test exit" failed to apply to 5.4-stable tree
In-Reply-To: <1597839865224233@kroah.com>
Message-ID: <alpine.LSU.2.11.2008191729020.24973@eggly.anvils>
References: <1597839865224233@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
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
index e9e7a5659d64..e30dd1865603 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1439,6 +1439,7 @@ static int khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
 
@@ -1467,7 +1468,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 			continue;
 		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
 			continue;
-		pmd = mm_find_pmd(vma->vm_mm, addr);
+		mm = vma->vm_mm;
+		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			continue;
 		/*
@@ -1477,17 +1479,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * mmap_sem while holding page lock. Fault path does it in
 		 * reverse order. Trylock is a way to avoid deadlock.
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
 		} else {
 			/* Try again later */
-			khugepaged_add_pte_mapped_thp(vma->vm_mm, addr);
+			khugepaged_add_pte_mapped_thp(mm, addr);
 		}
 	}
 	i_mmap_unlock_write(mapping);
