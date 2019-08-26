Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1EF9D399
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfHZQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:01:00 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59583 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730995AbfHZQBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 12:01:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 07F4E324;
        Mon, 26 Aug 2019 12:00:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 12:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=58KBhw
        0h9iMnzlpni+4h9iuTmsU+ZUCwJ/pz4TBijzs=; b=QLcXxIICZgz16JqgD06Bla
        Hr0gXtjjIdMIUVtdZQBjVlOI5exGKMzXwwTQRC4gW/QpnIosjt95ssoYL2Cx8o0h
        JEp/esYG9Ew9fz8I7I/1/4HAV7pdl0wyuQCP+5NY+LBZbN+5/tee4Kkl8Ecoasbj
        BHKwVoyJFcAFyhjJNmn7DruPPYklUDkkhxoTm7fi1SVCXTOgfbFa1x22OvVF+NDx
        6AED3fYFIXTlZUP4HtZpd95jnQSaIxeVQ4Nw5wZpZYRyxL2kNNIlwVky079lgF3N
        EpasWRAJkOWgGpCAz7M6qLmrxfU83c/S+7ZC/tjLl01mmqTlN1AjAWs3WbytT5BQ
        ==
X-ME-Sender: <xms:OQJkXRySa0uyi6eXEjVGrlim_orz4FgETgv4t15j5woRRhJvmhpl5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OQJkXbwdE_9KBJVYEA0XTx02DUljeDlzXuiLK-Rz5ZfZ5sjOyV4x7w>
    <xmx:OQJkXZIUMbuPWc0xHiKvlC8BVcuRVP388ARDoeaKQyNoRKFYs45jvw>
    <xmx:OQJkXQiFgXd80E2L_otIePtzTVLyqwx0MoJ0_CVDMEMVxaJ1cJNryA>
    <xmx:OgJkXSIC9L-EvDbwdFibOLVO_LV49-1sr-AUqF24QnnRAkFcyTirJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C08B8005A;
        Mon, 26 Aug 2019 12:00:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm, page_owner: handle THP splits correctly" failed to apply to 4.19-stable tree
To:     vbabka@suse.cz, akpm@linux-foundation.org, kirill@shutemov.name,
        mgorman@techsingularity.net, mhocko@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 18:00:55 +0200
Message-ID: <1566835255152129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From f7da677bc6e72033f0981b9d58b5c5d409fa641e Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Sat, 24 Aug 2019 17:54:59 -0700
Subject: [PATCH] mm, page_owner: handle THP splits correctly

THP splitting path is missing the split_page_owner() call that
split_page() has.

As a result, split THP pages are wrongly reported in the page_owner file
as order-9 pages.  Furthermore when the former head page is freed, the
remaining former tail pages are not listed in the page_owner file at
all.  This patch fixes that by adding the split_page_owner() call into
__split_huge_page().

Link: http://lkml.kernel.org/r/20190820131828.22684-2-vbabka@suse.cz
Fixes: a9627bc5e34e ("mm/page_owner: introduce split_page_owner and replace manual handling")
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 738065f765ab..de1f15969e27 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -32,6 +32,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/page_owner.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2516,6 +2517,9 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	}
 
 	ClearPageCompound(head);
+
+	split_page_owner(head, HPAGE_PMD_ORDER);
+
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
 		/* Additional pin to swap cache */

