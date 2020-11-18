Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473D82B7CA2
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgKRLZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgKRLZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:25:25 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32641C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:25:24 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o21so2248511ejb.3
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fWKyRf2WsGHgLb7HiAmjkYpOWmKSOplli+A+DLy0S1A=;
        b=d6h2oBOgo8mPEvFFMG9ikJzYINgr2PJUstL/3YRrVJBCArbW00nZK8tLfkWao49J+B
         R0NmkkNXipiwcl71+pRwsbyJZR9JIdjpUGRlcXW1caUKFKQqoPy15C9pkc434Xa2vHY3
         kp1YXrFqF6YRnSLHJj9qo7+XuOW3mF8ueGL5bgKR8Z8zbPu2KwngbvhDhmWHFAi4T/+g
         QavwecWVrRbsgG47fe5PJrafK+RLkwElzsd4Y/Q/y1zga6R9vjN90WtzGeVaqWgLZpkl
         IAu6A0Fcx+3SmE/JdaXrZeTsry6+aBWkJ4wygNqPdakgW6ER4FW3e3AHIHiG0Oq3S+BA
         60FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fWKyRf2WsGHgLb7HiAmjkYpOWmKSOplli+A+DLy0S1A=;
        b=ZsLdCVzvJ6uJ3F0UYKblMk7wGzmVVsZMp8pn1mMhRv5M8lan9SrcywbArZ1dBUgJlX
         bF2AqDx/0Vk2l0fE6WyDHD1o7r69r3MILT2oGmJed5lyaV/RTGIu0h9CQdv72PrOHZRX
         o8ScO1GvAhWN/2xMX2d8Vwtfe2YJjd5b8urPd4d9B6CljtEN/1aWTUTW1mwN9v8jytD/
         WS/hqeRiUuUS+/RemnuIq3QGtYA3eYJdxHMq6jERKLugmpabX5EkX2sOVwpHEWdC9dAn
         CORPX8t/Tdx4TaImxNYtW5bjKnfcspaqm0/eS+VFufpsY3LvbKFlIkh/m6WEbjaXV5pQ
         4TxA==
X-Gm-Message-State: AOAM532O10NI5x22s/Mcw6skdMamGEoT3eWcT0uyulBLoh3891qUmSWv
        A0qqblupl4SDHp7E0jypYQZT4cMs7i81VPkApl0czA==
X-Google-Smtp-Source: ABdhPJya9T6m7LJWsC7KLQDRV29Lbf+oR9VCfnP5P0PVMelIFdzdzjtVjdfHlmk3dHQuMc4dgqV8K+p2WgsBb3YOt0Q=
X-Received: by 2002:a17:906:af8b:: with SMTP id mj11mr5668211ejb.170.1605698722788;
 Wed, 18 Nov 2020 03:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20201117122106.144800239@linuxfoundation.org>
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 16:55:10 +0530
Message-ID: <CA+G9fYuQYufAewC_CzZ4ibo42iJNGZ2rU_1wRn8Z9zgXoi8W6g@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/64] 4.4.244-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.244 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.244-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.244-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 5c64a4febafe0af1834cf497df8985d917a94b05
git describe: v4.4.243-65-g5c64a4febafe
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.243-65-g5c64a4febafe

No regressions (compared to build v4.4.243)

No fixes (compared to build v4.4.243)

Ran 32841 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600

Summary
------------------------------------------------------------------------

kernel: 4.4.244-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.244-rc1-hikey-20201117-859
git commit: cdeaa8f4dfeb6e5920b76b6ee2d57b77b2810576
git describe: 4.4.244-rc1-hikey-20201117-859
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.244-rc1-hikey-20201117-859

No regressions (compared to build 4.4.244-rc1-hikey-20201114-857)

No fixes (compared to build 4.4.244-rc1-hikey-20201114-857)


Ran 1760 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
