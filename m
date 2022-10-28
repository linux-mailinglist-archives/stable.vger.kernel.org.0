Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D5611E0D
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 01:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJ1XVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 19:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJ1XVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 19:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DBD15DB24
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 16:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666999245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oYIHvTeMwIb+K7W2HGaQbire9czNW42U37FGK9GoxFo=;
        b=gzSO9j5QpoCYm4z4frElb5UaJw8BIjfNzYM5BKSK83GY2Mdy6Ami36ke5jAIGmAzkxxxxN
        0hCwz1CynwkWJglzjhWtla83XAJBw8ebiRqWZiTsW/FAy10mI+dFOFrVrrufAXv+k8+o+n
        /FMnRHuwcZzxTgcEEfGPv43bkrp4T20=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-544-H9TnJcdONSmFMVoNhqnDRg-1; Fri, 28 Oct 2022 19:20:43 -0400
X-MC-Unique: H9TnJcdONSmFMVoNhqnDRg-1
Received: by mail-qk1-f199.google.com with SMTP id v1-20020a05620a440100b006eee30cb799so4843643qkp.23
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 16:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYIHvTeMwIb+K7W2HGaQbire9czNW42U37FGK9GoxFo=;
        b=kMlwj2QL61fu69HVdGlLFGaPUKz7ivGW0adZleRnpRKRdoCdNmckO/hYdJXCqUNvX4
         1vexkUeB/MRXsz74fr8tBIu0SOUdV2Q0B2nGFpluuPiTpGVfC2qA+GJykm7axhg8g79U
         5pjjmGSnaWBVhz2drryAcFo0iswoXjjG2Usqrq+Z7uLcJW4uq0ZucDeB6SMTsL8rh6VR
         PMsaZdZD3mCX6kYyMrh+uTLAtHChMFXYo6pEO2NQjs/VwJkNyWtNlQZZYk89sg1pTqUy
         n2Qgfb6nhpILKYUOR/azTTCJQKlim1mh3a73YtN5nk+5ZnWKkYP7U2pgs5hG7O+vgQes
         MLQg==
X-Gm-Message-State: ACrzQf0R+p0RSNK5PQ6GEaxF7mB3pjM/sDSNj+X12MbaW9B4LG038ahG
        j5Y6mH592LTsWIaq7vEqrCLh7I4XFbAeQf4/0u9uc1IZRC+F+DooUjhRhIJdeFhH/E8AcvAHRHM
        vyrM/H4fy5KfpMAow
X-Received: by 2002:a05:622a:58f:b0:39d:10f3:cae4 with SMTP id c15-20020a05622a058f00b0039d10f3cae4mr1688259qtb.604.1666999242965;
        Fri, 28 Oct 2022 16:20:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ZhDbr+eJZH4OfX0v1B4vnH0cANm+KghIAOexsa39YQdBlxzfxxELs4LdzWu0JflpEcpuGsg==
X-Received: by 2002:a05:622a:58f:b0:39d:10f3:cae4 with SMTP id c15-20020a05622a058f00b0039d10f3cae4mr1688238qtb.604.1666999242725;
        Fri, 28 Oct 2022 16:20:42 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i22-20020ac871d6000000b003431446588fsm17123qtp.5.2022.10.28.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 16:20:42 -0700 (PDT)
Date:   Fri, 28 Oct 2022 19:20:40 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y1xjyLWNCK7p0XSv@x1n>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1xGzR/nHQTJxTCj@monkey>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 02:17:01PM -0700, Mike Kravetz wrote:
> On 10/28/22 12:13, Peter Xu wrote:
> > On Fri, Oct 28, 2022 at 08:23:25AM -0700, Mike Kravetz wrote:
> > > On 10/26/22 21:12, Peter Xu wrote:
> > > > On Wed, Oct 26, 2022 at 04:54:01PM -0700, Mike Kravetz wrote:
> > > > > On 10/26/22 17:42, Peter Xu wrote:
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > index c7105ec6d08c..d8b4d7e56939 100644
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> > >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> > >  					unsigned long start, unsigned long end)
> > >  {
> > > -	zap_page_range(vma, start, end - start);
> > > +	if (!is_vm_hugetlb_page(vma))
> > > +		zap_page_range(vma, start, end - start);
> > > +	else
> > > +		clear_hugetlb_page_range(vma, start, end);
> > 
> > With the new ZAP_FLAG_UNMAP flag, clear_hugetlb_page_range() can be dropped
> > completely?  As zap_page_range() won't be with ZAP_FLAG_UNMAP so we can
> > identify things?
> > 
> > IIUC that's the major reason why I thought the zap flag could be helpful..
> 
> Argh.  I went to drop clear_hugetlb_page_range() but there is one issue.
> In zap_page_range() the MMU_NOTIFY_CLEAR notifier is certainly called.
> However, we really need to have a 'adjust_range_if_pmd_sharing_possible'
> call in there because the 'range' may be part of a shared pmd.  :(
> 
> I think we need to either have a separate routine like clear_hugetlb_page_range
> that sets up the appropriate range, or special case hugetlb in zap_page_range.
> What do you think?
> I think clear_hugetlb_page_range is the least bad of the two options.

How about special case hugetlb as you mentioned?  If I'm not wrong, it
should be 3 lines change:

---8<---
diff --git a/mm/memory.c b/mm/memory.c
index c5599a9279b1..0a1632e44571 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1706,11 +1706,13 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
        lru_add_drain();
        mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
                                start, start + size);
+       if (is_vm_hugetlb_page(vma))
+               adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
        tlb_gather_mmu(&tlb, vma->vm_mm);
        update_hiwater_rss(vma->vm_mm);
        mmu_notifier_invalidate_range_start(&range);
        do {
-               unmap_single_vma(&tlb, vma, start, range.end, NULL);
+               unmap_single_vma(&tlb, vma, start, start + size, NULL);
        } while ((vma = mas_find(&mas, end - 1)) != NULL);
        mmu_notifier_invalidate_range_end(&range);
        tlb_finish_mmu(&tlb);
---8<---

As zap_page_range() is already vma-oriented anyway.  But maybe I missed
something important?

-- 
Peter Xu

