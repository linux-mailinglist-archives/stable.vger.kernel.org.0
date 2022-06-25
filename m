Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF755AA84
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiFYNdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiFYNdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:33:53 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D235315FC0
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:33:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id fd6so7029485edb.5
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uvcJcgBDL1XKuNKHnZVj4o8W2sfUNV/ROHCsL9fEdGc=;
        b=y49OMrR/FdL/W2uPLIeCBx0YlXuLTyDhCZRhcXGDuHuesKqzbgXIcG5eiG+GV3wg0w
         w5mqslklbULIiNA/TpUrKP6Ey/JDW8fqWoXcas+M7VJvoCGMhYSegIu55kOPnehNjADY
         nmIfHjNpt4Omx9MnaMOMrGZFM/J63Mxq5hqRWHKpF4lQyj18kpnWSMHwxF6IMivyeEzZ
         RvOOPCgasU12Jrpel9c5qjphAyZvdne9RvjDtzETEJzqB4GWIM4KZ4NQthZ2wI7oY/4F
         CgV5mIi2RoeG3KF0oz5wtT+3WoZeJ6JsQdhRg8OJjMY+z8DgpXXNhXUhiqj0dg0qTMGS
         xHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uvcJcgBDL1XKuNKHnZVj4o8W2sfUNV/ROHCsL9fEdGc=;
        b=OZ9Xr8Lt2KDonvxzqxNoMtpaYHFU9WFPYbVjeA6v43EkQcg8BktkRfcFPXODRK48my
         bkEWSOKAlm0tc+tnqyAHRkv1pxpe9GbmHMHvPZ2LunGcyVR//odocvlTWscR/gSft0Kk
         2E1sF6O59Akiu/JIg5/+lQqaif3QBbxY3pka+trD6lmgYDikiRH28k0AmEPQoRszQv91
         CO+QBfw3lSul7fD8aUshRQGiNh/W+L9ZqXSg8x27FGfSty5QEXcgvXEGerMa2mJ9H6dR
         8OSipjcn+1H0bqQutQlrqPhGRSJdxcVBTMXdmOrJB3I1ybFKjFYwXEMfJa0IYrcxtDtD
         9k/w==
X-Gm-Message-State: AJIora9+K3qzNYYTbB9DrpD+8Ted9eR+L6TfqUi1TLEnDUZBwtqnRDaS
        gY6Gb9RgWwgT7VYcWiTZtC1NNoROFN+MegIRsktukw==
X-Google-Smtp-Source: AGRyM1v7UgYXTYs4KO8weI0InhSUxx71r2S/CE6Yp6VUitWcyDQCuTRVLzDhNuyo+Ngx8curRF54uTrVW/QXogVVErQ=
X-Received: by 2002:a05:6402:3707:b0:437:61f9:57a9 with SMTP id
 ek7-20020a056402370700b0043761f957a9mr5011403edb.1.1656164031288; Sat, 25 Jun
 2022 06:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164322.296526800@linuxfoundation.org>
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 19:03:40 +0530
Message-ID: <CA+G9fYvWBKvUAOiKc=O2HGOT500_innDhhbOfgUH4cdXfW7kbQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/11] 5.10.125-rc1 review
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

On Thu, 23 Jun 2022 at 22:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.125 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.125-rc1.gz
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
* kernel: 5.10.125-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 99120abeed34b4814d3c0b4443283075bb65646c
* git describe: v5.10.123-96-g99120abeed34
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.123-96-g99120abeed34

## Test Regressions (compared to v5.10.123-85-g1432bd558ac0)
No test regressions found.

## Metric Regressions (compared to v5.10.123-85-g1432bd558ac0)
No metric regressions found.

## Test Fixes (compared to v5.10.123-85-g1432bd558ac0)
No test fixes found.

## Metric Fixes (compared to v5.10.123-85-g1432bd558ac0)
No metric fixes found.

## Test result summary
total: 133307, pass: 119577, fail: 254, skip: 12678, xfail: 798

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
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
