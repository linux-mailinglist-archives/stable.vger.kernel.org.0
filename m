Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E163D5EAB6E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiIZPoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiIZPnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:43:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B8B5F43
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:26:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id 13so14479054ejn.3
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kviW/kfGTdCum1FUfpznjlr9QAFsmNGG3WHj4fGpdC4=;
        b=NrC/5DqsHkAZ1V5Hx+CHDeXFUw6qXFGEZ/Xl2S8xOKBTXXR6XaghMdqZeZk7eHdZVe
         xqI+asdBqXsrQtk1goFqo1cHtneKXnRX3WsEYAyytZQxT3PO6kf9CEl2SEeA62px1b7H
         z3vys96W2s5h6GAuI/D1+beFxgpps+277addi1Mgc0RxhjfoeTfwuvBck75uIei01wsk
         6ICpRKXwd0psJ6GxfYJooqksmVR1ZHjJL/PPXyU1JjOZQXdYRLrgv5J1nGAqtQAnUoYl
         Z1mdEzqzrcF+CjDLgwTM26tJ71/9SvDzIC+B5ugoY02nbtxN+WuPilYSsRIGR6+R18lv
         GFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kviW/kfGTdCum1FUfpznjlr9QAFsmNGG3WHj4fGpdC4=;
        b=R+MCWZUjurnHCbqeYKb11lVq28dua2V/15WRs7wa9YdhJg/DaBlAQkAWSHMNpXApAE
         hMWHdrUOaxnM9vAmETGUEII8M5O4+72Ao5NTxzmXj3cPKreBMF7vfwkQ58Cwnzlm0utH
         8pW3xi1JXUO/2lIGmebcc3XvIjC7m39jPSlhCm5mpWJqHXA7NmGVK6J+D+iaDwRSGLEW
         j27yXSTDoco+5sHbOjDIaFdHHvCV9jYo264HE6v9a+Io/RukWtyhbe9nFIAz25gWHQvq
         lvujQzyJ7rEQFu4UDiRJrME8qSlmcDRshsVWjilq4VcR2qHIlI3v/miLyNEYssyrUQwY
         DK6g==
X-Gm-Message-State: ACrzQf386lz9hGkKJRAMAqw/mdHLWJRx0cCon+2Ql34cM9cc8ZhWqsgS
        Id+69NIjAfELcUEoMxQFMvMtZzHXttSk0PgCsKz5Mw==
X-Google-Smtp-Source: AMsMyM5PBP2ckmAZkrP18VOs8XaCn0cRlaz3thTNfuitZxPBgSIqYNVy7fODnA8+B6mGxWgAT0NXv93bg7Jfn4W8aGE=
X-Received: by 2002:a17:907:948e:b0:783:91cf:c35a with SMTP id
 dm14-20020a170907948e00b0078391cfc35amr4200187ejc.366.1664202398315; Mon, 26
 Sep 2022 07:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100754.639112000@linuxfoundation.org>
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 26 Sep 2022 19:56:26 +0530
Message-ID: <CA+G9fYtCSiceE2kbx2HeCqwhag5wx4PAm4WbiU0g89pr68Wsgg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/141] 5.10.146-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 15:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Following build warnings / errors noticed on arm and powerpc on stable-rc 5.10

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on arm:

   - build-gcc-12-ixp4xx_defconfig
   - build-gcc-8-ixp4xx_defconfig
   - build-gcc-11-ixp4xx_defconfig
   - build-gcc-9-ixp4xx_defconfig
   - build-gcc-10-ixp4xx_defconfig


arm build errors:
-----------------

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

Error was caused by below patch

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

net/core/dev_ioctl.c: In function 'dev_ifconf':
net/core/dev_ioctl.c:41:13: warning: unused variable 'i' [-Wunused-variable]
   41 |         int i;
      |             ^
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1832: drivers] Error 2

warning is caused by:
net: socket: remove register_gifconf
[ Upstream commit b0e99d03778b2418aec20db99d97d19d25d198b6 ]

Since dynamic registration of the gifconf() helper is only used for
IPv4, and this can not be in a loadable module, this can be simplified
noticeably by turning it into a direct function call as a preparation
for cleaning up the compat handling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5641c751fe2f ("net: enetc: deny offload of tc-based TSN
features on VF interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>


--
Linaro LKFT
https://lkft.linaro.org
