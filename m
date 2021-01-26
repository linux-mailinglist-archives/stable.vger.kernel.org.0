Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542E5303CA9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392549AbhAZMLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403835AbhAZLOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:14:44 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8A7C0613D6
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:14:04 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w1so22334568ejf.11
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fYupSZfGSpqos6EzshWCWKgBwX/sGM1t83TUapOfzmM=;
        b=VbexN5wLBRJtg3Xgj9BkYYyyr8SuLc06wkm+NGzg/+9oJil7Roa4JQw0qf+F1c9gey
         kwas/UBso+IGlk25Nb7MvzV7jPPHeySjaDI9Y6Z7wxy8F2tglLnCJ8I3B3YO7WE4fjt4
         LmmHmByJBRG/pXkHSCmfehy8xkazxFN7wpStnCmiDR1guqhho+s9k+OVjSORLAr6A6rb
         i63WLSkgoZIt7ZTM4X0kp9tTXECGodFypL8yEyj6XQApclBz1gCrNEGQg5qTruHQEbxt
         eDV/QlD6K5kgFiZAzlNWxYeJGca740vq8hLL5xNKz+rLBRehXA9/Ek+Oeov/dObbNTPi
         vItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fYupSZfGSpqos6EzshWCWKgBwX/sGM1t83TUapOfzmM=;
        b=J/SABH3kw43EvEIwO3+l3MMF/Wv9pQmjpccXC358BLFndorxQtH8Kx/zDngQhPWba3
         7Vw83+KH81aCDhg5kURhzuTAW1kgMzA45jITLMPo/LTj4wECf+9vXIxm0xqi+KjhI2L+
         tGVChhgOGo0ULOnL0/V9VWkRY3BiGIz4K+IVUle7UcvmbP+NcXkNQ5+mVvqFyqKL0GzH
         3qyl5fJRspSOSfpMXZfh7GiA/fOP2lFQn4BlbcOPd6PxoEw8FxBWs45zi4dD9RHZkfEY
         XpXXFBHspjfnpuIceZFph5s9D9RXt+S+4A2Z7rqsYtswfrJpkSUcmLF8iwsYJPtLWpUT
         vdfw==
X-Gm-Message-State: AOAM533zjYZ7ztx8r5Z2+/tpxY74pAfJuq6mmM42pkdQx3BzExjDDH9u
        80lvhpPmfAJTgF09Yus3l5M84aKmQr9UXZO6UkaiAA==
X-Google-Smtp-Source: ABdhPJwITm2P906snRNQzkdwvalIaBuZXKqAsdaamIm+KLMDW0TYv3btFTjih2Ul5m4jPuWGP8A2Ce1hF4b8DTtGZAQ=
X-Received: by 2002:a17:906:39d0:: with SMTP id i16mr3149157eje.18.1611659642780;
 Tue, 26 Jan 2021 03:14:02 -0800 (PST)
MIME-Version: 1.0
References: <20210126094301.457437398@linuxfoundation.org>
In-Reply-To: <20210126094301.457437398@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Jan 2021 16:43:51 +0530
Message-ID: <CA+G9fYtqJDKOwFGevaOmmK7gbKgo61CpL70yyG2daOxvRp5FSQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/88] 5.4.93-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, sagar.kadam@sifive.com,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Jan 2021 at 15:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Jan 2021 09:42:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As Daniel pointed in the other email thread,
riscv failed build:
     * clang-10-defconfig -  FAILED
     * clang-11-defconfig -  FAILED
     * gcc-8-defconfig -  FAILED
     * gcc-9-defconfig -  FAILED
     * gcc-10-defconfig -  FAILED

the riscv build failed due to the below commit.

> Sagar Shrikant Kadam <sagar.kadam@sifive.com>
>     dts: phy: add GPIO number and active state used for phy reset

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=riscv
CROSS_COMPILE=riscv64-linux-gnu- 'CC=sccache riscv64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts:88.27-28 syntax error
FATAL ERROR: Unable to parse input tree

Build log,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/986616680

-- 
Linaro LKFT
https://lkft.linaro.org
