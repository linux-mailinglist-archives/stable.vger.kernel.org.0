Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217694DC457
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiCQK5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiCQK5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C10F719E3BC
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 03:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647514545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oI5WSIRwZsbGZlVeSYcyiheGQZ2AXv4KqUCkckxJqyo=;
        b=e4io+uFfSGnnXaHgl55a8cINxXuwOPWt0KJf9vThpjOxtHf/SwV3afyxlyKDYQFz4oi2k6
        xL950l86K09R5fGA45uK5JaCbWNxGLt6bumIsO9jYO1wTJ4LllaL4SgWrF5k94xcM+GAZH
        pSpxKzGpwWb/xEhFktFGF5W35kY6AmM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-Ia03Qqw1Po-W9UIRQzKxjg-1; Thu, 17 Mar 2022 06:55:42 -0400
X-MC-Unique: Ia03Qqw1Po-W9UIRQzKxjg-1
Received: by mail-wm1-f71.google.com with SMTP id n62-20020a1ca441000000b0038124c99ebcso1488821wme.9
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 03:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=oI5WSIRwZsbGZlVeSYcyiheGQZ2AXv4KqUCkckxJqyo=;
        b=z+JM9yPJSZxk6q2D4AgYGPpmowknIcZh7u4QAF8m5anExxpbFhOsiqJNsNGLKiNZ1i
         g28R3MI4ayvBk9na8Nv6AQ5PvzQcixfxmhE16XK7sTLc0fXeBaolBIfel8fc4o6np1ry
         9ZiNuZ0qtbR+9YSQwVFSX1m3RrYfvrBb8GTNR4tWzVD+pa9KpvfayJGcImzw5MdgShsB
         ubXRPvj2Avd2j/Wc5TnWI9+YXzvrjYDBmWAf0Au35O4yy+tCUky95uw3fB+4orFLQRrz
         zBNQQfxBMQzOIjMOZ3yTXTdISJ8jGIeOBc9qejXWcl7RdK/i8PZe3uRKLQmgf5E4T5fL
         pZRQ==
X-Gm-Message-State: AOAM530xnONo1Pv8MuXh5que2Xb5coJQE8Q2bQrRlE0UOlawl/oVeezX
        8Tk4WMlKYXdT8Ubavb0AY7vYHGpdxUrLQjPOWrHLCwYoD5apgssDWCFi1uDIWQbIrklyzJU0B0w
        bJISJsKIvw/5Frbkf
X-Received: by 2002:a5d:59a4:0:b0:203:914f:52fa with SMTP id p4-20020a5d59a4000000b00203914f52famr3417262wrr.257.1647514541648;
        Thu, 17 Mar 2022 03:55:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysbRU6X3N38sZnHt2a+qYqTxqD7zt/WiAYw+BN78ayQKGmZg2WlK4KxV8gsbHuhc5/z0oc2A==
X-Received: by 2002:a5d:59a4:0:b0:203:914f:52fa with SMTP id p4-20020a5d59a4000000b00203914f52famr3417232wrr.257.1647514541257;
        Thu, 17 Mar 2022 03:55:41 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id r2-20020a0560001b8200b00203dffb9598sm3290679wru.86.2022.03.17.03.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 03:55:40 -0700 (PDT)
Message-ID: <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
Date:   Thu, 17 Mar 2022 11:55:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
In-Reply-To: <20220315144521.3810298-2-aisheng.dong@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.03.22 15:45, Dong Aisheng wrote:
> When there're multiple process allocing dma memory in parallel

s/allocing/allocating/

> by calling dma_alloc_coherent(), it may fail sometimes as follows:
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
> If dumping memory info, we found that there was also ~342M normal memory,
> but only 1352K CMA memory left in buddy system while a lot of pageblocks
> were isolated.

s/If/When/

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
> This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> error in case the target memory range may has been temporarily isolated
> by others and released later.

But you patch doesn't check for -EBUSY and instead might retry forever,
on any allocation error, no?

I'd really suggest letting alloc_contig_range() return -EAGAIN in case
the isolation failed and handling -EAGAIN only in a special way instead.

In addition, we might want to stop once we looped to often I assume.

-- 
Thanks,

David / dhildenb

