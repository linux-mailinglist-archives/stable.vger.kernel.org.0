Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECDC2D16D6
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 17:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgLGQvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 11:51:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbgLGQvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 11:51:32 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GW86E178762;
        Mon, 7 Dec 2020 11:50:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Ds2WMdmZ/lq45y6KREZlyRQnT0/6RFYciu/UgANIqxg=;
 b=DuhRZMk1xlZFYHzTM72HtjN3nt2s7fOGjUwSvFUEhNbWzhULK97NGHp7PEBDf8oyGNzV
 qFT4/7timwsMtV9YVdIAUm7OCNHk9vB71rb7hgsL/MvYdmiflSUiIwlPtjx/owWaodSw
 E5Ghiol6gppiwfLO2vq8wByTCJEVV2Q8rNwHx7t1PbFZ3obOiz6f2mnoG7o8tgRhPd75
 DkLj6cITSW4V0D9fuSjXKqrwZkNwEeeRe4finPzGA4rIUc7NJWDAMe1vdPtFxJ5h2Jgd
 SstIZZ7HrfSE4tsuMuiH9r0KyYb+6ieeqmyIgnC65+vIKxiZnRVlD8VT/jonHXOZzN8R kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359qrqs26a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 11:50:45 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7GWUXJ180262;
        Mon, 7 Dec 2020 11:50:45 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359qrqs24j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 11:50:45 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Gmg6i014990;
        Mon, 7 Dec 2020 16:50:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 35958q0emg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 16:50:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7GoeY319988808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 16:50:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FBBC4204B;
        Mon,  7 Dec 2020 16:50:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BC2742054;
        Mon,  7 Dec 2020 16:50:39 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.50.18])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  7 Dec 2020 16:50:39 +0000 (GMT)
Date:   Mon, 7 Dec 2020 18:50:37 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <20201207165037.GH1112728@linux.ibm.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
 <X80xQ6mvSwJZ0RvC@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X80xQ6mvSwJZ0RvC@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=962 mlxscore=0 lowpriorityscore=0 suspectscore=5
 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070102
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 02:30:11PM -0500, Andrea Arcangeli wrote:
> On Sun, Dec 06, 2020 at 08:48:49AM +0200, Mike Rapoport wrote:
> > I don't see why we need all this complexity when a simple fixup was
> > enough.
> 
> Note the memblock bug crashed my systems:
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> Please note how zone_spans_pfn expands:
> 
> static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
> {
> 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
> }
> 
> For pfn_to_page(0), the zone_start_pfn is 1 for DMA zone. pfn is 0.

I don't know why you keep calling it "memblock bug" as pfn 0 was not
part of DMA zone at least for ten years.

If you backport this VM_BUG_ON_PAGE() to 2.6.36 that has no memblock on
x86 it will happily trigger there.

The problem, as I see it, in, hmm, questionable semantics for
!E820_TYPE_RAM ranges on x86.

I keep asking this simple question again and again and I still have no
clear "yes" or "no" answer:

	Is PFN 0 on x86 memory?

Let's step back for a second and instead of blaming memblock in lack of
enforcement for .memory and .reserved to overlap and talking about how
memblock core was not robust enough we'll get to the point where we have
clear defintions of what e820 ranges represent.

> > > +	/*
> > > +	 * memblock.reserved isn't enforced to overlap with
> > > +	 * memblock.memory so initialize the struct pages for
> > > +	 * memblock.reserved too in case it wasn't overlapping.
> > > +	 *
> > > +	 * If any struct page associated with a memblock.reserved
> > > +	 * range isn't overlapping with a zone range, it'll be left
> > > +	 * uninitialized, ideally with PagePoison, and it'll be a more
> > > +	 * easily detectable error.
> > > +	 */
> > > +	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> > > +		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
> > > +		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> > > +
> > > +		if (end_pfn > start_pfn)
> > > +			pgcnt += init_unavailable_range(start_pfn, end_pfn,
> > > +							zone, nid);
> > > +	}
> > 
> > This means we are going iterate over all memory allocated before
> > free_area_ini() from memblock extra time. One time here and another time
> > in reserve_bootmem_region().
> > And this can be substantial for CMA and alloc_large_system_hash().
> 
> The above loops over memory.reserved only.

Right, this loops over memory.reserved which happens to include CMA and
the memory allocated in alloc_large_system_hash(). This can be a lot.
And memmap_init() runs before threads are available so this cannot be
parallelized.
The deferred memmap initialization starts much later than this.

> > > @@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
> > >   */
> > >  unsigned long __init find_min_pfn_with_active_regions(void)
> > >  {
> > > -	return PHYS_PFN(memblock_start_of_DRAM());
> > > +	/*
> > > +	 * reserved regions must be included so that their page
> > > +	 * structure can be part of a zone and obtain a valid zoneid
> > > +	 * before __SetPageReserved().
> > > +	 */
> > > +	return min(PHYS_PFN(memblock_start_of_DRAM()),
> > > +		   PHYS_PFN(memblock.reserved.regions[0].base));
> > 
> > So this implies that reserved memory starts before memory. Don't you
> > find this weird?
> 
> The above is a more complex way to write the below, which will make it
> more clear there's never overlap:
> 
> 		if (entry->type == E820_TYPE_SOFT_RESERVED)
> 			memblock_reserve(entry->addr, entry->size);
> 		else if (entry->type == E820_TYPE_RAM || entry->type == E820_TYPE_RESERVED_KERN)
> 			memblock_add(entry->addr, entry->size);

So what about E820_TYPE_ACPI or E820_TYPE_NVS?
How should they be treated?

It happend that we memblock_reserve() the first page, but what if the
BIOS marks pfn 1 as E820_TYPE_ACPI? It's neither in .memory nor in
.reserved. Does it belong to zone 0 and node 0?

Or, if, say, node 1 starts at 4G and the BIOS claimed several first pages
of node 1 as type 20?
What should we do then?

> Thanks,
> Andrea
> 

-- 
Sincerely yours,
Mike.
