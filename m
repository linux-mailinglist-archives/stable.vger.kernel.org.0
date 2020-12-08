Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0C2D358C
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 22:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgLHVs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 16:48:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgLHVs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 16:48:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8LfSBd070260;
        Tue, 8 Dec 2020 16:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=+qQf+sjEeYOXMkH59FZ/2QmD65d9LnYchq0Di2PPGO4=;
 b=L1T4hy0Kz5VCdVZxXIcmzxglln0+e8hTWCKG54z6nHbtvkvqTDBI/W/oIVxSOyla4MVZ
 mdmwes/cvHhpAeFIlMcIIfj2iJXV3JrF9XqCviZasNrNTfrM6xJhyCX3EezjxSvUFvlD
 ZZfuCf5ZlUFa7quUl+kwZxXBRn/k8nEv2TyeOGsuISKsBJH85CEZqnEKd4/gOBih3bIH
 0Un9u6pwsVfBX5l31JUTYMEuyl7nXqbNICpD6r/hhylVlHsr2GZoFpA7LU0gYeDFSYOG
 gF+5/J7/gh9gn4VF3Ek+Z+ueoyTeai8S7pEbVQEsfyqf+0+JXD6ehy9paZMmnvlVQq5F lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35agehhw3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 16:47:38 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8LhhOS076685;
        Tue, 8 Dec 2020 16:47:37 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35agehhw32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 16:47:37 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8LlZ33016520;
        Tue, 8 Dec 2020 21:47:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8nu66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 21:47:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8LkHCC50266538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 21:46:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC2E8A4054;
        Tue,  8 Dec 2020 21:46:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76A6DA405C;
        Tue,  8 Dec 2020 21:46:16 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.50.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Dec 2020 21:46:16 +0000 (GMT)
Date:   Tue, 8 Dec 2020 23:46:14 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <20201208214614.GD1164013@linux.ibm.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
 <X80xQ6mvSwJZ0RvC@redhat.com>
 <20201207165037.GH1112728@linux.ibm.com>
 <X87rodZBmvJCyjBi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X87rodZBmvJCyjBi@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_15:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=5 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080133
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 09:57:37PM -0500, Andrea Arcangeli wrote:
> On Mon, Dec 07, 2020 at 06:50:37PM +0200, Mike Rapoport wrote:
> > On Sun, Dec 06, 2020 at 02:30:11PM -0500, Andrea Arcangeli wrote:
> > > On Sun, Dec 06, 2020 at 08:48:49AM +0200, Mike Rapoport wrote:
> > > > I don't see why we need all this complexity when a simple fixup was
> > > > enough.
> > > 
> > > Note the memblock bug crashed my systems:
> > > 
> > > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > > 
> > > Please note how zone_spans_pfn expands:
> > > 
> > > static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
> > > {
> > > 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
> > > }
> > > 
> > > For pfn_to_page(0), the zone_start_pfn is 1 for DMA zone. pfn is 0.
> > 
> > I don't know why you keep calling it "memblock bug" as pfn 0 was not
> > part of DMA zone at least for ten years.
> > 
> > If you backport this VM_BUG_ON_PAGE() to 2.6.36 that has no memblock on
> > x86 it will happily trigger there.
> 
> I guess it wasn't considered a bug until your patch that was meant to
> enforce this invariant for all pfn_valid was merged in -mm?

What was not considered a bug? That node 0 and DMA zone on x86 started
at pfn 1 and pfn 0 zone/node links were set by chance to the right
values?

There was no intention to engfoce any invariant of overlaping or not
ovelapping ranges in memblock.memory and memblock.reserved.

The change in 73a6e474cb376921a311786652782155eac2fdf0 was to change the
loop over all pfns in a zone that among other things checked if that pfn
is in memblock.memory to a loop over intersection of pfns in a
zone with memblock.memory.

This exposed that before 73a6e474cb376921a311786652782155eac2fdf0:
* small holes, like your "7a17b000-7a216fff : Unknown E820 type" get
their zone/node links right because of an optimizaiton in
__early_pfn_to_nid() that didn't check if a pfn is in memblock.memory
for every pfn but rather cached the results.
* on x86 pfn 0 was neither in node 0 nor in DMA zone because they both
started with pfn 1; it got zone/node links set to 0 because that's what
init_unavailable_range() did for all pfns in "unavailable ranges".

So, if you add something like this

static int check_pfn0(void)
{
	unsigned long pfn = 0;
	struct page *page = pfn_to_page(pfn);

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

	return 0;
}
late_initcall(check_pfn0);

to an older kernel, this will blow up.

So, my guess is that we've never got to this check for pfn 0 and I
really don't know how your system crashed with both my patches applied,
unless you had a patch that checked pfn 0.

> > The problem, as I see it, in, hmm, questionable semantics for
> > !E820_TYPE_RAM ranges on x86.
> > 
> > I keep asking this simple question again and again and I still have no
> > clear "yes" or "no" answer:
> > 
> > 	Is PFN 0 on x86 memory?
> 
> The pfn is the same regardless if it's RAM or non RAM, so I don't
> think it makes any difference in this respect if it's RAM or not.
> 
> > Let's step back for a second and instead of blaming memblock in lack of
> > enforcement for .memory and .reserved to overlap and talking about how
> > memblock core was not robust enough we'll get to the point where we have
> > clear defintions of what e820 ranges represent.
> 
> I don't see why we should go back into the direction that the caller
> needs improvement like in commit
> 124049decbb121ec32742c94fb5d9d6bed8f24d8 and to try to massage the raw
> e820 data before giving it to the linux common code.

That's the entire point that the e820 data is massaged before it gets to
the common code. 124049decbb121ec32742c94fb5d9d6bed8f24d8 tried to alter
the way the raw e820 was transformed before going to the common code and
my feeling it was a shot in the dark.

The current abstraction we have in the common code to describe physical
memory is memblock and I want to make it explicit that every range in
e820 table is a part of system memory and hence a part of
memblock.memory.

> Even if you wanted to enforce overlap at all times (not possible
> because of the direct mapping issue) you could do it simply by calling
> memblock_add first thing in memblock_reserve (if it wasn't already
> fully overlapping) without the need to add an explicit memblock_add in
> the caller.

The purpose here is not to enforce overlap at all times [and it is
possible despite the direct mapping issues ;-) ].
The idea is to have the abstract description of the physical memory
(i.e. memblock) as close as possible to actual layout. The "simple" code
in e820__memblock_setup() only made things obfuscated and inconsistent.

If you have memory populated at address 0 you would expect that
for_each_mem_pfn_range() will start from pfn 0.

In addition, and implicit call to memblock_add() in memblock_reserve()
would be a waste of CPU time as most of the times memblock_reserve() is
called as the part of memory allocation before page allocator is ready.

> > > > > +	/*
> > > > > +	 * memblock.reserved isn't enforced to overlap with
> > > > > +	 * memblock.memory so initialize the struct pages for
> > > > > +	 * memblock.reserved too in case it wasn't overlapping.
> > > > > +	 *
> > > > > +	 * If any struct page associated with a memblock.reserved
> > > > > +	 * range isn't overlapping with a zone range, it'll be left
> > > > > +	 * uninitialized, ideally with PagePoison, and it'll be a more
> > > > > +	 * easily detectable error.
> > > > > +	 */
> > > > > +	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> > > > > +		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
> > > > > +		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> > > > > +
> > > > > +		if (end_pfn > start_pfn)
> > > > > +			pgcnt += init_unavailable_range(start_pfn, end_pfn,
> > > > > +							zone, nid);
> > > > > +	}
> > > > 
> > > > This means we are going iterate over all memory allocated before
> > > > free_area_ini() from memblock extra time. One time here and another time
> > > > in reserve_bootmem_region().
> > > > And this can be substantial for CMA and alloc_large_system_hash().
> > > 
> > > The above loops over memory.reserved only.
> > 
> > Right, this loops over memory.reserved which happens to include CMA and
> > the memory allocated in alloc_large_system_hash(). This can be a lot.
> > And memmap_init() runs before threads are available so this cannot be
> > parallelized.
> > The deferred memmap initialization starts much later than this.
> 
> Can you convert the memblock.memory and memblock.reserved to an
> interval tree? interval tree shall work perfectly since the switch to
> long mode, no need of dynamic RAM allocations for its inner
> working. There's no need to keep memblock a O(N) list.

Sorry, I was not clear. The penalty here is not the traversal of
memblock.reserved array. The penalty is for redundant initialization of
struct page for ranges memblock.reserved describes.
For instance, the if user specified hugetlb_cma=nnG loop over
memblock.reserved will cause redundant initialization pass over the
pages in this nnG.

> Such change would benefit the code even if we remove the loop over
> memblock.reserved.
> 
> > > > > @@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
> > > > >   */
> > > > >  unsigned long __init find_min_pfn_with_active_regions(void)
> > > > >  {
> > > > > -	return PHYS_PFN(memblock_start_of_DRAM());
> > > > > +	/*
> > > > > +	 * reserved regions must be included so that their page
> > > > > +	 * structure can be part of a zone and obtain a valid zoneid
> > > > > +	 * before __SetPageReserved().
> > > > > +	 */
> > > > > +	return min(PHYS_PFN(memblock_start_of_DRAM()),
> > > > > +		   PHYS_PFN(memblock.reserved.regions[0].base));
> > > > 
> > > > So this implies that reserved memory starts before memory. Don't you
> > > > find this weird?
> > > 
> > > The above is a more complex way to write the below, which will make it
> > > more clear there's never overlap:
> > > 
> > > 		if (entry->type == E820_TYPE_SOFT_RESERVED)
> > > 			memblock_reserve(entry->addr, entry->size);
> > > 		else if (entry->type == E820_TYPE_RAM || entry->type == E820_TYPE_RESERVED_KERN)
> > > 			memblock_add(entry->addr, entry->size);
> > 
> > So what about E820_TYPE_ACPI or E820_TYPE_NVS?
> > How should they be treated?
> > 
> > It happend that we memblock_reserve() the first page, but what if the
> > BIOS marks pfn 1 as E820_TYPE_ACPI? It's neither in .memory nor in
> > .reserved. Does it belong to zone 0 and node 0?
> > 
> > Or, if, say, node 1 starts at 4G and the BIOS claimed several first pages
> > of node 1 as type 20?
> > What should we do then?
> 
> I see we still have dependencies on the caller to send down good data,
> which would be ideal to remove.

Regardless of particular implementation, the generic code cannot detect
physical memory layout, this is up to architecture to detect what memory
banks are populated and provide this information to the generic code.

So we'll always have what you call "dependencies on the caller" here.
The good thing is that we can fix "the caller" when we find it's wrong.

> I guess before worrying of pfn 1 not being added to memblock.reserved,
> I'd worry about pfn 0 itself not being added to memblock.reserved.

My point was that with a bit different e820 table we may again hit a
corner case that we didn't anticipate.

pfn 0 is in memblock.reserved by a coincidence and not by design and using
memblock.reserved to detect zone/node boundaries is not reliable.

Moreover, if you look for usage of for_each_mem_pfn_range() in
page_alloc.c, it's looks very much that it is presumed to iterate over
*all* physical memory, including mysterious pfn 0.

> Still with the complex patch applied, if something goes wrong
> DEBUG_VM=y will make it reproducible, with the simple fix we return in
> non-reproducible land.

I still think that the complex patch is going in the wrong direction.
We cannot rely on memblock.reserved to calculate zones and nodes span.

This:

+       /*
+        * reserved regions must be included so that their page
+        * structure can be part of a zone and obtain a valid zoneid
+        * before __SetPageReserved().
+        */
+       return min(PHYS_PFN(memblock_start_of_DRAM()),
+                  PHYS_PFN(memblock.reserved.regions[0].base));

is definitely a hack that worked because "the caller" has this:

	/*
	 * Make sure page 0 is always reserved because on systems with
	 * L1TF its contents can be leaked to user processes.
	 */
	memblock_reserve(0, PAGE_SIZE);

So, what would have happen if L1TF was not yet disclosed? ;-)

Anyway, I think we need somthing like:

* add everything in e820 to memblock.memory while keeping any
!E820_TYPE_RAM out of the direct map
* refactor initialization of struct page for holes in memory layout to
have proper state for struct pages not backed by actual memory
* add validation of memory/nodes/zones to make sure the generic code can
deal with data that architecture supplied; this maybe only for
DEBUG_VM=y case.

> Thanks,
> Andrea
> 

-- 
Sincerely yours,
Mike.
