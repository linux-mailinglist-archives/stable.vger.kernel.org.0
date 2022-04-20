Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD39508943
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379040AbiDTN2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379021AbiDTN2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:28:37 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DC3A5D8;
        Wed, 20 Apr 2022 06:25:51 -0700 (PDT)
Received: from mail-wm1-f46.google.com ([209.85.128.46]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MMFdY-1nRI9D2Fs6-00JKba; Wed, 20 Apr 2022 15:25:49 +0200
Received: by mail-wm1-f46.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso3707201wma.0;
        Wed, 20 Apr 2022 06:25:49 -0700 (PDT)
X-Gm-Message-State: AOAM533Ruzzhq3AJnT/ApE5/MdAhSW3ZXbnGtnby3NKLfiyYe6w5d3f+
        57jVaS0GWfE6nujzi1m53KI5P/uSFE7Jda3XKrI=
X-Google-Smtp-Source: ABdhPJwiG3EyuSNpaHqra2dahTK/JnvqbUz+C9/o2SqI7KlR071QCZmOW+DAbeiKB7yYo6yDeDE/gbVIPvIMFUY5Nvg=
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id
 s25-20020a1cf219000000b0038c782c03bbmr3668880wmc.94.1650461149002; Wed, 20
 Apr 2022 06:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220420115512.175917-1-krzysztof.kozlowski@linaro.org>
 <CAK8P3a0uH5KjaobrqUmJQnvMmjkUaR1iC-7jEPjZFjZF1Z-GfQ@mail.gmail.com> <0c0b53c3-294a-b1ac-487a-ca96266c4bb7@linaro.org>
In-Reply-To: <0c0b53c3-294a-b1ac-487a-ca96266c4bb7@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Apr 2022 15:25:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2uuFMVcsR9c+J28ZsA1cC9+FJCnFy5Lnq6uUY=nPoTEQ@mail.gmail.com>
Message-ID: <CAK8P3a2uuFMVcsR9c+J28ZsA1cC9+FJCnFy5Lnq6uUY=nPoTEQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:kbYlLd+2VeG+VWzjp2K6Ui5Pwogjevu9don8FxO2FstBnYgOmnb
 LOavINgChxrc7d/yNCNs3yYy+Z4YBCrOM4OU+St7NMVCZ22FTO65Rp5CSFdfeeJuZDZgTA+
 wR8Yv/7zq9QQ+dYn4fdSgUu0r9J0U3Uga2wpngv3mw62rFq4AnWMrqofibanPF7LmBKuMDP
 tyyddHoxnf2MhEeiTex6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oOEJXlPpHLE=:0/LNQHR2Jtklkx+Q/alL+R
 bTjXpgO+yhO5xs0fEl5t1X2v1CysRELdtgaQwna8vDG51FulKc/cMuZ6ME3zTF2hc2XCuC/gL
 iPEMotvBDdQmQX8EV+II6I7qvmg7BjJgrX1rApPooRigWQaAWHCG+QQIjfpOU0044gCXD87WH
 2kkwyHVpSUfdJu5kg0oZANkeS31KLhQsxLDq3cowdxPnY1S0vgTR9P1MjNBcv+J0gktnD8w9T
 ElkDgyey6/5pCPudRFsqoBAQQ60miirEliEmSI48ZGcxDuRQo24cibQwo4EW6LBcGxzRT05Ka
 da/jM6oiXrIWOHjX/97w+XGs4pkiMKEs/19M9yuKlEi2YdNZY4PKShzblUNCkXvTNUqDWeOPl
 RUSs9YiYx1KID8bx0NiDOn4vS90gQbnf0eU6SS3ppPP3YbF36rSECuatiYv2gZxc5/a8KxITf
 shENMZuBk/242pATS8zcTXa01DmnBLL2mDucwl2OZfWwLsMwMeuTJoRYT2iJj9iq56gPbb/QH
 K4pzegIECuI/dLXfcY95iwGNNBEuQz5PKkVYrQz1Ct5wh0SNmzMcOfKnI1Fp2HKB7v3iJopVR
 v29NKvylAR3araV1BNou5bHtgixNg/dPJFRWsBF4pLTV5emsNck+y37wPPmI0npP1Hbr+pgy6
 DRVHu69fYU+MhdIJplOmC+06L1RFktrLc1iwk6kDTqTUWfhBHbPft2FoK9MSfkzWW754=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 2:13 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
> On 20/04/2022 14:10, Arnd Bergmann wrote:
> > On Wed, Apr 20, 2022 at 1:55 PM Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> The Samsung pinctrl drivers depend on OF_GPIO, which is part of GPIOLIB.
> >> ARMv7 Exynos platform selects GPIOLIB and Samsung pinctrl drivers. ARMv8
> >> Exynos selects only the latter leading to possible wrong configuration
> >> on ARMv8 build:
> >>
> >>   WARNING: unmet direct dependencies detected for PINCTRL_EXYNOS
> >>     Depends on [n]: PINCTRL [=y] && OF_GPIO [=n] && (ARCH_EXYNOS [=y] || ARCH_S5PV210 || COMPILE_TEST [=y])
> >>     Selected by [y]:
> >>     - ARCH_EXYNOS [=y]
> >>
> >>  config PINCTRL_EXYNOS
> >>         bool "Pinctrl common driver part for Samsung Exynos SoCs"
> >> -       depends on OF_GPIO
> >>         depends on ARCH_EXYNOS || ARCH_S5PV210 || COMPILE_TEST
> >>         select PINCTRL_SAMSUNG
> >>         select PINCTRL_EXYNOS_ARM if ARM && (ARCH_EXYNOS || ARCH_S5PV210)
> >
> >
> > The problem here is that PINCTRL_EXYNOS and the others can be built for
> > compile-testing without CONFIG_OF on non-arm machines.
> >
> > I think the correct dependency line would be
> >
> >       depends on ARCH_EXYNOS || ARCH_S5PV210 || (COMPILE_TEST && OF)
> >
> > which guarantees that OF_GPIO is also enabled.
>
> I don't think OF is the problem here, because the error is in missing
> GPIOLIB.

You are correct that the added dependency is not the solution for the
original problem. What I meant is that by dropping the dependency on
OF_GPIO, you create a new problem for compile-testing without
CONFIG_OF. Adding back the OF dependency avoids the regression.

> The platform selects Samsung pinctrl but it does not select
> GPIOLIB. Possible fixes are:
> 1. Do not select Samsung pinctrl from the platform (but have some
> default), so on compile test build it might not work.
> 2. Select GPIOLIB from the platform (ARMv7 Exynos does it).
> 3. Select GPIOLIB from here - this is current proposal.

Agreed, either 2. or 3. is fine, as long as you keep the CONFIG_OF
dependency.

       Arnd
