Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E996D58B0
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 08:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbjDDGVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 02:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjDDGV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 02:21:29 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C39E7D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 23:21:27 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id b6so24238867vsu.12
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 23:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680589287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uzwxOKmsdxIS2Jsg3C0T4XZWNuybdJYCmtC2mSEyI4=;
        b=YDESwoG49v15WvLJsOV7h9ofTe1pdsLZc59eiwSB8cxOpjA8Bfd/7ywZD3zXPsIxyx
         A0XQdxVL4odJygszpdbZ0KTWR4cm8dmNl8QAytZAIEFqUujcP0/uFjHcSqrje2F4HBsL
         bC0SyvVE1N9UqH1Z1F8NdX2eIr5iak/6XeV/xi62X3J/YGZSJTXwr5mpvEV+MREa7p9E
         GNOgkHYdVl2/lwR7cuEL+4yyLEeHhIZAHqYdnkCngd+NO4zmhi9pFv4OtM72ncqjqwFS
         1W63IijADoJqdwutv/62i4lqdq22A3kVPLfwECEA32E3/8UaKTXft3gSlvkmQYYwM7j9
         Hr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6uzwxOKmsdxIS2Jsg3C0T4XZWNuybdJYCmtC2mSEyI4=;
        b=Ho6UZQwNSdQtS/JXRQiHkRs4E0m2rVC8G6bAGTAT2QW1KNmi3I9HCN1W9oskTBM7vB
         BPnNkxnRIOKmHgwmNJA6q7lCCdPn1N0dl0sprhqZAiB6/ufdVrh6p0zvRuOJ1xPobpCI
         BwpgjhtlqS9neOCEvmXI07wI9uOFmcFWoMuxy9DjHL8w1ZuWOzlMD8YBKIO5eUfYCktK
         FDSMx23YYTThZMAhOr/huEMeRVaVrzDn229lQLtOAyzQbiP+t/hT2IXyk5+wm9YR4orI
         00YFRwUvzTTzC3Xag4stQfKclqWO13H7Cs9tOlwIy9f8iqE83QL0QX4rTZLnemyfyM1K
         vd/w==
X-Gm-Message-State: AAQBX9d8LjuxDMwXVpz4CaTx9Ibvf2WpvU8tXuKTXQt0SU4Ue9nkFS8b
        H6npRG8k9BRVQIY2RAo3PQvKUAd9Zfo49hxWlO1pfw==
X-Google-Smtp-Source: AKy350YuY0vOhnn+VixaITUbUnFbkm0W3IDIYmixrg8SZ8/6gPbnNii9CF1iZnUD3l6qpVvN7cnPgguZgoVdCjcqLJw=
X-Received: by 2002:a67:c896:0:b0:412:4e02:ba9f with SMTP id
 v22-20020a67c896000000b004124e02ba9fmr1457329vsk.1.1680589286702; Mon, 03 Apr
 2023 23:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140403.549815164@linuxfoundation.org>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Apr 2023 11:51:15 +0530
Message-ID: <CA+G9fYvwZQqTXazfbBK911S9p9M=x9hX4c7Pw8975uYUsXXybg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Apr 2023 at 19:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.240-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 73330daa339307fbff4ff7f1775da1dead794691
* git describe: v5.4.238-107-g73330daa3393
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
38-107-g73330daa3393

## Test Regressions (compared to v5.4.238)

## Metric Regressions (compared to v5.4.238)

## Test Fixes (compared to v5.4.238)

## Metric Fixes (compared to v5.4.238)

## Test result summary
total: 128883, pass: 105451, fail: 2957, skip: 20258, xfail: 217

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 143 total, 142 passed, 1 failed
* arm64: 43 total, 39 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 10 passed, 2 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
