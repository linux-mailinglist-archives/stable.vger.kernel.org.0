Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3270B09
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 23:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfGVVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 17:12:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41327 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729996AbfGVVMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 17:12:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so7909244pgg.8
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 14:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bx2/ePKA8H3cgL5H2m2rJiaOZ0YWGIns7rKdFWu1CvE=;
        b=cpwkkjOLk25nBbTGu2WNpjUDYdO+q1x07ANNm/j3n6/Ri82GyGhsmPlLyNydLB84me
         c88eJ3vF2boELtTlxfZl5HAuOq6KfFavmpEIRW81ecH92XPTLO7lPzU71NUNl+dtHtaX
         kWTBdNvHFtNYi2ySsiiFM6ZvTn1xfilyYzw7kU+bcbORNN0SHD5CAVr0dE7egLY7Tf6B
         J4uusXzpXcelhxkL8Yh2yCaLynfgNkqns22rVNk0OQg3JD9yPv2xeFdbnx0W8ZcW5euK
         XTgZLd5NBCrFenu+gJTV2jDJX+gLtOgIvPxgWCW7E/6mA2mfjlqtfPAy8PwAALWwushW
         sIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bx2/ePKA8H3cgL5H2m2rJiaOZ0YWGIns7rKdFWu1CvE=;
        b=JRd4Ac30dTeVjb93i+a2Bz1JYgKQ5/s6NCyqn8nUDCt8gDyIqn2ZFsRjHoJMnMTVCm
         cP8TsDSIBH16S6wW5yy3SjDIPcJyY7mqJMJQj3G17h/FLwE7lgxtkId1kUVMX237zg1V
         ePDiMZtaGudLyaw7+y9Sf8ORXTs3NFQOv3XVfI7JmCvdVA7OgHU4z4oewPA5cut6Q+tH
         9W+xVBp2Us+F4TDxAbZf9cSwe3BH6tc+1/VfD1p7cQv8JOOXkrHsZ7l6G2g09V+DrJvd
         21UoW85zLDCRNWhiNabj84PBS0Pj6rExuE8Of6fG78D50/lA5KBd6VTmQ8/HhlcdQg1U
         fAPQ==
X-Gm-Message-State: APjAAAV+/Kb3dM7OkCxykhR3ulBNniwxaPyBkGDqPgB0F0f/9l8qmUGf
        3cLlrn1bYHKFk5liV8DqVxFbGNjzVEcCLsUoG9Kc+g==
X-Google-Smtp-Source: APXvYqzdifltGHrEL/Vim3PWtyGDjD5Rl7cxRAZMB2C1K4hdOBZNUzpow3J0+KekukdWAXzghEqoDA9TevL/JhaYMO4=
X-Received: by 2002:a65:5687:: with SMTP id v7mr74705885pgs.263.1563829939659;
 Mon, 22 Jul 2019 14:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
 <20190718000206.121392-2-vaibhavrustagi@google.com> <CAKwvOdkHHNR7utufOcDwAOgBEA9MnOLh713Gaq01R=n26EyjZw@mail.gmail.com>
 <20190719081732.GF3419@hirez.programming.kicks-ass.net>
In-Reply-To: <20190719081732.GF3419@hirez.programming.kicks-ass.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 22 Jul 2019 14:12:08 -0700
Message-ID: <CAKwvOdknUgYS3R5+g0=wFb2SB3ojfhz667Zv_9UZj3nM0Z_PdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to Makefile
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 1:17 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jul 18, 2019 at 02:34:44PM -0700, Nick Desaulniers wrote:
> > On Wed, Jul 17, 2019 at 5:02 PM Vaibhav Rustagi
> > <vaibhavrustagi@google.com> wrote:
> > >
> > > Compiling the purgatory code with clang results in using of mmx
> > > registers.
> > >
> > > $ objdump -d arch/x86/purgatory/purgatory.ro | grep xmm
> > >
> > >      112:       0f 28 00                movaps (%rax),%xmm0
> > >      115:       0f 11 07                movups %xmm0,(%rdi)
> > >      122:       0f 28 00                movaps (%rax),%xmm0
> > >      125:       0f 11 47 10             movups %xmm0,0x10(%rdi)
> > >
> > > Add -mno-sse, -mno-mmx, -mno-sse2 to avoid generating SSE instructions.
> > >
> > > Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > > ---
> > >  arch/x86/purgatory/Makefile | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> > > index 3cf302b26332..3589ec4a28c7 100644
> > > --- a/arch/x86/purgatory/Makefile
> > > +++ b/arch/x86/purgatory/Makefile
> > > @@ -20,6 +20,7 @@ KCOV_INSTRUMENT := n
> > >  # sure how to relocate those. Like kexec-tools, use custom flags.
> > >
> > >  KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
> > > +KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-sse2
> >
> > Yep, this is a commonly recurring bug in the kernel, observed again
> > and again for Clang builds.  The top level Makefile carefully sets
> > KBUILD_CFLAGS, then lower subdirs in the kernel wipe them away with
> > `:=` assignment. Invariably important flags don't always get re-added.
> > In this case, these flags are used in arch/x86/Makefile, but not here
> > and should be IMO.  Thanks for the patch.
>
> Should we then not fix/remove these := assignments?

Good point, it's actually pretty straightforward to do so.  It just
will invert the order of patches in the series, as then the
memcpy/memset infinite recursion is now guaranteed with
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y (without the other patch in this
series).  Did the x86 maintainers have thoughts on their favorite
implementation of memset/memcpy for me to use from the thread from the
other patch in the series? I'll just resend with this fix and maybe we
can discuss there and spin a v3 if needed.

-- 
Thanks,
~Nick Desaulniers
