Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D760C45C861
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhKXPT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhKXPT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:19:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113B2C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 07:16:16 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r25so11975467edq.7
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 07:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SRT+e552GYvNrORbzlTEU61qBtjXbKFQpbMpGUU4ymo=;
        b=YTDuBANHpXFVqUo1qkgF02nMQFYOO2uY4GfbpdQPyIJG+8nSxYWYwqVi2LDqFU/52s
         RKs1t4HAq9i8BbYgh8dYSA0l6mxF0KI9FpHXumcK9DQ8uxEdEseXNr6zAO6PQ19RzsE9
         l8/zLRcAHemonR3fp93U4Cj04kU/w+o84rXxjLbECbYox7KIlKFQbC7SRBMNvQT0pw4h
         LiQcD6UkVzkMBzBW2Po/PuN/RudODyd/8D+z/fzlMkg9VTWntwvdE+sJevVnuT40c/PZ
         f1uvA5ueXuMvlpS6wAJXs7lHBmyk8ba3tyIUTtyP34NsKA5ax/hQRwtVZVBDL6eAtXnd
         FB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SRT+e552GYvNrORbzlTEU61qBtjXbKFQpbMpGUU4ymo=;
        b=TulCkF4tqgl1/XnWtsrNR2p5LvrUo417hYrAtO82FPAaTul+lNAKM4N457+neGPIXO
         r6SmFfNYVZQWzjmAPFnis8VV9lR/dDlVDqAO/YFuv9TO92HYKKomk5zP0BlXlMMmXoKi
         v28Gv43luBrppZMb9z9GDaChs25faOCqGFPtfVKpW4QwH9oTiYIivcPELB/qbt+NKpkr
         eYh9OQQQ7/F1f02ZrwMoXpxiBQNlh196saSLtgJxXj471vDLEu8owGV8ue0kjjYvxkBa
         IjWqIOf/qayjRcudMdixsGoIJJj39R0TdlLRM3eXXHPw+h9p6AZOXjNTCjzkoDmeRiRD
         SHNQ==
X-Gm-Message-State: AOAM532kKuvknZ5oVkwo5lJLxlzYCUmdH47y8CRqP59Vxmop3jZqjwpE
        yHDXSXDK5bcDLqKOpXCtexe3MBzd3wRU6sn593Mscw==
X-Google-Smtp-Source: ABdhPJynSITOhrxhbtnxTLdM1rUgW04j724qNIPfv0C85Q1r16XLCAIbvxp/CErtyvSxfVdx6MnY1VnbxCibHichNw0=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr21013814ejz.499.1637766973849;
 Wed, 24 Nov 2021 07:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20211124115702.361983534@linuxfoundation.org>
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 20:46:00 +0530
Message-ID: <CA+G9fYsmeKPRicvsjwT3gfQurf-k=15vm+kNCCKfOOoyAQE1oQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 at 18:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on arm gcc-11 builds
As I have already reported,
https://lore.kernel.org/stable/CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com/

drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
drivers/cpuidle/cpuidle-tegra.c:349:38: error:
'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
you mean 'TEGRA_SUSPEND_NONE'?
  349 |  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
      |                                      ^~~~~~~~~~~~~~~~~~~~~~~
      |                                      TEGRA_SUSPEND_NONE

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Due to the following patch,

cpuidle: tegra: Check whether PMC is ready
[ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]


--
Linaro LKFT
https://lkft.linaro.org
