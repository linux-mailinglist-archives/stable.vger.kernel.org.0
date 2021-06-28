Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F2F3B5D1C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhF1L2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 07:28:50 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:57323 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232767AbhF1L2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 07:28:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BEE471AC016E;
        Mon, 28 Jun 2021 07:26:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Jun 2021 07:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1ACeMP
        3IRMAaEM1pRRMRETPZNoRDgcA/Kcp1aH6jhzs=; b=q3mSI7fgJmqeU+20etq5vX
        wmNEKnIte5tBskKe42CQGeNM0cTXfWeNLHIX3eCPwmewXhIjM/LudWgtb9cKPbt0
        WRKqCBy8O39jFLggu7dMPB4yr707cd8ZWvqNdZbNJuvTixo5BAarjQbE8myUoXlX
        RanTsiLhC/NIlYafZOAafPgLH8o07h7aGcJIk1f6k2G7dKERfbQa3jiCYdic0qtX
        ClNeGvhwDKNj++9BNJs+czq/XGjDgBAsLZs7xhdjynKIFE1GMokffrTJ1P1yg5qW
        s3hHDRSfk5Zas2fy8n3jKfPW+9u/hefYY063Fqv7qCXR0z1FQ3ZgkDEm0brLeXFw
        ==
X-ME-Sender: <xms:3LHZYPsU_YRRCgMNDI3Bx-U60fYCnnXNa_eeO1JJuM4fY5lIBSskXw>
    <xme:3LHZYAeN9UkYsmZv2fc8de7lN61kLRUnFmfJgoLUWMtAeoM8eMKUw8jhCRQKJM3Nf
    0cy8wiTNCGcjw>
X-ME-Received: <xmr:3LHZYCyuFSayPPCohKcman6hWhfFbPlCnjFEjqZdcwGv8D0li4gCB25-TT6V7L_xzm-rbj-mPFs-T7rdMmRQbINGhxs1bVt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:3LHZYOMcKq_VBfFOHVdszSLG7l4TeBShIXw2892nSG2PhJ9yT_Q1kw>
    <xmx:3LHZYP8CaiID43Ig_movsxQ0kAEYLymdub3hDoTPQO0W0jgckWci9A>
    <xmx:3LHZYOX8zkuJNVNI_3-TL6_4kRCzv67a-VQr_JnpvMWMD7rKGdSEeQ>
    <xmx:37HZYOUS4pPOPx1I0J-wL5Mmrizb_d9NW6KC1o8Uel_tWmION7w6hvr_9ytSLawU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 07:26:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/memory-failure: use a mutex to avoid memory_failure()" failed to apply to 5.10-stable tree
To:     tony.luck@intel.com, akpm@linux-foundation.org, bp@alien8.de,
        bp@suse.de, david@redhat.com, juew@google.com, luto@kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, yaoaili@kingsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Jun 2021 13:26:18 +0200
Message-ID: <162487957819392@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 171936ddaf97e6f4e1264f4128bb5cf15691339c Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 24 Jun 2021 18:39:55 -0700
Subject: [PATCH] mm/memory-failure: use a mutex to avoid memory_failure()
 races

Patch series "mm,hwpoison: fix sending SIGBUS for Action Required MCE", v5.

I wrote this patchset to materialize what I think is the current
allowable solution mentioned by the previous discussion [1].  I simply
borrowed Tony's mutex patch and Aili's return code patch, then I queued
another one to find error virtual address in the best effort manner.  I
know that this is not a perfect solution, but should work for some
typical case.

[1]: https://lore.kernel.org/linux-mm/20210331192540.2141052f@alex-virtual-machine/

This patch (of 2):

There can be races when multiple CPUs consume poison from the same page.
The first into memory_failure() atomically sets the HWPoison page flag
and begins hunting for tasks that map this page.  Eventually it
invalidates those mappings and may send a SIGBUS to the affected tasks.

But while all that work is going on, other CPUs see a "success" return
code from memory_failure() and so they believe the error has been
handled and continue executing.

Fix by wrapping most of the internal parts of memory_failure() in a
mutex.

[akpm@linux-foundation.org: make mf_mutex local to memory_failure()]

Link: https://lkml.kernel.org/r/20210521030156.2612074-1-nao.horiguchi@gmail.com
Link: https://lkml.kernel.org/r/20210521030156.2612074-2-nao.horiguchi@gmail.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0143d32bc666..a7fc1cd6765a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1429,9 +1429,10 @@ int memory_failure(unsigned long pfn, int flags)
 	struct page *hpage;
 	struct page *orig_head;
 	struct dev_pagemap *pgmap;
-	int res;
+	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	static DEFINE_MUTEX(mf_mutex);
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1449,13 +1450,18 @@ int memory_failure(unsigned long pfn, int flags)
 		return -ENXIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 try_again:
-	if (PageHuge(p))
-		return memory_failure_hugetlb(pfn, flags);
+	if (PageHuge(p)) {
+		res = memory_failure_hugetlb(pfn, flags);
+		goto unlock_mutex;
+	}
+
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	orig_head = hpage = compound_head(p);
@@ -1488,17 +1494,19 @@ int memory_failure(unsigned long pfn, int flags)
 				res = MF_FAILED;
 			}
 			action_result(pfn, MF_MSG_BUDDY, res);
-			return res == MF_RECOVERED ? 0 : -EBUSY;
+			res = res == MF_RECOVERED ? 0 : -EBUSY;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
 		}
+		goto unlock_mutex;
 	}
 
 	if (PageTransHuge(hpage)) {
 		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
+			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
@@ -1522,7 +1530,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (PageCompound(p) && compound_head(p) != orig_head) {
 		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1542,14 +1550,14 @@ int memory_failure(unsigned long pfn, int flags)
 		num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	/*
@@ -1573,7 +1581,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1582,13 +1590,15 @@ int memory_failure(unsigned long pfn, int flags)
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
-out:
+unlock_page:
 	unlock_page(p);
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
 	return res;
 }
 EXPORT_SYMBOL_GPL(memory_failure);

