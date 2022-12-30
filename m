Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA79C6595B7
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 08:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiL3H3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 02:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiL3H3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 02:29:25 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D302819294
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 23:28:59 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id w26so1361158vkm.11
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 23:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4rWDBnich9Pr6lmmK6XSKuKBAi2tSUB5CAPgAozAlE=;
        b=XegkyVKV+PgUZa65lBzqGnH3bl4fhLNyQYEGygUbEJbcmgtYHf3+hQP2MXiEnbpaW4
         QuW+e+I2bMxHSfa2Bj2Z5r48w+YZADkfv4I/1TWUFCaV+VUe27mQsF8outWlygJshdpG
         AU53Bg1H1nTVYhI9TCgXHsqo0r9E34eyAacsX7AUvghb6LojnCggIOq47/HyQjDcPt5X
         lugbp9QKQYC7TD2GHQSGCDNqATgYcCP6hMaIMwi8Xx9G8zIZHVq+rqLqk6FSd8YZ4RDo
         u5XubKnl9Lik2djUMvslbq8GbwAOuHeTw8Jms98QyFiJ5pG54HPb3nSjxNCqkFBYWRHw
         f5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4rWDBnich9Pr6lmmK6XSKuKBAi2tSUB5CAPgAozAlE=;
        b=bH5ApdJVVhsuTcHGOMLD7x23tH+G0yMgJrUbBM6lBzXhJCYiU3Y/Ch07XtZzVKnXx3
         SUUbQQiNeHGpm0t2yKxSOdX2ggV4bvRJKBiVdyDVUMwRdNHfAi8OsNjfQQj4I0QV3F0B
         5PWEwETBf50wGbCvqm/2ltYEzRuXAP81YVkxC6KEOeQjtfKopK3ed0pMjhsrGSqleAeE
         0Azc0gU9bZlguHd293kyVnaDiGVgu7E0eA9U9xJpIzNPUMSZw9+2dZ3342MkVa0DM6w6
         kuwro432tcsCYLXw2fnX2CmwCmoYoVPUVN3ok9Mbe1a7JjF4ZCuc3qWGbmG8qMK/K/KL
         Uv9w==
X-Gm-Message-State: AFqh2krVXg9BmZw28SaZO0TZD5v/KzNb68MV9fNMIbP9UGk5G6xeHz0R
        NwWydFxpPk0gP4JsPrluF35vUMEW8/8IoOMJsVxvB0ZsizQzRCj7
X-Google-Smtp-Source: AMrXdXtkAY/uzal0nBliIfYQXiC4k+adlA8+pERXrTaj7CT8ZC3STOF5lX4ND2bGwJPtTvEUYMp8gfv6xd9Chkfy8uQ=
X-Received: by 2002:a1f:d904:0:b0:3d5:413f:ecd0 with SMTP id
 q4-20020a1fd904000000b003d5413fecd0mr2461946vkg.20.1672385338756; Thu, 29 Dec
 2022 23:28:58 -0800 (PST)
MIME-Version: 1.0
References: <20221228144256.536395940@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 30 Dec 2022 12:58:47 +0530
Message-ID: <CA+G9fYt_jC+FkQnUXhciRdbj+MvyFc-oe2uNz2Khr6rMJPirsA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
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

On Wed, 28 Dec 2022 at 20:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.86-rc1.gz
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

NOTE:
Daniel D=C3=ADaz reported allmodconfig failures [1]
[1] https://lore.kernel.org/stable/0328eb25-f711-d6ca-28f4-60601b6e0bfe@lin=
aro.org/

## Build
* kernel: 5.15.86-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 87d5d5cae7d93d584c504a91241ccf7a09217bab
* git describe: v5.15.85-732-g87d5d5cae7d9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.85-732-g87d5d5cae7d9

## Test Regressions (compared to v5.15.84-18-gbef75c6188c7)

## Metric Regressions (compared to v5.15.84-18-gbef75c6188c7)

## Test Fixes (compared to v5.15.84-18-gbef75c6188c7)

## Metric Fixes (compared to v5.15.84-18-gbef75c6188c7)

## Test result summary
total: 148474, pass: 130464, fail: 2813, skip: 14903, xfail: 294

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 43 passed, 6 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
