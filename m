Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F64D619D
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 13:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiCKMdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 07:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiCKMdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 07:33:54 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326BF1B4036
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 04:32:51 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2dc242a79beso91150437b3.8
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 04:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5hFuaglE4yJS/5oL7Fadm33x6yDTEgxO3NGLZmSMlas=;
        b=eaeVIobJoYGtx7gbe7lEOsjNsTbSONKWDj49lPvnUK+1ZXlWRunUYLO3kMXFu6bFcg
         rSB3N88d9y2dEINu/eUR4PysWbp8/mtVHMU8wRL46fZD2Pz4SLRXihe8in5lGYUp1KmR
         e/71qXb/3iQ47/sy2vVHsApp7W0SuxmmAZWQre13LKrqLdq0Eh43oPVGQgamvDP1Y7YZ
         If+PRe5lx50nB7H3RAPaeXlzzQueVCZmIFv/6MQ0/nX47gXF/dZXytISCZShqW5MpYmk
         YJGHU8ahLLyKRiz6j5yRpI10hUVwhmlcYiNb4MZncrVhe3Gd2lvnbyGabuLe385aOO1/
         IGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5hFuaglE4yJS/5oL7Fadm33x6yDTEgxO3NGLZmSMlas=;
        b=IF2Tnv67FVueZUYoZEJGTgQ4sWq73nbnhPiQb9/DQVmVhs3K/n9XUL/mgDf7eJUm+/
         rx77U4ouWmBITnnWNpzbZqMOHK6tAuaU1FNwXn/RVIePNecEmkErU6rB//8Hyzf1DYL0
         sd6GEIKfq1EGj1v5NN2L5p/nHQt9gfNXCe0za/lpCYUkNjtbcUyfn3wNU96k4irZ1pLf
         fHlGX0sRnlmYkz/+GskHBUiLXgz2Pwq9E7iOAr0qzNW70r/MroDKJ8JAoRWvgdlwW8c7
         4iMgTxCUiqTVDtTiZjbxw+YfUELrEKu5qzvKsYad259NvyP9hhfGTElb1TWxoAQ1YlEt
         SSjA==
X-Gm-Message-State: AOAM532/XMLeiDg1zKiDqwRDiYPPgsenBuMG95OBZ/DC8CMKUV65NnVC
        R6BR4aQbvbxuRbmjw+BIVE2LVvNXuhRhysGo1azH1Q==
X-Google-Smtp-Source: ABdhPJwG4dl8qdGejVZv6hE+k7iCsMBcP8Ux1BkyXocAMe8OxyGXlE2FuxQ6s+lF7MrZA2iqzPjIHH4I3lYLqwrP6Hw=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr8227231ywm.60.1647001969840; Fri, 11
 Mar 2022 04:32:49 -0800 (PST)
MIME-Version: 1.0
References: <20220310140807.749164737@linuxfoundation.org>
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Mar 2022 18:02:38 +0530
Message-ID: <CA+G9fYta+cTAe=tMHJ65tpNoWx2QKVWh3=pafuSRe-h6gwEp0Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
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

On Thu, 10 Mar 2022 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.234-rc2.gz
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
* kernel: 4.19.234-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 7603caa5cc1196665ba06ded1f0a6f615eeaebf5
* git describe: v4.19.233-34-g7603caa5cc11
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.233-34-g7603caa5cc11

## Test Regressions (compared to v4.19.233-19-g83f8068e02bc)
No test regressions found.

## Metric Regressions (compared to v4.19.233-19-g83f8068e02bc)
No metric regressions found.

## Test Fixes (compared to v4.19.233-19-g83f8068e02bc)
No test fixes found.

## Metric Fixes (compared to v4.19.233-19-g83f8068e02bc)
No metric fixes found.

## Test result summary
total: 84857, pass: 68636, fail: 1023, skip: 13321, xfail: 1877

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
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
