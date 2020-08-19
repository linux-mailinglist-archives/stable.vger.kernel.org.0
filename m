Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17036249DC4
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHSMYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:24:50 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36215 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgHSMYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:24:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9E2462CD;
        Wed, 19 Aug 2020 08:24:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nFdc5a
        FxGj/uiBQ/y8sOg6KVvjY3ERsuOvi0VRiD1c0=; b=XkbExeMs3LdnXHEfPXch7C
        EK7I3vgQLh7m4fQtd2P3TgLZAQ96eAmC6nh+zSo0QUWFPZiRFRH5drbIg87fSWRg
        HDJD7S23Bif7c4KkZh6JgveFK7JWWXfUlKOXaywWATF65jwlx3Zh5teXCwvYh6su
        IwIfKuqVl3Vemu+4I4dj4+TdDaJlYniH0LrGb6p1PVN4E1vdb3ntPqy2Whhi5lJS
        d7fi4LO4GUH6SAZmNG7YoGIMW0gID/umQnhKzy6hkwCrMo2XrgIq11W9/oA8tPqx
        GWsA76j0zrMhZtITQX9zYznSLkcw5U+WWA30BXJd7sj/CJnFVsyfgmTxsKRvbnMg
        ==
X-ME-Sender: <xms:EBo9XzoU1K74EhB3M7B85P-mgF9GbYp8wmxlAa5ffPUXkAy8NDH5sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EBo9X9rU5jM_WrQjxQZ6uMwYMuSpKSqiv1USKvtuU1HW7rrt9x1_SQ>
    <xmx:EBo9XwPV3LhFrKe6kGZwombdgEIRc7ASLpC-rPdRAElueQiJBrsPcA>
    <xmx:EBo9X27QDluQMC_vfoFFxJkvjJE5uA5MYFyTPd--26hU82AsW9ThlA>
    <xmx:EBo9X92kAei08O7N2CgUUC5KRIVgQ9D7AQTZeNrQRlfuqVXjj07cQfu1tHA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DED0130600A9;
        Wed, 19 Aug 2020 08:24:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] khugepaged: khugepaged_test_exit() check mmget_still_valid()" failed to apply to 5.4-stable tree
To:     hughd@google.com, aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:25:03 +0200
Message-ID: <1597839903329@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 6 Aug 2020 23:26:25 -0700
Subject: [PATCH] khugepaged: khugepaged_test_exit() check mmget_still_valid()

Move collapse_huge_page()'s mmget_still_valid() check into
khugepaged_test_exit() itself.  collapse_huge_page() is used for anon THP
only, and earned its mmget_still_valid() check because it inserts a huge
pmd entry in place of the page table's pmd entry; whereas
collapse_file()'s retract_page_tables() or collapse_pte_mapped_thp()
merely clears the page table's pmd entry.  But core dumping without mmap
lock must have been as open to mistaking a racily cleared pmd entry for a
page table at physical page 0, as exit_mmap() was.  And we certainly have
no interest in mapping as a THP once dumping core.

Fixes: 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page() and core dumping")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021217020.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ac04b332a373..b52bd46ad146 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -431,7 +431,7 @@ static void insert_to_mm_slots_hash(struct mm_struct *mm,
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0;
+	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
 }
 
 static bool hugepage_vma_check(struct vm_area_struct *vma,
@@ -1100,9 +1100,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	mmap_write_lock(mm);
-	result = SCAN_ANY_PROCESS;
-	if (!mmget_still_valid(mm))
-		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;

