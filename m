Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3DB4D1108
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 08:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245000AbiCHHeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 02:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240635AbiCHHeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 02:34:15 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA69934B8E
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 23:33:17 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2dc348dab52so157864637b3.6
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 23:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nnObU2Uyd0tlAyUt+AocrM4mHS92r1VcGTTBiqGJCgY=;
        b=yOfUUXtBHt0cPHQn9COcC8hkkfQMSk5WTW1M35SimptV1SelfF+dyssIOeqbmf0bYN
         1VHZe4xN6TSqi0DMMmnn3ho4ekwwLrYl7IMkpMx8N/ew/L+BIUucj5y20+18EP+4+lqY
         OxSy4ASMTTNpK3IQWjs8+ur3fm+nZ5l4Dj9DH86s1fQT6PvZweG3Z85i31ZmGsIssFzh
         edt6PdcZNOGWcwFccPTmOz6WUPOleB5dWMh17vKrW5NJOLlAWXO7Awsg7jyPHoCujppn
         7kP1niVQZdaBC55aRFBgRrzOaasilm2jKdFEoBHsoRpGgIxhQ4GbFehgfRYwwCOLD6yL
         wu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nnObU2Uyd0tlAyUt+AocrM4mHS92r1VcGTTBiqGJCgY=;
        b=wKjjkgGYrQm/ZSnImH3s9vSxvD2zXZq/sopIrC2lu7pJplf1p5rp+2uMCsmdbdoRPH
         bn0N9ZD6VoDFj3NAqWsGXQrYRjJwgZGQgtUvRqRMHYK0GAl1Ya5ltKoXhwUaGZVGZYFs
         hJVSWdFogaBbLVE/w1pwvQFdMz9zzeWFNTkE3qW3Fuo4o7lx45mqRfsrLV+46gMHsewh
         sETRJfviX+8TFN2bcqyvZReC2Gfjk7ckHn0L6BZ/mGz9Q1abBH9u6S7uEzjuFy0Z6LSb
         jXUS+jZRaDLqaTC6aWj4OQcMlvJpsLmp8JdSCU7L9J0wzZVp1BXDueuSNvSjGBxPEv2Z
         RY8A==
X-Gm-Message-State: AOAM531zXe0YNl+N5WwD/Nz/rgcfNFDym+Nkc/HyFAdWbcvqGyO0ZhPW
        J9CDZVNpVhOm5vvrHw2dQKRbiXD2LXsm9Jq4LE/ZEg==
X-Google-Smtp-Source: ABdhPJwWB9Ya4xGBxepsT+3xWuV/ks+Bxx0IXku6wm/jka5TL19e6eGW87IwXd1Srob5NwWU1bFeJ7WEH3euA+bNZ4Y=
X-Received: by 2002:a81:2f12:0:b0:2d7:d366:164a with SMTP id
 v18-20020a812f12000000b002d7d366164amr12184415ywv.265.1646724796782; Mon, 07
 Mar 2022 23:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20220307162147.440035361@linuxfoundation.org>
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 13:03:05 +0530
Message-ID: <CA+G9fYvrXYObuovXQvsbxfKAtZKFFTSBxPN850Wzx5s_aV-X_A@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
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

On Mon, 7 Mar 2022 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.13-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: c596a0efed21d96ec6d26eb247911dbfc7c3e36c
* git describe: v5.16.12-185-gc596a0efed21
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.12-185-gc596a0efed21

## Test Regressions (compared to v5.16.12-166-g373826da847f)
No test regressions found.

## Metric Regressions (compared to v5.16.12-166-g373826da847f)
No metric regressions found.

## Test Fixes (compared to v5.16.12-166-g373826da847f)
No test fixes found.

## Metric Fixes (compared to v5.16.12-166-g373826da847f)
No metric fixes found.

## Test result summary
total: 111761, pass: 94381, fail: 1219, skip: 14909, xfail: 1252

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
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
* kselftest[
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
