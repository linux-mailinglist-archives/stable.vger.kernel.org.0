Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FF42C2003
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 09:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgKXIbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 03:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbgKXIbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 03:31:15 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE126C0613CF
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:31:14 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k4so19958987edl.0
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I+tOihb6gtEPqqeGzt6Ir1ztTFoDxrJy8P1J3pOhkHg=;
        b=JYm5KulKQPt8nQlirAOsdfgCSm7m44rifBPRgmawiqnh3peUuIMzvBEvV7bxlo6jRQ
         NZm0uBTydK3J7L409rO9AJEWGZ7zhZXwinkt5gnaRA6vIEda862Cwu2bcjLFwLujvabk
         3bXBcMTv/s/qjHHkEvr+goQ7RLayZXF/3tP/Jdhr8l7YwrkAAGk55Dff6fd8BoHqQeiS
         1tBHHFf5hna7yrVQZ2wwJmL5p/LfYse2+/tZO0mFAW39whBIaUpmV5HcpBvvzuUyviYH
         GfflnOWXSMILgzGO8ZX25lfuyZsoA4hmxBYt5hCfhm9XFTipVbQUT5zIJrAMuzo1mMGi
         uZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I+tOihb6gtEPqqeGzt6Ir1ztTFoDxrJy8P1J3pOhkHg=;
        b=r/zfDGMo4zdoYMGZrpYpNOoJLkfFVq2NfV2gr70bgt7eL2RivqgAQPiZ+OTmrsyUQN
         cOdEXpsP8xwNBqYGTMF1kLtSyKI/tFraftjanyVRt7s8hIFYHGmKBaL2KpiPPvXnNBT9
         2tyJtRAU7O6ep4vwHvqmDeP1H/JfdIkbgEBvvMEJyYtrNlUbCXMY0Vw2vx3WXkYQb5FX
         uXO3D+4PBpekppUdfxk55tzrgxspac1oVq4nBcVkmdgnvCieSS/BihSYDUi6QraZDE1t
         oATgjckd+Zu6vemq7y1SdXfWbUw/QIWCVMK9pPWAzZrBHmSc1wNt1MHsgUFSmV2CIAC3
         ZqdQ==
X-Gm-Message-State: AOAM531fwTedKPdXS/XWZrLIi28O/uXDoH32dzkcbliTc5UcnpzeD3Dz
        yTEU1vdc16M4Lrxrq0xryGFVd55ehRZw/iccdCYRng==
X-Google-Smtp-Source: ABdhPJygZ+gZoMZgRnKPpgO7XrvN5whRtFdmmPEAGmLMTOSuWPnIRn9hGoBhhLtQt+EBJ7w+jelhLAXfy6LXrTKCL8s=
X-Received: by 2002:a05:6402:1644:: with SMTP id s4mr2858092edx.221.1606206673393;
 Tue, 24 Nov 2020 00:31:13 -0800 (PST)
MIME-Version: 1.0
References: <20201123121805.530891002@linuxfoundation.org>
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Nov 2020 14:01:01 +0530
Message-ID: <CA+G9fYsBvH5oFe6eWGXCu95evHy9w=LbvLKgbPouKuXaQ7XMCw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/47] 4.9.246-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Nov 2020 at 17:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.246 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.246-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.246-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 1a0738f3aaf5542394e8c7ce9738027a79b26241
git describe: v4.9.245-48-g1a0738f3aaf5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.245-48-g1a0738f3aaf5


No regressions (compared to build v4.9.245)


No fixes (compared to build v4.9.245)

Ran 32932 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
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
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
