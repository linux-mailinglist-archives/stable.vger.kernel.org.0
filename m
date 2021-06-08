Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEDF39F7E8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhFHNjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:39:12 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52665 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232797AbhFHNjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 09:39:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 0B66E1C44;
        Tue,  8 Jun 2021 09:37:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 09:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PjdLwF
        9sLXB6VXXm3MTYRl8fuxp0RNgs7vwu1/8jlwE=; b=r9O7TVm4GbhlJB2BtPVpuV
        AaHWwbS4+FsiBQ62NRXJ/kZFEV3w4SXhQ48RTcxY4GLX4anyPNp7qPhktcbTvcVw
        P0OudMEVLptlliL6Qu3dOC3AtAUgy0wDdkqMWVCT7oDV1G/qj+5i487/MrweutR7
        1VmSFl2HjpjfcHrc4FJ1IMZfTJUpI7qHAB+rrhkvToOkIpXXLNdmbITuAhusQcqV
        MHTSOwrZKl7kx0fI1FX/e70bGBwB/2f7Jb4pPPe44aggT1Hr2XBZip0sm70ncaWp
        iSOTm81mM8IMAdVNkSSZJ8FA0wAsaN23gkvWqmkDQgYC1yo0J7hI/kDz27CmLQ1A
        ==
X-ME-Sender: <xms:g3K_YLlRvmNkFUAEhNVMygFevPqLgYieMPQ-d-2dR39qz8rpXW2hFg>
    <xme:g3K_YO0d94G9Y9sISlgiguEK6FGzA5hB0hAY5H01032ijcLSFoGHb82ZGrA3heil0
    jfNZBUzWE7yAw>
X-ME-Received: <xmr:g3K_YBoE9258_rhh1xu0bCW8eLXoS5Aa_MZe0ZsEs_9XVfH44CcmM65v5NKVBJaNY-AoX7dWP97htNrv2ysiePlYx_5DsQLG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelle
    dvgeefleeltdetgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:g3K_YDmHt8WOFbDZNSVyMTbwIjz8LIt8hWjijcECcZyuzNmTWe7aHQ>
    <xmx:g3K_YJ2NcWV924cnN3yjZp7xYrp97-Wnh4wQRTxJbI6XI5vSS-gmWA>
    <xmx:g3K_YCv2NmprESNPMVUhxNoyBBy57feMuovDm8Ae3dnMMak2XgL7Dw>
    <xmx:g3K_YDqXN-Mu7Z92MEjR6qzNCzB8yqKHKru50bhWpNDRcU_843VzjeyuQEE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 09:37:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm, hugetlb: fix simple resv_huge_pages underflow on" failed to apply to 5.4-stable tree
To:     almasrymina@google.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 15:36:53 +0200
Message-ID: <16231594136129@kroah.com>
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

