Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568764D3CC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFTQbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:31:48 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50233 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfFTQbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 12:31:48 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 12:31:47 EDT
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4FDE12DE3;
        Thu, 20 Jun 2019 12:24:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 20 Jun 2019 12:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xu9are
        87ya2DkVzUSPPgRLfUhEEb8HlZo83LiAOJ0xs=; b=E2Unidxp8ql7PQEQhJXkFH
        rhR7eprhTQUrC5jMlR7lAT97CfbrPspfthO057wSuPI3KYYOszJeow7prn2rUU8a
        WtWRh/+XSMHHiXQJhWULt56O0En38qWoLE6lzyFZ9juoxDs0zvz1t/uYSKtCA26n
        izEpgx8RR0bo1PnDk1IhNNWn6adb+tBIjPw8UMswzQF98EPcL/iDGCp+3sP5+Cd5
        QxdQmbYOUH9xJQHUGcR4oA4T9+A3QT5eaqUBNIxUJRiOrV4wCRKHeTsDj38S3cJi
        AyUdmP7WUzNpiGwNVNassV8PD1rCmv/66HfUsGWdl8fN30kU/reN5V05HKQ5il8Q
        ==
X-ME-Sender: <xms:JLMLXe2WgGiRh10RkV92rMsC1kkonmBmKd0r-FChdy4YvS1zYTBkEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeggddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:JbMLXcQk8D7Ivuf5pYO63XEiJaOm6L1MFnqHeAQkI6MM-Nc_qpHC9w>
    <xmx:JbMLXWAaDn7Xt50hIr3dLNgg2a3IRQbNmvPZIUIuL4H0Ax91BnMwhg>
    <xmx:JbMLXQE5y7X0cZC2KXbUCGS0JQfAr4Ysaah4waqELhkPAvl-N-XuVQ>
    <xmx:JrMLXRoOuhISrAbRg0ehFG4UirUNzH64aHc17fA-nfIYIAx7ql1taA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7FA9180060;
        Thu, 20 Jun 2019 12:24:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coredump: fix race condition between collapse_huge_page() and" failed to apply to 4.9-stable tree
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        jannh@google.com, jgg@mellanox.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mike.kravetz@oracle.com, oleg@redhat.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Jun 2019 18:24:02 +0200
Message-ID: <1561047841541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 59ea6d06cfa9247b586a695c21f94afa7183af74 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Thu, 13 Jun 2019 15:56:11 -0700
Subject: [PATCH] coredump: fix race condition between collapse_huge_page() and
 core dumping

When fixing the race conditions between the coredump and the mmap_sem
holders outside the context of the process, we focused on
mmget_not_zero()/get_task_mm() callers in 04f5866e41fb70 ("coredump: fix
race condition between mmget_not_zero()/get_task_mm() and core
dumping"), but those aren't the only cases where the mmap_sem can be
taken outside of the context of the process as Michal Hocko noticed
while backporting that commit to older -stable kernels.

If mmgrab() is called in the context of the process, but then the
mm_count reference is transferred outside the context of the process,
that can also be a problem if the mmap_sem has to be taken for writing
through that mm_count reference.

khugepaged registration calls mmgrab() in the context of the process,
but the mmap_sem for writing is taken later in the context of the
khugepaged kernel thread.

collapse_huge_page() after taking the mmap_sem for writing doesn't
modify any vma, so it's not obvious that it could cause a problem to the
coredump, but it happens to modify the pmd in a way that breaks an
invariant that pmd_trans_huge_lock() relies upon.  collapse_huge_page()
needs the mmap_sem for writing just to block concurrent page faults that
call pmd_trans_huge_lock().

Specifically the invariant that "!pmd_trans_huge()" cannot become a
"pmd_trans_huge()" doesn't hold while collapse_huge_page() runs.

The coredump will call __get_user_pages() without mmap_sem for reading,
which eventually can invoke a lockless page fault which will need a
functional pmd_trans_huge_lock().

So collapse_huge_page() needs to use mmget_still_valid() to check it's
not running concurrently with the coredump...  as long as the coredump
can invoke page faults without holding the mmap_sem for reading.

This has "Fixes: khugepaged" to facilitate backporting, but in my view
it's more a bug in the coredump code that will eventually have to be
rewritten to stop invoking page faults without the mmap_sem for reading.
So the long term plan is still to drop all mmget_still_valid().

Link: http://lkml.kernel.org/r/20190607161558.32104-1-aarcange@redhat.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index a3fda9f024c3..4a7944078cc3 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -54,6 +54,10 @@ static inline void mmdrop(struct mm_struct *mm)
  * followed by taking the mmap_sem for writing before modifying the
  * vmas or anything the coredump pretends not to change from under it.
  *
+ * It also has to be called when mmgrab() is used in the context of
+ * the process, but then the mm_count refcount is transferred outside
+ * the context of the process to run down_write() on that pinned mm.
+ *
  * NOTE: find_extend_vma() called from GUP context is the only place
  * that can modify the "mm" (notably the vm_start/end) under mmap_sem
  * for reading and outside the context of the process, so it is also
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a335f7c1fac4..0f7419938008 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1004,6 +1004,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
+	result = SCAN_ANY_PROCESS;
+	if (!mmget_still_valid(mm))
+		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;

