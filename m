Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F84A249DC7
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHSM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:26:13 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36589 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgHSM0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:26:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id F0E23B10;
        Wed, 19 Aug 2020 08:26:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BLa09W
        lTrOCoLwoVAfO80RCt1c7GGSyk7GepEbeagzY=; b=rsM5+xFLON94QA1Lrb2yJF
        aGkqr58Umgbh9bctgM+2V53QQo0i48vy8QyM3+K0OezXaUzYRgVssFumydpkBG3O
        dqiHQukD4/veNyqJ9D6RPD+FRWG2AaFtKN3fP9W+W007TvYwarCh/zpD4FbeB3g3
        QYx0mvthUnIVqdHnWyU9XnWCefxtilSQYxC8k6uVeVdIfdl7+LdHlmvxUzPCuSPj
        Xy6LA+9VHZFP6roz53kVC0sa53ZX3fHfUoVw+F0GWQwQqfmt1gacCXU+7W998pT2
        IUPkLP+M/DvEjQVk2VvtGoHnXofDl1jzVWvD9QVVTtr5U014agl65UmfHMbGwZBQ
        ==
X-ME-Sender: <xms:YRo9X08ahd2zA7l-wLxvrMyiFoLte_owggYKGbgmtp7GfeuMKuUixA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YRo9X8tJGfLg_blNrEYmeA-AZQNZp_3lUrBYwVPisTaB0bN8fP8M1w>
    <xmx:YRo9X6AlldV4zJJpAyzvgrVkTHQF2JRtftuVAioiZLbrttu80rYpxg>
    <xmx:YRo9X0cxsqRATGyH8NGbY9w6yKEh3yE2Oqv9Op7q9i0NDieYkDg-bw>
    <xmx:Yho9Xyi2WKm0FCjwj-Tjc3Z2GaBlY-60_JNc--g7uF-_Kd-nftUO4zhSV6551iMO>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EC54306005F;
        Wed, 19 Aug 2020 08:26:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/shuffle: don't move pages between zones and don't read" failed to apply to 5.4-stable tree
To:     david@redhat.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, hannes@cmpxchg.org,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        richard.weiyang@gmail.com, richard.weiyang@linux.alibaba.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:26:32 +0200
Message-ID: <159783999286129@kroah.com>
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

From 4a93025cbe4a0b19d1a25a2d763a3d2018bad0d9 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 6 Aug 2020 23:17:13 -0700
Subject: [PATCH] mm/shuffle: don't move pages between zones and don't read
 garbage memmaps

Especially with memory hotplug, we can have offline sections (with a
garbage memmap) and overlapping zones.  We have to make sure to only touch
initialized memmaps (online sections managed by the buddy) and that the
zone matches, to not move pages between zones.

To test if this can actually happen, I added a simple

	BUG_ON(page_zone(page_i) != page_zone(page_j));

right before the swap.  When hotplugging a 256M DIMM to a 4G x86-64 VM and
onlining the first memory block "online_movable" and the second memory
block "online_kernel", it will trigger the BUG, as both zones (NORMAL and
MOVABLE) overlap.

This might result in all kinds of weird situations (e.g., double
allocations, list corruptions, unmovable allocations ending up in the
movable zone).

Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[5.2+]
Link: http://lkml.kernel.org/r/20200624094741.9918-2-david@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/shuffle.c b/mm/shuffle.c
index 44406d9977c7..dd13ab851b3e 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
  * For two pages to be swapped in the shuffle, they must be free (on a
  * 'free_area' lru), have the same order, and have the same migratetype.
  */
-static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
+static struct page * __meminit shuffle_valid_page(struct zone *zone,
+						  unsigned long pfn, int order)
 {
-	struct page *page;
+	struct page *page = pfn_to_online_page(pfn);
 
 	/*
 	 * Given we're dealing with randomly selected pfns in a zone we
 	 * need to ask questions like...
 	 */
 
-	/* ...is the pfn even in the memmap? */
-	if (!pfn_valid_within(pfn))
+	/* ... is the page managed by the buddy? */
+	if (!page)
 		return NULL;
 
-	/* ...is the pfn in a present section or a hole? */
-	if (!pfn_in_present_section(pfn))
+	/* ... is the page assigned to the same zone? */
+	if (page_zone(page) != zone)
 		return NULL;
 
 	/* ...is the page free and currently on a free_area list? */
-	page = pfn_to_page(pfn);
 	if (!PageBuddy(page))
 		return NULL;
 
@@ -123,7 +123,7 @@ void __meminit __shuffle_zone(struct zone *z)
 		 * page_j randomly selected in the span @zone_start_pfn to
 		 * @spanned_pages.
 		 */
-		page_i = shuffle_valid_page(i, order);
+		page_i = shuffle_valid_page(z, i, order);
 		if (!page_i)
 			continue;
 
@@ -137,7 +137,7 @@ void __meminit __shuffle_zone(struct zone *z)
 			j = z->zone_start_pfn +
 				ALIGN_DOWN(get_random_long() % z->spanned_pages,
 						order_pages);
-			page_j = shuffle_valid_page(j, order);
+			page_j = shuffle_valid_page(z, j, order);
 			if (page_j && page_j != page_i)
 				break;
 		}

