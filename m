Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C91D6EBD7
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbfGSVD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfGSVD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 17:03:57 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4565C2184E;
        Fri, 19 Jul 2019 21:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563570235;
        bh=0y3OwOJJL0ZsGZPr5ojKDgmzJb3bLr8Q1az/NuC2eKQ=;
        h=Date:From:To:Subject:From;
        b=OBvbJkwIEJ0lUyeeovMDZldU3+1/ll9ellBVELMclUO4aeLtBkbRigdfR1GOEwwQ9
         Xh5dMH4GdkS4kUgg7P6sQaUnSphEbiopgy1g0a5LlZ8NfWENBA1jmZEeqPdy6Th0Qv
         1amT8Zx7xUriBHYBiNFoMlwhABQHKB6W0eykYOHA=
Date:   Fri, 19 Jul 2019 14:03:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, schwidefsky@de.ibm.com,
        rdunlap@infradead.org, penberg@kernel.org, mike.kravetz@oracle.com,
        mhocko@suse.com, mgorman@techsingularity.net, logang@deltatee.com,
        kirill.shutemov@linux.intel.com, jiangshanlai@gmail.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@mellanox.com,
        jack@suse.cz, ira.weiny@intel.com, hch@lst.de,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        cl@linux.com, aryabinin@virtuozzo.com, aarcange@redhat.com,
        rcampbell@nvidia.com
Subject:  + mm-document-zone-device-struct-page-field-usage.patch
 added to -mm tree
Message-ID: <20190719210354.ukyMd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: document zone device struct page field usage
has been added to the -mm tree.  Its filename is
     mm-document-zone-device-struct-page-field-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-zone-device-struct=
-page-field-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-zone-device-struct=
-page-field-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: document zone device struct page field usage

Struct page for ZONE_DEVICE private pages uses the page->mapping and and
page->index fields while the source anonymous pages are migrated to device
private memory.  This is so rmap_walk() can find the page when migrating
the ZONE_DEVICE private page back to system memory.  ZONE_DEVICE pmem
backed fsdax pages also use the page->mapping and page->index fields when
files are mapped into a process address space.

Restructure struct page and add comments to make this more clear.

Link: http://lkml.kernel.org/r/20190719192955.30462-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   42 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/include/linux/mm_types.h~mm-document-zone-device-struct-page-field-us=
age
+++ a/include/linux/mm_types.h
@@ -76,13 +76,35 @@ struct page {
 	 * avoid collision and false-positive PageTail().
 	 */
 	union {
-		struct {	/* Page cache and anonymous pages */
-			/**
-			 * @lru: Pageout list, eg. active_list protected by
-			 * pgdat->lru_lock.  Sometimes used as a generic list
-			 * by the page owner.
-			 */
-			struct list_head lru;
+		struct {	/* Page cache, anonymous, ZONE_DEVICE pages */
+			union {
+				/**
+				 * @lru: Pageout list, e.g., active_list
+				 * protected by pgdat->lru_lock. Sometimes
+				 * used as a generic list by the page owner.
+				 */
+				struct list_head lru;
+				/**
+				 * ZONE_DEVICE pages are never on the lru
+				 * list so they reuse the list space.
+				 * ZONE_DEVICE private pages are counted as
+				 * being mapped so the @mapping and @index
+				 * fields are used while the page is migrated
+				 * to device private memory.
+				 * ZONE_DEVICE MEMORY_DEVICE_FS_DAX pages also
+				 * use the @mapping and @index fields when pmem
+				 * backed DAX files are mapped.
+				 */
+				struct {
+					/**
+					 * @pgmap: Points to the hosting
+					 * device page map.
+					 */
+					struct dev_pagemap *pgmap;
+					/** @zone_device_data: opaque data. */
+					void *zone_device_data;
+				};
+			};
 			/* See page-flags.h for PAGE_MAPPING_FLAGS */
 			struct address_space *mapping;
 			pgoff_t index;		/* Our offset within mapping. */
@@ -155,12 +177,6 @@ struct page {
 			spinlock_t ptl;
 #endif
 		};
-		struct {	/* ZONE_DEVICE pages */
-			/** @pgmap: Points to the hosting device page map. */
-			struct dev_pagemap *pgmap;
-			void *zone_device_data;
-			unsigned long _zd_pad_1;	/* uses mapping */
-		};
=20
 		/** @rcu_head: You can use this to free a page by RCU. */
 		struct rcu_head rcu_head;
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-document-zone-device-struct-page-field-usage.patch
mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

