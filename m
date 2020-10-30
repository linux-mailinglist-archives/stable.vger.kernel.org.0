Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2172A0AB7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgJ3QIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJ3QIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:08:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CC9C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:08:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f21so3172351plr.5
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X4h7VqbjWCTGqCw8svcGQvNFpVYxdtzFtyWsEhbWn98=;
        b=La2F8tfdO9gPtLk6NBLoFPncEHH9xi/vq3BgzPxpACZ7qaJfeGgyrKtM1nxKV3oomF
         rpz8wX+Fp1XVY6j6jhskM1DYBiySNJURTeKLF27RCm9qdfFhWZXYtL5XO13glKbtz1AT
         XBUlf64tNVx0JIyE5tHxQ0LInxano5sCS6Pj5pY1LNW4JwZWEi/3IoCqIm2wohyQ+tiv
         jz0OJOW3UVF9GzVizciJNrkARHPWxDt0EMn9DBtqVhPZynsQxtzFU7eW18tQ5u66zLiq
         yvzLwt2wzMHcceG2StAbTXfp6+4x6lGe9Pmhjm9NDjJ09ArcsYYF8z388I9KIvwZ7SPM
         q8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X4h7VqbjWCTGqCw8svcGQvNFpVYxdtzFtyWsEhbWn98=;
        b=bouZpknYfXDPjdNtTkm4QYFT/w4VNthMIzt3Di2ihKUZ6ftRWY991/7W9DtxB9KKi4
         6p4lrYSLKPQzKdgteD4ttsholqWsWHm5m2oSCpN2Yjb03roxPpC7WIkimvgUYBnBepWm
         T//OFJ89HSfuiiUToqTouySdpehrLzVwmfTYTtXMYadofIBPlWEExGfPJXKR6t9Hpj5Y
         WMkw/tDFfl6KZzWgQS9z8U2XJGgR7+s66ZnRHJW9tgzBI8P3zhRkSF0MBjWZLT7wL/qf
         yBm0gpzV/uzUUQN21N1ALb5nHD+Ns4y4Akt03/qDKf0ei7kv99BUdGWE5uDeN5i48i92
         nUpw==
X-Gm-Message-State: AOAM533rV7Mm4pYQbUgCqt63HT3Z6LT7dDpgpfCOmoIw5F7iVM1fz4Us
        1dqxSoORZX6d0ds0BzjblNwhfXXXAtmWhqrRIpo08A==
X-Google-Smtp-Source: ABdhPJwmn80tRBWXBbGzsZF1fDNlJuss+2qqaEfCoYXaiWaOKg5IbXI7+ZBt3a2mRiv+aOpOj5ixiNK7VB3jrC5am5o=
X-Received: by 2002:a17:902:7298:b029:d4:c71a:357a with SMTP id
 d24-20020a1709027298b02900d4c71a357amr9533788pll.38.1604074127724; Fri, 30
 Oct 2020 09:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201029180525.1797645-1-maskray@google.com> <a7d7b3d9-a902-346c-0b9c-d2364440e70b@kernel.org>
In-Reply-To: <a7d7b3d9-a902-346c-0b9c-d2364440e70b@kernel.org>
From:   =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
Date:   Fri, 30 Oct 2020 09:08:35 -0700
Message-ID: <CAFP8O3JEOXJumFtPh4dwiYT2FHt+27epqnBUQ-2622Mm29trcQ@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 2:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 29. 10. 20, 19:05, Fangrui Song wrote:
> > Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
> > memset/memmove/memcpy functions") added .weak directives to
> > arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_=
*
> > macros.
>
> There were no SYM_FUNC_START_* macros in 2015.

include/linux/linkage.h had WEAK in 2015 and WEAK should have been
used instead. Do I just need to fix the description?

> > This can lead to the assembly snippet `.weak memcpy ... .globl
> > memcpy`
>
> SYM_FUNC_START_LOCAL(memcpy)
> does not add .globl, so I don't understand the rationale.

There is no problem using
.weak
SYM_FUNC_START_LOCAL
just looks suspicious so I changed it, too.

> > which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> > memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> > https://reviews.llvm.org/D90108) will error on such an overridden symbo=
l
> > binding.
> >
> > Use the appropriate SYM_FUNC_START_WEAK instead.
> >
> > Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmov=
e/memcpy functions")
> > Reported-by: Sami Tolvanen <samitolvanen@google.com>
> > Signed-off-by: Fangrui Song <maskray@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >   arch/x86/lib/memcpy_64.S  | 4 +---
> >   arch/x86/lib/memmove_64.S | 4 +---
> >   arch/x86/lib/memset_64.S  | 4 +---
> >   3 files changed, 3 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> > index 037faac46b0c..1e299ac73c86 100644
> > --- a/arch/x86/lib/memcpy_64.S
> > +++ b/arch/x86/lib/memcpy_64.S
> > @@ -16,8 +16,6 @@
> >    * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
> >    */
> >
> > -.weak memcpy
> > -
> >   /*
> >    * memcpy - Copy a memory block.
> >    *
> > @@ -30,7 +28,7 @@
> >    * rax original destination
> >    */
> >   SYM_FUNC_START_ALIAS(__memcpy)
> > -SYM_FUNC_START_LOCAL(memcpy)
> > +SYM_FUNC_START_WEAK(memcpy)
> >       ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
> >                     "jmp memcpy_erms", X86_FEATURE_ERMS
> >
> > diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> > index 7ff00ea64e4f..41902fe8b859 100644
> > --- a/arch/x86/lib/memmove_64.S
> > +++ b/arch/x86/lib/memmove_64.S
> > @@ -24,9 +24,7 @@
> >    * Output:
> >    * rax: dest
> >    */
> > -.weak memmove
> > -
> > -SYM_FUNC_START_ALIAS(memmove)
> > +SYM_FUNC_START_WEAK(memmove)
> >   SYM_FUNC_START(__memmove)
> >
> >       mov %rdi, %rax
> > diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
> > index 9ff15ee404a4..0bfd26e4ca9e 100644
> > --- a/arch/x86/lib/memset_64.S
> > +++ b/arch/x86/lib/memset_64.S
> > @@ -6,8 +6,6 @@
> >   #include <asm/alternative-asm.h>
> >   #include <asm/export.h>
> >
> > -.weak memset
> > -
> >   /*
> >    * ISO C memset - set a memory block to a byte value. This function u=
ses fast
> >    * string to get better performance than the original function. The c=
ode is
> > @@ -19,7 +17,7 @@
> >    *
> >    * rax   original destination
> >    */
> > -SYM_FUNC_START_ALIAS(memset)
> > +SYM_FUNC_START_WEAK(memset)
> >   SYM_FUNC_START(__memset)
> >       /*
> >        * Some CPUs support enhanced REP MOVSB/STOSB feature. It is reco=
mmended
> >
>
>
> --
> js
> suse labs



--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
