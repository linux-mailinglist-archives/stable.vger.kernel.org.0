Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E5853D7ED
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiFDQpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 12:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiFDQpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 12:45:31 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26216BF59
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 09:45:28 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-30c143c41e5so109026997b3.3
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 09:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U0qwO/5RprU3Fxj4TQpkXAVK+0NlaHVF2GigE5WcPeQ=;
        b=MU24J+I84fiGjUY/ZdEMEqhjb5Apx8zdDSo+zCbyHmo05+ck8mobRMROr6tX8S+tdu
         RsS+lB5EmPOiqk0BV0avfSbUEVoCc0B2JD42g5siR6fjuxlPQdj82R095qz246FTKocu
         m2/MIX0nIqwwHaUWV61riH+gQXrYi503myTf0J/08XTjCOplvpOsOw5BbBgcONrk0tTC
         d2C5CWcPcjUEGykM0PRnmW9Peplw/iTaGiPfi7361BQA8ypeISDn0koFyfpl8r4zqlg4
         Xsy+cmSP81Ijpk3MyKeSbeihKjvqpVNyqxHpby0GcM0d3Mz0cCm/8lDembON7qqTmTdP
         F8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U0qwO/5RprU3Fxj4TQpkXAVK+0NlaHVF2GigE5WcPeQ=;
        b=K1zH3vYXydzjjKfiXHf7w1DR1OD5itOTyRRZAOSz4Etgcrpv2yF5a8s6LIxOlxgVHK
         6GFc+bxvxMYSSsogVR7lWrHx6eb5cCwoi+HgzR1k7sdW+Z6CjtQtafpK4OG95yXrOqnP
         Kwvj1B4TezWKDUmGTW/o/Ez9wZnOwOQ3IbbUtZZJs0r79+7tNzAO497IIJU+4gRhFSEc
         j5C/JcEn5EI+0TqXPLZ9ZxQf0uTOJiSIrlO/trun941CUErhakLCZS+KHI3x8V0P+9pt
         iHIlNXlmHiP1iLCTMkEBmoM5RKQwkJ5HxKwb+i+TEXYwQ1v1lwDvBlYKeWhWI27LcALZ
         T2Hg==
X-Gm-Message-State: AOAM532IBfkyincPCBBmFXlNvypYO87NJ1lQtL/B86PPI9aJWQZivR/n
        LbJw6tX41v4asYHKW974DjAei1gxzL0j83+W687s/w==
X-Google-Smtp-Source: ABdhPJxshDtlaeVVnmpjUpmce0jsCL3P/y9FYUMU+kxVMn8FJTEzWdsTAsf7GFP4LD4DT4ohTi/YGExC3u1O6QpUS/o=
X-Received: by 2002:a81:b343:0:b0:300:4822:e12 with SMTP id
 r64-20020a81b343000000b0030048220e12mr17638910ywh.376.1654361127256; Sat, 04
 Jun 2022 09:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220603173820.731531504@linuxfoundation.org>
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Jun 2022 22:15:16 +0530
Message-ID: <CA+G9fYsQ5732BSH83s=KcfNYooqSAV82BoUS9CYg5P2CSc+DMg@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
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

On Fri, 3 Jun 2022 at 23:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 20fa00749a26c2347ca02a2eb231d61ecd877c90
* git describe: v5.18-116-g20fa00749a26
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
-116-g20fa00749a26

## Test Regressions (compared to v5.18-48-g10e6e3d47333)
No test regressions found.

## Metric Regressions (compared to v5.18-48-g10e6e3d47333)
No metric regressions found.

## Test Fixes (compared to v5.18-48-g10e6e3d47333)
No test fixes found.

## Metric Fixes (compared to v5.18-48-g10e6e3d47333)
No metric fixes found.

## Test result summary
total: 132732, pass: 121296, fail: 1353, skip: 10083, xfail: 0

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 313 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
* kunit/15
* kunit/261
* kunit/3
* kunit/427
* kunit/90
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
