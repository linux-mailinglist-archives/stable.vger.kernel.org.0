Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780102D4D18
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 22:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgLIVrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 16:47:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32996 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733021AbgLIVrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 16:47:01 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9LWI8h093076;
        Wed, 9 Dec 2020 16:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=IjhstqwRkpEzjfk3T1WiEhmfDvCaQp/3SbJIeXVt4Gc=;
 b=kPcuwcEc1b2FaXN/mowfi9pEfFVm0wllOC+1ZSVWfhRRIydSPSSKjJr7lE2PrPaC0oRY
 oWmL3/YNA5firwOMl0wpw6cMfaWK5f18lYHkI1K/9ZJd8T5bvPzRDAbKrsa558lO/qNJ
 cnNP5rRWPOME17kE49SeAYUeZLbIxaLONPI2LSk0lF4i/Qgb45LO5ycFOHM4nc3m3B3y
 5PRFnzQlByqhuoJc61TBVZX/pC39vgcrYys4WDSHAyaOhWsS9+453M06EoZiRyPTI5zS
 W7KmqspJhL2kDGnn90/QGdbS+Jbkb9U91vENn9DZYpyAu7c8/9mWQ31hH2JM8NXkhV3i iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ayxndbb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 16:42:39 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9LWlU1094812;
        Wed, 9 Dec 2020 16:42:39 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ayxndbaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 16:42:39 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9LXFDL017337;
        Wed, 9 Dec 2020 21:42:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhn36s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 21:42:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9LgYur34275682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 21:42:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4A7FAE051;
        Wed,  9 Dec 2020 21:42:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E60AE04D;
        Wed,  9 Dec 2020 21:42:33 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.168.186])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  9 Dec 2020 21:42:33 +0000 (GMT)
Date:   Wed, 9 Dec 2020 23:42:31 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <20201209214231.GC8939@linux.ibm.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
 <X80xQ6mvSwJZ0RvC@redhat.com>
 <20201207165037.GH1112728@linux.ibm.com>
 <X87rodZBmvJCyjBi@redhat.com>
 <20201208214614.GD1164013@linux.ibm.com>
 <X9AIq3bwYXtrpFvx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9AIq3bwYXtrpFvx@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090147
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 06:13:47PM -0500, Andrea Arcangeli wrote:
> On Tue, Dec 08, 2020 at 11:46:14PM +0200, Mike Rapoport wrote:
>
> > Sorry, I was not clear. The penalty here is not the traversal of
> > memblock.reserved array. The penalty is for redundant initialization of
> > struct page for ranges memblock.reserved describes.
> 
> But that's the fix... How can you avoid removing the PagePoison for
> all pfn_valid in memblock.reserved, when the crash of
> https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org is
> in __SetPageReserved of reserve_bootmem_region?

With your fix the pages in the memblock.reserved that intersects
with memblock.memory will be initialized twice: first time in
for_each_mem_pfn_range() and the second time in for_each_res_pfn_range()

> > For instance, the if user specified hugetlb_cma=nnG loop over
> > memblock.reserved will cause redundant initialization pass over the
> > pages in this nnG.
> 
> And if that didn't happen, then I'm left wondering if
> free_low_memory_core_early would crash again with specified
> hugetlb_cma=nnG, not just in pfn 0 anymore even with the simple fix
> applied.
> 
> Where does PagePoison get removed from the CMA range, or is somehow
> __SetPageReserved not called with the simple fix applied on the CMA
> reserved range?

CMA range would be in both memblock.memory and memblock.reserved. So the
pages for it will be initialized in for_each_mem_pfn_range().

> > Regardless of particular implementation, the generic code cannot detect
> > physical memory layout, this is up to architecture to detect what memory
> > banks are populated and provide this information to the generic code.
> > 
> > So we'll always have what you call "dependencies on the caller" here.
> > The good thing is that we can fix "the caller" when we find it's wrong.
> 
> The caller that massages the e820 bios table, is still
> software. Software can go from arch code to common code. There's no
> asm or arch dependency in there.
> 
> The caller in my view needs to know what e820 is and send down the raw
> info... it's a 1:1 API translation, the caller massaging of the data
> can all go in the callee and benefit all callers.

Well, the translation between e820 and memblock could been 1:1, but it
is not. I think e820 in more broadly x86 memory initialization could
benifit from more straightforward translation to memblock. For instance,
I don't see why the pfn 0 should be marked as reserved in both e820 and
memblock and why some of the e820 reserved areas never make it to
memblock.reserved.

> The benefit is once the callee does all validation, then all archs
> that do a mistake will be told and boot will not fail and it'll be
> more likely to boot stable even in presence of inconsistent hardware
> tables.

That's true. Having the generic code more robust will benifit everybody.

> > > I guess before worrying of pfn 1 not being added to memblock.reserved,
> > > I'd worry about pfn 0 itself not being added to memblock.reserved.
> > 
> > My point was that with a bit different e820 table we may again hit a
> > corner case that we didn't anticipate.
> > 
> > pfn 0 is in memblock.reserved by a coincidence and not by design and using
> > memblock.reserved to detect zone/node boundaries is not reliable.
> >
> > Moreover, if you look for usage of for_each_mem_pfn_range() in
> > page_alloc.c, it's looks very much that it is presumed to iterate over
> > *all* physical memory, including mysterious pfn 0.
> 
> All the complex patch does it that it guarantees all the reserved
> pages can get a "right" zoneid.
> 
> Then we certainly should consider rounding it down by the pageblock in
> case pfn 0 isn't reserved.
> 
> In fact if you add all memblock.reserved ranges to memblock.memory,
> you'll obtain exactly the same result in the zone_start_pfn as with
> the complex patch in the zone_start_pfn calculation and the exact same
> issue of PagePoison being left on pfn 0 will happen if pfn 0 isn't
> added to memblock.memory with { memblock_add; memblock_reserved }.
>  
> > > Still with the complex patch applied, if something goes wrong
> > > DEBUG_VM=y will make it reproducible, with the simple fix we return in
> > > non-reproducible land.
> > 
> > I still think that the complex patch is going in the wrong direction.
> > We cannot rely on memblock.reserved to calculate zones and nodes span.
> > 
> > This:
> > 
> > +       /*
> > +        * reserved regions must be included so that their page
> > +        * structure can be part of a zone and obtain a valid zoneid
> > +        * before __SetPageReserved().
> > +        */
> > +       return min(PHYS_PFN(memblock_start_of_DRAM()),
> > +                  PHYS_PFN(memblock.reserved.regions[0].base));
> > 
> > is definitely a hack that worked because "the caller" has this:
> > 
> > 	/*
> > 	 * Make sure page 0 is always reserved because on systems with
> > 	 * L1TF its contents can be leaked to user processes.
> > 	 */
> > 	memblock_reserve(0, PAGE_SIZE);
> > 
> > So, what would have happen if L1TF was not yet disclosed? ;-)
> 
> It's actually fine thing to delete the above memblock_reserve(0,
> PAGE_SIZE) for all testing so we can move into the remaining issues.

There are few more places in arch/x86/kernel/setup.c that
memblock_reserve() one or several pages from address 0 :-)

> The end result of the "hack" is precisely what you obtain if you add
> all memblock.reserved to memblock.memory, except it doesn't require to
> add memblock.reserved to memblock.memory.

I still do not agree that there can be minimum between
memblock_start_of_DRAM() and anything else. I think it's semantically
wrong.

And I really dislike addition of memblock.reserved traversals, mostly
because of the areas that actually overlap.

However, I do agree that adding non-overlaping part of memblock.reserved
to memblock.memory will make the generic code more robust. I just don't
want to do this implicitly by calling memblock_add() from
memblock_reserve(). I think the cleaner way is to join them just before
free_area_init() starts zone/node size detection.

> Thanks,
> Andrea
> 

-- 
Sincerely yours,
Mike.
