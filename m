Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF9F2E10C3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 01:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLWAY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 19:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLWAYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 19:24:25 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A278FC061793
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:23:45 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id k8so13569571ilr.4
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zPVUyN0X2UaL/Rf0O3PrEWZ3gBNDq2ynrHr8/vpcWJw=;
        b=I5zPqBlWm/SLmDdOaoYaeHfuhH0ps9HdFKks+nISg5vlCt9Tou8OEjurUZN9h7YKqD
         XHTk1YJFEcHfyd3wXn7lrxj/vAcOLoKhcuFssd2zzXB8TTHdR56+2p/JzIYmUFLg+u4w
         nTJokCzMmzI4xioWPxVkgwJrTsJCnR7civiuosDvLxdKRomoJItfF+XkBZsM6qpp7kmO
         fKgphZK1yPNJqfrm4qgZfKjTG1+aqoB7xdxch5HO/4JWXbwToK4V2GxcYOyxOLONFw9/
         Bs7jNsyy6e7B9caoKNZ9RqO0cJc3DBxGhk/3HOYBQEYU6ualqWblfc/XotI4GarIdtNW
         Z+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zPVUyN0X2UaL/Rf0O3PrEWZ3gBNDq2ynrHr8/vpcWJw=;
        b=hYYu6PbSV/wSXuaeBz796TcL5NrzboUxraCsG5dd4ohDuE5vAsTinjO3ItOZypmzfU
         2ZJeeqdZQcOI6IODNo+ZIC9LrZmgLSQRxjeRKxmT6wfzarU7TBrShIEK7tvHtkej4O4M
         gpxJABzaBnMzyplpefVUlbdGYfaWzXwG3qhyudvZLkjPQ+gTBjDY5ifiFa+TaVMXpG88
         E428ZetXYCvYTXuR3Gyc7smJQAbxh+tum6iALpu9Wbcvcm3o4yKRxK0rQyCpeT3vCvaS
         yuHr43LkZfLDW4pA/Tr2jaLqltM1tv03cDkk2pnNoc5ZRx9P3ENvq/s+bLuGx56MEyMS
         inpw==
X-Gm-Message-State: AOAM533XxPGhB8LgftjmdPesC3twf3clpXp01MXQTb4TdeuS7/yVh9dE
        Pm4liXbAiKaJFIgqTZ2aOyv8yA==
X-Google-Smtp-Source: ABdhPJwIW6Ug/4l5H12+ASCnorvrI2VqBgDLkKUaNWjzv9o3noKby3TerJHlKeOOkng7DJkb+zL4nQ==
X-Received: by 2002:a92:d8d1:: with SMTP id l17mr22668025ilo.99.1608683024177;
        Tue, 22 Dec 2020 16:23:44 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id c2sm16996894ila.71.2020.12.22.16.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 16:23:43 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:23:39 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+KOC4sRtUs4Ljqq@google.com>
References: <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 04:01:45PM -0800, Linus Torvalds wrote:
> On Tue, Dec 22, 2020 at 3:50 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > See zap_pte_range() for an example of doing it right, even in the
> > presence of complexities (ie that has an example of both flushing the
> > TLB, and doing the actual "free the pages after flush", and it does
> > the two cases separately).
> 
> The more I look at the mprotect code, the less I like it. We seem to
> be much better about the TLB flushes in other places (looking at
> mremap, for example). The mprotect code seems to be very laissez-faire
> about the TLB flushing.
> 
> Does adding a TLB flush to before that
> 
>         pte_unmap_unlock(pte - 1, ptl);
> 
> fix things for you?

It definitely does. But if I had to choose, I'd go with holding
mmap_lock for write because 1) it's less likely to storm other CPUs by
IPI and would only have performance impact on processes that use ufd,
which I guess already have high tolerance for not-so-good performance,
and 2) people are spearheading multiple efforts to reduce the mmap_lock
contention, which hopefully would make ufd users suffer less soon.

> That's not the right fix - leaving a stale TLB entry around is fine if
> the TLB entry is more strict wrt protections - but it might be worth
> testing as a "does it at least close the problem" patch.

Well, things get trick if we do this. I'm not sure if I could vouch
such a fix for stable as confident as I do holding mmap_lock for
write.
