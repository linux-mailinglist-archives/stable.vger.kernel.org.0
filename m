Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5B451B5EF
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbiEECcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbiEECcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:32:09 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E34240A4
        for <stable@vger.kernel.org>; Wed,  4 May 2022 19:28:31 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2ef5380669cso34691967b3.9
        for <stable@vger.kernel.org>; Wed, 04 May 2022 19:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ymlQRBpbYvXfEl3HIzC/QEtILJ6ojNtKv+z7A5wo/TI=;
        b=U242DbqhzCK4g4VSNlslMqq5Fqo4ervJvNF0hvQnQrOZ/O1TJV3KZo/+kDs+wpgXEG
         95shw2d3u2JWAL4Tsethn+pYTshHBtdWcNp/r28P2LNIZEqnTXuGh1F93kRkHbz0Kh07
         8+1HePMQGrfJ6QT9a8DdXgmZ4hLnE8AnafRc/D+Dt93c9+LUimH96SNRks3/6MK/rMNX
         AHgNFXhFihCdjOnEjX8eto80htaPKJX/DpMch5PLCiUdq1A9M+WriFQ08RBO11cjq0E2
         PwKRhaRJThoHmo2iP8FfGaFO+YRPw96RW80SUrsB3uCwJWsuHGKxq9Qj4a9m5+Aqd1Wl
         wdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ymlQRBpbYvXfEl3HIzC/QEtILJ6ojNtKv+z7A5wo/TI=;
        b=yOAxApCyKwXH9Wkz+mb95gKPyp4d7lAby/VuJjUPx6Hs7mE60WTcigbcbP9LhUhJIn
         s3iefNJLXFffWGIm1Orkyg9mrod958U6dVjaUkdLbHJG8cfia4QZEmFXKV/s9+e/kbzn
         00bZXZMWZorzfyKNPx3c+fIERWGtjbAkefpmyR70H2viv2Zdte7M7+hDRnNvnp6D9L+C
         qvy+oT2K9i7CUsC0FdTFzYJROxIHc8briTkV1mRq0VXlXppI/SlNxLHrey5LjVFYzuGE
         AKZ0K/dIDTvhtPhW6vbFoXYYynlxupwbycaPizXs8lV+VY3BpmqYtxybJoN2B87ZSZhN
         Lbng==
X-Gm-Message-State: AOAM531v6XAv5Rssq5Eb5+iJiyB4426NEbnkXbLhvxsh1/k3i434Jyvx
        r9mLYTGBiXtatd/o4A7CkY0Ik213WCas3dqwDcZGFw==
X-Google-Smtp-Source: ABdhPJxHFZWderjdQXAMhlRBz+1miG2x5VRcuiynmyoG5x4/Y6U0iKwvFR1JGJS2lb9GEQh9Md8FyqpXZLPt/+691sk=
X-Received: by 2002:a81:23ce:0:b0:2f8:ad74:1185 with SMTP id
 j197-20020a8123ce000000b002f8ad741185mr22174840ywj.120.1651717710328; Wed, 04
 May 2022 19:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220504153110.096069935@linuxfoundation.org>
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 May 2022 07:58:19 +0530
Message-ID: <CA+G9fYufCiCBuY4qDSnbdzDpwtMZpX96ROC8iYNvpO1w2=mxHA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
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

On Wed, 4 May 2022 at 22:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.6 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.6-rc1.gz
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

NOTE:
Following deadlock warning noticed on stable rc 5.17.6-rc1 kernel.
This has been reported 3days back on mainline kernel [1]
Please find full log details [2] & [3].

[   11.893309] remoteproc remoteproc1: Direct firmware load for
qcom/sdm845/cdsp.mbn failed with error -2
[   11.896749]        CPU0
[   11.896752]        ----
[   11.896753]   lock(&irq_desc_lock_class);
[   11.896759]   lock(&irq_desc_lock_class);
[   11.896764]
[   11.896764]  *** DEADLOCK ***


## Build
* kernel: 5.17.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: d7a9320891735782606dab06b81711f1ea6fdff6
* git describe: v5.17.5-226-gd7a932089173
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.5-226-gd7a932089173

## Test Regressions (compared to v5.17.5-2-gb59a5f68feee)
No test regressions found.

## Metric Regressions (compared to v5.17.5-2-gb59a5f68feee)
No metric regressions found.

## Test Fixes (compared to v5.17.5-2-gb59a5f68feee)
No test fixes found.

## Metric Fixes (compared to v5.17.5-2-gb59a5f68feee)
No metric fixes found.

## Test result summary
total: 104616, pass: 88616, fail: 743, skip: 14152, xfail: 1105

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* 1[
* fwts
* igt-gpu-tools
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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
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
* prep-inline/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso


Upstream reported link,
[1] https://lore.kernel.org/all/CA+G9fYuBNB+iuVLFG4t-=3D5fsRsPdeXSSafkQECf3=
53VxikmW-w@mail.gmail.com/

Full test link:
[2] https://lkft.validation.linaro.org/scheduler/job/4989879#L3314
[3] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v=
5.17.5-226-gd7a932089173/testrun/9354932/suite/linux-log-parser/test/check-=
kernel-warning-4989879/log


--
Linaro LKFT
https://lkft.linaro.org
