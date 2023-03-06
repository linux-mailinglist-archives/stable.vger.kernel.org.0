Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9686C6AB6BE
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCFHCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFHCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:02:19 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED652116;
        Sun,  5 Mar 2023 23:02:17 -0800 (PST)
Received: from dggpemm500001.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PVTvj4LMkzSkX0;
        Mon,  6 Mar 2023 14:59:13 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 15:01:39 +0800
Message-ID: <5b44cbd0-c3c7-aa1d-5fbf-ef752c8f4343@huawei.com>
Date:   Mon, 6 Mar 2023 15:01:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: +
 mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch
 added to mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <willy@infradead.org>,
        <vishal.moola@gmail.com>, <stable@vger.kernel.org>, <sj@kernel.org>
References: <20230304195241.6DD11C433EF@smtp.kernel.org>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20230304195241.6DD11C433EF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/3/5 3:52, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: SeongJae Park <sj@kernel.org>
> Subject: mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
> Date: Sat, 4 Mar 2023 19:39:49 +0000
> 
> damon_pa_mark_accessed_or_deactivate() is accessing a folio via
> folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.
> 
> Link: https://lkml.kernel.org/r/20230304193949.296391-3-sj@kernel.org
> Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")

This is accepted in v6.3-rc1,

> Signed-off-by: SeongJae Park <sj@kernel.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Cc: <stable@vger.kernel.org>	[6.2.x]
so no need to stable ?

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> 
> --- a/mm/damon/paddr.c~mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate
> +++ a/mm/damon/paddr.c
> @@ -280,8 +280,8 @@ static inline unsigned long damon_pa_mar
>   			folio_mark_accessed(folio);
>   		else
>   			folio_deactivate(folio);
> -		folio_put(folio);
>   		applied += folio_nr_pages(folio);
> +		folio_put(folio);
>   	}
>   	return applied * PAGE_SIZE;
>   }
> _
> 
> Patches currently in -mm which might be from sj@kernel.org are
> 
> mm-damon-paddr-fix-folio_size-call-after-folio_put-in-damon_pa_young.patch
> mm-damon-paddr-fix-folio_nr_pages-after-folio_put-in-damon_pa_mark_accessed_or_deactivate.patch
> 
