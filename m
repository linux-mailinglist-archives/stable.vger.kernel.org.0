Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F514638E3A
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 17:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiKYQ0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 11:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYQ0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 11:26:36 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43F4C24F
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 08:26:35 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3704852322fso45881717b3.8
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 08:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bf7E7n4dmrdFRC5rZ1QW+EG5hHZAKscT7MoDcTeBD58=;
        b=G7gtbdq8ip2ekxwjuI/Ub7lCR6vSRAanKnS7PLhX2TsMFeIfK0dk0lA71Ecz56gEby
         eoWR5LG2GYMXiHODKmXHPIIjalopjSpHD7pDwEUskqdxTxLgThs3QVHUvf58mJL+Y3Ef
         sAunH4fiMS5Ixo9ehkZ52PlDfyf4mQrsWqYe+C2YOy1jicGTNMFIYmYDHnDobLnRrqtc
         3ab0RZgd/Fy6b077SaZrAdCSVwT/QG6GpEWXlL4g//RmcKVcxUvUrvDYzgQGuICfWzpB
         LD7SIpofW2zcEeJTHOEtPLxdRE5MaJg+jtH+zrs/8FBq4XMEQeoWYGtf9StmQhi64N2X
         yz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bf7E7n4dmrdFRC5rZ1QW+EG5hHZAKscT7MoDcTeBD58=;
        b=CMqNgAppNX5eZuZHLvBfg6q+4N8VDF2ckCKY6SgIimWGJksTQgsbW1Buw7A60Xx3GQ
         tosq5xEzesS4CIHTxIltZ6VMrt3ZOLIoZpUubl6oxFd9cxV1RiipsGk6/NoK8zqOyqpG
         bcKrt3BP7omy1oPZbOWas7vy8qSzU0sZLSjEvIW0Ufp3UBIdhs5vsbA2p6QpbV+YaiDW
         Crmk+ZlZtibfP44UAPyeZopH9OdsZ6GZXPjHfceR7UlP0YABe+UlhBHzVmPKc/T0rEel
         ApC16hMYjdxy/D05pydYLly8hC1Cd8hBGdkTomqa4lO03PbOaQ7ogO0xhJcLu51d00x4
         TwPw==
X-Gm-Message-State: ANoB5pnHJqtUu5A0Xwh67OzhH++5boQ1z+3l0HS9nAUe67vcc85zqLSv
        mK0eCClovm02irIR+xpSoACA1I61DhmnBiYA2A6rtQ==
X-Google-Smtp-Source: AA0mqf6dpYCUTp9rCGQ4y3qXOTEFkV/f/u8MPzAwc5LOoH3J6YCnEgQFsWvPKhbCHpODj7iXjQiYSWTbULk9LWhGl/Q=
X-Received: by 2002:a81:dd8:0:b0:3b8:97ce:990a with SMTP id
 207-20020a810dd8000000b003b897ce990amr5556946ywn.448.1669393594268; Fri, 25
 Nov 2022 08:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20221125075804.064161337@linuxfoundation.org>
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 25 Nov 2022 21:56:23 +0530
Message-ID: <CA+G9fYstqhTMcmVVu3ArZ7F=raf34SZ95Z8y_W+V+4TwcDgyDA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Nov 2022 at 13:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.10-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: e0b681e38dd4981e5305f1775747e3eb645e10ae
* git describe: v6.0.9-314-ge0b681e38dd4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.9-314-ge0b681e38dd4

## Test Regressions (compared to v6.0.9)

## Metric Regressions (compared to v6.0.9)

## Test Fixes (compared to v6.0.9)

## Metric Fixes (compared to v6.0.9)

## Test result summary
total: 149083, pass: 130099, fail: 3546, skip: 15063, xfail: 375

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 48 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
* ltp-fcn[
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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
