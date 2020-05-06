Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A413C1C6CC6
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgEFJWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 05:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728559AbgEFJWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 05:22:35 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF93C061A0F;
        Wed,  6 May 2020 02:22:34 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a21so1553791ljb.9;
        Wed, 06 May 2020 02:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=oa3P1hvJ9JWgjoriWyaE6QqHlQBf9qEx9mp41zilS0I=;
        b=eLBC11ZtPyd8FTayDY0uqooiZnpRr1qiuZ76CPLefg1fOLwOcQQm+i7+Japb0mAdLI
         zyhuxC+Hkjbr1VmR1XYu8l4rsh8a1IC5mMK1LEHxyi+Gma0VJtQqJ7l9dmAjtXaoS6AC
         1v58SBlH+3SoD+gTp+bTIdL2G/FKmTd/tnQRi8dOxFmOD2HdPC+YsbttMkciqn7vHXEL
         3uPAAwiBWk6iFBAoWpc2hal7KpcYhLZqZMkQwOPXxncwC6SL6TrSjXoFP1DEcwa+TptN
         s7x+sQWyd7iyDCyyGhz0Y7BMHxKIXtOBlVWgo74WNAO9fyJz/wIRgph3NnIk+9NtfX3R
         aLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=oa3P1hvJ9JWgjoriWyaE6QqHlQBf9qEx9mp41zilS0I=;
        b=jtfYur0bhPhx3bspTLJCINDxYa5qFp2ujJNjZjxFDiB36xOo4b4bbwDJoIZE04zhEE
         ognCC225+y91ow6VBNHQjdfg6da+RnVjwDW21S/6cMhFsS67T6F9xme59ICqFZCOxcph
         ouOS9OT1wcS3jRzlJP2Vg951p4lhi+UU9Ez+wTlvv7NJ/fNQcUfo+G0gUTBnSAma3Jb0
         w8rN+YtWZ79wg9mq+sgAvM+N+BKx9Q5uwJbpwWxVL08uK5r+ckXzFABZzmrpEL6EIJhI
         gPIsgPSOvjjtBhDV+JqoD9mvFY2h7LZ0+y6GnWnaydH9sOgLm8d8WrNZvZlh5cBVtIsR
         IYIQ==
X-Gm-Message-State: AGi0PuYnqLS17+bEVSpj0n4MaO3NRD01REiedgzxmxt9Q5S2j6SQOiU9
        7n1vBjAYfxXbJ4RWVwx9TvjdPWyoAvjF+jmAKD4=
X-Google-Smtp-Source: APiQypLb3/ZlGRa6gpg6Sn8UR5LHRo20nItZ7tPR6vGsur8ge7hKXcp2BPav8kBQhasdNFllU582mMaLnJKnznKLL6o=
X-Received: by 2002:a05:651c:385:: with SMTP id e5mr4345047ljp.208.1588756952993;
 Wed, 06 May 2020 02:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com> <20200506043028.GA663805@ubuntu-s3-xlarge-x86>
In-Reply-To: <20200506043028.GA663805@ubuntu-s3-xlarge-x86>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 6 May 2020 11:22:34 +0200
Message-ID: <CA+icZUUnrku_CLpaRchV-tNA4VFDhoYg7pnZuAA55cwghz00_A@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 6, 2020 at 6:30 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, May 05, 2020 at 10:44:22AM -0700, Nick Desaulniers wrote:
> > From: Sedat Dilek <sedat.dilek@gmail.com>
> >
> > It turns out that if your config tickles __builtin_constant_p via
> > differences in choices to inline or not, this now produces invalid
> > assembly:
> >
> > $ cat foo.c
> > long a(long b, long c) {
> >   asm("orb\t%1, %0" : "+q"(c): "r"(b));
> >   return c;
> > }
> > $ gcc foo.c
> > foo.c: Assembler messages:
> > foo.c:2: Error: `%rax' not allowed with `orb'
> >
> > The "q" constraint only has meanting on -m32 otherwise is treated as
> > "r".
> >
> > This is easily reproducible via Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> > or Clang+allyesconfig.
>
> For what it's worth, I don't see this with allyesconfig.
>
> > Keep the masking operation to appease sparse (`make C=1`), add back the
> > cast in order to properly select the proper 8b register alias.
> >
> >  [Nick: reworded]
> >
> > Cc: stable@vger.kernel.org
>
> The offending commit was added in 5.7-rc1; we shouldn't need to
> Cc stable since this should be picked up as an -rc fix.
>
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/961
> > Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> > Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Reported-by: kernelci.org bot <bot@kernelci.org>
> > Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> > Suggested-by: Ilie Halip <ilie.halip@gmail.com>
>
> Not to split hairs but this is Ilie's diff, he should probably be the
> author with Sedat's Reported-by/Tested-by.
>
> https://github.com/ClangBuiltLinux/linux/issues/961#issuecomment-608239458
>
> But eh, it's all a team effort plus that can only happen with Ilie's
> explicit consent for a Signed-off-by.
>

Digital dementia... Looking 3 weeks back I have put all relevant
informations into the patches in [1], mentionning the diff is from
Ilie.
Ilie for what reason did not react on any response for 3 weeks in the
CBL issue-tracker.
I think Nick wants to quickly fix the Kernel-CI-Bot issue seen with Clang.
Personally, I hope this patch will be upstreamed in (one of) the next
RC release.

I agree on CC:stable can be dropped.
Check causing commit-id:

$ git describe --contains 1651e700664b4
v5.7-rc1~122^2

Thanks.

Regards,
- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/961#issuecomment-613207374

> I am currently doing a set of builds with clang-11 with this patch on
> top of 5.7-rc4 to make sure that all of the cases I have found work.
> Once that is done, I'll comment back with a tag.
>
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  arch/x86/include/asm/bitops.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> > index b392571c1f1d..139122e5b25b 100644
> > --- a/arch/x86/include/asm/bitops.h
> > +++ b/arch/x86/include/asm/bitops.h
> > @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> >       if (__builtin_constant_p(nr)) {
> >               asm volatile(LOCK_PREFIX "orb %1,%0"
> >                       : CONST_MASK_ADDR(nr, addr)
> > -                     : "iq" (CONST_MASK(nr) & 0xff)
> > +                     : "iq" ((u8)(CONST_MASK(nr) & 0xff))
> >                       : "memory");
> >       } else {
> >               asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> > @@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> >       if (__builtin_constant_p(nr)) {
> >               asm volatile(LOCK_PREFIX "andb %1,%0"
> >                       : CONST_MASK_ADDR(nr, addr)
> > -                     : "iq" (CONST_MASK(nr) ^ 0xff));
> > +                     : "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> >       } else {
> >               asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> >                       : : RLONG_ADDR(addr), "Ir" (nr) : "memory");
> > --
> > 2.26.2.526.g744177e7f7-goog
> >
>
> Cheers,
> Nathan
