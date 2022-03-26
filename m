Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57524E8166
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiCZO0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiCZO0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:26:01 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DD263D1
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 07:24:24 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id u103so18678732ybi.9
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 07:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nsd9yIj1njT8T81VQFH5FbJtkddxsthtwMm7eiUPmAk=;
        b=TBmaNVHDdEGroqXdWD1QFZPbmAAumrhvVIuQpohm28CjJmTWF+Q6dNXax7Ip+a7GW3
         ay3hwWASN38U4401KTRCurPuFnK/HskKAGRe+2BLCSPCZSavq8JfrnJJG06pOXCpyNi7
         1eiNKc0vgp0jYJPQWMDJCuLWhQ77RXafj0Ycya1mwP+rAWxGffCAGpoxHh8K4Qvti2mf
         qm+nQJNmzi2SvYqQQosujfd0nzWzlqsZgHb036UFE4Nh3i3nLyRj8vjUYyj1OukyYXBT
         hzSwqvFQG2YhALnWc1c19fGv3YiFepLIdjGVk+jvH4q6SRhr++c+PdKMAbNPwGMaAtGo
         EUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nsd9yIj1njT8T81VQFH5FbJtkddxsthtwMm7eiUPmAk=;
        b=Xq6oY6hylnsUvl2mAL2kMLzJFyGNKR+IanyyrSHROEbarfZQx0GwdV3V70j9pOLV62
         6zba+fzShKkbfZnYfWOMN7En6oTvKAL8qN12Q954xj3N4LzR+6YAFT0kLS/vZj7B2u3C
         cieDk7b0q1s9ZroJ1IO3gxoeYavstLmoD9hvUx7N7/U0ZzXCFoiv8CbP/0pRxTJPuHW+
         0rkpdOCszqGLuCD6z7gccRKBqgdxqj8m9agYJNrwjSFESkSOphUKIHpJZNoJo4s/lEOI
         bKeRhkJU7ZjkKWeGQOn9JasokoaXvf2s7VxYUytDipp51HqRMeNOc3f/6/O1vE6ce0xM
         SYNg==
X-Gm-Message-State: AOAM530fUr2BwOg43iMOxwPxYpieduUrS3ogdbzH+sdZ2IuI6FnP5dF9
        b/RUhfF+ns67EAHEOW9d1eGFEo+d4BIuW85LC/oyTw==
X-Google-Smtp-Source: ABdhPJwXCAmIiZyiFlvW4ctqK9cr9f8LOvWIMbg4ixgtIWEmsG03wQmbmXowVufblsJLdHGbxkug2rlY4HK7RW7bS50=
X-Received: by 2002:a25:42c9:0:b0:634:1a46:e5c1 with SMTP id
 p192-20020a2542c9000000b006341a46e5c1mr15757173yba.474.1648304663867; Sat, 26
 Mar 2022 07:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150417.010265747@linuxfoundation.org>
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 19:54:12 +0530
Message-ID: <CA+G9fYtzUJLWFKjfe+vJMbjPV2jfThUr6vqFMb19B9om0MBSQQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/20] 4.19.237-rc1 review
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

On Fri, 25 Mar 2022 at 20:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.237 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.237-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.237-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 3a6a2212011395b420629a2d46310bd935d18c76
* git describe: v4.19.236-21-g3a6a22120113
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.236-21-g3a6a22120113

## Test Regressions (compared to v4.19.234-31-g4a3043563aa9)
No test regressions found.

## Metric Regressions (compared to v4.19.234-31-g4a3043563aa9)
No metric regressions found.

## Test Fixes (compared to v4.19.234-31-g4a3043563aa9)
No test fixes found.

## Metric Fixes (compared to v4.19.234-31-g4a3043563aa9)
No metric fixes found.

## Test result summary
total: 84118, pass: 67440, fail: 1087, skip: 13378, xfail: 2213

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
