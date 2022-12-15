Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10CE64DC9B
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLON6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLON62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:58:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A6A29CA9;
        Thu, 15 Dec 2022 05:58:27 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDmow9005280;
        Thu, 15 Dec 2022 13:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=oROM+X1qB958UmYYnNE4ilPhNkttLPi0xP6AeYrJb0k=;
 b=KxQLUpetf4JhvLd9fMPGDKO4NLxcvAYngJ4Hm0UY2NWla+ZEsa2/2tKcT6K98iVHtVUb
 aZQ2SlZm5F+HxGQ9nS8CVDshYHOHZF3iemhauSkKUR2sVcXvfhLMgAtvx1HZ8W92Gwbg
 Y6HpE++csNBMdN9GGxVtnSfZiqXUuj52z0Qy9xFuXxOCW5bIMxkkzhhHrS4JHEwQW9YH
 nLo9/2ZdEH5qmGBU+YX5zyvWrUg1zFy1hrfEwGYuTNCNfiMrra+AaVcH/BfKGToaFX5t
 Xu9gJTrowQQXOkivB+wnrytsYTqPZJg0KiEm/LAdNBoYKEgLc1hmHg4flM8UhTOK21Vt hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4syg5nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:58:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFDpMQk018167;
        Thu, 15 Dec 2022 13:58:11 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4syg5mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:58:11 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDAHCa006111;
        Thu, 15 Dec 2022 13:58:09 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3meyfdxd5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:58:09 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFDw8gf29622622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 13:58:08 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B8E758063;
        Thu, 15 Dec 2022 13:58:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3093D58066;
        Thu, 15 Dec 2022 13:58:02 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.98.149])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 13:58:01 +0000 (GMT)
X-Mailer: emacs 29.0.60 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Michal Hocko <mhocko@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
In-Reply-To: <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
 <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
Date:   Thu, 15 Dec 2022 19:27:59 +0530
Message-ID: <87o7s46a6w.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: euLci8W3q1Ze6AsAjBQbsDEhvLcpujM4
X-Proofpoint-GUID: AHMJAgOk14S-qzX1gvpXOnV9YQiW727Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_07,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Hocko <mhocko@suse.com> writes:

> On Wed 14-12-22 17:21:10, Mathieu Desnoyers wrote:
>> When encountering any vma in the range with policy other than MPOL_BIND
>> or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
>> on the policy just allocated with mpol_dup().
>> 
>> This allows arbitrary users to leak kernel memory.
>> 
>> Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> Cc: Ben Widawsky <ben.widawsky@intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Feng Tang <feng.tang@intel.com>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Huang Ying <ying.huang@intel.com>
>> Cc: <linux-api@vger.kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: stable@vger.kernel.org # 5.17+
>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks for catching this!
>
> Btw. looking at the code again it seems rather pointless to duplicate
> the policy just to throw it away anyway. A slightly bigger diff but this
> looks more reasonable to me. What do you think? I can also send it as a
> clean up on top of your fix.
> ---
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 61aa9aedb728..918cdc8a7f0c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>  {
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
> -	struct mempolicy *new;
> +	struct mempolicy *new. *old;
>  	unsigned long vmstart;
>  	unsigned long vmend;
>  	unsigned long end;
> @@ -1521,30 +1521,28 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>  		return 0;
>  	mmap_write_lock(mm);
>  	for_each_vma_range(vmi, vma, end) {
> -		vmstart = max(start, vma->vm_start);
> -		vmend   = min(end, vma->vm_end);
> -		new = mpol_dup(vma_policy(vma));
> -		if (IS_ERR(new)) {
> -			err = PTR_ERR(new);
> -			break;
> -		}
> -		/*
> -		 * Only update home node if there is an existing vma policy
> -		 */
> -		if (!new)
> -			continue;
> -
>  		/*
>  		 * If any vma in the range got policy other than MPOL_BIND
>  		 * or MPOL_PREFERRED_MANY we return error. We don't reset
>  		 * the home node for vmas we already updated before.
>  		 */
> -		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
> +		old = vma_policy(vma);
> +		if (!old)
> +			continue;
> +		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
>  			err = -EOPNOTSUPP;
>  			break;
>  		}
>  
> +		new = mpol_dup(vma_policy(vma));

		new = mpol_dup(old);

> +		if (IS_ERR(new)) {
> +			err = PTR_ERR(new);
> +			break;
> +		}
> +
>  		new->home_node = home_node;
> +		vmstart = max(start, vma->vm_start);
> +		vmend   = min(end, vma->vm_end);
>  		err = mbind_range(mm, vmstart, vmend, new);
>  		mpol_put(new);
>  		if (err)
> -- 
> Michal Hocko
> SUSE Labs
