Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BFD1FF92E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFRQ0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:26:04 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42143 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727882AbgFRQ0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:26:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 27A401940C56;
        Thu, 18 Jun 2020 12:26:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:26:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aOjy1I
        F+6f41x1h3mVokMOFcmjaaBPro1TqlnO6qdu8=; b=h8nOMbdJhGs8sFQt9r/Cjm
        5fCcerAyHODH7xUdju6B37OKnRrrdwjyTKQdHLLXmpusP7IUlSaZMUP6ysxO6s5S
        0auhMErASZox1qeZZZD8m7NjrpT9JMFEc17z7PEh1noWrLwrUbsk8wB72f35/Lg0
        se3jz9rdrPGzZE58Z3MSuNkKIjkGEFn+afnwLFix9GATKlLzXj/3+LpLsyf/7RbR
        fpjvIL7QGcCFic/lniDeQkpeLSO89VpqsXyeJ4d8hHHEDDKMo49GCmfZwyRnww32
        /a219FbfBKBlUT2IHUaM+dmMMOdjMmnP3AQdKfvc+pSkbYf2BNP7msLZQFqy84YA
        ==
X-ME-Sender: <xms:mZXrXmCHgqhlQcMCQXSwIXGWAIipye_V0uKPnLalAlHsLjS62Hd0zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mZXrXggAqlkNG33Gn_J7Xbc1HtY3dUyp017JjdHqqUlontVCwpzAiQ>
    <xmx:mZXrXpmLKdiSu_5XuSfVFycocEA46kF26zPEQKGJgml0xVGLX9ZpRg>
    <xmx:mZXrXkxSCwEGNJgxqroWFSYd9cuN2T85GfJ0d_jOcrA_A36R2jLjJQ>
    <xmx:m5XrXgK-vysoNo3wfEmU4h551KpXVFDuGthY_bafarGPq9_OEzQqKvt3t6s>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A25A73060F09;
        Thu, 18 Jun 2020 12:26:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/pagealloc.c: call touch_nmi_watchdog() on max order" failed to apply to 4.19-stable tree
To:     daniel.m.jordan@oracle.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, david@redhat.com, jmorris@namei.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, pasha.tatashin@soleen.com,
        sashal@kernel.org, shile.zhang@linux.alibaba.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, yiwei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:25:52 +0200
Message-ID: <159249755225165@kroah.com>
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

From 117003c32771df617acf66e140fbdbdeb0ac71f5 Mon Sep 17 00:00:00 2001
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Date: Wed, 3 Jun 2020 15:59:20 -0700
Subject: [PATCH] mm/pagealloc.c: call touch_nmi_watchdog() on max order
 boundaries in deferred init

Patch series "initialize deferred pages with interrupts enabled", v4.

Keep interrupts enabled during deferred page initialization in order to
make code more modular and allow jiffies to update.

Original approach, and discussion can be found here:
 http://lkml.kernel.org/r/20200311123848.118638-1-shile.zhang@linux.alibaba.com

This patch (of 3):

deferred_init_memmap() disables interrupts the entire time, so it calls
touch_nmi_watchdog() periodically to avoid soft lockup splats.  Soon it
will run with interrupts enabled, at which point cond_resched() should be
used instead.

deferred_grow_zone() makes the same watchdog calls through code shared
with deferred init but will continue to run with interrupts disabled, so
it can't call cond_resched().

Pull the watchdog calls up to these two places to allow the first to be
changed later, independently of the second.  The frequency reduces from
twice per pageblock (init and free) to once per max order block.

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: James Morris <jmorris@namei.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Yiqian Wei <yiwei@redhat.com>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-2-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 045c4aeeec9a..148cf9a73f0b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1693,7 +1693,6 @@ static void __init deferred_free_pages(unsigned long pfn,
 		} else if (!(pfn & nr_pgmask)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 1;
-			touch_nmi_watchdog();
 		} else {
 			nr_free++;
 		}
@@ -1723,7 +1722,6 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 			continue;
 		} else if (!page || !(pfn & nr_pgmask)) {
 			page = pfn_to_page(pfn);
-			touch_nmi_watchdog();
 		} else {
 			page++;
 		}
@@ -1863,8 +1861,10 @@ static int __init deferred_init_memmap(void *data)
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn)
+	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
+	}
 zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
@@ -1948,6 +1948,7 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 		first_deferred_pfn = spfn;
 
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		touch_nmi_watchdog();
 
 		/* We should only stop along section boundaries */
 		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)

