Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595D110094F
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfKRQhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 11:37:24 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52167 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726475AbfKRQhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 11:37:24 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C019A6AB;
        Mon, 18 Nov 2019 11:37:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 11:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=82XT/G
        vxKb2yfizXyIXfcrk+LrbY1rQkX7src4u8O0g=; b=J4NiiUwztakzSdUaprUM/L
        er1xnHFKZ3PG7Ottxuu+TifOnKA4VjK8h9FQwFmIJhr3UOE/OeyyCw6S5aPoKLO/
        yvR/c+nxENQELz1JaOPvTUtHDqRlUlElB0W+BIrWL5QlsJ98fdnJGqBwT4pCbHI6
        FjlgHimX7qUQlR9qq13qsh629GAGk/y1uxpvaVocTJoZYuMStLvtoEjNsZL8/aFM
        aMY0VeiFgk1UHUSCJrwLkoMRKokLU6Yd8s/5ZOHhCLbwCLG0sDObjMK/4Z/pgJF5
        B+4HUu4hcR33u6RTjsceWDA9oNZLZ/4HMuwtb+g+vrychiKw0Zxf++gQeNjuvgYA
        ==
X-ME-Sender: <xms:wsjSXaH-gfwcKqA9clX2lLk60pNBOcb7sTLt74NExRpfm_USrfCoOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wsjSXaESMH-Yb6ZDXxS4fj1BqsE6An7K5xsIJFf5GBPwGRUclr4LSA>
    <xmx:wsjSXWVN85KEKpnBlgqaujUcZ_N8KYDtf658XmA42b-SswjOFIm0JQ>
    <xmx:wsjSXYlHABoAmBytKoy-H472H6ocn365onVReZXTteg_gtcoB2IZqQ>
    <xmx:wsjSXQp-Z9wGExQv2IRx3hyanswQJNC4XUb0igdJRIp7URYDv5ktZQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC29A3060064;
        Mon, 18 Nov 2019 11:37:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/page_io.c: do not free shared swap slots" failed to apply to 4.19-stable tree
To:     vinmenon@codeaurora.org, akpm@linux-foundation.org,
        hughd@google.com, mhocko@suse.com, minchan@google.com,
        minchan@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 17:37:16 +0100
Message-ID: <1574095036140231@kroah.com>
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

From 5df373e95689b9519b8557da7c5bd0db0856d776 Mon Sep 17 00:00:00 2001
From: Vinayak Menon <vinmenon@codeaurora.org>
Date: Fri, 15 Nov 2019 17:35:00 -0800
Subject: [PATCH] mm/page_io.c: do not free shared swap slots

The following race is observed due to which a processes faulting on a
swap entry, finds the page neither in swapcache nor swap.  This causes
zram to give a zero filled page that gets mapped to the process,
resulting in a user space crash later.

Consider parent and child processes Pa and Pb sharing the same swap slot
with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.
Virtual address 'VA' of Pa and Pb points to the shared swap entry.

Pa                                       Pb

fault on VA                              fault on VA
do_swap_page                             do_swap_page
lookup_swap_cache fails                  lookup_swap_cache fails
                                         Pb scheduled out
swapin_readahead (deletes zram entry)
swap_free (makes swap_count 1)
                                         Pb scheduled in
                                         swap_readpage (swap_count == 1)
                                         Takes SWP_SYNCHRONOUS_IO path
                                         zram enrty absent
                                         zram gives a zero filled page

Fix this by making sure that swap slot is freed only when swap count
drops down to one.

Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Suggested-by: Minchan Kim <minchan@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_io.c b/mm/page_io.c
index 24ee600f9131..60a66a58b9bf 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -73,6 +73,7 @@ static void swap_slot_free_notify(struct page *page)
 {
 	struct swap_info_struct *sis;
 	struct gendisk *disk;
+	swp_entry_t entry;
 
 	/*
 	 * There is no guarantee that the page is in swap cache - the software
@@ -104,11 +105,10 @@ static void swap_slot_free_notify(struct page *page)
 	 * we again wish to reclaim it.
 	 */
 	disk = sis->bdev->bd_disk;
-	if (disk->fops->swap_slot_free_notify) {
-		swp_entry_t entry;
+	entry.val = page_private(page);
+	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
 		unsigned long offset;
 
-		entry.val = page_private(page);
 		offset = swp_offset(entry);
 
 		SetPageDirty(page);

