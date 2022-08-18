Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ECD598643
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiHROoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245745AbiHROow (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:44:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BBF39B93
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660833890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZlNW+boxKqgfwr0TWqSRLZOIUoJTEM6tD/36NIupE70=;
        b=eWM0kZleNy9WMT6fUahmrH5J3EhHBQP3V9TiaybrazKqb7TMvtoj/yKglHjEezEKrM4MGo
        jIrPIlwvWNECpxkdT7JgMkD7tOiPEhfC0eWFTNX1dIc7W0uTbGWlibHJeMrRGpyCaY1zLA
        oSYJ+8j98RUHwuMGaChoDGPHMwKLpZc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-ndbGINIoMkmCyer_AOg7HA-1; Thu, 18 Aug 2022 10:44:49 -0400
X-MC-Unique: ndbGINIoMkmCyer_AOg7HA-1
Received: by mail-qk1-f200.google.com with SMTP id bq19-20020a05620a469300b006bb70e293ccso1540542qkb.1
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 07:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ZlNW+boxKqgfwr0TWqSRLZOIUoJTEM6tD/36NIupE70=;
        b=yrcMDwcjH0yN/c2L64GZ8rABtN0NaYDgHEoFFNRtpXAU1EnFp3KWRXRxlhCMQsOdik
         IdjjXIo6pjo3IwgkjFO7wdy1VgS9obQg1JsNiF9QMNCX9gqMWpB7XfYu3SZ3FHJPJALc
         QLMcgz8EuOaH+HwdBTJZPAfJfMcXS/sKgncpwSSfEjxQXoJLmlSQbMPu8WISnk7oEJtf
         AVPKqvkQHVBzvxFdFLJY0PXMX+KfgQot/p0LIEGEPtyqdUl3AmnTde9a2G0olfu6DJyO
         d1rZVXYfLxsrpq87BgYhNbflTtfs/rmqzYQakoEbVgRxBC6j7E2RvYEtZI7R2apWSH94
         pmuQ==
X-Gm-Message-State: ACgBeo3vRDou8Jlvrm78u6Y6/jC+tIn+Mqz2QVGXfugNFZSuPuYCNtpr
        hGsZzm0vQkKqZz031pI7lxfukU5U03Pdb8VqRHNj03O87NlRGMoQPpF58JJ8TdoRDNPs4ppDLwM
        i4xGjhYw/NrUbhdlF
X-Received: by 2002:a05:622a:1c3:b0:344:56b5:f14b with SMTP id t3-20020a05622a01c300b0034456b5f14bmr2982403qtw.152.1660833888693;
        Thu, 18 Aug 2022 07:44:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Y7IFVVzndjOAS+SeXLhYlIl9eakAp1CbXrmWdBV9kzpU04h8jW0ij46cg9iIRTWVE+UYkxA==
X-Received: by 2002:a05:622a:1c3:b0:344:56b5:f14b with SMTP id t3-20020a05622a01c300b0034456b5f14bmr2982368qtw.152.1660833888473;
        Thu, 18 Aug 2022 07:44:48 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id y10-20020a05622a120a00b003435a198849sm1216076qtx.47.2022.08.18.07.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:44:47 -0700 (PDT)
Date:   Thu, 18 Aug 2022 10:44:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
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
Message-ID: <Yv5QXkS4Bm9pTBeG@xz-m1.local>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local>
 <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 02:34:45PM +0800, Huang, Ying wrote:
> > In this specific case, the only way to do safe tlb batching in my mind is:
> >
> > 	pte_offset_map_lock();
> > 	arch_enter_lazy_mmu_mode();
> >         // If any pending tlb, do it now
> >         if (mm_tlb_flush_pending())
> > 		flush_tlb_range(vma, start, end);
> >         else
> >                 flush_tlb_batched_pending();
> 
> I don't think we need the above 4 lines.  Because we will flush TLB
> before we access the pages.

Could you elaborate?

> Can you find any issue if we don't use the above 4 lines?

It seems okay to me to leave stall tlb at least within the scope of this
function. It only collects present ptes and flush propoerly for them.  I
don't quickly see any other implications to other not touched ptes - unlike
e.g. mprotect(), there's a strong barrier of not allowing further write
after mprotect() returns.

Still I don't know whether there'll be any side effect of having stall tlbs
in !present ptes because I'm not familiar enough with the private dev swap
migration code.  But I think having them will be safe, even if redundant.

Thanks,

-- 
Peter Xu

