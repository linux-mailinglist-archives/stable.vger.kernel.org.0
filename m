Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC464314663
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 03:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBICcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 21:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhBICcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 21:32:39 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C96C06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 18:31:58 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id l25so11641429eja.9
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 18:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTfGi8L/4CClRzVPopUo6ym2s0FBZL3P9CuXWX9APaM=;
        b=AvpvsLLoyj2RMvQKuZdRWp3N2Rljv2I6Xl80gQO51Qp+z7414zu8O1UN5G5sartw6D
         +IhkKyoj7zV4VyavWWOQ6a6KtSVb3pUmU4NEu3YZrrNizjNIIIQmuUH0x9Lifyks8z7f
         pwtMQ+RC9wBmRk+NcgEPKOMJ6tvIxUZFBMzQdAdWxFrvuRG7TtqTH3o3Kyi9DmCKcfk2
         +xNTn30tAaGakVdTPUy/amTU5SVkkS9lVgMew8ktr0zeTvzWHZuN4cF2OZWlM2fYi3Ce
         pEP6sDdhqBpesMewlMcX+/HzK8E8vOslrSn+RZFUrI4MvfUsXSzQFNu28F3chTPwMpEq
         Xbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTfGi8L/4CClRzVPopUo6ym2s0FBZL3P9CuXWX9APaM=;
        b=Q9saLYl5LzGyp1hcq5baRu4CJIcB0xLFqbjC4eGQ78uINmh+CxhsXhhOP+xowNj9Nq
         IMHF0phweqrQqRzcWe9Spx67mIZRPnNcx/ByWO6ILo6E56BG/1G5Q4KH3v/7eNxE1g+8
         SIHq6U2jPnJvg4W68zi1pJHvds2L+z7VNgLklRHLsvg2NJ+5v/Nralhh0vr5gNaPWNfy
         hhl5Pe6fgojhAhqxtv1RGYpQtZIBkm2wiXwwMD1Pyy/KghO+PijhFkFh5MdTd2Qldez8
         mxBheAIkq/wPCqVc2hcZ+qMRGwwsbEOMgZ9XiApgPnaN2/DnLTKP2pbrE/nLFK6r1IZr
         psKQ==
X-Gm-Message-State: AOAM53168qTuD2wAsK3WPXzdvDdlucMu8ts7tDVmHPQbWBNUhQnMZzVH
        w5k+CMk3V6bf+r9Ma2IEHOovAWG2pFGJbV39x26gijTEpxE5xoso
X-Google-Smtp-Source: ABdhPJyPqGgUhxoMWPs2L7UW1Jz9zUd86P5RnbK6VvIdX/xhbV1j3UzNgC6kJP1XsWoG0pHkFlPFl1LzpBH2fQn9Dz0=
X-Received: by 2002:a17:906:ca0d:: with SMTP id jt13mr19524040ejb.170.1612837916543;
 Mon, 08 Feb 2021 18:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20210208145818.395353822@linuxfoundation.org>
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Feb 2021 08:01:44 +0530
Message-ID: <CA+G9fYsjJ+K7w-PQ4gp=L3QO_VSaUMr6syvAS77--aFbfZVK-g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Feb 2021 at 20:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.15 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Due to the patch below, the x86_64 build breaks with gcc 7.3.x
This issue is specific to openembedded kernel builder.

We have also noticed on mainline, Linux next and now on stable-rc 5.10.

collect2: error: ld returned 1 exit status
make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1

ref:
Build failure link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/64/consoleText

> Rolf Eike Beer <eb@emlix.com>
>     scripts: use pkg-config to locate libcrypto

From 7658769759718950f5eda0079e84837738d8fda8 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eb@emlix.com>
Date: Thu, 22 Nov 2018 16:40:49 +0100
Subject: scripts: use pkg-config to locate libcrypto

commit 2cea4a7a1885bd0c765089afc14f7ff0eb77864e upstream.

Otherwise build fails if the headers are not in the default location. While at
it also ask pkg-config for the libs, with fallback to the existing value.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Cc: stable@vger.kernel.org # 5.6.x
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
