Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CD34AD392
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350018AbiBHIhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiBHIhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:37:52 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6E9C0401F6
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 00:37:51 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v186so47881318ybg.1
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 00:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IsuhTS+fbqIjZZkQVp8lZwfj5D0FFzFyP+BYoi4T2aY=;
        b=nc/nJKMT67xSf7afuo0qsrw7uxsuMSEaRe+4+HQ92JQakbLevrRVxaxy5FeoTJ1pfL
         oqUeVrBcyQvTc2tyxKKhC02KO61lnovMNdqTK+VVVekEsaP87A3AzDQoFKudIcqYsiuo
         Y4zaH+1CvzADu85+0xo4NyTE1OsHSDnVjvcK56gK5MyDBXK053+SMUT8yYBH2EAW6VtV
         V2RzWVZiPypnpZ1rNAXQJvM73x8kxhjFaof79JWcsZtkQBsgEJgBl/lqOYGbY85AAeg4
         m5ZlXVNKOpSJco/2HRO1zVsSFL1lPbrR6yL7xGCtC8nWvqhh6YnQA/a8Uo5IwZiPh80k
         +14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IsuhTS+fbqIjZZkQVp8lZwfj5D0FFzFyP+BYoi4T2aY=;
        b=PGKdWEQD2Uwrl/zVp44haFqSPQWf32LxY1LH4KQh+2B+G/0QKjNK/kq8QF56sDGPyU
         k4VPzRnW1mO7u4lNaCHMRZwjGe8CWhJ90h+Ss5t5R//Hd4idX3XJcmX4OcuBCIeiVhhl
         605sOsqI1SafJhmhsn1bbPEDvCHkcXh57u4sV/dce4Ba1YpUi7IByA1kuLrC5/k/1QEt
         Jrwj3h2xRwuN9EXKKkFGrQpLG8NmwOAIsF9/q8ZAHbwRYNsyiMJQ4KrJg7EgACGE6bvU
         Y31YNxqodPGBqD6Yq5D6ohj16/47LYiLi3DXFjHpINsg8xjmzeuJyY98W1oCr3HxHiI8
         Lqqg==
X-Gm-Message-State: AOAM533rxhxPmtUdwd4AuEVYPVzjBhfMcQL/ZoaxRcNhNQk0f8LNb9mj
        1FqR/4PSeUo5zwxVg+x9Z+8XiEVgGHG6u+ZSdgbKqg==
X-Google-Smtp-Source: ABdhPJyqqj0kG95cuaMupOXzk0MyB+zmiuu5RMcz5TRg30Xc//9dGAfX89A4nujJ7Z/ZRWjB0ylhQamoijY0GhHJNdU=
X-Received: by 2002:a25:1402:: with SMTP id 2mr3274089ybu.684.1644309470792;
 Tue, 08 Feb 2022 00:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20220207103757.550973048@linuxfoundation.org>
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 14:07:39 +0530
Message-ID: <CA+G9fYvxXGkgjcWqoZPbEWPThXf-oZD6rA3fWqiQW2oD9=cFvQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/86] 4.19.228-rc1 review
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

On Mon, 7 Feb 2022 at 16:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.228 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.228-rc1.gz
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
* kernel: 4.19.228-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: b06b07466af8a89d8b0f135c98ada13f5f373d7a
* git describe: v4.19.227-87-gb06b07466af8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.227-87-gb06b07466af8

## Test Regressions (compared to v4.19.227-54-gcc8f3cd8ea90)
No test regressions found.

## Metric Regressions (compared to v4.19.227-54-gcc8f3cd8ea90)
No metric regressions found.

## Test Fixes (compared to v4.19.227-54-gcc8f3cd8ea90)
No test fixes found.

## Metric Fixes (compared to v4.19.227-54-gcc8f3cd8ea90)
No metric fixes found.

## Test result summary
total: 85003, pass: 69288, fail: 738, skip: 13031, xfail: 1946

## Build Summary
* arm: 250 total, 246 passed, 4 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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

--
Linaro LKFT
https://lkft.linaro.org
