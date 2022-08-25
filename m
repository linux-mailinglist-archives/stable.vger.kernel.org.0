Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252285A1D31
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 01:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244587AbiHYX2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244702AbiHYX17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 19:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2DC88B1
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 16:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661470025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8enL1rrDOi/OnKgKQtLA4H9w0YLjxz1gjz5XS9Gs15s=;
        b=M1hVWOlsvq1j2GIc0btdqc0HE0iTP8cXAD0scUUmplMh6heRGndTO9OnFjlAWiY4dbVbhN
        6yNQBJRjcjZ2G7U8jaiqEP59ws40DzmwvptIdiBSpzbL+DNOVDqloQ9/xks34THPfHGHFW
        /g4ddDwz5Gmllx3CPwGvyMfwYbFrBS4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-444-Tt6XXT2pPw-2BerG1L5tRQ-1; Thu, 25 Aug 2022 19:27:03 -0400
X-MC-Unique: Tt6XXT2pPw-2BerG1L5tRQ-1
Received: by mail-qt1-f197.google.com with SMTP id v5-20020ac873c5000000b003434ef0a8c7so95636qtp.21
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 16:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8enL1rrDOi/OnKgKQtLA4H9w0YLjxz1gjz5XS9Gs15s=;
        b=ueFWNyU4gKHESgt/BsergkSOF6qUFmTOjD49/1qT7lO5JjoFLiA1tAY30t96X0BmqT
         xO6snQNRx6F6yqcMUCZfP44OpqsSEudDks8Dg4BnhFr5SwGQN1MMwcu78WeVQFy5gjDQ
         +zRBiNMrL+beBOkwrFsz1NpUYwybXdhClNd1DFNCLpfofMMl8GqsCfJZzb6IhQYhmIs0
         CwEmQzyUs+/j1Brt3uUXHNmXQKYu1M16sWAvsCDUTitmzpkhgEc10CQjya/LzUaDak0D
         QTTVkJXelk1pJA8hgSJtdOjWCGbNYYAdVGlo33r1BbUVfPOY4RqSI6scneSnHWh74ScY
         +o0Q==
X-Gm-Message-State: ACgBeo1HDncCOmAWcjxKExhz0Dm7zJNSp3OOwnt0av6y351hyMaAg4b7
        dWneA6Nl8s7rNxhqNKOWpJ/LxHqb+LH9X757KV6fzQnYKlHlrX4kU65TQjCsezNzUSCm/MWXo7U
        Lm6d5+deFtgI4Wj1e
X-Received: by 2002:a05:620a:1111:b0:6bb:604e:9d3d with SMTP id o17-20020a05620a111100b006bb604e9d3dmr4747564qkk.61.1661470023166;
        Thu, 25 Aug 2022 16:27:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7yqCUTQPAFxdfqhgCoZWa8dIEgb2UAHgMekDc93LYhHe8Ujqd1dkT+XYo5GK51eAd882LClw==
X-Received: by 2002:a05:620a:1111:b0:6bb:604e:9d3d with SMTP id o17-20020a05620a111100b006bb604e9d3dmr4747543qkk.61.1661470022876;
        Thu, 25 Aug 2022 16:27:02 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id u13-20020a05620a0c4d00b006b9c6d590fasm704728qki.61.2022.08.25.16.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:27:02 -0700 (PDT)
Date:   Thu, 25 Aug 2022 19:27:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
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
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <YwgFRLn43+U/hxwt@xz-m1.local>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local>
 <8735dkeyyg.fsf@nvdebian.thelocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8735dkeyyg.fsf@nvdebian.thelocal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 26, 2022 at 08:21:44AM +1000, Alistair Popple wrote:
> 
> Peter Xu <peterx@redhat.com> writes:
> 
> > On Wed, Aug 24, 2022 at 01:03:38PM +1000, Alistair Popple wrote:
> >> migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
> >> installs migration entries directly if it can lock the migrating page.
> >> When removing a dirty pte the dirty bit is supposed to be carried over
> >> to the underlying page to prevent it being lost.
> >>
> >> Currently migrate_vma_*() can only be used for private anonymous
> >> mappings. That means loss of the dirty bit usually doesn't result in
> >> data loss because these pages are typically not file-backed. However
> >> pages may be backed by swap storage which can result in data loss if an
> >> attempt is made to migrate a dirty page that doesn't yet have the
> >> PageDirty flag set.
> >>
> >> In this case migration will fail due to unexpected references but the
> >> dirty pte bit will be lost. If the page is subsequently reclaimed data
> >> won't be written back to swap storage as it is considered uptodate,
> >> resulting in data loss if the page is subsequently accessed.
> >>
> >> Prevent this by copying the dirty bit to the page when removing the pte
> >> to match what try_to_migrate_one() does.
> >>
> >> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> >> Acked-by: Peter Xu <peterx@redhat.com>
> >> Reported-by: Huang Ying <ying.huang@intel.com>
> >> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> >> Cc: stable@vger.kernel.org
> >>
> >> ---
> >>
> >> Changes for v3:
> >>
> >>  - Defer TLB flushing
> >>  - Split a TLB flushing fix into a separate change.
> >>
> >> Changes for v2:
> >>
> >>  - Fixed up Reported-by tag.
> >>  - Added Peter's Acked-by.
> >>  - Atomically read and clear the pte to prevent the dirty bit getting
> >>    set after reading it.
> >>  - Added fixes tag
> >> ---
> >>  mm/migrate_device.c |  9 +++++++--
> >>  1 file changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index 6a5ef9f..51d9afa 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -7,6 +7,7 @@
> >>  #include <linux/export.h>
> >>  #include <linux/memremap.h>
> >>  #include <linux/migrate.h>
> >> +#include <linux/mm.h>
> >>  #include <linux/mm_inline.h>
> >>  #include <linux/mmu_notifier.h>
> >>  #include <linux/oom.h>
> >> @@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
> >>  			if (anon_exclusive) {
> >>  				flush_cache_page(vma, addr, pte_pfn(*ptep));
> >> -				ptep_clear_flush(vma, addr, ptep);
> >> +				pte = ptep_clear_flush(vma, addr, ptep);
> >>
> >>  				if (page_try_share_anon_rmap(page)) {
> >>  					set_pte_at(mm, addr, ptep, pte);
> >> @@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  					goto next;
> >>  				}
> >>  			} else {
> >> -				ptep_get_and_clear(mm, addr, ptep);
> >> +				pte = ptep_get_and_clear(mm, addr, ptep);
> >>  			}
> >
> > I remember that in v2 both flush_cache_page() and ptep_get_and_clear() are
> > moved above the condition check so they're called unconditionally.  Could
> > you explain the rational on why it's changed back (since I think v2 was the
> > correct approach)?
> 
> Mainly because I agree with your original comments, that it would be
> better to keep the batching of TLB flushing if possible. After the
> discussion I don't think there is any issues with HW pte dirty bits
> here. There are already other cases where HW needs to get that right
> anyway (eg. zap_pte_range).

Yes tlb batching was kept, thanks for doing that way.  Though if only apply
patch 1 we'll have both ptep_clear_flush() and batched flush which seems to
be redundant.

> 
> > The other question is if we want to split the patch, would it be better to
> > move the tlb changes to patch 1, and leave the dirty bit fix in patch 2?
> 
> Isn't that already the case? Patch 1 moves the TLB flush before the PTL
> as suggested, patch 2 atomically copies the dirty bit without changing
> any TLB flushing.

IMHO it's cleaner to have patch 1 fix batch flush, replace
ptep_clear_flush() with ptep_get_and_clear() and update pte properly.

No strong opinions on the layout, but I still think we should drop the
redundant ptep_clear_flush() above, meanwhile add the flush_cache_page()
properly for !exclusive case too.

Thanks,

-- 
Peter Xu

