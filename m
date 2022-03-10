Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B334D44A1
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiCJKcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiCJKcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:32:00 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82EA13EF82
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 02:30:59 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dc28791ecbso52586267b3.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 02:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GEIKOgAspd11sCcksbwlQC1hgUyJX16lFrTFDurSqL0=;
        b=dPd6hyEcvmtuMDfVZVrmJ9pq4L1ctnGz96ODjH+VHv84r7zoI7lclitqyvah9DoWPd
         XI/zcqWf3jZg0C0bATpo2hYzsh1WdRaRfSoaNJmA7QhnYbjfP9ntQ8lrI1iz+F3gUggQ
         vS0/32fUU4aOJR0bdcDWjbUtHCWJXrM6EQUPEn0pxukoPGMjP4eAwEI1kiNSyI8GqMDS
         SVAvulj2wUh70ET3AshyWqdTpGu0SSp5ES/18HBG2AByXD52T6XW/J8QXux5jt90h87c
         vONbKMa3SyIL2s4YwZz7M5X8Y3ZWOPoKFKo1AoXKTNlV+A5Z3E8B1ANP+HpVdYvFqPRF
         nrsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GEIKOgAspd11sCcksbwlQC1hgUyJX16lFrTFDurSqL0=;
        b=QWgai66ofZVSIctA5JpPG2pMoKowIKG9iKw9pOXk2cJ5UcV05TszRR7vqrkF0ToCeR
         yFXgWn0xFOHEf10ZMD8YSaugaphoyIA/3aVkxtg509nLs2qNSaAKI+JKw9L4TAQklDrr
         tnQUk2vE+COHKK3EmJtnF7YmVYTJqqWTazcHxAIE0k/s6W3rIuH2O979ROD54nhtLwxg
         IIl6jLzqDzMF/J8+WseQkItRfUH+zA7324EoXpsBA092boAb0tfa02RALLnfXb64dBXf
         A0hk7649oiogoWZO+d/UTLxSuG+ga6EbiKWAVEPASYYdRTv9bJ0VKAU024Hx1AmSYsEo
         rFLw==
X-Gm-Message-State: AOAM5320M+VfM3ziAXNmsQoNMVD8AxeKcFSGxVqMIpsRCzHUubhjwdAQ
        czqFuNG1x1XRYuVHvT5TzgQ6w7NcIOqAVjumCjHW/zY0lJGLepCh
X-Google-Smtp-Source: ABdhPJyxz6RxicR07EAcW/kfCDhQdIURBoEkhQwDSD7HihZjf5U3WcCubUufIBZrJi4JfXwuxZJPVNQ6UFx87k+2eRM=
X-Received: by 2002:a81:486:0:b0:2d7:7785:3f33 with SMTP id
 128-20020a810486000000b002d777853f33mr3386035ywe.516.1646908258973; Thu, 10
 Mar 2022 02:30:58 -0800 (PST)
MIME-Version: 1.0
References: <20220309155859.734715884@linuxfoundation.org> <b17d6dad-b5b3-6c59-b156-831913f7cd3e@linaro.org>
In-Reply-To: <b17d6dad-b5b3-6c59-b156-831913f7cd3e@linaro.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 10 Mar 2022 11:30:48 +0100
Message-ID: <CADYN=9+VTyVCxuMBNfYGdLX+BzOhXPPURy8iaLDywyqmyiBZyw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Mar 2022 at 22:14, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wrot=
e:
>
> Hello!
>
> On 09/03/22 09:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.28 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.28-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions found.
>

[...]

>
>
> And here's one for Clang (same imx_v4_v5_defconfig config, but with clang=
-11):
>
>    ld.lld: error: ./arch/arm/kernel/vmlinux.lds:117: AT expected, but got=
 NOCROSSREFS
>    >>>  __vectors_lma =3D .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vector=
s_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8=
) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start =3D LO=
ADADDR(.vectors); __vectors_end =3D LOADADDR(.vectors) + SIZEOF(.vectors); =
__vectors_bhb_loop8_start =3D LOADADDR(.vectors.bhb.loop8); __vectors_bhb_l=
oop8_end =3D LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __v=
ectors_bhb_bpiall_start =3D LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bp=
iall_end =3D LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); .=
 =3D __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF=
(.vectors.bhb.bpiall); __stubs_lma =3D .; .stubs ADDR(.vectors) + 0x1000 : =
AT(__stubs_lma) { *(.stubs) } __stubs_start =3D LOADADDR(.stubs); __stubs_e=
nd =3D LOADADDR(.stubs) + SIZEOF(.stubs); . =3D __stubs_lma + SIZEOF(.stubs=
); PROVIDE(vector_fiq_offset =3D vector_fiq - ADDR(.vectors));
>    >>>                                          ^
>    make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1

Bisection showed patch 8f4782a68faf ("ARM: Spectre-BHB workaround") as
the faulty patch.


Cheers,
Anders
