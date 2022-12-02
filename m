Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC0640AE4
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiLBQes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiLBQep (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:34:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771CCAD9BF
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 08:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669998829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b8bI9+JmLhw8QU3ftEmY7iVkkP29bgA+9gnEtvy2G2c=;
        b=R9mz0nEnSNBnKaC/bH7gLT/EeLsK4pMSLaT36jCN8YfakLd2vyB1yF94W7toc1J9CFbBfO
        VwjofP+OaresTxFhExxHvqPdam8/RfoNjTJao73+kQxFt0rVNvSv6b7O0PWTlrmZNeO9Zb
        EhLOCs0Xy74T+RQ9ObrC3shqZxI/cgQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-Ey4LEpH3OIun6CU1OoCT-g-1; Fri, 02 Dec 2022 11:33:48 -0500
X-MC-Unique: Ey4LEpH3OIun6CU1OoCT-g-1
Received: by mail-qv1-f70.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso18000750qvb.23
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 08:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8bI9+JmLhw8QU3ftEmY7iVkkP29bgA+9gnEtvy2G2c=;
        b=oHQgiLn5p+rCpwN5sXoijT1i2q8AWPmlSTENkqR89rPtZvNSLRfOJDeHJ2FybSvvdg
         AKl3zMxC++dRGRf46n0ui7m2jqR4uAScX17inYKfPm3+7LdiiKQ1WDqib4d3cTZOjkGW
         YCL1WS+hTxHsMqpMMSgbN4NkvauVVTWPoyf1M6xOaowLThFW2fmc8VjTkjM22Z8ZVFV1
         RzoxXTxto9SQbqoGbXRgtLnT3efS7Rcs7IsyCrTUDt79cVy2slQG0+oExZdgi0CTJGx0
         w9bPTvWoc3Wu4db7AXwB6LlnzHhEPD38fO4yEjYDKjg0pQI3pqgOZI4S/s/tWKpt28/V
         VvjQ==
X-Gm-Message-State: ANoB5pnhlnneN07ZXovgy7uFT6vHxWCKQ006VsrNfzTujSFWYnHTomJ1
        rKLkAtphoz97nZv18BQIFvPVz2K5sZ6OlM27bbj1o54kFXAvbbVJpfXes7LNxfhzcrt30+ZJQ7m
        fHlI3IQCdprobCEp0
X-Received: by 2002:a05:620a:cef:b0:6fc:a666:bed6 with SMTP id c15-20020a05620a0cef00b006fca666bed6mr7293183qkj.10.1669998827561;
        Fri, 02 Dec 2022 08:33:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4u5pooV0x8XDVoQw1pqDk5zndpZbrwZXPle+Wm6P3OUgsFrG0Ys4YI1unFFeUobxCICzZB1A==
X-Received: by 2002:a05:620a:cef:b0:6fc:a666:bed6 with SMTP id c15-20020a05620a0cef00b006fca666bed6mr7293157qkj.10.1669998827220;
        Fri, 02 Dec 2022 08:33:47 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id o6-20020ac85546000000b003a69225c2cdsm2874748qtr.56.2022.12.02.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:33:46 -0800 (PST)
Date:   Fri, 2 Dec 2022 11:33:45 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
Message-ID: <Y4oo6cN1a4Yz5prh@x1n>
References: <20221202122748.113774-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202122748.113774-1-david@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 01:27:48PM +0100, David Hildenbrand wrote:
> Currently, we don't enable writenotify when enabling userfaultfd-wp on
> a shared writable mapping (for now we only support SHMEM). The consequence

and hugetlbfs

> is that vma->vm_page_prot will still include write permissions, to be set
> as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
> page migration, ...).

The thing is by default I think we want the write bit..

The simple example is (1) register UFFD_WP on shmem writable, (2) write a
page.  Here we didn't wr-protect anything, so we want the write bit there.

Or the other example is when UFFDIO_COPY with flags==0 even if with
VM_UFFD_WP.  We definitely wants the write bit.

We only doesn't want the write bit when uffd-wp is explicitly set.

I think fundamentally the core is uffd-wp is pte-based, so the information
resides in pte not vma.  I'm not strongly objecting this patch, especially
you mentioned auto-numa so I need to have a closer look later there.
However I do think uffd-wp is slightly special because we always need to
consider pte information anyway, so a per-vma information doesn't hugely
help, IMHO.

> 
> This is problematic for uffd-wp: we'd have to manually check for
> a uffd-wp PTE and manually write-protect that PTE, which is error prone
> and the logic is the wrong way around. Prone to such issues is any code
> that uses vma->vm_page_prot to set PTE permissions: primarily pte_modify()
> and mk_pte(), but there might be more (move_pte() looked suspicious at
> first but the protection parameter is essentially unused).
> 
> Instead, let's enable writenotify -- just like we do for softdirty
> tracking -- such that PTEs will be mapped write-protected as default
> and we will only allow selected PTEs that are defintly safe to be
> mapped without write-protection (see can_change_pte_writable()) to be
> writable. This reverses the logic and implicitly fixes and prevents any
> such uffd-wp issues.
> 
> Note that when enabling userfaultfd-wp, there is no need to walk page
> tables to enforce the new default protection for the PTEs: we know that
> they cannot be uffd-wp'ed yet, because that can only happen afterwards.
> 
> For example, this fixes page migration and mprotect() to not map a
> uffd-wp'ed PTE writable. In theory, this should also fix when NUMA-hinting
> remaps pages in such (shmem) mappings -- if NUMA-hinting is applicable to
> shmem with uffd as well.
> 
> Running the mprotect() reproducer [1] without this commit:
>   $ ./uffd-wp-mprotect
>   FAIL: uffd-wp did not fire
> Running the mprotect() reproducer with this commit:
>   $ ./uffd-wp-mprotect
>   PASS: uffd-wp fired
> 
> [1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u

I still hope for a formal patch (non-rfc) we can have a reproducer outside
mprotect().  IMHO mprotect() is really ambiguously here being used with
uffd-wp, so not a good example IMO as I explained in the other thread [1].

I'll need to off-work most of the rest of today, but maybe I can also have
a look in the weekend or Monday more on the numa paths.  Before that, can
we first reach a consensus that we have the mm/migrate patch there to be
merged first?  These are two issues, IMHO.

I know you're against me for some reason, but until now I sincerely don't
know why.  That patch sololy recovers write bit status (by removing it for
read-only) for a migration entry and that definitely makes sense to me.  As
I also mentioned in the old version of that thread, we can rework migration
entries and merge READ|WRITE entries into a GENERIC entry one day if you
think proper, but that's for later.

Let me provide another example why I think recovering write bit may matter
outside uffd too so it's common and it's always good to explicit check it.

If you still remember for sparc64 (I think you're also in the loop)
pte_mkdirty will also apply write bit there; even though I don't know why
but it works like that for years.  Consider below sequence:

  - map a page writable, write to page (fault in, set dirty)
  - mprotect(RO) on the page (keep dirty bit, vma/pte becomes RO)
  - migrate the page
    - mk_pte returns with WRITE bit cleared (which is correct)
    - pte_mkdirty set dirty and write bit (because dirty used to set)

If without the previous mm/migrate patch [1] IIUC it'll allow the pte
writable even without VM_WRITE here after migration.

I'm not sure whether I missed something, nor can I write a reproducer
because I don't have sparc64 systems on hand, not to mention time.  But
hopefully I explained why I think it's safer to just always double check on
the write bit to be the same as when before migration, irrelevant of
uffd-wp, vma pgprot or mk_pte().

For this patch itself, I'll rethink again when I read more on numa.

Thanks,

> 
> Reported-by: Ives van Hoorne <ives@codesandbox.io>
> Debugged-by: Peter Xu <peterx@redhat.com>
> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
> 
> Based on latest upstream. userfaultfd selftests seem to pass.
> 
> ---
>  fs/userfaultfd.c | 28 ++++++++++++++++++++++------
>  mm/mmap.c        |  4 ++++
>  2 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 98ac37e34e3d..fb0733f2e623 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -108,6 +108,21 @@ static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
>  	return ctx->features & UFFD_FEATURE_INITIALIZED;
>  }
>  
> +static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
> +				     vm_flags_t flags)
> +{
> +	const bool uffd_wp = !!((vma->vm_flags | flags) & VM_UFFD_WP);
> +
> +	vma->vm_flags = flags;
> +	/*
> +	 * For shared mappings, we want to enable writenotify while
> +	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
> +	 * recalculate vma->vm_page_prot whenever userfaultfd-wp is involved.
> +	 */
> +	if ((vma->vm_flags & VM_SHARED) && uffd_wp)
> +		vma_set_page_prot(vma);
> +}
> +
>  static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
>  				     int wake_flags, void *key)
>  {
> @@ -618,7 +633,8 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
>  		for_each_vma(vmi, vma) {
>  			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
>  				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
> -				vma->vm_flags &= ~__VM_UFFD_FLAGS;
> +				userfaultfd_set_vm_flags(vma,
> +							 vma->vm_flags & ~__VM_UFFD_FLAGS);
>  			}
>  		}
>  		mmap_write_unlock(mm);
> @@ -652,7 +668,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
>  	octx = vma->vm_userfaultfd_ctx.ctx;
>  	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
>  		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
> -		vma->vm_flags &= ~__VM_UFFD_FLAGS;
> +		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
>  		return 0;
>  	}
>  
> @@ -733,7 +749,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
>  	} else {
>  		/* Drop uffd context if remap feature not enabled */
>  		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
> -		vma->vm_flags &= ~__VM_UFFD_FLAGS;
> +		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
>  	}
>  }
>  
> @@ -895,7 +911,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
>  			prev = vma;
>  		}
>  
> -		vma->vm_flags = new_flags;
> +		userfaultfd_set_vm_flags(vma, new_flags);
>  		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
>  	}
>  	mmap_write_unlock(mm);
> @@ -1463,7 +1479,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * the next vma was merged into the current one and
>  		 * the current one has not been updated yet.
>  		 */
> -		vma->vm_flags = new_flags;
> +		userfaultfd_set_vm_flags(vma, new_flags);
>  		vma->vm_userfaultfd_ctx.ctx = ctx;
>  
>  		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
> @@ -1651,7 +1667,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		 * the next vma was merged into the current one and
>  		 * the current one has not been updated yet.
>  		 */
> -		vma->vm_flags = new_flags;
> +		userfaultfd_set_vm_flags(vma, new_flags);
>  		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
>  
>  	skip:
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 74a84eb33b90..ce7526aa5d61 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1525,6 +1525,10 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>  	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
>  		return 1;
>  
> +	/* Do we need write faults for uffd-wp tracking? */
> +	if (userfaultfd_wp(vma))
> +		return 1;
> +
>  	/* Specialty mapping? */
>  	if (vm_flags & VM_PFNMAP)
>  		return 0;
> 
> base-commit: a4412fdd49dc011bcc2c0d81ac4cab7457092650
> -- 
> 2.38.1
> 

-- 
Peter Xu

