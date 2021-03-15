Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1C33AE9B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCOJYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:24:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229663AbhCOJXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 05:23:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12F9Kkkd014322;
        Mon, 15 Mar 2021 05:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=/ZNiusgjhuMBhSyN3tNp/zx+vz5xwfZTps/B0UvBYCM=;
 b=atURwI0BINzqJtNYMlvhJSmieQT3PPwV1U1yt7Lzod0ahKCa/lEEvemvfumJhTt95t+W
 t63LN3DAIsc+0QHF6cn8BI7FtbIYVAus3GCtw1Dmb6K8OX2gxIN213kQKgyk8izs7sg5
 ILBkojAnfVcP+hJM8DSE97+MLmUDCj3pln9QJb5TIs7Twaze5dgldsVaOKnZ/N7zWPWs
 oEAPDwqI62GtyFovGPD0Sg5xCy0nCCTY9BH5/PV5O9XCJ/eLHZYRnODDC2h2LAavU+Ko
 ANn3nrQVhDIhBGvSlxOiSJPftdDTSf3V1UJ10f4bdTLq5h+Yn56p7n7XVxgO5usLNGtZ PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 379rh464mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 05:23:22 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12F9Kn1U014697;
        Mon, 15 Mar 2021 05:23:21 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 379rh464kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 05:23:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12F9Jen0004879;
        Mon, 15 Mar 2021 09:23:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 378n188vay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 09:23:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12F9N1qv31981920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 09:23:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 821FD42041;
        Mon, 15 Mar 2021 09:23:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B27034204C;
        Mon, 15 Mar 2021 09:23:14 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.58.148])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 15 Mar 2021 09:23:14 +0000 (GMT)
Date:   Mon, 15 Mar 2021 11:23:12 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     rppt@kernel.org, aarcange@redhat.com, akpm@linux-foundation.org,
        bhe@redhat.com, bp@alien8.de, cai@lca.pw, chris@chris-wilson.co.uk,
        david@redhat.com, hpa@zytor.com, lma@semihalf.com, mgorman@suse.de,
        mhocko@kernel.org, mingo@redhat.com, stable@vger.kernel.org,
        tglx@linutronix.de, tomi.p.sarvela@intel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc.c: refactor initialization
 of struct page for" failed to apply to 5.11-stable tree
Message-ID: <YE8ngJ3k/RuL5RER@linux.ibm.com>
References: <161579835811940@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <161579835811940@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_03:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150063
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Mar 15, 2021 at 09:52:38AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.11-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 0740a50b9baa4472cfb12442df4b39e2712a64a4 Mon Sep 17 00:00:00 2001
> From: Mike Rapoport <rppt@kernel.org>
> Date: Fri, 12 Mar 2021 21:07:12 -0800
> Subject: [PATCH] mm/page_alloc.c: refactor initialization of struct page for
>  holes in memory layout

The version below applies to v5.11 and v5.10.

From 66b430c3eef5eb9e3372eab3522e47acabefecc9 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Fri, 12 Mar 2021 21:07:12 -0800
Subject: [PATCH] mm/page_alloc.c: refactor initialization of struct page for
 holes in memory layout
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There could be struct pages that are not backed by actual physical memory.
This can happen when the actual memory bank is not a multiple of
SECTION_SIZE or when an architecture does not register memory holes
reserved by the firmware as memblock.memory.

Such pages are currently initialized using init_unavailable_mem() function
that iterates through PFNs in holes in memblock.memory and if there is a
struct page corresponding to a PFN, the fields of this page are set to
default values and it is marked as Reserved.

init_unavailable_mem() does not take into account zone and node the page
belongs to and sets both zone and node links in struct page to zero.

Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock
regions rather that check each PFN") the holes inside a zone were
re-initialized during memmap_init() and got their zone/node links right.
However, after that commit nothing updates the struct pages representing
such holes.

On a system that has firmware reserved holes in a zone above ZONE_DMA, for
instance in a configuration below:

	# grep -A1 E820 /proc/iomem
	7a17b000-7a216fff : Unknown E820 type
	7a217000-7bffffff : System RAM

unset zone link in struct page will trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

in set_pfnblock_flags_mask() when called with a struct page from a range
other than E820_TYPE_RAM because there are pages in the range of
ZONE_DMA32 but the unset zone link in struct page makes them appear as a
part of ZONE_DMA.

Interleave initialization of the unavailable pages with the normal
initialization of memory map, so that zone and node information will be
properly set on struct pages that are not backed by the actual memory.

With this change the pages for holes inside a zone will get proper
zone/node links and the pages that are not spanned by any node will get
links to the adjacent zone/node.  The holes between nodes will be
prepended to the zone/node above the hole and the trailing pages in the
last section that will be appended to the zone/node below.

[akpm@linux-foundation.org: don't initialize static to zero, use %llu for u64]

Link: https://lkml.kernel.org/r/20210225224351.7356-2-rppt@kernel.org
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Łukasz Majczak <lma@semihalf.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 mm/page_alloc.c | 158 +++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 83 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 519a60d5b6f7..b46ba78be37f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6257,13 +6257,66 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	}
 }
 
+#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+/*
+ * Only struct pages that correspond to ranges defined by memblock.memory
+ * are zeroed and initialized by going through __init_single_page() during
+ * memmap_init_zone().
+ *
+ * But, there could be struct pages that correspond to holes in
+ * memblock.memory. This can happen because of the following reasons:
+ * - physical memory bank size is not necessarily the exact multiple of the
+ *   arbitrary section size
+ * - early reserved memory may not be listed in memblock.memory
+ * - memory layouts defined with memmap= kernel parameter may not align
+ *   nicely with memmap sections
+ *
+ * Explicitly initialize those struct pages so that:
+ * - PG_Reserved is set
+ * - zone and node links point to zone and node that span the page if the
+ *   hole is in the middle of a zone
+ * - zone and node links point to adjacent zone/node if the hole falls on
+ *   the zone boundary; the pages in such holes will be prepended to the
+ *   zone/node above the hole except for the trailing pages in the last
+ *   section that will be appended to the zone/node below.
+ */
+static u64 __meminit init_unavailable_range(unsigned long spfn,
+					    unsigned long epfn,
+					    int zone, int node)
+{
+	unsigned long pfn;
+	u64 pgcnt = 0;
+
+	for (pfn = spfn; pfn < epfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
+			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
+				+ pageblock_nr_pages - 1;
+			continue;
+		}
+		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
+		__SetPageReserved(pfn_to_page(pfn));
+		pgcnt++;
+	}
+
+	return pgcnt;
+}
+#else
+static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
+					 int zone, int node)
+{
+	return 0;
+}
+#endif
+
 void __meminit __weak memmap_init(unsigned long size, int nid,
 				  unsigned long zone,
 				  unsigned long range_start_pfn)
 {
+	static unsigned long hole_pfn;
 	unsigned long start_pfn, end_pfn;
 	unsigned long range_end_pfn = range_start_pfn + size;
 	int i;
+	u64 pgcnt = 0;
 
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
@@ -6274,7 +6327,29 @@ void __meminit __weak memmap_init(unsigned long size, int nid,
 			memmap_init_zone(size, nid, zone, start_pfn, range_end_pfn,
 					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
+
+		if (hole_pfn < start_pfn)
+			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
+							zone, nid);
+		hole_pfn = end_pfn;
 	}
+
+#ifdef CONFIG_SPARSEMEM
+	/*
+	 * Initialize the hole in the range [zone_end_pfn, section_end].
+	 * If zone boundary falls in the middle of a section, this hole
+	 * will be re-initialized during the call to this function for the
+	 * higher zone.
+	 */
+	end_pfn = round_up(range_end_pfn, PAGES_PER_SECTION);
+	if (hole_pfn < end_pfn)
+		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
+						zone, nid);
+#endif
+
+	if (pgcnt)
+		pr_info("  %s zone: %llu pages in unavailable ranges\n",
+			zone_names[zone], pgcnt);
 }
 
 static int zone_batchsize(struct zone *zone)
@@ -7075,88 +7150,6 @@ void __init free_area_init_memoryless_node(int nid)
 	free_area_init_node(nid);
 }
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
-/*
- * Initialize all valid struct pages in the range [spfn, epfn) and mark them
- * PageReserved(). Return the number of struct pages that were initialized.
- */
-static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
-{
-	unsigned long pfn;
-	u64 pgcnt = 0;
-
-	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
-				+ pageblock_nr_pages - 1;
-			continue;
-		}
-		/*
-		 * Use a fake node/zone (0) for now. Some of these pages
-		 * (in memblock.reserved but not in memblock.memory) will
-		 * get re-initialized via reserve_bootmem_region() later.
-		 */
-		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
-		__SetPageReserved(pfn_to_page(pfn));
-		pgcnt++;
-	}
-
-	return pgcnt;
-}
-
-/*
- * Only struct pages that are backed by physical memory are zeroed and
- * initialized by going through __init_single_page(). But, there are some
- * struct pages which are reserved in memblock allocator and their fields
- * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly initialize those struct pages.
- *
- * This function also addresses a similar issue where struct pages are left
- * uninitialized because the physical address range is not covered by
- * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=, or when the highest physical
- * address (max_pfn) does not end on a section boundary.
- */
-static void __init init_unavailable_mem(void)
-{
-	phys_addr_t start, end;
-	u64 i, pgcnt;
-	phys_addr_t next = 0;
-
-	/*
-	 * Loop through unavailable ranges not covered by memblock.memory.
-	 */
-	pgcnt = 0;
-	for_each_mem_range(i, &start, &end) {
-		if (next < start)
-			pgcnt += init_unavailable_range(PFN_DOWN(next),
-							PFN_UP(start));
-		next = end;
-	}
-
-	/*
-	 * Early sections always have a fully populated memmap for the whole
-	 * section - see pfn_valid(). If the last section has holes at the
-	 * end and that section is marked "online", the memmap will be
-	 * considered initialized. Make sure that memmap has a well defined
-	 * state.
-	 */
-	pgcnt += init_unavailable_range(PFN_DOWN(next),
-					round_up(max_pfn, PAGES_PER_SECTION));
-
-	/*
-	 * Struct pages that do not have backing memory. This could be because
-	 * firmware is using some of this memory, or for some other reasons.
-	 */
-	if (pgcnt)
-		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
-}
-#else
-static inline void __init init_unavailable_mem(void)
-{
-}
-#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
-
 #if MAX_NUMNODES > 1
 /*
  * Figure out the number of possible node ids.
@@ -7580,7 +7573,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
-- 
2.28.0


