Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B72616DC6
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 20:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiKBTZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKBTZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 15:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F86E9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667417049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OnGbVU+pdLQrWU/4yKB9jRj3Qh2itknh7OkU6ci+FdA=;
        b=XNb06Dt4TYIrucqq5jXHrUhyC7N4it+zLR+BzctHrHmlPWdTyYKsv6/+/v7D8g/hdtK8a4
        WSfuHbu7tqBgjSz7seLp4XDhINsM7mNTSdN/Ho09IEvxHgknJNiCHXAsbY389OqOYfj07W
        Dg23g1WsmKaZAprUBarVBELA2kvmdWw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-1SHQ61deOtmI4Slmzk3WFw-1; Wed, 02 Nov 2022 15:24:08 -0400
X-MC-Unique: 1SHQ61deOtmI4Slmzk3WFw-1
Received: by mail-qv1-f71.google.com with SMTP id 71-20020a0c804d000000b004b2fb260447so10600856qva.10
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 12:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnGbVU+pdLQrWU/4yKB9jRj3Qh2itknh7OkU6ci+FdA=;
        b=1S4aMfk47L1A4YMlI/2qFIMb/gj1wTI4AUbbcFu91zPz436Xzh2GhM6n1LxB74jt3J
         BAMkChxXHTmK7butosqOWhyozph70C/Uhr8T27HtAxTYu03cu8kchX2e7EWB/9J48DXX
         Xy748ZWIuYnGJeLOb0I/aRQTmEDB4yyvhm1CteGRQDH99TSI4CbZZvEGbq9e2lM/tXov
         OaW9XOx/jxtvgbYEM49GYww4SQXxRNtRCpAuJWl+uMXeezembzSfT83zfUzIK8SgJN5K
         Gf4UQY1B4E0Gq/pMGJIlqOWIR8lPzQrPVGt4nlIXn5IM6yAGRo4PsA2150sL8xwsBHyZ
         UH0Q==
X-Gm-Message-State: ACrzQf14LMGMH+BRvZKhGZseMwPSH4cAd0rJDsWF8u82Pe212FBvu897
        5uNkfBh1qf8MRfmT//msrckuGClruLbVBgpq3SKRGLd3i+IEO8lSZjPdkyTuy6gw4Tj2MKmoP+Z
        1/tgVNXMZDtl+MZPq
X-Received: by 2002:a05:622a:650:b0:39c:fa98:2de9 with SMTP id a16-20020a05622a065000b0039cfa982de9mr21087118qtb.535.1667417047834;
        Wed, 02 Nov 2022 12:24:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7uiQZAjRp0CGfRjAPj7RfUT9NoUSAoNE0Xwu/NemCkgaG2/DG20QwO4j35n5PAKhn2onbQfA==
X-Received: by 2002:a05:622a:650:b0:39c:fa98:2de9 with SMTP id a16-20020a05622a065000b0039cfa982de9mr21087096qtb.535.1667417047578;
        Wed, 02 Nov 2022 12:24:07 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id m17-20020ae9e711000000b006e42a8e9f9bsm2788884qka.121.2022.11.02.12.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:24:07 -0700 (PDT)
Date:   Wed, 2 Nov 2022 15:24:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>,
        "# 5 . 10+" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y2LD1Vxt3vbChUyD@x1n>
References: <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n>
 <Y13CO8iIGfDnV24u@monkey>
 <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
 <Y17F50ktT9fZw4do@x1n>
 <3232338E-77BB-42A8-9A25-5A4AD61FD4B2@gmail.com>
 <Y18oagswntNCEszs@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y18oagswntNCEszs@monkey>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 30, 2022 at 06:44:10PM -0700, Mike Kravetz wrote:
> On 10/30/22 11:52, Nadav Amit wrote:
> > On Oct 30, 2022, at 11:43 AM, Peter Xu <peterx@redhat.com> wrote:
> > 
> > > The loop comes from 7e027b14d53e ("vm: simplify unmap_vmas() calling
> > > convention", 2012-05-06), where zap_page_range() was used to replace a call
> > > to unmap_vmas() because the patch wanted to eliminate the zap details
> > > pointer for unmap_vmas(), which makes sense.
> > > 
> > > I didn't check the old code, but from what I can tell (and also as Mike
> > > pointed out) I don't think zap_page_range() in the lastest code base is
> > > ever used on multi-vma at all.  Otherwise the mmu notifier is already
> > > broken - see mmu_notifier_range_init() where the vma pointer is also part
> > > of the notification.
> > > 
> > > Perhaps we should just remove the loop?
> > 
> > There is already zap_page_range_single() that does exactly that. Just need
> > to export it.
> 
> I was thinking that zap_page_range() should perform a notification call for
> each vma within the loop.  Something like this?

I'm boldly guessing what Nadav suggested was using zap_page_range_single()
and export it for MADV_DONTNEED.  Hopefully that's also the easiest for
stable?

For the long term, I really think we should just get rid of the loop..

> 
> @@ -1704,15 +1704,21 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>  	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
>  
>  	lru_add_drain();
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> -				start, start + size);
>  	tlb_gather_mmu(&tlb, vma->vm_mm);
>  	update_hiwater_rss(vma->vm_mm);
> -	mmu_notifier_invalidate_range_start(&range);
>  	do {
> -		unmap_single_vma(&tlb, vma, start, range.end, NULL);
> +		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma,
> +				vma->vm_mm,
> +				max(start, vma->vm_start),
> +				min(start + size, vma->vm_end));
> +		if (is_vm_hugetlb_page(vma))
> +			adjust_range_if_pmd_sharing_possible(vma,
> +				&range.start,
> +				&range.end);
> +		mmu_notifier_invalidate_range_start(&range);
> +		unmap_single_vma(&tlb, vma, start, start + size, NULL);
> +		mmu_notifier_invalidate_range_end(&range);
>  	} while ((vma = mas_find(&mas, end - 1)) != NULL);
> -	mmu_notifier_invalidate_range_end(&range);
>  	tlb_finish_mmu(&tlb);
>  }
>  
> 
> One thing to keep in mind is that this patch is a fix that must be
> backported to stable.  Therefore, I do not think we want to add too
> many changes out of the direct scope of the fix.
> 
> We can always change things like this in follow up patches.
> -- 
> Mike Kravetz
> 

-- 
Peter Xu

