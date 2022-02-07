Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C54ACA3F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 21:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbiBGUTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 15:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241872AbiBGUN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 15:13:58 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F6C0401E4
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 12:13:57 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m6so43452101ybc.9
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 12:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nRc9Tqqq9fYDfHJKshSMoN+bDAjX+9kSEzcflRyBExg=;
        b=gjrPNzzAMYoHyJvcEgNl1zceUp8sU8VR+2Gcw4fpIxLoeFsxodPJVAewDArz97bRx/
         EEofiOzSThAi8K/KaXII8yHkyOb25AowdV8SDwCG+xpt5bxMz3t3QJPiP0YWr5T+uFAZ
         ydG82vAaW9F7pGlI+dtC/YjBnarmYiUlXdKtU/OJ56oIqgzPe6rMUSe4tA6Y6uYpHWhu
         yeufA+1X5VkzGc13i9hCOIDiOMl+mpqG3Z6U84RzuOa8fpW4yGAmjKZOzCiObepZWE5/
         KQuOUrqeERcCPia8aupZccDJXdgsdhd8PKHjHQFdpnU8q6fWSrbzliIohhH0w57dV7bO
         GKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nRc9Tqqq9fYDfHJKshSMoN+bDAjX+9kSEzcflRyBExg=;
        b=L4dFs4h9r++ixgCENRQAPrWgDV1XyWQXvJ0qsoRz+3Ktg8C8R1WeMJjniT6xIbvA59
         k4gEEUiVaHoeVVgBjDyyMA8dWGWjo+m8rwXImMXnwKN2d6fVLLklzk1lhfnUpgZdw7k/
         3VegeAWK48ML+5LVofKn3AZQcaqJA1pY/x1z6w2hecICStmz5XwbMh8zxZJ2IKG0beYO
         G92oztfUztSVBO8sjYvdg3C+6mSryQ490FIB+7WH0avIPPOTJpiIb4CmcbaU95uH5Hae
         O5PX28Uz7zalu2ZM1KbUvh2TlniXghR6Ii/3zeN+wgwzHM+VjJSHthrHO5uXR3yYkzcK
         elOQ==
X-Gm-Message-State: AOAM530HDsCTP/GNvz7BVN/a1esgJJfbZsh82QEQjNVwiUZ37Te6cg5c
        MJbGcENfcJEQ3ldYqKW4IesQSC+xW+Gw9rl12irO3w==
X-Google-Smtp-Source: ABdhPJyucK91UYiujQhpoNFj6jy7F3p2dUZ40tG1lxniwN3tAyuZDcSt1IAjz2DEOLDd8I8HqkU70fanVMaPd4Qddww=
X-Received: by 2002:a81:ed10:: with SMTP id k16mr1741134ywm.166.1644264836076;
 Mon, 07 Feb 2022 12:13:56 -0800 (PST)
MIME-Version: 1.0
References: <20220207133903.595766086@linuxfoundation.org>
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 01:43:44 +0530
Message-ID: <CA+G9fYswXgZsdVSg+q_76A6dvj2=8KpWKBqFCAUxC64y5JcQfQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
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

On Mon, 7 Feb 2022 at 19:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.22-rc2.gz
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
* kernel: 5.15.22-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 0472630a562104918269888a8b355d06c5060e98
* git describe: v5.15.21-112-g0472630a5621
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.21-112-g0472630a5621

## Test Regressions (compared to v5.15.21)
No test regressions found.

## Metric Regressions (compared to v5.15.21)
No metric regressions found.

## Test Fixes (compared to v5.15.21)
No test fixes found.

## Metric Fixes (compared to v5.15.21)
No metric fixes found.

## Test result summary
total: 77350, pass: 66730, fail: 383, skip: 9670, xfail: 567

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
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
