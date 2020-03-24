Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56194190CD0
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgCXLzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:55:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37866 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgCXLzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 07:55:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id d12so12183480qtj.4
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 04:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w1YWm4F/uaQ5OYqNJamoxbnrEIFgzKhIqyElOppFU5I=;
        b=pT25pjC8buxYmrlihdNvLu+wRRYwjgGQrAyYVoKbCfUxBGdR12W1egcMG9e4xz3YtL
         iRNrD87Us1LrJS0Mns/670+/pV2oYj3vpLVBhbs+x06bwDfPkQ9ENan/4x7Fwkf2NQw8
         MqW0lEC1xz+kRVUOEymctRt+r5x2KjtT3102m2w5xfryGLJiwJ4GWWiKQq26rV43f3QR
         oIHpCDCaz09ZRgBWHeucaVDMXTHbz8Gxiaz1tACsnHZTllZtmKSWVLv6LSNKgTAjFlkr
         19uDaOv1Bw2C14v0UsFV2pL55FtI81uT4URanBCJ1A9PFbaQM7E2/gKSvyxDLBxcZpLd
         50sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w1YWm4F/uaQ5OYqNJamoxbnrEIFgzKhIqyElOppFU5I=;
        b=r6OacaU71s7rXfRlYAZ3UCvnxFR2BUJl4CidIDQB6Lsz+xsmSgWj78UIG28yS2wFyU
         iV0zTbUFbU+xIMcDdWNsKM/kBESDN1scFTw8sqiPCQRXvx0shkkuv0CUgBTGPvBeVeVg
         4tRqDuTDAbk+xLrpNq7tMKksaXylKmZoQQvAYpvH0+hZkhG7liij94VWfdERCRRQF8GF
         hox1dcT502ZmPSq3tTG11RSBUKMbnYJrO37XhDl7a/OQRlv7XL6WLsW5zDy8scGmfBte
         UrGrfkX165tPzsALpd/QDLzVW4OwQDXtzGb3EEn/e44Mh5HH5QNgyLm0IbeYd/e4+/Gb
         A1Fw==
X-Gm-Message-State: ANhLgQ0nVV1NKAHbvlnd0hkbagrRjMP3vHG26L+tUlBV+HKHasuQhlOG
        JpvP3XlML2aFfdVJansUEO0U4g==
X-Google-Smtp-Source: ADFU+vtqQmsl96/BHuBLkeo81EPEC4/F6MmK+fNUA2yXeLXS6wRo/nyPq47akLBUzP+GcH5YLso85g==
X-Received: by 2002:ac8:184f:: with SMTP id n15mr25478318qtk.371.1585050943209;
        Tue, 24 Mar 2020 04:55:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id v75sm13301271qkb.22.2020.03.24.04.55.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 04:55:42 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGi9l-00010Q-R6; Tue, 24 Mar 2020 08:55:41 -0300
Date:   Tue, 24 Mar 2020 08:55:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200324115541.GH20941@ziepe.ca>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
 <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 10:37:49AM +0800, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> 
> 
> On 2020/3/24 6:52, Jason Gunthorpe wrote:
> > On Mon, Mar 23, 2020 at 01:35:07PM -0700, Mike Kravetz wrote:
> >> On 3/23/20 11:07 AM, Jason Gunthorpe wrote:
> >>> On Mon, Mar 23, 2020 at 10:27:48AM -0700, Mike Kravetz wrote:
> >>>
> >>>>>  	pgd = pgd_offset(mm, addr);
> >>>>> -	if (!pgd_present(*pgd))
> >>>>> +	if (!pgd_present(READ_ONCE(*pgd)))
> >>>>>  		return NULL;
> >>>>>  	p4d = p4d_offset(pgd, addr);
> >>>>> -	if (!p4d_present(*p4d))
> >>>>> +	if (!p4d_present(READ_ONCE(*p4d)))
> >>>>>  		return NULL;
> >>>>>  
> >>>>>       pud = pud_offset(p4d, addr);
> >>>>
> >>>> One would argue that pgd and p4d can not change from present to !present
> >>>> during the execution of this code.  To me, that seems like the issue which
> >>>> would cause an issue.  Of course, I could be missing something.
> >>>
> >>> This I am not sure of, I think it must be true under the read side of
> >>> the mmap_sem, but probably not guarenteed under RCU..
> >>>
> >>> In any case, it doesn't matter, the fact that *p4d can change at all
> >>> is problematic. Unwinding the above inlines we get:
> >>>
> >>>   p4d = p4d_offset(pgd, addr)
> >>>   if (!p4d_present(*p4d))
> >>>       return NULL;
> >>>   pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
> >>>
> >>> According to our memory model the compiler/CPU is free to execute this
> >>> as:
> >>>
> >>>   p4d = p4d_offset(pgd, addr)
> >>>   p4d_for_vaddr = *p4d;
> >>>   if (!p4d_present(*p4d))
> >>>       return NULL;
> >>>   pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);
> >>>
> >>
> >> Wow!  How do you know this?  You don't need to answer :)
> > 
> > It says explicitly in Documentation/memory-barriers.txt - see
> > section COMPILER BARRIER:
> > 
> >  (*) The compiler is within its rights to reorder loads and stores
> >      to the same variable, and in some cases, the CPU is within its
> >      rights to reorder loads to the same variable.  This means that
> >      the following code:
> > 
> >         a[0] = x;
> >         a[1] = x;
> > 
> >      Might result in an older value of x stored in a[1] than in a[0].
> > 
> > It also says READ_ONCE puts things in program order, but we don't use
> > READ_ONCE inside pud_offset(), so it doesn't help us.
> > 
> > Best answer is to code things so there is exactly one dereference of
> > the pointer protected by READ_ONCE. Very clear to read, very safe.
> > 
> > Maybe Longpeng can rework the patch around these principles?
> > 
> Thanks Jason and Mike, I learn a lot from your analysis.
> 
> So... the patch should like this ?

Yes, the pattern looks right

The commit message should reference the above section of COMPILER
BARRIER and explain that de-referencing the entries is a data race, so
we must consolidate all the reads into one single place.

Also, since CH moved all the get_user_pages_fast code out of the
arch's many/all archs can drop their arch specific version of this
routine. This is really just a specialized version of gup_fast's
algorithm..

(also the arch versions seem different, why do some return actual
 ptes, not null?)

Jason
