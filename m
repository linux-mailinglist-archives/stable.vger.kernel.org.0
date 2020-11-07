Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B862AA65F
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgKGPjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:39:32 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52601 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728177AbgKGPj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:39:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 529F5F7B;
        Sat,  7 Nov 2020 10:39:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:39:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vQMNoH
        /kdcpDAwnAzLSoIA9aWmvJYWwReAZozuQ+Nzg=; b=AZEUwzJbQ0LlUCIDOQbpMD
        jJ8Qhl5E1ZpJscxBF6rSOhAldQar5N5L4Baf9cM64EN5T3maN1a4lC/SDNc30MPN
        a7jmZV14epVUd68vM9i5kMGCDojSrudQ3Izmcq19JzYrQ2qgFhVwfhV6ZteHFciS
        VVHjBQi3NPEDqXAFh79YExBiaxaHW5+07iCXiOKHL8E6yljrj0nr71y0ObYYcBnh
        jb13yYuIsW0RTRnwBCfSNm2Gd5YM6AwLoSvY9ZwR3RxEFwrDZATofJCguF/JimvE
        c7bLLDAgPqEGR/KVRLLekaltYWFTb2RAA4q87IGmTCtP4YPTfauSmKJMa7iedUoQ
        ==
X-ME-Sender: <xms:rr-mX21jMjGNf1qviCUa21tEkc5a71_AxJmm5Xr7wb6KIeAQ9UJ_Ow>
    <xme:rr-mX5FfOq54gVqT7N-DX0t9O14IBxQTkFfSfrZJ7yXjoQIGwqhFeLWIEJfYpqcUZ
    PVGEuEob1E6mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rr-mX-5Ow28fpM402HpN4JZsYRf0LJm7i3x4xaGjRnb7B7wIy8G4NA>
    <xmx:rr-mX33bXXsBmStl9qhIMV09t6SxeiJCnlo1RNkitut8Ut6MUli5vQ>
    <xmx:rr-mX5GGqNOkoyBGP75xXWwmGFrsGmZKqmO9_Kx-Ofeu5gEs2OHElg>
    <xmx:rr-mXyMEPDT15She_jc2g1_YW8GJ3kr2hdd9IPv9U8owH8iJ3ipCD4IofU8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79BC532803D4;
        Sat,  7 Nov 2020 10:39:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: mempolicy: fix potential pte_unmap_unlock pte error" failed to apply to 4.9-stable tree
To:     luoshijie1@huawei.com, akpm@linux-foundation.org,
        linfeilong@huawei.com, linmiaohe@huawei.com, mhocko@suse.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:40:03 +0100
Message-ID: <160476360386106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3f08842098e842c51e3b97d0dcdebf810b32558e Mon Sep 17 00:00:00 2001
From: Shijie Luo <luoshijie1@huawei.com>
Date: Sun, 1 Nov 2020 17:07:40 -0800
Subject: [PATCH] mm: mempolicy: fix potential pte_unmap_unlock pte error

When flags in queue_pages_pte_range don't have MPOL_MF_MOVE or
MPOL_MF_MOVE_ALL bits, code breaks and passing origin pte - 1 to
pte_unmap_unlock seems like not a good idea.

queue_pages_pte_range can run in MPOL_MF_MOVE_ALL mode which doesn't
migrate misplaced pages but returns with EIO when encountering such a
page.  Since commit a7f40cfe3b7a ("mm: mempolicy: make mbind() return
-EIO when MPOL_MF_STRICT is specified") and early break on the first pte
in the range results in pte_unmap_unlock on an underflow pte.  This can
lead to lockups later on when somebody tries to lock the pte resp.
page_table_lock again..

Fixes: a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when MPOL_MF_STRICT is specified")
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Shijie Luo <luoshijie1@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201019074853.50856-1-luoshijie1@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3fde772ef5ef..3ca4898f3f24 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -525,7 +525,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	unsigned long flags = qp->flags;
 	int ret;
 	bool has_unmovable = false;
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
@@ -539,7 +539,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
@@ -571,7 +571,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		} else
 			break;
 	}
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	cond_resched();
 
 	if (has_unmovable)

