Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F03F4F7D4A
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiDGKzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 06:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiDGKzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 06:55:10 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9909BBB5
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 03:53:09 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2eafabbc80aso56583467b3.11
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 03:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S3/ZPcxc/3TfZOLPkAhFYMPHkk6r+3cfOkyNPqSHcqw=;
        b=x8L1FfC8pW+nKZ7aYjLP1xGAi//QTY0+bW8tYG0yzkxhQaJwi1U0SlOCGKOBQo1M5A
         5EfuKxpW7wZw6JMk2r4KA5AgD/UGeruyU8UGkMMKv9V6sv3nwNMRkv7Uwd0irU1MuGQX
         aJiE+D/MPtFksdywDVGDWC+owSDjYlQ2zPWjipV0H4m/nMFvgLjHF1RJnvYaOgzAIKId
         iEnDjGeqbwp/WxW3j70q7Xwc9j8XnFXUhEYanlaJ/7rqmo0ujaswnujqxTYnKytwVeGc
         tsE9s3bAntwX7JlOMI1aUzd8E4eMO3NDcgZnL+tnx58QQwPLV7cVHy+j260KcDE3zXG5
         tw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S3/ZPcxc/3TfZOLPkAhFYMPHkk6r+3cfOkyNPqSHcqw=;
        b=0J10WhSUq1MpaTU/ucEBZfiIQfkAsDp1fHugjUdPyXxhabba4udwBj60M9lr1uDts/
         FoGsMNqmHrCUxkUE1RTtxyrh9YL12RSNRvauAFHDuF9aiKoIXBFoKwy0szPr2kGx+pVb
         3/Ioh30TBaE3pCf0TrIKS49OnmgDUbIIUIhiB6FQ29yRCXFd+4Sk4qbCzK/xFa5NVOTb
         yc6gwc0yPswslEB1lv+CgNGh0VPbxIGjnsfuhdmRovh5keYvImmDIlUm8xUkv/7jI0/2
         VHmgbQHT9GNGuecHpNhXDSWQAzOWViPTd7la2dsdsytr5x66/U0rtKZ5QhHjdeYkfpC2
         yWfw==
X-Gm-Message-State: AOAM530WLK24kbsOGaDL2wuDfcgb8SFxm809WglonV3qt0LKgMsa19Y6
        xGsWjsbrZPRpWxZVJ7miFr6Rzz8SSkD1IpgY+w9qfQ==
X-Google-Smtp-Source: ABdhPJwyXjRED4OxmzEuIkxMjiQSHDzM7hz2/mI4lCRBCvyqAkOrougmhtripDZmtxSCMd9KNUZdzcHPDEtjDXfXOsM=
X-Received: by 2002:a0d:ffc3:0:b0:2eb:2327:3361 with SMTP id
 p186-20020a0dffc3000000b002eb23273361mr10786867ywf.36.1649328788347; Thu, 07
 Apr 2022 03:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133013.264188813@linuxfoundation.org>
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Apr 2022 16:22:55 +0530
Message-ID: <CA+G9fYstjcHeC18ffkb-9pATAXftP9Wy3k9RqYmwEuALjcr3kA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Apr 2022 at 19:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.110-rc2.gz
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
* kernel: 5.10.110-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f8a7d8111f45af2bc1b9d989d2326a3ea61c10fb
* git describe: v5.10.109-598-gf8a7d8111f45
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.109-598-gf8a7d8111f45

## Test Regressions (compared to v5.10.109-593-gd189d4a7b878)
No test regressions found.

## Metric Regressions (compared to v5.10.109-593-gd189d4a7b878)
No metric regressions found.

## Test Fixes (compared to v5.10.109-593-gd189d4a7b878)
No test fixes found.

## Metric Fixes (compared to v5.10.109-593-gd189d4a7b878)
No metric fixes found.

## Test result summary
total: 95786, pass: 80814, fail: 838, skip: 13216, xfail: 918

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
