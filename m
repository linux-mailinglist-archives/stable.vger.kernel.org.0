Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A38F39F7E6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhFHNix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:38:53 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48561 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhFHNiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 09:38:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5057D1A74;
        Tue,  8 Jun 2021 09:36:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 09:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hlXx/e
        4/hzouC+mMfMW4DSZeV4jKtoghB2/dKR1fRlI=; b=JroVctRAEE1Ak4+B4o9xFS
        3WncG8c2X+2fRD6ZhI9OpxnRiG3IygemJ1MtatfUbDyr9p4xApaRio61aLWD+6nk
        oWVJ6zIxyBl9i6CtPTcoWjA9wKewj/MHfp+0LWiUVJRyTQLoRnYhvlKDyq7xWPU+
        5LYtGvGaGX0psIhDUx7ML4RS3fkiXNXEyXAtsrH3ESyFBUEravRg4INemxLWf1UE
        nJtMCafgQcGcV9o8zXyLMsDxqgooNtJ9d5dBch5Z07if3TIxd4y6VdyxgENP37tH
        T26v/9f7yh6UlCR5uPRhT828VY/BOcW8MRGsOViSYlLTzPW+eSvhdTQe783nUvXg
        ==
X-ME-Sender: <xms:dnK_YLcPWY1EgRsPlHdN6gnspTkRy2yqkMI43hh1tWLwxiu25FcqEA>
    <xme:dnK_YBM3tKmTdin7bn3hBh3H4LNwOqrMoFUa-qqTQLyBLqNxZuwWhF4gPwLERkVPg
    mbbcvT3sEmr6w>
X-ME-Received: <xmr:dnK_YEjdGmLIzWXqGcrqlVYyyxNn9CmK9mtdhyPfwFeUrnB_u5zqGsCpIoVDM6YUEInc5M97iJLaj7_RwEbVokf6i2zBBHcv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelle
    dvgeefleeltdetgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dnK_YM9Tgpt4iP9SHwF-cCcY5ouQ6Qi0I_ZSqZvm7G0F4seSrvtxNQ>
    <xmx:dnK_YHtt4U5cvDaKgxSGS9aztzDrzv3h8Fk9Zt7lZPPW87jkj_bZQg>
    <xmx:dnK_YLG7ojakOnjY2uypDBaukPdI61s8HkJAjfJ-cLOkDsH5Q5xhZw>
    <xmx:dnK_YLjQFQB2treih5MeqqawcbhEVkvG8_uOpc4eaKVkrrmwh20zCkF-xMA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 09:36:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm, hugetlb: fix simple resv_huge_pages underflow on" failed to apply to 5.12-stable tree
To:     almasrymina@google.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 15:36:51 +0200
Message-ID: <16231594118484@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d84cf06e3dd8c5c5b547b5d8931015fc536678e5 Mon Sep 17 00:00:00 2001
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 4 Jun 2021 20:01:36 -0700
Subject: [PATCH] mm, hugetlb: fix simple resv_huge_pages underflow on
 UFFDIO_COPY

The userfaultfd hugetlb tests cause a resv_huge_pages underflow.  This
happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
an index for which we already have a page in the cache.  When this
happens, we allocate a second page, double consuming the reservation,
and then fail to insert the page into the cache and return -EEXIST.

To fix this, we first check if there is a page in the cache which
already consumed the reservation, and return -EEXIST immediately if so.

There is still a rare condition where we fail to copy the page contents
AND race with a call for hugetlb_no_page() for this index and again we
will underflow resv_huge_pages.  That is fixed in a more complicated
patch not targeted for -stable.

Test:

  Hacked the code locally such that resv_huge_pages underflows produce a
  warning, then:

  ./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
  ./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings.  After the test runs number
of free/resv hugepages is correct.

[mike.kravetz@oracle.com: changelog fixes]

Link: https://lkml.kernel.org/r/20210528004649.85298-1-almasrymina@google.com
Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 470f7b5b437e..5560b50876fb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4889,10 +4889,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		if (!page)
 			goto out;
 	} else if (!*pagep) {
-		ret = -ENOMEM;
+		/* If a page already exists, then it's UFFDIO_COPY for
+		 * a non-missing case. Return -EEXIST.
+		 */
+		if (vm_shared &&
+		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			ret = -EEXIST;
+			goto out;
+		}
+
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			ret = -ENOMEM;
 			goto out;
+		}
 
 		ret = copy_huge_page_from_user(page,
 						(const void __user *) src_addr,

