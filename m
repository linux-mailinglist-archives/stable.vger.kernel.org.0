Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2C260EAEB
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 23:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJZVof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 17:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJZVoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 17:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7665FD2
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666820670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FGEAcGAjAMPOazJHa2zAyqoTgNuI6YN3F8egocsHkTg=;
        b=QRRe2g8g4WtHRoYFzOQOS+xTaKXK7V8CCHlWdbpP8z3sZrhMR8mzXol80b4HsjLyhvUrIv
        OJuGa/onh1QPPj2WFb1rxqnscC55HQGOyYIK+WphIXRLovb9KGJ4H9p7FcLUB9dEbaZdTj
        JmqH2eGSxV7/4u2hjPkw80WBML2vp78=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-2tfDMthsM8OzK0RujOTScQ-1; Wed, 26 Oct 2022 17:44:23 -0400
X-MC-Unique: 2tfDMthsM8OzK0RujOTScQ-1
Received: by mail-qk1-f199.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso14995448qkp.7
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGEAcGAjAMPOazJHa2zAyqoTgNuI6YN3F8egocsHkTg=;
        b=dm7ibzs+oH44TijrjBUTTxynC3OYL9jYktcVOOHQCJ9VnPxb2qpD/TtaHcf3BG5MhY
         RS2NDEgUeuUndGTZXJ4lglMWWzZe98p+X00/+p3dW27ulJE4D3M2wecb0HO+k/BAxcN0
         GCPF7wD7boz1s5FIdj8cSJZj3SSf4xH9xLM1nu5v90zRLBpqzuiO/5ZmZmEFKzjPDxYZ
         G9OxWJZD+ocA9Xug6Z9bXqqgTzVbcRWfdPefjPLJeUS8NPUD9aAfwK9XZN9fCq3coP9F
         qUAt3uoLAeo7qpVKUxQkRjH88DsL5+SHDiKas221CVr1Ik2b1Hhi5eK9AnFPHpgKU/Qb
         +jXA==
X-Gm-Message-State: ACrzQf1iEpLy9HQndibcRmXuFjmFH8SN3QAYzDA2a5n5xhtAafTvnOp0
        Z6x8XZax9v45JZH98vBWKU8VOmNLCmg4dgbbo54ehaAetTpOR6PHB51lLjpAPO7ENk0VmG5xHQG
        a0oK8A09FljxBeRVA
X-Received: by 2002:a37:f61d:0:b0:6ec:cafa:4741 with SMTP id y29-20020a37f61d000000b006eccafa4741mr31814344qkj.761.1666820663334;
        Wed, 26 Oct 2022 14:44:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HHTcYSpvmiPVnb/2bsgS5xXso9GWJqdZfKpadyAATz9h1MRXRKgSf2YjE5S4eVRVaZ0aPOg==
X-Received: by 2002:a37:f61d:0:b0:6ec:cafa:4741 with SMTP id y29-20020a37f61d000000b006eccafa4741mr31814329qkj.761.1666820663061;
        Wed, 26 Oct 2022 14:44:23 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bk30-20020a05620a1a1e00b006eeaf9160d6sm4644656qkb.24.2022.10.26.14.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:42:52 -0700 (PDT)
Date:   Wed, 26 Oct 2022 17:42:24 -0400
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
Message-ID: <Y1mpwKpwsiN6u6r7@x1n>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221023025047.470646-1-mike.kravetz@oracle.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Mike,

On Sat, Oct 22, 2022 at 07:50:47PM -0700, Mike Kravetz wrote:

[...]

> -void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> +static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
>  			  struct vm_area_struct *vma, unsigned long start,
>  			  unsigned long end, struct page *ref_page,
> -			  zap_flags_t zap_flags)
> +			  zap_flags_t zap_flags, bool final)
>  {
>  	hugetlb_vma_lock_write(vma);
>  	i_mmap_lock_write(vma->vm_file->f_mapping);
>  
>  	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
>  
> -	/*
> -	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
> -	 * the vma_lock is freed, this makes the vma ineligible for pmd
> -	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
> -	 * This is important as page tables for this unmapped range will
> -	 * be asynchrously deleted.  If the page tables are shared, there
> -	 * will be issues when accessed by someone else.
> -	 */
> -	__hugetlb_vma_unlock_write_free(vma);
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

Pure question: can we rely on hugetlb_vm_op_close() to destroy the hugetlb
vma lock?

I read the comment above, it seems we are trying to avoid racing with pmd
sharing, but I don't see how that could ever happen, since iiuc there
should only be two places that unmaps the vma (final==true):

  (1) munmap: we're holding write lock, so no page fault possible
  (2) exit_mmap: we've already reset current->mm so no page fault possible

> +	} else {
> +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> +		hugetlb_vma_unlock_write(vma);
> +	}
> +}
>  
> -	i_mmap_unlock_write(vma->vm_file->f_mapping);
> +void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> +			  struct vm_area_struct *vma, unsigned long start,
> +			  unsigned long end, struct page *ref_page,
> +			  zap_flags_t zap_flags)
> +{
> +	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
> +					zap_flags, true);
>  }
>  
> +#ifdef CONFIG_ADVISE_SYSCALLS
> +/*
> + * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
> + * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
> + * the associated vma_lock.
> + */
> +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
> +				unsigned long end)
> +{
> +	struct mmu_notifier_range range;
> +	struct mmu_gather tlb;
> +
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> +				start, end);

Is mmu_notifier_invalidate_range_start() missing here?

> +	tlb_gather_mmu(&tlb, vma->vm_mm);
> +	update_hiwater_rss(vma->vm_mm);
> +
> +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
> +
> +	mmu_notifier_invalidate_range_end(&range);
> +	tlb_finish_mmu(&tlb);
> +}
> +#endif
> +
>  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>  			  unsigned long end, struct page *ref_page,
>  			  zap_flags_t zap_flags)
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 2baa93ca2310..90577a669635 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
>  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
>  					unsigned long start, unsigned long end)
>  {
> -	zap_page_range(vma, start, end - start);
> +	if (!is_vm_hugetlb_page(vma))
> +		zap_page_range(vma, start, end - start);
> +	else
> +		clear_hugetlb_page_range(vma, start, end);
>  	return 0;
>  }

This does look a bit unfortunate - zap_page_range() contains yet another
is_vm_hugetlb_page() check (further down in unmap_single_vma), it can be
very confusing on which code path is really handling hugetlb.

The other mm_users check in v3 doesn't need this change, but was a bit
hackish to me, because IIUC we're clear on the call paths to trigger this
(unmap_vmas), so it seems clean to me to pass that info from the upper
stack.

Maybe we can have a new zap_flags passed into unmap_single_vma() showing
that it's destroying the vma?

Thanks,

-- 
Peter Xu

