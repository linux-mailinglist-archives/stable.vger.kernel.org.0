Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD14C8568
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 08:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiCAHpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 02:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiCAHpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 02:45:19 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995A565834
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 23:44:38 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2db2add4516so102534477b3.1
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 23:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qe1X7mYMjXko6WaUL3HZPQ/8TN0i+vTLPTdADUVrV6A=;
        b=oKHFvyYc+b+VqpPJWEG0QQI4TQ49QS6dxgxtz4v5AxO60fH7IIgR0yVO/+eXVC0gfC
         22DgwiLdgsz+oGyfFZyjl2IlMMUAGND3Z+DATVlEpsCANVC4XlfverhvM6TCNO9Ld/yT
         nwl+ptG6zgKLWsJ10nx38xP4qIk8VF89eWP9Kan2yPb+xpg9YfKYtzvGIyh5rhcZAkEG
         uYUNJn6CgcmXDiNSZ9XMkBPFgBjTNxwgQJz2oCTSCM1C4h0B9tq5685p+e85CTuEcnKs
         tlMFzytchDn3SlpUV6/Tv6xB3jKv+RuP41lBj5C7Nm/uYtAmToECV7P1Fdq9HC36QTwJ
         B4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qe1X7mYMjXko6WaUL3HZPQ/8TN0i+vTLPTdADUVrV6A=;
        b=fR9Stnv6qWjRbq2cb6+sUlybK9CuBB4Yw24TbH8P2oSYl6wtfruliQkPsJWk0Fgwzx
         xvVrAX/LQIZ7AsHJrZAM71BwFQa4C6KclatJZrBRVvSoohUopRJsDplM7qTmBy/LKOH7
         tCIfIGgjlxUI2cNoehSNK02PVPGkVkkd/eHw3u8vckZpD3QOKG2xhWnxDZ9LPrb/ZSG8
         GxP5sjRE+nAhwykCdzqeHDki071G/7uAGQY58+QFX34R0q16tvRw0e4SDX+c5AWsMM32
         MunutI0YyC9dq0m9AauAZsohSKPUOyKtWlBwLqD5t7nZnVimFn711FMMaWXu17AF8dkM
         r77w==
X-Gm-Message-State: AOAM533s4BJTDDO8aI0IaOUIfoUqIhvXFlFZz4QCnKlNC8q3J3Jw2aJA
        2lSoOOCw7vSOepNsVUVpo6L63kIHINWyzr00qzdEIA==
X-Google-Smtp-Source: ABdhPJx1tl1/b3S3sZfZuqz7dkpdAuY3FvclosjsCLKMt254WfGeHfOpJNrB/Ng8cL0MsK5hsmp+f6+QDNxVONtvjNk=
X-Received: by 2002:a0d:f347:0:b0:2d6:916b:eb3f with SMTP id
 c68-20020a0df347000000b002d6916beb3fmr24378404ywf.141.1646120677626; Mon, 28
 Feb 2022 23:44:37 -0800 (PST)
MIME-Version: 1.0
References: <20220228172347.614588246@linuxfoundation.org>
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 13:14:26 +0530
Message-ID: <CA+G9fYvwkJJQ6-q6C9ii6WQFLRMr=tTuCsOFF=-WUqXmgJdRyw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
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

On Mon, 28 Feb 2022 at 23:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.26-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 798174743716117a3388365925d6d20985bf920d
* git describe: v5.15.25-140-g798174743716
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.25-140-g798174743716

## Test Regressions (compared to v5.15.25)
No test regressions found.

## Metric Regressions (compared to v5.15.25)
No metric regressions found.

## Test Fixes (compared to v5.15.25)
No test fixes found.

## Metric Fixes (compared to v5.15.25)
No metric fixes found.

## Test result summary
total: 108667, pass: 93375, fail: 831, skip: 13467, xfail: 994

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 44 passed, 3 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kselftest-lkdtm
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
