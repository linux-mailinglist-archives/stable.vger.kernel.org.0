Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9A6C2B60
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCUHbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCUHbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:31:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74012057
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:31:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cn12so10383612edb.4
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679383896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9GDFvoC7kbAq3Pu2flhUcwFA+dtH+7aeYZEHEaRwfY=;
        b=uZ0CsOYdoiOmKMOL1gvq+80fFFTRiIXimjjEqFJgIzVckBSyGtx5GXuoc+pa22P/je
         y1sif9eWhrIq4bfEl8TEkzIAUVla+y0rK57YnC1yD6KlpkkAQ2iaGHULwtunesv7haD/
         jLbG0UJtXXkp0aPWRTymIUOKZWfWvtYkBI0d8tkHlohPdvRVpRQlo0L42GOQBYydRJEV
         TeaY2JKev7WC1Guf7igpJDhnUlaNYQeAmVKPW8zsKXQMutGeLipQ2a7UbYCO3mSzxBK3
         g2cYnXh72jazdkiQIDDstc28X1k/HvXkI8mnzihzUdH0ozEwki/0NuQID23KNMsqpOix
         SvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679383896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9GDFvoC7kbAq3Pu2flhUcwFA+dtH+7aeYZEHEaRwfY=;
        b=Ja+fWUpVSsxhjhOSma1iSAF6kBmGUyZhJm6vHxoUFCjMRfHCSRoUDGANDuGb+oeYj5
         gkplkPu9qUmUoRwGR+C2LMAriukoOmYgCjHGZqcL418qpPh6YlI6fjPGFKfFhGGsKHK1
         UZYMBy7mCiK9IQ4zLjK2wcmLZOWsunmhwobCQQ+dwhJAcZQWZicf479b6DTP7TBHUMR8
         QU5qECSFfkjnmawzvjzxEClVFcJnn/SAUdSvoPmvohxu/j9Fr1LRviTsNjlhzW8qbmhf
         WfH3DHYWxvhIkgLyr3xNO5vBUDlM+HRSZIYy2JUZZR7rFWJ31XWSQNufMNAPkyzhS9Tx
         9lLg==
X-Gm-Message-State: AO0yUKU7oQPZTa8lbxsRATFnKVb888SC8YPT3RYgWGwcoF1zMJvPwD5G
        1mbOL5twJbwgcHjE2tyQ2bt/4X1sv6xjTEVT1ulviQ==
X-Google-Smtp-Source: AK7set/2wtIwIn8el1k9vUQPkQi1zybgqo+D2WWq3T+IJBqpDr10UFwGBXAMtTQFSirx2zN6voDpWpdONvTXAy7/ltM=
X-Received: by 2002:a17:906:dd2:b0:926:5020:1421 with SMTP id
 p18-20020a1709060dd200b0092650201421mr895428eji.9.1679383895712; Tue, 21 Mar
 2023 00:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145424.191578432@linuxfoundation.org>
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 13:01:23 +0530
Message-ID: <CA+G9fYuP=XioTQemURBMBwOfp-1pKf=VQizVG8zq3+amLd=6Fw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.279-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.279-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: c1beffa09ae6c6e2099ae4ffe4f30d5c2ee69f09
* git describe: v4.19.278-37-gc1beffa09ae6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.278-37-gc1beffa09ae6

## Test Regressions (compared to v4.19.278)

## Metric Regressions (compared to v4.19.278)

## Test Fixes (compared to v4.19.278)

## Metric Fixes (compared to v4.19.278)

## Test result summary
total: 91992, pass: 69255, fail: 3591, skip: 19028, xfail: 118

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 201 total, 200 passed, 1 failed
* arm64: 42 total, 41 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
