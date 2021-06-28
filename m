Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64C73B5E00
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhF1Mee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:34:34 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:56401 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbhF1Med (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 08:34:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id A6A481AC07C8;
        Mon, 28 Jun 2021 08:32:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 28 Jun 2021 08:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5Zes26
        XF9mxiZbi8U8Wor0uISC5XCqsWQPDWaT3ocDM=; b=msBVzRetlVB2tAZfGCbAPF
        I6FszNyaCU0Cu7tCW3BExpPKoMx4YgY3ul3Rlni98nmoDwvh6kZHYZYOB1g659Mg
        RboWoxKgU5zG94dg8VW1zg2kf15bO25Wn7XkMUQv7zxGe/9ukSDzgX65TRULk8KZ
        7EkRwahPplzuyO51mEuSC1EjSQNb349em25Jg45Rq8hLXMbPCImW8hbeC//P5vUh
        YaMO/4mbOwvoFInZ/w/PBE5xL5gX/NBKg6d0sLhlE72D3NsBUFdAS39/QhhLeBRN
        jO0LmU0J9bUBCfl3HYxeSVNeK5glmlWIxSVl/KyxSjWF07+dr6uv/7njXyeuhZ7Q
        ==
X-ME-Sender: <xms:RsHZYMa2G0dE-tEn1Uz_q8ac3NqX4uDedYC6ApgQT308k2fbyM0Cpw>
    <xme:RsHZYHbSgKemjZ58odAdvNyUbUImAih5h3njOWG39ISPxRZrRr992CUQchHjewiwo
    JNYMZqw9hoOOA>
X-ME-Received: <xmr:RsHZYG_4F1_4p6yeWsRiCCMetWMTfBab7nKvz5kGlpFRZ9viMlPUs4nnwa9ppLw3tr4T5T3ig83hfzgpuq8qcFN8SaaoOvvm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:RsHZYGrtn5N0c1TNKT2NnYXkXYJ22SnYOkhxxTloYYBKaoEQ7cn4TA>
    <xmx:RsHZYHoWYZB-SdWsJL9y0L6wmWuT8mAYNrL8wGAaOBhsLLLrxQTGfw>
    <xmx:RsHZYETK5rgs-8tL-XC40z7CS7bDYiQwfkwDM172TjGJA_BAI5VQPA>
    <xmx:R8HZYDLmOxk7wTCCb3yYbNjTEQwT2D5p8U2FIba1KYgAzRPTcOqPMIG_6kk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 08:32:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hwpoison: do not lock page again when me_huge_page()" failed to apply to 4.4-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Jun 2021 14:32:04 +0200
Message-ID: <1624883524112241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

