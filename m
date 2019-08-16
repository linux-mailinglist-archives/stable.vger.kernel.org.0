Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86068FF98
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 12:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfHPKBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 06:01:15 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56725 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbfHPKBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 06:01:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 771082A3D;
        Fri, 16 Aug 2019 06:01:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 16 Aug 2019 06:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pYV7z/
        zN1znYNhXnaDHZi82HGW6WTuePuf0h1sTgB9A=; b=TLNW8qx7ugbMcGFcWJs0PQ
        clp4fzlUefaJxJ1YmeqeX78WTPeoeQ6Bc+BH9H8TbWtpg2/jS0Fw5qY1wc1WL6Mf
        mcAHrpE/TsLKKKCqo7ne8P+EvbsqahdohjxIzYXccqkh7jA60hveBNjwY6K07rpI
        XAMxpAb9ExindnBVAdaETuR7PyT0NxjQd1OGhgwv3OF413YWUaamKrG4nfXwiDiu
        fgKGfpKMwA4BSdWbDgFhNYCgMe2SRQ2Ybi0xGev9QvG5oKQIoLn5iSr/Whh57AjW
        CQK/MO8yM/C8LezRA+Igc69H5qColtMOCDub/2Fb+6VVChFoK8OKkOAOEqNSjayw
        ==
X-ME-Sender: <xms:535WXbX3JHGz20LnN9yjLi3hQvNJKgRbh80kA8jXJLh6AO5NkB2afg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeffedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:535WXcWthzcHtthwXd2ITxukRyhvvBirdA5Al9DtQeltODjFZQaxrg>
    <xmx:535WXZkw9YOZuOvBJkN4gDrl0aDsCBlWODXSyXCbxDGg_eER4Rnx-Q>
    <xmx:535WXdLd3bPEwhkMK_7TXqhEY8Qv1gnQd8QYXfYk7TObUs1UJj3OOw>
    <xmx:6X5WXfs1Dn-g25EyH1wtADl16DSWrrUCHkSBhruyi-YdbIbNy1jZiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82CE58005A;
        Fri, 16 Aug 2019 06:01:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hmm: fix bad subpage pointer in try_to_unmap_one" failed to apply to 4.14-stable tree
To:     rcampbell@nvidia.com, aarcange@redhat.com,
        akpm@linux-foundation.org, aryabinin@virtuozzo.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com, hch@lst.de,
        ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com, jiangshanlai@gmail.com,
        kirill.shutemov@linux.intel.com, logang@deltatee.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, penberg@kernel.org, rdunlap@infradead.org,
        schwidefsky@de.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Aug 2019 12:01:08 +0200
Message-ID: <15659496684516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 1de13ee59225dfc98d483f8cce7d83f97c0b31de Mon Sep 17 00:00:00 2001
From: Ralph Campbell <rcampbell@nvidia.com>
Date: Tue, 13 Aug 2019 15:37:11 -0700
Subject: [PATCH] mm/hmm: fix bad subpage pointer in try_to_unmap_one
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When migrating an anonymous private page to a ZONE_DEVICE private page,
the source page->mapping and page->index fields are copied to the
destination ZONE_DEVICE struct page and the page_mapcount() is
increased.  This is so rmap_walk() can be used to unmap and migrate the
page back to system memory.

However, try_to_unmap_one() computes the subpage pointer from a swap pte
which computes an invalid page pointer and a kernel panic results such
as:

  BUG: unable to handle page fault for address: ffffea1fffffffc8

Currently, only single pages can be migrated to device private memory so
no subpage computation is needed and it can be set to "page".

[rcampbell@nvidia.com: add comment]
  Link: http://lkml.kernel.org/r/20190724232700.23327-4-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20190719192955.30462-4-rcampbell@nvidia.com
Fixes: a5430dda8a3a1c ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/rmap.c b/mm/rmap.c
index e5dfe2ae6b0d..003377e24232 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1475,7 +1475,15 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
+			 *
+			 * The assignment to subpage above was computed from a
+			 * swap PTE which results in an invalid pointer.
+			 * Since only PAGE_SIZE pages can currently be
+			 * migrated, just set it to page. This will need to be
+			 * changed when hugepage migrations to device private
+			 * memory are supported.
 			 */
+			subpage = page;
 			goto discard;
 		}
 

