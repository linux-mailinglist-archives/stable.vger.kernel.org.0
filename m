Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B182B5EC1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgKQL5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgKQL5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:57:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2435E2223C;
        Tue, 17 Nov 2020 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605614253;
        bh=kfXrXhyHzwT2fJSKCK/glCo2mjWWrAZU7vVsb+igxo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZBKk0Ttbw+yCkUZHvkZUnatYagCbSlTcCmY5fE3P8OW2vj0/fEWLdnfr1GFigOh5L
         oWgeXICfSgGvaxRWG4u8iUjbb9cHJ3QGCN98+bUY2f9U2WUOktiKwZtfsZQjzcsJo/
         Wh+aVaJ3LfqzBB2eGlSK/6RIUt4kztmEBQVerOBk=
Date:   Tue, 17 Nov 2020 12:58:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        kiyin@tencent.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [v4.9.y] backport of few missed perf fixes
Message-ID: <X7O63sAoymm4f82B@kroah.com>
References: <20201112133112.w3z6vyq5m5p7aowx@debian>
 <X7OynckqadusPjk2@kroah.com>
 <CADVatmM6nQuKJ4c2nx4iQjwy8aQAYCW3YnfCy43GgFkgcV=-+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADVatmM6nQuKJ4c2nx4iQjwy8aQAYCW3YnfCy43GgFkgcV=-+A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 11:47:13AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Nov 17, 2020 at 11:22 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 12, 2020 at 01:31:12PM +0000, Sudip Mukherjee wrote:
> > > Hi Greg, Sasha,
> > >
> > > These are few missing commits for stable v4.9.y branch.
> >
> > <snip>
> >
> > >
> > > Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> > > Signed-off-by: "kiyin(尹亮)" <kiyin@tencent.com>
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
> > > Cc: Anthony Liguori <aliguori@amazon.com>
> > > --
> > >  kernel/events/core.c | 12 +++++-------
> > >  1 file changed, 5 insertions(+), 7 deletions(-)
> > >
> > > [sudip: Backported to 4.9: adjust context]
> > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > > ---
> > >  kernel/events/core.c | 10 ++++------
> > >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > Odd way to add your s-o-b :)
> 
> Yeah, I know. :(
> 
> But the file changed line before my s-o-b was part of the original
> commit message, and so I had to add the s-o-b after that to preserve
> the original message.

But don't keep two diffstats in there, that's not ok.
