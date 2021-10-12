Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58C429D53
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 07:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhJLFrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 01:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhJLFri (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 01:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2535C60EB6;
        Tue, 12 Oct 2021 05:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634017536;
        bh=e4lNi6oL+ZJGLDOqDqTU6x8+bOlEd0FA7f2KB1xQTMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IgUVWKIfYpkER152yW5CFGy8tRnvBg2jjaHn/CWAnnxbXccke/48widvimvVMd8y6
         E9Wzvho3/5nqf8ICZjvW5yVWm2Cue1Lncerlx3VawmHL+aZZMQ3CNY8g6kPEH60IqQ
         mtT6S3ITHuqe5jXEtFKULZlwHnQ4g49EeJA4YedE=
Date:   Tue, 12 Oct 2021 07:45:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     stable <stable@vger.kernel.org>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, jack@suse.cz,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Message-ID: <YWUg/FIt7GyGJkAu@kroah.com>
References: <20211012015244.693594-1-surenb@google.com>
 <CAJuCfpF7mZ9vxV2c4D3+rOQw3ky57JULY00==eCrT0e0ZbHPWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpF7mZ9vxV2c4D3+rOQw3ky57JULY00==eCrT0e0ZbHPWA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 06:55:39PM -0700, Suren Baghdasaryan wrote:
> On Mon, Oct 11, 2021 at 6:52 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Sorry Greg, I must have screwed up something and this "From:" line
> appeared twice. Do you want me to resent these backports or you can
> simply drop the duplicate line?

I will fix it up, no worries.

greg k-h
