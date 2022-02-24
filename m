Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121C84C293C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 11:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiBXKVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 05:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiBXKVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 05:21:21 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A806228AD8A;
        Thu, 24 Feb 2022 02:20:51 -0800 (PST)
Received: from mail-wr1-f50.google.com ([209.85.221.50]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MXGes-1njfQ746pi-00YmL0; Thu, 24 Feb 2022 11:20:50 +0100
Received: by mail-wr1-f50.google.com with SMTP id d3so2214147wrf.1;
        Thu, 24 Feb 2022 02:20:49 -0800 (PST)
X-Gm-Message-State: AOAM533t6iTrUnDjXs91EkyUdw/i+4T2YIL0LCAWx1rrZwdQl4w42abM
        aNCNdpGiGEA0243pLllXnw/FE/ElHaNQxRdY21A=
X-Google-Smtp-Source: ABdhPJwlwBZOETCLeyu6amnN4VaudZFBEgKuBFVnNi6SbNUIvJmeYpK6VEyqchdPJW+eY7ZEGveiw2GFLgbBfJMODq8=
X-Received: by 2002:adf:a446:0:b0:1ed:c41b:cf13 with SMTP id
 e6-20020adfa446000000b001edc41bcf13mr1730833wra.407.1645698049603; Thu, 24
 Feb 2022 02:20:49 -0800 (PST)
MIME-Version: 1.0
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
 <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none>
 <1645678884.dsm10mudmp.astroid@bobo.none> <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
 <1645694174.z03tip9set.astroid@bobo.none>
In-Reply-To: <1645694174.z03tip9set.astroid@bobo.none>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 24 Feb 2022 11:20:33 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
Message-ID: <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LWUNT/sGK0HY/3BZxg1QBBPTyVYsoKoxgJRq/XKM3pe027b7LyS
 vonMhlfRGOdiZfd8mFiGpiqQCqosCRtDF/D9eOxbdak5QsgUp4kWHGo6WPYxoZTA6sGRYEe
 7XjMBecOLGZjBqFkkaSivTd4KAVl8YUHHdarRMYT1IRvOUx2dMoa9msU/T0q23J7PIhrFyg
 MQHkkBhXH8LuRInHSLvEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2ZtXFukJpyc=:lO0BW73fgg7XvxbWSbggKz
 UcynFwt8Y0UltheQzkOVVFAfbsmb3sbJA/9rj6Donl9T8a04110IsQkRYlbgCtQNJMvi7s8IF
 7s3MfFda7sH1PZ+yTi0wP7zzrev9pWUblH84mo+29DrX/JsTXBR2fP0Rg28qI1maS4+oVoBiV
 hyF1ujBzzSCPcTzpiWSwDQ8/6NDZKmRwAd4Sx8H/sLaof4CzUfw1xgIYZ9G2PE1zXJbxkwwwn
 V3Lco8Dm7hIilLKZ0CDaI1gBYdfUl9VFgmtxHibRdTuKxCPn+ydx4a7o9M3q+H777KVBwE9B+
 4C4JoOAP4Xlhad3IUnU3KdM/FXU5Wf3E0LHZsAShIRcG57SqYd8S9i2+uAtcXJVzW+jLh1jNr
 Zqw5WsSO4rytzLMp3l+7gF7WD40pH0Ng7h/VetdA+PDXAA4npcMk3VhpEK6OwWeYMUjoZSbEy
 ozMbgmFThkhsP3+BTv/DOpThxiCCLXCjD9p56Q4mtasnoO1OdC3V8yfvlL2hpQVUi8SZ1rd0h
 0iDZ1sJGit4vMSHAHK+O4GBCQxck3oX4t2q3zf1kvBv0mR7oJ+dtIwsqdyI/oppdwF52Hlr//
 Xrmb3ChzOXQflpUkgtmCc6t6ddlElrI5UMOhHwZ0mz4XhJtQUlO7QR41J3nNsTQuZC6XIORg8
 Ee1bWfJqhSzS+V3F126gUSENLcJs2PAlF/gm1LaWyisZKM9gjjIkVMVAGODjew3xerm2EClT7
 KIxyuJVKBhEc99BZD1gnTJOHq5IT6L0RZ6+AIKAhlDyZ1BBNDtrgU1yGnZLj1nFn6xDwTm1LI
 IVEGJLgcVjIB8Nwr92fyQKeT42/PzN3yWDrQMNDMwZ7+KyPZzA=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 11:11 AM Nicholas Piggin <npiggin@gmail.com> wrote:
> Excerpts from Arnd Bergmann's message of February 24, 2022 6:55 pm:
> > On Thu, Feb 24, 2022 at 6:05 AM Nicholas Piggin <npiggin@gmail.com> wrote:
> > We had the same thing on Arm a few years ago when binutils
> > started enforcing this more strictly, and it does catch actual
> > bugs. I think annotating individual inline asm statements is
> > the best choice here, as that documents what the intention is.
>
> A few cases where there are differences in privileged instructions
> (that won't be compiler generated), that will be done anyway.
>
> For new instructions added to the ISA though? I think it's ugly and
> unecesaary. There is no ambiguity about the intention when you see
> a lharx instruction is there?
>
> It would delinate instructions that can't be used on all processors
> but I don't see  much advantage there, it's not an exhaustive check
> because we have other restrictions on instructions in the kernel
> environment. And why would inline asm be special but not the rest
> of the asm? Would you propose to put these .machine directives
> everywhere in thousands of lines of asm code in the kernel? I
> don't know that it's an improvement. And inline asm is a small
> fraction of instructions.

Most of the code is fine, as we tend to only build .S files that
are for the given target CPU, the explicit .machine directives are
only needed when you have a file that mixes instructions for
incompatible machines, using a runtime detection.

> Right that should be caught if you just pass -m<superset> architecture
> to the assembler that does not include the mtpmr. 32-bit is a lot more
> complicated than 64s like this though, so it's pssible in some cases
> you will want more checking and -m<subset> + some .machine directives
> will work better.
>
> Once you add the .machine directive to your inline asm though, you lose
> *all* such static checking for the instruction. So it's really not a
> panacea and has its own downsides.

Again, there should be a minimum number of those .machine directives
in inline asm as well, which tends to work out fine as long as the
entire kernel is built with the correct -march= option for the minimum
supported CPU, and stays away from inline asm that requires a higher
CPU level.

      Arnd
