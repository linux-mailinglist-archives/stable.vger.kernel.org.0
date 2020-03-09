Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6296A17E820
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgCITPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:15:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35709 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727335AbgCITPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:15:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1688422128;
        Mon,  9 Mar 2020 15:15:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 15:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gaCo7t
        ChMh9NUcXtt/22CB13RyG/rZ8z6AcFr3QniXc=; b=OTiBhhbGj6Nwk5xaDrB1/0
        WCIfEBPm9op9tPgo4LlAnKL7uUr/xw1pSMoSY4jcgpF45UOp2ECu5Kq3HB6xqici
        RR4NhpsgMsUlc71+7aDMcPZ65jUE5naGlzcYj0BiqhKCLWCCHQRMTQzPVkUsnYKS
        DD8W3ppruOKsKOJH0ixkxgWTtORElazit4KgaXsyWEpGjET3+XpCHoram7gLW3TL
        GyU4JketVpRUl+f7tS6maE/B05reoR9eaUhNBTl6Yht7gDPIBfv2q1NaGaA11hu3
        DIEfWi3Rjh+dkZOtIBBaLeAOIBTTtWUcTEl7lJzSp7cCYrrTMAHAO1f9Nd7GkdXQ
        ==
X-ME-Sender: <xms:xZVmXm46mt1GlA-FA60CGeXzcqeYmm5Caf37GOZvBZ8e0wY2LYo1TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xZVmXjEFbyqgcNRjrECx7aw7VKZRddeX1SOh4jTdfHQ-2T6_cREirw>
    <xmx:xZVmXhlYdZJ9xgNE9t5btpr4Uqj_3p6W6tlcArdaithovFpa7_qFcw>
    <xmx:xZVmXtn88DBtDvYBRVxQLPGkJraaG2vprCACbHU4Ep-3niYFD-2U_A>
    <xmx:xpVmXqWhh7AsJZGoFVkB9iLSomZhcLsF5NWp0R1XDgBJWXOokanroA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7600E3280063;
        Mon,  9 Mar 2020 15:15:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: fix possible PMD dirty bit lost in" failed to apply to 4.14-stable tree
To:     ying.huang@intel.com, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mhocko@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 20:15:15 +0100
Message-ID: <158378131510638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a8683ad9ba48b4b52a57f013513d1635c1ca5c4 Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Thu, 5 Mar 2020 22:28:29 -0800
Subject: [PATCH] mm: fix possible PMD dirty bit lost in
 set_pmd_migration_entry()

In set_pmd_migration_entry(), pmdp_invalidate() is used to change PMD
atomically.  But the PMD is read before that with an ordinary memory
reading.  If the THP (transparent huge page) is written between the PMD
reading and pmdp_invalidate(), the PMD dirty bit may be lost, and cause
data corruption.  The race window is quite small, but still possible in
theory, so need to be fixed.

The race is fixed via using the return value of pmdp_invalidate() to get
the original content of PMD, which is a read/modify/write atomic
operation.  So no THP writing can occur in between.

The race has been introduced when the THP migration support is added in
the commit 616b8371539a ("mm: thp: enable thp migration in generic path").
But this fix depends on the commit d52605d7cb30 ("mm: do not lose dirty
and accessed bits in pmdp_invalidate()").  So it's easy to be backported
after v4.16.  But the race window is really small, so it may be fine not
to backport the fix at all.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Link: http://lkml.kernel.org/r/20200220075220.2327056-1-ying.huang@intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b08b199f9a11..24ad53b4dfc0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3043,8 +3043,7 @@ void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		return;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = *pvmw->pmd;
-	pmdp_invalidate(vma, address, pvmw->pmd);
+	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	entry = make_migration_entry(page, pmd_write(pmdval));

