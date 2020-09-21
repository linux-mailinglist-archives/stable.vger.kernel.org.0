Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1C2730F1
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIURjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:39:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48820 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIURjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 13:39:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHWoQj090637;
        Mon, 21 Sep 2020 13:37:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3XIUYpc3C+Pu2lBFJPzrPnGeSJmYybjVQQTFkjsaG40=;
 b=PH29p3X4c6OkJue8GjadYB+1kTqK4a2A8mH0ezHnlzzSKbZYylMGubrPmNJb4RKgq3VC
 DLgq+N5JhDVCBZZWO9UjUPGX1bzJUSp9Amjp7Fw9d3OL4MEfM5TKGPfD9sv3//aLfQ+I
 8eD7BbU9IV/0uOOLymtIRUNwlcBT9sGmth0R7T/29Ntf+I3Wr7Y4z85JLUJ5byEOHi8w
 yROPSzxub2SajfUljyVMDujc0w4lQMkDV6Wpxl4F1o2+ghelCbpat1R2RXiG11ppBaNm
 1VLH2UASotcGx5S1+NSa3zZiNx+1R4rSBxBBEuVI3QPR+pdU+Vhg4rzadaGzaqZzgfZG eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33px1ewta3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 13:37:21 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08LHX2qj091077;
        Mon, 21 Sep 2020 13:37:21 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33px1ewt9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 13:37:21 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LHYEUx018765;
        Mon, 21 Sep 2020 17:37:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 33n9m7s606-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 17:37:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LHbGbs30736826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 17:37:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B5C152051;
        Mon, 21 Sep 2020 17:37:16 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.160.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 802BA5204E;
        Mon, 21 Sep 2020 17:37:14 +0000 (GMT)
Subject: Re: + mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch added
 to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        will@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, rppt@linux.ibm.com, richard@nod.at,
        peterz@infradead.org, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, linux@armlinux.org.uk,
        jgg@nvidia.com, jdike@addtoit.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        dave.hansen@linux.intel.com, dave.hansen@intel.com,
        catalin.marinas@arm.com, bp@alien8.de, benh@kernel.crashing.org,
        aryabinin@virtuozzo.com, arnd@arndb.de, agordeev@linux.ibm.com,
        gor@linux.ibm.com
References: <20200916003608.ib4Ln%akpm@linux-foundation.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <eac62020-0526-cbc9-18d3-499526ef7a14@de.ibm.com>
Date:   Mon, 21 Sep 2020 19:37:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200916003608.ib4Ln%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 16.09.20 02:36, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: mm/gup: fix gup_fast with dynamic page table folding
> has been added to the -mm tree.  Its filename is
>      mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
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

Andrew,

now that this is part of next, what are the plans for merging this in 5.9?
It does fix a data corruption issue on s390.

thanks

Christian 



> ------------------------------------------------------
> From: Vasily Gorbik <gor@linux.ibm.com>
> Subject: mm/gup: fix gup_fast with dynamic page table folding
> 
> Currently to make sure that every page table entry is read just once
> gup_fast walks perform READ_ONCE and pass pXd value down to the next
> gup_pXd_range function by value e.g.:
> 
> static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
>                          unsigned int flags, struct page **pages, int *nr)
> ...
>         pudp = pud_offset(&p4d, addr);
> 
> This function passes a reference on that local value copy to pXd_offset,
> and might get the very same pointer in return.  This happens when the
> level is folded (on most arches), and that pointer should not be iterated.
> 
> On s390 due to the fact that each task might have different 5,4 or 3-level
> address translation and hence different levels folded the logic is more
> complex and non-iteratable pointer to a local copy leads to severe
> problems.
> 
> Here is an example of what happens with gup_fast on s390, for a task with
> 3-levels paging, crossing a 2 GB pud boundary:
> 
> // addr = 0x1007ffff000, end = 0x10080001000
> static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
>                          unsigned int flags, struct page **pages, int *nr)
> {
>         unsigned long next;
>         pud_t *pudp;
> 
>         // pud_offset returns &p4d itself (a pointer to a value on stack)
>         pudp = pud_offset(&p4d, addr);
>         do {
>                 // on second iteratation reading "random" stack value
>                 pud_t pud = READ_ONCE(*pudp);
> 
>                 // next = 0x10080000000, due to PUD_SIZE/MASK != PGDIR_SIZE/MASK on s390
>                 next = pud_addr_end(addr, end);
>                 ...
>         } while (pudp++, addr = next, addr != end); // pudp++ iterating over stack
> 
>         return 1;
> }
> 
> This happens since s390 moved to common gup code with commit d1874a0c2805
> ("s390/mm: make the pxd_offset functions more robust") and commit
> 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code").
> s390 tried to mimic static level folding by changing pXd_offset
> primitives to always calculate top level page table offset in pgd_offset
> and just return the value passed when pXd_offset has to act as folded.
> 
> What is crucial for gup_fast and what has been overlooked is that
> PxD_SIZE/MASK and thus pXd_addr_end should also change correspondingly. 
> And the latter is not possible with dynamic folding.
> 
> To fix the issue in addition to pXd values pass original pXdp pointers
> down to gup_pXd_range functions.  And introduce pXd_offset_lockless
> helpers, which take an additional pXd entry value parameter.  This has
> already been discussed in
> https://lkml.kernel.org/r/20190418100218.0a4afd51@mschwideX1
> 
> Link: https://lkml.kernel.org/r/patch.git-943f1e5dcff2.your-ad-here.call-01599856292-ext-8676@work.hours
> Fixes: 1a42010cdc26 ("s390/mm: convert to the generic get_user_pages_fast code")
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: <stable@vger.kernel.org>	[5.2+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/s390/include/asm/pgtable.h |   42 +++++++++++++++++++++---------
>  include/linux/pgtable.h         |   10 +++++++
>  mm/gup.c                        |   18 ++++++------
>  3 files changed, 49 insertions(+), 21 deletions(-)
> 
> --- a/arch/s390/include/asm/pgtable.h~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
> +++ a/arch/s390/include/asm/pgtable.h
> @@ -1260,26 +1260,44 @@ static inline pgd_t *pgd_offset_raw(pgd_
>  
>  #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
>  
> -static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
> +static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long address)
>  {
> -	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
> -		return (p4d_t *) pgd_deref(*pgd) + p4d_index(address);
> -	return (p4d_t *) pgd;
> +	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R1)
> +		return (p4d_t *) pgd_deref(pgd) + p4d_index(address);
> +	return (p4d_t *) pgdp;
>  }
> +#define p4d_offset_lockless p4d_offset_lockless
>  
> -static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
> +static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address)
>  {
> -	if ((p4d_val(*p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
> -		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
> -	return (pud_t *) p4d;
> +	return p4d_offset_lockless(pgdp, *pgdp, address);
> +}
> +
> +static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long address)
> +{
> +	if ((p4d_val(p4d) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R2)
> +		return (pud_t *) p4d_deref(p4d) + pud_index(address);
> +	return (pud_t *) p4dp;
> +}
> +#define pud_offset_lockless pud_offset_lockless
> +
> +static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
> +{
> +	return pud_offset_lockless(p4dp, *p4dp, address);
>  }
>  #define pud_offset pud_offset
>  
> -static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
> +static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud, unsigned long address)
> +{
> +	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
> +		return (pmd_t *) pud_deref(pud) + pmd_index(address);
> +	return (pmd_t *) pudp;
> +}
> +#define pmd_offset_lockless pmd_offset_lockless
> +
> +static inline pmd_t *pmd_offset(pud_t *pudp, unsigned long address)
>  {
> -	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) >= _REGION_ENTRY_TYPE_R3)
> -		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
> -	return (pmd_t *) pud;
> +	return pmd_offset_lockless(pudp, *pudp, address);
>  }
>  #define pmd_offset pmd_offset
>  
> --- a/include/linux/pgtable.h~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
> +++ a/include/linux/pgtable.h
> @@ -1427,6 +1427,16 @@ typedef unsigned int pgtbl_mod_mask;
>  #define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
>  #endif
>  
> +#ifndef p4d_offset_lockless
> +#define p4d_offset_lockless(pgdp, pgd, address) p4d_offset(&(pgd), address)
> +#endif
> +#ifndef pud_offset_lockless
> +#define pud_offset_lockless(p4dp, p4d, address) pud_offset(&(p4d), address)
> +#endif
> +#ifndef pmd_offset_lockless
> +#define pmd_offset_lockless(pudp, pud, address) pmd_offset(&(pud), address)
> +#endif
> +
>  /*
>   * p?d_leaf() - true if this entry is a final mapping to a physical address.
>   * This differs from p?d_huge() by the fact that they are always available (if
> --- a/mm/gup.c~mm-gup-fix-gup_fast-with-dynamic-page-table-folding
> +++ a/mm/gup.c
> @@ -2485,13 +2485,13 @@ static int gup_huge_pgd(pgd_t orig, pgd_
>  	return 1;
>  }
>  
> -static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> +static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned long end,
>  		unsigned int flags, struct page **pages, int *nr)
>  {
>  	unsigned long next;
>  	pmd_t *pmdp;
>  
> -	pmdp = pmd_offset(&pud, addr);
> +	pmdp = pmd_offset_lockless(pudp, pud, addr);
>  	do {
>  		pmd_t pmd = READ_ONCE(*pmdp);
>  
> @@ -2528,13 +2528,13 @@ static int gup_pmd_range(pud_t pud, unsi
>  	return 1;
>  }
>  
> -static int gup_pud_range(p4d_t p4d, unsigned long addr, unsigned long end,
> +static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned long end,
>  			 unsigned int flags, struct page **pages, int *nr)
>  {
>  	unsigned long next;
>  	pud_t *pudp;
>  
> -	pudp = pud_offset(&p4d, addr);
> +	pudp = pud_offset_lockless(p4dp, p4d, addr);
>  	do {
>  		pud_t pud = READ_ONCE(*pudp);
>  
> @@ -2549,20 +2549,20 @@ static int gup_pud_range(p4d_t p4d, unsi
>  			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
>  					 PUD_SHIFT, next, flags, pages, nr))
>  				return 0;
> -		} else if (!gup_pmd_range(pud, addr, next, flags, pages, nr))
> +		} else if (!gup_pmd_range(pudp, pud, addr, next, flags, pages, nr))
>  			return 0;
>  	} while (pudp++, addr = next, addr != end);
>  
>  	return 1;
>  }
>  
> -static int gup_p4d_range(pgd_t pgd, unsigned long addr, unsigned long end,
> +static int gup_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr, unsigned long end,
>  			 unsigned int flags, struct page **pages, int *nr)
>  {
>  	unsigned long next;
>  	p4d_t *p4dp;
>  
> -	p4dp = p4d_offset(&pgd, addr);
> +	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
>  	do {
>  		p4d_t p4d = READ_ONCE(*p4dp);
>  
> @@ -2574,7 +2574,7 @@ static int gup_p4d_range(pgd_t pgd, unsi
>  			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
>  					 P4D_SHIFT, next, flags, pages, nr))
>  				return 0;
> -		} else if (!gup_pud_range(p4d, addr, next, flags, pages, nr))
> +		} else if (!gup_pud_range(p4dp, p4d, addr, next, flags, pages, nr))
>  			return 0;
>  	} while (p4dp++, addr = next, addr != end);
>  
> @@ -2602,7 +2602,7 @@ static void gup_pgd_range(unsigned long
>  			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
>  					 PGDIR_SHIFT, next, flags, pages, nr))
>  				return;
> -		} else if (!gup_p4d_range(pgd, addr, next, flags, pages, nr))
> +		} else if (!gup_p4d_range(pgdp, pgd, addr, next, flags, pages, nr))
>  			return;
>  	} while (pgdp++, addr = next, addr != end);
>  }
> _
> 
> Patches currently in -mm which might be from gor@linux.ibm.com are
> 
> mm-gup-fix-gup_fast-with-dynamic-page-table-folding.patch
> 
