Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5099B2AA660
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgKGPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:39:33 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45175 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgKGPjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:39:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F1DFDDF9;
        Sat,  7 Nov 2020 10:39:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=p/A70i
        g6SppWwIjHn9OYs3458SdN+VBV5r9xandvuFI=; b=ExTcu3mPz9Q+6EsZ9POl9D
        Wq4FfY2KSWiys85iRShCLOi3hyRBqJu0jBD4KS/4Zd3olLI/ywOC+Y46s6WogFrB
        iyJc6ScyPiLVKARg528YIqeewURLRM5+qMfVOFcpDWd4rV85QUJ1vj78uRxAdIN6
        uEUfGYV2tuza2efFnqxu9Qb0BAltNI8MdRXLUV0M+rJJWZ1zCS/Ho59hPgMRzdg+
        alfwvQBCsdp1dtQ+drlJe87Cx+AlTt+CqlmpBaJ1Ys4BA0530lrUwAjc2XU74Oa1
        AFY2/xZGAUbV/Px/LiqgnDDzCA0/z+Fcvo0HjGBJeLzLDmZY5QjWB1VSODxOkQrA
        ==
X-ME-Sender: <xms:sL-mXztbN83DqGNDOhDTV-MGOaa8HhS94ri5Nei1N1BWg2GMNL_0ig>
    <xme:sL-mX0f24qgv3PyVUEri6pe3jhQAHh3X7p85mgGc2GVKm04PSSza3o_2E9meZ1FOv
    22ppWi_MubZnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sL-mX2z-umQbpzv4PzLYWyDcGoImkC9NyVs4q_ez46JxxrwMTwYouQ>
    <xmx:sL-mXyPIplwOOMXnEXZkmFIlhhTWZGX7svxekRzFIC63ms08RfDKYA>
    <xmx:sL-mXz9tWmGrRX2pHdURvNloC_wdLBE-1iM2U6rfglWtf1D0r9W6Bw>
    <xmx:sL-mX-kvyKekBgUexMqxeFdIPss6JY3fgGgN_c9XyRq7LAT9UnC3SFduvu0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32D5A30604EA;
        Sat,  7 Nov 2020 10:39:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: mempolicy: fix potential pte_unmap_unlock pte error" failed to apply to 4.14-stable tree
To:     luoshijie1@huawei.com, akpm@linux-foundation.org,
        linfeilong@huawei.com, linmiaohe@huawei.com, mhocko@suse.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:40:04 +0100
Message-ID: <16047636043195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

