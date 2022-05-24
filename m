Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2D532A7F
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 14:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiEXMiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 08:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237419AbiEXMiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 08:38:01 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF3487A01
        for <stable@vger.kernel.org>; Tue, 24 May 2022 05:38:00 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ff155c239bso180435657b3.2
        for <stable@vger.kernel.org>; Tue, 24 May 2022 05:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j8lEs0UvbPfsBuXtPymrsSZyDf2BNed9XTZAMBsnAcc=;
        b=O6BoOAOBkSRsxfa9Lj8Ht4IrqgvPfKr2zbWhi8qif1rzSPAonQgzId05ZhyFyBX8aZ
         gY5gfJi9HVSFh5M3U6W7YDCTGXD/Z9nFTi1EtpXcKokarHW6mgmBDa9Zrmp9OV0fSin8
         oSJ/HpQ4Jji9yLcAWrLs5E/92A3jU0pEKl3fQfNR6rheKF3Q7NOHL9srTNdrTyJOZWjY
         /HkhQQbvbjGbNGR9GqNydYrmpVhZaczIYRuJWAOrQhXr8uEy3DwtQBTs2OpUnyCcDVLQ
         Wk5Aw+W0X+IPcIX1+nQ0Szs1m5UWhRTOBxi2IcLckYgy9gLnAgqdLv0ur7Xcqp2NAjGT
         0j7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j8lEs0UvbPfsBuXtPymrsSZyDf2BNed9XTZAMBsnAcc=;
        b=BnBskFwe1tkARj1WeCV+17fNYp4j09RN+cRD/vntxOF00WIY6FaNf+y9XiucYvISlQ
         SQjwp1fj06oQ4UfItgPVc0b/X1HlkISdzPw9WFZ7Xzcsv9mTYmHYmdH3g0H0pwHZn/zr
         WcHfzqoGQfwFPQrAfQ8uw96bWZLesPy0MYPQXceeJZfr+rjO+mFhITIYcyP2r9KLlrdO
         tuiotZKyaVtt5o2j+2RgG4Ijq8QfNIzf7M7b39g9slOmQf3krEdQRwhv8KwjWi/wK2CW
         9nzETFipUeiaTyXGeK9R1CTXz4G6I0HEiT/a/h/oKs60a/zuiz1TWAMBriwuY6VgpFiA
         8uRA==
X-Gm-Message-State: AOAM5304eADe2/cVSZCx9NlZMX4EMh/2xbWf+H6W0AuJDdvK4vtMJpw8
        gqljK5XDXRF/X7EWXTOyuNPxIpWT2lErKWv/H7ZkcQ==
X-Google-Smtp-Source: ABdhPJxX7wYFP/afvpunY/HrW+UWNDXEpYllsHNZT40xSy9b7TN3ysFGD+hwbUuPVtp65VDNw9YSkj1RYqadFUfo6dI=
X-Received: by 2002:a05:690c:443:b0:2fe:eefc:1ad5 with SMTP id
 bj3-20020a05690c044300b002feeefc1ad5mr27685203ywb.199.1653395879436; Tue, 24
 May 2022 05:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165746.957506211@linuxfoundation.org>
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 18:07:48 +0530
Message-ID: <CA+G9fYsefeayMPwakY0W=gBYsJUHfnvZL00bmyuGy5-jSE6bqg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/33] 4.14.281-rc1 review
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

On Mon, 23 May 2022 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.281 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.281-rc1.gz
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
* kernel: 4.14.281-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: b14ecd5c89c07852f6db6e723ddfcd15248f9b8d
* git describe: v4.14.280-34-gb14ecd5c89c0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.280-34-gb14ecd5c89c0

## Test Regressions (compared to v4.14.280)
No test regressions found.

## Metric Regressions (compared to v4.14.280)
No metric regressions found.

## Test Fixes (compared to v4.14.280)
No test fixes found.

## Metric Fixes (compared to v4.14.280)
No metric fixes found.

## Test result summary
total: 76912, pass: 62185, fail: 786, skip: 11760, xfail: 2181

## Build Summary
* arm: 270 total, 270 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
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
* log-parser-boot
* log-parser-test
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
