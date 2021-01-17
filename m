Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B442F9074
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 05:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbhAQEmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 23:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAQEmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 23:42:10 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600C7C061573
        for <stable@vger.kernel.org>; Sat, 16 Jan 2021 20:41:30 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y19so26412858iov.2
        for <stable@vger.kernel.org>; Sat, 16 Jan 2021 20:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B1u3O83tTrsiNvPrp3hP0q70ExIGdl4r796ZiGkVvug=;
        b=N1aT2fBkHInlcB+SZ3y3jFU0B3PlXy6oQ9UoC2DV3e03WGOj7kquOGyhUCZfwmUThV
         xWBXH42AWotId0uCXKh9KXFy5i9GGKv1JznVVFqEiG6mh83/qbPvFlxRIbrWI2qH92E4
         2R8i+dDmCkDFRQUeC0C7eArExk7aWwcROV1/a4cWml3fwCdLHZr/w+jcLL0ZdXazxJ7j
         O/MdslR1uPPl2rQcbKtEqnq0GSiujKsPS7nbbJkpR0HLzazeto7sWAWJmqT30oaK2yXA
         cHJLEmL8juw/8Bf+enLx/6pausdfE3zFhPX/IZ49Xu8ZEphPLfyLAAQr9+xHIikMTWS7
         RO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B1u3O83tTrsiNvPrp3hP0q70ExIGdl4r796ZiGkVvug=;
        b=m+EL53AYrUudHH5KtzcUOBn1aU2dpcBFKzEInlShUMMOd6mGNqR1UezEPBLsvJtz2h
         keK0eYy7WglhLOzZ1PkgG1t70TYxZrcgbFyodqEZUsqkOxN4rsIoHMWXf/9q9GTBPSVX
         Mub7scNt0iw4UOUpTNn9H46wDq/WG+jGiCciV91StiKVEiT307FB8C+PIgMn4eoqvAc3
         lmYTC2JSduoq9XB47+U1EFHJt+RIRLSctr7S3zZ6qrzSm7NZAebq2AmPWxhCNdAcAIEY
         wW2NtZYGM0xvtKaS7jaPXfRdfq+UeCLIPi7/tvM5ve9j1iBG0ts0c5ZdLpY3qzc0vHZb
         33ng==
X-Gm-Message-State: AOAM533dl70w4DSBBLprAydWJbxOdOdXrwIaEg3nvW0TvnNX3H2zbawO
        F6daiZgS5vp1muIHSC13eqxNuQ==
X-Google-Smtp-Source: ABdhPJy4FEFzTg0+fTXRvhWE6yGrciQw/nHrFSaBGjcKyTDZSaYbHcFMnMulKYfs8iaV+B3jf9pSAg==
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr17061597ilm.15.1610858489666;
        Sat, 16 Jan 2021 20:41:29 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7d62:41db:b863:bc92])
        by smtp.gmail.com with ESMTPSA id g13sm7969402iln.12.2021.01.16.20.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 20:41:28 -0800 (PST)
Date:   Sat, 16 Jan 2021 21:41:25 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <YAO/9YVceghRYo4T@google.com>
References: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112214337.GA10434@willie-the-truck>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 09:43:38PM +0000, Will Deacon wrote:
> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
> > > On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
> > > On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> > >> I will send an RFC soon for per-table deferred TLB flushes tracking.
> > >> The basic idea is to save a generation in the page-struct that tracks
> > >> when deferred PTE change took place, and track whenever a TLB flush
> > >> completed. In addition, other users - such as mprotect - would use
> > >> the tlb_gather interface.
> > >> 
> > >> Unfortunately, due to limited space in page-struct this would only
> > >> be possible for 64-bit (and my implementation is only for x86-64).
> > > 
> > > I don't want to discourage you but I don't think this would end up
> > > well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> > > and I've run into problems with this before while trying to do
> > > something similar.
> > 
> > Discourage, discourage. Better now than later.
> > 
> > It will be relatively easy to extend the scheme to be per-VMA instead of
> > per-table for architectures that prefer it this way. It does require
> > TLB-generation tracking though, which Andy only implemented for x86, so I
> > will focus on x86-64 right now.
> 
> Can you remind me of what we're missing on arm64 in this area, please? I'm
> happy to help get this up and running once you have something I can build
> on.

I noticed arm/arm64 don't support ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH.
Would it be something worth pursuing? Arm has been using mm_cpumask,
so it might not be too difficult I guess?
