Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC23968A902
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 09:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjBDIoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 03:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjBDIn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 03:43:59 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47586BBC4
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 00:43:57 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id v5so3731794vkc.10
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 00:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfIQcOwb3dWkgDSw0lSfmPr25dlvhIlu3sOQI1zR7+M=;
        b=FwH1Yb0Ea+3DoopFhDZ0j+nFkXhjf6hSxRphzYN4NLRQk0YzVEvG+mOtBYYgUA+zjS
         HIPFqMeGXQAILnJA4e0+ncED3VHYSArH+5VYUV7eWWkiqY7OQ24OanmXS2yWDjY+k+gn
         YjLhgiFOTO4GBPkFAyl7WJ+yMLG5zhj22jHWZjcegAzuQTss0aZ/2dsegGAitkBZfpXl
         fI+LvtoR+8QA7ZQnkMzyDpkEcw3GSusfy65YiTP7+6ANuBKV51WjY7vTXyajbeW1OTkg
         AllD3xM5LuDeYYKP0S1r4pW6DrYCs9vNm5ScLxZwoR1WfnCnlGiYM+tEfcUBp22PfzPg
         lIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfIQcOwb3dWkgDSw0lSfmPr25dlvhIlu3sOQI1zR7+M=;
        b=TgyrgO+JfwvrA+JcpNChrTtdukWWSfI05mR0dyn6Q0IMRcBpjQCnxo8JTMCiHRg+fi
         Xvj/i6HLJPsth5zZ1sTTMrfm1wkvN31TSVOSxZIpAuhgHDZ3zdSBuZyo4DjwkY4zXdNT
         0rbosqfD7iXxDL21LzMCHQfQVS7zu327KyOvyc7vq4Oy6ORU3GUFeroLzvVRF0+HGI5v
         DyHJrU5gEqlgqQrcXknha4zfVAXbmIeRQGBB3Sl405X2gOvkGPaxwQNO3EuV62EOIcZC
         Z7EMbIS1kERRuDOE3tOfKeuSv1veckZoF40TIB2rvpEn+4DIKO9xSfuMPKbgFVzGYT43
         0Rrw==
X-Gm-Message-State: AO0yUKXtm6FDxpd0I7kvN3Th4RfIUycTJeyKuK46C1tZC8gzM76aNq9T
        ekpsxqGzuRZtd0sFDszi1816zafXfXJos80M1OjhCw==
X-Google-Smtp-Source: AK7set+XZ+Wvinf1/vcUxNLeNk8uoKnfBNpM4AzHxlnDAMb2hfU/rPeLYY1CsEk7+vk9ebKozxGCcAEwWIiWl3oMT48=
X-Received: by 2002:a05:6122:b43:b0:3ea:4be1:4a72 with SMTP id
 3-20020a0561220b4300b003ea4be14a72mr1900084vko.20.1675500235601; Sat, 04 Feb
 2023 00:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20230203101006.422534094@linuxfoundation.org>
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Feb 2023 14:13:44 +0530
Message-ID: <CA+G9fYscBgwZ5MxeTyo8XQfKkuPV1xJ+24E0gq1DgEyMzas44w@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
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

On Fri, 3 Feb 2023 at 15:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.167-rc1.gz
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
* kernel: 5.10.167-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 6278b8c9832e3a5adb841ca9e2cfebadb522f304
* git describe: v5.10.166-10-g6278b8c9832e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.166-10-g6278b8c9832e

## Test Regressions (compared to v5.10.165-144-g930bc29c79c4)

## Metric Regressions (compared to v5.10.165-144-g930bc29c79c4)

## Test Fixes (compared to v5.10.165-144-g930bc29c79c4)

## Metric Fixes (compared to v5.10.165-144-g930bc29c79c4)

## Test result summary
total: 155976, pass: 129575, fail: 3537, skip: 22567, xfail: 297

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
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
* kselftest-rseq
* kselftest-rtc
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
