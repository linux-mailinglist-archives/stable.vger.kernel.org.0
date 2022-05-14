Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0D526E7E
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiENDqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 23:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiENDqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 23:46:20 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6792F61E1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 20:46:17 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id y76so18421166ybe.1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CAK+uUxQGB/aQr1diNYGcf/OqTs3Egl9DWdix/1cY1g=;
        b=vjdMvBG8Tf4xD68cr2dNt9BTkYJeR5NG1rovQAEqpxE15Vrs5ZX+ZcxGebdIgytwMF
         OHhCP/2StZyEgeS1opvG9eSCPR6kSxtzy0bdolnbw/4RvCwRzeb5h83mOM9nMijPpL3+
         3AEEWoLypvTBbELY0ypYp4RrnF4z9/pPM1e3+bmf4CsrNbM5OZ9Z7GWhMjFaoZ3boWuD
         V3wUrxgtxy0wcg5jqCQAHUdB8AiRL5eH+N2laKhr81B9jSYpWTONIZPkxgExlkproKyP
         v3uuuPXZtS29AOQX8UZlP1AwoBRewpidu36gmoB8A+Uj3vElfzpCE+me9Zlc9Ny1UHuO
         nmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CAK+uUxQGB/aQr1diNYGcf/OqTs3Egl9DWdix/1cY1g=;
        b=PpjfN5Q0dZfHDKN/8jw9D3nHBUZNd1ITFz9jVqDDNHlSSG/fsdGCcs7YBLv8SbCxEQ
         R+LGswpX/imEDH0RsQGtMXJN2DE91H7c1YmuiTRpg4eo3v1N5XDhxoQSfjHngu0dhZgK
         ybyWITXsiEwFkyJ47w788oqMzRrAJg8NNBKN+C47PUyy92phJs/VKDNBLUTpy9/xN4vc
         vPj7nvwCjMc8E8l8Qig9saw6ZFlqfCkaS4RGvv2eCI9DGe2UlaMkbFoI5K94/g8fctOr
         jNRJkfX9gEzo3n2/0jRJ08hkvxR15CnUsmMcnU/0urW4PqStJnHzHF66oMW0Cobp2YU9
         uDTA==
X-Gm-Message-State: AOAM53042O1DGV6fGSObH8l62rKd8I3M6mvsZW0mtzCruv5gxS3Eiv1M
        36Bdx/cDnA2dt7h5Tob/BQERvoAf5qE6rYHyWUkz+Q==
X-Google-Smtp-Source: ABdhPJwrv0FJX4/uTH8pV0Aal/cjW4xhwrg10VEhFQNd0WLEgknzk/modL+9GVRi7GLp3o2Y8mu3qzt7LhMn/lVfvqs=
X-Received: by 2002:a25:4aca:0:b0:64d:66b2:192b with SMTP id
 x193-20020a254aca000000b0064d66b2192bmr1202168yba.603.1652499976799; Fri, 13
 May 2022 20:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142228.651822943@linuxfoundation.org>
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 09:16:05 +0530
Message-ID: <CA+G9fYuezEQQ3oZ3zR_p1rv-PLsbNLXySPbhZt7iY6EGEf-m9A@mail.gmail.com>
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
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

On Fri, 13 May 2022 at 19:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: a8480fa60862622d04d6440efdfda7e367721037
* git describe: v5.17.7-13-ga8480fa60862
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.7-13-ga8480fa60862

## Test Regressions (compared to v5.17.6-141-g34d85184d6b8)
No test regressions found.

## Metric Regressions (compared to v5.17.6-141-g34d85184d6b8)
No metric regressions found.

## Test Fixes (compared to v5.17.6-141-g34d85184d6b8)
No test fixes found.

## Metric Fixes (compared to v5.17.6-141-g34d85184d6b8)
No metric fixes found.

## Test result summary
total: 103104, pass: 86581, fail: 1173, skip: 14138, xfail: 1212

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
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
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
* v4l[
* vdso

--
Linaro LKFT
https://lkft.linaro.org
