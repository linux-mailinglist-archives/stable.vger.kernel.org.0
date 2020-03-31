Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D86D199822
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgCaOIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 10:08:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34021 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbgCaOIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 10:08:07 -0400
Received: by mail-qk1-f194.google.com with SMTP id i6so23085469qke.1
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 07:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=q3QjRBFEa+x9S+j/if9kDJCpzG6TvcNpGZtZPRzj+nc=;
        b=nxw3egfe7Em5HQYVwcJvTVy1sf/Mw/uTAjR1YmZS/PkVF29/d+FdyvLuQ7cuzBR7XJ
         NOz2SGtfXofEEohEjpv/HSRZwziuSgAx0I5OFi4npEvSY/LbxBJsgQHfAuVPCmRFneLZ
         HUPPtM7QkBk7ZCewYLxZjnw/kvRAlkYkeEw9wjfpIubFnFShhpvrDlg0Ku0GolkjQ6FY
         8xO58taZIZaL5/K+WA++EaJ1RBNSqy0ZC94WPK9gGtw8rvKbqAwgCK4u2nlm0pXTS2CM
         EVcuWn2yOmB0PlbpcXqWp/serUOWRXWZscBffL0TvcT5fRgb4jV6YwIE5ORelWSUh+wd
         gT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=q3QjRBFEa+x9S+j/if9kDJCpzG6TvcNpGZtZPRzj+nc=;
        b=uE8XSOLrQbzw9kkMM5oGjuzh1yyTbmiCRnt/Ss2a+jaCJOlTqfRMdztfeeSihWQicQ
         rDSx2dGkfFIBOuTjtaDI4bxcbEE0IU3vs7er16xwDG1PbYErxqA80rYmbqRREoB80/2K
         p8PQ7HbVTxWkWSjiXZvKZjxBc3/iHeup8M0TvtfJjHMk3hRxs11a++0RVddTgJO/yKsY
         q1DL+cXqjv6tnuYP84PgbsRuGJ5mULjy1jrhavZ6dvJUfQ9HNRwmj5GkRcImKz2L+TKu
         udu07YRXdBuYQlsBRaiS62cmey3lzEqiDqV4g4IFIIFrpHJXmhu7veHeGiBCIgFxBjsU
         BDTw==
X-Gm-Message-State: ANhLgQ2D5ckE0OS0ver00KliARhRbreLWLuUBhGFmL40mllQ1BKM2XEY
        ev2314sXVbfFWq+mV33/yzs9Ew==
X-Google-Smtp-Source: ADFU+vsVQPoOkMA+Bl33oRYht7HVQnL7jNy5IMGu2oM1vp9gTY5DpTqkmNH8mLDYMinLw6eB3ZgSRQ==
X-Received: by 2002:a37:2d83:: with SMTP id t125mr5174340qkh.359.1585663685492;
        Tue, 31 Mar 2020 07:08:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id l62sm10096376qte.52.2020.03.31.07.08.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2020 07:08:04 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jJHYi-0003iG-1Q; Tue, 31 Mar 2020 11:08:04 -0300
Date:   Tue, 31 Mar 2020 11:08:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>, akpm@linux-foundation.org,
        longpeng2@huawei.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, willy@infradead.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: +
 mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch added
 to -mm tree
Message-ID: <20200331140804.GN20941@ziepe.ca>
References: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
 <eea7c1f8-a2e4-5af1-acc4-3eb21a076d37@oracle.com>
 <20200331044408.GW24988@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331044408.GW24988@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 09:44:08PM -0700, Sean Christopherson wrote:
> On Mon, Mar 30, 2020 at 08:35:29PM -0700, Mike Kravetz wrote:
> > On 3/28/20 3:10 PM, akpm@linux-foundation.org wrote:
> > > The patch titled
> > >      Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
> > > has been added to the -mm tree.  Its filename is
> > >      mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > > 
> > > This patch should soon appear at
> > >     http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > > and later at
> > >     http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> > > 
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
> > > 
> > > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > > 
> > > The -mm tree is included into linux-next and is updated
> > > there every 3-4 working days
> > > 
> > > From: Longpeng <longpeng2@huawei.com>
> > > Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
> > 
> > This patch is what caused the BUG reported on i386 non-PAE kernel here:
> > 
> > https://lore.kernel.org/linux-mm/CA+G9fYsJgZhhWLMzUxu_ZQ+THdCcJmFbHQ2ETA_YPP8M6yxOYA@mail.gmail.com/
> > 
> > As a clue, when building in this environment I get:
> > 
> >   CC      mm/hugetlb.o
> > mm/hugetlb.c: In function ‘huge_pte_offset’:
> > cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> > mm/hugetlb.c:5361:14: note: declared here
> >   pud_t *pud, pud_entry;
> >               ^~~~~~~~~
> > cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> > mm/hugetlb.c:5361:14: note: declared here
> > cc1: warning: function may return address of local variable [-Wreturn-local-addr]
> > mm/hugetlb.c:5360:14: note: declared here
> >   p4d_t *p4d, p4d_entry;
> >               ^~~~~~~~~

Yes, this is certainly very bad.

> Non-PAE uses ModeB / PSE paging, which only has 2-level page tables.  The
> non-existent levels get folded in and pmd_offset/pud_offset() return the
> passed in pointer instead of accessing a table, e.g.:
> 
> static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
> {
> 	return (pmd_t *)pud;
> }

> The bug probably only manifests with PSE paging because it can have huge
> pages in the top-level table, i.e. is the only mode that can get a false
> positive.

> This is arguably a bug in pmd_huge/pud_hug(), seems like they should
> unconditionally return false if the relevant level doesn't exist.

The issue is that to get the READ_ONCE semantic for a lockless flow
this hackily defeats the de-reference inside the pXX_offset by passing
in a pointer to a stack variable. This is fine unless you actually
care about the *address* of the result of pXX_offset, which
huge_pte_offset() does.

I can't think of an easy fix here.

Andrew, I think this patch has to be dropped :(

Longpeng can fix the direct bug he saw by not changing the
pXX_offset(), but this extra de-reference will remain some
theortical/rare bug according to the memory model.

Maybe we need to change pXX_offset to take in the pointer and the
de'refd value?

Jason
