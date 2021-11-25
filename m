Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4D45D973
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhKYLqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbhKYLoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 06:44:55 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A94C061746;
        Thu, 25 Nov 2021 03:37:51 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id g17so10844542ybe.13;
        Thu, 25 Nov 2021 03:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=URm6ZWUfxchA16w1ij07A+03cvDLxhDqhsPzShg+v+E=;
        b=PaCRUvW1W00c4jfML41lt4hu65ASX4DDzmnXw7fEZPlSOhD74KimgvC6uXWYqIcxPx
         rQ9yCRplElME4UjdVUbDBE1rvO67aYWWWrsBZ/Idn7YQs0N+metgEH8D3E8QJzfrcXin
         z197meFn5rbzbUsCAb/8NfRH572uo2+REBe2p4SUZnx/nBlBUHfDnNU7aQhduRHMF7kz
         ekPTalGZ1ybJdn1U9/pVPpn3iYRdp8xD+guzSJUjV8SyarA45y//WNH+A3ZD2vFDo2ny
         V9htczUZCBbPd7cn5B6Kk3WM1JghwofAkwghRIj2D8E1XP2lENUD9DsALgdIrozIp7gm
         51Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=URm6ZWUfxchA16w1ij07A+03cvDLxhDqhsPzShg+v+E=;
        b=CuhlX9hhkuNRjb4AKyzWDHWIOIGjfwxjkcdvch1xyC9P8IndM56Rn0R3P16toxJqeI
         gMKan55dOioDTtu0xJIUGMxg1BdDQiBkZqbbAhzA+2FRf9raCBPee3uvfYtndRmUI8sf
         miNb4P5OmM2pygl3T+cQ6EstLhiRvf/8Ezm+MZ7+o6u1c9jbw3yFSrwdDirHA4Nl+7ny
         9yQLEfpMS6mme7RaM4+o9lvkRiCZ+exvDRirnM/AKtUbbGMUAwW/5p/EamsOw0j3kjmL
         EGRmnHwHnWwOadAMFzlBrHAljgo8Ig3H+BlqK4CwWnb+91OYnskpLjX4KkRB2oLzMVCt
         g9MQ==
X-Gm-Message-State: AOAM533bV3w2NLFEe7pygkj0n8B7jeV7JGZabNT9PrlBGCqd/hfKGo9j
        QOQ3+Plm8ahBliAOPcy1+u6OSnlQpDeEUVopGaQ=
X-Google-Smtp-Source: ABdhPJxOtyYiVC0L2G/p1HOoM1hO3jXUEWdObOdBw37UpmM6XjmQSqygXwLBaLXzjneBIdgZVvkN0YxjpJtlqf9bN6c=
X-Received: by 2002:a25:b7c6:: with SMTP id u6mr5876697ybj.16.1637840270575;
 Thu, 25 Nov 2021 03:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20211124115702.361983534@linuxfoundation.org> <20211124135311.GA29193@duo.ucw.cz>
In-Reply-To: <20211124135311.GA29193@duo.ucw.cz>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 25 Nov 2021 11:37:14 +0000
Message-ID: <CADVatmPhw41K9Eg75_7w89bgXLMnuGcJDNcsP0KMVxhkTQmTxw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 24, 2021 at 1:57 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > This is the start of the stable review cycle for the 5.10.82 release.
> > There are 154 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> CIP is running tests here:
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
>
> And there's a build failure in CIP testing there:
>
>   CC      drivers/mmc/core/sdio_ops.o
> 5040drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> 5041drivers/cpuidle/cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did you mean 'TEGRA_SUSPEND_NONE'?
> 5042  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)

I also having the same build failures for arm.

drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
drivers/cpuidle/cpuidle-tegra.c:349:45: error:
'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
you mean 'TEGRA_SUSPEND_NONE'?
  349 |         if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)

And it should be for 4d895b601038 (\"cpuidle: tegra: Check whether PMC
is ready\").


-- 
Regards
Sudip
