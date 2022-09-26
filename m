Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA85C5EAD69
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIZRAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiIZQ73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E65EE0D8;
        Mon, 26 Sep 2022 08:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A928B80B06;
        Mon, 26 Sep 2022 15:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80085C433C1;
        Mon, 26 Sep 2022 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664207977;
        bh=DvZFZNwqn0ZytOdLEPK8RWC8688qKjbR9EzPhi20zew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqHDqf4pB2bld6dm91Ej2mJOLxK69UuyTxzVN/g4Y6vm57lrJvnsA+6Jrvht7EJ1V
         dFaHbTeSAAVALc9ev+mBdLwJEF3vPzml6uBOzp9iPVneQbB7rF495WlLlB6GwCux+k
         zz6TZa6jppHvDMaBf1Jmr5wdxtNOILZ6M520VEHk=
Date:   Mon, 26 Sep 2022 17:59:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 000/141] 5.10.146-rc1 review
Message-ID: <YzHMZsgnKsslFttl@kroah.com>
References: <20220926100754.639112000@linuxfoundation.org>
 <CA+G9fYtCSiceE2kbx2HeCqwhag5wx4PAm4WbiU0g89pr68Wsgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtCSiceE2kbx2HeCqwhag5wx4PAm4WbiU0g89pr68Wsgg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 07:56:26PM +0530, Naresh Kamboju wrote:
> On Mon, 26 Sept 2022 at 15:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.146 release.
> > There are 141 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Following build warnings / errors noticed on arm and powerpc on stable-rc 5.10
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on arm:
> 
>    - build-gcc-12-ixp4xx_defconfig
>    - build-gcc-8-ixp4xx_defconfig
>    - build-gcc-11-ixp4xx_defconfig
>    - build-gcc-9-ixp4xx_defconfig
>    - build-gcc-10-ixp4xx_defconfig
> 
> 
> arm build errors:
> -----------------
> 
> drivers/gpio/gpio-ixp4xx.c:171:18: error: 'IRQCHIP_IMMUTABLE'
> undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
>   171 |         .flags = IRQCHIP_IMMUTABLE,
>       |                  ^~~~~~~~~~~~~~~~~
>       |                  IS_IMMUTABLE
> drivers/gpio/gpio-ixp4xx.c:172:9: error:
> 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
>   172 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpio/gpio-ixp4xx.c:172:9: warning: excess elements in struct initializer
> drivers/gpio/gpio-ixp4xx.c:172:9: note: (near initialization for
> 'ixp4xx_gpio_irqchip')
> drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
> drivers/gpio/gpio-ixp4xx.c:296:9: error: implicit declaration of
> function 'gpio_irq_chip_set_chip'
> [-Werror=implicit-function-declaration]
>   296 |         gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> Error was caused by below patch
> 
> gpio: ixp4xx: Make irqchip immutable
> [ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]
> 
> This turns the IXP4xx GPIO irqchip into an immutable
> irqchip, a bit different from the standard template due
> to being hierarchical.
> 
> Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
> for a rootfs on compact flash with IRQs from this GPIO
> block to the CF ATA controller.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> net/core/dev_ioctl.c: In function 'dev_ifconf':
> net/core/dev_ioctl.c:41:13: warning: unused variable 'i' [-Wunused-variable]
>    41 |         int i;
>       |             ^
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [Makefile:1832: drivers] Error 2
> 
> warning is caused by:
> net: socket: remove register_gifconf
> [ Upstream commit b0e99d03778b2418aec20db99d97d19d25d198b6 ]
> 
> Since dynamic registration of the gifconf() helper is only used for
> IPv4, and this can not be in a loadable module, this can be simplified
> noticeably by turning it into a direct function call as a preparation
> for cleaning up the compat handling.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Stable-dep-of: 5641c751fe2f ("net: enetc: deny offload of tc-based TSN
> features on VF interfaces")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Now dropped thanks.  I'll do a -rc2 soon.

greg k-h
