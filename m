Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8155EAB16
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiIZPbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbiIZP3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:29:37 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A09BF7A
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:13:44 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nb11so14382819ejc.5
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MT1LPTvIFv/5Fp9GWZQcD85XMgLKQ5pRfsrKQbYX3Zo=;
        b=wBUeqX0VM7B7xY4xc2nadwSd0mQCjwrF7AfUmaeraAsLEk5oZM+7DigkJZOkTbzmR5
         W5lNb2pCXhWCWpelDvjrP/8wrmX40ty9CwcVz6vMKpGxkcpXTdY8ZlgqdXXP3fK611sX
         dTIt6lW1UA4cS53m59eZ052yfn1N8f+PEPJJBBhioQ8atlD/tK/t58jN/AtEuk/ic/Rl
         /nM3MCxv5pEhqVlT66/FuMPItiD1vPIq8ca1tbWoaEq7aDu7t4HigYZT62yxJwXAYus8
         zUSdaQ+Ls/8QOHVx/dlAQtbIywUbjuPe/rrI7UWia1m99IGmaGdUrfp/v4ZGUivFltMu
         m+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MT1LPTvIFv/5Fp9GWZQcD85XMgLKQ5pRfsrKQbYX3Zo=;
        b=miU16PdiDvO8Pc+26DXFGcJX1EfJiGhtvwH2B3ta9dX5TzH+lzPu+59amgQpszwwni
         6Ks9EIESMKGt1ar+fJiZeq/W7UNrZlowV4EQGZGod8DL1Xl70GX5cksuQmlQjmBBstj7
         +o7yPlBsDeySymgvxbsSettOzMc1reYzqCo1lfZSa6VUi8g7nJgVmj3tTEK/j/1gt3nQ
         3JY7s2ePVmst9Rc8zwNak5x9ScybAyvmv4v5GdsKY5nr32UIKaVbWNPbRwL1cJmXWdxO
         GxrlXdwZ528ZGJN13wlILb+pXjaDsWnzEkjdMqt9qGBUrrGK25rkPBUdcjHeE3wQCpos
         aR/w==
X-Gm-Message-State: ACrzQf1ZsJ6vJD+n0Q3XeUDntBK2FKwzewu56/DeC7Prl4DNzwA8+5Pq
        vq3G8xExR+RF5tt0xDpIher896Q6DuIu01WrdVO4wRG3bZiJpA==
X-Google-Smtp-Source: AMsMyM4LjreNkwwt6BrcTo7OI8omUAJD6z5AYRUeUZmUjd1XgexKN0dPouiXbuR5EBZd8g1Yv0pXKEGC2r/I4HN1fZs=
X-Received: by 2002:a17:907:948e:b0:783:91cf:c35a with SMTP id
 dm14-20020a170907948e00b0078391cfc35amr4147025ejc.366.1664201622543; Mon, 26
 Sep 2022 07:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100750.519221159@linuxfoundation.org>
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 26 Sep 2022 19:43:31 +0530
Message-ID: <CA+G9fYsaviCxmAqWzOxgkU7HcmzU=e0LKci2_+5uPUOc+8xb3A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/120] 5.4.215-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 16:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / errors noticed on arm on stable-rc 5.4.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on arm:

   - build-gcc-8-ixp4xx_defconfig
   - build-gcc-11-ixp4xx_defconfig
   - build-gcc-12-ixp4xx_defconfig
   - build-gcc-9-ixp4xx_defconfig
   - build-gcc-10-ixp4xx_defconfig


arm build errors:
-----------------
kernel/extable.c: In function 'sort_main_extable':
kernel/extable.c:37:59: warning: comparison between two arrays [-Warray-compare]
   37 |         if (main_extable_sort_needed && __stop___ex_table >
__start___ex_table) {
      |                                                           ^
kernel/extable.c:37:59: note: use '&__stop___ex_table[0] >
&__start___ex_table[0]' to compare the addresses
drivers/gpio/gpio-ixp4xx.c:171:18: error: 'IRQCHIP_IMMUTABLE'
undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
  171 |         .flags = IRQCHIP_IMMUTABLE,
      |                  ^~~~~~~~~~~~~~~~~
      |                  IS_IMMUTABLE
drivers/gpio/gpio-ixp4xx.c:172:9: error:
'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
  172 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-ixp4xx.c:172:9: warning: excess elements in struct initializer
drivers/gpio/gpio-ixp4xx.c:172:9: note: (near initialization for
'ixp4xx_gpio_irqchip')
drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
drivers/gpio/gpio-ixp4xx.c:296:9: error: implicit declaration of
function 'gpio_irq_chip_set_chip'
[-Werror=implicit-function-declaration]
  296 |         gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
      |         ^~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:262: drivers/gpio/gpio-ixp4xx.o] Error 1

Following patch caused this build break,

gpio: ixp4xx: Make irqchip immutable
[ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]

This turns the IXP4xx GPIO irqchip into an immutable
irqchip, a bit different from the standard template due
to being hierarchical.

Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
for a rootfs on compact flash with IRQs from this GPIO
block to the CF ATA controller.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>


--
Linaro LKFT
https://lkft.linaro.org
