Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9853B4B0DB8
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiBJMoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 07:44:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiBJMoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 07:44:55 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7221625DF
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 04:44:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id p5so14866318ybd.13
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 04:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=43xEOmAYjc4SMGg63vOu/s3s4PIfMCkr/BkAyskjsp4=;
        b=DdjeCauqy2Wk2by059XmPEUpWjiNgWODqg0RzE+6p1p2uptgiC03cKNn5Fd3AREbdm
         Ll8zKHTjwa0wXPSvyQv4HLKna7t6O7hzKL6A/kfpAaWINMI/BhgrGgbcX+P9iMCtW17T
         MfK2M1cZh39P/iQ6ImkNul41X1xXz5qI3TPBj7GOX/RzOmVQzbiX09DPnZowVDPM+0Qg
         Pg9N/403eSd8AiXTCckpAW/VlT2FXTtMGE/iWvX1b6j5jSsBNFTixxzuhtj+gRFvlA7M
         ie5hJJY2vp7fTJzbI9TAeyxu8QFs7W61AW8PspC/foTcPyQcWWcap8xq5qJwanCgPG3z
         LkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=43xEOmAYjc4SMGg63vOu/s3s4PIfMCkr/BkAyskjsp4=;
        b=nPopSjdFAudMsSMeViYHPFWCHdSrIvKeIu2BiMzWcxJ4FtFapry1VU3Eqd7ljiSifz
         mqltWpuVWQALhIL6JayKsrp/yJidBRoDq0JQai98wSKumkLy4E3UNINr1WqKIRIhvoE3
         s5f93nqqcwiPhZagJ/z4xd2qRw/+iYDgmFT7TimyuaqvAoyG7Zn0uquU6ib3P7AM9aJY
         1f+XI5VTVBVvtrOz4FXh/Jr5qo3eh+nuLiAG2TAuqH8in9lzanLNOmX73YIq6ZVGCwWP
         q4emWfo/mGXK6J6ANvkXxjyX5a5FbYcstkX217kezIN5DKQUJtRHptWjd/Dsh2p7ke1/
         3/Gg==
X-Gm-Message-State: AOAM533nxfJRZTO7zA+W5F9yWixlXQNX7OB6mXodbPeFH/zcB3O7FG0X
        MwbgzScy+XLLC7DNQLYd1jwprMzy+knvLyTbBLBc1A==
X-Google-Smtp-Source: ABdhPJwVVbJn1EPrxkqtw3SvW/41ZDLjZK7xYjXuww/RQ8URBIFL/Ba6adwSKOUKKyo4VgBCebGJ78SZ5DtC1OzmX24=
X-Received: by 2002:a81:a403:: with SMTP id b3mr6785321ywh.310.1644497095408;
 Thu, 10 Feb 2022 04:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20220209191248.892853405@linuxfoundation.org>
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 18:14:44 +0530
Message-ID: <CA+G9fYtrt=Me2pJUrmrSyQ664ALa-D=3EnzANCCOE1ytZhrrOQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
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

On Thu, 10 Feb 2022 at 00:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.100-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.100-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: f1b074cc52b4cb5f2f78985508ae344e6f066252
* git describe: v5.10.98-79-gf1b074cc52b4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.98-79-gf1b074cc52b4

## Test Regressions (compared to v5.10.98-75-g9f5cb871ceb9)
No test regressions found.

## Metric Regressions (compared to v5.10.98-75-g9f5cb871ceb9)
No metric regressions found.

## Test Fixes (compared to v5.10.98-75-g9f5cb871ceb9)
No test fixes found.

## Metric Fixes (compared to v5.10.98-75-g9f5cb871ceb9)
No metric fixes found.

## Test result summary
total: 76874, pass: 66765, fail: 223, skip: 9288, xfail: 598

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* kunit
* kvm-unit-tests
* libgpiod
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
