Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4775EAA0D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiIZPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiIZPQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:16:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46047C1AC
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:01:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l14so14281295eja.7
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=WwbBPgpgSOhDsXzAEnUiTwCSqAmh6U+810HxaiUH3Zs=;
        b=UrtVKnOix0Lho2BSMv2jSyYSA0LAxChjJSwfJ8qTj/5/DnGtjVLDNF2LzMibde/9P2
         d3V5rEl2RYMIyanf52ejwgaNhpSmEPgYXM0GCAJmELQeM/1tcX1tZgYRH9uJU/Z5sFM4
         zutpl2fJ/EdCTMLz9rqgeLdeTooH2JtCE4BRWEA+UJ0zAtBJdD231k04hqVSnXL2Kfgg
         thRDnPf/nZI+TIqICwinTP+GmAhxGOTEtR1tof0/lk/DFyiV7ZEi4qvjev6xIQgJFRxl
         V23ZAx/v4v6pHUor7HWaOVNbTOi2eKOGNxkZTZslHmxAwFlx4zvar+lsSY+t0U98mIlj
         ioVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=WwbBPgpgSOhDsXzAEnUiTwCSqAmh6U+810HxaiUH3Zs=;
        b=NShAMwp7pugngYZPdbRsBOamQSnLeUpVeMKryorlNmoTBjni73aaCL3I34ix7aBIes
         ZEXZClZlKtNbX2YGDBVyZvN8cisJg3iEM2204RbdEInTuh6O7AyQMIt3DlULb+Lz5psw
         Oj7cvQzy7ej7SfQpWhVBKxBfE06DMtKUo4ZiI8oFcJaofxQNhAfiegpf0VZ9oYe2/QZL
         iM6QzXtG/bvKy1yAyhT4VaO9AIRZ2ZAmbJI7a8D6M/ZB4+0sCQJKzLt2iZmJ0P+clyYH
         ziDpPFlpWea7wsBx464XPTW3d9lgu8J97Kx0uyv2sxbaiKv0muUEQhiBODGCqMhyj20X
         g91g==
X-Gm-Message-State: ACrzQf2WqKfTU3TBvm0V+81eq0GuRFhbHpIZ9SWTd2JZ1H4xHQuCnoog
        rd2a/7RkyR1dju/vNaJNzpxqMhvXSdWIfVBl1+9lJA==
X-Google-Smtp-Source: AMsMyM5EGRHraqsTUxCdbMQ61QK0aJzGFGFVBi/7vZQSQr/VAFXheJhEouqn+2fNCDyvTRnY/g1MvwLGQu/Nd94MN44=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr18595743ejb.169.1664200897188; Mon, 26
 Sep 2022 07:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100756.074519146@linuxfoundation.org>
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 26 Sep 2022 19:31:25 +0530
Message-ID: <CA+G9fYsiTk-nq98AaQF+BNmxtEH911m+SDhXGbLns5Nb91cMWA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Linus Walleij <linusw@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jordan Niethe <jniethe5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 16:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.71-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / errors noticed on arm and powerpc on stable-rc 5.15.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on arm:

   - build-gcc-8-ixp4xx_defconfig
   - build-gcc-11-ixp4xx_defconfig
   - build-gcc-12-ixp4xx_defconfig
   - build-gcc-9-ixp4xx_defconfig
   - build-gcc-10-ixp4xx_defconfig

Regressions found on powerpc:

   - build-clang-nightly-defconfig
   - build-gcc-8-maple_defconfig
   - build-gcc-9-cell_defconfig
   - build-gcc-12-cell_defconfig
   - build-gcc-11-cell_defconfig
   - build-gcc-8-cell_defconfig
   - build-gcc-10-cell_defconfig
   - build-clang-14-defconfig
   - build-gcc-9-maple_defconfig
   - build-gcc-10-maple_defconfig
   - build-gcc-11-defconfig
   - build-clang-13-defconfig
   - build-gcc-8-defconfig
   - build-gcc-12-maple_defconfig
   - build-gcc-10-defconfig
   - build-gcc-11-maple_defconfig
   - build-gcc-9-defconfig
   - build-gcc-12-defconfig

arm build errors:
-----------------
drivers/gpio/gpio-ixp4xx.c:171:11: error: 'IRQCHIP_IMMUTABLE'
undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
  .flags = IRQCHIP_IMMUTABLE,
           ^~~~~~~~~~~~~~~~~
           IS_IMMUTABLE
drivers/gpio/gpio-ixp4xx.c:172:2: error:
'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
  GPIOCHIP_IRQ_RESOURCE_HELPERS,
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-ixp4xx.c:172:2: warning: excess elements in struct initializer
drivers/gpio/gpio-ixp4xx.c:172:2: note: (near initialization for
'ixp4xx_gpio_irqchip')
drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
drivers/gpio/gpio-ixp4xx.c:296:2: error: implicit declaration of
function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'?
[-Werror=implicit-function-declaration]
  gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
  ^~~~~~~~~~~~~~~~~~~~~~
  gpiochip_get_data
cc1: some warnings being treated as errors

Build:
https://builds.tuxbuild.com/2FInaOdiei4NQtTNOEIHoQiC7Lq/

Powerpc build errors:
-----------------
powerpc64le-linux-gnu-ld: arch/powerpc/kernel/rtas_entry.o: in
function `enter_rtas':
(.text+0x92): undefined reference to `IRQS_ENABLED'

build: https://builds.tuxbuild.com/2FInbucjJPAvqTvJc7358SVLh2O/


--
Linaro LKFT
https://lkft.linaro.org
