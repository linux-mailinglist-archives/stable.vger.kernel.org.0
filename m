Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F983B5E02
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhF1Men (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:34:43 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:43985 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbhF1Mem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 08:34:42 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 90F211AC0AEA;
        Mon, 28 Jun 2021 08:32:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 28 Jun 2021 08:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BuYVpA
        MoW88rtWVeD3lOs8IcfCYiHC37uCVMQonDcl8=; b=PFBRcngN9IevnZ+gqfKML4
        0YAP89RclPQIFxRGsEwyoL41fcUERNKBp4Ap37B0viL4CnWDyNvyLGxdNKymfWPq
        +EsxRfMhxpbSaXKf86rdQP6WN8eNiIIPfmAgBBLdN/aWIfC42m6FuJp5QcrNa4IQ
        WV1Ze6wfAI5//XQajlJv2+tiPC5ylyPu4hrA3mClKB/b3oNgWsV0X2RLtHOnytq8
        NGHqNASmED3GCHeHX+gdU+Svpno0Nc/qeyn8o31R5IsO33Ot7INbYMxZJQ/YAnwD
        zb9tPU96aMy2oEro78n3zxpUnEuWSH1UEu4HEqcaQUwyvi2BzaB2Ygq0xOUepR+Q
        ==
X-ME-Sender: <xms:TsHZYKwsYmmBA6loVvvVcN1pbV04Gn8KEYOqcMx5fRBRMOKruDErHA>
    <xme:TsHZYGSpdbFMTHiGBPdNJ02LGxojblpzooLDQcxIsK2lRad3iwe2QvSJ97t1fnVCA
    NSTkvao-J2x_Q>
X-ME-Received: <xmr:TsHZYMVP2RydMUwWbYmWScTgJp56M5PxfdzNmYI8pmzcki6LF-aOr7ILOiHP7jdXk6SxDulsAjWC-0OaQpS8GEYC_wn7wv2x>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:TsHZYAhhsSpVTR0EV3L5McslSk6d6doMx1VLJKidqmmf1EKq8OXuyg>
    <xmx:TsHZYMBEVyo14I0JlC1aKgXX1pFbJMXG0jRGRAQdsDkNcVAo-WLrYw>
    <xmx:TsHZYBJi09DdbFA70fUeyRuOEw-5cqV_s1FPKa6tknJKQzmO4G_nMg>
    <xmx:T8HZYKBU7C1QUqCEkdJi68kUnwi79RcRIDzyN8iUc_PYPYefMpYtPQmpgqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 08:32:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hwpoison: do not lock page again when me_huge_page()" failed to apply to 4.19-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Jun 2021 14:32:06 +0200
Message-ID: <16248835264119@kroah.com>
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

