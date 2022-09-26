Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6875EAD84
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiIZREt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIZREY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF827CCD;
        Mon, 26 Sep 2022 09:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91D7260EC3;
        Mon, 26 Sep 2022 16:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CB1C433C1;
        Mon, 26 Sep 2022 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208417;
        bh=TpYLjLkdwT/3KQvOCYgaHupNVXSuSPcK5EbkAVo1Pec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bue9cJcqCK573+zRR4kaawP8VpdQPm/6xkpFXlsS/XC1xfaasMgZs0q62qib+0HT8
         d7hep7eTcaCimpMevg/1BcBEoLlrrQ/eASxQQCWeARZ0V3wDJXeTcU3djD6y6SBmo3
         0JoihvZ9Q0S6zWPw/Cctreg4RKO3HVNvyrtlXLAc=
Date:   Mon, 26 Sep 2022 18:06:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
Message-ID: <YzHOHi2NwrNlMOVw@kroah.com>
References: <20220926100756.074519146@linuxfoundation.org>
 <1d7f82a0-b75f-d305-328e-8e84605149f6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7f82a0-b75f-d305-328e-8e84605149f6@roeck-us.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:39:25AM -0700, Guenter Roeck wrote:
> On 9/26/22 03:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.71 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building arm:ixp4xx_defconfig ... failed
> --------------
> Error log:
> drivers/gpio/gpio-ixp4xx.c:171:18: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
>   171 |         .flags = IRQCHIP_IMMUTABLE,
>       |                  ^~~~~~~~~~~~~~~~~
>       |                  IS_IMMUTABLE
> drivers/gpio/gpio-ixp4xx.c:172:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
>   172 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpio/gpio-ixp4xx.c:172:9: warning: excess elements in struct initializer
> drivers/gpio/gpio-ixp4xx.c:172:9: note: (near initialization for 'ixp4xx_gpio_irqchip')
> drivers/gpio/gpio-ixp4xx.c: In function 'ixp4xx_gpio_probe':
> drivers/gpio/gpio-ixp4xx.c:296:9: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror=implicit-function-declaration]
>   296 |         gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
>       |         ^~~~~~~~~~~~~~~~~~~~~~

Should now be fixed, will do a -rc2.

thanks,

greg k-h
