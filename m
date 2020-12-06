Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8708F2D0149
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 07:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgLFGtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 01:49:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36678 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgLFGtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 01:49:45 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B66fiqA068185;
        Sun, 6 Dec 2020 01:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=zXquViEhJ7suspESv6HBx58nfGP4ImLVfWoZRfcKygk=;
 b=kQSWTnt9VFPIFnqKq/gxS3tWDEDWO7y3Q2Rzs9uknTzViJi/1nzOOHzyg155YaCsnaCh
 Nt58Swo3SloPK9GDOLdf1pFzUc1Qo5kdKpGj+WzyS8kj8oBBj66haJFIKv8g/Tqg/HjD
 P54pfZeFzEQGbcDLZJfaWhHZEctrryVE8T9ao6Syal9AX6E23Basa7xcDO15cc+uHiPo
 GJN1ZnXLYdvAGM12gKM52mJWjgeSHG5BlwdH0QiW0j+n0evjZ6kta8KmETG4jpLh84J2
 mt2WIZJZ7oWX6+1t30XL9javViyDsaQ3wEKXqXoUpuTm6LKMzooO5h0FojO3JGSI6RYd 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358t8pr36n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 01:48:57 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B66gLN2069780;
        Sun, 6 Dec 2020 01:48:56 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358t8pr367-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 01:48:56 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B66gLwE002493;
        Sun, 6 Dec 2020 06:48:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u80wgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 06:48:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B66mqNP8454662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 06:48:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B42A74C046;
        Sun,  6 Dec 2020 06:48:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DC084C040;
        Sun,  6 Dec 2020 06:48:51 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.50.18])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun,  6 Dec 2020 06:48:51 +0000 (GMT)
Date:   Sun, 6 Dec 2020 08:48:49 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     akpm@linux-foundation.org
Cc:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        mgorman@suse.de, mhocko@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <20201206064849.GW123287@linux.ibm.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_02:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=32
 clxscore=1011 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060041
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Dec 05, 2020 at 04:54:01PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> has been added to the -mm tree.  Its filename is
>      mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> 
> Without this change, the pfn 0 isn't in any zone spanned range, and it's
> also not in any memory.memblock range, so the struct page of pfn 0 wasn't
> initialized and the PagePoison remained set when reserve_bootmem_region
> called __SetPageReserved, inducing a silent boot failure with DEBUG_VM
> (and correctly so, because the crash signaled the nodeid/nid of pfn 0
> would be again wrong).
> 
> There's no enforcement that all memblock.reserved ranges must overlap
> memblock.memory ranges, so the memblock.reserved ranges also require an
> explicit initialization and the zones ranges need to be extended to
> include all memblock.reserved ranges with struct pages too or they'll be
> left uninitialized with PagePoison as it happened to pfn 0.
> 
> Link: https://lkml.kernel.org/r/20201205013238.21663-2-aarcange@redhat.com
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memblock.h |   17 ++++++++---
>  mm/debug.c               |    3 +
>  mm/memblock.c            |    4 +-
>  mm/page_alloc.c          |   57 +++++++++++++++++++++++++++++--------
>  4 files changed, 63 insertions(+), 18 deletions(-)

I don't see why we need all this complexity when a simple fixup was
enough.

> --- a/include/linux/memblock.h~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
> +++ a/include/linux/memblock.h

...

> --- a/mm/page_alloc.c~mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges
> +++ a/mm/page_alloc.c

...

> @@ -6227,7 +6233,7 @@ void __init __weak memmap_init(unsigned
>  			       unsigned long zone,
>  			       unsigned long range_start_pfn)
>  {
> -	unsigned long start_pfn, end_pfn, next_pfn = 0;
> +	unsigned long start_pfn, end_pfn, prev_pfn = 0;
>  	unsigned long range_end_pfn = range_start_pfn + size;
>  	u64 pgcnt = 0;
>  	int i;
> @@ -6235,7 +6241,7 @@ void __init __weak memmap_init(unsigned
>  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>  		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
>  		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> -		next_pfn = clamp(next_pfn, range_start_pfn, range_end_pfn);
> +		prev_pfn = clamp(prev_pfn, range_start_pfn, range_end_pfn);
>  
>  		if (end_pfn > start_pfn) {
>  			size = end_pfn - start_pfn;
> @@ -6243,10 +6249,10 @@ void __init __weak memmap_init(unsigned
>  					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
>  		}
>  
> -		if (next_pfn < start_pfn)
> -			pgcnt += init_unavailable_range(next_pfn, start_pfn,
> +		if (prev_pfn < start_pfn)
> +			pgcnt += init_unavailable_range(prev_pfn, start_pfn,
>  							zone, nid);
> -		next_pfn = end_pfn;
> +		prev_pfn = end_pfn;
>  	}
>  
>  	/*
> @@ -6256,12 +6262,31 @@ void __init __weak memmap_init(unsigned
>  	 * considered initialized. Make sure that memmap has a well defined
>  	 * state.
>  	 */
> -	if (next_pfn < range_end_pfn)
> -		pgcnt += init_unavailable_range(next_pfn, range_end_pfn,
> +	if (prev_pfn < range_end_pfn)
> +		pgcnt += init_unavailable_range(prev_pfn, range_end_pfn,
>  						zone, nid);
>  
> +	/*
> +	 * memblock.reserved isn't enforced to overlap with
> +	 * memblock.memory so initialize the struct pages for
> +	 * memblock.reserved too in case it wasn't overlapping.
> +	 *
> +	 * If any struct page associated with a memblock.reserved
> +	 * range isn't overlapping with a zone range, it'll be left
> +	 * uninitialized, ideally with PagePoison, and it'll be a more
> +	 * easily detectable error.
> +	 */
> +	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> +		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
> +		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> +
> +		if (end_pfn > start_pfn)
> +			pgcnt += init_unavailable_range(start_pfn, end_pfn,
> +							zone, nid);
> +	}

This means we are going iterate over all memory allocated before
free_area_ini() from memblock extra time. One time here and another time
in reserve_bootmem_region().
And this can be substantial for CMA and alloc_large_system_hash().

> +
>  	if (pgcnt)
> -		pr_info("%s: Zeroed struct page in unavailable ranges: %lld\n",
> +		pr_info("%s: pages in unavailable ranges: %lld\n",
>  			zone_names[zone], pgcnt);
>  }
>  
> @@ -6499,6 +6524,10 @@ void __init get_pfn_range_for_nid(unsign
>  		*start_pfn = min(*start_pfn, this_start_pfn);
>  		*end_pfn = max(*end_pfn, this_end_pfn);
>  	}
> +	for_each_res_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
> +		*start_pfn = min(*start_pfn, this_start_pfn);
> +		*end_pfn = max(*end_pfn, this_end_pfn);
> +	}
>  
>  	if (*start_pfn == -1UL)
>  		*start_pfn = 0;
> @@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
>   */
>  unsigned long __init find_min_pfn_with_active_regions(void)
>  {
> -	return PHYS_PFN(memblock_start_of_DRAM());
> +	/*
> +	 * reserved regions must be included so that their page
> +	 * structure can be part of a zone and obtain a valid zoneid
> +	 * before __SetPageReserved().
> +	 */
> +	return min(PHYS_PFN(memblock_start_of_DRAM()),
> +		   PHYS_PFN(memblock.reserved.regions[0].base));

So this implies that reserved memory starts before memory. Don't you
find this weird?

>  }
>  
>  /*
> _
> 
> Patches currently in -mm which might be from aarcange@redhat.com are
> 
> mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 

-- 
Sincerely yours,
Mike.
