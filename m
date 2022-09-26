Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF155EAD88
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiIZRFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIZREj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D639DF52;
        Mon, 26 Sep 2022 09:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A60EB60F7C;
        Mon, 26 Sep 2022 16:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9037EC433D6;
        Mon, 26 Sep 2022 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208434;
        bh=hCRRXsW11YMvC8Y8h44DrQp5jTNBYzAtTZLpVUqbjlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EF15N9D47cxNAsXFeSi5soyYYba34r9NeDFJVBY8v30k6RTbFpNHiwVH+ek+dTDNK
         iw2lxudpF2qZtThPYwua1VtVBX8uEMvLphOC2K6n+gk20KlSz8HI0TW1XHDzsj4nzu
         bgCDqtPGe2T7yd+gkv7FPAVHdH0V76v/fr09oM/U=
Date:   Mon, 26 Sep 2022 18:07:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
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
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
Message-ID: <YzHOLw5flpnGswCp@kroah.com>
References: <20220926100756.074519146@linuxfoundation.org>
 <CA+G9fYsiTk-nq98AaQF+BNmxtEH911m+SDhXGbLns5Nb91cMWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsiTk-nq98AaQF+BNmxtEH911m+SDhXGbLns5Nb91cMWA@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 07:31:25PM +0530, Naresh Kamboju wrote:
> On Mon, 26 Sept 2022 at 16:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.71 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.71-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following build warnings / errors noticed on arm and powerpc on stable-rc 5.15.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on arm:
> 
>    - build-gcc-8-ixp4xx_defconfig
>    - build-gcc-11-ixp4xx_defconfig
>    - build-gcc-12-ixp4xx_defconfig
>    - build-gcc-9-ixp4xx_defconfig
>    - build-gcc-10-ixp4xx_defconfig
> 
> Regressions found on powerpc:
> 
>    - build-clang-nightly-defconfig
>    - build-gcc-8-maple_defconfig
>    - build-gcc-9-cell_defconfig
>    - build-gcc-12-cell_defconfig
>    - build-gcc-11-cell_defconfig
>    - build-gcc-8-cell_defconfig
>    - build-gcc-10-cell_defconfig
>    - build-clang-14-defconfig
>    - build-gcc-9-maple_defconfig
>    - build-gcc-10-maple_defconfig
>    - build-gcc-11-defconfig
>    - build-clang-13-defconfig
>    - build-gcc-8-defconfig
>    - build-gcc-12-maple_defconfig
>    - build-gcc-10-defconfig
>    - build-gcc-11-maple_defconfig
>    - build-gcc-9-defconfig
>    - build-gcc-12-defconfig
> 
> arm build errors:
> -----------------
> drivers/gpio/gpio-ixp4xx.c:171:11: error: 'IRQCHIP_IMMUTABLE'
> undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
>   .flags = IRQCHIP_IMMUTABLE,
>            ^~~~~~~~~~~~~~~~~
>            IS_IMMUTABLE
> drivers/gpio/gpio-ixp4xx.c:172:2: error:
> 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
>   GPIOCHIP_IRQ_RESOURCE_HELPERS,
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpio/gpio-ixp4xx.c:172:2: warning: excess elements in struct initializer
> drivers/gpio/gpio-ixp4xx.c:172:2: note: (near initialization for
> 'ixp4xx_gpio_irqchip')
> drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
> drivers/gpio/gpio-ixp4xx.c:296:2: error: implicit declaration of
> function 'gpio_irq_chip_set_chip'; did you mean 'gpiochip_get_data'?
> [-Werror=implicit-function-declaration]
>   gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
>   ^~~~~~~~~~~~~~~~~~~~~~
>   gpiochip_get_data
> cc1: some warnings being treated as errors

Should be fixed now, will do a -rc2 soon.

thanks,

greg k-h
