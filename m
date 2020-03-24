Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EFC191569
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 16:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgCXPz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 11:55:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37958 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgCXPzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 11:55:55 -0400
Received: by mail-qk1-f196.google.com with SMTP id h14so19750023qke.5
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WKfNG8umMlwkpQpy66f4+p/cJ7axBraMaD/gLOw+hwA=;
        b=MrGUEZ9IiQLdHGz08a8ugYDa8Kh9rXV8aSLNAnHozoNnLeKHJVRGMe9+8m1GlUnstf
         5tQpZMpOzCfVJxw86gZz4WggoXB0Lk1BX8/uFnmjM+uCn92w4dRor82thwtliC5iP6y4
         /VJADA5NAPnbZwi11s0UvCWYud5WVJaWD2G41vqNRnnaMZFarV6c/scEaRy4/utVW5io
         HuiW5m2mDE6YyHm6pmCHQqtyi6ePkAMcQR77qCpuFosHVAiGz+OrsD3/7tJilvvyxdrX
         +quF2ez8iVba7Sx8HThDueT1e16xa52eSqf8BciD/j7h9YlZibh9+FT85mFcIKgSVAjO
         +Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WKfNG8umMlwkpQpy66f4+p/cJ7axBraMaD/gLOw+hwA=;
        b=EAE/fG+fOj/K5TAnDVAy2NKjmSk47xE399rSqoMkAV6V1gqtUsXlZ0/wQMhY4H5cRn
         nwThSeF/2wR67IFaQvYe00yN1Xr2gS/WctZMOkE7+W5VzOBXxIlAgpQRhDKgH5wLPtgW
         pprg0pFNHjfSuD8f3vUSZX/TmYjdfHsvk5PGIamcc+Y5UwSGyb1i+Tss+0OwAQE/eYSH
         vb/hSaiB4qjBdWRvQ9tkZzbfF+shIDW37kv50a3kQLmBpYJ0g8jVZ1FbvrCjYlYO9Cq6
         rsfJhFKjxWRJDrFxAC/TOdhLhoe8h/Rr3rpm1vYC938HtO+7MINlUyFPMiXurIOtP2gu
         xuCg==
X-Gm-Message-State: ANhLgQ3tuSlNKa2olywzCXZeReRq9iy6NMKNlg41YTsCRNMd9c6Bt9lG
        J5w2QrByJiWItQJO1Giu6bXeLw==
X-Google-Smtp-Source: ADFU+vuLBR4sW0l9XYEmX4X3U9KJJIggAbGvaXnj0Zmnvl3IhX2Vdun2/yaOWCfr3BoRN1vAtQoZlA==
X-Received: by 2002:a37:a70e:: with SMTP id q14mr23857810qke.41.1585065353693;
        Tue, 24 Mar 2020 08:55:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id v20sm12871207qth.10.2020.03.24.08.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 08:55:53 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGluC-0004gw-I1; Tue, 24 Mar 2020 12:55:52 -0300
Date:   Tue, 24 Mar 2020 12:55:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200324155552.GK20941@ziepe.ca>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
 <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
 <20200324115541.GH20941@ziepe.ca>
 <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98d35563-8af0-2693-7e76-e6435da0bbee@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 08:25:09AM -0700, Mike Kravetz wrote:
> On 3/24/20 4:55 AM, Jason Gunthorpe wrote:
> > Also, since CH moved all the get_user_pages_fast code out of the
> > arch's many/all archs can drop their arch specific version of this
> > routine. This is really just a specialized version of gup_fast's
> > algorithm..
> > 
> > (also the arch versions seem different, why do some return actual
> >  ptes, not null?)
> 
> Not sure I understand that last question.  The return value should be
> a *pte or null.

I mean the common code ends like this:

	pmd = pmd_offset(pud, addr);
	if (sz != PMD_SIZE && pmd_none(*pmd))
		return NULL;
	/* hugepage or swap? */
	if (pmd_huge(*pmd) || !pmd_present(*pmd))
		return (pte_t *)pmd;

	return NULL;

So it always returns a pointer into a PUD or PMD, while say, ppc
in __find_linux_pte() ends like:

	return pte_offset_kernel(&pmd, ea);

Which is pointing to a PTE

So does sparc:

        pmd = pmd_offset(pud, addr);
        if (pmd_none(*pmd))
                return NULL;
        if (is_hugetlb_pmd(*pmd))
                return (pte_t *)pmd;
        return pte_offset_map(pmd, addr);

Which is even worse because it is leaking a kmap..

etc

> /*
>  * huge_pte_offset() - Walk the page table to resolve the hugepage
>  * entry at address @addr
>  *
>  * Return: Pointer to page table or swap entry (PUD or PMD) for
                                              ^^^^^^^^^^^^^^^^^^^

Ie the above is not followed by the archs

I'm also scratching my head that a function that returns a pte_t *
always returns a PUD or PMD. Strange bit of type casting..

Jason
