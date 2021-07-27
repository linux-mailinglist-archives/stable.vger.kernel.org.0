Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0263D6D04
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 05:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhG0DJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 23:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbhG0DJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 23:09:05 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9477C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:49:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gn26so13789725ejc.3
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpLCH8i7gCpJey27/mvGMaFIhXVVT1m8mh82Ruty9ss=;
        b=yW81CH7lqOqxC8Scp/WY6mmK8Kgt5C+EijGLLTcwu9Y06jyxCd3m6lvMpI/3sgCnfc
         R6Rknv0sbcp1F5sGYii1jaa70wglYwqtXMDwFRPgjGRfMTphfFfCy1Q2DNpkXE91884O
         OnCYga3Il5Ip8lKpAjnb32lYKdRDY/hz5F7u1UZtq5bG+/SDehIaPcCRMWmHAlrZV0Js
         Suq5xnFE3FpoZsKN2KppExY3ZK7ygz01ASn5sBkc/k4QUgjqS0xcVfIOa79bwUoIyjmI
         M+yuBCLXECBBT2fBLkCh5LfmIFR0eqZXDjiBGUofoTOfIw/Jkwe/4GrT9bVKxEjw152T
         wW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpLCH8i7gCpJey27/mvGMaFIhXVVT1m8mh82Ruty9ss=;
        b=T6Oxcce4CXuRti+CfTxEPyPEZYyohEm/OA/hmmsAHbEBdq9snuQ/4QK1+QGi6gMoei
         Yj6/hu8TAOIRCT7/GQzmkjSiBkFt31Lofgl6S/i2oPBktqXg0gl6Qc9i0kVNNCnmz0EJ
         vSoa/3P0Y06RuYLZX8mMlwmr/+ojHDV741nX29yHm3gES6wtqRJdayhkP8FSsQFDLZrI
         eptFG6CIuhde05B9XT4Hh/RLzdtgk4I4mWlXcN7GIgpibDrqEgDljTvHrXrkEIqwfPyJ
         Srcfmo5TYdrAr435kVc7m/1+RrlNUPgZ0StdeZ2ZeZSl7NSorWZ4jgnQqHfp2hfhHHWO
         MSKw==
X-Gm-Message-State: AOAM531Tbz9kgIlN+mDvALUAh2aqpmeOZoWKC/0QDqchfrBYtZxxIKdr
        xvVFK5j7UHHcFNHJi5ks0ugJdY225eR29FF/56eZSA==
X-Google-Smtp-Source: ABdhPJywJKyZVSHTxSkKleiscIisK5+YmFGUR7HMWOxInQL6D6Je5QCbQqjZvIu5zcLy1QLrnR234wpdZAg9z2p1W6w=
X-Received: by 2002:a17:906:40d1:: with SMTP id a17mr6366003ejk.503.1627357770176;
 Mon, 26 Jul 2021 20:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153822.980271128@linuxfoundation.org>
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 09:19:19 +0530
Message-ID: <CA+G9fYvKUnzAph-kNsc45v1vF9DLK5NgYONdue4q-Zuw1S3oVQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/47] 4.4.277-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Jul 2021 at 21:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.277 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.277-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


perf build failed on 4.19, 4.14, 4.9 and 4.4 due to these warnings / errors
for all the architectures.

> Riccardo Mancini <rickyman7@gmail.com>
>     perf test session_topology: Delete session->evlist


perf-in.o: In function `session_write_header':
tools/perf/tests/topology.c:55: undefined reference to `evlist__delete'
collect2: error: ld returned 1 exit status

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/893/console

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
