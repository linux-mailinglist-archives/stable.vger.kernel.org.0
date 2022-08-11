Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03BB5906A7
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 21:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiHKS73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 14:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiHKS72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 14:59:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B8B9FAB3;
        Thu, 11 Aug 2022 11:59:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BHs3bB018975;
        Thu, 11 Aug 2022 18:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=IkUHLqgV90LD23QhhowJrEhRr4t1doEe7JbVgYwvVh4=;
 b=XqZMxjhkzpyoHZR3sdG2wwBg+xaEbwIgg7/AGSBAFq2d5qygyWoNWQLAGywBgTdqh387
 DASoO53SuzM2I1DS1Ub9cO5hXqsRkp4lYakUJIz2FRS5Ouih/uXFR1RecauUQtZTc2GS
 SMAm/KUXbMx7MG+DcUv2lJS8Qid0e1CFkLBbB/anI/f+j8S/bRuiiXdK/9nLrp3j037T
 LCpxbU6oi/3K3iZ6omFyvCrmSmhE7E5DuBAVkbVDWpYAURffeXZHv2sA9XHejrif2dBd
 0AlIY56g/jNsEuWyHAllHMVf8xb9ucyWycAcpvXBeYOdok6MKvWjqou/Qu8jFJJKc4+T AA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbnr1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:59:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BIFERo019217;
        Thu, 11 Aug 2022 18:59:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkc17u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:59:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkQcMgEelOOmyk9IX4709scR2HhvXtRIOfQfW6EHfL5lyNMJIsllr5w83TcRqczH+u/QnCYTyvNS9ve33WrdDaRa9YNUKUd9yc7LyWPwWBqcU0FcD9qHjc+GD7WKzPS+xQREzmeFs7HQqbFXnRqQqTV3XlBkY41qHoCqlAf5NGy6Gzd17Bw1k51dEY8uGcQL8wXCyPNtsWU2QCvfAr/kXwKBeda5QZHiLtmgcnmgncONRztgflniZ/GV/0486Za5eeNptjiuvBkLuijKy7d0r3RkFRP/N8onGRYqIlLBjReJEzvfTa7WMG53ytHCZUVg+Lebbl6Q7BB+kpX9KGBBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkUHLqgV90LD23QhhowJrEhRr4t1doEe7JbVgYwvVh4=;
 b=lrbhtFFLUhu3qz8BwtT9WvdRdgv28XgNYCv13qgpg9XYyjSSK4sMPr+8D1Hy3bnW2wHZoV80hz+VdAFqXyPPAaV+bRjNtRWS+9IGaAbiswM0X/73Zi/Ud1k25F80xnGMWPoRedklb+PEF9DWTLiqzMGsGnvIuc19FkrljkQeUcj+QJ5TJ2DZNeEhwP78lBKxyfhPNusZRz1KnUyqFBui/P7XRI7Q5sdFlZvtzB8pksoEfKBQCxzTmtdes1hrkh224mWyLGfhEwV8dP/Co8poWIbvwrTRqO4cwvCMgLz2yGLhn7JDpk8zt9W+kYVQCrwbyddQQtL3nSycJmtj+oh2yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkUHLqgV90LD23QhhowJrEhRr4t1doEe7JbVgYwvVh4=;
 b=uN3LkqacedW5tS1uWEtJtyQK0oKW49E0JY/XengO2Q5mf1z1Z2zMD/a57e2gRCIcg44iypBtXSrNUDrxSYiw9AA9fBNtCvL3KQvClULyKXNekvGuwJvlLwkrNz2Q3/TNYjCzMq5nYrL0a80aWG82g1aEbyeshm96xi9KPhMk8/I=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5629.namprd10.prod.outlook.com (2603:10b6:a03:3e2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 11 Aug
 2022 18:59:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 18:59:13 +0000
Date:   Thu, 11 Aug 2022 11:59:09 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <YvVRfSYsPOraTo6o@monkey>
References: <20220811103435.188481-1-david@redhat.com>
 <20220811103435.188481-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811103435.188481-3-david@redhat.com>
X-ClientProxiedBy: MW2PR16CA0034.namprd16.prod.outlook.com (2603:10b6:907::47)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c789364-019f-4ef6-7b95-08da7bcb94a8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5629:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJkH2LyQH8jQJlToZQ/xrM0qbdZfyt+i9aVn2wd2aQBJASxCORibIpnmiKVOm8LQWSQy6y65XEQ5Kh2EKh2gyjMgh3li8ARAi8+XO8xQi06KaJ8bcfCbh8jLYRZV2Qe0RnCwfBahcxIJ3OSEh26bRiN2ucCkhbM6VDAP1JiPhAeWYRKya6Qalbju61U5kOZCCWKp40RmIdx6Rp084eHXGq9QeEvN0oqA+Jv9JKU6qqqve+0i9I1WK38lvkPxphdHRHrf8Ony6F0xvfmZqLFqSxtHtXh6IG7ZJWZHxtBHefldy42xQdkcPfDNCkFCwTEmAtAyIrPE8WjpHeNx1JtnKejOYs+cWeO3Utgur2J7DcBbd0FYhvS2BvAewvrq/Nj1FNpVn8pLH6n4Lng7spti04ffMC5P7xsMyGeAQSu9Uki4lpEcEUdBMv9WN9fZzUYzvkjjnC9zRGnod1WV5lRwtXmXNomXPxAhSlucFnKRx3mtg92fmNm+T37E2RNMhgvYGsm8YYt72+1S6zAfur+a2rE6bXrLHeNCHqBy5zyWAtuqvhWQ49OuK6yahmZGo+BL8I7vHcedN6fcNkjuMz2uXNRkeLrMjDlYkp4cll4Av292F6tETNQ/W+wVjpp5bNVT0/TYF8pc0o767jG2drirpQnfetDQTuXsLaiDW8eePwZw0zL4xepJlnbu9gU/UmiooaOSHTgqThA+7dpJXb57xCQN+YTzeenxwUGb36lCoNDpjJRRqbBCf98jDI1lr2Y+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(346002)(366004)(396003)(376002)(33716001)(83380400001)(186003)(86362001)(6916009)(38100700002)(6486002)(478600001)(2906002)(316002)(8936002)(4326008)(44832011)(5660300002)(6506007)(9686003)(26005)(6512007)(8676002)(53546011)(66556008)(66476007)(41300700001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AfwujUO4OqBgpnyB+8NO9FWO4Qp7HMv9vf76JYfboWDZwlOsxuAyjlQb6PKa?=
 =?us-ascii?Q?tyO/HyOJ75unsS0c5anb2HfJn/Gsvwc288nVBn8xou3Q+d6+ux9bnPMUrP/V?=
 =?us-ascii?Q?h37dW+hwnZqp2hP4UQyhOilH/7ryi+iJwe13xERdjFACofR7YDtmmIFeKLh9?=
 =?us-ascii?Q?+EZw06KHPWXz78MUh6lu3EwLVcOm1Vd5r4rS5Nx3/N4GNYBKKLRJXmAZnmhs?=
 =?us-ascii?Q?ahhHkHq2EAI1pE/r4OcKApAu2XWjIdccpr/Mxd8T9DihgnUn0IRt6gst3elI?=
 =?us-ascii?Q?qJEf31fTVLPQb8A/YaPoSrAjMout3bJ42abBfNCnnfrZrfW4Fv54izV1wqSb?=
 =?us-ascii?Q?q3T1aKl++orHd5fGJWxuftMOENStGtoO2Qqvgfvo0+hY3IQqdQxR3YgXSbaB?=
 =?us-ascii?Q?95FybXiymxuIFhKZdfBeQ4/WnDlZD4bEmN8HO26cBbuVReOEpTaDJlaVasvW?=
 =?us-ascii?Q?tWKMrKRK/Sn63daUz59f5SoZ6JTqn4WYl8IRJ3ienbH9EFVPlSsPqZEaW8oX?=
 =?us-ascii?Q?dSrSVp7t0LiIXonxurqONdWk7tHbG0NoyDYwNe3ze9r4RxlTkaZ4geiOY2aB?=
 =?us-ascii?Q?nkVfnl7Oyv8RbLpzqwe48Dt9jzGUaqoC8/lFuddDEF+HC20Df8UDAA+pzLHo?=
 =?us-ascii?Q?Y7YdRZ5ihnV097O42iN64QJrymItsk7b5SBIZDqKwUSkNFCkZF8NSmGbcs7v?=
 =?us-ascii?Q?SEXKTblIvPUXzV1JrtNHv2ee+mCGE4xGYEJoQEJ0Qpo0hts6YRy7KzMOD/is?=
 =?us-ascii?Q?5R+bed5Mwa+cUFMKHrKHsp6DPfFIyfoSm5Jj0UTbVshbAVOjv7l10N1QiPTt?=
 =?us-ascii?Q?cjDDmwe1tdcGAGH8eCGeZdEwEfh+Vs1q4bvPGrLCBJwJrD6VMoTFbnk81nDt?=
 =?us-ascii?Q?sBpOrCLXxGjcMOW7DDznx61PFApDDnsl7wnBzqgy9mUFOgcU6pq4n9hyF4wh?=
 =?us-ascii?Q?EHj1+t2e+bdej8UjBeSg+6VxpLWczV1mS/WJ/rzZvRfD/A3LLQYQxaffDPls?=
 =?us-ascii?Q?jEgJCqNS/zLwwfTSkjdvYHpsI/jrtjB5PSrolUfLHAp4P1LvMo9Cz7tOGeup?=
 =?us-ascii?Q?YLQ16W2aTutAfRPivEOQYP4bI9QH1D+n/e0D0oj+1qIuB8QaMCXfUdTgzXJE?=
 =?us-ascii?Q?oXsxaMiVKj6nESFj/znwaUZtM6926uXKZkSi/Z/ev8sCfXltcS++gJPjToqO?=
 =?us-ascii?Q?0khNtd3HWHeWpu4m3QR3pcM7hy4NyWV6ycBKIJdgzzFyIkzjV4AiZvwI6J6j?=
 =?us-ascii?Q?s06rDjbfctKC/FTRhMeqS8l3svvlrZlj1NvZVi392KXE+in79+H3ohQHlliw?=
 =?us-ascii?Q?E+d8cw7tX/m6OC3GYfa1zDmH4Q597jBXFc5i3kkcXitHCE8iyyjeWIlQ9bD7?=
 =?us-ascii?Q?Cz2Vgk7Rjzce7SfpblMy5qYuo0Pf14PD4kv27NvTrVwVwSKcoOfMRYu+88dk?=
 =?us-ascii?Q?tXOQpZsoJmgJcDgUbDy5v08+d/0IGFojx+9Bv5JYUNskNc/ztzwRCCu0Icm+?=
 =?us-ascii?Q?jF+bJAOvk/wBBqbxpL/kQH0+PT9Nnd7zlWRW6PhK3t/hbWnloNz2qUmMRp3g?=
 =?us-ascii?Q?4e4zT7QhcfrOsAn9QRd5eUlxid4vhoE/sj22HebhJpYGS+KoidlO3m0Bu24k?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c789364-019f-4ef6-7b95-08da7bcb94a8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 18:59:12.9930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czmLSoAZ3kiPk6ir0Q4+WM5rrJpG96zvif4m8IujMuLglOYdkr4nk9ZuGmdp9uC3KBSBK3Tawj+8MICEPay+TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_13,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110060
X-Proofpoint-GUID: qPUS7PJd6RfKFqrgU4EIc519dg9VryhG
X-Proofpoint-ORIG-GUID: qPUS7PJd6RfKFqrgU4EIc519dg9VryhG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11/22 12:34, David Hildenbrand wrote:
> If we ever get a write-fault on a write-protected page in a shared mapping,
> we'd be in trouble (again). Instead, we can simply map the page writable.
> 
<snip>
> 
> Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> unregistering and consequently keeps the PTE writeprotected. Reason for
> this is to avoid the additional overhead when unregistering. Note
> that this is the case also for !hugetlb and that we will end up with
> writable PTEs that still have the uffd-wp PTE bit set once we return
> from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
> seems to be a generic thing -- wp_page_reuse() also doesn't clear it.
> 
> VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
> indicates that MAP_SHARED handling was at least envisioned, but could never
> have worked as expected.
> 
> While at it, make sure that we never end up in hugetlb_wp() on write
> faults without VM_WRITE, because we don't support maybe_mkwrite()
> semantics as commonly used in the !hugetlb case -- for example, in
> wp_page_reuse().

Nit,
to me 'make sure that we never end up in hugetlb_wp()' implies that
we would check for condition in callers as opposed to first thing in
hugetlb_wp().  However, I am OK with description as it.

> Note that there is no need to do any kind of reservation in hugetlb_fault()
> in this case ... because we already have a hugetlb page mapped R/O
> that we will simply map writable and we are not dealing with COW/unsharing.

Note that we are not really doing any reservation adjustment in
hugetlb_fault().  That code does pre-allocation of reservation data in
case we might need it in hugetlb_wp.  Since hugetlb_wp will certainly
not do an allocation in this case, we do not even need to do the
preallocation here.  This change is more of an optimization.  I am still
happy with it.

> 
> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
> Cc: <stable@vger.kernel.org> # v5.19
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/hugetlb.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)

Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0aee2f3ae15c..2480ba627aa5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5241,6 +5241,21 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  	VM_BUG_ON(unshare && (flags & FOLL_WRITE));
>  	VM_BUG_ON(!unshare && !(flags & FOLL_WRITE));
>  
> +	/*
> +	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
> +	 * PTE mapped R/O such as maybe_mkwrite() would do.
> +	 */
> +	if (WARN_ON_ONCE(!unshare && !(vma->vm_flags & VM_WRITE)))
> +		return VM_FAULT_SIGSEGV;
> +
> +	/* Let's take out MAP_SHARED mappings first. */
> +	if (vma->vm_flags & VM_MAYSHARE) {
> +		if (unlikely(unshare))
> +			return 0;
> +		set_huge_ptep_writable(vma, haddr, ptep);
> +		return 0;
> +	}
> +
>  	pte = huge_ptep_get(ptep);
>  	old_page = pte_page(pte);
>  
> @@ -5781,12 +5796,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 * If we are going to COW/unshare the mapping later, we examine the
>  	 * pending reservations for this page now. This will ensure that any
>  	 * allocations necessary to record that reservation occur outside the
> -	 * spinlock. For private mappings, we also lookup the pagecache
> -	 * page now as it is used to determine if a reservation has been
> -	 * consumed.
> +	 * spinlock. Also lookup the pagecache page now as it is used to
> +	 * determine if a reservation has been consumed.
>  	 */
>  	if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
> -	    !huge_pte_write(entry)) {
> +	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(entry)) {
>  		if (vma_needs_reservation(h, vma, haddr) < 0) {
>  			ret = VM_FAULT_OOM;
>  			goto out_mutex;
> @@ -5794,9 +5808,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		/* Just decrements count, does not deallocate */
>  		vma_end_reservation(h, vma, haddr);
>  
> -		if (!(vma->vm_flags & VM_MAYSHARE))
> -			pagecache_page = hugetlbfs_pagecache_page(h,
> -								vma, haddr);
> +		pagecache_page = hugetlbfs_pagecache_page(h, vma, haddr);
>  	}
>  
>  	ptl = huge_pte_lock(h, mm, ptep);
> -- 
> 2.35.3
> 
> 
