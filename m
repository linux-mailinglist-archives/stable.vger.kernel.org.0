Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37DE5A2951
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 16:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbiHZOZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 10:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbiHZOZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 10:25:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D42419C0D
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661523912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y4bjLXg/JtmRKJW/PsE4ZvXOvyRGRLjuYGGABsuG5Dk=;
        b=Z451xlg1Pf8bDWVs+8BIICvLF5fupHFlMFjjsQ0/YGuaKpMmEyjvW2cGjsM8Mfxa2C1RoU
        j9RoI5X5qpNbueigMQTLixYxdlH6IIPWDT5kUNmM26J9RH0yJjocyoaPsA181EZPxWTt7R
        FC5SZgPfuRrkULPE7rSyNf7jMAAe0as=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-anqDHoilM_yYQGcqXgdazQ-1; Fri, 26 Aug 2022 10:25:11 -0400
X-MC-Unique: anqDHoilM_yYQGcqXgdazQ-1
Received: by mail-qk1-f199.google.com with SMTP id f1-20020a05620a280100b006bc4966f463so1359384qkp.4
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Y4bjLXg/JtmRKJW/PsE4ZvXOvyRGRLjuYGGABsuG5Dk=;
        b=izhJLJ85yRBBwVqteUwXwTL3Ig2WViLqRbvJI6z7pHBk427Ay9FhdQMYUMvM91UBYv
         /sGulyne24JIVAlNG39bXeI4LI7Y7KuJgKwEKgHeh2hdl/1pk+zwm+GkZTwywoPbND3u
         MFEK1Iw01oW6kvhgjJXnBdP8K6VWHQsAw/PTO07REXyOAYXk6IX3xECZIDiEw0TOgVru
         UYYhkF2WuUO8q/OcXU5VEQVsCNZuBYDV5Je3w72gUF1sUeObwWYYCeAp0AWBNwH85rxB
         iyeiMnb0NtR273xg6hWWX4ptcPwVxUzqCQIH60USd7YABf1sTzS+8To8kGBfBM0yJPiS
         9nMg==
X-Gm-Message-State: ACgBeo26eWOiY7lreNTOQN8PGcdBu9rD+dpalLmMrSuiT9eEVZj0E5oC
        0R6xb1tN5lC95xYYNQXE+eIrjbUk4ObshXdxSzG2MChcx+kRgZvAVQt3+jFKnpjvhxF0Fu+4F8l
        nUw7YiBdRGgl4khTF
X-Received: by 2002:a05:622a:6027:b0:343:5691:93de with SMTP id he39-20020a05622a602700b00343569193demr8069011qtb.165.1661523910500;
        Fri, 26 Aug 2022 07:25:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7+t+rG++BFNW0uDP/2t8VMm7035UgpMd2ct1n9bL/iw1fkQYla9mH099oUJxPeUBOcLBE22Q==
X-Received: by 2002:a05:622a:6027:b0:343:5691:93de with SMTP id he39-20020a05622a602700b00343569193demr8068988qtb.165.1661523910244;
        Fri, 26 Aug 2022 07:25:10 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id x19-20020a05620a449300b006b629f86244sm2033590qkp.50.2022.08.26.07.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 07:25:09 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:25:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] mm/mprotect: Only reference swap pfn page if type match
Message-ID: <YwjXxC2BbJ5+3Isx@xz-m1.local>
References: <20220823221138.45602-1-peterx@redhat.com>
 <411d7b8c-f914-875e-b397-856e6a894366@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <411d7b8c-f914-875e-b397-856e6a894366@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 26, 2022 at 12:49:37PM +0200, David Hildenbrand wrote:
> On 24.08.22 00:11, Peter Xu wrote:
> > Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
> > fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:
> > 
> >   kernel BUG at include/linux/swapops.h:117!
> >   CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
> >   RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
> >   Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
> >   c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
> >   48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
> >   RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
> >   RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
> >   RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
> >   RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
> >   R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
> >   R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
> >   FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   Call Trace:
> >    <TASK>
> >    change_pte_range+0x36e/0x880
> >    change_p4d_range+0x2e8/0x670
> >    change_protection_range+0x14e/0x2c0
> >    mprotect_fixup+0x1ee/0x330
> >    do_mprotect_pkey+0x34c/0x440
> >    __x64_sys_mprotect+0x1d/0x30
> > 
> > It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
> > genuine swap entry.
> > 
> > Fix it by only calling it when it's a write migration entry where the page*
> > is used.
> > 
> > [1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/
> > 
> > Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  mm/mprotect.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index f2b9b1da9083..4549f5945ebe 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -203,10 +203,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
> >  			pages++;
> >  		} else if (is_swap_pte(oldpte)) {
> >  			swp_entry_t entry = pte_to_swp_entry(oldpte);
> > -			struct page *page = pfn_swap_entry_to_page(entry);
> >  			pte_t newpte;
> >  
> >  			if (is_writable_migration_entry(entry)) {
> > +				struct page *page = pfn_swap_entry_to_page(entry);
> > +
> >  				/*
> >  				 * A protection check is difficult so
> >  				 * just be safe and disable write
> 
> 
> Stumbling over the THP code, I was wondering if we also want to adjust change_huge_pmd()
> and hugetlb_change_protection. There are no actual swap entries, so I assume we're fine.
> 
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 482c1826e723..466364e7fc5f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1798,10 +1798,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>         if (is_swap_pmd(*pmd)) {
>                 swp_entry_t entry = pmd_to_swp_entry(*pmd);
> -               struct page *page = pfn_swap_entry_to_page(entry);
>  
>                 VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>                 if (is_writable_migration_entry(entry)) {
> +                       struct page *page = pfn_swap_entry_to_page(entry);
>                         pmd_t newpmd;
>                         /*
>                          * A protection check is difficult so
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2480ba627aa5..559465fae5cd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6370,9 +6370,9 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>                 }
>                 if (unlikely(is_hugetlb_entry_migration(pte))) {
>                         swp_entry_t entry = pte_to_swp_entry(pte);
> -                       struct page *page = pfn_swap_entry_to_page(entry);
>  
>                         if (!is_readable_migration_entry(entry)) {
> +                               struct page *page = pfn_swap_entry_to_page(entry);
>                                 pte_t newpte;
>  
>                                 if (PageAnon(page))
> 
> 
> @Peter, what's your thought?

IMHO they're not needed?

The rule is simple in my mind: we should only pass in a pfn-typed swap
entry into pfn_swap_entry_to_page() (or the new swp_offset_pfn()), or it's
a violation of the API.  In these two cases they do not violate the API and
they're always safe because they're guaranteed to be pfn swap entries when
calling.

Thanks,

-- 
Peter Xu

