Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38117325525
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhBYSIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 13:08:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233225AbhBYSGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 13:06:48 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PI4JBN184132;
        Thu, 25 Feb 2021 13:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=D/vq04KrC5z7pj6suPS7B/dPNTPFiG/UIVker3qiyOM=;
 b=q7joBG/vQLob9hXtPyu+pbVPu5g1aCQmFFNg1XGwvwFhzjOuEkSKh3BkAZ8k36cg3nxm
 fPnfRGiP6wlkusZ+O91b2OdnMi67Ord4CKEZQiKFtBhCA+oSk4jifeUiPJiT33jFOGYR
 z0jKJvG6Cs2CFK04v0tYIaG2C7/RIbwEwe+I31TQwmf4lrCiTFRLoO6Dhthv7sCPPxCM
 zpjAmoFKx0mzzJJfJVx8qOimNifK1DDcdITWn1l4lHVu1H7gtrtt9qDkw8vdFU3FGHwf
 piIS3IRTxB9ClTB5U/q/Zt8Ij8zyGJ8m2tBXls8m50m2/j/9co99Orho6XC51HjXHsOb 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xe106trq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 13:05:31 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PI4RAx184987;
        Thu, 25 Feb 2021 13:05:30 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xe106tqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 13:05:30 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PI2ClE010667;
        Thu, 25 Feb 2021 18:05:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 36tt28tf12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 18:05:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PI5Pro32702956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 18:05:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DED3A11C052;
        Thu, 25 Feb 2021 18:05:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 912CC11C04A;
        Thu, 25 Feb 2021 18:05:23 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.51.238])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Feb 2021 18:05:23 +0000 (GMT)
Date:   Thu, 25 Feb 2021 20:05:21 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210225180521.GH1854360@linux.ibm.com>
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
 <a4b2ba7e-96a5-6a75-dad7-626d054f9e8b@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4b2ba7e-96a5-6a75-dad7-626d054f9e8b@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_10:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250138
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 06:51:53PM +0100, Vlastimil Babka wrote:
> On 2/24/21 4:39 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Hi, thanks for your efforts. I'll just nit pick on the description/comments as I
> don't feel confident about judging the implementation correctness, sorry :)
> 
> > There could be struct pages that are not backed by actual physical memory.
> > This can happen when the actual memory bank is not a multiple of
> > SECTION_SIZE or when an architecture does not register memory holes
> > reserved by the firmware as memblock.memory.
> > 
> > Such pages are currently initialized using init_unavailable_mem() function
> > that iterates through PFNs in holes in memblock.memory and if there is a
> > struct page corresponding to a PFN, the fields of this page are set to
> > default values and it is marked as Reserved.
> > 
> > init_unavailable_mem() does not take into account zone and node the page
> > belongs to and sets both zone and node links in struct page to zero.
> > 
> > Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> > rather that check each PFN") the holes inside a zone were re-initialized
> > during memmap_init() and got their zone/node links right. However, after
> > that commit nothing updates the struct pages representing such holes.
> > 
> > On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> > instance in a configuration below:
> > 
> > 	# grep -A1 E820 /proc/iomem
> > 	7a17b000-7a216fff : Unknown E820 type
> > 	7a217000-7bffffff : System RAM
> > 
> > unset zone link in struct page will trigger
> > 
> > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> ... in set_pfnblock_flags_mask() when called with a struct page from the
> "Unknown E820 type" range.

"... in set_pfnblock_flags_mask() when called with a struct page from a range
other than E820_TYPE_RAM"

then :)
 
> > because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> > in struct page) in the same pageblock.
> 
> I would say "there are apparently pages" ... "and ZONE_DMA does not span this range"

I'd rephrase it differently, something like

"because there are pages in the range of ZONE_DMA32 but the unset zone link
in struct page makes them appear as a part of ZONE_DMA"

> > Interleave initialization of the unavailable pages with the normal
> > initialization of memory map, so that zone and node information will be
> > properly set on struct pages that are not backed by the actual memory.
> > 
> > With this change the pages for holes inside a zone will get proper
> > zone/node links and the pages that are not spanned by any node will get
> > links to the adjacent zone/node.
> 
> What if two zones are adjacent? I.e. if the hole was at a boundary between two
> zones.

What do you mean by "adjacent zones"? If there is a hole near the zone
boundary, zone span would be clamped to exclude the hole.

> > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Reported-by: Qian Cai <cai@lca.pw>
> > Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> > Reviewed-by: Baoquan He <bhe@redhat.com>
> 
> For the approach:
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 
> > ---
> >  mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
> >  1 file changed, 64 insertions(+), 83 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 3e93f8b29bae..a11a9acde708 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6280,12 +6280,60 @@ static void __meminit zone_init_free_lists(struct zone *zone)
> >  	}
> >  }
> >  
> > +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> > +/*
> > + * Only struct pages that correspond to ranges defined by memblock.memory
> > + * are zeroed and initialized by going through __init_single_page() during
> > + * memmap_init_zone().
> > + *
> > + * But, there could be struct pages that correspond to holes in
> > + * memblock.memory. This can happen because of the following reasons:
> > + * - phyiscal memory bank size is not necessarily the exact multiple of the
> 
>         physical

Thanks. 

> > + *   arbitrary section size
> > + * - early reserved memory may not be listed in memblock.memory
> > + * - memory layouts defined with memmap= kernel parameter may not align
> > + *   nicely with memmap sections
> > + *
> > + * Explicitly initialize those struct pages so that:
> > + * - PG_Reserved is set
> > + * - zone and node links point to zone and node that span the page
> 
> Yes spanned pages are the most important, but should you also describe here the
> adjacent ones, as you do in commit log?

Will try :)

> > + */
> > +static u64 __meminit init_unavailable_range(unsigned long spfn,
> > +					    unsigned long epfn,
> > +					    int zone, int node)
> > +{
> > +	unsigned long pfn;
> > +	u64 pgcnt = 0;
> > +
> > +	for (pfn = spfn; pfn < epfn; pfn++) {
> > +		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
> > +			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
> > +				+ pageblock_nr_pages - 1;
> > +			continue;
> > +		}
> > +		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> > +		__SetPageReserved(pfn_to_page(pfn));
> > +		pgcnt++;
> > +	}
> > +
> > +	return pgcnt;
> > +}
> > +#else
> > +static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
> > +					 int zone, int node)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  void __meminit __weak memmap_init_zone(struct zone *zone)
> >  {
> >  	unsigned long zone_start_pfn = zone->zone_start_pfn;
> >  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
> >  	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> > +	static unsigned long hole_pfn = 0;
> >  	unsigned long start_pfn, end_pfn;
> > +	u64 pgcnt = 0;
> >  
> >  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> >  		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> > @@ -6295,7 +6343,23 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
> >  			memmap_init_range(end_pfn - start_pfn, nid,
> >  					zone_id, start_pfn, zone_end_pfn,
> >  					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
> > +
> > +		if (hole_pfn < start_pfn)
> > +			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
> > +							zone_id, nid);
> > +		hole_pfn = end_pfn;
> >  	}
> > +
> > +#ifdef CONFIG_SPARSEMEM
> > +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> > +	if (hole_pfn < end_pfn)
> > +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> > +						zone_id, nid);
> > +#endif
> > +
> > +	if (pgcnt)
> > +		pr_info("  %s zone: %lld pages in unavailable ranges\n",
> > +			zone->name, pgcnt);
> >  }
> >  
> >  static int zone_batchsize(struct zone *zone)
> > @@ -7092,88 +7156,6 @@ void __init free_area_init_memoryless_node(int nid)
> >  	free_area_init_node(nid);
> >  }
> >  
> > -#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> > -/*
> > - * Initialize all valid struct pages in the range [spfn, epfn) and mark them
> > - * PageReserved(). Return the number of struct pages that were initialized.
> > - */
> > -static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
> > -{
> > -	unsigned long pfn;
> > -	u64 pgcnt = 0;
> > -
> > -	for (pfn = spfn; pfn < epfn; pfn++) {
> > -		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
> > -			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
> > -				+ pageblock_nr_pages - 1;
> > -			continue;
> > -		}
> > -		/*
> > -		 * Use a fake node/zone (0) for now. Some of these pages
> > -		 * (in memblock.reserved but not in memblock.memory) will
> > -		 * get re-initialized via reserve_bootmem_region() later.
> > -		 */
> > -		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
> > -		__SetPageReserved(pfn_to_page(pfn));
> > -		pgcnt++;
> > -	}
> > -
> > -	return pgcnt;
> > -}
> > -
> > -/*
> > - * Only struct pages that are backed by physical memory are zeroed and
> > - * initialized by going through __init_single_page(). But, there are some
> > - * struct pages which are reserved in memblock allocator and their fields
> > - * may be accessed (for example page_to_pfn() on some configuration accesses
> > - * flags). We must explicitly initialize those struct pages.
> > - *
> > - * This function also addresses a similar issue where struct pages are left
> > - * uninitialized because the physical address range is not covered by
> > - * memblock.memory or memblock.reserved. That could happen when memblock
> > - * layout is manually configured via memmap=, or when the highest physical
> > - * address (max_pfn) does not end on a section boundary.
> > - */
> > -static void __init init_unavailable_mem(void)
> > -{
> > -	phys_addr_t start, end;
> > -	u64 i, pgcnt;
> > -	phys_addr_t next = 0;
> > -
> > -	/*
> > -	 * Loop through unavailable ranges not covered by memblock.memory.
> > -	 */
> > -	pgcnt = 0;
> > -	for_each_mem_range(i, &start, &end) {
> > -		if (next < start)
> > -			pgcnt += init_unavailable_range(PFN_DOWN(next),
> > -							PFN_UP(start));
> > -		next = end;
> > -	}
> > -
> > -	/*
> > -	 * Early sections always have a fully populated memmap for the whole
> > -	 * section - see pfn_valid(). If the last section has holes at the
> > -	 * end and that section is marked "online", the memmap will be
> > -	 * considered initialized. Make sure that memmap has a well defined
> > -	 * state.
> > -	 */
> > -	pgcnt += init_unavailable_range(PFN_DOWN(next),
> > -					round_up(max_pfn, PAGES_PER_SECTION));
> > -
> > -	/*
> > -	 * Struct pages that do not have backing memory. This could be because
> > -	 * firmware is using some of this memory, or for some other reasons.
> > -	 */
> > -	if (pgcnt)
> > -		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
> > -}
> > -#else
> > -static inline void __init init_unavailable_mem(void)
> > -{
> > -}
> > -#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
> > -
> >  #if MAX_NUMNODES > 1
> >  /*
> >   * Figure out the number of possible node ids.
> > @@ -7597,7 +7579,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >  	/* Initialise every node */
> >  	mminit_verify_pageflags_layout();
> >  	setup_nr_node_ids();
> > -	init_unavailable_mem();
> >  	for_each_online_node(nid) {
> >  		pg_data_t *pgdat = NODE_DATA(nid);
> >  		free_area_init_node(nid);
> > 
> 

-- 
Sincerely yours,
Mike.
