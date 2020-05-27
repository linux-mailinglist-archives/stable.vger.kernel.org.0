Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10A1E3BF7
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgE0IbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgE0IbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:31:01 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A011C061A0F
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:31:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z18so27824897lji.12
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AKqc+Sak0/1Unpb4rC7cN11riWtJQ2hXeIWL6LgMdSU=;
        b=ituUtednA03mm4qjbWeWVpF3Tyl/ePiX8eUEtZlFVdtpE0suIg6Eu4JmMIRg6QTelz
         vGj6i/yRgaIBMbu5ccETmf6Gr86kemoVmma+HRd/XqiYjJZOi7PFwNGQhMbHvaJJ+0DS
         ZYCxDETC3+yJNhz7c6f9SACDtu3O9B2gvhLBf+DiO/SsqCDDemCG4853s4xsYzF+rXBf
         Q1I4MeFe4VVDNWWjqdMQi5Bv8f20XOYdIMsBtYYTvsAZMp3yhWD1t4s1WuWBVJYQ/Uq4
         FaFcE/tBTv+1KDvuYXHbWvlXxw6rZYx/qJ4lLORpll3Jni1VrQz/LJng21MqsW0AOunN
         sUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AKqc+Sak0/1Unpb4rC7cN11riWtJQ2hXeIWL6LgMdSU=;
        b=P9Fkz5QHclIUiny+awQQHw9m2SyTJiOijfrq/QMkPW2ISQeLN6G4zExBlGvCHxbJLt
         R4BLMjC/M+20+RRsjibH5wguU9nd2nqb/XnZGm4+uRM86Iz/mjhuRmu/GXDf8aLwqY/p
         JnQ9GMK/jFS4UG/VlsXaKf9Vssap5KCs8MK+q2DQaMkPWS3vHqXE0X6O8s64A5AHyvSE
         oOW40ePQ+yKwC37ag06BvTX/1jOR5mVafV99YkBt4DHlBsjKyabtMwauD1qZDZ7cJjRZ
         3SGf9OD8VtYDOrQkfbD8gN67XrMTzTHoqCKIFWBp4zh6vLq0015SQLxkXk2qomJ2iy0N
         EUYw==
X-Gm-Message-State: AOAM533TrYPVf10EeKNZZGtdgEYZABM3NnfCAYPxNqPCSd0nTGSFFBlr
        t3kh8vU0bg9dSRPUWWns+tWPnUBG09Hu0kmT/c9r7g==
X-Google-Smtp-Source: ABdhPJx1Ns6B0WbfghucE7BlGuXzK4/57oaFdPf1BJdOyop3Rpv6tYr+tGtjxN1IY9RX1uk5PjwmgtRiSeT32kpWniA=
X-Received: by 2002:a2e:89d9:: with SMTP id c25mr2711833ljk.366.1590568259755;
 Wed, 27 May 2020 01:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200526183923.108515292@linuxfoundation.org>
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 May 2020 14:00:48 +0530
Message-ID: <CA+G9fYsM8rJhvW3TnLEq7aKgwouD7T1z5uQs2yeS1gUwWG-DQA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/81] 4.19.125-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 May 2020 at 00:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.125 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.125-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.125-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 59438eb2aa125985caa11179358001f38df0bc7e
git describe: v4.19.124-82-g59438eb2aa12
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.124-82-g59438eb2aa12


No regressions (compared to build v4.19.124)

No fixes (compared to build v4.19.124)

Ran 25492 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
