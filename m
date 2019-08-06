Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF9882CB8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 09:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfHFH0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 03:26:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34818 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731711AbfHFH0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 03:26:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id p197so60159973lfa.2
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 00:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RwJqQDsRZ9AaLr/ekC9Gdx1vhurMfbMK5qMIFyjdmMY=;
        b=HkHWeHbeFUjBWyDvZUKxfFH/WkeH9dkUS16Y5GRnBi91t54nMbVt/XorG/JXWA5jZJ
         wv+hU6jBYyJN9xQ7qSqsopUw/vFHMrdRD1cLx4l91coySp/zMd/MnmN0UmtLRKykM0rF
         YdIWhEyurVbfV+9tIpH9dpxK22vM77eZZuLl5biNjJKFM+VBPfS0/l3m6C0X6+1lLl1q
         F+tHsOeqwfnFw3jv2GJ7FzfTfrIEcaNA4yEclC038TBckWjvRjK0bV2wdjey/rtobNnv
         TmGR7hZ3tngqlGETH0zEKPgyNOJmDaUbn1CIdFR5E/QZMXgF/kaZ4CX78i0t40y3ak3B
         KAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RwJqQDsRZ9AaLr/ekC9Gdx1vhurMfbMK5qMIFyjdmMY=;
        b=ESKpbU4EJt/i6viIx1WJGDWKeX4rNl9RQBg9K09DErSm+tZv+XdgvRNKn8YppXVwds
         2YbtvcX7gNhxvX2V9F3gSDZ5IAlhRqVEG3+3Wu/NRQYM1N6us9IBjiT2qS6ClxYjk+sr
         Eg96KqgU7lDw7tlHx5SBLVo4OJMh7vZX4IcpS2ViGKxWW8fO4mzFYllXoyerzyYWdLoD
         6blOMe2gwLR8MBatRtyp0UNGURRPTATpTW8Q+Ht6PBJ62jGtukwe8ynZrci8OO5lDXqr
         /WDU1Gv/V0U0nZ3Mah55PhKawPq3SUNmcau9s79DQkDtlWtnK36F+Rbg3wA7q8yjeS+O
         Y0GA==
X-Gm-Message-State: APjAAAVtraN39yyvjgq0ive6MjU8ZmxHv9nUurVe7uJ7SOR1hXPXiZ3D
        jQ2sC2YV9mps7Ztdl9S+7I80J3/JCBQWCb7tYvJbEw==
X-Google-Smtp-Source: APXvYqxNSUUlWAzx8oictpwRYd8Zg+c7SEIFsrenLoLlTH9vDkh63cTnmW1jbAgbNgPTEOHbkG3/J8Cj5I115SVc55U=
X-Received: by 2002:a19:5f0f:: with SMTP id t15mr1409306lfb.67.1565076394740;
 Tue, 06 Aug 2019 00:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124918.070468681@linuxfoundation.org>
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Aug 2019 12:56:23 +0530
Message-ID: <CA+G9fYvhTQfV=gOVeqtNax9sgmRVUexWAwkBcorEG3PqShGXsw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/22] 4.4.188-stable review
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

On Mon, 5 Aug 2019 at 18:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.188 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.188-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.188-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 462a4b2bd3bfaa6e11d1e8180bc95324efc96390
git describe: v4.4.187-23-g462a4b2bd3bf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.187-23-g462a4b2bd3bf


No regressions (compared to build v4.4.187)


No fixes (compared to build v4.4.187)

Ran 20069 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
* libhugetlbfs
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.188-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.188-rc1-hikey-20190805-520
git commit: c9b6c3a54493f03773243bfd3c3ffbc88982ec27
git describe: 4.4.188-rc1-hikey-20190805-520
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.188-rc1-hikey-20190805-520


No regressions (compared to build 4.4.187-rc2-hikey-20190802-517)


No fixes (compared to build 4.4.187-rc2-hikey-20190802-517)

Ran 1550 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
