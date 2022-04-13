Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914434FEF98
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 08:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiDMGMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 02:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiDMGMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 02:12:36 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BB133EAC
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:10:14 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ec42eae76bso10867307b3.10
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5fgVChRRApKlBIxVlW1f3hD3updGvqv5yvWmNDhjdtM=;
        b=sI58AZkwnV0PCwyvFIbzfa5QQOD2KOa4/arl6YdzEnwXWAhOnYuzFBRM7LS9aH+/Bx
         lZ5qzStf0i7jmdVP+bD2gt4luZx+SYboLf8Z0boKiZnt2/Y1XqjdMMMAgBOnwWT1nwOd
         /+3y6q0sg6fTMSJv3/ieKe4oSjz27TUBC0bz5Idccf64BemXK7Zz4WVqLBU/4AngPlkq
         rVrGNebOihUvSCCiugDQz8ahIhi5UJbqzb8Z3WIWItzxQBVyH6gLuxH0gypY35v7j5P+
         C+ALokXhuan4JZ+3M5C09TpgU0kN8IIWje2bnLnT3+0BwZhunY4BdFvvXYxyNxuXBdDe
         R+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5fgVChRRApKlBIxVlW1f3hD3updGvqv5yvWmNDhjdtM=;
        b=czTttmpOVX0UYUnRSOnQTnFav5fh/Ctp5i/pi+Lvm8JneksU0NfXGj4gZB5yBpGjkQ
         /i3USCc2C1gRDE7sIYWvtav0SsytG8ULS0lsoQ48ZXHtf2bULYxlsbpRpDfPhKyhP5MA
         V+xC8aOFt++WRZHV62V0QXK6xj/l4sIVX27gNkvrBgaZSYUOyPglSTd83bWcsbXpjlk7
         SJuwO6XnNDlNuZJioVMfojFJXyyI0jlGUlrttBlLrnYoYlpV+cDAoE+k7jCh0ppokhqK
         xx0wJ1/e+fE9jwSLbbkyi+4651PvU6xAL7OYzLIyT6gJzKtc/ep5X4/KVmy3hy+cmG4m
         76Kg==
X-Gm-Message-State: AOAM531CcRuElN4KB/z1t9/EuRf4rN/D4b0FkymnObOSCqmyuBzvlt3/
        v2wVeMDM3jR3riIFdyJaya+HFjTo+Pwm1yq59hq6Sw==
X-Google-Smtp-Source: ABdhPJyL+jMiw5z7EODt9P0QXbBXCN/kSj7h9Iv6Dz1aDHs5FhCsk1IdpCBf2tyRfFSkdgqquVySeXxYu3HczxYW3aI=
X-Received: by 2002:a81:bf51:0:b0:2ef:414a:f03b with SMTP id
 s17-20020a81bf51000000b002ef414af03bmr2551046ywk.199.1649830213341; Tue, 12
 Apr 2022 23:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220412173836.126811734@linuxfoundation.org>
In-Reply-To: <20220412173836.126811734@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Apr 2022 11:40:02 +0530
Message-ID: <CA+G9fYvwjKoO4TmPDgZ8pZfuv3b9_3V9keR7rR6aiH2_n4a6cw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc2 review
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

On Tue, 12 Apr 2022 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.34-rc2.gz
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
* kernel: 5.15.34-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 1ad810a5a764358347407720dd6ea61e771cfe36
* git describe: v5.15.33-278-g1ad810a5a764
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.33-278-g1ad810a5a764

## Test Regressions (compared to v5.15.33-277-g059c7c9bf722)
No test regressions found.

## Metric Regressions (compared to v5.15.33-277-g059c7c9bf722)
No metric regressions found.

## Test Fixes (compared to v5.15.33-277-g059c7c9bf722)
No test fixes found.

## Metric Fixes (compared to v5.15.33-277-g059c7c9bf722)
No metric fixes found.

## Test result summary
total: 100224, pass: 84238, fail: 999, skip: 13860, xfail: 1127

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
* kselftest-arm6[
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
