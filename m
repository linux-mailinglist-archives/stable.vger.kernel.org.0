Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF42596781
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 04:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbiHQCpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 22:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbiHQCpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 22:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD3474B90
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 19:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660704341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sFFVgLR/Ut+q9B0hkN4LXK9LXiRNRRxKcE0ZSUfZXQc=;
        b=igBR8u9IhUYcHwo5l1rjuJfd2rcU5ceZRs3Qp1ncSYfPTyixtv34Ch0k2xoMln+3l+R28N
        D31pbiAHOaXoKgMS3UVUbxJ42LFMZALnE2ySckpRILTsKugI8yMHPTxFrEEVQzt8jaVMeU
        WjvsMmQ/UqDcpZKSSQWEMcbOeqz+Vqk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-9je37BiTMHWfKcym9iwFRg-1; Tue, 16 Aug 2022 22:45:40 -0400
X-MC-Unique: 9je37BiTMHWfKcym9iwFRg-1
Received: by mail-qt1-f200.google.com with SMTP id h19-20020ac85493000000b00343408bd8e5so9589877qtq.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 19:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=sFFVgLR/Ut+q9B0hkN4LXK9LXiRNRRxKcE0ZSUfZXQc=;
        b=XT9jfbkJWhA0OP0XiXcFdS8rdamF24CkbBvO3b99zw1N74JBFAcjmuAHiKz/B/UNR9
         nefoRtvcgS327vAJllzjS9Jh2QqC2GEVwqqAXlyfepfbIU5skzlJyeK7pT9pDW1bsMzI
         /7PYEgfd8LGpchjua7joY8gNXREupUdOtKf6AddELM7QhUBHKy6vU4aoDjYWvlK6pTL8
         nJ22dv67NupKm/KnRQR5wUOJSrdMcFsI5GE+Ep5WHSVTumHVhmnvjbCVkkQAV2OLy1L8
         2IoH5HaKuHsQEBj/1zwn/fAZ+bIHqnXbULbMp4LRH+Kx7gEqIGFFf+B7Ll0qdeG2bzpJ
         /C9w==
X-Gm-Message-State: ACgBeo22dxWAQ/KZL/ortoYwuToGrh7j0Z/YXkkDMvJxBEKc99XXma9D
        XGmaTd+nNnej9XAva1Hi3o/RhdaQWkJLSQnqX0oBI0V9GGwQB/Os8xKiD8F2emZCEI6E5Y0bcsv
        raexqVpYvAQ/W2AGm
X-Received: by 2002:a37:64c3:0:b0:6ba:f404:8ff2 with SMTP id y186-20020a3764c3000000b006baf4048ff2mr12451581qkb.397.1660704339578;
        Tue, 16 Aug 2022 19:45:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ynDdWHuXl7m7xK2zUJirotuz+hRQv269GrLiXRjE8J+k1PvWsa2cxvxjorZ2Ww5yhRCP3kw==
X-Received: by 2002:a37:64c3:0:b0:6ba:f404:8ff2 with SMTP id y186-20020a3764c3000000b006baf4048ff2mr12451556qkb.397.1660704339333;
        Tue, 16 Aug 2022 19:45:39 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id w17-20020a05620a0e9100b006bb568016easm4148710qkm.116.2022.08.16.19.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 19:45:38 -0700 (PDT)
Date:   Tue, 16 Aug 2022 22:45:37 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     huang ying <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
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
Message-ID: <YvxWUY9eafFJ27ef@xz-m1.local>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local>
 <871qtfvdlw.fsf@nvdebian.thelocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <871qtfvdlw.fsf@nvdebian.thelocal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 11:49:03AM +1000, Alistair Popple wrote:
> 
> Peter Xu <peterx@redhat.com> writes:
> 
> > On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
> >> > @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >> >                         bool anon_exclusive;
> >> >                         pte_t swp_pte;
> >> >
> >> > +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
> >> > +                       pte = ptep_clear_flush(vma, addr, ptep);
> >>
> >> Although I think it's possible to batch the TLB flushing just before
> >> unlocking PTL.  The current code looks correct.
> >
> > If we're with unconditionally ptep_clear_flush(), does it mean we should
> > probably drop the "unmapped" and the last flush_tlb_range() already since
> > they'll be redundant?
> 
> This patch does that, unless I missed something?

Yes it does.  Somehow I didn't read into the real v2 patch, sorry!

> 
> > If that'll need to be dropped, it looks indeed better to still keep the
> > batch to me but just move it earlier (before unlock iiuc then it'll be
> > safe), then we can keep using ptep_get_and_clear() afaiu but keep "pte"
> > updated.
> 
> I think we would also need to check should_defer_flush(). Looking at
> try_to_unmap_one() there is this comment:
> 
> 			if (should_defer_flush(mm, flags) && !anon_exclusive) {
> 				/*
> 				 * We clear the PTE but do not flush so potentially
> 				 * a remote CPU could still be writing to the folio.
> 				 * If the entry was previously clean then the
> 				 * architecture must guarantee that a clear->dirty
> 				 * transition on a cached TLB entry is written through
> 				 * and traps if the PTE is unmapped.
> 				 */
> 
> And as I understand it we'd need the same guarantee here. Given
> try_to_migrate_one() doesn't do batched TLB flushes either I'd rather
> keep the code as consistent as possible between
> migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
> introducing TLB flushing for both in some future patch series.

should_defer_flush() is TTU-specific code?

IIUC the caller sets TTU_BATCH_FLUSH showing that tlb can be omitted since
the caller will be responsible for doing it.  In migrate_vma_collect_pmd()
iiuc we don't need that hint because it'll be flushed within the same
function but just only after the loop of modifying the ptes.  Also it'll be
with the pgtable lock held.

Indeed try_to_migrate_one() doesn't do batching either, but IMHO it's just
harder to do due to using the vma walker (e.g., the lock is released in
not_found() implicitly so iiuc it's hard to do tlb flush batching safely in
the loop of page_vma_mapped_walk).  Also that's less a concern since the
loop will only operate upon >1 ptes only if it's a thp page mapped in ptes.
OTOH migrate_vma_collect_pmd() operates on all ptes on a pmd always.

No strong opinion anyway, it's just a bit of a pity because fundamentally
this patch is removing the batching tlb flush.  I also don't know whether
there'll be observe-able perf degrade for migrate_vma_collect_pmd(),
especially on large machines.

Thanks,

-- 
Peter Xu

