Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DA29DA1B
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgJ1XOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390237AbgJ1XOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:14:38 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADC0C0613D1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:14:38 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m22so731223ots.4
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xcYtxhATV9tNgzx/0u/R7WT0cT5PolfDyRZ40j1FlbI=;
        b=zgsUAsMT0yDpwiTyOvKDRHI+scC2U9iPXQzA5yYwY+Tqh8UAupR9WUMi5j7rPAKb0G
         MBot37UhvP8sRYYRvOgUm86e204v15RwQ8HNzZ9o/hzd4Wei6ltsr8yURMsIeJMmt0fh
         9G1X21u3jibbfJmYoUEblBbsG2Dh5PvSnLFLGiohh+01PMCPtvyR+3DmVDI2MWxiX2Nz
         XKnMH1kwOt848xReaMGXXTVvHnND/sSAfk0bRQ5M9++dwwC7boNt61hkeSezDkm0U65p
         y1b93ygDMQQRL0vL9JH0JfGL/WyWk9yj3sfsiR43T9P78VT+Q7PubjaogZZeWp5Tc3VB
         8iHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xcYtxhATV9tNgzx/0u/R7WT0cT5PolfDyRZ40j1FlbI=;
        b=nyx5OGT+oinIAaIJhC1To/Mt9Zo2BESwKpQ6wruZSp8nn/ovFvHwCxmJZD9i/wOA3X
         /9qhr3NLGsYwoOlt5xbikXpeGc8GLBw8iIYtUEL02W0RJJLP2tLFT3GtKeyQM2ULvyIQ
         pS9adWEauKZGCn6JQPNTEt+OASKQCJwOaqrLRxPPtANjaIexSdliiN/XRVu7APf1l8im
         nY2hLQDj92wWn1x6YopVnSYqyVEJtvHAXv1uD73vMAghwmKWSqe5LnAPEgTtEHf4tx0b
         6wmxGJm9KDyYA0w7u9nu1hOkG6CfoaNNf1a0Bn9M+bp0vWedQRSIciG0E8109L3QGXr+
         lQ4g==
X-Gm-Message-State: AOAM533K04gbWafyhZ0/LxnNEY69RgufgU7qajHmDUA6xqNcQNyHb6ZB
        Wh64tyFY/FBwItFe4c9kVvDvQY5UGHLDi9ObC0GPX+K7w+Iv6NcW
X-Google-Smtp-Source: ABdhPJy6soemAsqMe1KYx+bmBldzxZD4Uw6ebV8TsxQ/bcsplxiFnj7KM2Q6qrJCMRh4pBcok2RmEJjEr5dSkRTzXfY=
X-Received: by 2002:a9d:22e4:: with SMTP id y91mr5240199ota.72.1603893200353;
 Wed, 28 Oct 2020 06:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201027134902.130312227@linuxfoundation.org>
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 19:23:08 +0530
Message-ID: <CA+G9fYvGVjxrJf=vFzuqhWfcmCUPbeOB3qgL7HWZUBiFAo4KSA@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/139] 4.9.241-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 at 19:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.241 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.241-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.241-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 97bfc73b33b595e89801f5fd849c14af344dccdd
git describe: v4.9.240-140-g97bfc73b33b5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.240-140-g97bfc73b33b5

No regressions (compared to build v4.9.240)

No fixes (compared to build v4.9.240)

Ran 16492 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* perf
* v4l2-compliance
* ltp-sched-tests
* network-basic-tests
* ltp-containers-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests

--=20
Linaro LKFT
https://lkft.linaro.org
