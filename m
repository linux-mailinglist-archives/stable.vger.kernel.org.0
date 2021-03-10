Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2FD334543
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 18:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCJRix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 12:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhCJRiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 12:38:23 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553CBC061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:38:23 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p7so28989885eju.6
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=okV++VFxVSFyAERp8JdbnLcbQt5jDIvaux7uTpycWNY=;
        b=qBemZ4JHjSlP1msVG5z66KEhDBsStg25FgSoIPAXuJMTQjjx6hdY3APMV3MjWA1djV
         tlbdeAPJd16zyumDX1HSElzgZfjNRLxYC4Sv40i9rJ2YX/EXVcx7m3MSbzX6HObxxcT0
         Y3QLgxUGWToiRJ1ixU+CgP7nBuvg8W3DCxJwTHpYV1AgHJxgaV7D+b18iq74Sc3bjbfK
         iBH188WxGP/T9/hpYY2c2/bxHeY/J50rHcMAmv1GWi9HB5x13gRGVKbjsskK49EgAPLO
         /VYN3cIhUrWSRaF3MZD7nvtPkqVRuGOQ7YyH5wOftpNuJ6w8/G7FJ/YmJTrGy+Q8JvNM
         mKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=okV++VFxVSFyAERp8JdbnLcbQt5jDIvaux7uTpycWNY=;
        b=VKGasAs56PuKjnORAvvqrP15SVQjpvE1zILaa0gMXBaE4SIjT/ecy7QL6oz0an5Sdo
         rJlsnj4l8bMmKFWQRmfnSY7swvEtoaoXCVp7kWghNsZiOIz8TLYin+2DZ3P8XsINu9o/
         k4OPJsx8aqrIN/Gv8UOaZCuDPHzVv4j4B5AwHM9+UEZ8L1DqL/bsOL4DuhKg0K+U8nlv
         NsG876E+KhKBQqmxI6r2QmZeezVrig2qF7HSAhgPwUdndVUnx8qgxzdwaO4PvGsIW1y7
         DiiEWJjpFepqRipMyAt/jl4GhyPY9v3J+4LXmZYF4YUPYJcJEBXTP2tzaCGT5xZVXx5H
         AEow==
X-Gm-Message-State: AOAM533WtQdGI1vcVOzcXZtyzTDVn4ftGBE0a52lk77dsoq63E815pLE
        M3lFWGIJrcgZRseq/Beryv5CgX4NTO0ebUJ7JBSAbA==
X-Google-Smtp-Source: ABdhPJzcR1BVT4oayP9E7SdgOQDg9FkHjMIuiCm2oG++v/DxNaO3ew1DPo2i++wCyrjHoK66vb0bK/qwkMoYPDFo0HY=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr4854165ejo.247.1615397901839;
 Wed, 10 Mar 2021 09:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20210310132321.948258062@linuxfoundation.org>
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Mar 2021 23:08:10 +0530
Message-ID: <CA+G9fYuydf-g2FPOtP9LAX-4zY3EF64Bx0OQjbjn=a4V+0=eLA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/49] 5.10.23-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 at 18:54, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While building stable rc 5.10 for arm64 the build failed due to
the following errors / warnings.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
clang'
drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
        case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
             ^
1 error generated.
make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> Alex Elder <elder@linaro.org>
>     net: ipa: ignore CHANNEL_NOT_RUNNING errors

Build log link,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1086862412#L210

-- 
Linaro LKFT
https://lkft.linaro.org
