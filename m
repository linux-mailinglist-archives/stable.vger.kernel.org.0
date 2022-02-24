Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694654C3119
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiBXQSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiBXQRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:17:44 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23F143495
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:17:04 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j12so450826ybh.8
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M6/DsYcMdCQ5Jv7h2HtppDAD63hulQRUnEll08wdM0w=;
        b=MMxNIcwAG1rEPw9GYtGcc1MbySE+4/aZhxOK9Arfa8JLcnH0cfZ64TEtJey0SODZ7C
         QBiByPS+i5aydu3vs8H0awLJPCpykYptJU2HmxOfIPQy8vs+fSr3SUJJNxd/KVNH/kNZ
         gjoFbkx/CDEUSFXXCM5T51pKHiPWXVwYVlaXGo94O4Cmtc1DR+BED9zBq+ATBB0gXAsU
         9w8HCZaC1ZZAwHI9UCrFptnAwn1x1krO6meiyDfKd7+rSVqIb0MYvV2xW4o0BAq/KmF8
         q69HHptkg51lHY1WR5Ir2y0+/4WIeubhQ74U4NMz+V9vB19oH7Z86WtRP9Ikzr/QZWt6
         IMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6/DsYcMdCQ5Jv7h2HtppDAD63hulQRUnEll08wdM0w=;
        b=WtTjIchUi0AAiHasTgVdQMO4rOUzIRum8Rg9MGbU/pTolKllOedsFUjgMcndOojfKk
         eeulcc5kkXOef7/0wjXbNoXBQCD8tkH9QdUurRtpYHEqYTy/HrubVEtBT9KHlr0Usb/B
         HP+wz9Q3XQgIdxq7U03mPjvgncjXrf8qNknkM+pzaSPlUAkaxGQhijd/SCre42qlQ9Te
         NCi9xa7pkcxQ46GGXQhhNV68ksNQ46alJI11295mC0dZukyjDM2f7iB1HYyPw57IBzaQ
         lbtdIQlvL+rH2qaBT7eyXckp6jOAy0YvULuNKAxDVJzcQGansXx4EDrHAxCXAwOBvcqt
         L6Mw==
X-Gm-Message-State: AOAM533RxXbZL03pmJSHajp3C3biTwajjej1gVHDFsuNk/04zwioLQEh
        MGtNsJeEbR4ZsDm7fMuy9LX00Jw1YaOJvk5K/MHIj5qdpSU=
X-Google-Smtp-Source: ABdhPJx1PBFTzicPX+FhslEYT6ZwXv/E5aXyEeLEMZmHKuUh6nEpZizMLlaeQ3T+XDiafTBRLEZRxAV7na7hyyARMPw=
X-Received: by 2002:a25:ad9b:0:b0:624:5db2:2084 with SMTP id
 z27-20020a25ad9b000000b006245db22084mr3073965ybi.132.1645719140249; Thu, 24
 Feb 2022 08:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
 <20220223135820.2252470-2-anders.roxell@linaro.org> <871qzsphfv.fsf@mpe.ellerman.id.au>
In-Reply-To: <871qzsphfv.fsf@mpe.ellerman.id.au>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 24 Feb 2022 17:12:09 +0100
Message-ID: <CADYN=9L7L7+DOA6qYj4aOgg9rBhOrUCk5b4K5tr6wZ709WpsyA@mail.gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Feb 2022 at 13:39, Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Hi Anders,

Hi Michael,

>
> Thanks for these, just a few comments below ...

I will resolve the comments below and resend a v2 shortly.

Cheers,
Anders

>
> Anders Roxell <anders.roxell@linaro.org> writes:
> > Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> > 2.37.90.20220207) the following build error shows up:
> >
> >  {standard input}: Assembler messages:
> >  {standard input}:1190: Error: unrecognized opcode: `stbcix'
> >  {standard input}:1433: Error: unrecognized opcode: `lwzcix'
> >  {standard input}:1453: Error: unrecognized opcode: `stbcix'
> >  {standard input}:1460: Error: unrecognized opcode: `stwcix'
> >  {standard input}:1596: Error: unrecognized opcode: `stbcix'
> >  ...
> >
> > Rework to add assembler directives [1] around the instruction. Going
> > through the them one by one shows that the changes should be safe.  Like
> > __get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
> > which according to the name is specific to power9.  And __raw_rm_read*()
> > are only called in things that are powernv or book3s_hv specific.
> >
> > [1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo
> >
> > Cc: <stable@vger.kernel.org>
> > Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  arch/powerpc/include/asm/io.h        | 46 +++++++++++++++++++++++-----
> >  arch/powerpc/include/asm/uaccess.h   |  3 ++
> >  arch/powerpc/platforms/powernv/rng.c |  6 +++-
> >  3 files changed, 46 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> > index beba4979bff9..5ff6dec489f8 100644
> > --- a/arch/powerpc/include/asm/io.h
> > +++ b/arch/powerpc/include/asm/io.h
> > @@ -359,25 +359,37 @@ static inline void __raw_writeq_be(unsigned long v, volatile void __iomem *addr)
> >   */
> >  static inline void __raw_rm_writeb(u8 val, volatile void __iomem *paddr)
> >  {
> > -     __asm__ __volatile__("stbcix %0,0,%1"
> > +     __asm__ __volatile__(".machine \"push\"\n"
> > +                          ".machine \"power6\"\n"
> > +                          "stbcix %0,0,%1\n"
> > +                          ".machine \"pop\"\n"
> >               : : "r" (val), "r" (paddr) : "memory");
>
> As Segher said it'd be cleaner without the embedded quotes.
>
> > @@ -441,7 +465,10 @@ static inline unsigned int name(unsigned int port)       \
> >       unsigned int x;                                 \
> >       __asm__ __volatile__(                           \
> >               "sync\n"                                \
> > +             ".machine \"push\"\n"                   \
> > +             ".machine \"power6\"\n"                 \
> >               "0:"    op "    %0,0,%1\n"              \
> > +             ".machine \"pop\"\n"                    \
> >               "1:     twi     0,%0,0\n"               \
> >               "2:     isync\n"                        \
> >               "3:     nop\n"                          \
> > @@ -465,7 +492,10 @@ static inline void name(unsigned int val, unsigned int port) \
> >  {                                                    \
> >       __asm__ __volatile__(                           \
> >               "sync\n"                                \
> > +             ".machine \"push\"\n"                   \
> > +             ".machine \"power6\"\n"                 \
> >               "0:" op " %0,0,%1\n"                    \
> > +             ".machine \"pop\"\n"                    \
> >               "1:     sync\n"                         \
> >               "2:\n"                                  \
> >               EX_TABLE(0b, 2b)                        \
>
> It's not visible from the diff, but the above two are __do_in_asm and
> __do_out_asm and are inside an ifdef CONFIG_PPC32.
>
> AFAICS they're only used for:
>
> __do_in_asm(_rec_inb, "lbzx")
> __do_in_asm(_rec_inw, "lhbrx")
> __do_in_asm(_rec_inl, "lwbrx")
> __do_out_asm(_rec_outb, "stbx")
> __do_out_asm(_rec_outw, "sthbrx")
> __do_out_asm(_rec_outl, "stwbrx")
>
> Which are all old instructions, so I don't think we need the machine
> power6 for those two macros?
>
> > diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
> > index b4386714494a..5bf30ef6d928 100644
> > --- a/arch/powerpc/platforms/powernv/rng.c
> > +++ b/arch/powerpc/platforms/powernv/rng.c
> > @@ -43,7 +43,11 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
> >       unsigned long parity;
> >
> >       /* Calculate the parity of the value */
> > -     asm ("popcntd %0,%1" : "=r" (parity) : "r" (val));
> > +     asm (".machine \"push\"\n"
> > +          ".machine \"power7\"\n"
> > +          "popcntd %0,%1\n"
> > +          ".machine \"pop\"\n"
> > +          : "=r" (parity) : "r" (val));
>
> This was actually present in an older CPU, but it doesn't really matter,
> this is fine.
>
> cheers
