Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B174E80FF
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 14:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiCZNRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 09:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiCZNRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 09:17:31 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70D1EC9AC
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 06:15:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y38so15867245ybi.8
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 06:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AikdSfXe4Ki+gU0Iq/j+kPAARq8zAHekqtyyVX0tRXQ=;
        b=RQviT6fqIMAsoYwEAHbJat7HQtZQb2tSYfI0bzwD6jFcUFFDZwgzhY7+LUqaunSeXY
         PxWo+AtRNBZCbsQTVFJYx3DB1HMHJxjQU030LdczHzyV7bMdhtVofJv/ZjS3cGEEmCVO
         2LY61O0oVzKe4/lQgdNhhCyCyKau+t4aT5zZq3dFGu9L9kdQbBiFy3Ihomuzh/YeZynR
         kd/PAFhtdzEwoAPx+u6LGaoE7fpF8a5QAHnBr/oNTnXqYLSLOkzD2OHExYeAWYHjrBCq
         EUEit1BCsxaihDMvxbxQL9MC0lk5jAu5tOoGtUe2rrkle0mpDAk/Be8svDsUs/0uKtRi
         AaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AikdSfXe4Ki+gU0Iq/j+kPAARq8zAHekqtyyVX0tRXQ=;
        b=fAfeMI5RyX0vumFwnoSbwlCxk/D5oJL5TubJAKzaR2Wh+HHjyB2JA77gcZXQX07ZIp
         PWmkxxmijmMcv8JbFUvuLGuIKVKQUJnR0+bU8BV7RoWeENYVVgNRR5x3Ce89HLawrbuE
         BOkdxeZiSw9lSIvGJZbu9897EzE0QiqezQLb6vHHEKjpNr7jXtb746guT0xQJvwpH7Oh
         3jyxidL6Oi/S3ZMshc44/g25VSlES3kbAZEwDde2FsTP8F8c/XG4SkApKtsaRGeH6QXP
         +ay8+Cs9GpG9M+kltt+5Ksw91TkGuKq17wvFg4jKgU16r320ygH5D4WYoe4LnhPS2ylV
         755A==
X-Gm-Message-State: AOAM530uP4zQP5fyX3MHhW4U+SfdF8lkRs28t57Jg288dJ9QQd3kzIdF
        xDzdpfFkzObrUzY6dx+35echDL3sMW8th4bW2QNV3A==
X-Google-Smtp-Source: ABdhPJzXhnH+ENU9AtT/qfaSGWiLN+Z5W88chmmcHqYfBDob0ZSbqwDnKTb0nvjPqxOJK2sdBrvu6QfSRIeQDwBNbs4=
X-Received: by 2002:a25:2409:0:b0:634:15f4:2240 with SMTP id
 k9-20020a252409000000b0063415f42240mr14270050ybk.88.1648300554229; Sat, 26
 Mar 2022 06:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150419.757836392@linuxfoundation.org>
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 18:45:42 +0530
Message-ID: <CA+G9fYu9CjYCQwM3EO5eguRC0rq00HMuE7cEAG4E68shzw4OHA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/38] 5.10.109-rc1 review
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

On Fri, 25 Mar 2022 at 20:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.109 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.109-rc1.gz
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
* kernel: 5.10.109-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: c02fc5f9e70f4aed2693f783a09af12c2ef87802
* git describe: v5.10.108-39-gc02fc5f9e70f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.108-39-gc02fc5f9e70f

## Test Regressions (compared to v5.10.105)
No test regressions found.

## Metric Regressions (compared to v5.10.105)
No metric regressions found.

## Test Fixes (compared to v5.10.105)
No test fixes found.

## Metric Fixes (compared to v5.10.105)
No metric fixes found.

## Test result summary
total: 95863, pass: 81602, fail: 589, skip: 12715, xfail: 957

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
