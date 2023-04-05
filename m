Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECCB6D824E
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbjDEPpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbjDEPpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:45:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C6449F1
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680709403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9+5VtQajWJ6aryPiByZHs9cjsreXsrWr3HePjo1dmYw=;
        b=QgWGo3uTGrQ0lAOnYiXbcXaxemF29bGFSwn0KLnDFv6yLoj0VxrTT9Vq43rWPI1Y98gyO8
        VII8yZSBU2DT9omSEKHq2E0c3E+rfT3iyUd2DQdmyKO6bI6K8z5zhdEODv4IMoCbAJ3ked
        +p0dIbkgs4KYmtVix+UzmSuo1XbrW5Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-7m3Mqb6LMueX9OWxTunSSg-1; Wed, 05 Apr 2023 11:43:22 -0400
X-MC-Unique: 7m3Mqb6LMueX9OWxTunSSg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-57c67ea348eso22166286d6.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+5VtQajWJ6aryPiByZHs9cjsreXsrWr3HePjo1dmYw=;
        b=wHquJSbXgN/fnphoNEjCoecAKmN2kba99W4eZtFDY1cDvUt544JoOxRiM+O80KucBz
         XuruPvyUhLNTenL9+PhsfkebdUdZJgjjBC/QmgkbVJ0N1GU1K2Ygbb4ioG9wKa9R6o6O
         J/wI6AtqkEhVMffHdfHqsuHAMR0qxbxoqmUjTKwtO8eZXasNKf8pJO6em+X3DjUUCjV4
         hmYteQ4jki8IZw7VvFBRtfVagcBhcUyGyO4e1zAz81U17cSXmiAeVgZKt3xdYrQAH9kK
         6BrfiMo2zSzr4uaxUhCmkUd+WoGFrkfP8kNO7qBcQjsDwqYJVutE2rTdpwsKNSOS5l0K
         QvOQ==
X-Gm-Message-State: AAQBX9fOBG/8HyJI9e9Eg8pd57FNC8TuuqNgJUAQLRPmot6kh+p18Dg/
        7lBQwdl12sQnjnKwt02ROcGY/xC9US2Fvl91fgHorr+FFuFkmkB7EpYlOwv8f3EIIn4hsxNktFu
        HcvKQG+1lvtAw9Eqk
X-Received: by 2002:a05:6214:508f:b0:5aa:14b8:e935 with SMTP id kk15-20020a056214508f00b005aa14b8e935mr5332693qvb.2.1680709401929;
        Wed, 05 Apr 2023 08:43:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y+dqb9QrfztOw+KW0CP34FDawHm56qfppdjPpbcsE7psQgXBNb1GRyofOuvw2sxegNfHvQLA==
X-Received: by 2002:a05:6214:508f:b0:5aa:14b8:e935 with SMTP id kk15-20020a056214508f00b005aa14b8e935mr5332654qvb.2.1680709401524;
        Wed, 05 Apr 2023 08:43:21 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id f24-20020ac84658000000b003b9a73cd120sm4059709qto.17.2023.04.05.08.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:43:21 -0700 (PDT)
Date:   Wed, 5 Apr 2023 11:43:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: fix uffd-wp handling for THP
 migration entries
Message-ID: <ZC2XF8qLXNOqIqGw@x1n>
References: <20230405142535.493854-1-david@redhat.com>
 <20230405142535.493854-2-david@redhat.com>
 <ZC2P7Z7S87myvSst@x1n>
 <c4c3ddb7-66fe-08e3-e59a-352f8aec6c6f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c4c3ddb7-66fe-08e3-e59a-352f8aec6c6f@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 05:17:31PM +0200, David Hildenbrand wrote:
> On 05.04.23 17:12, Peter Xu wrote:
> > On Wed, Apr 05, 2023 at 04:25:34PM +0200, David Hildenbrand wrote:
> > > Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
> > > fix uffd-wp handling for migration entries in hugetlb_change_protection()")
> > > similarly applies to THP.
> > > 
> > > Setting/clearing uffd-wp on THP migration entries is not implemented
> > > properly. Further, while removing migration PMDs considers the uffd-wp
> > > bit, inserting migration PMDs does not consider the uffd-wp bit.
> > > 
> > > We have to set/clear independently of the migration entry type in
> > > change_huge_pmd() and properly copy the uffd-wp bit in
> > > set_pmd_migration_entry().
> > > 
> > > Verified using a simple reproducer that triggers migration of a THP, that
> > > the set_pmd_migration_entry() no longer loses the uffd-wp bit.
> > > 
> > > Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > 
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > 
> > Thanks, one trivial nitpick:
> > 
> > > ---
> > >   mm/huge_memory.c | 14 ++++++++++++--
> > >   1 file changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 032fb0ef9cd1..bdda4f426d58 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> > >   	if (is_swap_pmd(*pmd)) {
> > >   		swp_entry_t entry = pmd_to_swp_entry(*pmd);
> > >   		struct page *page = pfn_swap_entry_to_page(entry);
> > > +		pmd_t newpmd;
> > >   		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> > >   		if (is_writable_migration_entry(entry)) {
> > > -			pmd_t newpmd;
> > >   			/*
> > >   			 * A protection check is difficult so
> > >   			 * just be safe and disable write
> > > @@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> > >   				newpmd = pmd_swp_mksoft_dirty(newpmd);
> > >   			if (pmd_swp_uffd_wp(*pmd))
> > >   				newpmd = pmd_swp_mkuffd_wp(newpmd);
> > > -			set_pmd_at(mm, addr, pmd, newpmd);
> > > +		} else {
> > > +			newpmd = *pmd;
> > >   		}
> > > +
> > > +		if (uffd_wp)
> > > +			newpmd = pmd_swp_mkuffd_wp(newpmd);
> > > +		else if (uffd_wp_resolve)
> > > +			newpmd = pmd_swp_clear_uffd_wp(newpmd);
> > > +		if (!pmd_same(*pmd, newpmd))
> > > +			set_pmd_at(mm, addr, pmd, newpmd);
> > >   		goto unlock;
> > >   	}
> > >   #endif
> > > @@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
> > >   	pmdswp = swp_entry_to_pmd(entry);
> > >   	if (pmd_soft_dirty(pmdval))
> > >   		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> > > +	if (pmd_swp_uffd_wp(*pvmw->pmd))
> > > +		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
> > 
> > I think it's fine to use *pmd, but maybe still better to use pmdval?  I
> > worry pmdp_invalidate()) can be something else in the future that may
> > affect the bit.
> 
> Wondering how I ended up with that, I realized that it's actually
> wrong and might have worked by chance for my reproducer on x86.
> 
> That should make it work:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f977c965fdad..fffc953fa6ea 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3257,7 +3257,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>         pmdswp = swp_entry_to_pmd(entry);
>         if (pmd_soft_dirty(pmdval))
>                 pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> -       if (pmd_swp_uffd_wp(*pvmw->pmd))
> +       if (pmd_uffd_wp(pmdval))
>                 pmdswp = pmd_swp_mkuffd_wp(pmdswp);
>         set_pmd_at(mm, address, pvmw->pmd, pmdswp);
>         page_remove_rmap(page, vma, true);

I guess pmd_swp_uffd_wp() just reads the _USER bit 2 which is also set for
a present pte, but then it sets swp uffd-wp always even if it was not set.

Yes the change must be squashed in to be correct, with that, my R-b keeps.

Thanks,

-- 
Peter Xu

