Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D44758DF
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 13:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbhLOMa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 07:30:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242428AbhLOMa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 07:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639571456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zH8D1SLNAp4PXkcwxNLQitwyr9VTmaG7uyXu9T1aOg0=;
        b=PHmC4ld08CIywijvfk1MMoV7RB965i2Qocjfp3rw5w5XuKDFT9UQ4/QlQUmA0fRYoBd/Gz
        hXCkIkKZbYysbjMUti9lTOyTLUJPwh1wJmaa26f9SvsCaQJR6fZ8xW2w1cQ07FA/peC4rB
        oSNbMasaODMAgULfCacR5OlQJcPyV80=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-vvvc9eGJOgqgkLdhTETkzw-1; Wed, 15 Dec 2021 07:30:55 -0500
X-MC-Unique: vvvc9eGJOgqgkLdhTETkzw-1
Received: by mail-wm1-f70.google.com with SMTP id j20-20020a05600c1c1400b00343ad0c4c40so2619082wms.0
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 04:30:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=zH8D1SLNAp4PXkcwxNLQitwyr9VTmaG7uyXu9T1aOg0=;
        b=S2dIO64NpkoGdDjmQe1ZBxd4QE8v4SEas61rKg76urLNlO6VSqSa77xaDsIt2ERZ9n
         79XoGIS1Eb1d9GXBA+/VvUEnUK1x/jYjpChHV4rNM2pkm7eYSj4SiAdRAiPg5TBzbJZl
         5Go+F/2VuQ9MZeTjL6piFaUOQ4lfd8TkOQwOZ3/lzZ3imPfnizp01R6KBVSlxYaWaD7q
         2F8afGUxSJfEt1embjK+2+kU6MZvhPaJaiUwUIau0/uK17QqGXdSmBfOYpAUDQAr6vP9
         lH8T9H/khu8BycaW29W71+2QzJYVnFFZ+KNBvjPty3sh8v+O/PvN5lcdcz7aPJfYQXMg
         3dHQ==
X-Gm-Message-State: AOAM531F0hfboBDKEyAuv+1t4LVrG0TNezLE21hoLHjRK84oDAAI1QXW
        XtEuLRvkCA4k14SFdh8ZnTv3xifkuAqQ7HgUbo/PoEDowM51Qqn3DdpGcI2I2bRTbI5D1CJMmYX
        kvBjf+FRzDxjtaeX5
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr1020595wrc.274.1639571454270;
        Wed, 15 Dec 2021 04:30:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfpgjKYuZNDv0OniYKd7UUVLPlR4v7vEBeJK21+fOTrEhUjq0mHLYuLaFlnRTX/3YAYADjoQ==
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr1020572wrc.274.1639571454002;
        Wed, 15 Dec 2021 04:30:54 -0800 (PST)
Received: from [192.168.3.132] (p5b0c609b.dip0.t-ipconnect.de. [91.12.96.155])
        by smtp.gmail.com with ESMTPSA id j35sm822030wms.13.2021.12.15.04.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 04:30:53 -0800 (PST)
Message-ID: <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
Date:   Wed, 15 Dec 2021 13:30:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Content-Language: en-US
To:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, dongas86@gmail.com,
        linux-arm-kernel@lists.infradead.org, jason.hui.liu@nxp.com,
        leoyang.li@nxp.com, abel.vesa@nxp.com, shawnguo@kernel.org,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211215080242.3034856-2-aisheng.dong@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.12.21 09:02, Dong Aisheng wrote:
> We met dma_alloc_coherent() fail sometimes when doing 8 VPU decoder
> test in parallel on a MX6Q SDB board.
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
> memory allocation. It's possible that the pageblock process A try to alloc
> has already been isolated by the allocation of process B during memory
> migration.
> 
> When there're multi process allocating CMA memory in parallel, it's
> likely that other the remain pageblocks may have also been isolated,
> then CMA alloc fail finally during the first round of scanning of the
> whole available CMA bitmap.

I already raised in different context that we should most probably
convert that -EBUSY to -EAGAIN --  to differentiate an actual migration
problem from a simple "concurrent allocations that target the same
MAX_ORDER -1 range".


-- 
Thanks,

David / dhildenb

