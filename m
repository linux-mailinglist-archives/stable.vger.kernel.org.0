Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB86297F6
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 13:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiKOMDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 07:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiKOMCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 07:02:51 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD020222AF
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 04:02:49 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3876f88d320so6571277b3.6
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 04:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ux8QFcJWIOHy95msi/DPXBwY/PKWFOBKNLrmFRGoLJE=;
        b=wJ2e0xBMeihOIaC8JieBaPJG/TuJHqXQEU2+yn713eLHOW7P0jmjUAJc0FzT3BXupM
         HAU/iMV1zGrbfC3heH90e44HKBildUEblpYMRHhu9KYqBdsxxjjnnYKuS3LHLTFsAfr9
         ypRlKjjvaeNGdeX/CYjv99vaNWXU+ZvBP58n8vMspZn8hQmU6ufW269O60upfrH9Izuc
         YThLq5YDiBnk9WT9nU2U0bcxZSCzRxKa9ddNGdGstZZS3OAi43mhBkJIAch+vNcKNtgY
         E6sTKZzyHbeU5xXilalnhbbJFwQpPedzrcNmAM363TMM+/jou/Wqp1Rlo/lWHvLl4xsD
         Zu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ux8QFcJWIOHy95msi/DPXBwY/PKWFOBKNLrmFRGoLJE=;
        b=tJuv+h70UwUt9Us71Fb4chHf6PWrFD38SMmqZPSt8E4FW767vz8w3+C4/AogvoxZqO
         BjO+bXEB8mfyZr2+Q5eAYdcQH6iYs10Ji323hZMMQvReswzYMjbur911JyKqgsEVoQSI
         rcyEqWQLCv2z6qvYcHOQe+XkS60YgEI2GwyS/5Kxt1GoSKZEaElhNe9DrZxbnZ4zhOSJ
         U99BBD2+C4C93Yvw7aStsdpEnO6rNWKPLB8UxL2IObAn9sMh6f8MJIdnfK4MN/CghM8N
         fxxa9Cc1Y3R4EXDzvWl7IGu294HtfL1fB6Wkx4m2weQVSC4KLY6DRq9wnBquPCaUQilz
         v/mA==
X-Gm-Message-State: ANoB5plA2HvAiJ5C4YbMJCIA45+2DcFHp0T1hKVnBSf0pdJ+AQXSXFBA
        7oHmAynhr4CPfiu51LdHrnxv1qKFRkzd/xFhy5JPJA==
X-Google-Smtp-Source: AA0mqf4peP/pfzhfBwyPbXRi9SZmzgVzjr7Zhw8DsKipwrDO00grFNS7ArT8NL7616EwncYxAW6L0fn/wTkz8o7aafs=
X-Received: by 2002:a81:4f42:0:b0:37c:a694:25b9 with SMTP id
 d63-20020a814f42000000b0037ca69425b9mr14221008ywb.259.1668513768782; Tue, 15
 Nov 2022 04:02:48 -0800 (PST)
MIME-Version: 1.0
References: <20221114124448.729235104@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Nov 2022 17:32:37 +0530
Message-ID: <CA+G9fYs7z7hbf0rcKhhyAkROTnQHnbmOzZ+oTMbW=Es6pu159A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
A part from allmodconfig build failures on arm and arm64
other test reports are looking ok.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.79-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: b6ea7e152210f358e39d05a567697a098aa16e7a
* git describe: v5.15.78-132-gb6ea7e152210
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.78-132-gb6ea7e152210

## Test Regressions (compared to v5.15.78)

## Metric Regressions (compared to v5.15.78)

## Test Fixes (compared to v5.15.78)

## Metric Fixes (compared to v5.15.78)

## Test result summary
total: 63728, pass: 54817, fail: 1467, skip: 7178, xfail: 266

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 287 passed, 2 failed
* arm64: 80 total, 77 passed, 3 failed
* i386: 68 total, 64 passed, 4 failed
* mips: 54 total, 54 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 60 passed, 0 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 76 total, 72 passed, 4 failed

## Test suites summary
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
