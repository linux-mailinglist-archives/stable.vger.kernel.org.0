Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D15A5A02A8
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbiHXUZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiHXUZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F123DBC0
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661372749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WcGllBx/E+hwvIFs2WxQDGDJChMuYQJTiL0H+5A7OM0=;
        b=TU36UDUF5tc3Y4XVjVatqgkZdgawz+vG3zQBs25yaq4wU4QkL7hTEK+s+drxT+Y6tCibRs
        nuG1MmHD0cIKaUfA6agjh+tSihzH9zGE86R51aG1o66DDqL4ZgBPELsvG5KE2GCreMQU9/
        EGlBm4kIIw+Y8zvT8Gv3LlpgAMIx+ck=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-300-RqeRlbo1OueNBtk5qUBVhA-1; Wed, 24 Aug 2022 16:25:48 -0400
X-MC-Unique: RqeRlbo1OueNBtk5qUBVhA-1
Received: by mail-qt1-f197.google.com with SMTP id i19-20020ac85e53000000b00342f05b902cso13552354qtx.7
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=WcGllBx/E+hwvIFs2WxQDGDJChMuYQJTiL0H+5A7OM0=;
        b=wf5VyZ+22fY/kOv1dZ7X3MvLVUoYuIE0jVAdRfxuOKJxYrNa4JzP6kxyI+HDKO5GiN
         QmBDZk5+GFGWC37T/LSYOlRCLZON/PEjqPEApgDTHdqXuP1+TH4GlT1/hL6N7DsdYyv1
         gj3emEmtt9INEBjZAiW6eQikjFiGNk5sAH/xofJFSPTh+6y/86fX39uIGoZzDtCiEKmE
         yS87GCvnWPic4gSyM0DvxV76cSTIqRkDFGfRnpzsDpU/cfKzTV8AN0Vfw3lenQRbZU90
         Gw8KmUFCQPNxtO/von3/fXcERjUjJNkvyMFL6fknDysdd4guOYoPnvT/ltsSvRJcO+SL
         LSxg==
X-Gm-Message-State: ACgBeo24zq1JgqcGx20/eoiBCSTRMj9Ng0JWoW1vQsJVPgnDhZUs5r/U
        wvjtuL7rdfMWsO2FSEvm8P6lUgiuTbP/joVKzaTDLyHorX5FubaUlT7Mq3GuSPWktX6CjhD4Cfe
        kJ6UH30o33iBbS3+J
X-Received: by 2002:ac8:7e83:0:b0:344:7ee0:1241 with SMTP id w3-20020ac87e83000000b003447ee01241mr889824qtj.587.1661372747558;
        Wed, 24 Aug 2022 13:25:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4At86RE03P4mlSnr4jeclId4tDLoIpgKf+KL9cAcwLzF1s7WEI2JSHt6UJKgXWx7E14+/57Q==
X-Received: by 2002:ac8:7e83:0:b0:344:7ee0:1241 with SMTP id w3-20020ac87e83000000b003447ee01241mr889808qtj.587.1661372747336;
        Wed, 24 Aug 2022 13:25:47 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id v16-20020a05620a0f1000b006b97151d2b3sm16098374qkl.67.2022.08.24.13.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 13:25:46 -0700 (PDT)
Date:   Wed, 24 Aug 2022 16:25:44 -0400
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
Message-ID: <YwaJSBnp2eyMlkjw@xz-m1.local>
References: <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87czcqiecd.fsf@nvdebian.thelocal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 11:56:25AM +1000, Alistair Popple wrote:
> >> Still I don't know whether there'll be any side effect of having stall tlbs
> >> in !present ptes because I'm not familiar enough with the private dev swap
> >> migration code.  But I think having them will be safe, even if redundant.
> 
> What side-effect were you thinking of? I don't see any issue with not
> TLB flushing stale device-private TLBs prior to the migration because
> they're not accessible anyway and shouldn't be in any TLB.

Sorry to be misleading, I never meant we must add them.  As I said it's
just that I don't know the code well so I don't know whether it's safe to
not have it.

IIUC it's about whether having stall system-ram stall tlb in other
processor would matter or not here.  E.g. some none pte that this code
collected (boosted both "cpages" and "npages" for a none pte) could have
stall tlb in other cores that makes the page writable there.

When I said I'm not familiar with the code, it's majorly about one thing I
never figured out myself, in that migrate_vma_collect_pmd() has this
optimization to trylock on the page, collect if it succeeded:

  /*
   * Optimize for the common case where page is only mapped once
   * in one process. If we can lock the page, then we can safely
   * set up a special migration page table entry now.
   */
   if (trylock_page(page)) {
          ...
   } else {
          put_page(page);
          mpfn = 0;
   }

But it's kind of against a pure "optimization" in that if trylock failed,
we'll clear the mpfn so the src[i] will be zero at last.  Then will we
directly give up on this page, or will we try to lock_page() again
somewhere?

The future unmap op is also based on this "cpages", not "npages":

	if (args->cpages)
		migrate_vma_unmap(args);

So I never figured out how this code really works.  It'll be great if you
could shed some light to it.

Thanks,

-- 
Peter Xu

