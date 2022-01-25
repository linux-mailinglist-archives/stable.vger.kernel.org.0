Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5878149B46B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 14:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574766AbiAYM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457527AbiAYMyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:54:52 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBACC06174E
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 04:54:51 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id p5so61293792ybd.13
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 04:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UX+mCL/+3OJClsOKBeEkEvb9NIERuxwgkgzWt1+XqsM=;
        b=MCfxrIYF6U0/6cGSKJjwW/A47yTN2CaZTRTOMOG2K0WZgWik2SWsZvjQVEGGjUY99V
         Sx2JU0toFct5kvq8SG4BQoQXuCn9miimZ6o2926HqohYBeRkqTRj15KlZrt9dL9Isf6L
         9ZfLksc0m9sfMpYNVxEepuYZPZmOMxQ6ZDHmdc1v7qstSTuC2jtroO7GTsRGbgWH37Rf
         XP+rkoQnNUVmJELWTn+aUD1hhJfCDuBdhUUOviJZHYsE9Iu4qOzo/VrTBNxzpCzBy2oN
         lNWGfb8aACd3gU8QF9o5sRKzv9UZ8O7vRJc4RX2DnvPdAiRKhurCnVQeYhUapbzbUGCE
         2GOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UX+mCL/+3OJClsOKBeEkEvb9NIERuxwgkgzWt1+XqsM=;
        b=VIOtxuHxn/fF0zkTkNrgD4EZ/r5MjufsOP73iRMAX2Acozvv2KMl3+qmi5wMBClsul
         kIFyFykIOCDahwJqTe6cPE2SSobU9ZxLeYb6a8ozsuZiJNPF7cQzlqwx6yBtCV2ZUCII
         JKj1gJ2BQ/wLaqAvF5dbfRX/IzNRHfNMzjYfj5s/WXBfAv0+wbYiwGjor18fCpkSTvcU
         tuLYD7P0ftWMdrB7+XJuGLD9kxY6qBk/L978aiYcQLCccB7tL0aG9t6OCRwpnkF8USvT
         l3LK4xIPJ7m6Aj1SZr6PmUkQuDMhcIXmEyQdgmUBLAUouZjJ6GpGACP8WNb7oXHhHQ7A
         McNg==
X-Gm-Message-State: AOAM5313hAWZMl6p8C9XZJICwOffuwDcIV+X5X7ddrIlpOB6PPyVBOJr
        pf27kIREoRjqZn0QjobUgB0Cx+Is/Q16IQqMS5ZQhQ==
X-Google-Smtp-Source: ABdhPJxy7bKXZE3JuwuIx8BjOw2Sgn8MbTp7tnuKrlmmDX6NQqm0P+KRj1X89r1eunx+bttGoOG/cYEVleuw2ogE1X4=
X-Received: by 2002:a25:4284:: with SMTP id p126mr30711644yba.108.1643115290841;
 Tue, 25 Jan 2022 04:54:50 -0800 (PST)
MIME-Version: 1.0
References: <20220124183932.787526760@linuxfoundation.org>
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 18:24:39 +0530
Message-ID: <CA+G9fYvzftL7cWFysem9z4AMKFXMRShy6-Ewp74ckP1xeaBCAA@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/157] 4.9.298-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 00:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

same as 4.14 build error.
stable-rc 4.9 build failed.
arm (imx_v6_v7_defconfig) with gcc-8, gcc-9, gcc-10 and gcc-11 - FAILED

 > Lucas Stach <l.stach@pengutronix.de>
 >     drm/etnaviv: limit submit sizes

drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c: In function
'etnaviv_ioctl_gem_submit':
drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c:329:37: error: 'struct
drm_etnaviv_gem_submit' has no member named 'nr_pmrs'; did you mean
'nr_bos'?
      args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
                                     ^~~~~~~
                                     nr_bos
make[5]: *** [scripts/Makefile.build:307:
drivers/gpu/drm/etnaviv/etnaviv_gem_submit.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org
