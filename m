Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE570476F4B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 11:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhLPK5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 05:57:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhLPK5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 05:57:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639652223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MC2gvHGYmh9g6Raca53bij6uBB+XqUqBeIAACH6kGiw=;
        b=K0tlO4kHiCTrYj/Jj6x0sLl4ETeFdI3vXUJztlbQty4xTeoEhL72Xaf0ihSeHarbOnrrMs
        9AXHj/JJdb/Jwg3T1lLNuBrkkVUOzCt/g8LhNMM0JDsMkJnsElHeLebqaiwkXqrZssOzRe
        n5HJVUqyH0HRvt4SeMLywWKJPVLY/Po=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-sEKN_HLzMD2jPt8bMj36KQ-1; Thu, 16 Dec 2021 05:57:02 -0500
X-MC-Unique: sEKN_HLzMD2jPt8bMj36KQ-1
Received: by mail-wr1-f72.google.com with SMTP id l9-20020adfa389000000b001a23bd1c661so636651wrb.6
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 02:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=MC2gvHGYmh9g6Raca53bij6uBB+XqUqBeIAACH6kGiw=;
        b=Ycqw5o5AOZbuWxItGYNxlLa/GwnbwSdLH2WiDoqrX9Stmw/JwQNmySa5+ADHn+pXbJ
         01sLngc/WdoO2PHjpmqd1okNr0MZ/+O8CJkisHzFIKMKvlyJ4ZN8zWjkmqMd1/WKhSdR
         xHU+3i/FTW4I6EQPwxKnr26fmjd8VFm7Sc1uMwSJUgK9S8G0DbLiSxLXxDnUqiOLTPdw
         Z3v6Q91OfUzbZO+VY9sFHs8onXBHaMk2BZUxDjYhWfdsXuvvV8TMbNel82DFQ4H4zAEw
         XH9CZ/qtHJQIt3GSCMSNDKJLsgYndQy5on4DFLsiQZC9WJGG8+f/O+5o8dHtqpFj38r5
         kmnw==
X-Gm-Message-State: AOAM530G3UgLm6lujP3ful6KTpGJst56Gh0+2jMrFPvH1NZ/3TYT17zP
        XOhc31Hl37sm1yZO1cnklfrdm0PUBBz7A1i5OxyYwjER757/1d7vg05aaPid8eyrq3OXSFD1bEh
        5YYCTpyCMZzygGoni
X-Received: by 2002:a1c:f60a:: with SMTP id w10mr4356535wmc.53.1639652221411;
        Thu, 16 Dec 2021 02:57:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDhJG49j5IOXlecqEpDnxZnmchZDhLcRCk8gk+wn9LsO6KsDIg1HPa3zDdFSpqHP48eaZL7A==
X-Received: by 2002:a1c:f60a:: with SMTP id w10mr4356526wmc.53.1639652221231;
        Thu, 16 Dec 2021 02:57:01 -0800 (PST)
Received: from [192.168.3.132] (p4ff23dcd.dip0.t-ipconnect.de. [79.242.61.205])
        by smtp.gmail.com with ESMTPSA id g198sm5057299wme.23.2021.12.16.02.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:57:00 -0800 (PST)
Message-ID: <7d9b7e5f-a6c0-2079-90e7-c02aaeb1f4c0@redhat.com>
Date:   Thu, 16 Dec 2021 11:56:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Content-Language: en-US
To:     Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jason Liu <jason.hui.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "lecopzer.chen@mediatek.com" <lecopzer.chen@mediatek.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shijie Qin <shijie.qin@nxp.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com>
 <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
 <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.12.21 03:54, Aisheng Dong wrote:
>> From: David Hildenbrand <david@redhat.com>
>> Sent: Wednesday, December 15, 2021 8:31 PM
>>
>> On 15.12.21 09:02, Dong Aisheng wrote:
>>> We met dma_alloc_coherent() fail sometimes when doing 8 VPU decoder
>>> test in parallel on a MX6Q SDB board.
>>>
>>> Error log:
>>> cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
>>> cma: number of available pages:
>>>
>> 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@3607
>> 6+99@40477+108
>>> @40852+44@41108+20@41196+108@41364+108@41620+
>>>
>> 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49
>> 324+20@49388+
>>> 5076@49452+2304@55040+35@58141+20@58220+20@58284+
>>> 7188@58348+84@66220+7276@66452+227@74525+6371@75549=>
>> 33161 free of
>>> 81920 total pages
>>>
>>> When issue happened, we saw there were still 33161 pages (129M) free
>>> CMA memory and a lot available free slots for 148 pages in CMA bitmap
>>> that we want to allocate.
>>>
>>> If dumping memory info, we found that there was also ~342M normal
>>> memory, but only 1352K CMA memory left in buddy system while a lot of
>>> pageblocks were isolated.
>>>
>>> Memory info log:
>>> Normal free:351096kB min:30000kB low:37500kB high:45000kB
>> reserved_highatomic:0KB
>>> 	    active_anon:98060kB inactive_anon:98948kB active_file:60864kB
>> inactive_file:31776kB
>>> 	    unevictable:0kB writepending:0kB present:1048576kB
>> managed:1018328kB mlocked:0kB
>>> 	    bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB
>>> lowmem_reserve[]: 0 0 0
>>> Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB
>> (UMECI) 65*64kB (UMCI)
>>> 	36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI)
>> 4*2048kB (MI) 8*4096kB (EI)
>>> 	8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
>>>
>>> The root cause of this issue is that since commit a4efc174b382
>>> ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports
>> concurrent
>>> memory allocation. It's possible that the pageblock process A try to
>>> alloc has already been isolated by the allocation of process B during
>>> memory migration.
>>>
>>> When there're multi process allocating CMA memory in parallel, it's
>>> likely that other the remain pageblocks may have also been isolated,
>>> then CMA alloc fail finally during the first round of scanning of the
>>> whole available CMA bitmap.
>>
>> I already raised in different context that we should most probably convert that
>> -EBUSY to -EAGAIN --  to differentiate an actual migration problem from a
>> simple "concurrent allocations that target the same MAX_ORDER -1 range".
>>
> 
> Thanks for the info. Is there a patch under review?

No, and I was too busy for now to send it out.

> BTW i wonder that probably makes no much difference for my patch since we may
> prefer retry the next pageblock rather than busy waiting on the same isolated pageblock.

Makes sense. BUT as of now we isolate not only a pageblock but a
MAX_ORDER -1 page (e.g., 2 pageblocks on x86-64 (!) ). So you'll have
the same issue in that case.

-- 
Thanks,

David / dhildenb

