Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA5F3E38BD
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 06:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhHHE57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 00:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHHE54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 00:57:56 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA78DC061760
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 21:57:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bo19so129349edb.9
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 21:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BHHFo7Idw/9uaOjm2GZ570NChGXVkddZgvopJOV+1hQ=;
        b=BnbU+B8cpFnAZgZb0EZJ21MS21ooiFg2zawpKGQhgpnG+wL5R513n9pjP15ZkMvQDq
         46i6FC2eCatptg3DE7UrEcHhzVOxoKNQxckG0GABAEBbEALi6D7OS1T1zOnrLy0stesO
         pc6y5+zdwHXKMXdUyMgOd89yd5nijYf1TZdp6vI++FaZ+y1hzQ2U+KGVn4CT6Lcq/kZt
         Stb4efXovniCs17bi3XyLlZMX2Deq5Rxe8OkFKthH5oJxXrc5ynfpAaiB5KgAwUAsOIx
         92OgW8boHQZG9wbPxij1xDek8x5Avj/knXxyHImPPRpzEQr3xVVQSVJKIhB7tGTjTy72
         OzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BHHFo7Idw/9uaOjm2GZ570NChGXVkddZgvopJOV+1hQ=;
        b=tmXDRvrrPibIO7Huq64LPaYB0xkZhKdMjmnti8O58cerdokKKy3DekRv9Gh/98KyXR
         7lxDLa2Wc+lT4yLwPhVCMq0Q07mScIAHYKxvbgMdup7uHyNaY3w6GBTAH6YEAYK+xLQe
         n1ppA4m0OurHRI7XLXGWBcicdOlA7NjO+s6SCgaOwujGmZ0Oui7O8QsQKxY2byjENsir
         v5uB+NOw6gJa9ww3AnIgkBdaORHpMe6rEH44LGVlp1jO0plwU4VGgZQLxUwpr8jn3dCW
         vapCzrKENQvs4yqSwYTVwEninFbZ/7i5dF6lactteLyKvjPif0+pZwZjaMjGWWN6iXbt
         j+cA==
X-Gm-Message-State: AOAM530Q8fA6HtSbKAFgi1scC31UpVJr7OORAaA0voTRCgfiFeAx6+nB
        xplm+Ay91rI7gQ1/psLYvhEkeqRvmY3NUW5g4yK3Yw==
X-Google-Smtp-Source: ABdhPJyPR5Ts0oEWNaZfz+B/eeTNUIButemnx+FzOuwRHmewEF0qFsimJ+clFLstUKI5se44rfUjLzcag0+pdEYPlUI=
X-Received: by 2002:a05:6402:b6e:: with SMTP id cb14mr21877512edb.239.1628398655111;
 Sat, 07 Aug 2021 21:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081110.511221879@linuxfoundation.org>
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 8 Aug 2021 10:27:23 +0530
Message-ID: <CA+G9fYsHx=ueQc5B7Ogku=m7_phkYxQ_AhM28AjJ0i+yFSTVeA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/11] 4.14.243-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 Aug 2021 at 13:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.243 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.243-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.243-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: d7decc4b25e5f95848a688261db9ff2d18604b39
* git describe: v4.14.242-12-gd7decc4b25e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.242-12-gd7decc4b25e5

## No regressions (compared to v4.14.242)

## No fixes (compared to v4.14.242)

## Test result summary
total: 64520, pass: 50896, fail: 677, skip: 11151, xfail: 1796

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
