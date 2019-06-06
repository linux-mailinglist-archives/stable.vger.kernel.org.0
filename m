Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9636F45
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfFFI7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 04:59:00 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:56260 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbfFFI7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 04:59:00 -0400
Received: by mail-it1-f193.google.com with SMTP id i21so1972043ita.5
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 01:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5G77k0j63/1dHq8s2sfTu2vMdGLfH/hNCHXcpdGXNs=;
        b=ZivuuU5W7ouwon2oensR1KO0lnkteogDIK19A1X47Zoe4snPwL4k8a1t5bMf+dLWtT
         VOolVZmdsbxr315riQpfgCTO9M+BvJkRcvx5Auo/80TgV0IhCbWvFr4sFhIGt5pUCR7p
         i87b/pz4u4Yr9UP4seBZ2JGEhaw0pLTuN8ocfr/jIWeSd8lpqqKt2h1mjpI1Ynfp2UNC
         VzR74ww2NeTIOGWs/UfvQLSaHJqdZ/zTI/r8bMHgyGx+cy9FxUNYzVH01iD8Idkz84l3
         /CRfUU2sfdy/GaQ2TCjNTb/MicRZ9JXaVGcI2tM9o7JlFVeYo7uhrw3d0WAbGh1nRi/7
         ODlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5G77k0j63/1dHq8s2sfTu2vMdGLfH/hNCHXcpdGXNs=;
        b=O/LHHfo+FRQwO5CMzjPZaa9VtvyWS4aj8aW5Wh4LjZEJknUScYttFEGKcvi8n+bs0y
         Y62xwEt8sOxI0hduIGpNnvWMQx8TdbdeimLpxMzrqD3kw6mSLdKJGCl0R6JYo0TZ21vw
         /WSJz8PDvPX2a0guqeBGxswAND4ji0zYKwFqFCwlbMUUEWqwI3oqryi44t4oGecFA9Mt
         YNnUMC9fdKIpaFlkQNnB2LFWYvFaq5Y70E+v6+73pHR6lwqPonmcStMYc3oZeUOXDedz
         fypHqQY2aGCDOHyIcpp9WfNL9I7/vjEgZ4smbpiV+DXnCM6/I7deXggpR5FEc0sY+X+T
         PPOQ==
X-Gm-Message-State: APjAAAVWRQSHUwDtIFS6c5KG3pYIYXhiBjuGGAJZ88Qeph+s3Nb91U11
        3KFN+HjduAOIgUnMPHx30dZXVkguL/IdTSHFk9oCqA==
X-Google-Smtp-Source: APXvYqxs7hWigkDcMTot18j8lPuAqIP8AayWjmmUPBwKknx0qEOV19fRGwdZcJYlzoL4iJVt5cCwDol/sNN/lZCGalk=
X-Received: by 2002:a24:740f:: with SMTP id o15mr14731071itc.76.1559811539672;
 Thu, 06 Jun 2019 01:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <779905244.a0lJJiZRjM@devpool35> <20190605162626.GA31164@kroah.com>
 <CAKv+Gu9QkKwNVpfpQP7uDd2-66jU=qkeA7=0RAoO4TNaSbG+tg@mail.gmail.com>
 <CAKwvOdnPcjESFrQRR_=cCVag3ZSnC0nBqF7+LFHrcDArT_segA@mail.gmail.com>
 <CAKv+Gu9Leaq_s2kVNzHx+zkdKFXgQVkouN3M56u5nou5WX=cKg@mail.gmail.com> <20190606070807.GA17985@kroah.com>
In-Reply-To: <20190606070807.GA17985@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 10:58:45 +0200
Message-ID: <CAKv+Gu_=aUmN76Wzy5kokgP6hcZPWAwW_7=ekqOawkfg7LPE3g@mail.gmail.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 at 09:08, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 06, 2019 at 08:55:29AM +0200, Ard Biesheuvel wrote:
> > On Wed, 5 Jun 2019 at 22:48, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > On Wed, Jun 5, 2019 at 11:42 AM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > > For the record, this is an example of why I think backporting those
> > > > clang enablement patches is a bad idea.
> > >
> > > There's always a risk involved with backports of any kind; more CI
> > > coverage can help us mitigate some of these risks in an automated
> > > fashion before we get user reports like this.  I meet with the
> > > KernelCI folks weekly, so I'll double check on the coverage of the
> > > stable tree's branches.  The 0day folks are also very responsive and
> > > I've spoken with them a few times, so I'll try to get to the bottom of
> > > why this wasn't reported by either of those.
> > >
> > > Also, these patches help keep Android, CrOS, and Google internal
> > > production kernels closer to their upstream sources.
> > >
> > > > We can't actually build those
> > > > kernels with clang, can we? So what is the point? </grumpy>
> > >
> > > Here's last night's build:
> > > https://travis-ci.com/ClangBuiltLinux/continuous-integration/builds/114388434
> > >
> >
> > If you are saying that plain upstream 4.9-stable defconfig can be
> > built with Clang, then I am pleasantly surprised.
>
> I know some specific configs can, there's no rule that I know of that
> 'defconfig' support is required.  But then again, it might also work,
> try it and see :)
>

Well, it is the rule that the arm64 maintainers use.

> > > Also, Android and CrOS have shipped X million devices w/ 4.9 kernels
> > > built with Clang.  I think this number will grow at least one order of
> > > magnitude imminently.
> > >
> >
> > I know that (since you keep reminding me :-)), but obviously, Google
> > does not care about changes that regress GCC support.
>
> What are you talking about?  Bugs happen all the time, what specifically
> did "Google" do to break gcc support?  If you are referring to this
> patch, and it is a regression, of course I will revert it.  But note
> that gcc and 4.9 works just fine for all of the other users right now,
> remember we do do a lot of testing of these releases.
>

Don't get me wrong: I am not blaming Google for this. But having
strict Documented/ stable-rules, violating them by backporting patches
that are clearly not bug fixes, and *then* saying 'bugs happen all the
time' makes no sense to me at all.
