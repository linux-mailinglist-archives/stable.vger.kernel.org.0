Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41AA24A005
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgHSNc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgHSNcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:32:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951C8C061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 06:32:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n129so21545445qkd.6
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 06:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=5ACybnqBkP1otrE++RT4cdbyRbh+4WzelobvOAINN3k=;
        b=ti/4HnGeyYhujKq6+y1iZIS/9dQ7+O5ncJQN7vyh8BqmUIhsv6OHnr+uxAHktUu0Fn
         Er0kIGOXJ5anFH2xo72k0qYgoYblYmZFMIYWd2l5i4qena707/hhdgopdz1h8AARl0Ho
         DPPDC6PUFfBF5Nv6cFwbAWtXSKhoMi77QN3a305jSZiR4/1hWIol8VfJLsmQYFVkDe+e
         pZAqC+o4zMDe5718PWLrbbfGHXI1EAtgsRCNYkuAGUgFM1I2DCEJfvqPwiOebZDHTjya
         1eWPzW2s3odK/z/1Gbk5vXsq6i08YMDORRjgxjjw+WJUiY7LugSCuhX2estibBEF5Jbe
         ZB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=5ACybnqBkP1otrE++RT4cdbyRbh+4WzelobvOAINN3k=;
        b=keNKNY3MwIEt0gTW2XpMXzZlMWVHj7ztIAO5CKW9CTootVUVOvGtJxZIMf9E6fUIVX
         oJV5ElfWeKTuppn9e2hYRCivrXNpgA6Hcai/t+I+G794xDNP8Nml15JP3k9Ly5jUMv3p
         bOgSpKsKlPo73BLpunoHRMihFylGNIyWJcyf5Vs/H6ckcs97Q1u5NAgPasZAZBo9la9x
         N+DdrfUxXPtygcN2gVw6uni3KXDy2eHgiXv/P8u8eu+Xcs3sYmatb3LndDCAt6sYOpYA
         Vq25gfx5Ci3KQDAXtiGxa0BYlak2SlETjyBav2V1eSnQPu88SAT2+iGTceNNn8S3mTXt
         kFeg==
X-Gm-Message-State: AOAM530Hx06hbljYY1QnRsCEsZszZZB8CQAjwKO7zt/xa4F5QsBPKDly
        4A5m1c7da+5OuG+33vBVZgqh7dwvJfRZug==
X-Google-Smtp-Source: ABdhPJy0zdA/1WO2sY1gwV0aAL6SUGkVIhtsGhTKmf5Zi5UdEnST13S/SK1FCvUkqGZLGLaHT67QeQ==
X-Received: by 2002:a05:620a:166e:: with SMTP id d14mr21555316qko.25.1597843960454;
        Wed, 19 Aug 2020 06:32:40 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id t32sm28948930qtb.3.2020.08.19.06.32.37
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 19 Aug 2020 06:32:38 -0700 (PDT)
Date:   Wed, 19 Aug 2020 06:32:26 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check mmget_still_valid()"
 has been added to the 5.8-stable tree
In-Reply-To: <1597841669128213@kroah.com>
Message-ID: <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
References: <1597841669128213@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     khugepaged: khugepaged_test_exit() check mmget_still_valid()
> 
> to the 5.8-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
> and it can be found in the queue-5.8 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please hold this one back for the moment: we shall want it, but syzbot
detected one place where it can lead to a VM_BUG_ON_MM().  The fix to
that is currently in Andrew's tree, but not yet in Linus's - when it
gets there, I'll send you its git commit id in reply to this mail.

This patch failed to apply to earlier releases: I'll send the fixup for
those at that time.  (Fixups for another patch to follow later today.)

Thanks,
Hugh

> 
> 
> From bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 Mon Sep 17 00:00:00 2001
> From: Hugh Dickins <hughd@google.com>
> Date: Thu, 6 Aug 2020 23:26:25 -0700
> Subject: khugepaged: khugepaged_test_exit() check mmget_still_valid()
> 
> From: Hugh Dickins <hughd@google.com>
> 
> commit bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 upstream.
> 
> Move collapse_huge_page()'s mmget_still_valid() check into
> khugepaged_test_exit() itself.  collapse_huge_page() is used for anon THP
> only, and earned its mmget_still_valid() check because it inserts a huge
> pmd entry in place of the page table's pmd entry; whereas
> collapse_file()'s retract_page_tables() or collapse_pte_mapped_thp()
> merely clears the page table's pmd entry.  But core dumping without mmap
> lock must have been as open to mistaking a racily cleared pmd entry for a
> page table at physical page 0, as exit_mmap() was.  And we certainly have
> no interest in mapping as a THP once dumping core.
> 
> Fixes: 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page() and core dumping")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: <stable@vger.kernel.org>	[4.8+]
> Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021217020.27773@eggly.anvils
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  mm/khugepaged.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -431,7 +431,7 @@ static void insert_to_mm_slots_hash(stru
>  
>  static inline int khugepaged_test_exit(struct mm_struct *mm)
>  {
> -	return atomic_read(&mm->mm_users) == 0;
> +	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
>  }
>  
>  static bool hugepage_vma_check(struct vm_area_struct *vma,
> @@ -1100,9 +1100,6 @@ static void collapse_huge_page(struct mm
>  	 * handled by the anon_vma lock + PG_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = SCAN_ANY_PROCESS;
> -	if (!mmget_still_valid(mm))
> -		goto out;
>  	result = hugepage_vma_revalidate(mm, address, &vma);
>  	if (result)
>  		goto out;
> 
> 
> Patches currently in stable-queue which might be from hughd@google.com are
> 
> queue-5.8/khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
> queue-5.8/hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem.patch
> queue-5.8/khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
> queue-5.8/khugepaged-retract_page_tables-remember-to-test-exit.patch
> queue-5.8/khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
> 
