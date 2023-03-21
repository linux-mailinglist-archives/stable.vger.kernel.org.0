Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40CB6C3ACB
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjCUTio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCUTim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:38:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF1F5FC8
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679427358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkHbf1v/TeW0kF6HmTdS9KScSLUYYXyk622NGMWYMjE=;
        b=ETJeyOw8ZIbnVGBReJZQKHjiotwO1cqsn7a2NVZ3ZUtD0j/QYnkVgK2hrU3ZhnRc8a1Vrg
        0zu3x+bGN4be+ZPYk5agBpcIUG/W/ZAs6qiylrt78v6Juml3Lkmq4YAi+tqb9Y99cVPYCL
        8MP+Esv+fTqhIajsaocHacuj+7Kudw4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-rUgSMiooMMu7xeDM3oa-BQ-1; Tue, 21 Mar 2023 15:35:57 -0400
X-MC-Unique: rUgSMiooMMu7xeDM3oa-BQ-1
Received: by mail-qt1-f198.google.com with SMTP id f2-20020ac87f02000000b003dd98d8bea0so5960643qtk.6
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkHbf1v/TeW0kF6HmTdS9KScSLUYYXyk622NGMWYMjE=;
        b=Ja0AIxi3mD09zrVeCMTNG2tD77eBx36oUUIIv/wJsdWFvHQziQRsp/sORr8L4N2Cvi
         FZLEV4J4BGaReHVSnGGJalki5mCpd3GlL5jA/ytj9RmYKzvDu6npnXa9L58wCBRekEVB
         VtIUIJsaFIT4UyCImGbegllqQC+AqHPCMwoVGus6rrPWYlUE/fgplKKPqEgyeoIlra5l
         DT6g0vLQut6exeYY1pVPjZCxCAOkT3Polh34ZM41+FMPr/prJyyqUewGqw00ajPLh6Vn
         LoAJkpH7V4w99cF9AhiQTRZZ3Hjmo1H8o9ErXUaNVN3zXmQchZOm7glZIw7GbOh4gQGl
         OD+w==
X-Gm-Message-State: AO0yUKW3V3zy7Gmzvkyv/1dlFGcao82+A2PLqH7q57zzqqJSDd01KXTB
        DhxKcOE86TxW4IG60g9TkIEgrWcBjR4ffu0zzuddRjIEjcaHX6PI0z1qAUENfO3ugE07puFOBnk
        /+/wg78Rzi373w+fO
X-Received: by 2002:a05:622a:1a17:b0:3e3:7ed0:d6df with SMTP id f23-20020a05622a1a1700b003e37ed0d6dfmr7146945qtb.6.1679427356677;
        Tue, 21 Mar 2023 12:35:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set/1G9IE3BTdBMPqhFVArq51OpJH8MCFFhHpaUyXIe8c4hd5ykBJuU5X/upf6HakV7unCN1aoQ==
X-Received: by 2002:a05:622a:1a17:b0:3e3:7ed0:d6df with SMTP id f23-20020a05622a1a1700b003e37ed0d6dfmr7146908qtb.6.1679427356422;
        Tue, 21 Mar 2023 12:35:56 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id 15-20020a05620a048f00b0074636e35405sm2443163qkr.65.2023.03.21.12.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:35:55 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:35:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <ZBoHGulYSqHrjyLC@x1n>
References: <20230321191840.1897940-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230321191840.1897940-1-peterx@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mike,

For some reason I forgot to copy you.. sorry.  Here's the link:

https://lore.kernel.org/linux-mm/20230321191840.1897940-1-peterx@redhat.com

On Tue, Mar 21, 2023 at 03:18:40PM -0400, Peter Xu wrote:
> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> writable even with uffd-wp bit set.  It only happens with all these
> conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
> write to the page to trigger.
> 
> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> need.  However there's one CoW optimization path for missing hugetlb page
> that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> userfaultfd-wp traps.
> 
> A few ways to resolve this:
> 
>   (1) Skip the CoW optimization for hugetlb private mapping, considering
>   that private mappings for hugetlb should be very rare, so it may not
>   really be helpful to major workloads.  The worst case is we only skip the
>   optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
>   fault anyway.
> 
>   (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
>   into hugetlb_wp().  The major cons is there're a bunch of locks taken
>   when calling hugetlb_wp(), and that will make the changeset unnecessarily
>   complicated due to the lock operations.
> 
>   (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
>   for uffd-wp privately mapped pages.
> 
> This patch chose option (3) which contains the minimum changeset (simplest
> for backport) and also make sure hugetlb_wp() itself will start to be
> always safe with uffd-wp ptes even if called elsewhere in the future.
> 
> This patch will be needed for v5.19+ hence copy stable.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfd07f4c143..22337b191eae 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		       struct folio *pagecache_folio, spinlock_t *ptl)
>  {
>  	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> -	pte_t pte;
> +	pte_t pte, newpte;
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page;
>  	struct folio *new_folio;
> @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		mmu_notifier_invalidate_range(mm, range.start, range.end);
>  		page_remove_rmap(old_page, vma, true);
>  		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> -		set_huge_pte_at(mm, haddr, ptep,
> -				make_huge_pte(vma, &new_folio->page, !unshare));
> +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> +		if (huge_pte_uffd_wp(pte))
> +			newpte = huge_pte_mkuffd_wp(newpte);
> +		set_huge_pte_at(mm, haddr, ptep, newpte);
>  		folio_set_hugetlb_migratable(new_folio);
>  		/* Make the old page be freed below */
>  		new_folio = page_folio(old_page);
> -- 
> 2.39.1
> 

-- 
Peter Xu

