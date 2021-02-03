Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D621730D9D4
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 13:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhBCMbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 07:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhBCMbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 07:31:42 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1351C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 04:31:01 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u20so10899644iot.9
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 04:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=7YYFHaimUN1BMIpwAYU2USpJeCCQFRuO4lnSFSGgXbc=;
        b=A2NyX2LtJn0HGC3nJHq4smoRlbLRkSl+v1NOjAf+TDVm8tHB9EqiIsC4Kw0kHNeLWx
         ID1fobeSs5nrWTMtgXLJkG/MrTfWUB896tW5jfldtBspWQY0m6MBvfh2jZ1zzmiD8jzc
         UvorfJS0BC74uZjv3LLS3Zs7gfKkMQG+ioNayi34lsS1NY6o54Sae8FDHO64sE4zYTdK
         qEReYeUzTgMRYvDWLLRkLzkUQNtZvPq5ruo/dLPuzlNbMuFNPySqr1dvoGqBftPs1EmZ
         Lu0prJAOufaGYVwzwns55NrcNOjjBrOiD8Sv0edFbuFmbJZ4rqd5praG51gkV0bnpldD
         HNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=7YYFHaimUN1BMIpwAYU2USpJeCCQFRuO4lnSFSGgXbc=;
        b=ViEhPQW7KqB6Fdf8SS5CfGmeQsgwizvEZAfVvURHKBttwEOI7lNY3Ps2TQ+gVPtFtP
         +Vj+W9aSh879cXK13/ACDV+5Ayz83XVdMazjIZqml2qEyUgwtLM2EC0FrTPnDENVJ7g+
         YP9wyG+Gm+9plnjOi3NVWoT7pw4wq+bqAnCHsBkQUe6Np1N7IRNG6FOESBmcggbUKTyW
         6gvwj1y6W69mbGwyjaDbcrCGzSJ1vsERwygDRjrrdOqhmQHLR1NLLd7w35/RgMOMgCoE
         l0Qpb7/lpYlN6sO3cLpSdt2CInXdMHtWY4J+wkdkn6zrCe2Dhuc71qRN6osr9JQAIat2
         Q+4w==
X-Gm-Message-State: AOAM531ONxfZ2a2iFijcw2W1cr9RSApFKwTc4DIe9PCmR60Xa+eDfYvT
        Kbi/+etsyhhqnakdBS0VS//V9htqVA0POPesc7w=
X-Google-Smtp-Source: ABdhPJx6sW/xng+7dc2TRua77l7RAeSBmADLEW1xzL4dgUlhpxlmlSY2ZivQwrrpI0owX+QR02PWuVaA/BPVVe3i1vc=
X-Received: by 2002:a05:6638:251:: with SMTP id w17mr2665978jaq.138.1612355461352;
 Wed, 03 Feb 2021 04:31:01 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
 <YBlONpmGoM0/qG7R@kroah.com> <CA+icZUXeK4_5A8YzkuQUcP9jhZKvYrCtWbcgToV-FDE+VY=BvQ@mail.gmail.com>
 <YBp1QM3HFjV4kTwM@kroah.com>
In-Reply-To: <YBp1QM3HFjV4kTwM@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 3 Feb 2021 13:30:50 +0100
Message-ID: <CA+icZUVKG8YnFfwBYmkKtvsf5zK6yPty2g_0wk2-h6XqRF=otA@mail.gmail.com>
Subject: Re: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi
 THUNK macro argument"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 3, 2021 at 11:04 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 03, 2021 at 10:21:56AM +0100, Sedat Dilek wrote:
> > On Tue, Feb 2, 2021 at 2:06 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Feb 01, 2021 at 08:50:52PM +0100, Sedat Dilek wrote:
> > > > Hi,
> > > >
> > > > you have in Linux 5.10.13-rc1:
> > > >
> > > > "x86/entry: Emit a symbol for register restoring thunk"
> > > >
> > > > While that discussion Boris and Peter recommended to remove unused code via:
> > > >
> > > > "x86/entry: Remove put_ret_addr_in_rdi THUNK macro argument"
> > > > ( upstream commit 0bab9cb2d980d7c075cffb9216155f7835237f98 )
> > > >
> > > > OK, this has no CC:stable but I have both as a series in my local Git
> > > > and both were git-pulled from [1].
> > > > What do you think?
> > >
> > > What bug is this fixing that requires this in 5.10?
> > >
> >
> > Commit 0bab9cb2d980d7c075cffb9216155f7835237f98 removed unused logic.
> >
> > So-to-say:
> > Fixes: 320100a5ffe5 ("x86/entry: Remove the TRACE_IRQS cruft")
> >
> > The commit was first introduced with Linux v5.8-rc1:
> >
> > $ git describe --contains 320100a5ffe5
> > v5.8-rc1~21^2~28
> >
> > As Linux v5.10.y is an LTS IMHO I hoped it is worth removing unused code.
> > You better know the rules for stable-linux, so I leave it to you, Greg.
>
> The rules are listed here:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
> So please let me know what this patch fixes based on that and I will be
> glad to merge it.
>

[ CC Boris Peter & Nick ]

I looked at the rules.
The mentioned patch looks like a nice "cleanup" to me.
If you are strict with the rules... Let's hear the CCed folks.

Thanks for your/the feedback (in advance).

- Sedat -
