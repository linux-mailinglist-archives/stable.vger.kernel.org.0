Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0DD3B5E04
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhF1Mes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:34:48 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:36207 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232965AbhF1Mes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 08:34:48 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 3E6B21AC0ABD;
        Mon, 28 Jun 2021 08:32:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 28 Jun 2021 08:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=juk7j0
        VzqNLH22QMGU7vJWikLtiMWROKiTNteOZiWWQ=; b=RcubURVDlSuCYFSOJh58PI
        Le0tpnQESBmyFwLCZtMPNchtNJRCvyI7F3c15bpep/OXzr4ChGOypjLvz6dYauJZ
        Nd0cNJAOlYJi/i6OhmkXhbwOXbM7MoEF/XI00hQ6yAoTt33hAJQrp/05EaAwZlEE
        QZODzWtAQqnyK1/Pq1++81ujBdLRnI6qarUtIljImRDxgCdiGQ5zRMdzmR/ciYsS
        yBcrDMBvQgMr4mL7CtCWD5GZ8Blz1CRV3I3nVXmEvM23BR+/ftIzny7pt+USLPgo
        VcQ8ZHvyAGxchM17MdclN+sSQWpCHbMB0FqiEh2Krn91stRoAD2/CLBztsLivbGA
        ==
X-ME-Sender: <xms:VMHZYBELw_ORwneKBX7vKz1L0wmiU4MF1pnzUd-tgcSBLBDgC6neUg>
    <xme:VMHZYGUYnz_LjcSRbVypsvzElA5Wp2CcdpP_1e_ZtaMOg4_Co_yj0jjGPfkoFxl8k
    ff27Fr0HnhrLQ>
X-ME-Received: <xmr:VMHZYDJ5JBHTkwh1AXsQGsOUbkL_N6vHmkKQGnRLI5JV9pF6M4eckeXM0tBueg4utWyX19g48CMrfIPh8Kh88tkA03RtWb2->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:VMHZYHHyZWyy66rzl2v3m40TPLqORRReCzUzzcweSjwm_C10rOLvTA>
    <xmx:VMHZYHWEqXlr4CsTY3pIT9DJNhLzzFDqGCTpgTrxrgtYwd50k183uA>
    <xmx:VMHZYCMg8SxT9-RhtGtt5V_3inz2asIToy6av2OLRSQL8un3fS4RUg>
    <xmx:VMHZYOGFw0UnxRhE06hfkx4ZPyHzqWm7Zy8TDK_LxOsLtyhxet8NKQUntxA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 08:32:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hwpoison: do not lock page again when me_huge_page()" failed to apply to 5.4-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Jun 2021 14:32:07 +0200
Message-ID: <162488352786230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ea6d0630100b285f059d0a8d8e86f38a46407536 Mon Sep 17 00:00:00 2001
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date: Thu, 24 Jun 2021 18:40:01 -0700
Subject: [PATCH] mm/hwpoison: do not lock page again when me_huge_page()
 successfully recovers

Currently me_huge_page() temporary unlocks page to perform some actions
then locks it again later.  My testcase (which calls hard-offline on
some tail page in a hugetlb, then accesses the address of the hugetlb
range) showed that page allocation code detects this page lock on buddy
page and printed out "BUG: Bad page state" message.

check_new_page_bad() does not consider a page with __PG_HWPOISON as bad
page, so this flag works as kind of filter, but this filtering doesn't
work in this case because the "bad page" is not the actual hwpoisoned
page.  So stop locking page again.  Actions to be taken depend on the
page type of the error, so page unlocking should be done in ->action()
callbacks.  So let's make it assumed and change all existing callbacks
that way.

Link: https://lkml.kernel.org/r/20210609072029.74645-1-nao.horiguchi@gmail.com
Fixes: commit 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f24105db7081..6f5f78885ab4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -658,6 +658,7 @@ static int truncate_error_page(struct page *p, unsigned long pfn,
  */
 static int me_kernel(struct page *p, unsigned long pfn)
 {
+	unlock_page(p);
 	return MF_IGNORED;
 }
 
@@ -667,6 +668,7 @@ static int me_kernel(struct page *p, unsigned long pfn)
 static int me_unknown(struct page *p, unsigned long pfn)
 {
 	pr_err("Memory failure: %#lx: Unknown page state\n", pfn);
+	unlock_page(p);
 	return MF_FAILED;
 }
 
@@ -675,6 +677,7 @@ static int me_unknown(struct page *p, unsigned long pfn)
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -683,8 +686,10 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
 	 */
-	if (PageAnon(p))
-		return MF_RECOVERED;
+	if (PageAnon(p)) {
+		ret = MF_RECOVERED;
+		goto out;
+	}
 
 	/*
 	 * Now truncate the page in the page cache. This is really
@@ -698,7 +703,8 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 		/*
 		 * Page has been teared down in the meanwhile
 		 */
-		return MF_FAILED;
+		ret = MF_FAILED;
+		goto out;
 	}
 
 	/*
@@ -706,7 +712,10 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	 *
 	 * Open: to take i_mutex or not for this? Right now we don't.
 	 */
-	return truncate_error_page(p, pfn, mapping);
+	ret = truncate_error_page(p, pfn, mapping);
+out:
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -782,24 +791,26 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
  */
 static int me_swapcache_dirty(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_DELAYED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+	unlock_page(p);
+	return ret;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	delete_from_swap_cache(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_RECOVERED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -820,6 +831,7 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
+		unlock_page(hpage);
 	} else {
 		res = MF_FAILED;
 		unlock_page(hpage);
@@ -834,7 +846,6 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
-		lock_page(hpage);
 	}
 
 	return res;
@@ -866,6 +877,8 @@ static struct page_state {
 	unsigned long mask;
 	unsigned long res;
 	enum mf_action_page_type type;
+
+	/* Callback ->action() has to unlock the relevant page inside it. */
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
@@ -929,6 +942,7 @@ static int page_action(struct page_state *ps, struct page *p,
 	int result;
 	int count;
 
+	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(p, pfn);
 
 	count = page_count(p) - 1;
@@ -1313,7 +1327,7 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 		goto out;
 	}
 
-	res = identify_page_state(pfn, p, page_flags);
+	return identify_page_state(pfn, p, page_flags);
 out:
 	unlock_page(head);
 	return res;
@@ -1596,6 +1610,8 @@ int memory_failure(unsigned long pfn, int flags)
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
+	mutex_unlock(&mf_mutex);
+	return res;
 unlock_page:
 	unlock_page(p);
 unlock_mutex:

