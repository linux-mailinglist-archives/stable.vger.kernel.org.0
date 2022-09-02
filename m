Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C25AA863
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiIBGxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiIBGxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEE8BC134
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 23:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662101594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+57PdWMxpBWbQjargyaqlxNH+Zcmno8dXbh3sZc6/c=;
        b=NSAJyKI1OzMusRWmc9xm0T7junBLWZK0BQb5u1L5PilV5/iWSLXHSRIk4rGxbMCA89aFiY
        1uObkmayh9HTYMYu457YqMOOaKnMltSEKQY+kDK5godGc8GaMw2nGMW6BGT8Q5KptkM87v
        QKsGWQl1S478qkp2kGPQPvTVMVor7Jg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-GrO9Dcz0MuSsn8xmucrSDQ-1; Fri, 02 Sep 2022 02:53:13 -0400
X-MC-Unique: GrO9Dcz0MuSsn8xmucrSDQ-1
Received: by mail-wm1-f70.google.com with SMTP id c64-20020a1c3543000000b003a61987ffb3so727868wma.6
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 23:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=h+57PdWMxpBWbQjargyaqlxNH+Zcmno8dXbh3sZc6/c=;
        b=RNhzblRrRQ97j7f1VTmOs2oJ6/Mj4DIUB9510flReTxh9na4bWOJDgyuRkSFkOMY9c
         9eirCmFI1iWkZlg/x9IxujHM0VK+/aXqOhvOdbJrU9KQ1biAaDb1kgqGI/fzw7yeUaFc
         DX5ioAfovVFaseLou48f1XlIrSYrUwjvnE/aB6XW4CWZk+43Xjm52H2ZAHUYeaPgQZkZ
         fZwzxg2qR0PufnHR0bWSA3GrPLOU6L2yvprHkARAVKeL5bZD/q60gRj5ETJ/TPDlsCPH
         Lcse7dLbltp0+opaWSWb1SCh2rrPr4KjsHiGExBW479VZ4XfspMnQyMYmQSgaCJUG2vR
         gnMQ==
X-Gm-Message-State: ACgBeo0UM7Ij0MZTZKC8+SVnRsN2aGQXOHU0XfXTIfE3dsk+ztHSH47f
        Nha4+R2UV4m2PUef3ek6erM11OOkrG4ti99Djdjwtn4rafyIULJGJ8Wxe3Kgq7pxrEAHL2htS/J
        4eTajBmkiB/yp8Cvy
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr16886153wrr.472.1662101592036;
        Thu, 01 Sep 2022 23:53:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR72FIltlXb2TQPeyqyCZoaRVMW4kclo3DOPj63oymphdPfUvZp/uulcrUG16hwS6UnSef2yNw==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr16886135wrr.472.1662101591768;
        Thu, 01 Sep 2022 23:53:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:4800:2077:1bf6:40e7:2833? (p200300cbc714480020771bf640e72833.dip0.t-ipconnect.de. [2003:cb:c714:4800:2077:1bf6:40e7:2833])
        by smtp.gmail.com with ESMTPSA id z15-20020a5d654f000000b002211fc70174sm842621wrv.99.2022.09.01.23.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 23:53:11 -0700 (PDT)
Message-ID: <2fccd4c1-d12f-334c-3fab-24a84bcac007@redhat.com>
Date:   Fri, 2 Sep 2022 08:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 3/4] mm/migrate_device.c: Copy pte dirty bit to page
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
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
        linuxppc-dev@lists.ozlabs.org,
        "Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
References: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
 <dd48e4882ce859c295c1a77612f66d198b0403f9.1662078528.git-series.apopple@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <dd48e4882ce859c295c1a77612f66d198b0403f9.1662078528.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.09.22 02:35, Alistair Popple wrote:
> migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
> installs migration entries directly if it can lock the migrating page.
> When removing a dirty pte the dirty bit is supposed to be carried over
> to the underlying page to prevent it being lost.
> 
> Currently migrate_vma_*() can only be used for private anonymous
> mappings. That means loss of the dirty bit usually doesn't result in
> data loss because these pages are typically not file-backed. However
> pages may be backed by swap storage which can result in data loss if an
> attempt is made to migrate a dirty page that doesn't yet have the
> PageDirty flag set.
> 
> In this case migration will fail due to unexpected references but the
> dirty pte bit will be lost. If the page is subsequently reclaimed data
> won't be written back to swap storage as it is considered uptodate,
> resulting in data loss if the page is subsequently accessed.
> 
> Prevent this by copying the dirty bit to the page when removing the pte
> to match what try_to_migrate_one() does.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Reported-by: "Huang, Ying" <ying.huang@intel.com>
> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Changes for v4:
> 
>  - Added Reviewed-by
> 
> Changes for v3:
> 
>  - Defer TLB flushing
>  - Split a TLB flushing fix into a separate change.
> 
> Changes for v2:
> 
>  - Fixed up Reported-by tag.
>  - Added Peter's Acked-by.
>  - Atomically read and clear the pte to prevent the dirty bit getting
>    set after reading it.
>  - Added fixes tag
> ---
>  mm/migrate_device.c |  9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 4cc849c..dbf6c7a 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -7,6 +7,7 @@
>  #include <linux/export.h>
>  #include <linux/memremap.h>
>  #include <linux/migrate.h>
> +#include <linux/mm.h>
>  #include <linux/mm_inline.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/oom.h>
> @@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			flush_cache_page(vma, addr, pte_pfn(*ptep));
>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>  			if (anon_exclusive) {
> -				ptep_clear_flush(vma, addr, ptep);
> +				pte = ptep_clear_flush(vma, addr, ptep);
>  
>  				if (page_try_share_anon_rmap(page)) {
>  					set_pte_at(mm, addr, ptep, pte);
> @@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					goto next;
>  				}
>  			} else {
> -				ptep_get_and_clear(mm, addr, ptep);
> +				pte = ptep_get_and_clear(mm, addr, ptep);
>  			}
>  
>  			migrate->cpages++;
>  
> +			/* Set the dirty flag on the folio now the pte is gone. */
> +			if (pte_dirty(pte))
> +				folio_mark_dirty(page_folio(page));
> +
>  			/* Setup special migration page table entry */
>  			if (mpfn & MIGRATE_PFN_WRITE)
>  				entry = make_writable_migration_entry(


This matches what we do in try_to_unmap_one()

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

