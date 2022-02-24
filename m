Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223AC4C2A8A
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiBXLOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 06:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiBXLOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 06:14:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D997293A23;
        Thu, 24 Feb 2022 03:13:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h17-20020a17090acf1100b001bc68ecce4aso5391553pju.4;
        Thu, 24 Feb 2022 03:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=WjQC5Y7ro/c9MdCjVexTb0YJtz1qK4y19XmmyHlyFew=;
        b=Jirg0vziGW8V3SRKvS+PjhON7lmoM4owOMTYOfacsP7PA1kucpsNi1ShKnC1Xkovyw
         o6U9yMSJlGTp/9bdcko9RMowA7lWuUecDmFzi+XEIU8N0VGjsiQpJZu1tXNBvuyMs/p2
         rbCJzpbTs4etXqH/zrJ3B4vY3NwUmDan5gFm5+guije2IkK/PL83p0+na++9vFREa4W4
         ArHXY4YXbYTIFTn95zCxQOQz6HcTe5XGs4vkROZUfpVuMcPdX7MbSwcnlAglD3ApP9Jx
         lWwz3Oy0jJU+P8hF7OM/qdSde4sPYz/DR+kmgZ6Fea+azQZS46sldPZe+9sBPmJhsJ8u
         +1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=WjQC5Y7ro/c9MdCjVexTb0YJtz1qK4y19XmmyHlyFew=;
        b=OXfcT3gaQXUYsOKyjXe8G0KpcQNzY6fAwSVcEwqEXDi7iZEfDmpAGj7J8mDaa6XSeT
         XigByXl8jIvnJWhReya6PZud4k/wl59JY0g/mEMw7CGxNWcR1V9P7D1Pifi8r5qihEbY
         55bxZRJqLfuQzMOMrbcQOP8Xc2tBNtd++JUcldSMnDYAp7c2k5UVkO+4sf2H08AzCvES
         kVgEmRILFF5DdAxGb+2HiwZQsRoKeE1yHIoAv8saY5mkyjZyqmibJUZYibQrepEN0Ugs
         54g0fJ+tA5siI6pWMUoiAMxIpEjBLYsaWLKUoF0+2nyVts3lX+oYp72CvQ/TJdqAPBiP
         xxdw==
X-Gm-Message-State: AOAM533YDA5ahYS4HzQtB6oXH67JHwU3ADguuR3fJT4sfNoRDXFMK1p7
        nTb9mjHN2BhfeeVR+qhJfnM=
X-Google-Smtp-Source: ABdhPJyounr1R+DBw3MY3a4cGgCM4BABVn40lZPd0jyri1ZanC2IX019OiKZipTBZMe59x5+BtL/Dw==
X-Received: by 2002:a17:90b:400c:b0:1bc:7190:5696 with SMTP id ie12-20020a17090b400c00b001bc71905696mr2284455pjb.109.1645701211364;
        Thu, 24 Feb 2022 03:13:31 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id q1sm2911458pfs.112.2022.02.24.03.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 03:13:30 -0800 (PST)
Date:   Thu, 24 Feb 2022 21:13:25 +1000
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
        <1645694174.z03tip9set.astroid@bobo.none>
        <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
In-Reply-To: <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1645700767.qxyu8a9wl9.astroid@bobo.none>
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

Excerpts from Arnd Bergmann's message of February 24, 2022 8:20 pm:
> On Thu, Feb 24, 2022 at 11:11 AM Nicholas Piggin <npiggin@gmail.com> wrot=
e:
>> Excerpts from Arnd Bergmann's message of February 24, 2022 6:55 pm:
>> > On Thu, Feb 24, 2022 at 6:05 AM Nicholas Piggin <npiggin@gmail.com> wr=
ote:
>> > We had the same thing on Arm a few years ago when binutils
>> > started enforcing this more strictly, and it does catch actual
>> > bugs. I think annotating individual inline asm statements is
>> > the best choice here, as that documents what the intention is.
>>
>> A few cases where there are differences in privileged instructions
>> (that won't be compiler generated), that will be done anyway.
>>
>> For new instructions added to the ISA though? I think it's ugly and
>> unecesaary. There is no ambiguity about the intention when you see
>> a lharx instruction is there?
>>
>> It would delinate instructions that can't be used on all processors
>> but I don't see  much advantage there, it's not an exhaustive check
>> because we have other restrictions on instructions in the kernel
>> environment. And why would inline asm be special but not the rest
>> of the asm? Would you propose to put these .machine directives
>> everywhere in thousands of lines of asm code in the kernel? I
>> don't know that it's an improvement. And inline asm is a small
>> fraction of instructions.
>=20
> Most of the code is fine, as we tend to only build .S files that
> are for the given target CPU,

That's not true on powerpc at least. grep FTR_SECTION.

Not all of them are different ISA, but it's more than just the
CPU_FTR_ARCH ones which only started about POWER7.

> the explicit .machine directives are
> only needed when you have a file that mixes instructions for
> incompatible machines, using a runtime detection.

Right. There are .S files are in that category. And a lot of
it for inline and .S we probably skirt entirely due to using raw=20
instruction encoding because of old toolchains (which gets no error=20
checking at all) which we really should tidy up and trim.

>=20
>> Right that should be caught if you just pass -m<superset> architecture
>> to the assembler that does not include the mtpmr. 32-bit is a lot more
>> complicated than 64s like this though, so it's pssible in some cases
>> you will want more checking and -m<subset> + some .machine directives
>> will work better.
>>
>> Once you add the .machine directive to your inline asm though, you lose
>> *all* such static checking for the instruction. So it's really not a
>> panacea and has its own downsides.
>=20
> Again, there should be a minimum number of those .machine directives
> in inline asm as well, which tends to work out fine as long as the
> entire kernel is built with the correct -march=3D option for the minimum
> supported CPU, and stays away from inline asm that requires a higher
> CPU level.

There's really no advantage to them, and they're ugly and annoying
and if we applied the concept consistently for all asm they would grow=20
to a very large number.

The idea they'll give you good static checking just doesn't really
pan out.

Thanks,
Nick
