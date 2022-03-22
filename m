Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8004C4E4310
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiCVPeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 11:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiCVPeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 11:34:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846268BF10
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:32:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o5so34331337ybe.2
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tqDPM5RlgpXSQi1Ee2XnXishFimAHDqmADlb12IdHGI=;
        b=yeTDYvrn200X+80eXdUJtJ1yM+FmFqDC2clNaFSxGxu/DPOvhJCpKD6uZvWu9DUeHf
         j4EQLVr6R0+9uVHTaxUYz1bMwnmDIjkQPO/r5TVYMIyZo7FKNYThRrL6VM12mQBkVdjF
         WQKrbiD1YuwAntBEWGAgziO/yMAYWAH+3gEhBcb3hov7lHGniKWPh0LHSTUkHRQ9IL16
         o1ypIQo3iF0XwRnEfxI5Lllqinm89HNPTKNjopuXLTJe5jQM+i2BzbGg/j9tXD/SZhot
         Zh+jycNEhJhiNBYZKZ3a0Wmx5ozxn4oznybrTRmlYXlLmhrXYRYodHRvCVRSvUwnX7FO
         admA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tqDPM5RlgpXSQi1Ee2XnXishFimAHDqmADlb12IdHGI=;
        b=11qQ8bktUQxcRvcElT+Osrq587RwTJggyjmiABxRbocm+zXUWroUe7QRhxW/yJSesz
         yJF54lkNKSHPYeslwYcDf+LmY5JT6MzmS1EtcHWCch9lf5bzTTMEXmtI1QNjyTvhmyT7
         cdU9HEWXSU641imeQBkgdFSAJo/mBstHl6fUgwKlQtW6MNEhkPiT/ExFbm8u6/zwx/I/
         oeXA83LtCZ/AGQXPbzNpowoVd2L/I4BvPkFoxfGaoSTe+/SqmGX1ovn4kag6BgwWibF9
         8yhTj8U+ljsukP6MtCn6a8tU/O/MdnRTD8C22FPXqWsF0O8rfKNR/pF04aNir/FZoA0y
         X0ZA==
X-Gm-Message-State: AOAM5332tJ2BroB/UYPh0yaQtioaj1FbJdvaBNS37jxD8DFGy+mrPexu
        bj7vuKsaxCqk+eLaUz3e40X5ZH58UJowQx8AeasUGw==
X-Google-Smtp-Source: ABdhPJx/oh3K4UCmXLO5BuBjsTgL2X9Ol2SqzDRFLnaCkRwITbus2a6io3xJ6+SrfhNofe6YIZWMU/q2CVjkezGEOeY=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr27461840ybo.537.1647963172547; Tue, 22
 Mar 2022 08:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133216.648316863@linuxfoundation.org>
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Mar 2022 21:02:41 +0530
Message-ID: <CA+G9fYvNXydpNH_oymBx3PHbVu=_HtqSCOrF-x0usPSpWJcJdQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/16] 4.9.308-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Mar 2022 at 19:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.308 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.308-rc1.gz
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
* kernel: 4.9.308-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 9edf1c247ba23173e6a105911ccdd3491f0f1a7e
* git describe: v4.9.307-17-g9edf1c247ba2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
07-17-g9edf1c247ba2

## Test Regressions (compared to v4.9.307-12-g907431a01b50)
No test regressions found.

## Metric Regressions (compared to v4.9.307-12-g907431a01b50)
No metric regressions found.

## Test Fixes (compared to v4.9.307-12-g907431a01b50)
No test fixes found.

## Metric Fixes (compared to v4.9.307-12-g907431a01b50)
No metric fixes found.

## Test result summary
total: 51902, pass: 42014, fail: 393, skip: 8470, xfail: 1025

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 18 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* kselftest-android
* kselftest-arm64
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
