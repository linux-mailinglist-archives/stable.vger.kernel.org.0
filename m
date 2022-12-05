Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18D1643688
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 22:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiLEVKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 16:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiLEVJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 16:09:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02A6FC3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 13:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670274503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZ9h4MWEriQjSU6cqdcDY6NrBbd8n2iFEddnFpDJGM4=;
        b=TN0+Y/DMGOMo17E6hB/NC3gWRlDo5Q3qppyhd8hth2fB5w5L84OckPp5TS3zKvROZK3van
        7VSNYBFf1Rgde3Xw2Qc8OrmGQw7vjcwHUbTz3AbamkiSDSYWYupGnwl/4e2zyvmRvchbgn
        4FzNcOwSqx3zjmMu0GfcLvIf22Cnq5A=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-ayX8DdzxMm2a3Upy8-m1pQ-1; Mon, 05 Dec 2022 16:08:16 -0500
X-MC-Unique: ayX8DdzxMm2a3Upy8-m1pQ-1
Received: by mail-qv1-f71.google.com with SMTP id on28-20020a056214449c00b004bbf12d7976so31499265qvb.18
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 13:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ9h4MWEriQjSU6cqdcDY6NrBbd8n2iFEddnFpDJGM4=;
        b=1FUpLihif0VyQglIaFNd7LgkPQZutjTViERfipK7OZV+688b1YntySb2nPm3Ji7L5G
         VC9BD4/C5Odo1zHT4gP4CCL2FpWZZIU0inQECRRC+zDKlgAhKO3hshVR+SFEzKIpNbJc
         EsfdvokraZxeZ+J1aPPr75rNyzz0HFJq0jEylGl5LPStE7RzMMTQk7MSMmpTznyooqvZ
         gFFw9CfNaFAiPcE/U+S8MI4/lt20Wxl9vZb5VJgJgp44sAdpOD12KpXYqGy1TIc9zI+M
         zOxVKb3/rcZSmFlNtJThOJ0r0rNB7mTcyE9683DtPYwmn/bNUCVnOtN8GRfUM5oQ9TEb
         ClBw==
X-Gm-Message-State: ANoB5pk3VYETY++1lqNtjNwwpOvUwv/zSJvkduqtlHgsGkI9HASFp38E
        PyLP8aeFkBNdGockPSLXICSegSl/Kkuksv6/XmfoOzXtV9nsfekWfoBz9g6u8mTX44xGX4CxYpB
        bIDPPX4AUOvlH4gK5
X-Received: by 2002:a05:6214:5d8b:b0:4c7:79b4:523c with SMTP id mf11-20020a0562145d8b00b004c779b4523cmr2942466qvb.45.1670274494118;
        Mon, 05 Dec 2022 13:08:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sxXU4X6JPbMzDXRVemRo9kME5rTW0DWx47Msl220IhYWiaSPOjAVrwh1RXToKz5OoRFLG3Q==
X-Received: by 2002:a05:6214:5d8b:b0:4c7:79b4:523c with SMTP id mf11-20020a0562145d8b00b004c779b4523cmr2942430qvb.45.1670274493743;
        Mon, 05 Dec 2022 13:08:13 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id dt4-20020a05620a478400b006fc9847d207sm12973263qkb.79.2022.12.05.13.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:08:13 -0800 (PST)
Date:   Mon, 5 Dec 2022 16:08:11 -0500
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
Message-ID: <Y45duzmGGUT0+u8t@x1n>
References: <20221202122748.113774-1-david@redhat.com>
 <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="q5IFF/aTDPAhV49v"
Content-Disposition: inline
In-Reply-To: <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q5IFF/aTDPAhV49v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Dec 02, 2022 at 06:11:17PM +0100, David Hildenbrand wrote:
> On 02.12.22 17:56, David Hildenbrand wrote:
> > On 02.12.22 17:33, Peter Xu wrote:
> > > On Fri, Dec 02, 2022 at 01:27:48PM +0100, David Hildenbrand wrote:
> > > > Currently, we don't enable writenotify when enabling userfaultfd-wp on
> > > > a shared writable mapping (for now we only support SHMEM). The consequence
> > > 
> > > and hugetlbfs
> > > 
> > > > is that vma->vm_page_prot will still include write permissions, to be set
> > > > as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
> > > > page migration, ...).
> > > 
> > > The thing is by default I think we want the write bit..
> > > 
> > > The simple example is (1) register UFFD_WP on shmem writable, (2) write a
> > > page.  Here we didn't wr-protect anything, so we want the write bit there.
> > > 
> > > Or the other example is when UFFDIO_COPY with flags==0 even if with
> > > VM_UFFD_WP.  We definitely wants the write bit.
> > > 
> > > We only doesn't want the write bit when uffd-wp is explicitly set.
> > > 
> > > I think fundamentally the core is uffd-wp is pte-based, so the information
> > > resides in pte not vma.  I'm not strongly objecting this patch, especially
> > > you mentioned auto-numa so I need to have a closer look later there.
> > > However I do think uffd-wp is slightly special because we always need to
> > > consider pte information anyway, so a per-vma information doesn't hugely
> > > help, IMHO.
> > 
> > That's the same as softdirty tracking, IMHO.

Soft-dirty doesn't have a bit in the pte showing whether the page is
protected.

One wr-protects in soft-dirty with either ALL or NONE.  That's per-vma.

One wr-protects in uffd-wp by wr-protect specific page or range of pages.
That's per-page.

> > 
> > [...]
> > 
> > > > Running the mprotect() reproducer [1] without this commit:
> > > >     $ ./uffd-wp-mprotect
> > > >     FAIL: uffd-wp did not fire
> > > > Running the mprotect() reproducer with this commit:
> > > >     $ ./uffd-wp-mprotect
> > > >     PASS: uffd-wp fired
> > > > 
> > > > [1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u
> > > 
> > > I still hope for a formal patch (non-rfc) we can have a reproducer outside
> > > mprotect().  IMHO mprotect() is really ambiguously here being used with
> > > uffd-wp, so not a good example IMO as I explained in the other thread [1].
> > 
> > I took the low hanging fruit to showcase that this is a more generic problem.
> > The reproducer is IMHO nice because it's simple and race-free.

If no one is using mprotect() with uffd-wp like that, then the reproducer
may not be valid - the reproducer is defining how it should work, but does
that really stand?  That's why I said it's ambiguous, because the
definition in this case is unclear.

I think numa has the problem too which I agree with you.  If you attach a
numa reproducer it'll be nicer.  But again I'm not convinced uffd-wp is a
per-vma thing, which seems to be what this patch is based upon.

Now I really wonder whether I should just simply wr-protect pte for
pte_mkuffd_wp() always, attached.  I didn't do that from the start because
I wanted to keep the helpers operate on one bit only.  But I found that
it's actually common technique to use in pgtable arch code, and it really
doesn't make sense to not wr-protect a pte if uffd-wp is set on a present
entry.  It's much safer.

> > 
> > > 
> > > I'll need to off-work most of the rest of today, but maybe I can also have
> > > a look in the weekend or Monday more on the numa paths.  Before that, can
> > > we first reach a consensus that we have the mm/migrate patch there to be
> > > merged first?  These are two issues, IMHO.
> > > 
> > > I know you're against me for some reason, but until now I sincerely don't
> > > know why.  That patch sololy recovers write bit status (by removing it for
> > > read-only) for a migration entry and that definitely makes sense to me.  As
> > > I also mentioned in the old version of that thread, we can rework migration
> > > entries and merge READ|WRITE entries into a GENERIC entry one day if you
> > > think proper, but that's for later.
> > 
> > I'm not against you. I'm against changing well-working, common code
> > when it doesn't make any sense to me to change it.

This goes back to the original question of whether we should remove the
write bit for read migration entry.  Well, let's just focus on others;
we're all tired of this one.

> > And now we have proof that
> > mprotect() just behaves exactly the same way, using the basic rules of vma->vm_page_prot.
> > 
> > Yes, there is broken sparc64 (below), but that shouldn't dictate our implementation.

I doubt whether sparc64 is broken if it has been like that anyway, because
I know little on sparc64 so I guess I'd not speak on that.

> > 
> > 
> > What *would* make sense to me, as I raised, is:
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index dff333593a8a..9fc181fd3c5a 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -213,8 +213,10 @@ static bool remove_migration_pte(struct folio *folio,
> >                           pte = pte_mkdirty(pte);
> >                   if (is_writable_migration_entry(entry))
> >                           pte = maybe_mkwrite(pte, vma);
> > -               else if (pte_swp_uffd_wp(*pvmw.pte))
> > +               else if (pte_swp_uffd_wp(*pvmw.pte)) {
> >                           pte = pte_mkuffd_wp(pte);
> > +                       pt = pte_wrprotect(pte);
> > +               }
> >                   if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
> >                           rmap_flags |= RMAP_EXCLUSIVE;
> > 
> > 
> > It still requires patch each and every possible code location, which I dislike as
> > described in the patch description. The fact that there are still uffd-wp bugs
> > with your patch makes that hopefully clear. I'd be interested if they can be
> > reproduced witht his patch.
> > 
> 
> And if NUMA hinting is indeed the problem, without this patch what would
> be required would most probably be:
> 
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 8a6d5c823f91..869d35ef0e24 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4808,6 +4808,8 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>         pte = pte_mkyoung(pte);
>         if (was_writable)
>                 pte = pte_mkwrite(pte);
> +       if (pte_uffd_wp(pte))
> +               pte = pte_wrprotect(pte);
>         ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
>         update_mmu_cache(vma, vmf->address, vmf->pte);
>         pte_unmap_unlock(vmf->pte, vmf->ptl);
> 
> 
> And just to make my point about the migration path clearer: doing it your way
> would be:
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 8a6d5c823f91..a7c4c1a57f6a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4808,6 +4808,8 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>         pte = pte_mkyoung(pte);
>         if (was_writable)
>                 pte = pte_mkwrite(pte);
> +       else
> +               pte = pte_wrprotect(pte);
>         ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
>         update_mmu_cache(vma, vmf->address, vmf->pte);
>         pte_unmap_unlock(vmf->pte, vmf->ptl);
> 
> 
> And I don't think that's the right approach.

Yes, but now I'm prone to the patch I attached which should just cover all
pte_mkuffd_wp().

Side note: since looking at the numa code, I found that after the recent
rework of removing savedwrite for numa, cdb205f9e220 ("mm/autonuma: use
can_change_(pte|pmd)_writable() to replace savedwrite"), I think it can
happen that after numa balancing one pte under uffd-wp vma (but not
wr-protected) can have its write bit lost if the migration failed during
recovering, because vma_wants_manual_pte_write_upgrade() will return false
for such case.  Is it true?

-- 
Peter Xu

--q5IFF/aTDPAhV49v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-mm-uffd-Always-wr-protect-pte-in-pte_mkuffd_wp.patch"

From de45385070c960056433bfd6ac575f50937717d6 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Mon, 5 Dec 2022 15:30:53 -0500
Subject: [PATCH] mm/uffd: Always wr-protect pte in pte_mkuffd_wp()
Content-type: text/plain

It's never valid to have write bit set for any pte that is uffd
wr-protected.  Remove the write bit explicitly in pte_mkuffd_wp() so we
never forget to do that in any callers.

Remove the rest paths where we explicitly wr-protect the pte just for
uffd-wp because they're not needed anymore.

This should make sure all the places (e.g. do_numa_page for writable shmem)
will not have the write bit set as long as when uffd-wp is set.

Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/pgtable.h | 2 +-
 include/asm-generic/hugetlb.h  | 2 +-
 mm/hugetlb.c                   | 4 ++--
 mm/memory.c                    | 8 +++-----
 mm/mprotect.c                  | 6 ++----
 mm/userfaultfd.c               | 6 ------
 6 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0564edd24ffb..b6e348f7610f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -313,7 +313,7 @@ static inline int pte_uffd_wp(pte_t pte)
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_set_flags(pte, _PAGE_UFFD_WP);
+	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD_WP));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index a57d667addd2..a190ad12b7cc 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -37,7 +37,7 @@ static inline pte_t huge_pte_modify(pte_t pte, pgprot_t newprot)
 
 static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
 {
-	return pte_mkuffd_wp(pte);
+	return huge_pte_wrprotect(pte_mkuffd_wp(pte));
 }
 
 static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d97c9a2a15d..943aa96b6f68 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5751,7 +5751,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	 * if populated.
 	 */
 	if (unlikely(pte_marker_uffd_wp(old_pte)))
-		new_pte = huge_pte_wrprotect(huge_pte_mkuffd_wp(new_pte));
+		new_pte = huge_pte_mkuffd_wp(new_pte);
 	set_huge_pte_at(mm, haddr, ptep, new_pte);
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
@@ -6552,7 +6552,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (uffd_wp)
-				pte = huge_pte_mkuffd_wp(huge_pte_wrprotect(pte));
+				pte = huge_pte_mkuffd_wp(pte);
 			else if (uffd_wp_resolve)
 				pte = huge_pte_clear_uffd_wp(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
diff --git a/mm/memory.c b/mm/memory.c
index aad226daf41b..1e2628bf8de1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -882,7 +882,7 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	if (userfaultfd_pte_wp(dst_vma, *src_pte))
 		/* Uffd-wp needs to be delivered to dest pte as well */
-		pte = pte_wrprotect(pte_mkuffd_wp(pte));
+		pte = pte_mkuffd_wp(pte);
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -3950,10 +3950,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
-	if (pte_swp_uffd_wp(vmf->orig_pte)) {
+	if (pte_swp_uffd_wp(vmf->orig_pte))
 		pte = pte_mkuffd_wp(pte);
-		pte = pte_wrprotect(pte);
-	}
 	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
@@ -4296,7 +4294,7 @@ void do_set_pte(struct vm_fault *vmf, struct page *page, unsigned long addr)
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (unlikely(uffd_wp))
-		entry = pte_mkuffd_wp(pte_wrprotect(entry));
+		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 093cb50f2fc4..a816ec34c234 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -177,12 +177,10 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
 			ptent = pte_modify(oldpte, newprot);
 
-			if (uffd_wp) {
-				ptent = pte_wrprotect(ptent);
+			if (uffd_wp)
 				ptent = pte_mkuffd_wp(ptent);
-			} else if (uffd_wp_resolve) {
+			else if (uffd_wp_resolve)
 				ptent = pte_clear_uffd_wp(ptent);
-			}
 
 			/*
 			 * In some writable, shared mappings, we might want
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 650ab6cfd5f4..29015ad73e69 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -85,12 +85,6 @@ int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 
 	if (writable)
 		_dst_pte = pte_mkwrite(_dst_pte);
-	else
-		/*
-		 * We need this to make sure write bit removed; as mk_pte()
-		 * could return a pte with write bit set.
-		 */
-		_dst_pte = pte_wrprotect(_dst_pte);
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 
-- 
2.37.3


--q5IFF/aTDPAhV49v--

