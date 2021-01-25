Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515853032D3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbhAZEix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:53 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60917 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729202AbhAYOQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:16:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 67BFAC10;
        Mon, 25 Jan 2021 09:14:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IhQZgX
        Ulr+ezEqCTTYOuqFT0oqd9gKVyIZzZczJKatg=; b=qvogIsa9TJOeacZNDheQ2l
        oHTieWx5xnKXCUpNrs6zFJyPXRjrJbtMu1dvnBLoFNuHY8TaAOXLTR6mEelcPviV
        d7eRhH/rM6RqwVIN0Xf3dCTHSBA7oSXm/Tuj1bs2AaUTDKmbAiLmhbImpUR3rYtq
        NB3QXexBd1LBw8o6n2OwH0qmEnmXZP+cR5Pn9fHNe35BRN+8xa8eXD8gqJ7c3L2g
        /xvuJE9UEtnNyR/ybJT3NER50zKlfQ0tDrF85wXCYLdzoJJb5x3nRXdSdzz29CjJ
        Y8Q6MjBwT7GeMazeT/7HobYWhCH+HuqkGqTpovyp4D1RYOEK2cLC5kohmcRIQgMg
        ==
X-ME-Sender: <xms:P9IOYIiNa_e9M7jx6LnH0KX66Hq9_op3fWuMSP-pNBpUoFjzSQjHvw>
    <xme:P9IOYBCPSasTmWYnvWIYzZU8XP76Q-8VchAYFPp5rPsT_HesoM5aRxJIWKgFiq2OF
    lDrnxxNeV7Y9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:P9IOYAGi-r64I2FBFTf7PiDYUPwkL7vPNgNrpU3RBGTRQtvUj0mo-g>
    <xmx:P9IOYJRME_rqJZoQXSsGCctJF5Zmk_inypd1D9eGYCajFTFu2ZF1hQ>
    <xmx:P9IOYFxXuP1Uo_V5H-wWom25ChcXjrfxYB0tXIUEU27bpyUf3vhuPw>
    <xmx:QNIOYMlkd3ZYweiYWCXv9j7Kz5GN4yo51t2Fpgg-J4oh6AUuLV6xN_JLuJY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF46C24005D;
        Mon, 25 Jan 2021 09:14:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: fix numa stats for thp migration" failed to apply to 5.4-stable tree
To:     shakeelb@google.com, akpm@linux-foundation.org, guro@fb.com,
        hannes@cmpxchg.org, mhocko@kernel.org, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:14:21 +0100
Message-ID: <161158406117368@kroah.com>
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

From 5c447d274f3746fbed6e695e7b9a2d7bd8b31b71 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb@google.com>
Date: Sat, 23 Jan 2021 21:01:15 -0800
Subject: [PATCH] mm: fix numa stats for thp migration

Currently the kernel is not correctly updating the numa stats for
NR_FILE_PAGES and NR_SHMEM on THP migration.  Fix that.

For NR_FILE_DIRTY and NR_ZONE_WRITE_PENDING, although at the moment
there is no need to handle THP migration as kernel still does not have
write support for file THP but to be more future proof, this patch adds
the THP support for those stats as well.

Link: https://lkml.kernel.org/r/20210108155813.2914586-2-shakeelb@google.com
Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/migrate.c b/mm/migrate.c
index 613794f6a433..c0efe921bca5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = expected_page_refs(mapping, page) + extra_count;
+	int nr = thp_nr_pages(page);
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, nr); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (PageTransHuge(page)) {
 		int i;
 
-		for (i = 1; i < HPAGE_PMD_NR; i++) {
+		for (i = 1; i < nr; i++) {
 			xas_next(&xas);
 			xas_store(&xas, newpage);
 		}
@@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		__dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
-		__inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
+		__mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+		__mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_lruvec_state(old_lruvec, NR_SHMEM);
-			__inc_lruvec_state(new_lruvec, NR_SHMEM);
+			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
+			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
-			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
-			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
+			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
+			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
+			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
 	local_irq_enable();

