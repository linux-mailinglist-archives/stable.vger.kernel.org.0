Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6762C1DFD
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 07:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgKXGML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 01:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbgKXGML (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 01:12:11 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8294C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 22:12:10 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l5so19584253edq.11
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 22:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pZjg1xQ0Iv1GHEMitlUxPg48M2pI2OsXz3XVyqZx1r0=;
        b=GZiTlMquhbSE4wLmzDeSnGGztt2ei/rHdw0eKl8OvUxXvd7jvPE3kYbGSkwi1m/A0W
         pSh/QT3aG9nvJxhk+bTLtA//UVc8hpM3+uuIl8kN3s8yFs+Yfk8l4mEZc5S1pnomITvO
         VSL+kQQnaeKiXdF+cYHbTtVu1MswCFMx7wPtGAIdhIGRp64LpV7nVgsjBMc12NUbF0e9
         w5j0644ZrAfgwSNlO3UF19XzxL/AoEVYCyu8HRfu1KSnbjGRAEGC9qUqS5/gpCBM7bbK
         NxD+xN58Ig4KxtiW1ArPv23sh3/WTfAVamUYNtY4mnZB9yFAH3Ua/J1bfPiEIQ3kXV68
         iKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pZjg1xQ0Iv1GHEMitlUxPg48M2pI2OsXz3XVyqZx1r0=;
        b=CyS8tVtdFTzRrZAzX1ATv37lHn/DfxBnaHIDW9r+1DYq8q25I1VI7Mq+vA52RC7hXw
         9Ct3z2HbbnzWbYv58CLcryNxpAFwDmaDjznCGIMIqXKxjjeASzBDIj7+xBpBqUi0rAoE
         C2N0ZOb2ibqdUerasWijQAK+4dhW/OxwNL0MiNg7CfN4/yJbAZ8tOoldCsbNPA1ACPn9
         c/Khe160CC2hF8u+sT0U5Bs0BVDz+j82HRWiU5hkoLuX18epbG2IDHZkZfdCCVqfbw9B
         jExCupinRbOnC5ZYFdnCPsVHXma+i4WSBUn6La5NFsMCpHfmrZRz3+dmAWgzK1E0M6RK
         r83A==
X-Gm-Message-State: AOAM5318TRvVnvhWJkVj+UlKrB2g+ouQnOps2rYtQDwMZCEyX129c5s1
        InAeSvWzLatrXNWGP9oLa7VWw3HZ3QNoYaA332neLA==
X-Google-Smtp-Source: ABdhPJxhPT+j3W7KSDmBdwh1ZLFOkOpBZ4rFGHgjNOe+urTL0QetqiVGVQFhnpqDBRnXFqzFdlJsscpVJn+KPgMk9OE=
X-Received: by 2002:a05:6402:1644:: with SMTP id s4mr2455486edx.221.1606198329283;
 Mon, 23 Nov 2020 22:12:09 -0800 (PST)
MIME-Version: 1.0
References: <20201123121835.580259631@linuxfoundation.org>
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Nov 2020 11:41:57 +0530
Message-ID: <CA+G9fYtOd8pajJ4aDYjMqScyfd_VCtvudzhKzPybuNiJOWSKJQ@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
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

On Mon, 23 Nov 2020 at 18:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.11 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
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

kernel: 5.9.11-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 7939279fca79f52c48861829cef3fe5d15529c42
git describe: v5.9.10-253-g7939279fca79
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.10-253-g7939279fca79

No regressions (compared to build v5.9.10)

No fixes (compared to build v5.9.10)


Ran 47415 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
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
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* kselftest

--=20
Linaro LKFT
https://lkft.linaro.org
