Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9952A858
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 18:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351095AbiEQQmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 12:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351092AbiEQQmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 12:42:22 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B36403FB
        for <stable@vger.kernel.org>; Tue, 17 May 2022 09:42:20 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id o130so17824456ybc.8
        for <stable@vger.kernel.org>; Tue, 17 May 2022 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HMoOpKOlu+k7LW37DRFl0GsXtUqddEd+oHDo/auxrgg=;
        b=fu8oxRN+9yYdHMKb8ZvWKHsQDWY7Y5UXQpgbzHN1HxclG7VW5xwjhxk3lxjz4fSoh9
         e4m33w1jcki7Z6eVL0nQCG1gNGqtwbUfo2nX4gCNE5UZN/rV3Bhev+EBNTvZ1PyJRA/U
         5pDrF08raIAQUR0/IJbsDRkFExpqf8jLdoiqI+iNmnNK8DRRw7pBUgomD9QCF0fojDhO
         DybV63SWO4xmYpbC5QYdY72PleePs3F4gSjZzG9Bnx+v+sArkswwyj72Tpd7yp5JMinu
         wO08p1+oe/Y3lbU+socKu4TdYdrMdNs1ZUmeDZlo+DHQemERs7ucpZBGRawrLQsssihn
         WIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HMoOpKOlu+k7LW37DRFl0GsXtUqddEd+oHDo/auxrgg=;
        b=Fkwrwb/wLf6DF5oyrI3X8/+nqcgjCtRnlMX0ul9fp9cT7ctLwuxM0wMlUzBCYO8NRW
         T5nSfFne4wrZztP6AgZcsWTEgrJGAktizVlObPFuRoEoSU07effzNUMdMGkX7S0i8SL2
         mk3BOgOyDYwOwG9/9aGZO5sEslE6vekmNGJd4sMQ2+XtwWZUjQLrQpqVhZaZ92ZHyZ/V
         V0ywraug/sWyOS0wVHYTTxBsqjXCEwbYqY9mKijNWfvIXihNs7/Cy7Oq1rgRUxC4lPop
         RrYDeYdV8pKGXnNsVh6xDu5sdIUYGNyJW4goi3DsaNxQjWwjmr+/08n43ppl+kANgC5a
         jf2Q==
X-Gm-Message-State: AOAM5318zW1yWHwOfcCdivniJx9hJScbry6c1LR/BhGCL+buAWAfIRFi
        844ejvof+2q3zo4555F2AkI5G4EuzqTlrpd/X2vKLg==
X-Google-Smtp-Source: ABdhPJxHjRPLoNTgsjT3o/XgWtKKJX8krSIPM4pcOr8f6InoMA/ExhFPEuR8BMoBPUOqfesTrH5yxdTL4PeCtF8Vu0I=
X-Received: by 2002:a25:aa30:0:b0:64d:ebad:538d with SMTP id
 s45-20020a25aa30000000b0064debad538dmr6335668ybi.603.1652805739369; Tue, 17
 May 2022 09:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193614.773450018@linuxfoundation.org>
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 May 2022 22:12:07 +0530
Message-ID: <CA+G9fYsRFZK87_9Xfcbraft9R34cqp7ZjcGsxvY65E3rMv=O3A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.244-rc1 review
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

On Tue, 17 May 2022 at 01:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.244 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.244-rc1.gz
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
* kernel: 4.19.244-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: bc41838f2dd87b1c999e8eb02de3c503953f0ab7
* git describe: v4.19.243-33-gbc41838f2dd8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.243-33-gbc41838f2dd8

## Test Regressions (compared to v4.19.242-16-ga96b764d90b5)
No test regressions found.

## Metric Regressions (compared to v4.19.242-16-ga96b764d90b5)
No metric regressions found.

## Test Fixes (compared to v4.19.242-16-ga96b764d90b5)
No test fixes found.

## Metric Fixes (compared to v4.19.242-16-ga96b764d90b5)
No metric fixes found.

## Test result summary
total: 74073, pass: 60228, fail: 866, skip: 11511, xfail: 1468

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
