Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B7C645A54
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiLGNDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 08:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLGNDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 08:03:37 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376B826579
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:03:36 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id cg5so16022741qtb.12
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2av9P4q0PWClAqjlk9+Sy30yJr7v0F5TZCLHKaqqno=;
        b=mazFRj2d/QItG2GL7Vu0gXiEkXj5q49RE7uiQFWb+1kncwKex4qUT1U7glBufTLFYT
         p2Aaq0sPV1ZyC/rjuWeyZ/aRTqb8Rgc5EmB+90sVsbAe9EYn6DS9sNgKEuHGhN0waWAg
         2kRhpuwQBOTJPzi3CmOgXS4yx2YoJcEfcs7/mDst296JSugU2gV9UsAx1XS6uEzhoDJl
         Npibkyjxd+MqQLU1weOXRq58t9s2NF5Qvpm/8c7BU2OLr9gTlZa3Q1o64uSnXVkZP2H1
         CeBd+uujIeGoCtt+MVH7qYcLHbJMgj870bRSZxFya6JwJAiwG5JGCAcv9Xo1b8gV6Vcu
         W4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2av9P4q0PWClAqjlk9+Sy30yJr7v0F5TZCLHKaqqno=;
        b=IyaiF5k774g43tDn6CGJoizrSITtsLrBwR1i/6VZdputhX4W6iuDCq1E6SXRREMVa/
         jgGfcAHR6J5C5oslhSi0QudpYzENuWTHk+5DDMr+9D8Yw4IsocOsoqKtk53u8YzPBL8f
         hXQIy/rygpv5UgAP4jOppO9s7c9VjbKctB5n0ZbE/gp2QIuC3UFuodS8XBBkrcTWYR9s
         y7YbgoBmVunJxCqOBo4rIA1AWFPhVcOEca2qLcvR/dRrxZ5rRiPzKlw/e876Vp9ZHwsW
         XaVO/3TqTVSca9qpC0lF8146gHFtK5qV9YSQwFwCD4tP2DFyQUPgud3NSBTu9vkNEpv3
         61xw==
X-Gm-Message-State: ANoB5pnKVU5Dry+6TAQiiAqTC2uxFSZrfAA4WKU59OyMMYJuCZ0lrUM5
        o7zlFIUAoS0cg9Vy3w3aRec/O7PPxVczMuqjanlmlw==
X-Google-Smtp-Source: AA0mqf7y4RypDqQ69GxKfE2SkP2KuvMCtQmjR0Ll8ehFHHQ5JvGK7wQPg5M/+gaS5rBRi9bTwsfthzdKPvjhrlu3bgE=
X-Received: by 2002:ac8:148a:0:b0:399:a020:2aa with SMTP id
 l10-20020ac8148a000000b00399a02002aamr67545276qtj.247.1670418215133; Wed, 07
 Dec 2022 05:03:35 -0800 (PST)
MIME-Version: 1.0
References: <20221206124046.347571765@linuxfoundation.org>
In-Reply-To: <20221206124046.347571765@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 18:33:23 +0530
Message-ID: <CA+G9fYtgAZwXn_BT86JM1m+RWsc0+_ebtvWPdCksVuYgbtp7ew@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/83] 4.14.301-rc2 review
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

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.301 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.301-rc2.gz
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
* kernel: 4.14.301-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: dd6fc0ede260695326bad7de0ba0122fe6ba8834
* git describe: v4.14.300-84-gdd6fc0ede260
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.300-84-gdd6fc0ede260

## Test Regressions (compared to v4.14.299-88-g179ef7fe8677)

## Metric Regressions (compared to v4.14.299-88-g179ef7fe8677)

## Test Fixes (compared to v4.14.299-88-g179ef7fe8677)

## Metric Fixes (compared to v4.14.299-88-g179ef7fe8677)

## Test result summary
total: 48369, pass: 41437, fail: 896, skip: 5341, xfail: 695

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
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
* kselftest-net
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
