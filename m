Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3544F4C9082
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbiCAQiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiCAQiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:38:08 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C930C47046
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:37:26 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2d07ae0b1c4so150811907b3.11
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HXHGLPLtJRYzjv6GySuP5dGmNicFN4UpBZOGFq6UpJ4=;
        b=o6wRjxVDReOpmpWTDLYS5JsU4T1jJyPUCbmUFEvt587Yp/bGuKvDeypREjE7RHhUiC
         vcVMX8ZBItn93oYEpzI7TpbQFudx8Vj3lpXBr83Ws7GfgQCTcvQ0RkTcm+yZkQgJ6yKE
         g3HEkCiCKxf7kN5Y9GT8GfWLc15Y/FFVBk7kwHOQSqn9SnARxxgoEZ6mXOtnyCeR3Fql
         im1hyAKLlGjKvxqqKdhy2nhleakAtssezMJPeMJUBoqQcHiXIK0THW0mDJaU3T2sXHea
         N2BEdLOBPha/U32zMWEVzNuJKnkelg7eB0E+niO1NvUPlfNbrCrxpNSr/ukPmgpOxtcF
         TE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HXHGLPLtJRYzjv6GySuP5dGmNicFN4UpBZOGFq6UpJ4=;
        b=508WibDQn50TKL44qZrhxWi3u1Iv5s1eCzTscRJfkSQO1oSSyVB9jj8x+niQ+X8XIp
         Pc2betKN3jJ8O/apbnTnbaHwbX3vHq5rJdKtFIAyp1n3ZQe0MW4NN0GCHZFSPcifhkab
         ts5wSIov5WEnIxv8IEayF0+vJCr9GgWdpCtOWSmuZi4x01gMdAGaK5B2gBwQivvFA1So
         Fm7+lhx+9Nqa96dYN+rmTKP2t0kawiaauHsY0k4nZlE7SffujwO/4MIRaaom6SatUo7L
         jVmqXk2tR3IJeFmOXE/KyDcAU5dpkf3IJSKrfW9vJYvBbkTOryn7ZD2UVLDTy6uHZ1+u
         MiDA==
X-Gm-Message-State: AOAM531VF+5wsklYkyR+p7W//cb10asP+6UEQV/WlldJloTGwxR+VQmw
        I0ScWMavwkylJqxJr3txPpBCy8DKVXq1ovJ742enSQ==
X-Google-Smtp-Source: ABdhPJwD/CrTkuqxdqpnyMbKcMWQbQMe61UiZ/DvsEd5/UZrtCbcZx/Gb0RQsU8nZLCtdqz6fItOUA055qNfu6ZPqHA=
X-Received: by 2002:a81:2f12:0:b0:2d7:d366:164a with SMTP id
 v18-20020a812f12000000b002d7d366164amr26275690ywv.265.1646152645816; Tue, 01
 Mar 2022 08:37:25 -0800 (PST)
MIME-Version: 1.0
References: <20220228172207.090703467@linuxfoundation.org>
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 22:07:13 +0530
Message-ID: <CA+G9fYvN1awHcozk3A2=TKGF9T2626Qu9BU=E=z5NyBpOM-TXg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
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

On Mon, 28 Feb 2022 at 22:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.232-rc1.gz
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
* kernel: 4.19.232-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 277110482a84a0400d6d71b4c12262431b62a5fe
* git describe: v4.19.231-35-g277110482a84
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.231-35-g277110482a84

## Test Regressions (compared to v4.19.231)
No test regressions found.

## Metric Regressions (compared to v4.19.231)
No metric regressions found.

## Test Fixes (compared to v4.19.231)
No test fixes found.

## Metric Fixes (compared to v4.19.231)
No metric fixes found.

## Test result summary
total: 80757, pass: 67675, fail: 437, skip: 11350, xfail: 1295

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 37 passed, 2 failed
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
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
