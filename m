Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432392B66B
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfE0N3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 09:29:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfE0N3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 09:29:21 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RDQpeZ091797
        for <stable@vger.kernel.org>; Mon, 27 May 2019 09:29:20 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srf6nnd7c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 27 May 2019 09:29:19 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <aneesh.kumar@linux.ibm.com>;
        Mon, 27 May 2019 14:29:19 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 14:29:14 +0100
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RDTDmC26280250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 13:29:13 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A13FC6A054;
        Mon, 27 May 2019 13:29:13 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 504106A04D;
        Mon, 27 May 2019 13:29:10 +0000 (GMT)
Received: from [9.102.28.6] (unknown [9.102.28.6])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 13:29:09 +0000 (GMT)
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
To:     Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        stable@vger.kernel.org, npiggin@gmail.com, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, jstancek@redhat.com,
        yang.shi@linux.alibaba.com
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
 <20190527110158.GB2623@hirez.programming.kicks-ass.net>
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date:   Mon, 27 May 2019 18:59:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527110158.GB2623@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052713-0016-0000-0000-000009BA5D22
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011172; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01209325; UDB=6.00635276; IPR=6.00990351;
 MB=3.00027072; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-27 13:29:18
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052713-0017-0000-0000-000043631B7A
Message-Id: <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270095
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/19 4:31 PM, Peter Zijlstra wrote:
> On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org wrote:
>> --- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-force-flush
>> +++ a/mm/mmu_gather.c
>> @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
>>   {
>>   	/*
>>   	 * If there are parallel threads are doing PTE changes on same range
>> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
>> -	 * flush by batching, a thread has stable TLB entry can fail to flush
>> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>> -	 * forcefully if we detect parallel PTE batching threads.
>> +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
>> +	 * flush by batching, one thread may end up seeing inconsistent PTEs
>> +	 * and result in having stale TLB entries.  So flush TLB forcefully
>> +	 * if we detect parallel PTE batching threads.
>> +	 *
>> +	 * However, some syscalls, e.g. munmap(), may free page tables, this
>> +	 * needs force flush everything in the given range. Otherwise this
>> +	 * may result in having stale TLB entries for some architectures,
>> +	 * e.g. aarch64, that could specify flush what level TLB.
>>   	 */
>>   	if (mm_tlb_flush_nested(tlb->mm)) {
>> +		/*
>> +		 * The aarch64 yields better performance with fullmm by
>> +		 * avoiding multiple CPUs spamming TLBI messages at the
>> +		 * same time.
>> +		 *
>> +		 * On x86 non-fullmm doesn't yield significant difference
>> +		 * against fullmm.
>> +		 */
>> +		tlb->fullmm = 1;
>>   		__tlb_reset_range(tlb);
>> -		__tlb_adjust_range(tlb, start, end - start);
>> +		tlb->freed_tables = 1;
>>   	}
>>   
>>   	tlb_flush_mmu(tlb);
> 
> Nick, Aneesh, can we now do this?
> 
> ---
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
> index 4d841369399f..8d28b83914cb 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -881,39 +881,6 @@ void radix__tlb_flush(struct mmu_gather *tlb)
>   	 */
>   	if (tlb->fullmm) {
>   		__flush_all_mm(mm, true);
> -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
> -	} else if (mm_tlb_flush_nested(mm)) {
> -		/*
> -		 * If there is a concurrent invalidation that is clearing ptes,
> -		 * then it's possible this invalidation will miss one of those
> -		 * cleared ptes and miss flushing the TLB. If this invalidate
> -		 * returns before the other one flushes TLBs, that can result
> -		 * in it returning while there are still valid TLBs inside the
> -		 * range to be invalidated.
> -		 *
> -		 * See mm/memory.c:tlb_finish_mmu() for more details.
> -		 *
> -		 * The solution to this is ensure the entire range is always
> -		 * flushed here. The problem for powerpc is that the flushes
> -		 * are page size specific, so this "forced flush" would not
> -		 * do the right thing if there are a mix of page sizes in
> -		 * the range to be invalidated. So use __flush_tlb_range
> -		 * which invalidates all possible page sizes in the range.
> -		 *
> -		 * PWC flush probably is not be required because the core code
> -		 * shouldn't free page tables in this path, but accounting
> -		 * for the possibility makes us a bit more robust.
> -		 *
> -		 * need_flush_all is an uncommon case because page table
> -		 * teardown should be done with exclusive locks held (but
> -		 * after locks are dropped another invalidate could come
> -		 * in), it could be optimized further if necessary.
> -		 */
> -		if (!tlb->need_flush_all)
> -			__radix__flush_tlb_range(mm, start, end, true);
> -		else
> -			radix__flush_all_mm(mm);
> -#endif
>   	} else if ( (psize = radix_get_mmu_psize(page_size)) == -1) {
>   		if (!tlb->need_flush_all)
>   			radix__flush_tlb_mm(mm);
> 


I guess we can revert most of the commit
02390f66bd2362df114a0a0770d80ec33061f6d1. That is the only place we 
flush multiple page sizes? . But should we evaluate the performance 
impact of that fullmm flush on ppc64?


-aneesh

