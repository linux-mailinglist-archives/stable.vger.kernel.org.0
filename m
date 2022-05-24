Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94352532AC8
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 15:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiEXNFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 09:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiEXNFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 09:05:13 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B569156E
        for <stable@vger.kernel.org>; Tue, 24 May 2022 06:05:12 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2f83983782fso180836657b3.6
        for <stable@vger.kernel.org>; Tue, 24 May 2022 06:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=To11RlxqH6GZH9FPXLaskPjRkQ4yZEZUtKkrlfgzx5k=;
        b=SrW38l8zVhjzS5d1qhwscRSJD9CHrJ94L1YtUj2PSUrek8Q4I7M76lx9Tjp9YCIPin
         VnJpGJySVKfX9k4N75W/rAbbLF/042yIyXfK8RYxmqDIiIRyiAORoTWxM6TFGHrFrJmw
         tIJNmxS3MirfiFwahPq+Vpf9QSgaRKQ55w+ZNdrQfZEL+V6j+cnx6wJibhAXS4/CvwFF
         sVIx2a3XAHdN57woOVQkznef6tZO2/slDq8dQch0zZw3DhjIHCZVDRzkfmmTPLTXIeEL
         QBWka+mgfr1UEvo9+bEv7bYB2GH9yYBoTniOR8ixJ7/hJNQijQczQBTPjM67QqbmVrjs
         qJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=To11RlxqH6GZH9FPXLaskPjRkQ4yZEZUtKkrlfgzx5k=;
        b=Ha8uvKVh0Uzl4QUTV2F4216ZsQlJCgzkAXddAdUu2szgVeqww37L9hiy0myGIonrCB
         MC+dQM3JCRghDCtRvMzFp+6w6I5Q88h7QhAFmjA9AAYovR4ptZc0627td1ZeGwilnDao
         XGXLD2WX0WirQSoD03bsWxAbln7qIxTU7oTryb+M0nEAC6Osl7kMkf2On1Yo436D2Lgq
         HXP9yozoz03/+c5pHkrriS2zEWtLag8dIqb33CMz0EZ5NzcPV14iMsQrOOkE1XuCHy/U
         iD6v4F7k2C2k3rfVgkdf4+x2qkDOHTS9v+yQ4tve7dESatqs+GKveScw6jLTkuLLYepc
         N7mQ==
X-Gm-Message-State: AOAM531lv9/7/0pFEsz0O+jrxGqmx+0+tmtROeNByljHsswt03b8i8/t
        rpYZcSA4u2uPTQ7qlBc303P9yHTNyEmp8vIJE1W77w==
X-Google-Smtp-Source: ABdhPJywoisxT8mLcMdZ7yPKHGZUw3cETrNIIeg59RUrd4PF3W8NNkIwn9gPARS0L/KBaowMI2wfHaK7Kv3Fgmey1ds=
X-Received: by 2002:a81:442:0:b0:300:2add:cd21 with SMTP id
 63-20020a810442000000b003002addcd21mr2720910ywe.189.1653397511146; Tue, 24
 May 2022 06:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165743.398280407@linuxfoundation.org>
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 18:35:00 +0530
Message-ID: <CA+G9fYv_TYDmJZg8__NqAw-QDWo0jx-=4DwXG6N2xES2qP=iKA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
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

On Mon, 23 May 2022 at 22:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.316 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.316-rc1.gz
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
* kernel: 4.9.316-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: be4ec3e3faa1cfbe1ee62a6f6dc29c1b341a90f0
* git describe: v4.9.315-26-gbe4ec3e3faa1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
15-26-gbe4ec3e3faa1

## Test Regressions (compared to v4.9.315)
No test regressions found.

## Metric Regressions (compared to v4.9.315)
No metric regressions found.

## Test Fixes (compared to v4.9.315)
No test fixes found.

## Metric Fixes (compared to v4.9.315)
No metric fixes found.

## Test result summary
total: 72713, pass: 57877, fail: 683, skip: 11880, xfail: 2273

## Build Summary
* arm: 238 total, 238 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
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
* log-parser-boot
* log-parser-test
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
