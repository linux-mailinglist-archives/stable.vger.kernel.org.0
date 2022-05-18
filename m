Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8D52B510
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 10:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiERIeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiERIeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:34:03 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DFA1929B
        for <stable@vger.kernel.org>; Wed, 18 May 2022 01:34:02 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f83983782fso16328797b3.6
        for <stable@vger.kernel.org>; Wed, 18 May 2022 01:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PrZaKflJcqAm6ITWcjGceKP2vw/l5blOH42KyEb340k=;
        b=ncomM3peKSn04FpIn39Tye5gpWIkIHpJe+eZQVH3AEcRe+PayE+bjnIgzYa+tYzSpn
         a+duRleDpSvtHwQV5QJBWp1tz3yNsSB6g3AtI2aMihK58iKLiEbJvFHSW3XMIcCgysWV
         /c19HSvwfQV+031guMjkhQYQmzFzKch82/yV9Y2HdkoERvFuxbnck4I8+09O8fON0/4s
         t6NUIWgNkqzpGoUKcrINlMwHntweiO6u/E1yOf/rdbj11tesv88Em8Negn/xffloU5NU
         2FDoZr+6zThRLHgzR8Hkl+I+IhYp5vOec3uoAzYqM3TyWkUEFPCfV0u0/j/ZinGic0L3
         pwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PrZaKflJcqAm6ITWcjGceKP2vw/l5blOH42KyEb340k=;
        b=hDD5973GRhWD/PJG8eXJPigU4faqfzqrrBb4422bv2XO8rEXPYSZVDTSzHdBRDvwE0
         crubAnKAolkGPIjUBfTd/wnjxPKYtDfd0rA2HxE2HXi32hPUzDUKYaNfvjRAWRY0qxY7
         bsp6xobIQ7uKMnqK41uh8N1BWVuDfqMOc1B0naIdrRnExvGm39G//35zBXRaLgQF8Vjh
         Pme1FccxoKf3MqEaiIaamBNU20VDmoKN+QDksPg3b2TrObsWfq3PYJ87DO47nsTRVAGT
         bMNyu1n6QMDAq7RzcteeIQrPj1O7yM4bHFFr26e/bqg40HBAN+l7fuoyZVXJDVUNRrUb
         jgSw==
X-Gm-Message-State: AOAM532/6MhX0OXVPZouMzqtqJIn1aQ36qEhopG3MR9TC35WNCunva6M
        37x3iSZImatxPghw/JU7R0ZdNF7y7mVcVFgWKybF/g==
X-Google-Smtp-Source: ABdhPJzptGy3TNS2w3LxYTNzAV1jeNgHV/LL+PxFsbqHAIkz8CDMWjg9njpIZjIx1Tl/gchvpdBXIzK86XzjQVa2bWE=
X-Received: by 2002:a05:690c:443:b0:2fe:eefc:1ad5 with SMTP id
 bj3-20020a05690c044300b002feeefc1ad5mr16379342ywb.199.1652862841052; Wed, 18
 May 2022 01:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193614.678319286@linuxfoundation.org>
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 May 2022 14:03:50 +0530
Message-ID: <CA+G9fYt0_sus+OcfndkeA+OmjfwPWsm=sgaBJT+pPKR1nO-n0g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/25] 4.14.280-rc1 review
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

On Tue, 17 May 2022 at 01:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.280 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.280-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.280-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 371779ee7c349696d0848d670711e87d44903fe1
* git describe: v4.14.279-26-g371779ee7c34
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.279-26-g371779ee7c34

## Test Regressions (compared to v4.14.278-15-g4477341b2b19)
No test regressions found.

## Metric Regressions (compared to v4.14.278-15-g4477341b2b19)
No metric regressions found.

## Test Fixes (compared to v4.14.278-15-g4477341b2b19)
No test fixes found.

## Metric Fixes (compared to v4.14.278-15-g4477341b2b19)
No metric fixes found.

## Test result summary
total: 79237, pass: 62537, fail: 1123, skip: 13203, xfail: 2374

## Build Summary
* arm: 270 total, 270 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
