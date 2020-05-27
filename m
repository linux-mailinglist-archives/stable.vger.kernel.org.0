Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8273D1E3CAC
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388249AbgE0IxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388113AbgE0IxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:53:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB1CC061A0F
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:53:06 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z18so27900087lji.12
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VMYivybFR3qZWswQd+4Hh00wgkOlInWhi0WpQgvu6k8=;
        b=Zv10UTO9QZf5MGO5WdogeLLqk0XLrBiu9u3HsCrO64WQ+KezlTbigGnhN5oDs+qjv8
         9gU8XZFaiD+ewGxHa2IeSCW+4JgleH/Ztvv8Et/TuEHn9zFsRwZP6CDej6JUHpxexaxs
         dHCYEhboBG86Nk22CdHzEeKg3/piogfA6xLLLmmqzZ3Eois+AhP2xdvk3hHBMycrxUKZ
         3qSsCgoroLKbhrhBJy6aZ3sHm47OnEC9/RYfycB7b9SDyW4lK2aEDsz2NfdqDfBSQ+nG
         tofQWOjFsnuf6njdOHl//svyuApUdwWBu3UluN8b6dQw/CZ+wczbwIXt6m5Wl56upN4O
         YheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VMYivybFR3qZWswQd+4Hh00wgkOlInWhi0WpQgvu6k8=;
        b=jQpnOERa4HrGG3oU+9iQDULPr973hYjYuUzgmeYDvjsNn3cJ1Iqw/GUJ3ytt05RAaK
         bnvv+KU+DrmRVgQ8QaipZY/d/LrBqSLiXttleZ9Al0N/mLSq15NmPfWesDczkGZUINVk
         WMNs+kqzGDK4cbfffhpwhPJ1+PsN8S5M6s9RXV0emys36CAQ5gCEXN9dh2MrlF7Q8tFO
         mbWC707mbQRpPB+B6I/lmI0mDy/xepS1/PvFTm7gR0676kEnSOgnviU/ypqazckkz573
         LIJISYWMnhZwiHgLTIpDrbuxCB+LouMQ7PO3yoFBqgZvoEa0YnTcIVeAs6U/QxhPPeaX
         KsQw==
X-Gm-Message-State: AOAM533DITH2Ecd2PhGtUlVzH71J/2OtHdkbgBL+JDm455Xvf59Sp+hJ
        mhMxWNRXhIYYPaWfa35qp8XRSduhjSf0/ioKX6Q8xnB10YF4ig==
X-Google-Smtp-Source: ABdhPJwwTJHa3rqeb8/G4wh2gtOFICQYxsYQiW2iM0wlhShazA9cZNim2OfJfYJQtgWFcSO0zM5ba/upU8fGpFSO1Pc=
X-Received: by 2002:a2e:89d9:: with SMTP id c25mr2754030ljk.366.1590569585048;
 Wed, 27 May 2020 01:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200526183905.988782958@linuxfoundation.org>
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 May 2020 14:22:53 +0530
Message-ID: <CA+G9fYtqoHXXWq9+jb6-nN5Jvj7x8dryYK6ehTC2+8TRxCWsag@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/65] 4.4.225-rc1 review
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

On Wed, 27 May 2020 at 00:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.225 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.225-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.225-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 147ece171c0dc02b417f35088182a61e6dac368a
git describe: v4.4.224-66-g147ece171c0d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.224-66-g147ece171c0d

No regressions (compared to build v4.4.224)

No fixes (compared to build v4.4.224)

Ran 15012 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems

Summary
------------------------------------------------------------------------

kernel: 4.4.225-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.225-rc1-hikey-20200526-731
git commit: f578d6e82f6756e9b9385131e4bef87a9fe5483f
git describe: 4.4.225-rc1-hikey-20200526-731
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.225-rc1-hikey-20200526-731

No regressions (compared to build 4.4.225-rc1-hikey-20200525-730)

No fixes (compared to build 4.4.225-rc1-hikey-20200525-730)

Ran 305 total tests in the following environments and test suites.

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
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* spectre-meltdown-checker-test

--=20
Linaro LKFT
https://lkft.linaro.org
