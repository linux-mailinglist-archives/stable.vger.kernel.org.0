Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C52500A1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHXPNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgHXPMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 11:12:37 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585DAC061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 08:12:36 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z195so5511838oia.6
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=bSji5JZCegRkT3ZpcPstTc7w+6yt/fUtFHwOFLNiuws=;
        b=VgN3MX86Yr+A7Oc3iasj9KTt5bh3IeKYrQ6I2/CMACGJzhjOTyLb3/LftUVFgJekSD
         GrYDUbLhCgt3heyvAM6vIIc101E+3FHpFgvknXp2WtPWhsnc+qK/mnAAQ0JxeVLaNwwn
         /fqFwQ6wkjpFJueFVAy9G71lMkqfU28Rh0TU/XWZTdtYnBpQ2zPqK0bOGTJsygmdECDW
         k10xWvL60DFy6Y3fyI6cpb50ow7XNJ6UtB1LKggVMCh4RIglwSPrH0np3WQfmafSvzwV
         wW2UXT41iT6kLbjXlwOhVbII+LrHbC6vtNEiHWeScNoLdNkUhj7vGO+e6jV4r+jl1UfO
         Fb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=bSji5JZCegRkT3ZpcPstTc7w+6yt/fUtFHwOFLNiuws=;
        b=SW09e2/NhvO7Mf39dk+8fcIRp1ufORq/LPhyCYX+nOsD3BzEtJE1R+bx6FNmwpbTmt
         MgAVPXLdKkeHJNlkkyc1hNhcq6Vfk5Mb+ee7Lg69s3d+u5BCvAr0t4gVHli5RSxY9uCr
         9zkB1botyM80gxBu4N+gcS/Tp7w7R0X5Ilen0WcQFwYkPI55Kvg2wRvVVv+EN86VCvLx
         JmiY9RxKkpyTuLSaYs7kngc5B5pMDdwV/OqcYRWnrDTtrwVzwwoFrSSwWgnWG/cF+iHz
         wJQnjdvH02OlvJCTvaBJ5b6DYPpeU/izo0XjJCcoh/+3/BZw5Fq1VJ2e8SQkzZ+aK2jF
         QFcA==
X-Gm-Message-State: AOAM533UUfv7M1nPFvSK08MO5ZUNnm8GmqRhdYzztdeZYB9BI5K7xsH/
        2obR4w/6nDhqCUD6bP9/MQafVQ==
X-Google-Smtp-Source: ABdhPJwWqXK0u8VxSO0x2XfRFpFVAboth/zmuOAg/R/5pNH/mW1fIRvh9Z228ob59m8nuHLb+jHT4A==
X-Received: by 2002:aca:3d44:: with SMTP id k65mr2529805oia.149.1598281955448;
        Mon, 24 Aug 2020 08:12:35 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q7sm2076436otf.25.2020.08.24.08.12.33
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 24 Aug 2020 08:12:34 -0700 (PDT)
Date:   Mon, 24 Aug 2020 08:12:20 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     Sasha Levin <sashal@kernel.org>, Hugh Dickins <hughd@google.com>,
        aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check mmget_still_valid()"
 has been added to the 5.8-stable tree
In-Reply-To: <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
Message-ID: <alpine.LSU.2.11.2008240758110.2486@eggly.anvils>
References: <1597841669128213@kroah.com> <alpine.LSU.2.11.2008190625060.24442@eggly.anvils> <20200819135306.GA3311904@kroah.com> <alpine.LSU.2.11.2008211739460.9564@eggly.anvils> <20200822212053.GE8670@sasha-vm>
 <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 22 Aug 2020, Hugh Dickins wrote:
> On Sat, 22 Aug 2020, Sasha Levin wrote:
> > 
> > I've followed your instructions and backported the patches:
> > 
> > bbe98f9cadff ("khugepaged: khugepaged_test_exit() check
> > mmget_still_valid()") - to all branches.
> > f3f99d63a815 ("khugepaged: adjust VM_BUG_ON_MM() in
> > __khugepaged_enter()") - to all branches.
> > 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page()
> > and core dumping") - for 4.4.
> 
> That's saved me time, thanks a lot for doing that work, Sasha.
> 
> I've checked the results (haha, read on) and they're all fine,
> but one minor flaw in bisectability: the added 4.4 backport of
> "coredump: fix race condition..." adds a line (deleted by the next commit)
> 	result = SCAN_ANY_PROCESS;
> but neither "result" nor "SCAN_ANY_PROCESS" is defined in that tree,
> so that intermediate step would generate an easily fixed build error.
> 
> FWIW - I don't know whether that's something to care about or not.

Ah, but I missed that this one that we originally held back from 5.8,
did not in fact get re-added to 5.8: all the backport series have it,
but today's 5.8.4-rc1 does not have it.

That's not a disaster - the series builds without it, and having its
fix without the fixed commit is just odd, no more unsafe than before;
but it should be re-added for a 5.8.4-rc2 or 5.8.5.

Thanks,
Hugh

From bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 6 Aug 2020 23:26:25 -0700
Subject: khugepaged: khugepaged_test_exit() check mmget_still_valid()

From: Hugh Dickins <hughd@google.com>

commit bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 upstream.

Move collapse_huge_page()'s mmget_still_valid() check into
khugepaged_test_exit() itself.  collapse_huge_page() is used for anon THP
only, and earned its mmget_still_valid() check because it inserts a huge
pmd entry in place of the page table's pmd entry; whereas
collapse_file()'s retract_page_tables() or collapse_pte_mapped_thp()
merely clears the page table's pmd entry.  But core dumping without mmap
lock must have been as open to mistaking a racily cleared pmd entry for a
page table at physical page 0, as exit_mmap() was.  And we certainly have
no interest in mapping as a THP once dumping core.

Fixes: 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page() and core dumping")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021217020.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -431,7 +431,7 @@ static void insert_to_mm_slots_hash(stru
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0;
+	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
 }
 
 static bool hugepage_vma_check(struct vm_area_struct *vma,
@@ -1100,9 +1100,6 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	mmap_write_lock(mm);
-	result = SCAN_ANY_PROCESS;
-	if (!mmget_still_valid(mm))
-		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
