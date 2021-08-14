Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044D33EC266
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhHNLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhHNLgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:36:19 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7242CC0613CF
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:35:51 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 108-20020a9d01750000b029050e5cc11ae3so15210646otu.5
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NDchhMqZTf6Z5FH9y7Ucd99RT01Wm0vnI0/OhzaI3Hg=;
        b=q0mljz45bvavoQOLjTrVmCporgPVQAaI0FBEtnrLlyXzGgOeQ/s8YRanthPKjO8eWL
         RZnSBE9synCxaJBvKmK7zHzMO+HeY+1am6Xm35rWaah4wa0q7dUwDDRYxjZpOBvZMSpU
         GrHX0NAi9/nbcIFGeJLoJ3fv3bLPVjYF2Z3UQSvZiW/ES5daDXJxhCiBU1U8nwUw3dTZ
         7il/IqJIhsIaztTVXh5xA4gRsZJeWZgi6ArN18StiJ6aNarYTKkJcEZ92vcE2GZXce2f
         roduJr8Le9IKVeG5GZVqmj9W4d3c1e2NBGP4UwLJzHyHVCOmwwLSuERl/RvjSyHKv7Sl
         GwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NDchhMqZTf6Z5FH9y7Ucd99RT01Wm0vnI0/OhzaI3Hg=;
        b=FmHLKyUIoEnuxS8DCQtsZ29tV6tvur6kZrtbDip0Kr2TaRXnskEfcI2N1+++VWZ9ST
         IdDq/5m9ZyzyqVDjTOOrjD+FbXh4y3+mwF/bZpFggdnv9xYVwpM9TT0vb9h5MOk8RFRN
         DbNxGo0hVAYxAQZPrf7J1mCptN7rdL4vYohnq+b4VovukE86DselGPEqYKP3WsaK8xK0
         YsZOTVbrjg58uifxcxK2tJ/73Pn3gIcPsVek3b2CXfRWEF2eS5Mj9LCApV6ol+pbzu55
         +dWu8rfUypfQc6BKU8yKAM16cTRncVyPhuwXlgy5xgQW0NKD+qNFJQfdrbqO35E05N0/
         8fxA==
X-Gm-Message-State: AOAM531OcD1egfjcI94Nb3w1i51CgAmdsXZ3LPt5DKHR4GvEQVfKdEjd
        hkTZ2Sd4/vBWLGIBi1pnSGq5sVW1ZULiGsTkXpPWyA==
X-Google-Smtp-Source: ABdhPJypLF8Ii1uwCKdYPTbgj0jzo8vSwFZ9EhYXA+/ib9TXxfOW6aV2mIZClLUClUvFPw35IpM5HWzZWhLqooxcGNA=
X-Received: by 2002:a9d:27a4:: with SMTP id c33mr5859925otb.281.1628940950600;
 Sat, 14 Aug 2021 04:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150522.623322501@linuxfoundation.org>
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 17:05:38 +0530
Message-ID: <CA+G9fYsZxoobbFQ5OQHQiKTeT1U5Re+nXPqoS=P7ANOQ5NwwYw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/19] 5.10.59-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Aug 2021 at 20:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.59 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.59-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ed2493daa915286093123bc53c2172d717bc5d82
* git describe: v5.10.57-155-ged2493daa915
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.57-155-ged2493daa915

## No regressions (compared to v5.10.57-155-g81212a8abbf6)

## No fixes (compared to v5.10.57-155-g81212a8abbf6)

## Test result summary
total: 82479, pass: 69458, fail: 306, skip: 11842, xfail: 873

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 194 total, 194 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 28 total, 28 passed, 0 failed

## Test suites summary
* fwts
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
