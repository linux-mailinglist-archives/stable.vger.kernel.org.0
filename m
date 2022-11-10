Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA0624C3E
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 21:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiKJU54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 15:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKJU5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 15:57:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B53245EE2
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 12:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668113814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=efgxOmrbcsO6hxCTWc8zw/N4bhgLG/VI8js+kw4ojtw=;
        b=E+Aj5pT/ZrLKAXWf+x6fuVzhMkOpQ458H8cLk9aFmNxOiPYpG903WEMjaYlL1fNcDOZ2ab
        0Uq6PtDzZU0vuRwO969mcSIqM6LK/eZaaTFsms6QlPVAvCviwCDyyOdueI+w5rdQV3Q9+R
        sJoJ/8ePYuzpHxSzq682xQyIUhJNojk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-PMVRso3SNTWJoaNIa87ieA-1; Thu, 10 Nov 2022 15:56:51 -0500
X-MC-Unique: PMVRso3SNTWJoaNIa87ieA-1
Received: by mail-qv1-f69.google.com with SMTP id h1-20020a0ceda1000000b004b899df67a4so2378274qvr.1
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 12:56:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efgxOmrbcsO6hxCTWc8zw/N4bhgLG/VI8js+kw4ojtw=;
        b=23loKAnEWeufFtNRCV73K0COI8VVRcn5UgOkLv0YykUwy58cvZcrVEj2hQ1qDyLye2
         8J7Sf0xyI8uuuzRheKSk6kpMyg6n1H7/CAPbCO4V8VTZWfbEZHX5pbLjw0xsqo9afwj9
         6DXU8mfrl8467zXMvZtF9mYIxi42VBVh6PjH7rD5D9EllnyXvGJooV+edi76YjfJnNwy
         EgnhqxeJeAlZ+A6L+PJOD1dAWSuGljqS2wIO3QJ66RhxCOVzS1SAM9wL2KfDUvBb3NtZ
         ORk0YhHIo6wjKBV46wR+6fmp9em18tZFHXe31URIUHkUTXK1+l+Gn0v3SKJkqdPpTtM8
         Yd1w==
X-Gm-Message-State: ACrzQf2whAduf5aTuqx9n2stT+neGxZ+RhbZiUo+TXu03bd45zB5BAni
        DKuLF5pV+Yhn25aU/xHZwlrBRXUZziLi6QVQG5+xtiaXe4vQEGYVfZqF0WdMe16T6NwTFE3T9Sq
        MJNwaqyKpM9YdIqVG
X-Received: by 2002:ac8:7145:0:b0:39c:bdd5:30b7 with SMTP id h5-20020ac87145000000b0039cbdd530b7mr1859979qtp.213.1668113810924;
        Thu, 10 Nov 2022 12:56:50 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7TI/Aui7PHbcCH7WK4/o+hRfeDpfr9KLaxtQZEGGBwYzrDx15N1iN9FNA/1f0Syp0iMLOZxw==
X-Received: by 2002:ac8:7145:0:b0:39c:bdd5:30b7 with SMTP id h5-20020ac87145000000b0039cbdd530b7mr1859962qtp.213.1668113810592;
        Thu, 10 Nov 2022 12:56:50 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm175654qti.38.2022.11.10.12.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:56:50 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:56:48 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y21lkEMOALb2pP89@x1n>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221108011910.350887-2-mike.kravetz@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Mike,

Sorry to be late, took me quite some time working on another bug..

On Mon, Nov 07, 2022 at 05:19:09PM -0800, Mike Kravetz wrote:
> madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
> tables associated with the address range.  For hugetlb vmas,
> zap_page_range will call __unmap_hugepage_range_final.  However,
> __unmap_hugepage_range_final assumes the passed vma is about to be removed
> and deletes the vma_lock to prevent pmd sharing as the vma is on the way
> out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
> missing vma_lock prevents pmd sharing and could potentially lead to issues
> with truncation/fault races.
> 
> This issue was originally reported here [1] as a BUG triggered in
> page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
> vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
> prevent pmd sharing.  Subsequent faults on this vma were confused as
> VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
> not set in new pages added to the page table.  This resulted in pages that
> appeared anonymous in a VM_SHARED vma and triggered the BUG.
> 
> Address issue by:
> - Add a new zap flag ZAP_FLAG_UNMAP to indicate an unmap call from
>   unmap_vmas().  This is used to indicate the 'final' unmapping of a vma.
>   When called via MADV_DONTNEED, this flag is not set and the vm_lock is
>   not deleted.
> - mmu notification is removed from __unmap_hugepage_range to avoid
>   duplication, and notification is added to the other calling routine
>   (unmap_hugepage_range).
> - notification range in zap_page_range_single is updated to take into
>   account the possibility of hugetlb pmd sharing.
> - zap_page_range_single renamed to __zap_page_range_single to be used
>   internally within mm/memory.c
> - zap_vma_range() interface created to zap a range within a single vma.
> - madvise_dontneed_single_vma is updated to call zap_vma_range instead of
>   zap_page_range as it only operates on a range within a single vma
> 
> [1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
> Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
>  include/linux/mm.h |  5 +++++
>  mm/hugetlb.c       | 45 +++++++++++++++++++++++++++------------------
>  mm/madvise.c       |  4 ++--
>  mm/memory.c        | 17 +++++++++++++----
>  4 files changed, 47 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 978c17df053e..d205bcd9cd2e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1840,6 +1840,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
>  void zap_page_range(struct vm_area_struct *vma, unsigned long address,
>  		    unsigned long size);
> +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
> +		    unsigned long size);
>  void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
>  		struct vm_area_struct *start_vma, unsigned long start,
>  		unsigned long end);
> @@ -3464,4 +3466,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
>   */
>  #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
>  
> +/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
> +#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))

It seems this is not set anywhere in the patch?

> +
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ceb47c4e183a..7c8fbce4441e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5072,7 +5072,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
>  	struct page *page;
>  	struct hstate *h = hstate_vma(vma);
>  	unsigned long sz = huge_page_size(h);
> -	struct mmu_notifier_range range;
>  	unsigned long last_addr_mask;
>  	bool force_flush = false;
>  
> @@ -5087,13 +5086,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
>  	tlb_change_page_size(tlb, sz);
>  	tlb_start_vma(tlb, vma);
>  
> -	/*
> -	 * If sharing possible, alert mmu notifiers of worst case.
> -	 */
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
> -				end);
> -	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> -	mmu_notifier_invalidate_range_start(&range);
>  	last_addr_mask = hugetlb_mask_last_page(h);
>  	address = start;
>  	for (; address < end; address += sz) {
> @@ -5178,7 +5170,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
>  		if (ref_page)
>  			break;
>  	}
> -	mmu_notifier_invalidate_range_end(&range);
>  	tlb_end_vma(tlb, vma);
>  
>  	/*
> @@ -5203,32 +5194,50 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
>  			  unsigned long end, struct page *ref_page,
>  			  zap_flags_t zap_flags)
>  {
> +	bool final = zap_flags & ZAP_FLAG_UNMAP;
> +
>  	hugetlb_vma_lock_write(vma);
>  	i_mmap_lock_write(vma->vm_file->f_mapping);
>  
>  	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
>  
>  	/*
> -	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
> -	 * the vma_lock is freed, this makes the vma ineligible for pmd
> -	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
> -	 * This is important as page tables for this unmapped range will
> -	 * be asynchrously deleted.  If the page tables are shared, there
> -	 * will be issues when accessed by someone else.
> +	 * When called via zap_vma_range (MADV_DONTNEED), this is not the
> +	 * final unmap of the vma, and we do not want to delete the vma_lock.
>  	 */
> -	__hugetlb_vma_unlock_write_free(vma);
> -
> -	i_mmap_unlock_write(vma->vm_file->f_mapping);
> +	if (final) {
> +		/*
> +		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
> +		 * When the vma_lock is freed, this makes the vma ineligible
> +		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
> +		 * pmd sharing.  This is important as page tables for this
> +		 * unmapped range will be asynchrously deleted.  If the page
> +		 * tables are shared, there will be issues when accessed by
> +		 * someone else.
> +		 */
> +		__hugetlb_vma_unlock_write_free(vma);
> +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> +	} else {
> +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> +		hugetlb_vma_unlock_write(vma);
> +	}
>  }
>  
>  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>  			  unsigned long end, struct page *ref_page,
>  			  zap_flags_t zap_flags)
>  {
> +	struct mmu_notifier_range range;
>  	struct mmu_gather tlb;
>  
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,

Should this be s/UNMAP/CLEAR/?  As IIUC the unmap path was only happening
in __unmap_hugepage_range_final().

> +				start, end);
> +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
>  	tlb_gather_mmu(&tlb, vma->vm_mm);
> +
>  	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
> +
> +	mmu_notifier_invalidate_range_end(&range);
>  	tlb_finish_mmu(&tlb);
>  }
>  
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c7105ec6d08c..9d2625b8029a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -772,7 +772,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
>   * Application no longer needs these pages.  If the pages are dirty,
>   * it's OK to just throw them away.  The app will be more careful about
>   * data it wants to keep.  Be sure to free swap resources too.  The
> - * zap_page_range call sets things up for shrink_active_list to actually free
> + * zap_vma_range call sets things up for shrink_active_list to actually free
>   * these pages later if no one else has touched them in the meantime,
>   * although we could add these pages to a global reuse list for
>   * shrink_active_list to pick up before reclaiming other pages.
> @@ -790,7 +790,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
>  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
>  					unsigned long start, unsigned long end)
>  {
> -	zap_page_range(vma, start, end - start);
> +	zap_vma_range(vma, start, end - start);

I'd rather just call zap_page_range_single() directly with NULL passed
over, considering that this is for stable, but no strong opinions.

>  	return 0;
>  }
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 6090124b64f1..af3a4724b464 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1717,7 +1717,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>  }
>  
>  /**
> - * zap_page_range_single - remove user pages in a given range
> + * __zap_page_range_single - remove user pages in a given range

Same nitpick here, I'd rather keep the name at least for this patch.  But
again, no strong opinion.

>   * @vma: vm_area_struct holding the applicable pages
>   * @address: starting address of pages to zap
>   * @size: number of bytes to zap
> @@ -1725,7 +1725,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>   *
>   * The range must fit into one VMA.
>   */
> -static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> +static void __zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size, struct zap_details *details)
>  {
>  	struct mmu_notifier_range range;
> @@ -1734,6 +1734,9 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
>  	lru_add_drain();
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
>  				address, address + size);
> +	if (is_vm_hugetlb_page(vma))
> +		adjust_range_if_pmd_sharing_possible(vma, &range.start,
> +							&range.end);
>  	tlb_gather_mmu(&tlb, vma->vm_mm);
>  	update_hiwater_rss(vma->vm_mm);
>  	mmu_notifier_invalidate_range_start(&range);
> @@ -1742,6 +1745,12 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
>  	tlb_finish_mmu(&tlb);
>  }
>  
> +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
> +		unsigned long size)
> +{
> +	__zap_page_range_single(vma, address, size, NULL);
> +}
> +
>  /**
>   * zap_vma_ptes - remove ptes mapping the vma
>   * @vma: vm_area_struct holding ptes to be zapped
> @@ -1760,7 +1769,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  	    		!(vma->vm_flags & VM_PFNMAP))
>  		return;
>  
> -	zap_page_range_single(vma, address, size, NULL);
> +	__zap_page_range_single(vma, address, size, NULL);
>  }
>  EXPORT_SYMBOL_GPL(zap_vma_ptes);
>  
> @@ -3453,7 +3462,7 @@ static void unmap_mapping_range_vma(struct vm_area_struct *vma,
>  		unsigned long start_addr, unsigned long end_addr,
>  		struct zap_details *details)
>  {
> -	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
> +	__zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
>  }
>  
>  static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
> -- 
> 2.37.3
> 
> 

-- 
Peter Xu

