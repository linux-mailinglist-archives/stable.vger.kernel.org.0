Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A0523A39
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiEKQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344686AbiEKQXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 12:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9501F6EB2A
        for <stable@vger.kernel.org>; Wed, 11 May 2022 09:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652286228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzVb9aUm7dZUVaR978hRNFMSk49T/5qOVU61ny8xUgA=;
        b=OQ95w15itRNkBGw006qixieGo1L+0BPfET2tx0aS7Xd/4QsfAA/W5xguRQ8dc6PE1ho4B4
        28RrKKwciBpQ0MzeWVweDmzDPDtUNoC7IJWUvDMQnlAJEqYwAPyosoR/FOlJ7gJqcqfLqf
        iY0A72x6wvqWpxs4yOTE08JOmm6TDUk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-fdgG9MjePDOUqU3xYB709g-1; Wed, 11 May 2022 12:23:47 -0400
X-MC-Unique: fdgG9MjePDOUqU3xYB709g-1
Received: by mail-wm1-f70.google.com with SMTP id u3-20020a05600c210300b0039430c7665eso878137wml.2
        for <stable@vger.kernel.org>; Wed, 11 May 2022 09:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=xzVb9aUm7dZUVaR978hRNFMSk49T/5qOVU61ny8xUgA=;
        b=5yLz/6gz39PYaggAL7/EFt7AeZwN2STt/YBeSBYmFfMr1JGm51MbzvF+ccswdjwGWt
         qtohAtZKPp+73EBM+OY/upwmJCQxI/K6v/Bl5bhOtjfX9Wmjt0Ipebw472wSy5ULDdIG
         GaNj4fqgGCaYyso4mnI+cjv/KowarjrDgOU5XGcrCHcCL3MgI9fnGb4XEeeS0CsqOSO6
         +NvX+Z+VPkJS4seEyPeQRz8vfw+97kC9elYtCYa5hwCXiBKQndPGYEWi8whNzxB/Hnc/
         pq/YBugB+vOzOQkLM+DLJ3460g/JYdsDlqHX9nHiOKocZeoo3RJtZbKTYNpcrGc+NmSw
         V6hw==
X-Gm-Message-State: AOAM533cSHGc5lVyQeMz8/SUTiK0U5hfQIPPQKz9QbfZuxWc2X7R8FEU
        /6Dcd3abDirIHRkKhBSU+NV58b7JIKDBHyWcNQQL3hCgQJpE4/MLz9mf2REJ7QxQH2CbHs9gQJ1
        vpkvPXhRzhesr2/op
X-Received: by 2002:a5d:5143:0:b0:20c:d517:d321 with SMTP id u3-20020a5d5143000000b0020cd517d321mr8643342wrt.468.1652286226351;
        Wed, 11 May 2022 09:23:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdiw9S/CTJAMmC+rAXMnyELFp8v1yYDXpfEZqwvfLhPJcSNLTGFikKsKJjOk6LDmY2et/HwA==
X-Received: by 2002:a5d:5143:0:b0:20c:d517:d321 with SMTP id u3-20020a5d5143000000b0020cd517d321mr8643318wrt.468.1652286226063;
        Wed, 11 May 2022 09:23:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:700:2393:b0f4:ef08:bd51? (p200300cbc70107002393b0f4ef08bd51.dip0.t-ipconnect.de. [2003:cb:c701:700:2393:b0f4:ef08:bd51])
        by smtp.gmail.com with ESMTPSA id o15-20020a5d684f000000b0020c5253d8fesm2109855wrw.74.2022.05.11.09.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 09:23:45 -0700 (PDT)
Message-ID: <a53fb3e9-23fb-9b58-b1c5-ad6e39884330@redhat.com>
Date:   Wed, 11 May 2022 18:23:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] Revert "mm/cma.c: remove redundant cma_mutex lock"
Content-Language: en-US
To:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, minchan@kernel.org
References: <20220509094551.3596244-1-aisheng.dong@nxp.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220509094551.3596244-1-aisheng.dong@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.05.22 11:45, Dong Aisheng wrote:
> This reverts commit a4efc174b382fcdb62e2d90d39e78a274a975e38 which
> introduced a regression issue that when there're multiple processes
> allocating dma memory in parallel by calling dma_alloc_coherent(), it
> may fail sometimes as follows:
> 
> Error log:
> cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> cma: number of available pages:
> 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> 
> When issue happened, we saw there were still 33161 pages (129M) free CMA
> memory and a lot available free slots for 148 pages in CMA bitmap that we
> want to allocate.
> 
> When dumping memory info, we found that there was also ~342M normal memory,
> but only 1352K CMA memory left in buddy system while a lot of pageblocks
> were isolated.
> 
> Memory info log:
> Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> 	    active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> 	    unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> 	    bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> 	36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> 	8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> 
> The root cause of this issue is that since commit a4efc174b382
> ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> memory allocation. It's possible that the memory range process A trying
> to alloc has already been isolated by the allocation of process B during
> memory migration.
> 
> The problem here is that the memory range isolated during one allocation
> by start_isolate_page_range() could be much bigger than the real size we
> want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> 
> Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> all CMA memory may have already been isolated by other processes when
> one trying to allocate memory using dma_alloc_coherent().
> Since current CMA code will only scan one time of whole available CMA
> memory, then dma_alloc_coherent() may easy fail due to contention with
> other processes.
> 
> This patch simply falls back to the original method that using cma_mutex
> to make alloc_contig_range() run sequentially to avoid the issue.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> CC: stable@vger.kernel.org # 5.11+
> Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> ---
> Patch is based on
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-stable
> ---
>  mm/cma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index eaa4b5c920a2..4a978e09547a 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -37,6 +37,7 @@
>  
>  struct cma cma_areas[MAX_CMA_AREAS];
>  unsigned cma_area_count;
> +static DEFINE_MUTEX(cma_mutex);
>  
>  phys_addr_t cma_get_base(const struct cma *cma)
>  {
> @@ -468,9 +469,10 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>  		spin_unlock_irq(&cma->lock);
>  
>  		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
> +		mutex_lock(&cma_mutex);
>  		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
>  				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> -
> +		mutex_unlock(&cma_mutex);
>  		if (ret == 0) {
>  			page = pfn_to_page(pfn);
>  			break;


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

