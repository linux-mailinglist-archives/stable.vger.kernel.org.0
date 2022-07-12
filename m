Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DD571246
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 08:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGLGeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 02:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGLGeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 02:34:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7038726560
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 23:34:13 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C5hoC2009912;
        Tue, 12 Jul 2022 06:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=pGvkkXFFduigXu7unC8JSxXg7ldqQAFnpk8mthY2i94=;
 b=R03GlkpDr51nWK08Gkbr01xbovcfhcyFDG1qhfeFRJ5Ykya27Q8ed/ixjXa2ZYBqCpYe
 io+65Vknn6vc+Nb+ZhuupHt3f4ZQA85BgxACtWiWml2tEwzMre3kMqrpTzbmOQBvjz75
 ZLPTNght4keydwJb6rQfpGbLnzAfdC9WOp4NVUZGG7ZeNo1qkLgjCshiGmfNnYKoW32B
 l4JcSYj2C8q9iQu8JhbjnsqRtV7oaH6YcdcCmBn+w1ODYZbX9ryOZOrzbzP7td89QRoH
 yV/WHHpg16LaUc5BSTuLTDpD9RhEm/j9HKXpLkkV+7IYjsgQofyX3KKEqkwHuvDlqRKF aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h932gh2tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 06:34:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26C64Ub0029872;
        Tue, 12 Jul 2022 06:34:05 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h932gh2st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 06:34:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26C6KJ1b002069;
        Tue, 12 Jul 2022 06:34:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3h71a8u0wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 06:34:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26C6Y1WZ16449970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 06:34:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A463AAE045;
        Tue, 12 Jul 2022 06:34:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0B00AE055;
        Tue, 12 Jul 2022 06:34:00 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.144.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 12 Jul 2022 06:34:00 +0000 (GMT)
Date:   Tue, 12 Jul 2022 09:33:58 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: provide properly masked address for
 huge-pages
Message-ID: <Ys0V1gm/VNGgb5Ei@linux.ibm.com>
References: <20220711165906.2682-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711165906.2682-1-namit@vmware.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fAwP9Qnr1y0PLchh5SvtiKc2FGszaA6Q
X-Proofpoint-ORIG-GUID: ISeBXPdzIfiIoJXZ8jTLMwh6AG7DFPFj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_03,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 09:59:06AM -0700, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Commit 824ddc601adc ("userfaultfd: provide unmasked address on
> page-fault") was introduced to fix an old bug, in which the offset in
> the address of a page-fault was masked. Concerns were raised - although
> were never backed by actual code - that some userspace code might break
> because the bug has been around for quite a while. To address these
> concerns a new flag was introduced, and only when this flag is set by
> the user, userfaultfd provides the exact address of the page-fault.
> 
> The commit however had a bug, and if the flag is unset, the offset was
> always masked based on a base-page granularity. Yet, for huge-pages, the
> behavior prior to the commit was that the address is masked to the
> huge-page granulrity.
> 
> While there are no reports on real breakage, fix this issue. If the flag
> is unset, use the address with the masking that was done before.
> 
> Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
> Reported-by: James Houghton <jthoughton@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  fs/userfaultfd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index e943370107d0..de86f5b2859f 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -192,17 +192,19 @@ static inline void msg_init(struct uffd_msg *msg)
>  }
>  
>  static inline struct uffd_msg userfault_msg(unsigned long address,
> +					    unsigned long real_address,
>  					    unsigned int flags,
>  					    unsigned long reason,
>  					    unsigned int features)
>  {
>  	struct uffd_msg msg;
> +
>  	msg_init(&msg);
>  	msg.event = UFFD_EVENT_PAGEFAULT;
>  
> -	if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
> -		address &= PAGE_MASK;
> -	msg.arg.pagefault.address = address;
> +	msg.arg.pagefault.address = (features & UFFD_FEATURE_EXACT_ADDRESS) ?
> +				    real_address : address;
> +
>  	/*
>  	 * These flags indicate why the userfault occurred:
>  	 * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
> @@ -488,8 +490,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>  
>  	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
>  	uwq.wq.private = current;
> -	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
> -			ctx->features);
> +	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
> +				reason, ctx->features);
>  	uwq.ctx = ctx;
>  	uwq.waken = false;
>  
> -- 
> 2.25.1
> 

-- 
Sincerely yours,
Mike.
