Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A942032545E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhBYRIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 12:08:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234328AbhBYRHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 12:07:52 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PH2lAo018661;
        Thu, 25 Feb 2021 12:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=mWpPq56z5DGoB0nelFqiqLQFXIjErs2NXFY3C+xsWTM=;
 b=ORgBDj9Bvj1cfNEiI1YrL8RgSkhSnNhXHxtlBk+Ut90SrNS5xhTCqdtE6nnsj7/pvCds
 QkZzGDWeQGV5tjaJH7MZF+N9AdSQXcEGiGvdk76rQiblgNk2TfG/IrwjoxxFaRI0iYYY
 blg1Ir8npSfknDPo3/cDqK0LGUni2Au6i3WY/vWhVwnB6Lt+FY0rwvmhx7K2NOXjcXB4
 iuckFVoFpLa1GHY5WSsUpkw+xq4q7WqPltUEbABKQL7kQvMrR4j4o3Fn/BxsMj3e/2Rs
 NRyHMQoGZ/yOI11hdR88u/w5hiuFfQfaCRqpBwcImURAwFmfIYnzY+iCjdkODV4OzNna lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcx9bbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 12:06:39 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PH3JEv020221;
        Thu, 25 Feb 2021 12:06:39 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xfcx9b8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 12:06:39 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PH2e46026326;
        Thu, 25 Feb 2021 17:06:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt284mdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 17:06:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PH6XdR31588620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 17:06:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A26D24203F;
        Thu, 25 Feb 2021 17:06:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DE6742042;
        Thu, 25 Feb 2021 17:06:31 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.51.238])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Feb 2021 17:06:31 +0000 (GMT)
Date:   Thu, 25 Feb 2021 19:06:29 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210225170629.GE1854360@linux.ibm.com>
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
 <515b4abf-ff07-a43a-ac2e-132c33681886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515b4abf-ff07-a43a-ac2e-132c33681886@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_10:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 04:59:06PM +0100, David Hildenbrand wrote:
> On 24.02.21 16:39, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
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
> > 
> > because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> > in struct page) in the same pageblock.
> > 
> > Interleave initialization of the unavailable pages with the normal
> > initialization of memory map, so that zone and node information will be
> > properly set on struct pages that are not backed by the actual memory.
> > 
> > With this change the pages for holes inside a zone will get proper
> > zone/node links and the pages that are not spanned by any node will get
> > links to the adjacent zone/node.
> > 
> > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Reported-by: Qian Cai <cai@lca.pw>
> > Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> > Reviewed-by: Baoquan He <bhe@redhat.com>
> > ---
> >   mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
> >   1 file changed, 64 insertions(+), 83 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 3e93f8b29bae..a11a9acde708 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6280,12 +6280,60 @@ static void __meminit zone_init_free_lists(struct zone *zone)
> >   	}
> >   }
> > +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> > +/*
> > + * Only struct pages that correspond to ranges defined by memblock.memory
> > + * are zeroed and initialized by going through __init_single_page() during
> > + * memmap_init_zone().
> > + *
> > + * But, there could be struct pages that correspond to holes in
> > + * memblock.memory. This can happen because of the following reasons:
> > + * - phyiscal memory bank size is not necessarily the exact multiple of the
> > + *   arbitrary section size
> > + * - early reserved memory may not be listed in memblock.memory
> > + * - memory layouts defined with memmap= kernel parameter may not align
> > + *   nicely with memmap sections
> > + *
> > + * Explicitly initialize those struct pages so that:
> > + * - PG_Reserved is set
> > + * - zone and node links point to zone and node that span the page
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
> >   void __meminit __weak memmap_init_zone(struct zone *zone)
> >   {
> >   	unsigned long zone_start_pfn = zone->zone_start_pfn;
> >   	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
> >   	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> > +	static unsigned long hole_pfn = 0;
> >   	unsigned long start_pfn, end_pfn;
> > +	u64 pgcnt = 0;
> >   	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> >   		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> > @@ -6295,7 +6343,23 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
> >   			memmap_init_range(end_pfn - start_pfn, nid,
> >   					zone_id, start_pfn, zone_end_pfn,
> >   					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
> > +
> > +		if (hole_pfn < start_pfn)
> > +			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
> > +							zone_id, nid);
> > +		hole_pfn = end_pfn;
> >   	}
> > +
> > +#ifdef CONFIG_SPARSEMEM
> > +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> > +	if (hole_pfn < end_pfn)
> > +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> > +						zone_id, nid);
> 
> We might still double-initialize PFNs when two zones overlap within a
> section, correct?

You mean that a section crosses zones boundary?
I don't think it's that important.

> This might worth documenting - also, you might want to
> take some of the original comment the accompanied this code.

The original comment was not exactly right, I believe the comment above
init_unavailable_range() better describes what's going on there.
 
> You should also document (in the patch description?) that node/zone spans
> are not properly handled yet for such hole pfns and that this might require
> care in the future.

I think Link: will suffice for this.
 
> I played a little with weird setups and expected the memap state using
> page-types (well, I can't inspect the node/zone that way but at least have a
> look if the memmap was initialized). No surprises.

Great, thanks!

-- 
Sincerely yours,
Mike.
