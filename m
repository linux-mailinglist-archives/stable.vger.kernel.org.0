Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F324E527260
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiENPHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiENPHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 11:07:00 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C799762E6
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:06:57 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v59so20039917ybi.12
        for <stable@vger.kernel.org>; Sat, 14 May 2022 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8bgbRvm58+qrdPjIs9kk4ClZICHs5MASc7rQ6VCmXcs=;
        b=lTZs+suBBLjkYFQ4cCx3P3HeR86S0Y2RhD0U6jQQQItDfTbLpeIaGvjLpNWdMzIm3Q
         0NTaaJz3CPU1mp5ITGf9+sgHIX9pRXZHeS0BLd3Ad7twZceqYksJv+VLhOckxFdEoNZ8
         q8uqiV71r2/NxWAWq8ZyjjLner1NWqiFvRCzN2drfE8xFqlsXo38Xdt5osJvWZp/sOLQ
         XabsDFPqBfVez+mZs5N6aTrQH5nKI4x0mtqzbt2K+hEaVal/zHWOzWlBgyts0LxxSkYP
         nyBtj5ycG2gEAMy/aCGhjmgstPBsd4bjq9xyRaJibFfvmjxy+EiRR08Cm+doQ1v7Vy3U
         z75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8bgbRvm58+qrdPjIs9kk4ClZICHs5MASc7rQ6VCmXcs=;
        b=ccv6vzuKA/iDeVmEvdUsmjrWcM3nreXfwaYBroqV98/we9MkB+LxtvBJ4vWbVOxnHo
         gsPMmS/3p1tYoStTEpS089Qn5eKNRWa5qbjHffxATViQMikdy7l9gYeb7xvmk7VWPB+V
         y7zpmGtJClUFsN3kEgtPc0oGCUTLYK+bfRC5cr6RzQFwoE/hKvQicjqCu2afha4wIQsJ
         fIDbsAdxp9y8/DwshF/GfIrGUgrFcOOPLlv0h3NDFRKHpBI4k2eYg1wWk2cusKheWMOr
         8YLDhf9o8kxgZpWdr/B4xEq3KG/0yKSkBRC68q/z+ksH7r0YrvQ/C7mXuGr9yBrYdv86
         aTgw==
X-Gm-Message-State: AOAM532tmFLJXUaSLOqLeZ9NNlAyiBQ+b2gIUA10ugAGw5dimk7yvfvY
        Y8hUxIVtYA1NM9+44HyM8yTJbvdNQjjHx71XIDtj0g==
X-Google-Smtp-Source: ABdhPJzmR95yLZDUNsPxVkwvA1a1rWFjuGCzjE6DA7sNhY4KC0mUAIhHUi9jNbLbIdJi6AQxGrJGIW4vq1r/DA7U+fQ=
X-Received: by 2002:a25:d187:0:b0:64d:7735:cda2 with SMTP id
 i129-20020a25d187000000b0064d7735cda2mr848452ybg.474.1652540816855; Sat, 14
 May 2022 08:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142227.897535454@linuxfoundation.org>
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 20:36:45 +0530
Message-ID: <CA+G9fYuhwLTj=VOQCjh-NuQmtFOvgeTWsCzEp=U0y6qsG=+2bw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/15] 4.19.243-rc1 review
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

On Fri, 13 May 2022 at 19:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.243 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.243-rc1.gz
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
* kernel: 4.19.243-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: a96b764d90b5b33d8b7817d4e0da1ea730cc208d
* git describe: v4.19.242-16-ga96b764d90b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.242-16-ga96b764d90b5

## Test Regressions (compared to v4.19.241-79-ge28b1117a7ab)
No test regressions found.

## Metric Regressions (compared to v4.19.241-79-ge28b1117a7ab)
No metric regressions found.

## Test Fixes (compared to v4.19.241-79-ge28b1117a7ab)
No test fixes found.

## Metric Fixes (compared to v4.19.241-79-ge28b1117a7ab)
No metric fixes found.

## Test result summary
total: 84228, pass: 67603, fail: 1113, skip: 13402, xfail: 2110

## Build Summary
* arm: 275 total, 275 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
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
