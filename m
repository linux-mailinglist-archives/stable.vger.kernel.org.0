Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92744C2904
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 11:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiBXKMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 05:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiBXKMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 05:12:14 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B241333;
        Thu, 24 Feb 2022 02:11:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id bd1so1232043plb.13;
        Thu, 24 Feb 2022 02:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=0UyTq+70vAzCW9qxBkMZP4Hj0BfByktsPwckPsM60AI=;
        b=ow04/WOD/9vA26tvuRs8a/SUfYu7aItaEjNfi4iygMZIR5FXddxaKnY3gJ0eBH3Guu
         cqV0ugd090AB1u5i8FX2N7E7+blbVEQrbvqAyMrlkEDw5zmeV2jJdCy1Dl1wgXW0zTGA
         0T4oS6z1NnAIvyZChnAxM4Y7PjppAB9KRHgJKTYa+UWtDFljA7L4Dz3zk6DlXimr383O
         AH44WiUBbenPHdrng51FdTtBSDPTkY0zHomwMB/ubs30fQz7LLbEoeDM5xjqwRKVUIL0
         y/nivXZG9RZcRHwb22fW/eMI6BmBacDh0mvuTP5TCMF7P86kqXPhYR+PlnbF4JzDKQQW
         dZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=0UyTq+70vAzCW9qxBkMZP4Hj0BfByktsPwckPsM60AI=;
        b=v+SV/CMeaAUpsYdVBkBO0w/Wwq8VfluO9Xa1P/Mw2v9ug8Mv0A3V7R/psIT4/2Ry9j
         IHVja11hrKI60LWc0YEoiEdTaBDykrFIu6grj1lMhA+N/YgvX9QwzUHXr2dPOTVjI7ED
         nwYBuR96N+tTM6mtjmE1zreuZO1bvC2maUkVFFUBiWXKXS+GPWVEqMEMW1vPkxHu+AiY
         dMcCil4aeHd+G9r/7rWchgj2ULBEmsMsKaTUmWHg4lfpUNuZzzbJiawT+CrVrXWCI9ix
         3u0new5UydJDjYcA9DwiJZm4vd2XRK427rmGNfZslC0Goafk/ay3VY+aVrr8aw4wKPW7
         YLCQ==
X-Gm-Message-State: AOAM530A0UbXjpw1zkwEjWCvDRWenikF2wGkYiXJtCBVg9BIA3wSi9eQ
        Ew66pBp489FDVuueT6WPKoM=
X-Google-Smtp-Source: ABdhPJyZU4g6wP2Mo9IwolMMtTJ1GMX0qpiyYVrPEiJ7s77T+aZBM7B4uD6EFV89/doY/JFv8h6DAw==
X-Received: by 2002:a17:902:d892:b0:14e:e074:7ff7 with SMTP id b18-20020a170902d89200b0014ee0747ff7mr1944382plz.29.1645697503522;
        Thu, 24 Feb 2022 02:11:43 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id h4sm2909028pfv.166.2022.02.24.02.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 02:11:43 -0800 (PST)
Date:   Thu, 24 Feb 2022 20:11:37 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
        <1645670923.t0z533n7uu.astroid@bobo.none>
        <1645678884.dsm10mudmp.astroid@bobo.none>
        <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
In-Reply-To: <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1645694174.z03tip9set.astroid@bobo.none>
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

Excerpts from Arnd Bergmann's message of February 24, 2022 6:55 pm:
> On Thu, Feb 24, 2022 at 6:05 AM Nicholas Piggin <npiggin@gmail.com> wrote=
:
>> Excerpts from Nicholas Piggin's message of February 24, 2022 12:54 pm:
>> >
>> > Not sure on the outlook for GCC fix. Either way unfortunately we have
>> > toolchains in the wild now that will explode, so we might have to take
>> > your patches for the time being.
>>
>> Perhaps not... Here's a hack that seems to work around the problem.
>>
>> The issue of removing -many from the kernel and replacing it with
>> appropriate architecture versions is an orthogonal one (that we
>> should do). Either way this hack should be able to allow us to do
>> that as well, on these problem toolchains.
>>
>> But for now it just uses -many as the trivial regression fix to get
>> back to previous behaviour.
>=20
> I don't think the previous behavior is what you want to be honest.

-many isn't good but that's what we're using and that is still
what we're using upstream on any other toolchain that doesn't
have these issues. Including the next binutils version that will
ignore the initial .machine directive for 64s.

Neither of these approaches solves that. At least for 64s that
is passing -Wa,-many down already. (Although Anders' series
gets almost there).

So this is the minimal fix that brings the toolchians in to line
with others and behaves how it previously did and fixes immediate
build regressions. Removing -many is somewhat independent of that.

> We had the same thing on Arm a few years ago when binutils
> started enforcing this more strictly, and it does catch actual
> bugs. I think annotating individual inline asm statements is
> the best choice here, as that documents what the intention is.

A few cases where there are differences in privileged instructions
(that won't be compiler generated), that will be done anyway.

For new instructions added to the ISA though? I think it's ugly and
unecesaary. There is no ambiguity about the intention when you see
a lharx instruction is there?

It would delinate instructions that can't be used on all processors
but I don't see  much advantage there, it's not an exhaustive check
because we have other restrictions on instructions in the kernel
environment. And why would inline asm be special but not the rest
of the asm? Would you propose to put these .machine directives
everywhere in thousands of lines of asm code in the kernel? I
don't know that it's an improvement. And inline asm is a small
fraction of instructions.

>=20
> There is one more bug in this series that I looked at with Anders, but
> he did not send a patch for that so far:
>=20
> static void dummy_perf(struct pt_regs *regs)
> {
> #if defined(CONFIG_FSL_EMB_PERFMON)
>         mtpmr(PMRN_PMGC0, mfpmr(PMRN_PMGC0) & ~PMGC0_PMIE);
> #elif defined(CONFIG_PPC64) || defined(CONFIG_PPC_BOOK3S_32)
>         if (cur_cpu_spec->pmc_type =3D=3D PPC_PMC_IBM)
>                 mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~(MMCR0_PMXE|MMCR0_=
PMAO));
> #else
>         mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_PMXE);
> #endif
> }
>=20
> Here, the assembler correctly flags the mtpmr/mfpmr as an invalid
> instruction for a combined 6xx kernel: As far as I can tell, these are
> only available on e300 but not the others, and instead of the compile-tim=
e
> check for CONFIG_FSL_EMB_PERFMON, there needs to be some
> runtime check to use the first method on 83xx but the #elif one on
> the other 6xx machines.

Right that should be caught if you just pass -m<superset> architecture
to the assembler that does not include the mtpmr. 32-bit is a lot more
complicated than 64s like this though, so it's pssible in some cases
you will want more checking and -m<subset> + some .machine directives
will work better.

Once you add the .machine directive to your inline asm though, you lose
*all* such static checking for the instruction. So it's really not a
panacea and has its own downsides.

Thanks,
Nick
