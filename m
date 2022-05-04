Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E663651B39D
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 01:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381937AbiEDXmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 19:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382346AbiEDX26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 19:28:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349416542;
        Wed,  4 May 2022 16:25:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i24so2294622pfa.7;
        Wed, 04 May 2022 16:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a3oa+MjWYg0iSbcO36pvcY+lTfK7h1GqKS5uNpusaVA=;
        b=YY1eAVbiS/5bMstpMIVNzDvXqhG2kOZZN7HBO/WKu3wzHQ0PAre97bcODM8/EMh2FI
         Ak3VlVF9fOE7V0jnYGyaGzkha0L/2zTD/74w3y+1RJ0CI+MYS5Ad5rjicpbv9iAJvODw
         nNlZhO5Q4HG30CmItkCTKy55mN6EdwjYpv1qZTnQendVpZHjRSfs7XQGL/PCIPL9+dcp
         6fLwpuzn1Bs76/g56t5SjrTvFbNgsBGa3VSQlfoMqrAdaIcOCtPiqpqqIlFNbX43xt39
         3eQndrYepvPMO4QFzgf5DQqKCitah/zkIimD11M/JN9N1ZfxUkA/+6xPT0G1gYmMVImX
         xY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=a3oa+MjWYg0iSbcO36pvcY+lTfK7h1GqKS5uNpusaVA=;
        b=MjmXnM5TCXG8aZk4CWtl7MUTpYJdbBkUFpn35muPYNC0H+4+BM5hD2lt2FMJ1Fiks6
         cVS/8AF3/qZt93EKuQgR3nJImR0baBc0xsQKlQ/I6Q7mfpkCFv61nkBMQdvwFblzOga2
         efPmmsBRtfHgNtSSMqH1ZMTfop5Kjipi5fPM5zi4iN2POxB1Llqj393jbP7PWV4Q5iF2
         XHlSiFREfqVpQ9uVxnLl4hyqHq9OLPLhU4iLMZhkJwshG8C/7uzPkypX66+JQ5tiN+Bs
         E0qoAyID02yA/j56fkKUf2SboBlBtrVOZ/cpOIdlMHIhp0vb8Ao2S2ubok9+yCx90Ikm
         lFQA==
X-Gm-Message-State: AOAM533CW2TaTT0+Eb6BRIFiN4yIJSQGH0VLw7m4RH+cT6kMsQY5SHSc
        IQT6/FB/xGuTkI8I4j+hzcI=
X-Google-Smtp-Source: ABdhPJwK4Gh+zY0MtqvpDIPUpMlLIEyJbgID9CQEKBbeqLrfTRpJF85qZ9z0lFWMSaqPYB9T4YqKDg==
X-Received: by 2002:a62:834c:0:b0:50d:8d39:8715 with SMTP id h73-20020a62834c000000b0050d8d398715mr23338399pfe.29.1651706717997;
        Wed, 04 May 2022 16:25:17 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:8435:b3e7:62fc:4dfa])
        by smtp.gmail.com with ESMTPSA id b21-20020aa78715000000b0050dc76281a4sm8739881pfo.126.2022.05.04.16.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 16:25:17 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 4 May 2022 16:25:15 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Dong Aisheng <dongas86@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
Message-ID: <YnMLW76ivpJSrzto@google.com>
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com>
 <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
 <CAA+hA=QzDJhFnntKK4nk-SMErk9J_mFPv0b7ZWuC8Ubz0BC+sg@mail.gmail.com>
 <YjNr+d2Un7F8c2DZ@google.com>
 <CAA+hA=SBeCT+XkzNL3p07vC+58AZOTtoiLG=jVK0tX4wNFvrHA@mail.gmail.com>
 <YjSxR9Zyck4YqgEz@google.com>
 <CAA+hA=QT3GH0_ufNRowW0N-KzziiJkaDo5o8W-CqZboD3XDbyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=QT3GH0_ufNRowW0N-KzziiJkaDo5o8W-CqZboD3XDbyg@mail.gmail.com>
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

On Wed, May 04, 2022 at 11:52:30PM +0800, Dong Aisheng wrote:
> Hi Minchan & David,
> 
> On Sat, Mar 19, 2022 at 12:20 AM Minchan Kim <minchan@kernel.org> wrote:
> >
> > On Fri, Mar 18, 2022 at 11:43:41AM +0800, Dong Aisheng wrote:
> > > On Fri, Mar 18, 2022 at 1:12 AM Minchan Kim <minchan@kernel.org> wrote:
> > > >
> > > > On Thu, Mar 17, 2022 at 10:26:42PM +0800, Dong Aisheng wrote:
> > > > > On Thu, Mar 17, 2022 at 6:55 PM David Hildenbrand <david@redhat.com> wrote:
> > > > > >
> > > > > > On 15.03.22 15:45, Dong Aisheng wrote:
> > > > > > > When there're multiple process allocing dma memory in parallel
> > > > > >
> > > > > > s/allocing/allocating/
> > > > > >
> > > > > > > by calling dma_alloc_coherent(), it may fail sometimes as follows:
> > > > > > >
> > > > > > > Error log:
> > > > > > > cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> > > > > > > cma: number of available pages:
> > > > > > > 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> > > > > > > 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> > > > > > > 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> > > > > > >
> > > > > > > When issue happened, we saw there were still 33161 pages (129M) free CMA
> > > > > > > memory and a lot available free slots for 148 pages in CMA bitmap that we
> > > > > > > want to allocate.
> > > >
> > > > Yes, I also have met the problem especially when the multiple threads
> > > > compete cma allocation. Thanks for bringing up the issue.
> > > >
> > > > > > >
> > > > > > > If dumping memory info, we found that there was also ~342M normal memory,
> > > > > > > but only 1352K CMA memory left in buddy system while a lot of pageblocks
> > > > > > > were isolated.
> > > > > >
> > > > > > s/If/When/
> > > > > >
> > > > >
> > > > > Will fix them all, thanks.
> > > > >
> > > > > > >
> > > > > > > Memory info log:
> > > > > > > Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> > > > > > >           active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> > > > > > >           unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> > > > > > >           bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> > > > > > > Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> > > > > > >       36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> > > > > > >       8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> > > > > > >
> > > > > > > The root cause of this issue is that since commit a4efc174b382
> > > > > > > ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> > > > > > > memory allocation. It's possible that the memory range process A trying
> > > > > > > to alloc has already been isolated by the allocation of process B during
> > > > > > > memory migration.
> > > > > > >
> > > > > > > The problem here is that the memory range isolated during one allocation
> > > > > > > by start_isolate_page_range() could be much bigger than the real size we
> > > > > > > want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> > > > > > >
> > > > > > > Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> > > > > > > is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> > > > > > > (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> > > > > > > all CMA memory may have already been isolated by other processes when
> > > > > > > one trying to allocate memory using dma_alloc_coherent().
> > > > > > > Since current CMA code will only scan one time of whole available CMA
> > > > > > > memory, then dma_alloc_coherent() may easy fail due to contention with
> > > > > > > other processes.
> > > > > > >
> > > > > > > This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> > > > > > > error in case the target memory range may has been temporarily isolated
> > > > > > > by others and released later.
> > > > > >
> > > > > > But you patch doesn't check for -EBUSY and instead might retry forever,
> > > > > > on any allocation error, no?
> > > > > >
> > > > >
> > > > > My patch seems not need check it because there's no chance to retry the loop
> > > > > in case an non -EBUS error happened earlier.
> > > > >
> > > > > for (;;) {
> > > > >         if (bitmap_no >= bitmap_maxno) {
> > > > >                 retry_the_whole_loop;
> > > > >         }
> > > > >
> > > > >         pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
> > > > >         ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
> > > > >                              GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> > > > >
> > > > >         if (ret != -EBUSY)
> > > > >                 break;
> > > > > }
> > > > >
> > > > > > I'd really suggest letting alloc_contig_range() return -EAGAIN in case
> > > > > > the isolation failed and handling -EAGAIN only in a special way instead.
> > > > > >
> > > > >
> > > > > Yes, i guess that's another improvement and is applicable.
> > > > >
> > > > > > In addition, we might want to stop once we looped to often I assume.
> > > > > >
> > > > >
> > > > > I wonder if really retried un-reasonably too often, we probably may
> > > > > need figure out
> > > > > what's going on inside alloc_contig_range() and fix it rather than
> > > > > return EBUSY error to
> > > > > users in case there're still a lot of avaiable memories.
> > > > > So currently i didn't add a maximum retry loop outside.
> > > > >
> > > > > Additionaly, for a small CMA system (128M with 32M max_order pages),
> > > > > the retry would
> > > > > be frequently when multiple process allocating memory, it also depends
> > > > > on system running
> > > > > state, so it's hard to define a reasonable and stable maxinum retry count.
> > > >
> > > > IMO, when the CMA see the -EAGAIN, it should put the task into
> > > > cma->wait_queue and then be woken up by other thread which finish
> > > > work of the cma. So it's similar with cma_mutex but we don't need to
> > > > synchronize for !EAGAIN cases and make the cma allocatoin fair.
> > >
> > > Okay, that's another approach which is completely different from the
> > > existing one.
> > > Instead of blocking on the CMA memory range which we want to allocate,
> > > the existing code will try the next available memory ranges.
> > > The question is whether we need to change this behavior?
> >
> > It could wait only if it scan the whole range but everyblock were
> > taken and then one more trial after woken up. If the cma_alloc return
> > -EAGAIN in the end, user could decide the policy.
> >
> > > It looks to me both ways have pros and cons.
> > >
> > > And for sleeping on -EAGAIN case, do we need an accurate wakeup?
> > > IOW only wakes the sleeper when the exact memory range is released
> > > which means we need create some more complicated code logic
> > > to track different CMA memory range usage.
> > > Otherwise, there will be possible false positive wakeups and the requester may
> > > quickly sleep again.
> >
> > I even didn't consider such complicated model since we would have
> > the race anyway.(Never tested but wanted to show the intention)
> >
> > diff --git a/mm/cma.c b/mm/cma.c
> > index bc9ca8f3c487..cccf684da587 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -449,6 +449,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> >         offset = cma_bitmap_aligned_offset(cma, align);
> >         bitmap_maxno = cma_bitmap_maxno(cma);
> >         bitmap_count = cma_bitmap_pages_to_bits(cma, count);
> > +       bool retried = false;
> >
> >         if (bitmap_count > bitmap_maxno)
> >                 goto out;
> > @@ -460,6 +461,12 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> >                                 offset);
> >                 if (bitmap_no >= bitmap_maxno) {
> >                         spin_unlock_irq(&cma->lock);
> > +                       if (ret == -EAGAIN && !retried) {
> > +                               wait_event_killable(cma->wq);
> 
> I spent a few days reading the code carefully and implementing your suggestions.
> But I think the problem was still when to wake up multiple callers
> properly who were sleeping
> on isolation contention error.  The issue I observed was that there's
> a synchronization problem
> between the sleeper and waker in current code logic due to:
> 1) we only need to wake up the caller when detecting users sleeping on
> the isolation contention.
> A flag needs to be introduced to check dynamically.
> 2) wakeup code may be finished before the flag was set which means the
> last sleeper
> may be missed to wake up. So a timeout mechanism needs to be introduced.
> 3) the code can't avoid the wait_for_completion() and complete() run in parallel
> without introducing extra complexity to do proper synchronization.
> (during my test, &cma->pending can be < 0 sometimes)
> 
> I wonder if it's worth introducing such complexity to support sleeping
> on isolation contention.
> Maybe the simple way was just as Andrew said that  let's revert that
> broken patch first.
> 
> Do you have any suggestions?

Thanks for the effort. On a second thought, I am also worry about the unfairness
on my suggestion since new comer could steal the pageblock while former was waiting
on the queue to be woken up. If it's complicated than the expectation, I don't think
we should block your workload so I agree reverting the original patch to resolve
regression first as Andrew suggested and then we need to think over better ideas.

Thanks.
