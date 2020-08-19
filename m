Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D17B249DC5
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHSMYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:24:53 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38389 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbgHSMYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:24:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3265AAF1;
        Wed, 19 Aug 2020 08:24:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wNFrkt
        WXbFwA75HM3hYyMuonKNXk8I55GGeeGC86gkk=; b=KPwGzZMpPLNvXF1jfP6qcP
        JC93osNiPwoeFsJoY+9b0zViD1QZjsN0058gK8xv3Gttkvw+YSkN3tgB+x1XPnRC
        bVbJYTWBTP3hQHctMYufh4/Vztwfbg/NJmvVIWXt6/HPh4PGszLfp17Ej08ta1jQ
        b0TBpaN8AT5SCkmvwu+vgKHD3CDKipc3ekBSzH6o/NoPacryb9csuhcduD6VabRj
        vUIAxJuoNxifRDlnhaV6FdlWXAq7WFC4/VFjRoptubDZqHZzoWblH91uWMayk5ni
        Za5HfYwwhUaDRxDEfByv2pdQBATU8tl2nA+lxXJXZaGAfKwH0sXbsNJqL58CbWaw
        ==
X-ME-Sender: <xms:ERo9X2gOUBX51NGIR9up5tFZxQkXq8r-RitvXu9rPHzzqAQxIUnh1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ERo9X3Cu3b9v4UAXd5x9ZzKHEBdA0ghmUYZLPHWuXo8ahmphW3D7Rw>
    <xmx:ERo9X-E9vMK3tPx2Vv6OVo2livOtHG5Euvbb_u34nUrDnpHm9ZVpPw>
    <xmx:ERo9X_TqDXg1fauxTVrWTAAPPH5fmyQYI4JGQcc70zRMSQBgG30-Hw>
    <xmx:ERo9X1sXidGrgbHGRECVYczChtmXDL_umOEFzGE-uTOqGWnGdIpYmU1C9Fo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A890306005F;
        Wed, 19 Aug 2020 08:24:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] khugepaged: khugepaged_test_exit() check mmget_still_valid()" failed to apply to 5.7-stable tree
To:     hughd@google.com, aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:25:04 +0200
Message-ID: <1597839904113171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

