Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1EB4D53F9
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 22:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344142AbiCJVyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 16:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343617AbiCJVyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 16:54:44 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E1114D244
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:53:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id g26so13543361ybj.10
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vXgPptlnAq9CokgqQzrTxngWaf000WwuBucpk34zTdU=;
        b=TZoUkC+eWW5B9pwdPu6qPcw2zU80I5xL5EtBO1Rg/UhWPz9WF/xvt9nMteqKoEqLaS
         xNOFImSuximEUql+W/aFnqlB755ovL2DQrzwkWJ4k1eddD/lfuSZpQDIysCFUsajBG+b
         46IeCQAn787pZCSuD1T4vNyUKyIaQKMKFGk8vscO0wlRqWNhYwEbfKhFItATaWywkREz
         D3XOZw3xW9S16vz2u2sv4NsbIeNeqefduCQMVCIxIWrm4EpdeFzIGj1lwoxBsw5+/8RC
         WbH9zHT/Ko2XA1km9RI2E3Cvl0+JNbcHUZ2cjFY6BgR/iAWcqF9NW6lcDUNLA8Io6MX4
         T6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vXgPptlnAq9CokgqQzrTxngWaf000WwuBucpk34zTdU=;
        b=loHiU41HszD1t+zQTygFjGRTiiXguqbvFc4M/R7lWR6fvc6I8hBJvr6cUn9HjVbJSL
         jT9gbdKrbyJVmSHmB2pTtGMqTwZ1iNcyhSxKeNhI2uN1L8mDRHTRphykJc99Q9dj10K0
         iTUOPiH0V0pXWtNu/NfSQ2ohp0AdCBsIHF2PF76odDw71F3m0FbHM0aD3gomwWZYU4AF
         FnBCTNbV1wdcxD5J4njywoQ4d9rCgc3slai0RYlAR5l8pRdtWjzGiD3JwWv3g4I5KDOy
         HjHFPNlLF8xpT3cYboyIOyfP0DO1uBkiiMHl51ugq5GTSjKrOKvEm2ru6m7qSGIqIa76
         OMPQ==
X-Gm-Message-State: AOAM530NWTwa/vW/f8frKnyeMm3AJPh6eUSSnGWyEzUimXVbrtmIJQIW
        B+drNpuizhGS/jFExxeszRQ6ujjpYr7yGQzqjnuuEQ==
X-Google-Smtp-Source: ABdhPJwTx8CE8o/IhrrKnHcXqM2aMBcl0URepi8bRnLnHL3uXsC8X5yl1ZQQiFVRjT/u2N7sBtn6IX7n4dBU6UWDA+o=
X-Received: by 2002:a25:338b:0:b0:610:a221:af23 with SMTP id
 z133-20020a25338b000000b00610a221af23mr5901864ybz.474.1646949221400; Thu, 10
 Mar 2022 13:53:41 -0800 (PST)
MIME-Version: 1.0
References: <20220310140811.832630727@linuxfoundation.org>
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Mar 2022 03:23:30 +0530
Message-ID: <CA+G9fYvLiAqSwge66drSuoUwG17agsSiSFbO+knzqfep=p807g@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
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

On Thu, 10 Mar 2022 at 19:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
>
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.14-rc2.gz
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
* kernel: 5.16.14-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 8a3839d7a6f38d700fead63c3976116e5172ba62
* git describe: v5.16.13-54-g8a3839d7a6f3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.13-54-g8a3839d7a6f3

## Test Regressions (compared to v5.16.13-37-g22f5a43617b1)
No test regressions found.

## Metric Regressions (compared to v5.16.13-37-g22f5a43617b1)
No metric regressions found.

## Test Fixes (compared to v5.16.13-37-g22f5a43617b1)
No test fixes found.

## Metric Fixes (compared to v5.16.13-37-g22f5a43617b1)
No metric fixes found.

## Test result summary
total: 110972, pass: 93953, fail: 1167, skip: 14722, xfail: 1130

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
* ltp-fcntl-locktests[
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
