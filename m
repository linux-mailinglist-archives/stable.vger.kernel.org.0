Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBB1F07E6
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgFFQ07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 12:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFFQ06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 12:26:58 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E31FC03E96A
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 09:26:56 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d7so7638454lfi.12
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 09:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WVipMmANOU1TRs4bJMqo6LMdlj1YJeAI2TUZczm2aTw=;
        b=OVOMqoIe555B1hV0WAdydYjQa7QDL/leZXjEUsZ8+vZo7TeKPnb+ULGJUXJGfOfTga
         yFnVaDYZZlutVlYX/pUGAU3wdNkv+1U5cDWfoISagxa7G8SaiVktuSlF9q7+HTf7Xql5
         vHEOvO8ZHYBGk8CQxE61hJJg9iRhJLZcOch9XyeBCvsuoDWRMsYuicf4b3eQbPBDWBHm
         6ELxLqMp8NZmtZJIol7Px8HpK8rJMmlhYuXgigzLn9tvLY1R2udqC8M7+ERkTCGPkaA/
         uzEb9Z2eYB54KkEx/nsTeXmApRRkv/yWngxm1sJ9t3mbdtoOMeGTva7KzBjbXegxzbvr
         nrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WVipMmANOU1TRs4bJMqo6LMdlj1YJeAI2TUZczm2aTw=;
        b=NZSZjCXiAw9lZfLnIKA49swrLvM6VTVNI6fiP4AsGAhh0ObFUKatrQ4McRZ28H8tXf
         Yu/T5i/kc/FOHnqUh7pdRHfMRZXI1sDPmu4YYzjqT35FjlZkxvy3r1FV1SEO44TFx3Fj
         hdq0Kxoq7PBXS1/kIc/mG7DforVSNLFeCSHbSIQv+J6uDpz5LHaIZQK5L/oplsGGsPdB
         1Wj3v8c3s9UGRexKcjMq+HJi1wEvdggsz8yXbNzvzPZc/dCw1+5NUqfnu4NXVFpjkVi/
         0d8dEXLctA8fDhlLynffpxQRPTon9P8FoPDfIn8IjpAA9q5odiwsCPsaXplyPgeVxLlx
         5oVg==
X-Gm-Message-State: AOAM530SlD1tnkNa+njMnGhHmsNMa5GCrfK8NlWFh5qE4y27LXYm9L0i
        Px++k/ZKLhaQS5yIPzNgj4ZKjUJHefOOFVADzyFnCQ==
X-Google-Smtp-Source: ABdhPJyJjX1YglqzJhvvFpLs8hNGBh+SSfnFt6AP22UOBLoSHqX6yu6LfxIB4yln42330u/EGAq+9Ic0ZJFeWdKVYe8=
X-Received: by 2002:a19:641b:: with SMTP id y27mr7657667lfb.74.1591460814960;
 Sat, 06 Jun 2020 09:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200605140252.542768750@linuxfoundation.org>
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Jun 2020 21:56:43 +0530
Message-ID: <CA+G9fYs8M4h-j+t4zypuTw+013F5vkvkAUxKu6iEwGHRxKC_4Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/38] 5.4.45-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Jun 2020 at 19:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.45-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 0e4e419d5fc3f776cc5ac829737dd6020f89f2a6
git describe: v5.4.44-39-g0e4e419d5fc3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.44-39-g0e4e419d5fc3

No regressions (compared to build v5.4.44)

No fixes (compared to build v5.4.44)

Ran 32219 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libgpiod
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
