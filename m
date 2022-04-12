Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E520E4FE521
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343684AbiDLPvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357401AbiDLPva (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:51:30 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0131F43
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:49:09 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id q19so2821146ybd.6
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UTyzDghl6HrL3ZR/fFistubqxpKJRCJIoqi5QoNRA9Y=;
        b=QX626BjZ1zeRqzxoxzx0fuqPYd/Y9pgpBIPMsftcM2RDEp7VGQXdsBGwmu4nr32sbi
         lDUOWROulURYtk0GJrRbchXcVVMKXVE/k2F67XCSZRl5ZvhyEZesRf3PXy3d8a+WTdoL
         Q3jSZYJthmEsY+A4jpXJGm3ygFazPm9s3fyx/gJKJbutgUoHN8rtxwLoprSIfCK+zhLb
         zYbtlGYx/3Vh7/N1n3sS5hlpocr/yywQKG8FI01rsLtaRSvGSqOlT43aW3/ZuPcdgxWn
         Z6PficYR3PIX0xwsZ1dB0i6nPBHa2kPoosRioiYPNtRlT//uOdzqY5kEna0YDxprblWx
         STZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UTyzDghl6HrL3ZR/fFistubqxpKJRCJIoqi5QoNRA9Y=;
        b=r15iKmRuOucOsIsVcfi2BCrrJGsa63hGCaWrrWrEuNUOWKwujHwSoSEuhpjJ0wFh58
         5SUT+muxws0YmnaRhbOs6BafySWFIgmlZ1cpZda/ygy6w7CLWXCNVAFy1ysu2RP5cajE
         UlRDuCWFvtApewtuzspxFnnpJOk2RsKXmGy5c/CJTc3AiGpANWI/GR2onh3n0i1bedjz
         6pE4mEK8fkqByVSSXQTWoR4voGwwYzKFW8vljLOV9X6+S5nk1l8vh7zV59yR6uX4D+Ra
         0+myrJB82gEL13qbFYJ3Q51FqQ7bVjETG5k0eYYkNVxq+ULmEsioiIQEkT7IMHxnUIP7
         SJcQ==
X-Gm-Message-State: AOAM530ifjPGt2XIR0oS7iKxVoSK0x5WhoK/ZQ6he96JZUCHS+6rUDkj
        MiBswMeI82SZYFiir7eLtxeQfCWaMhu4EHSJbD7k6Q==
X-Google-Smtp-Source: ABdhPJxjOqntonAgwiYzKWD78wj4sOmbGMOnG78mhTYcRidPMBhcdGLTxuoDRwt2DCLwkvcik8YE+jbasZC2WWWXsyU=
X-Received: by 2002:a25:f50e:0:b0:641:303c:782c with SMTP id
 a14-20020a25f50e000000b00641303c782cmr10373094ybe.625.1649778548714; Tue, 12
 Apr 2022 08:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062942.022903016@linuxfoundation.org> <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
 <CANpmjNP4-jG=kW8FoQpmt4X64en5G=Gd-3zaBebPL7xDFFOHmA@mail.gmail.com> <CA+G9fYuJKsYMR2vW+7d=xjDj9zoBtTF5=pSmcQRaiQitAjXCcw@mail.gmail.com>
In-Reply-To: <CA+G9fYuJKsYMR2vW+7d=xjDj9zoBtTF5=pSmcQRaiQitAjXCcw@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 12 Apr 2022 17:48:32 +0200
Message-ID: <CANpmjNPMd_HRPEqxQR0XXdp91QfqoYJxhoTjVMZLLDSTgyyTYA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Apr 2022 at 17:44, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Hi Marco
>
> On Tue, 12 Apr 2022 at 20:32, Marco Elver <elver@google.com> wrote:
> >
> > On Tue, 12 Apr 2022 at 16:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Tue, 12 Apr 2022 at 12:11, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.34 release.
> > > > There are 277 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > On linux stable-rc 5.15 x86 and i386 builds failed due to below error [1]
> > > with config [2].
> > >
> > > The finding is when kunit config is enabled the builds pass.
> > > CONFIG_KUNIT=y
> > >
> > > But with CONFIG_KUNIT not set the builds failed.
> > >
> > > x86_64-linux-gnu-ld: mm/kfence/core.o: in function `__kfence_alloc':
> > > core.c:(.text+0x901): undefined reference to `filter_irq_stacks'
> > > make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > I see these three commits, I will bisect and get back to you
> > >
> > > 2f222c87ceb4 kfence: limit currently covered allocations when pool nearly full
> > > e25487912879 kfence: move saving stack trace of allocations into
> > > __kfence_alloc()
> > > d99355395380 kfence: count unexpectedly skipped allocations
> >
> > My guess is that this commit is missing:
>
> This patch is missing Fixes: tag.

No it's not - it was patch 1/N in this series:
https://lore.kernel.org/all/20210923104803.2620285-1-elver@google.com/

> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f39f21b3ddc7fc0f87eb6dc75ddc81b5bbfb7672
