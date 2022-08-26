Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568C55A312F
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 23:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbiHZVhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 17:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236442AbiHZVhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 17:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8994A9250
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 14:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661549836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2KrAZmGrG6kDDNuHo11ICMD83hxyjEivX/cg1A87nKw=;
        b=EnPecC5q8SQAHUon872hmOnUsn1RlcGc9qm3lacOeXIazl3V03awvtkB1UXwHHgolRbPxN
        jR2ebRfH0KmOjixb1ij0OqfQRSWFCUlXQQqWrubLim5MlkEzha7DZTTuvRt4W8l2hot6Iv
        q+k7QSzwCAXHAiKpFaVYhmqJF+52sXA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-ygcZteltOeOf_8HOUDD-Lw-1; Fri, 26 Aug 2022 17:37:15 -0400
X-MC-Unique: ygcZteltOeOf_8HOUDD-Lw-1
Received: by mail-qk1-f199.google.com with SMTP id f1-20020a05620a280100b006bc4966f463so2196152qkp.4
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 14:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=2KrAZmGrG6kDDNuHo11ICMD83hxyjEivX/cg1A87nKw=;
        b=nbZlwpnPDZ5Kq6jJu3ID12zPclcbra+zopjaD4M3/h0N694YHiGIM+B7cy+8vwY4Yy
         5FUCfU5pIwIIxg4RcHo6QZcVBCLmikCDLCaHHhST5Ls9S0yEwfYjY3YkVwcpFptrXGMl
         /npHh4PZ9cAL2IlB8GVEgdYcoD2CDMNe+2pYQM29W34Mte4GS/dO3+tUdixfOy2vyjti
         A8d3sb7HJ+8TIhcZt1UkJS3QLiK99+JZPe8+7lzLRideKwZZ0HduKPdNxr3nc4cKQxka
         dqEnh7EgAePaoLAjSTF9k/PP2TVdG65kCy1Wasc0MG9aSLxpYx1FEwycqpyjGk9Gv8nJ
         6j7w==
X-Gm-Message-State: ACgBeo2H9vXgn8BcnRwRGo69L+Z4R6V4BTVIX/61JZnT6xBIBdsqrT38
        /JdAeiAEtvfZ1/+JET/5b/DIQg+lP4YzZFJB8Mhix0H2NKmlZ0M5nCmH9y0r94B2oQtMziuvGTa
        BIxvXSaRBHuf9hKXG
X-Received: by 2002:a05:6214:e6c:b0:476:a4bd:2b95 with SMTP id jz12-20020a0562140e6c00b00476a4bd2b95mr1312586qvb.25.1661549835126;
        Fri, 26 Aug 2022 14:37:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR53is4ixbz7h41Wx5XIm184jiaZL8HsGwhTwAJEHRIbbpDPLRMqX963knWH+clH/uGR3aknhA==
X-Received: by 2002:a05:6214:e6c:b0:476:a4bd:2b95 with SMTP id jz12-20020a0562140e6c00b00476a4bd2b95mr1312571qvb.25.1661549834906;
        Fri, 26 Aug 2022 14:37:14 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id h1-20020a05620a400100b006bbe7ded98csm554339qko.112.2022.08.26.14.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 14:37:14 -0700 (PDT)
Date:   Fri, 26 Aug 2022 17:37:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <Ywk9CKIJMX3z6WIq@xz-m1.local>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local>
 <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local>
 <8735dj7qwb.fsf@nvdebian.thelocal>
 <YwjZamk4n/dz+Y/M@xz-m1.local>
 <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
 <Ywjs/i4kIVlxZwpb@xz-m1.local>
 <140e7688-b66d-2f6d-fed8-e39da5045420@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <140e7688-b66d-2f6d-fed8-e39da5045420@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 26, 2022 at 06:46:02PM +0200, David Hildenbrand wrote:
> On 26.08.22 17:55, Peter Xu wrote:
> > On Fri, Aug 26, 2022 at 04:47:22PM +0200, David Hildenbrand wrote:
> >>> To me anon exclusive only shows this mm exclusively owns this page. I
> >>> didn't quickly figure out why that requires different handling on tlb
> >>> flushs.  Did I perhaps miss something?
> >>
> >> GUP-fast is the magic bit, we have to make sure that we won't see new
> >> GUP pins, thus the TLB flush.
> >>
> >> include/linux/mm.h:gup_must_unshare() contains documentation.
> > 
> > Hmm.. Shouldn't ptep_get_and_clear() (e.g., xchg() on x86_64) already
> > guarantees that no other process/thread will see this pte anymore
> > afterwards?
> 
> You could have a GUP-fast thread that just looked up the PTE and is
> going to pin the page afterwards, after the ptep_get_and_clear()
> returned. You'll have to wait until that thread finished.

IIUC the early tlb flush won't protect concurrent fast-gup from happening,
but I think it's safe because fast-gup will check pte after pinning, so
either:

  (1) fast-gup runs before ptep_get_and_clear(), then
      page_try_share_anon_rmap() will fail properly, or,

  (2) fast-gup runs during or after ptep_get_and_clear(), then fast-gup
      will see that either the pte is none or changed, then it'll fail the
      fast-gup itself.

> 
> Another user that relies on this interaction between GUP-fast and TLB
> flushing is for example mm/ksm.c:write_protect_page()
> 
> There is a comment in there explaining the interaction a bit more detailed.
> 
> Maybe we'll be able to handle this differently in the future (maybe once
> this turns out to be an actual performance problem). Unfortunately,
> mm->write_protect_seq isn't easily usable because we'd need have to make
> sure we're the exclusive writer.
> 
> 
> For now, it's not too complicated. For PTEs:
> * try_to_migrate_one() already uses ptep_clear_flush().
> * try_to_unmap_one() already conditionally used ptep_clear_flush().
> * migrate_vma_collect_pmd() was the one case that didn't use it already
>  (and I wonder why it's different than try_to_migrate_one()).

I'm not sure whether I fully get the point, but here one major difference
is all the rest handles one page, so a tlb flush alongside with the pte
clear sounds reasonable.  Even if so try_to_unmap_one() was modified to use
tlb batching, but then I see that anon exclusive made that batching
conditional.  I also have question there on whether we can keep using the
tlb batching even with anon exclusive pages there.

In general, I still don't see how stall tlb could affect anon exclusive
pages on racing with fast-gup, because the only side effect of a stall tlb
is unwanted page update iiuc, the problem is fast-gup doesn't even use tlb,
afaict..

Thanks,

-- 
Peter Xu

