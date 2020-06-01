Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB91EA269
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgFALH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:07:28 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53259 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgFALH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 07:07:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C1BCF19408F8;
        Mon,  1 Jun 2020 07:07:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 07:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m1Ldvt
        GREb0ge1WL2n9lb1PxlLKIPEwydrXtBNBXQ4E=; b=NdJbGcK4xeVlhBz1nco1BU
        t6RL7GcX8Y9VPhSHOcnZVmCbp/LdOZqe/kh4Q+ZlJilUSPtluarKBG/L8ar9FjP2
        joh7+d5eZ9knZLI9I+apXuUMBvKsUwo2TDjnkMvlpjpb+wnkMuoKQFPxxm1CC1gG
        9qHNccTp86o44GG0EzbI8BXGROwdrGNFk7onANnm2vuXXJnvwzWtEK0I5Tqery9u
        14C7M70XatlwwORh4weSSSGImsy04IuNtOoCrUs+xtHTaRdzvmXmVuGNIx+/cOzI
        LLNL/sADo8dxVI9mZuyf+nAJWptSa6sQJmyKAxNdA9xWGn6JAz5/R50bicyxd2uw
        ==
X-ME-Sender: <xms:buHUXqKsksfjXUvj0p_eA-h20V6m3-4AROfn6C_CecFdGR00vC_c8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:buHUXiIp26lPwzH7bRCtV6ghiejlYmX9u44xbeJMN-EeZs7-5vgvlw>
    <xmx:buHUXqtn_ZcmYzK-PBxmdmc8NhJ33s56dBvN-FyA-fI2bSMEyF5jww>
    <xmx:buHUXvYxkIKP2-OTMAR1n08fbFOsFZX-Wll5f3q_c6VDwj1u0gK24w>
    <xmx:buHUXgxGg4HZJwwcMLIQWrxcEDOYcBUwM5c5E38u_ufa2EhfCCM9vQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDD0D3280060;
        Mon,  1 Jun 2020 07:07:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: add VM_BUG_ON_PAGE() to page_mapcount()" failed to apply to 4.4-stable tree
To:     Yalin.Wang@sonymobile.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, torvalds@linux-foundation.org,
        yalin.wang@sonymobile.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jun 2020 13:07:24 +0200
Message-ID: <159100964424864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1d148e218a0d0566b1c06f2f45f1436d53b049b2 Mon Sep 17 00:00:00 2001
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Date: Wed, 11 Feb 2015 15:24:48 -0800
Subject: [PATCH] mm: add VM_BUG_ON_PAGE() to page_mapcount()

Add VM_BUG_ON_PAGE() for slab pages.  _mapcount is an union with slab
struct in struct page, so we must avoid accessing _mapcount if this page
is a slab page.  Also remove the unneeded bracket.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8dd4fde9d2e5..c6bf813a6b3d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -484,7 +484,8 @@ static inline void page_mapcount_reset(struct page *page)
 
 static inline int page_mapcount(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + 1;
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 static inline int page_count(struct page *page)

