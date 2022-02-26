Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380034C5265
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 01:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiBZAIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 19:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbiBZAIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 19:08:21 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6C8A41B3;
        Fri, 25 Feb 2022 16:07:44 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m22so6182339pja.0;
        Fri, 25 Feb 2022 16:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=c5B6JRpH2tbmLBFBMPjCFNLPBgu4FT5DIbHXGYJdCK8=;
        b=MmF7aDNZ0tCRKCA08hEFDy64f+YnQ2/g6cOWR4EuXliwFwbU0Vu48vP/mdNsKXQeyZ
         EeSvXiWEUGzXToeTYPgpa6MFBK3iab+OaDsdhIKZxv4sdPiflwZZvHioYRhpL5iqKoQu
         PJp8yRfo4e95feVAS+zetRfXI2De+dfnuJ7+Td+RwqYVjrdmIBUtIzApG5HZoJuLjuOi
         OHquYyPAM9s74SnqQcjS+PKNRNsLV31TGtolp6h57rm2yCdYqog0aTTMiGntqVR4lfeI
         ieDUgO/0TSqeVgvAI6Ovh8YoMMkroBoJSaBlcrEqhy3uUmvWWHmx4EzzVDzjcWp0JfbX
         MV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=c5B6JRpH2tbmLBFBMPjCFNLPBgu4FT5DIbHXGYJdCK8=;
        b=f6Edy9BD9RHXfNWuKWxtNzYYs/u6gobAo3/7FexLz7Cy8r0Mfj6nAZnx/H8OU/apXM
         agNg1Z+n2Ts9Wd2mT/lvFAXIkzNN3+h6JwB8xDYxOvcCF9OEChIWAO6r1W+M4hbyaNpR
         ZwfxP/lagBVejWhiETh0TV+b8awTArxOJwk8NlcL9bOb8Dg0OEO6bnSw7IXqqRst3OCg
         wwq/c9p6wUj51lZYueJQJpAUyJzxCiOYPGD8TXz5tWrvOnUU9WZpNOa/X3Rt0oRt3bNY
         awNlFMPMPyL4413RYMzSCmTs/0n5/rwWG9VKWADLCzRK4q6nPNyJRXbjvkE+t+Lc7Kge
         3iBQ==
X-Gm-Message-State: AOAM533s5Q4IuhcULt0W5uBNJavodMe2/3uWf2CfeXba0494rE/jyUrM
        9ra+yJ4lZgb5h+4MckK+8DStrng4YLA=
X-Google-Smtp-Source: ABdhPJz8UcTnhJMjqVzj//IRynVGj6DHXJzLRxFY20AEWWT0+6hgtNUecNWrIpo0/D5GJEv1WjEHug==
X-Received: by 2002:a17:902:8bcc:b0:14f:2294:232e with SMTP id r12-20020a1709028bcc00b0014f2294232emr9754162plo.105.1645834063924;
        Fri, 25 Feb 2022 16:07:43 -0800 (PST)
Received: from localhost (118-208-203-92.tpgi.com.au. [118.208.203.92])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b004e10365c47dsm4550030pfc.192.2022.02.25.16.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 16:07:43 -0800 (PST)
Date:   Sat, 26 Feb 2022 10:07:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
        <1645670923.t0z533n7uu.astroid@bobo.none>
        <1645678884.dsm10mudmp.astroid@bobo.none>
        <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
        <1645694174.z03tip9set.astroid@bobo.none>
        <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
        <1645700767.qxyu8a9wl9.astroid@bobo.none>
        <20220224172948.GN614@gate.crashing.org>
        <1645748553.sa2ewgy7dr.astroid@bobo.none>
        <20220225222841.GS614@gate.crashing.org>
In-Reply-To: <20220225222841.GS614@gate.crashing.org>
MIME-Version: 1.0
Message-Id: <1645833637.za1t01a9md.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Segher Boessenkool's message of February 26, 2022 8:28 am:
> On Fri, Feb 25, 2022 at 10:23:07AM +1000, Nicholas Piggin wrote:
>> Excerpts from Segher Boessenkool's message of February 25, 2022 3:29 am:
>> > On Thu, Feb 24, 2022 at 09:13:25PM +1000, Nicholas Piggin wrote:
>> >> Excerpts from Arnd Bergmann's message of February 24, 2022 8:20 pm:
>> >> > Again, there should be a minimum number of those .machine directive=
s
>> >> > in inline asm as well, which tends to work out fine as long as the
>> >> > entire kernel is built with the correct -march=3D option for the mi=
nimum
>> >> > supported CPU, and stays away from inline asm that requires a highe=
r
>> >> > CPU level.
>> >>=20
>> >> There's really no advantage to them, and they're ugly and annoying
>> >> and if we applied the concept consistently for all asm they would gro=
w=20
>> >> to a very large number.
>> >=20
>> > The advantage is that you get machine code that *works*.  There are
>> > quite a few mnemonics that translate to different instructions with
>> > different machine options!  We like to get the intended instructions
>> > instead of something that depends on what assembler options the user
>> > has passed behind our backs.
>> >=20
>> >> The idea they'll give you good static checking just doesn't really
>> >> pan out.
>> >=20
>> > That never was a goal of this at all.
>> >=20
>> > -many was very problematical for GCC itself.  We no longer use it.
>>=20
>> You have the wrong context. We're not talking about -many vs .machine
>> here.
>=20
> Okay, so you have no idea what you are talking about?  Wow.

Wrong context. It's not about -many. We're past that everyone agrees=20
it's wrong.

> The reason GCC uses .machine *itself* is because assembler -mmachine
> options *cannot work*, for many reasons.  We hit problems often enough
> that years ago we started moving away from it already.  The biggest
> problems are that on one hand there are mnemonics that encode to
> different instructions depending on target arch or cpu selected (like
> mftb, lxvx, wait, etc.), and on the other hand GCC needs to switch that
> target halfway through compilation (attribute((target(...)))).
>=20
> Often these problems were hidden most of the time by us passing -many.
> But not all of the time, and over time, problems became more frequent
> and nasty.
>=20
> Passing assembler -m options is nasty when you have to mix it with
> .machine statements (and we need the latter no matter what), and it

No it's not nasty, read the gas manual. -m specifies the machine and
so does .machine. It's simple.

> becomes completely unpredictable if the user passes other -m options
> manually.
> Inline assembler is inserted textually in the generated assembler code.
> This is a big part of the strength of inline assembler.  It does mean
> that if you need a different target selected for your assembler code
> then you need to arrange for that in your assembler code.
>=20
> So yes, this very much is about -many, other -m options, and .machine .
> I discourage the kernel (as well as any other project) from using -m
> options, especially -many, but that is your own choice of course.  I
> get sick and tired from you calling a deliberate design decision we
> arrived at after years of work and weighing alternatives a "bug" though.

Alan posted a good summary here

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D102485#c10

Thanks,
Nick
