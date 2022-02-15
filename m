Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061C04B6964
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiBOKhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:37:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiBOKg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:36:58 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5A96D1A5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 02:36:47 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p5so54401402ybd.13
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 02:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4KTL35Bo4Fdy1NiVAS6uRnpi0byqJqzZzyqoX1d6AMs=;
        b=fE3z6ZYl6X4ABGnmSHSpwe0HwMl1WxtAS/2YGV2fOgHnRVHhIl6iyWYFGxrFTwEwSS
         8vcaYnYu2nsKDAxuwciBHoxnCfWgvXwyJgBXiBN8MjgYDOk8JCGXn31z8DqkanSBkX2K
         jzjmDL3gzxX2qnxdl+7Uh8p8zxjd2jTQzd1IGqYS0WyArr36aGrmIyJ69n/w5QjskDz4
         uIhe8H/grP8mPk5X1Fut0IW90JGPzQc7RV4v61TxUZQSUioteyVapWX4q0Hxb5kbGlsM
         JU5QG3enx40mpm9qX51XTwrAegajd4voE0I4txqO5FWk1A9f6IxYDvXwBn5pMieXuDZm
         GWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4KTL35Bo4Fdy1NiVAS6uRnpi0byqJqzZzyqoX1d6AMs=;
        b=BXnVtpY8qzBv8m5ZzN5lEdFpdDp5xvNbWBs/8j+D2Nvxcj0Ya1F2iewupnTxweuJKW
         kpCEw17MwPnhcEX0NMUAaXk6juePftAReyzjiFmgcqZBeZcHdOu2aGifQ8KHp5OhOJEe
         hCi7aC0/+R25bU7M83GjJq9RBsBYv+GlctzzJTnVkMBeH/f21JtFYC+jItlkhF3ILgm5
         GaYN/kJKyAUbgttqYRw1e8bfdcGsWGGVyjuv/epEhHqdtSPywDMrW7x4qcXt5A76KIeD
         8aTvXxICk6yXTGVxZAmABApAqE+DxC0G3nGK+lryMtxDt3DyVpwETdboHRSX0rtkuTVN
         IajQ==
X-Gm-Message-State: AOAM532OdHymsp+MoapXbpI0gux3JZ6xCE+bA01ILtnmzlPy4y4VsIoq
        qWV/iyrZhWV7dmmpiV8fZX97iF2Ui885Q8zBTKlIRA==
X-Google-Smtp-Source: ABdhPJzQVdNWMINzfp0BMtejmWzhKosM7Sbl6myl20Ydx3Ej4p2wfX6qPfsp9/ZfESlk+K8jsEzqEELiMpshJ2npgn0=
X-Received: by 2002:a05:6902:1201:: with SMTP id s1mr3337961ybu.704.1644921406275;
 Tue, 15 Feb 2022 02:36:46 -0800 (PST)
MIME-Version: 1.0
References: <20220214092445.946718557@linuxfoundation.org>
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 16:06:35 +0530
Message-ID: <CA+G9fYuswGGxTH7j17P69+zfx0TZMSjCU1pfQqU3kyxW7aNX0A@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 at 14:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.302-rc1.gz
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

## Build
* kernel: 4.9.302-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 133617288e03af9de3f241a342aa8d75164a2b46
* git describe: v4.9.301-35-g133617288e03
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
01-35-g133617288e03

## Test Regressions (compared to v4.9.301)
No test regressions found.

## Metric Regressions (compared to v4.9.301)
No metric regressions found.

## Test Fixes (compared to v4.9.301)
No test fixes found.

## Metric Fixes (compared to v4.9.301)
No metric fixes found.

## Test result summary
total: 58950, pass: 48443, fail: 310, skip: 9068, xfail: 1129

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 31 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-membarrier
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
