Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0424A49B8D9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 17:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1584023AbiAYQf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 11:35:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1583781AbiAYQdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 11:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfgMJjJLkuse5GtAchEf6Kwh02fgOfErvUbiicxCd3s=;
        b=h9+t6qa5iEbmghmdYYYZDdHAGtfJ+obFYCEnERWjQ4LlMoXQjaiNWSByx9TlgzrXpx3nFB
        qOc5KSPkmEGT/FHQKgR0JFIgVY0553q+pUbx357dWQHUY6RCsGFhL9Bk5v9L2fcy+kLto0
        asb0wPyzxfeZqwWMXRdpKWW8NpChYmk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-qr61ohqDO4KL0-vwJB-bqA-1; Tue, 25 Jan 2022 11:33:52 -0500
X-MC-Unique: qr61ohqDO4KL0-vwJB-bqA-1
Received: by mail-ed1-f70.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so10979627eds.7
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 08:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=KfgMJjJLkuse5GtAchEf6Kwh02fgOfErvUbiicxCd3s=;
        b=aGj3ixpAZsZyJ/6n+XdGCwIHAOwqn1OvDzzlli5YUget6TU6TZBxoWVL0FPRLBYP25
         BY8QXxk1ohHAV2tCLm0cR9+2zIlnADPp2QhEVS1m/giuUO/C9gZjdBseiRSmDagmwZNZ
         LRR+hJVRuA9WIEJWEiiCb27+3YTXCeQ5C1Y7igTAYJYJcFkjJTlf8dyZD86Kk87PjJDW
         i83F1qJt4UfvI2ZcrJ9KenxLMurnP4ALmOXVF38aQ/nZ+kiTH9BtaaQeF0yg5Xbu3rBc
         HnDwMZdL18Ds9V9mvuOZAbwX5anWUyjKVSDWQhNEYT4NoFf2RPb4KquPCJ3Zy+fvN4+H
         8//A==
X-Gm-Message-State: AOAM530wCZCGHaN8Qv7secIXtbxmB3Nd4+XluR5c1e7t2SmXgN5uHIeD
        AI9PP/RZsgzIHHz9Dq4wWatv1kEgK53p+2l9GExI0PkBqyHBooQBuu5nXxYEeVFqrb72GYMHw1H
        tWiGRxGXVznTqD7wT
X-Received: by 2002:a17:907:3e98:: with SMTP id hs24mr5686288ejc.615.1643128431437;
        Tue, 25 Jan 2022 08:33:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeyf5mAQBARaflP79k/1usfZgp11GmPqAXlH9bD84k9hx/lc6ZGcZS3QYF6aaWGyAbIL/opw==
X-Received: by 2002:a17:907:3e98:: with SMTP id hs24mr5686263ejc.615.1643128431147;
        Tue, 25 Jan 2022 08:33:51 -0800 (PST)
Received: from ?IPV6:2003:cb:c70f:8000:9797:8f:1ed9:7596? (p200300cbc70f80009797008f1ed97596.dip0.t-ipconnect.de. [2003:cb:c70f:8000:9797:8f:1ed9:7596])
        by smtp.gmail.com with ESMTPSA id n25sm4995831ejx.92.2022.01.25.08.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:33:50 -0800 (PST)
Message-ID: <517e1ea1-f826-228b-16a0-da1dc76017cc@redhat.com>
Date:   Tue, 25 Jan 2022 17:33:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, jason.hui.liu@nxp.com, leoyang.li@nxp.com,
        abel.vesa@nxp.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com
References: <20220112131552.3329380-1-aisheng.dong@nxp.com>
 <20220112131552.3329380-3-aisheng.dong@nxp.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 2/2] mm: cma: try next MAX_ORDER_NR_PAGES during retry
In-Reply-To: <20220112131552.3329380-3-aisheng.dong@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.01.22 14:15, Dong Aisheng wrote:
> On an ARMv7 platform with 32M pageblock(MAX_ORDER 14), we observed a

Did you actually intend to talk about pageblocks here (and below)?

I assume you have to be clearer here that you talk about the maximum
allocation granularity, which is usually bigger than actual pageblock size.

> huge number of repeat retries of CMA allocation (1k+) during booting
> when allocating one page for each of 3 mmc instance probe.
> 
> This is caused by CMA now supports cocurrent allocation since commit
> a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock").
> The pageblock or (MAX_ORDER -1) from which we are trying to allocate
> memory may have already been acquired and isolated by others.
> Current cma_alloc() will then retry the next area by the step of
> bitmap_no + mask + 1 which are very likely within the same isolated range
> and fail again. So when the pageblock or MAX_ORDER is big (e.g. 8192),
> keep retrying in a small step become meaningless because it will be known
> to fail at a huge number of times due to the pageblock has been isolated
> by others, especially when allocating only one or two pages.
> 
> Instread of looping in the same pageblock and wasting CPU mips a lot,
> especially for big pageblock system (e.g. 16M or 32M),
> we try the next MAX_ORDER_NR_PAGES directly.
> 
> Doing this way can greatly mitigate the situtation.
> 
> Below is the original error log during booting:
> [    2.004804] cma: cma_alloc(cma (ptrval), count 1, align 0)
> [    2.010318] cma: cma_alloc(cma (ptrval), count 1, align 0)
> [    2.010776] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> [    2.010785] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> [    2.010793] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> [    2.010800] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> [    2.010807] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> [    2.010814] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> .... (+1K retries)
> 
> After fix, the 1200+ reties can be reduced to 0.
> Another test running 8 VPU decoder in parallel shows that 1500+ retries
> dropped to ~145.
> 
> IOW this patch can improve the CMA allocation speed a lot when there're
> enough CMA memory by reducing retries significantly.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> CC: stable@vger.kernel.org # 5.11+
> Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> ---
> v1->v2:
>  * change to align with MAX_ORDER_NR_PAGES instead of pageblock_nr_pages
> ---
>  mm/cma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 1c13a729d274..1251f65e2364 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -500,7 +500,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>  		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
>  					   count, align);
>  		/* try again with a bit different memory target */
> -		start = bitmap_no + mask + 1;
> +		start = ALIGN(bitmap_no + mask + 1,
> +			      MAX_ORDER_NR_PAGES >> cma->order_per_bit);

Mind giving the reader a hint in the code why we went for
MAX_ORDER_NR_PAGES?

What would happen if the CMA granularity is bigger than
MAX_ORDER_NR_PAGES? I'd assume no harm done, as we'd try aligning to 0.

-- 
Thanks,

David / dhildenb

