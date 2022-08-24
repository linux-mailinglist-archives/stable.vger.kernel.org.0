Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5766D5A02F6
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbiHXUsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiHXUso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F42786C5
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661374123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/rRnDONf/MIAcvQvaU+OL/iys5bxrMY05ODAN/aEOnI=;
        b=aj/+ET2UnjpBLdj4Z8sxjtg36aqNF85XMtJ6JREFtjObE2EctYcMtdHYVXrsKzTP2orppa
        pHIwK90PoLNe+1XTWX6XU5UcREmVmLv7BiZRQyXom6GqT1DO7NxRJDFvvHR7iAKArigtU8
        MS5VMR6NRj21Dqp1Mt2986CqLAdUbPs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-gvUrz6b0MZCLzqv11RQG9g-1; Wed, 24 Aug 2022 16:48:41 -0400
X-MC-Unique: gvUrz6b0MZCLzqv11RQG9g-1
Received: by mail-qv1-f71.google.com with SMTP id gh7-20020a05621429c700b00496b1a465b1so10288778qvb.5
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/rRnDONf/MIAcvQvaU+OL/iys5bxrMY05ODAN/aEOnI=;
        b=1OtYv41MxYEHf7Cs6Z9NOaT/J5Yq1eybzFTRRk6EMfwNSAh5wIiPbM4g/mQNpKjlGU
         u+FJ2ubFLezc5OK6i+xYOBrppd4KmjW5g7hvbXwsex/llUJJkKCHo4nseNuPwps913A1
         Wvk6LL1kT3+wOsYtFW9G9KDcyy6RH9lDR1/ZbH53e4Wjq/FT7ydXbJKrku3uwiAk7sYp
         lakOakgbUxSEroWvzz8htMSFO3kgAhJQm0YDaiBoW1n5f6EcXIyGvn9Jed3Atih6O87j
         w/iXVTgTnC3QGRzJLS/0sxIznhWyfrxLXfQz2ZtJv3CV0sFTZVieTiAN07FPCP4V161Z
         JqPw==
X-Gm-Message-State: ACgBeo3OZq6jH0bklM4Zk+Uzgiy24OytGZ+sxGg5XOHIvPE9O86mt2aj
        pLWDwlpm8SI7dg6XI4ToI6OviJTEeI5HtycVlUrZluFnkYjh5n2RCnncRrpA5AMNXObUOnngycW
        jj1J9DJBTZzhrNXMx
X-Received: by 2002:ad4:4eaf:0:b0:496:ac46:2d9c with SMTP id ed15-20020ad44eaf000000b00496ac462d9cmr868933qvb.82.1661374121422;
        Wed, 24 Aug 2022 13:48:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4s25beJjrLygCxW4UWpRepdZLtdhOdc0j/yJivVpKekwHMGeWPIw0hJ6uQX5trRhdvaC3qCw==
X-Received: by 2002:ad4:4eaf:0:b0:496:ac46:2d9c with SMTP id ed15-20020ad44eaf000000b00496ac462d9cmr868905qvb.82.1661374121119;
        Wed, 24 Aug 2022 13:48:41 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id g9-20020ac85809000000b00344576bcfefsm13976258qtg.70.2022.08.24.13.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 13:48:40 -0700 (PDT)
Date:   Wed, 24 Aug 2022 16:48:38 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <YwaOpj54/qUb5fXa@xz-m1.local>
References: <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal>
 <YwaJSBnp2eyMlkjw@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwaJSBnp2eyMlkjw@xz-m1.local>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 04:25:44PM -0400, Peter Xu wrote:
> On Wed, Aug 24, 2022 at 11:56:25AM +1000, Alistair Popple wrote:
> > >> Still I don't know whether there'll be any side effect of having stall tlbs
> > >> in !present ptes because I'm not familiar enough with the private dev swap
> > >> migration code.  But I think having them will be safe, even if redundant.
> > 
> > What side-effect were you thinking of? I don't see any issue with not
> > TLB flushing stale device-private TLBs prior to the migration because
> > they're not accessible anyway and shouldn't be in any TLB.
> 
> Sorry to be misleading, I never meant we must add them.  As I said it's
> just that I don't know the code well so I don't know whether it's safe to
> not have it.
> 
> IIUC it's about whether having stall system-ram stall tlb in other
> processor would matter or not here.  E.g. some none pte that this code
> collected (boosted both "cpages" and "npages" for a none pte) could have
> stall tlb in other cores that makes the page writable there.

For this one, let me give a more detailed example.

It's about whether below could happen:

       thread 1                thread 2                 thread 3
       --------                --------                 --------
                          write to page P (data=P1)
                            (cached TLB writable)
  zap_pte_range()
    pgtable lock
    clear pte for page P
    pgtable unlock
    ...
                                                     migrate_vma_collect
                                                       pte none, npages++, cpages++
                                                       allocate device page
                                                       copy data (with P1)
                                                       map pte as device swap 
                          write to page P again
                          (data updated from P1->P2)
  flush tlb

Then at last from processor side P should have data P2 but actually from
device memory it's P1. Data corrupt.

> 
> When I said I'm not familiar with the code, it's majorly about one thing I
> never figured out myself, in that migrate_vma_collect_pmd() has this
> optimization to trylock on the page, collect if it succeeded:
> 
>   /*
>    * Optimize for the common case where page is only mapped once
>    * in one process. If we can lock the page, then we can safely
>    * set up a special migration page table entry now.
>    */
>    if (trylock_page(page)) {
>           ...
>    } else {
>           put_page(page);
>           mpfn = 0;
>    }
> 
> But it's kind of against a pure "optimization" in that if trylock failed,
> we'll clear the mpfn so the src[i] will be zero at last.  Then will we
> directly give up on this page, or will we try to lock_page() again
> somewhere?
> 
> The future unmap op is also based on this "cpages", not "npages":
> 
> 	if (args->cpages)
> 		migrate_vma_unmap(args);
> 
> So I never figured out how this code really works.  It'll be great if you
> could shed some light to it.
> 
> Thanks,
> 
> -- 
> Peter Xu

-- 
Peter Xu

