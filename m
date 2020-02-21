Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2BB167BDF
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 12:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgBULR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 06:17:58 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45715 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgBULR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 06:17:58 -0500
Received: by mail-lf1-f66.google.com with SMTP id z5so1187339lfd.12
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 03:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gim0LahUou+1GhT0i2NTsUJucCc3gqJedRUqf5uOSGY=;
        b=YapktekuYDYpX1KTSNJAZ2QZReOKHtBO1DePweQSweEsAq1UHVUy1RypFJE81btbve
         ZJILpa8pMOwj3RPbn7ykJKganH0aQQ2ar63kA5mcgWPSCvb9P6piCgYUIr5o1QBWn+ZX
         RbZeed8wn7fwIu/Em8IJ21LS/NE2kiarmk7xDyHwdMUtwhDcbPag5gQjxjeBZ/4pUBim
         MCJmins9PcZqcjkg6H1DP64Hw+I8GKLMWlKwlat7dz0Zr8k7SLT70L/gbOWLw4veNqmm
         i460+mvR8VJ0/a0iNGzsI9QQ2uGlpu1AIF48iIyex/Tx3kSoTCOfykalbc+T7PAHfiDx
         DJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gim0LahUou+1GhT0i2NTsUJucCc3gqJedRUqf5uOSGY=;
        b=oKn+FcVNrK7vPVYwsXsS+EqDKaZNoWztNCl4r9UH+04FwisWeG1qcXz42QlyNgELmp
         vZ5oG1nOiEgSDD7zoEozftBSd93sjvBSaSAAvEyhmSJ6uiDLL2epxfhkMnFA/TKjcYTR
         EEABPZu9JvalxzQu9HKiAqLHBU95dnlReZShEs/kDcdEpSqiN6Toaax9+89vA2ssz0Kb
         fifzHwNPwmv6JlkdDgLnyi8QISOx/LoOG6aKyX9AqSqnMXRH0ps9Xgqoj5RLrTSw6AJV
         2PvdSCZekIcOQizytGylDPgq3fJdA3XfPfXuMHq9Q3xBwsfUoSoUm90eqR6L2oOKRHtJ
         tc3Q==
X-Gm-Message-State: APjAAAXAfQeNXfW+fWM4p6Ju0gEutIwSwIlChXPQ9uFXVsoJc24hskRp
        Ymm+leWTwuSeK7aOPLD1nwlJ+Xjbp1L2+iGbdg3jUg==
X-Google-Smtp-Source: APXvYqwBQiV+KkA20U9up3VHyUSJOdigNHkwyzQDqlAHqaQHklI/NeQBKdnFSBD4r3qgBx1CeYRW6gAVDCwxU/N2S0Q=
X-Received: by 2002:ac2:4199:: with SMTP id z25mr19750795lfh.26.1582283876489;
 Fri, 21 Feb 2020 03:17:56 -0800 (PST)
MIME-Version: 1.0
References: <20200221072349.335551332@linuxfoundation.org> <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
In-Reply-To: <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Feb 2020 16:47:45 +0530
Message-ID: <CA+G9fYv-KC0v++YsyXR-rhC2JBGUfhNGD+XYaZjN3fJSX1x_mg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, t-kristo@ti.com
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jonathanh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 Feb 2020 at 15:34, Jon Hunter <jonathanh@nvidia.com> wrote:
>
>
> On 21/02/2020 07:36, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.22 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
>
> ...
>
> > Tero Kristo <t-kristo@ti.com>
> >     ARM: OMAP2+: pdata-quirks: add PRM data for reset support
>
>
> The above commit is generating the following build error on ARM systems ...
>
> dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error: linux/platform_data/ti-prm.h: No such file or directory
>  #include <linux/platform_data/ti-prm.h>
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

build error:

../arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error:
linux/platform_data/ti-prm.h: No such file or directory
   27 | #include <linux/platform_data/ti-prm.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[2]: *** [../scripts/Makefile.build:265:
arch/arm/mach-omap2/pdata-quirks.o] Error 1

With these below three patches, it applies cleanly and builds.
But I'm not sure these are not expected to get into stable rc 5.4 branch.

3e99cb214f03 ("soc: ti: add initial PRM driver with reset control support")
c5117a78dd88 ("soc: ti: omap-prm: poll for reset complete during de-assert")
d30cd83f6853 ("soc: ti: omap-prm: add support for denying idle for
reset clockdomain")

However, it's only patch
d30cd83f6853 ("soc: ti: omap-prm: add support for denying idle for
reset clockdomain")
that introduces file linux/platform_data/ti-prm.h

--
Linaro LKFT
https://lkft.linaro.org
