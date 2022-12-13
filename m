Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F7664B4D5
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiLMMJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiLMMJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:09:31 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEEE14D2B
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 04:09:28 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id r3so1404122vkq.13
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 04:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJL+U76JCqYeWWRN8/cqC6HsxwebukyU2fBx3ui4C3I=;
        b=zePtpkGl19QzWz/6OL7naBdx6vBeHonvdp+VXHQH+j0IZtYrgQZb+SyzNxOZaVEikL
         RsKbH0gWVrYTRLE4aQQQAQvWfGeN+ZRZcT9oLYKFV7MsT60P3kZB1QjuibP/lKVNMs+Z
         w4rTYDmvyQfao1j9vWiiXeCYQNtls9WzVeDK6natmGQ7YmxTbR0g9uJsDzEvqRs7JTJX
         JD6nmAlXg6mF2ibKD6V7w0zgVOI/g1hDnK9kicyxhAm8QNPB+5+dloiEpXasfpzCi1jq
         ZCxctlB/V0XU7zb7M87ysTxlGtTilmmKr+gIJXkIS/BDx6VQ0QNO0YEzG+7Zb+IMPxuq
         3vQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJL+U76JCqYeWWRN8/cqC6HsxwebukyU2fBx3ui4C3I=;
        b=K754WYd9a5UXVTSLLR6Uutq35R65X+e5gE3AopN2uA+F8ggD8SXAAGEB1t4Vu6tGsm
         zYNdxejfsRceNkmooVpaCMio3y4fxcarbWvQJ6ZCce0rKXa2vtbJYIF4TSvaGjFBZpoy
         7/C57Ier7gfU7ky2Gs7Xsw0deByKpJ1bEU8Mrep7DaIDdUMXLigSAtX7jnYacYG2XAdd
         jPySK27NS3VFMYlDkWuTgx15s9vDChCa4KnGub/dAay5TLzm+jYmXoapcXlF4LIId/Y+
         9Upt8FFRqYZPX/dAChEu+fMAMcp1p42+5cfP69hUr8ANA2S8PBCWmBm+yZO7hN/PhahL
         yLKQ==
X-Gm-Message-State: ANoB5pnPdDMW1DPKJNR4t3lvPKj9yUSQ0QxIqxBMW+Tr7r1Bxr7S1Aw2
        gyzEQe03QGPO5MduONyWn6QU/NVZSocDecnG+SaMpg==
X-Google-Smtp-Source: AA0mqf79SQlWgVD1PWez5EBV8eYsjPlUjuNbJ1sVTeT0My+UMSkYGzHxJvREadsCXakmPsFHJU9qlJlFDrHhU0e43cY=
X-Received: by 2002:a05:6122:1437:b0:3bd:dc4d:fb7d with SMTP id
 o23-20020a056122143700b003bddc4dfb7dmr6681926vkp.7.1670933367637; Tue, 13 Dec
 2022 04:09:27 -0800 (PST)
MIME-Version: 1.0
References: <20221212130909.943483205@linuxfoundation.org>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 17:39:16 +0530
Message-ID: <CA+G9fYsxPgFXZ6E1mEbT-S9Lf0AhgLzjPtMTcDUPXfGjLZMmag@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
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

On Mon, 12 Dec 2022 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.336-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.336-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: c4da25efd82f1a9c340da79342fe0f5228fc5165
* git describe: v4.9.335-32-gc4da25efd82f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
35-32-gc4da25efd82f

## Test Regressions (compared to v4.9.335)

## Metric Regressions (compared to v4.9.335)

## Test Fixes (compared to v4.9.335)

## Metric Fixes (compared to v4.9.335)

## Test result summary
total: 72922, pass: 62808, fail: 998, skip: 8302, xfail: 814

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 280 total, 277 passed, 3 failed
* arm64: 51 total, 46 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-net-forwarding
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
