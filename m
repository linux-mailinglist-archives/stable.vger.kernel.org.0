Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC715963BE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 22:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiHPUfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 16:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiHPUfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 16:35:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4007A6A4A7
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660682108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qNWq56WcsAjV+d0DPWCWS43jEIePhWAAvwxxzNI+Yo=;
        b=PWUm55nNMex+zZxNub8oYd4hNMtzeQlNKTqQ1YjiwanSyO4hGdn5lKRA1ornHk/FsGXZBk
        kzRa2+2LZaz6Bb3Pssjnk6pxQaqf/1jM96Inrx+Hd4bdQXaBmyH8w3E2nzSa/owEWSVW2m
        swhjEbwVNDSA1eaPiHw7EBj0HY3cYUw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-584-xMaaGHSZPpmScKyBTXTs7A-1; Tue, 16 Aug 2022 16:35:07 -0400
X-MC-Unique: xMaaGHSZPpmScKyBTXTs7A-1
Received: by mail-qv1-f69.google.com with SMTP id o16-20020a0cecd0000000b0049656c32564so544383qvq.19
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 13:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8qNWq56WcsAjV+d0DPWCWS43jEIePhWAAvwxxzNI+Yo=;
        b=fNorGp5KUbv0EhMXUKxMLB0YT2eyYHKCkmFbgoSFpsbdwQ4nKA9PutThdbmJQBLfLn
         0wVImjbM5hZmGn41G8fSNuH8N/O7QpHfrwO57jNNlVFjEyVhmPqZcto78nKwkPop9VQ5
         uAW2UrNr7CdnvKmYL/YpRlqWFW5nZ8/CtIp+hpt/hF45lcXDk4YlRPzQHduUyBP8SczH
         F5nBCgkt3AcNu8Tu2dPXVMTMAa6QsYHfYIFi45BcbolU/jcX80p7B5sMW3l9bzXFwdOX
         qeWmWG0oD2sVi8Tw6M7pIlu1Vm8kf1L+cYWLIeVb+40gOXTqd95QOCYeEKed1gdWzdSu
         s5FQ==
X-Gm-Message-State: ACgBeo3fW/D7ZHQfSIiPjS76GrJ8qYdLfteXDy4dE4hXC9NuF8FFOhUJ
        1k6JzZgcfXR63D6wahT3T08YPpKizG1ah2AIw+H6wXep3/7bSQgc0S46fMjG415i7BUmeKtOFNY
        Xu4ogEW1Qd1b2ymTS
X-Received: by 2002:a05:6214:2aa2:b0:477:1882:3dc with SMTP id js2-20020a0562142aa200b00477188203dcmr19064879qvb.11.1660682106686;
        Tue, 16 Aug 2022 13:35:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6sxNDlfRThn/rIz3JOnzmI+jYq7VbHmqoYMTVRKckqHUaSQxZWhXW5hA43Dz2DbrziOS2X+w==
X-Received: by 2002:a05:6214:2aa2:b0:477:1882:3dc with SMTP id js2-20020a0562142aa200b00477188203dcmr19064852qvb.11.1660682106470;
        Tue, 16 Aug 2022 13:35:06 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id l1-20020a05620a28c100b006b958c34bf1sm3222130qkp.10.2022.08.16.13.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:35:05 -0700 (PDT)
Date:   Tue, 16 Aug 2022 16:35:04 -0400
From:   Peter Xu <peterx@redhat.com>
To:     huang ying <huang.ying.caritas@gmail.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
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
        linuxppc-dev@lists.ozlabs.org, Huang Ying <ying.huang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <Yvv/eGfi3LW8WxPZ@xz-m1.local>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
> > @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >                         bool anon_exclusive;
> >                         pte_t swp_pte;
> >
> > +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
> > +                       pte = ptep_clear_flush(vma, addr, ptep);
> 
> Although I think it's possible to batch the TLB flushing just before
> unlocking PTL.  The current code looks correct.

If we're with unconditionally ptep_clear_flush(), does it mean we should
probably drop the "unmapped" and the last flush_tlb_range() already since
they'll be redundant?

If that'll need to be dropped, it looks indeed better to still keep the
batch to me but just move it earlier (before unlock iiuc then it'll be
safe), then we can keep using ptep_get_and_clear() afaiu but keep "pte"
updated.

Thanks,

-- 
Peter Xu

