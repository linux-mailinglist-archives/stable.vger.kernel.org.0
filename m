Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1425087CA
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378441AbiDTMNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378442AbiDTMNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:13:09 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719DD28E3A;
        Wed, 20 Apr 2022 05:10:21 -0700 (PDT)
Received: from mail-wr1-f46.google.com ([209.85.221.46]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N9M5y-1o1nCx3k9c-015M8y; Wed, 20 Apr 2022 14:10:19 +0200
Received: by mail-wr1-f46.google.com with SMTP id x18so2019503wrc.0;
        Wed, 20 Apr 2022 05:10:19 -0700 (PDT)
X-Gm-Message-State: AOAM530HBRqZVdBx6mQC9a2skGh625UftjxhGT9wSh3x8APaCuzki3ce
        KqJGXpGYGVLe4QlzSfnlm1qnPnQ/5E3aENZVbrU=
X-Google-Smtp-Source: ABdhPJwEzMpW3Z+El4kjnHs87k1+HrjytUR9IDBIcg8LlQbi6Kg0Yw1ngl3fa6HiSMPMMkT1ObfluHZ9iQTS11evFFo=
X-Received: by 2002:a5d:6389:0:b0:207:a7d8:2b64 with SMTP id
 p9-20020a5d6389000000b00207a7d82b64mr15261455wru.12.1650456619497; Wed, 20
 Apr 2022 05:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220420115512.175917-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220420115512.175917-1-krzysztof.kozlowski@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Apr 2022 14:10:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0uH5KjaobrqUmJQnvMmjkUaR1iC-7jEPjZFjZF1Z-GfQ@mail.gmail.com>
Message-ID: <CAK8P3a0uH5KjaobrqUmJQnvMmjkUaR1iC-7jEPjZFjZF1Z-GfQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:9HTFVXbF8thm6W+pemK9kzBhMavi6QDXkUIgNwn+le/z7kbKJ92
 ZvJUkoZ8qmqzWiQ9tXqtRDDQCZhpAvncbnXGxiXolRPXTgdbc8gXjvPzPAwj8tMu8ODKGxg
 VZexpZbWDhsO0/saIdV1TVoXT8/B5B+/rGEK2bAgaEBo0085Rtcai4/qrH+GQUZuFwYLhiF
 uk+bvnOm2RWyXYaBkqT3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6eg226EKkx4=:Gzm/re6sjLggt33JpQubg3
 dtzvmwLw1AYDrz+cNiJ52HCzMTQjNFbGdKl7O4TDQemDeK17AdISpVSMbbP9PzaGj4yvbfb2Q
 naSiyX1RbsRgMGd75DPi8b72Nu4Zx+Lj6LHxCWMHsbjHPuLDAOAYna0ZcC3JkEOEVA5fJTHH7
 qmjyTCdw7s1HQ1e2uEx/6GAFAH1tT0RGfh7ippdD6ly8o4Mpxc0GN+INZBRL7ZngEScEhdMvo
 PjFTFl3PJyw8B91Ac545iyzNtDsuNMAIy46BVtUKjntLFnZ9XL6blTi2gNTvTl/B1s3yGBgBP
 B+wdKzK2BbXOtT92QUNtinSwacTtepjf1SAS5YtzJ0XOvlEVCMZfzIoZJwIM7S8CADK6E+ULQ
 oGp0KfjJw8clKgg4L1KgLgJkx0P+m81fKdMFl9yWexoN0/yQdGDmKjE2CO6bWyTw6/nNt0/Ub
 Z3y7bcPnATlmmJaqB6by4Yd8NHfq3+YZ7YVuWpI0YFyvzg+herDsp0mt9RoCZp629oV/XULgA
 Xf8D1c8A/xnNadyfwXRw+uChn33CPqD55nmPirAnbRy8tK5ppC9SzqvGbZQACPtSBg+xYh5mO
 2el0LCYogE/9Cf/M/zFU6Qqjst66bxDbCLrqxWPX90v8qVtE0JN3QdTz09dr0FhBJdipMhhh7
 7HbknufRdM1VmmfLcsmC6IY99lxD8EX6DW4tNRLNp8JdU9dZng2aVO50onghHcEff0RFcghY7
 QWoVMBxn5MJ5smxrCNUVUgLnzAfmnLZydcSR/I4cEOIqc6cUuJdMbvhDkaILc4ARnz+hy9hHy
 h1WUHvMlWliDAmLC+UQNK73p8o/DPoyaQKIuxC6YQ6wtU7hJv0=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 1:55 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> The Samsung pinctrl drivers depend on OF_GPIO, which is part of GPIOLIB.
> ARMv7 Exynos platform selects GPIOLIB and Samsung pinctrl drivers. ARMv8
> Exynos selects only the latter leading to possible wrong configuration
> on ARMv8 build:
>
>   WARNING: unmet direct dependencies detected for PINCTRL_EXYNOS
>     Depends on [n]: PINCTRL [=y] && OF_GPIO [=n] && (ARCH_EXYNOS [=y] || ARCH_S5PV210 || COMPILE_TEST [=y])
>     Selected by [y]:
>     - ARCH_EXYNOS [=y]
>
> Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
> Fixes: eed6b3eb20b9 ("arm64: Split out platform options to separate Kconfig")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>

This does not look like a correct fix:

> diff --git a/drivers/pinctrl/samsung/Kconfig b/drivers/pinctrl/samsung/Kconfig
> index dfd805e76862..c852fd1dd284 100644
> --- a/drivers/pinctrl/samsung/Kconfig
> +++ b/drivers/pinctrl/samsung/Kconfig
> @@ -4,13 +4,13 @@
>  #
>  config PINCTRL_SAMSUNG
>         bool
> -       depends on OF_GPIO
> +       select GPIOLIB
> +       select OF_GPIO
>         select PINMUX
>         select PINCONF

OF_GPIO is an automatic symbol that is always enabled when both
GPIOLIB and OF are enabled. Selecting it from somewhere else cannot
really work at all. I see we have a few other instances and should probably
fix those as well.

>  config PINCTRL_EXYNOS
>         bool "Pinctrl common driver part for Samsung Exynos SoCs"
> -       depends on OF_GPIO
>         depends on ARCH_EXYNOS || ARCH_S5PV210 || COMPILE_TEST
>         select PINCTRL_SAMSUNG
>         select PINCTRL_EXYNOS_ARM if ARM && (ARCH_EXYNOS || ARCH_S5PV210)


The problem here is that PINCTRL_EXYNOS and the others can be built for
compile-testing without CONFIG_OF on non-arm machines.

I think the correct dependency line would be

      depends on ARCH_EXYNOS || ARCH_S5PV210 || (COMPILE_TEST && OF)

which guarantees that OF_GPIO is also enabled.

    Arnd
