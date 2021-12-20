Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D6847A3FA
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbhLTDtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 22:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhLTDtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 22:49:00 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CE7C061574;
        Sun, 19 Dec 2021 19:49:00 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id q25so13965861oiw.0;
        Sun, 19 Dec 2021 19:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1j2CDzTNF0m2JBkGbaCYgtzCPMnfZRu2YruHU72ntE=;
        b=CzMq9dYGxrgDIms9/jNx2BuPUB+jYthIp9jXrg4ofFTjTXUP2xLWgcc1XzU089Yv6H
         cX+IMxZY70kQHE/SpJ0XhvW4vrHfg2qaYAo4V4gY2nUmHMjO70fm11Wct0we3N0D0wbl
         tMp+hw1c2UTACB/PC9uOi0AjrxhNWgdXfTHmmlnXn1CQf2z75Rr0pIMb8zZmRSt6HrKW
         A/+cB3wpSpRPkJfEm49W+HlxejclfMLxeYxSddZuaU0oG1JTTvNS/am2qXXdyCgK+4yZ
         tSStCpuMRlbnZNBGziuZo/qb5tKgpiqLeA6vIS5/yphXAWoVZB/OW2mxOOrp3qCGCCoU
         Eqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1j2CDzTNF0m2JBkGbaCYgtzCPMnfZRu2YruHU72ntE=;
        b=VDIluHQvKCyYpHJpW7GI7flM+csqFAonnsY46tAFQ/aktynqRN+5B1Bh4uD4cxXncM
         BZW6t77o5m3503G7O3NnqHpF+7x3vE3GIFAebw/e5xXULBBW3djb7Cu15K8w48SjNZsm
         QbRnlLyqalO3qeJr2NaSNlr+TgTZAzcpV3rrnV8QZ3/SA7T3eM0bMpnjw5rOVTyff5ae
         91tu5E3uVxlBcIK9prfolTH+TNpvH131S8PCZKu9+Mq4lI2wmw4d3pfhzkTjS4mJk4By
         9QFFrQeom1O3qlwcuuaIKa9fQ4KmDqVZnlRAHbK6qlf4AhqQBILlkOTPKozXn/WORnyM
         HKnQ==
X-Gm-Message-State: AOAM531lN6mZIZ4H7YuYvEk2RzHa8701TtyyKYL7mrqO6FAyG91wOVAA
        isHE788bXZNDhGhEcL3KMon+bcyxIDjwDQqTEC0=
X-Google-Smtp-Source: ABdhPJy6Iydo/sxMOAklsGW6oGKTDwBI1+syO1sfRCphXRESVwwOKJ8Y1ck13Xns7X62wl4ODtiXn2mvSNykIdUlLLo=
X-Received: by 2002:a54:4584:: with SMTP id z4mr16454845oib.158.1639972139627;
 Sun, 19 Dec 2021 19:48:59 -0800 (PST)
MIME-Version: 1.0
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
 <20211215080242.3034856-2-aisheng.dong@nxp.com> <783f64f5-3a55-6c42-a740-19a12c2c7321@redhat.com>
 <DB9PR04MB84777DDC63F5D2D995F7F5E980779@DB9PR04MB8477.eurprd04.prod.outlook.com>
 <7d9b7e5f-a6c0-2079-90e7-c02aaeb1f4c0@redhat.com> <DB9PR04MB8477037EE173D98F844DCAE680789@DB9PR04MB8477.eurprd04.prod.outlook.com>
 <88ce4f53-587b-c18a-9694-a3e173e6e030@redhat.com>
In-Reply-To: <88ce4f53-587b-c18a-9694-a3e173e6e030@redhat.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Mon, 20 Dec 2021 11:43:48 +0800
Message-ID: <CAA+hA=TnrPxqDqoy0iuyWK1PRzPcvjur7DhpEy8J4R8K2B6nsA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
To:     David Hildenbrand <david@redhat.com>
Cc:     Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 8:27 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 17.12.21 04:44, Aisheng Dong wrote:
> >> From: David Hildenbrand <david@redhat.com>
> >> Sent: Thursday, December 16, 2021 6:57 PM
> >>
> >> On 16.12.21 03:54, Aisheng Dong wrote:
> >>>> From: David Hildenbrand <david@redhat.com>
> >>>> Sent: Wednesday, December 15, 2021 8:31 PM
> >>>>
> >>>> On 15.12.21 09:02, Dong Aisheng wrote:
> >>>>> We met dma_alloc_coherent() fail sometimes when doing 8 VPU decoder
> >>>>> test in parallel on a MX6Q SDB board.
> >>>>>
> >>>>> Error log:
> >>>>> cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret:
> >>>>> -16
> >>>>> cma: number of available pages:
> >>>>>
> >>>>
> >> 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@3607
> >>>> 6+99@40477+108
> >>>>> @40852+44@41108+20@41196+108@41364+108@41620+
> >>>>>
> >>>>
> >> 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49
> >>>> 324+20@49388+
> >>>>> 5076@49452+2304@55040+35@58141+20@58220+20@58284+
> >>>>> 7188@58348+84@66220+7276@66452+227@74525+6371@75549=>
> >>>> 33161 free of
> >>>>> 81920 total pages
> >>>>>
> >>>>> When issue happened, we saw there were still 33161 pages (129M) free
> >>>>> CMA memory and a lot available free slots for 148 pages in CMA
> >>>>> bitmap that we want to allocate.
> >>>>>
> >>>>> If dumping memory info, we found that there was also ~342M normal
> >>>>> memory, but only 1352K CMA memory left in buddy system while a lot
> >>>>> of pageblocks were isolated.
> >>>>>
> >>>>> Memory info log:
> >>>>> Normal free:351096kB min:30000kB low:37500kB high:45000kB
> >>>> reserved_highatomic:0KB
> >>>>>       active_anon:98060kB inactive_anon:98948kB active_file:60864kB
> >>>> inactive_file:31776kB
> >>>>>       unevictable:0kB writepending:0kB present:1048576kB
> >>>> managed:1018328kB mlocked:0kB
> >>>>>       bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB
> >>>>> lowmem_reserve[]: 0 0 0
> >>>>> Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB
> >>>> (UMECI) 65*64kB (UMCI)
> >>>>>   36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI)
> >>>> 4*2048kB (MI) 8*4096kB (EI)
> >>>>>   8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> >>>>>
> >>>>> The root cause of this issue is that since commit a4efc174b382
> >>>>> ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports
> >>>> concurrent
> >>>>> memory allocation. It's possible that the pageblock process A try to
> >>>>> alloc has already been isolated by the allocation of process B
> >>>>> during memory migration.
> >>>>>
> >>>>> When there're multi process allocating CMA memory in parallel, it's
> >>>>> likely that other the remain pageblocks may have also been isolated,
> >>>>> then CMA alloc fail finally during the first round of scanning of
> >>>>> the whole available CMA bitmap.
> >>>>
> >>>> I already raised in different context that we should most probably
> >>>> convert that -EBUSY to -EAGAIN --  to differentiate an actual
> >>>> migration problem from a simple "concurrent allocations that target the
> >> same MAX_ORDER -1 range".
> >>>>
> >>>
> >>> Thanks for the info. Is there a patch under review?
> >>
> >> No, and I was too busy for now to send it out.
> >>
> >>> BTW i wonder that probably makes no much difference for my patch since
> >>> we may prefer retry the next pageblock rather than busy waiting on the
> >> same isolated pageblock.
> >>
> >> Makes sense. BUT as of now we isolate not only a pageblock but a
> >> MAX_ORDER -1 page (e.g., 2 pageblocks on x86-64 (!) ). So you'll have the
> >> same issue in that case.
> >
> > Yes, should I change to try next MAX_ORDER_NR_PAGES or keep as it is
> > and let the core to improve it later?
> >
> > I saw there's a patchset under review which is going to remove the
> > MAX_ORDER - 1 alignment requirement for CMA.
> > https://patchwork.kernel.org/project/linux-mm/cover/20211209230414.2766515-1-zi.yan@sent.com/
> >
> > Once it's merged, I guess we can back to align with pageblock rather
> > than MAX_ORDER-1.
>
> While the goal is to get rid of the alignment requirement, we might
> still have to isolate all applicable MAX_ORDER-1 pageblocks. Depends on
> what we can or cannot achieve easily :)
>

Ok, got it. As that's another story and does not affect us to fix the current
kernel problem first that CMA alloc may fail occasionally,
I'm going to change to align with MAX_ORDER_NR_PAGES for retries
as you pointed out in the next version.
Do you have more suggestions for this patchset?

Regards
Aisheng

>
> --
> Thanks,
>
> David / dhildenb
>
