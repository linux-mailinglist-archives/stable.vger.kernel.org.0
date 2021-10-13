Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABCF42CD27
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 23:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhJMWAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 18:00:25 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:17057
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229631AbhJMWAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 18:00:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyL8cbxR+BJ8L/xASOllYnwOeulk58kNu0wBKKWq+Pu6ddCmfBk1p5OJT6Tyv6+tpFmjpRIrePZp6+nMgk11V7GkkLS1882W2x17Wank8M/DzncC+orj1weyl2oTvEdAHfr937Qzj+l9k4rNXPu7TURrUSjGTkJb0AwqNnNsNWqsMu/ne3JsIjMZt6zWKz9xAmmurDrFIq8dGx9Q8S4iMInBclrM9qYmJpVNbn1uk2ABA8FGNsWJjfDYjLrn8cTs1hlqHQooOJPDLFf24WJGqLGTKvVUTQDSHEz2JgvlO/2PkmP/D6ZV8+yhlRH3WjMgbPmGVcIr2UL6aediyUPkEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6sCWEybN5q8IsLbX+6if2f4DOqNvE2Oc8HkMOZcUqo=;
 b=CRx0Cj7jpjdGn42Trx4sfvpIdJUzDakY8BrrVyqOIsb1jBeHaOxUHlvNTRPVZVRLH8blpobAOu7hmhxGKULBoojlyRTkXGJTzV2SBCgv6k5fSval5IOidwb6iTjMdMRy/xIBehrJ9hee7lmu9ZCp4yqnv2WSU9viax0xlFokjJPkiVICNC9kG3+1LN4as6b4Gv3fmkd2yvKLg9UWhPZSmWaYvVCQGkMJ8ldhbjg7NiI4QoWqgHV1EkqXdxreMLoHmwZgDeeM7ekfZ1D0Ds7qRnf5EfzPMKWFsMVpj38pIGnUOlW5atGd8xvlhu97kxSnZyWbIlzC3Zk2KZ36+FAJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6sCWEybN5q8IsLbX+6if2f4DOqNvE2Oc8HkMOZcUqo=;
 b=iuH8+9v3tB/RFOdnioMFE1XAzW2XLucRiL6XrzLVXjOVcbvwC5QzTRY90+cTJ/lpYcAL0P+CokBmtSsyOGI9vQ1LgjrY5Je7e4pnhgob6866EQiTjmKFXY08laMK0HGn6nkhrbzY5FOXn5ewfgqNvcrOywIz4xGrZpsR51dXPGrey6wyX6ZCgsV9FOJ48Aif2TooahwgQ1nb2Dq1QgS0gYGAXWQn1rpoGf/TyLcYvLE2OGDbXdbIBrGkQFEV/v8npUYn/nlyy/RDZRMePoPJoDQGZ75dAIMjaR1CaZ5INOOZX7vC4FBbB5RQmcIoFydgdK6ey88ECBKmr+Gw9LbQJQ==
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BYAPR12MB2982.namprd12.prod.outlook.com (2603:10b6:a03:a8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Wed, 13 Oct
 2021 21:58:18 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a0ac:922f:1e42:f310]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a0ac:922f:1e42:f310%3]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 21:58:18 +0000
Message-ID: <768394b0-41ad-66e6-feda-75bc3243dcf6@nvidia.com>
Date:   Wed, 13 Oct 2021 14:58:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Content-Language: en-US
To:     Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com, hch@lst.de,
        oleg@redhat.com, kirill@shutemov.name, jack@suse.cz,
        willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com
References: <20211012015244.693594-1-surenb@google.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20211012015244.693594-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::14) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
Received: from [10.2.58.230] (216.228.112.21) by BY5PR03CA0004.namprd03.prod.outlook.com (2603:10b6:a03:1e0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 21:58:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d09040-1030-4f43-04f9-08d98e949082
X-MS-TrafficTypeDiagnostic: BYAPR12MB2982:
X-Microsoft-Antispam-PRVS: <BYAPR12MB298200CD0B62E018F5AEEED1A8B79@BYAPR12MB2982.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXU7RhmkOby3jmVHWLGI6726uff98TSikMOf4rDYzjgjmRx6bJY7OWFNfjW4sHFFnIJ4i3x8bomwWVjjYYjIY4MNF3A7LgJB1ZZdpuPz+dUzE4FaMukDtwRjs1AYfozvtf6sstrPRXTrtmjadl5QRZSMvD05XbOtaCIBPcCMk+FdOIxixoh+PCoKieUcZi9CsY7vP7pvh+8oguSKsFNvRbC7KimAcp73u12zhUx08S6RQOj/6KaadN5+X8/irezubITzFuxqinrwtLCVb3s5hUax/6gZqwsHt4swBxu7cqXHyOMOAWlsGDa6Wkaze1aA6UdjZFNobcdyeCKA7JczO59YT6YK8VdbAbmrLJMo51YOlW4zhocx+0Nw54jDnT/XNyjX1OQS9m87CtJYmVDzlw7Qrt7w7Ia3zXK0o/k4e0viA5hC44lCZPPzc/k+ZAa+GaOOOfCA1/6dxYWu3ve37TuJKH2Ufd61UfD2XNkypL49eQHI5Ve7jYyPjKemdFAzo13npdosBwW7iszZpSQR30Ar1tGA8m2k+P7taMnQbV1R8nP564+JhZcKJyWcQdvQqi7YRDz7XtkUO0Djq0EAz2YETki87liMyxwz7kASJYcj04uuo4DBg+NujwY01xRv0r5HI8hfwxDXVvvy73QHapCURo4s0/SzDLfe5ntqxxMHVgnclTgILuRNnuI8GKpOy72F454ueAfK/4lAkkD63RpDeeV49UE78Qlw0Ng1fHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(53546011)(2616005)(7416002)(86362001)(4326008)(956004)(16576012)(83380400001)(36756003)(6486002)(31686004)(2906002)(186003)(316002)(38100700002)(66946007)(66556008)(66476007)(5660300002)(8936002)(8676002)(31696002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW10WUdCNEhMbnRmaTYrdWhEaU5DR04rWHB6VTlDSUhwS2VQY3pYUVRJRDNH?=
 =?utf-8?B?QldhK3l1Y0xOY2tZWERvVHdWYWFzSExJTEpET25tUzY5ZmtVQ0hzMkNBcC9S?=
 =?utf-8?B?c3J4cnMrL1JMQm5DNmI5Q0xDUkc2SnU3ZWNZWVNTeHBqZjQzUU1BTmdhRjhW?=
 =?utf-8?B?a2REcEpHMVJqclpTRXRSb3N2RnRQY2lqaU9vMjNRcEJyMWxjY0l1MXdXLytP?=
 =?utf-8?B?QkpMS01GMGw4dEFvelBCN0RPNHlqV0pucHduUjE0MlZPc0hTYi9ZV0VleWh5?=
 =?utf-8?B?QURHN21aUDV1VVZ5K0VTSnJtYUJMUTZYQXRLUGlTOTVUOGI5SjZxUklVTHlm?=
 =?utf-8?B?UGdhUjRBZEVEaU9XbDU3b3V6L1V4djZHcVJkL3gzbktUTC9kRU5FRmppelQ3?=
 =?utf-8?B?UnBQL3ZoTEJXeFFTTW90c2xmcmZ3NWw4SzFHMVhncUw4LzJCSFVVV0ZRdHNR?=
 =?utf-8?B?aFdta1RhR1R2aTk1RytXSkI2SkpzSjhleEZlS1ZUNlZYMFZuMTcxejN1OUZI?=
 =?utf-8?B?c0hyUVd4K3VIUThIVGxBcTEzMzVPeThWSTN0S05teHNoaDY2UUk0VU1JUHhY?=
 =?utf-8?B?QjV4RG9hMGxtbElsRHhpVG5QN3FocCtOK2hSbThrNWV6VWdYdVpKaEo0VFpD?=
 =?utf-8?B?aFpiRWtUNlJjWmdYaUxmRHh5RUliZVV6RnBTaFcxMVI1eTBkL3lGV2t2YkV6?=
 =?utf-8?B?d1E1U3JsU1BVL3pJMVgvQjVTOStlcURoM05vczhwS296U3I1UDFRY1VKSU5R?=
 =?utf-8?B?dXN1QjF1S3RYTGwxamFwZzBBTXpFbEN4aTB6UWpZeFJqZjBNTHRtYkY3VjVK?=
 =?utf-8?B?T0pRYkVIR055K1NQbE9oMFYvV3crT3ltQ3lya0tIRXNMYzhEcWJjeEtsdHRV?=
 =?utf-8?B?REQwNnBvTS84b0tDSkh3cWx4bERsZmJTc3huMGJWejd3bWFYSzM5WmRSOVJS?=
 =?utf-8?B?NVhpV3g0OFF6QUVKZ3p3Y0Z5MnVqbXFraFdIUndyOGVuSFBKTGlJT20yRUZF?=
 =?utf-8?B?RXQzeWp4TFNWSWQ1cG5GaEFIZmJZNVl1MStPZU5pZXNSSDlZdDlWU21uUXIz?=
 =?utf-8?B?bVZIWElZQk1kb09SeFpzVHZRYUlDeEt0dklOK3lJYlJvV3ZDRDJxbG93aEV5?=
 =?utf-8?B?NThYOTFTbE5HUDZQa3M1WXZlSGZHSW51eTJxR0dFQjh4cVNqdGlvQUJvUVpN?=
 =?utf-8?B?aHAxM1lxSkZ1ZGRGME0za3lWOUE5eHhiTkpUcWRqbGRheWh2TTZiK29jYjNh?=
 =?utf-8?B?QnJ3b2Q5Zkc0SmgwbFVSR0xTTE84OTNKVTBRdEdXVlRPdE9COFVOZTl1N3Bn?=
 =?utf-8?B?d3hCK3FtNzE5NGFEMWJ6VnoranBhZUcxUS9wSVdKdzJ0TC9yb3dYOVM3cHFx?=
 =?utf-8?B?SWNRMytSMDhvTHRjYzk2ZDRNbHEvaXNqRzlSYSt2RHEwcVFyY0xiOUNZZHhQ?=
 =?utf-8?B?MURJQVdiRlprZ09LaG5rNjUrZHlZbDVYckFRNk1UbVJKMDBCZ1VzTTZpZTQy?=
 =?utf-8?B?NFMyOWpRTTdwWDM0QnllaFV3YTdpU3ZzVkhySUJKZ2RwOHR1NWFjNGNob3FQ?=
 =?utf-8?B?aXlTcW9jTm5ONkNMMHRxTG5vTEIyZW04Tk1PL2xEc3FOVi84NnFHWSsyQW9h?=
 =?utf-8?B?MmMvVFVxR0dyeWlVaS9oY0hVUk8vU1gyTmNwSjlJQmYvNG5DMlcxTkg5V1di?=
 =?utf-8?B?NGZ3YUZ5SlUxYmdQOExVa0t1NlcxMTdsNWlLQlAxTkJacVdzdjBnQWd5L1FO?=
 =?utf-8?Q?64b1/02+RbZVAB36FWj0vMmcfLCXGtcdRWyxuNh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d09040-1030-4f43-04f9-08d98e949082
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 21:58:18.3366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3ki+H/WLZPHE2WLoIIRD0EEJd6VbYoPSsl7vWz2fsPTbPakgszZGUXg0BVC4LxF+CCtqhIfiJIXEcT/5KSdAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2982
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 18:52, Suren Baghdasaryan wrote:
...
> [surenb: backport notes
>          Since gup_pgd_range does not exist, made appropriate changes on
>          the the gup_huge_pgd, gup_huge_pd and gup_pud_range calls instead.
> 	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_huge_pgd,
>          gup_huge_pd and gup_pud_range.
> 	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
> 	the earlier kernels.]
> 

This backport looks accurate. At first I thought you missed the comment-only
change to i915_gem_userptr.c, and then I noticed that the older branch still
uses non-fast gup, so not applicable there after all. :)

Agree with others that this whole area is still shaky, but it does sound as if
this will help.


Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> Reported-by: Jann Horn <jannh@google.com>
> Tested-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Kirill Shutemov <kirill@shutemov.name>
> Acked-by: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [surenb: backport to 4.4 kernel]
> Cc: stable@vger.kernel.org # 4.4.x
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>   mm/gup.c         | 48 ++++++++++++++++++++++++++++++++++++++++--------
>   mm/huge_memory.c |  7 +++----
>   2 files changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 4c5857889e9d..c80cdc408228 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -59,13 +59,22 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
>   }
>   
>   /*
> - * FOLL_FORCE can write to even unwritable pte's, but only
> - * after we've gone through a COW cycle and they are dirty.
> + * FOLL_FORCE or a forced COW break can write even to unwritable pte's,
> + * but only after we've gone through a COW cycle and they are dirty.
>    */
>   static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
>   {
> -	return pte_write(pte) ||
> -		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
> +	return pte_write(pte) || ((flags & FOLL_COW) && pte_dirty(pte));
> +}
> +
> +/*
> + * A (separate) COW fault might break the page the other way and
> + * get_user_pages() would return the page from what is now the wrong
> + * VM. So we need to force a COW break at GUP time even for reads.
> + */
> +static inline bool should_force_cow_break(struct vm_area_struct *vma, unsigned int flags)
> +{
> +	return is_cow_mapping(vma->vm_flags) && (flags & FOLL_GET);
>   }
>   
>   static struct page *follow_page_pte(struct vm_area_struct *vma,
> @@ -509,12 +518,18 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>   			if (!vma || check_vma_flags(vma, gup_flags))
>   				return i ? : -EFAULT;
>   			if (is_vm_hugetlb_page(vma)) {
> +				if (should_force_cow_break(vma, foll_flags))
> +					foll_flags |= FOLL_WRITE;
>   				i = follow_hugetlb_page(mm, vma, pages, vmas,
>   						&start, &nr_pages, i,
> -						gup_flags);
> +						foll_flags);
>   				continue;
>   			}
>   		}
> +
> +		if (should_force_cow_break(vma, foll_flags))
> +			foll_flags |= FOLL_WRITE;
> +
>   retry:
>   		/*
>   		 * If we have a pending SIGKILL, don't keep faulting pages and
> @@ -1346,6 +1361,10 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
>   /*
>    * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
>    * the regular GUP. It will only return non-negative values.
> + *
> + * Careful, careful! COW breaking can go either way, so a non-write
> + * access can get ambiguous page results. If you call this function without
> + * 'write' set, you'd better be sure that you're ok with that ambiguity.
>    */
>   int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   			  struct page **pages)
> @@ -1375,6 +1394,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   	 *
>   	 * We do not adopt an rcu_read_lock(.) here as we also want to
>   	 * block IPIs that come from THPs splitting.
> +	 *
> +	 * NOTE! We allow read-only gup_fast() here, but you'd better be
> +	 * careful about possible COW pages. You'll get _a_ COW page, but
> +	 * not necessarily the one you intended to get depending on what
> +	 * COW event happens after this. COW may break the page copy in a
> +	 * random direction.
>   	 */
>   
>   	local_irq_save(flags);
> @@ -1385,15 +1410,22 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   		next = pgd_addr_end(addr, end);
>   		if (pgd_none(pgd))
>   			break;
> +		/*
> +		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
> +		 * because get_user_pages() may need to cause an early COW in
> +		 * order to avoid confusing the normal COW routines. So only
> +		 * targets that are already writable are safe to do by just
> +		 * looking at the page tables.
> +		 */
>   		if (unlikely(pgd_huge(pgd))) {
> -			if (!gup_huge_pgd(pgd, pgdp, addr, next, write,
> +			if (!gup_huge_pgd(pgd, pgdp, addr, next, 1,
>   					  pages, &nr))
>   				break;
>   		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
>   			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
> -					 PGDIR_SHIFT, next, write, pages, &nr))
> +					 PGDIR_SHIFT, next, 1, pages, &nr))
>   				break;
> -		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
> +		} else if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
>   			break;
>   	} while (pgdp++, addr = next, addr != end);
>   	local_irq_restore(flags);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6404e4fcb4ed..fae45c56e2ee 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1268,13 +1268,12 @@ out_unlock:
>   }
>   
>   /*
> - * FOLL_FORCE can write to even unwritable pmd's, but only
> - * after we've gone through a COW cycle and they are dirty.
> + * FOLL_FORCE or a forced COW break can write even to unwritable pmd's,
> + * but only after we've gone through a COW cycle and they are dirty.
>    */
>   static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
>   {
> -	return pmd_write(pmd) ||
> -	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
> +	return pmd_write(pmd) || ((flags & FOLL_COW) && pmd_dirty(pmd));
>   }
>   
>   struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
> 

