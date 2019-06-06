Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448EA37000
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfFFJfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:35:16 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39287 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbfFFJfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 05:35:15 -0400
Received: by mail-io1-f67.google.com with SMTP id r185so137141iod.6
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 02:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHp49uQlU5yIys64xH4zvS9Cue2SVr3RQK/YgKDpiRc=;
        b=AN2CNz7CPqZzivrS99g5nvwP/o/SgLHBsg/4sHt3Gs4l8ZE8woyNIea7FNZ+ZLVBs9
         10My5n58np8Mog6V4seZA5WseaRXJL42mH3XFJho3fx5KAEGrLvh/B3CRxP75+hoXCZs
         yutgAOz6DZfYnD+C1SCiox4cawVPPNLBMCf9t8dwKI04O4kGiCd7c2Jjr/n8fqgzSIiS
         H1/AVWlWmtVtxOGX+Qm4cp0uMl8cAUWzNzyeVJwTJsegYoFIkG0U2hJ8qyVYHuOjZlDV
         WqbmmgQgR4GOiTE/hNEAD0H0E1uqB+MqNjm+3CN5fKeF1BIthAwuYe+Q8cxB4XWQ0DyS
         PWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHp49uQlU5yIys64xH4zvS9Cue2SVr3RQK/YgKDpiRc=;
        b=Ps6nk37VQFKLWBr2j2NCkkzxZHzxfCY1CY2F1XV+Eh1zlU/Oy0rF7wLhPgLYVP6LP9
         a8GQZ2blqZhdGVXZhZ0wF24ukrg6ZCgIc/1JLDXL8Dhfeq0OHQMxaWqKJ4iyDKfuZZmP
         u8RdiFWmDiSZc7FSDEKImZWzPTUVL72JAnyDiEkC//aOCYa6WLdRYd1aqjd1C8bel3I6
         b035cXFN8hfOfpxXvR2o/QzDroXTFjlY7+q7Snj0b7qbB2P01ufPvrsrR+boUb8+AQ6D
         1aILKRBFsREh3jmU6ETcJuY8Ob69C5dSQxprSahEBVIRUeY7L9EnGnevEMZbULFwGHwX
         C6Ew==
X-Gm-Message-State: APjAAAW4cmy1mtFG+wATJNJjI6FgmyMKBgmJ/yIEQUgJ73JrdFaHFkc/
        oRPY1GbAELZeBuxGTz+Gz1ZLiBRYFHB2pkJjppvcOQ==
X-Google-Smtp-Source: APXvYqwYiF7FPCLPAO+cIFA18Sip3ZuB6prYvOwBxGiLac3826Dt6ufVgilOW70nYctUeU+5al9/Hx5B739dM7xe0tI=
X-Received: by 2002:a6b:e608:: with SMTP id g8mr5429025ioh.88.1559813714855;
 Thu, 06 Jun 2019 02:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <779905244.a0lJJiZRjM@devpool35> <20190605162626.GA31164@kroah.com>
 <CAKv+Gu9QkKwNVpfpQP7uDd2-66jU=qkeA7=0RAoO4TNaSbG+tg@mail.gmail.com>
 <CAKwvOdnPcjESFrQRR_=cCVag3ZSnC0nBqF7+LFHrcDArT_segA@mail.gmail.com>
 <CAKv+Gu9Leaq_s2kVNzHx+zkdKFXgQVkouN3M56u5nou5WX=cKg@mail.gmail.com>
 <20190606070807.GA17985@kroah.com> <CAKv+Gu_=aUmN76Wzy5kokgP6hcZPWAwW_7=ekqOawkfg7LPE3g@mail.gmail.com>
In-Reply-To: <CAKv+Gu_=aUmN76Wzy5kokgP6hcZPWAwW_7=ekqOawkfg7LPE3g@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 11:34:54 +0200
Message-ID: <CAKv+Gu9qg0K44hWtKH9vycxhUF4e2zB87kLqw33Jt+Shc1+9HQ@mail.gmail.com>
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

On Thu, 6 Jun 2019 at 10:58, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 6 Jun 2019 at 09:08, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jun 06, 2019 at 08:55:29AM +0200, Ard Biesheuvel wrote:
> > > On Wed, 5 Jun 2019 at 22:48, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > > >
> > > > On Wed, Jun 5, 2019 at 11:42 AM Ard Biesheuvel
> > > > <ard.biesheuvel@linaro.org> wrote:
> > > > > For the record, this is an example of why I think backporting those
> > > > > clang enablement patches is a bad idea.
> > > >
> > > > There's always a risk involved with backports of any kind; more CI
> > > > coverage can help us mitigate some of these risks in an automated
> > > > fashion before we get user reports like this.  I meet with the
> > > > KernelCI folks weekly, so I'll double check on the coverage of the
> > > > stable tree's branches.  The 0day folks are also very responsive and
> > > > I've spoken with them a few times, so I'll try to get to the bottom of
> > > > why this wasn't reported by either of those.
> > > >
> > > > Also, these patches help keep Android, CrOS, and Google internal
> > > > production kernels closer to their upstream sources.
> > > >
> > > > > We can't actually build those
> > > > > kernels with clang, can we? So what is the point? </grumpy>
> > > >
> > > > Here's last night's build:
> > > > https://travis-ci.com/ClangBuiltLinux/continuous-integration/builds/114388434
> > > >
> > >
> > > If you are saying that plain upstream 4.9-stable defconfig can be
> > > built with Clang, then I am pleasantly surprised.
> >
> > I know some specific configs can, there's no rule that I know of that
> > 'defconfig' support is required.  But then again, it might also work,
> > try it and see :)
> >
>
> Well, it is the rule that the arm64 maintainers use.
>
> > > > Also, Android and CrOS have shipped X million devices w/ 4.9 kernels
> > > > built with Clang.  I think this number will grow at least one order of
> > > > magnitude imminently.
> > > >
> > >
> > > I know that (since you keep reminding me :-)), but obviously, Google
> > > does not care about changes that regress GCC support.
> >
> > What are you talking about?  Bugs happen all the time, what specifically
> > did "Google" do to break gcc support?  If you are referring to this
> > patch, and it is a regression, of course I will revert it.  But note
> > that gcc and 4.9 works just fine for all of the other users right now,
> > remember we do do a lot of testing of these releases.
> >
>
> Don't get me wrong: I am not blaming Google for this. But having
> strict Documented/ stable-rules, violating them by backporting patches
> that are clearly not bug fixes, and *then* saying 'bugs happen all the
> time' makes no sense to me at all.

BTW I hit the same issue immediately building 4.9.180 defconfig +
CONFIG_RANDOMIZE_BASE=y, using my distro GCC (6.3.0), so I'd say the
testing coverage is not sufficient.
