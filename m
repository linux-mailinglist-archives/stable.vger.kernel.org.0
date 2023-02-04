Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C7968A93A
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 10:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjBDJgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 04:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBDJgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 04:36:54 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985B534010
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 01:36:51 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id s24so7795654vsi.12
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 01:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyoKiQ7zeC9iLhE6WOuhw6cWFuYLyGHZEkrfQLzhroc=;
        b=mYhN8sPaOx7ArX81ubvoDo8WWoKL5Y3kj1U7wnjI7vJKHzWmYSC3CW+takqwsx0oXS
         84/AE8mfHbRtcHKkq28mWSc0gNCFD/o5o/gvh4zfplfofXrd/+yahBCvArbrse+NnDLd
         FrRdQALPJkuwf9DKAWNnHjMTKeT4k2EBDjwjAmQilxttmO+QWPEM8B4vrcVt51PBNj4W
         yfqpZ8Zil9LCG4rh3V3XFO3ZM+bMqLOTxFESqt7S55ye9wMac+UEC1RFY+DCUk/Yq89v
         b4qhDYD21BOlypF8IYxX5BgYfUQCtXEwaQV5x9rduGvkP/TQxFcwNXYZYfOW28yT9ExL
         Eycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyoKiQ7zeC9iLhE6WOuhw6cWFuYLyGHZEkrfQLzhroc=;
        b=p8ef6Jl7QyPLr4r4Ys6nDYb/vVvNFmzg6AW9pugBarcnIBHQOTMp5SAI5lYOu0SR4a
         8Zdbjq/Snm3Ip8TkG/GCCgJQL2vKmX6STkqxMwCdO8HMHOsEubCQ1MpjgRBTwHxExRpX
         ya5eg9gbrt/EedeGBw6K4ezNQpxDIEWSZYvMs6B/56T2b5p+hIbMd+dbJmoUjmzBHAA8
         poHtww04tlGPmcnuhLyoCCqlA5qNR1hAyF8Fe0/41o9FNIFDbKnVfDrD92LLGgNS+Q71
         kE58BgvtauCemS+JImmGIo8si9UMhGx6+BENP7mmxnqwDgs2JwqcsrF0OvI6PVfzdLkm
         EG+Q==
X-Gm-Message-State: AO0yUKUo6cmIgm9+kQPI5RCJHZEFan4n8mDyLucKwWBfSXGrEeDSSG1h
        tMucAdIFtCiT0e5ntrwNGwaThyGJhO1FPTyw8tQWAg==
X-Google-Smtp-Source: AK7set+fjvCQQ/rq4Vudh9xe09bpSjdm95pV6GiaBLXbbEPh3SJM1xLwDHkX151ez658u6eBcK6cuGO2TgDc+2tu5LI=
X-Received: by 2002:a67:e19a:0:b0:3f7:528b:d25f with SMTP id
 e26-20020a67e19a000000b003f7528bd25fmr2142314vsl.9.1675503410280; Sat, 04 Feb
 2023 01:36:50 -0800 (PST)
MIME-Version: 1.0
References: <20230203101012.959398849@linuxfoundation.org>
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Feb 2023 15:06:39 +0530
Message-ID: <CA+G9fYvDk2QKX9iJQy_GMrntYqSqbf_HHaTO2cLsMSvsKuT6iQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Feb 2023 at 15:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.305-rc1.gz
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
* kernel: 4.14.305-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 001d96b34795b15b9037ba2fb3c63dffcfc0566e
* git describe: v4.14.304-63-g001d96b34795
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.304-63-g001d96b34795

## Test Regressions (compared to v4.14.304)

## Metric Regressions (compared to v4.14.304)

## Test Fixes (compared to v4.14.304)

## Metric Fixes (compared to v4.14.304)

## Test result summary
total: 92228, pass: 79865, fail: 2880, skip: 9186, xfail: 297

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 306 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
