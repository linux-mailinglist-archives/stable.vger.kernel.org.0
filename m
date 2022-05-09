Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C08520146
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiEIPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 11:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiEIPnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 11:43:31 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5B22B3F60;
        Mon,  9 May 2022 08:39:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x18so14208888plg.6;
        Mon, 09 May 2022 08:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6/chWcvBkY19DLcB+U1/TJvEN2HZbk6pQe9THfK7tl4=;
        b=gMhj5NAfa8kuX+GK5AoyjPHJzShaiHqMob0+aua9CPRj7Ee8B3UhTko574gd3fDCBY
         WTjkMgTGhp8EBzvxRKqyw4Xp8M2WnuzQVfeWaOVEu3DzyhKYX9UJcq0ulnwjFgtNHcQT
         CkbPfFHT4yFbfHz4GuXY0OTL+ziSVei5XMEMBESfpNBET6POcbE8J6tttv+POmRsntNq
         YWpBaDHfbJXD4CtdLgievqMEJ+RsvrUpAWxTUpwRJ89SH2sdWGDL5vLd1B+gkx/l5U0Y
         Dw2vkgJjuBBOO+IBNjw+mkS+/CEZClL9qiAzhUNUELqit8LIQFYGO7J6ofW0LN/eY76L
         TY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6/chWcvBkY19DLcB+U1/TJvEN2HZbk6pQe9THfK7tl4=;
        b=GgYYYkhJ806BREQA1wca/MF4PCjMPTSq1LPPeMjFYx4i30z5kLEFO0pXYBb+oHve30
         p4e7OO9Gd5U6nolGntK+kG5hb4q7YgUX2yYcNnLq/eJ3tONhYZX0S1u1etW/8GjSE3V6
         2uvfNIHZmhP6QUfmehZbe2E6GQD35TUZ9yPhdp5goRmIUgOl1kHOacCz1jYRkNd7w93R
         /fz9NT/ldGks+B+MbGnI4UVGEhoEkrQQ/DksuZRuO+Q8X2pAPJTDY7LkF100Z2dx/VG9
         tqleX0/QWzfEPzdQHebLAYw93mquOt+FPA8Z1HwhCunyI1JLZGDkza8gm87iXErmQhNN
         W0tQ==
X-Gm-Message-State: AOAM532fmwnV80+8N2YPD/0phIPvmRlfH2DXI/K0LNZYlnk578Ka1MxL
        gdCE8e8MOKDTUMF/zQMd8G0=
X-Google-Smtp-Source: ABdhPJzZaiuoQoQ8UtW7Pp2JgsA9jZZFz6hG+13CXjxTRjIbJEXPje+mOJuzda3Qn1p3WPHjZNmm9Q==
X-Received: by 2002:a17:902:a407:b0:15d:29cc:5f56 with SMTP id p7-20020a170902a40700b0015d29cc5f56mr17206972plq.132.1652110773644;
        Mon, 09 May 2022 08:39:33 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:3704:694b:acc0:e064])
        by smtp.gmail.com with ESMTPSA id 5-20020a630705000000b003c14af5061esm8605388pgh.54.2022.05.09.08.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:39:33 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Mon, 9 May 2022 08:39:31 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Dong Aisheng <aisheng.dong@nxp.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dongas86@gmail.com,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Revert "mm/cma.c: remove redundant cma_mutex lock"
Message-ID: <Ynk1s07xAX1rvMdg@google.com>
References: <20220509094551.3596244-1-aisheng.dong@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509094551.3596244-1-aisheng.dong@nxp.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 05:45:51PM +0800, Dong Aisheng wrote:
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


Link: https://lore.kernel.org/all/20220315144521.3810298-2-aisheng.dong@nxp.com/

Adding a link would be helpful why decided to revert.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> CC: stable@vger.kernel.org # 5.11+
> Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
> Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Acked-by: Minchan Kim <minchan@kernel.org>
