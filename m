Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE124FEDBF
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 05:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiDMDtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 23:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiDMDtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 23:49:19 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8478366B7
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 20:46:58 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2db2add4516so9164137b3.1
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 20:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cqaAPEMX7LYW6wg5ZfwQLTI8+xvUDectbkA1gAskbOw=;
        b=nvveBPlHiygWMrmuD+JYJ8gKsLnG6urrHeGrSt9Lt+BK4uwpMw7fqsC6eg1hEDY/eC
         7pAwppHWjNptm6l8jtsgrJtzCteM87WmpRp9/GRB+JZoyodsTOG3DfeAwlaHMdKNWSUj
         96pTQD5JlefglpsdnRNTokJNErGlhFK3HH6fEweA6hgc05QSKfAOnv+4kyXBwqwEWyXf
         LbBwQupTyPKVn6OGDEXrBqwXCqx24jDyv7QAzCPTP2sriTpqad5V3YdVCsjNHU3dP71K
         Te19LfVpvynk5KWUR2uTxJtz3SAaLyrNBcwILf8LQCpnyTZRvpkKt6MZupiOgwme9LeD
         VlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cqaAPEMX7LYW6wg5ZfwQLTI8+xvUDectbkA1gAskbOw=;
        b=HK32jtC3Ctg5KWmPf5uZRo1WmSHcouiraoCsMCFrngy0pxuBKzk81K0G9DqftzacWi
         BD02RuDuxW2/QoC8KuFHdshvFOvIcsG/o5qMhhlfLAQFD6QhTSx91l6gPEVCjmTYLHF9
         OhlJ5sVCU775rz9upKRFrSVjkm9ivvG9jNPUKCYN98O4r1BhjowImDVOBztEfzfletTR
         jRhwpHwaAdin/jnqAv41xmcq4nfrvBgS5hrgjmBEgKiO/qctqhD9m0dBnQ1HxclXf9AS
         bpL3hmeTjlQAXkCXknNhJicCYPQuCulOctWQvhHhveHdQBhFjTTpAF8zVeySBJEATL5u
         f0JA==
X-Gm-Message-State: AOAM5328AOWXVIskwKfW+3J71erWFIv6Hox8xS2ULd5ODYVjMveNSBGJ
        ofXGF04cbDQ2gZgpUTi3cbqO2m33qhd3NnEI+hb35A==
X-Google-Smtp-Source: ABdhPJy7+cF/HmAxm+sJ/582idxx0wjCJIqCVhknhj4LI9bhT556p0NrH7O3Y16Jmqp+fIL2PgsKbwZaeKHll1cvz4s=
X-Received: by 2002:a81:bf51:0:b0:2ef:414a:f03b with SMTP id
 s17-20020a81bf51000000b002ef414af03bmr2271421ywk.199.1649821617761; Tue, 12
 Apr 2022 20:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062951.095765152@linuxfoundation.org>
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Apr 2022 09:16:46 +0530
Message-ID: <CA+G9fYvOaEoq6tR5O4rLW=dfPv5MDOK-Qgy+H3cJSPsBWMwaWQ@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
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

On Tue, 12 Apr 2022 at 12:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.3-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.17.y
* git commit: 66349d151ef98c411fbfe080a4e9c646dc41eca8
* git describe: v5.17.2-344-g66349d151ef9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.2-344-g66349d151ef9

## Test Regressions (compared to v5.17.2-340-ge5a51d774e89)
No test regressions found.

## Metric Regressions (compared to v5.17.2-340-ge5a51d774e89)
No metric regressions found.

## Test Fixes (compared to v5.17.2-340-ge5a51d774e89)
No test fixes found.

## Metric Fixes (compared to v5.17.2-340-ge5a51d774e89)
No metric fixes found.

## Test result summary
total: 100152, pass: 85962, fail: 732, skip: 12550, xfail: 908

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 46 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 26 passed, 6 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
