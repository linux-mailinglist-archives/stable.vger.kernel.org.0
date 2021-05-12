Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D001C37CF07
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhELRIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbhELQxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 12:53:18 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF23C03461C
        for <stable@vger.kernel.org>; Wed, 12 May 2021 09:47:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id di13so27882600edb.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLDlceFPG4F0Fb3dNmzA+5MCXXJnN0q1C9HnPLqxGao=;
        b=JzN0isVmUOucKzUKjur/vn33DhCU89F/fH1BSSc5FQmte51dxAY2hw/9FG1hIp887h
         YNlOP5aE5/xQfni49iOo2ZpX9ZEk7bBOhlQQmHkjmNg58xN3MezOnQ6ocZCzSkNGZNKM
         8cvZq6P9kIBbQZAlw/oTJhLswznEGMSNGeGcZsqAOu6iA1+Isx546PrPPKBHXoQmTc3p
         JdUm3DffBX3wu8GZb3lmlSS1HdpW/oVEtDzuF7tSPsLxSzDrpE9o6fagffn31l+TK+PP
         RqQeMwJiwLUBiJKAIBMotEJGeDemsLjxIfMmdVwcpJdtFE8dN+w0G24h1Ujex1/2QwZ4
         7FGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLDlceFPG4F0Fb3dNmzA+5MCXXJnN0q1C9HnPLqxGao=;
        b=q/fa4EwEbG/yEYRcFliHOG++kzz4bJCEnAoLaauSJIMXL3/hWgIE61hPbMY+mvvNhd
         I9su5yCeNYJYfgyU/416ksP1NawfRKcQqUZQDR5yQna/y9adOG2Jys52D5bW0gcU7FPN
         k2GiFG8MBfb550wi98I7c4XLLG69UXMhp4wYQkAIEUtmKQzHS72H8O1eS1d4n6YYzDrg
         nTc+lXOMaMozl43egXCeBQi9ozNIZjRI2tI60Dhf2XzEqtGfKDqXdojfMVzuV/Y6stcc
         ZZMsQVX1TH7DE7XYGAvHI4j/Cohny6/Ne5VHPynA9dIa8a/8lIUKLzxU8EOi0RfNQgmG
         Udkw==
X-Gm-Message-State: AOAM533BwFjdOzEJlosUCYLNMoZd8xMFz5om64wFeNSe1PA6YV3BH6JN
        gkstMtIH/1gv8YgTn0g1D0ESyG+ZddXsA84peILEpQ==
X-Google-Smtp-Source: ABdhPJyRZZ/2wFYuQ59+lzOy/ODmfJDP4HsKhPf+qtv1rThZSJPRW9sq7+R/GFBeQlTmuP+XhNbOkyQHO6bH3wh/JvM=
X-Received: by 2002:aa7:cd4a:: with SMTP id v10mr38037505edw.239.1620838076182;
 Wed, 12 May 2021 09:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org>
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 May 2021 22:17:44 +0530
Message-ID: <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build regression detected.

> Alexandru Elisei <alexandru.elisei@arm.com>
>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it

stable rc 5.4 arm axm55xx_defconfig builds failed due to these
warnings / errors.
  - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed

arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
  kvm_arm_vcpu_init_debug(vcpu);
  ^~~~~~~~~~~~~~~~~~~~~~~
  kvm_arm_init_debug
cc1: some warnings being treated as errors


steps to reproduce:
--------------------
#!/bin/sh

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
axm55xx_defconfig

ref:
https://builds.tuxbuild.com/1sRT0HOyHnZ8N5ktJmaEcMIQZL0/


--
Linaro LKFT
https://lkft.linaro.org
