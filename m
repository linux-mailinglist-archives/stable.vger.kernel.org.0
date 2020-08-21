Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A0B24D342
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgHUKx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 06:53:59 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:38045 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728471AbgHUKxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 06:53:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 67A65B5D;
        Fri, 21 Aug 2020 06:53:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 21 Aug 2020 06:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=4w5aaSxnH7WDfq4kjSzfbsI5N/z
        p0ZWkHRv0ThroaAs=; b=WkSyOnegVM5YahV565joYP05oOpfuBUeBRvgnXXJ4jb
        0xGWisZFnEl/gw7fiHRfcs8j/aoaaeSeyiLW0/EdX1a+2YStDkZgQqb7QPq7hDHg
        HX7tgyY2WKjrsbiZBIYnGwOWcld7on5b7xOfdgUhVkDRoyUorcl3+22ieLGkpC9/
        KGRqSQJe6fUeL8m2k5tVyRUU2pYuwD4soGpsEEEWIo2ZI80BU/y5SRa4bmJU0tLV
        /CQ3xP0Y+aFeruslkF1bajkgo0NOxRZ1xz6i1AfQIrNxXgFK85iXjzwG+xvZfeZa
        fFWsC1X+jJaR6UY/KJQssUQFrvqbQeppnUqmjRLlYuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4w5aaS
        xnH7WDfq4kjSzfbsI5N/zp0ZWkHRv0ThroaAs=; b=XRZxiSKZ3i62nYcgD5JJIC
        pZozybeXHAzH0R4SA/nLjeZdxHyYiK441EgN5LB1kCZsWwAPpUynHdH84ORQs0x4
        NVfODJYdwrjuNOSmXZJzokx1FjcusWkL7aj7mNqnlgWqFu4AkgDciIyPqjwJ7aiL
        5GayzENN59ffOq4xdQOzGzns/4TNRaoYONc2Egc6wn9mzwq1kEv9jgHGmzYKywek
        GQXX8GpUiPdgaisThL2c3NA3yZNBocInL3x+ZqNRYTxT4944ENoo+oM0Zj2oR8uZ
        +Fj34xlcNNK13fqA0HIla2VnSg9pNeZxX7MKISJQ3D3M31JyhXMDuXQC5IVsuRzg
        ==
X-ME-Sender: <xms:nac_XzH7jO54wG6o2aWJdgmhOEGx0ehvzJOXuGx9QLs5AZ3SB5HGxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduvddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:nac_XwUW15JsV4nRgiz4g_QxIN4qUBCfLwOMjSLE_8fySJraENOa7A>
    <xmx:nac_X1I2WV00Qo--zwt7UfLhuyB7xEtA3lm5IGefpabwO1ToTskf9w>
    <xmx:nac_XxE5RVpZz-tEdROTxkd6OVy56SYqYnZ2I0Q9UgfQtEzGh_YDGQ>
    <xmx:n6c_XxTAzs571VgL8bpj8ackiJw53ZKGRIEe5fNeMh3z4CubGgPus6Lpvlk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5327230600B1;
        Fri, 21 Aug 2020 06:53:17 -0400 (EDT)
Date:   Fri, 21 Aug 2020 12:53:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Track page table modifications in
 __apply_to_page_range() construction
Message-ID: <20200821105337.GA1915660@kroah.com>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk>
 <20200821100902.GG3354@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821100902.GG3354@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 12:09:02PM +0200, Joerg Roedel wrote:
> The __apply_to_page_range() function is also used to change and/or
> allocate page-table pages in the vmalloc area of the address space.
> Make sure these changes get synchronized to other page-tables in the
> system by calling arch_sync_kernel_mappings() when necessary.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> (Only compile tested on x86-64 so far)
> 
>  mm/memory.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3a7779d9891d..fd845991f14a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -83,6 +83,7 @@
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  
> +#include "pgalloc-track.h"
>  #include "internal.h"
>  
>  #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
> @@ -2206,7 +2207,8 @@ EXPORT_SYMBOL(vm_iomap_memory);
>  
>  static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				     unsigned long addr, unsigned long end,
> -				     pte_fn_t fn, void *data, bool create)
> +				     pte_fn_t fn, void *data, bool create,
> +				     pgtbl_mod_mask *mask)
>  {
>  	pte_t *pte;
>  	int err = 0;
> @@ -2235,6 +2237,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				break;
>  		}
>  	} while (addr += PAGE_SIZE, addr != end);
> +	*mask |= PGTBL_PTE_MODIFIED;
>  
>  	arch_leave_lazy_mmu_mode();
>  
> @@ -2245,7 +2248,8 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  
>  static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
>  				     unsigned long addr, unsigned long end,
> -				     pte_fn_t fn, void *data, bool create)
> +				     pte_fn_t fn, void *data, bool create,
> +				     pgtbl_mod_mask *mask)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -2254,7 +2258,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
>  	BUG_ON(pud_huge(*pud));
>  
>  	if (create) {
> -		pmd = pmd_alloc(mm, pud, addr);
> +		pmd = pmd_alloc_track(mm, pud, addr, mask);
>  		if (!pmd)
>  			return -ENOMEM;
>  	} else {
> @@ -2264,7 +2268,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
>  		next = pmd_addr_end(addr, end);
>  		if (create || !pmd_none_or_clear_bad(pmd)) {
>  			err = apply_to_pte_range(mm, pmd, addr, next, fn, data,
> -						 create);
> +						 create, mask);
>  			if (err)
>  				break;
>  		}
> @@ -2274,14 +2278,15 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
>  
>  static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
>  				     unsigned long addr, unsigned long end,
> -				     pte_fn_t fn, void *data, bool create)
> +				     pte_fn_t fn, void *data, bool create,
> +				     pgtbl_mod_mask *mask)
>  {
>  	pud_t *pud;
>  	unsigned long next;
>  	int err = 0;
>  
>  	if (create) {
> -		pud = pud_alloc(mm, p4d, addr);
> +		pud = pud_alloc_track(mm, p4d, addr, mask);
>  		if (!pud)
>  			return -ENOMEM;
>  	} else {
> @@ -2291,7 +2296,7 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
>  		next = pud_addr_end(addr, end);
>  		if (create || !pud_none_or_clear_bad(pud)) {
>  			err = apply_to_pmd_range(mm, pud, addr, next, fn, data,
> -						 create);
> +						 create, mask);
>  			if (err)
>  				break;
>  		}
> @@ -2301,14 +2306,15 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
>  
>  static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
>  				     unsigned long addr, unsigned long end,
> -				     pte_fn_t fn, void *data, bool create)
> +				     pte_fn_t fn, void *data, bool create,
> +				     pgtbl_mod_mask *mask)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
>  	int err = 0;
>  
>  	if (create) {
> -		p4d = p4d_alloc(mm, pgd, addr);
> +		p4d = p4d_alloc_track(mm, pgd, addr, mask);
>  		if (!p4d)
>  			return -ENOMEM;
>  	} else {
> @@ -2318,7 +2324,7 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
>  		next = p4d_addr_end(addr, end);
>  		if (create || !p4d_none_or_clear_bad(p4d)) {
>  			err = apply_to_pud_range(mm, p4d, addr, next, fn, data,
> -						 create);
> +						 create, mask);
>  			if (err)
>  				break;
>  		}
> @@ -2333,6 +2339,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
>  	pgd_t *pgd;
>  	unsigned long next;
>  	unsigned long end = addr + size;
> +	pgtbl_mod_mask mask = 0;
>  	int err = 0;
>  
>  	if (WARN_ON(addr >= end))
> @@ -2343,11 +2350,14 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
>  		next = pgd_addr_end(addr, end);
>  		if (!create && pgd_none_or_clear_bad(pgd))
>  			continue;
> -		err = apply_to_p4d_range(mm, pgd, addr, next, fn, data, create);
> +		err = apply_to_p4d_range(mm, pgd, addr, next, fn, data, create, &mask);
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
>  
> +	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> +		arch_sync_kernel_mappings(addr, addr + size);
> +
>  	return err;
>  }
>  
> -- 
> 2.28.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
