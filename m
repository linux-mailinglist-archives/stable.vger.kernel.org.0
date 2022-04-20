Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC9D5087E3
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352992AbiDTMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352906AbiDTMQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:16:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DD7393EE
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:13:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g20so2020092edw.6
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t4fnkhjiK7o7zoKvIVj8krdFqshM+NAvjEpfPjIpMNE=;
        b=oesE1IY+fZaZQAK7RVRyEFGXJv0OHXbxWD8BJTs9H6XZ5ov9VhWpB+X+ynfaWlF6KP
         NU/z+zj6ysinrY/GiZnPNG+F6MeIlG44haXQ7l4CURDsWrl6OQgLyZwXYIebaxyBR9JT
         kXTgf0BI7TdjuOCkzvkwNv823Wr2wKlmGkCSJOlaOStPvX8ibW20jPHwAM6nD3k2Mblc
         Uj/bPf69I98fnN5lgO7OQDAhACAwqkxlc7quoTASh5537AAuC0fxZrv8lawDskal3qRV
         3LXx6WuvAZ8xu7pDmOEDEU2NjPAxY02ZjMxq/sNlx1svNodffFkrhmIvBTvYhhTWfY/C
         DxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t4fnkhjiK7o7zoKvIVj8krdFqshM+NAvjEpfPjIpMNE=;
        b=2EjkOvvrHxQqfjzXtiX3rEzDaXcwy8620Cdm7V6dgSPtUNvVMCs2mURruingbXa/Eb
         m6AxO9Rj4GZPCYGkQvrbhc3Z979Qi7tQPQFxeyLLpE0/ru1PJCTUhyG+c8Hpp5MHZlx2
         BZq0K8H0Hp/HWheetrQHqPvRmF+KTOqAZljYm//grlD7HnxibZkjkAlCjFzKwh7oaH2f
         kNBhrm6cmmB4AZ93yJ/qd/uK0PJK9g79q7r1qOLYvdeMVtmtOSoU+w0aq34rr2wHilOG
         v6gx1xLD1DoGGgasiywioE99r6oHY0H+1e/NbWWUs6T9ybCttIX8rTXNmGabRZpgUMut
         unrA==
X-Gm-Message-State: AOAM532F9j+oioEWjo2jr6y8n+/+miy1A2pQY14QnG47+ft8C8tzuf9u
        bwXmIjidlsBmHWr6lnt4sXrP4g==
X-Google-Smtp-Source: ABdhPJze27l1aXD+D4yIQEK0h88zbma4f2jYuOAuBnfilQml1/mAiidAIhshNW98oRXBiF5le2r20w==
X-Received: by 2002:a05:6402:321b:b0:41d:888a:3ff0 with SMTP id g27-20020a056402321b00b0041d888a3ff0mr23117956eda.167.1650456817280;
        Wed, 20 Apr 2022 05:13:37 -0700 (PDT)
Received: from [192.168.0.225] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id fy11-20020a1709069f0b00b006e8b68c92d8sm6559748ejc.162.2022.04.20.05.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 05:13:36 -0700 (PDT)
Message-ID: <0c0b53c3-294a-b1ac-487a-ca96266c4bb7@linaro.org>
Date:   Wed, 20 Apr 2022 14:13:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos
 config
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
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
References: <20220420115512.175917-1-krzysztof.kozlowski@linaro.org>
 <CAK8P3a0uH5KjaobrqUmJQnvMmjkUaR1iC-7jEPjZFjZF1Z-GfQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAK8P3a0uH5KjaobrqUmJQnvMmjkUaR1iC-7jEPjZFjZF1Z-GfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/04/2022 14:10, Arnd Bergmann wrote:
> On Wed, Apr 20, 2022 at 1:55 PM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> The Samsung pinctrl drivers depend on OF_GPIO, which is part of GPIOLIB.
>> ARMv7 Exynos platform selects GPIOLIB and Samsung pinctrl drivers. ARMv8
>> Exynos selects only the latter leading to possible wrong configuration
>> on ARMv8 build:
>>
>>   WARNING: unmet direct dependencies detected for PINCTRL_EXYNOS
>>     Depends on [n]: PINCTRL [=y] && OF_GPIO [=n] && (ARCH_EXYNOS [=y] || ARCH_S5PV210 || COMPILE_TEST [=y])
>>     Selected by [y]:
>>     - ARCH_EXYNOS [=y]
>>
>> Reported-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
>> Fixes: eed6b3eb20b9 ("arm64: Split out platform options to separate Kconfig")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
> 
> This does not look like a correct fix:
> 
>> diff --git a/drivers/pinctrl/samsung/Kconfig b/drivers/pinctrl/samsung/Kconfig
>> index dfd805e76862..c852fd1dd284 100644
>> --- a/drivers/pinctrl/samsung/Kconfig
>> +++ b/drivers/pinctrl/samsung/Kconfig
>> @@ -4,13 +4,13 @@
>>  #
>>  config PINCTRL_SAMSUNG
>>         bool
>> -       depends on OF_GPIO
>> +       select GPIOLIB
>> +       select OF_GPIO
>>         select PINMUX
>>         select PINCONF
> 
> OF_GPIO is an automatic symbol that is always enabled when both
> GPIOLIB and OF are enabled. Selecting it from somewhere else cannot
> really work at all. I see we have a few other instances and should probably
> fix those as well.

True, OF_GPIO I could skip here.

> 
>>  config PINCTRL_EXYNOS
>>         bool "Pinctrl common driver part for Samsung Exynos SoCs"
>> -       depends on OF_GPIO
>>         depends on ARCH_EXYNOS || ARCH_S5PV210 || COMPILE_TEST
>>         select PINCTRL_SAMSUNG
>>         select PINCTRL_EXYNOS_ARM if ARM && (ARCH_EXYNOS || ARCH_S5PV210)
> 
> 
> The problem here is that PINCTRL_EXYNOS and the others can be built for
> compile-testing without CONFIG_OF on non-arm machines.
> 
> I think the correct dependency line would be
> 
>       depends on ARCH_EXYNOS || ARCH_S5PV210 || (COMPILE_TEST && OF)
> 
> which guarantees that OF_GPIO is also enabled.

I don't think OF is the problem here, because the error is in missing
GPIOLIB. The platform selects Samsung pinctrl but it does not select
GPIOLIB. Possible fixes are:
1. Do not select Samsung pinctrl from the platform (but have some
default), so on compile test build it might not work.
2. Select GPIOLIB from the platform (ARMv7 Exynos does it).
3. Select GPIOLIB from here - this is current proposal.


Best regards,
Krzysztof
