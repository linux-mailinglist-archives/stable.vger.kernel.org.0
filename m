Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0347F2B65B4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgKQN6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgKQN6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 08:58:03 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E08C0613CF;
        Tue, 17 Nov 2020 05:58:02 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id z21so30193218lfe.12;
        Tue, 17 Nov 2020 05:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DQvmYjbDLLBnHVdX+CylDIEuf6i9/j+JMwS6A3fnRDk=;
        b=KfRYe7etr069x7vSrWYScAW2e9VlkU4yKQhSex+cMx5Durh9EmJxOm6voWPy5MIcat
         fZNxV7/WPZZbKpBI3qt51fczpKwolC/iCrXeuiTE8tXPhqebTutkaaQnfJm7r+BbAY9m
         oldHMXUH96jE5ERAE0vY2rjqCLrNgr6j+LGpFKKFxveu6Yp3GlPczoEDYvxSSjbi4s8J
         QPki9Jnf8bXSXByZgBu4dAPcpb1c6lHMXKg/XTkbENIyma2xWmqQ0NxH2LF/kn419vjs
         K7iLgfQuVzI/JwpDz7pNBmbNyGV4uyu3obP0E65YEpv3mLJsR13bzgWgfvhZvprc+wZz
         XGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DQvmYjbDLLBnHVdX+CylDIEuf6i9/j+JMwS6A3fnRDk=;
        b=fgrU8ffFZUbg1FlTOm4Gw32jtwsfquih40EmFHnXGmt6y7kFPdtxHBFc+pGjn9MdhN
         t5QkBFOBNvpRNWvec5aHNilW0Lhd5baFY1bzYca/c4xZoCHrgIcyZK5w4Lsw0OlKRn9g
         Jsqfd3ZlNm0gv2kU5gLa777byONzwSqX/uyDFPTRhbJ0K02Pv8OnD6itb3Cln2E6Vsfa
         Ybr0v0HhUoIW5o4R5Xp/jsSqcpFjZzxjQJ0pYSXuuIsiYuahrWVUgntDC3NwjhhoD28k
         MkqBd5QJnbN3qh0u7CaWtTIh7lpuMcnQNqalzNovLDN44ZNOef40uiXeY7+m7s/P60rQ
         oDPA==
X-Gm-Message-State: AOAM531htdZEQXp3NOgFdIPSOyBoDY6e1xLOoV5M4DOVEankAcL4OdSU
        FlF8oU2ACWUVPym1QTUYtJU=
X-Google-Smtp-Source: ABdhPJx3NPYlcHefpv13+uwzcCiZxoxLv9hs8s6K2s2sKD8scEwyGNsxAWJAU21dGk/NyXeZL8HZFQ==
X-Received: by 2002:a19:3d5:: with SMTP id 204mr1779266lfd.384.1605621481297;
        Tue, 17 Nov 2020 05:58:01 -0800 (PST)
Received: from pc636 (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id r20sm3066853ljk.97.2020.11.17.05.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:58:00 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Tue, 17 Nov 2020 14:57:58 +0100
To:     Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201117135758.GA11602@pc636>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
 <20201116175323.GB3805951@google.com>
 <20201116152058.effcc5e6915cd9b98ba31348@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116152058.effcc5e6915cd9b98ba31348@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> Let's cc Uladzislau on vmalloc things?
> 
> > How about this?
> 
> Well, lol, that's a simple approach to avoiding the problem ;)
> 
To me it looks like a specific workaround for a specific one user.

> > unmap_kernel_range had been atomic operation and zsmalloc has used
> > it in atomic context in zs_unmap_object.
> > However, ("e47110e90584, mm/vunmap: add cond_resched() in vunmap_pmd_range")
> > changed it into non-atomic operation via adding cond_resched.
> > It causes zram decompresion failure by corrupting compressed buffer
> > in atomic context.
> > 
> > This patch introduces unmap_kernel_range_atomic which works for
> > only range less than PMD_SIZE to prevent cond_resched call.
> > 
> > ...
> >
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -180,6 +180,7 @@ int map_kernel_range(unsigned long start, unsigned long size, pgprot_t prot,
> >  		struct page **pages);
> >  extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
> >  extern void unmap_kernel_range(unsigned long addr, unsigned long size);
> > +extern void unmap_kernel_range_atomic(unsigned long addr, unsigned long size);
> >  static inline void set_vm_flush_reset_perms(void *addr)
> >  {
> >  	struct vm_struct *vm = find_vm_area(addr);
> > @@ -200,6 +201,7 @@ unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
> >  {
> >  }
> >  #define unmap_kernel_range unmap_kernel_range_noflush
> > +#define unmap_kernel_range_atomic unmap_kernel_range_noflush
> >  static inline void set_vm_flush_reset_perms(void *addr)
> >  {
> >  }
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d7075ad340aa..714e5425dc45 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -88,6 +88,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> >  	pmd_t *pmd;
> >  	unsigned long next;
> >  	int cleared;
> > +	bool check_resched = (end - addr) > PMD_SIZE;
> >  
> >  	pmd = pmd_offset(pud, addr);
> >  	do {
> > @@ -102,8 +103,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> >  		if (pmd_none_or_clear_bad(pmd))
> >  			continue;
> >  		vunmap_pte_range(pmd, addr, next, mask);
> > -
> > -		cond_resched();
> > +		if (check_resched)
> > +			cond_resched();
> >  	} while (pmd++, addr = next, addr != end);
> >  }
> >  
> > @@ -2024,6 +2025,24 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
> >  	flush_tlb_kernel_range(addr, end);
> >  }
> >  
> > +/**
> > + * unmap_kernel_range_atomic - unmap kernel VM area and flush cache and TLB
> > + * @addr: start of the VM area to unmap
> > + * @size: size of the VM area to unmap
> > + *
> > + * Similar to unmap_kernel_range_noflush() but it's atomic. @size should be
> > + * less than PMD_SIZE.
> > + */
> > +void unmap_kernel_range_atomic(unsigned long addr, unsigned long size)
> > +{
> > +	unsigned long end = addr + size;
> > +
> > +	flush_cache_vunmap(addr, end);
> > +	WARN_ON(size > PMD_SIZE);
> 
> WARN_ON_ONCE() would be better here - no point in creating a million
> warnings where one would suffice.
> 
> > +	unmap_kernel_range_noflush(addr, size);
> > +	flush_tlb_kernel_range(addr, end);
> > +}
> > +
> >  static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
> >  	struct vmap_area *va, unsigned long flags, const void *caller)
> >  {
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 662ee420706f..9decc7634852 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1154,7 +1154,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
> >  {
> >  	unsigned long addr = (unsigned long)area->vm_addr;
> >  
> > -	unmap_kernel_range(addr, PAGE_SIZE * 2);
> > +	unmap_kernel_range_atomic(addr, PAGE_SIZE * 2);
> >  }
> 
> I suppose we could live with it if no better solutions are forthcoming.
>
Maybe solve it on zsmalloc side? For example to add __zs_unmap_object_deferred(),
so it schedules the work that calls unmap_kernel_range() on a list of mapping_area
objects.

--
Vlad Rezki
