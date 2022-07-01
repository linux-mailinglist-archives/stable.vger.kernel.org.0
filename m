Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642FA562B22
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 07:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiGAF7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 01:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiGAF7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 01:59:54 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047CA6B802
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 22:59:53 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id p14so810593ile.1
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 22:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bpnf0MqrDUKXaYHd0cZNSK1Qdldyb8RGowVrGEDoJK8=;
        b=aW7WFpcvK228CM2dgtBRxM9bHphIRiPT+yxPIkR4EstJXxWsR1LfomBh89UTynanIb
         GPa2ogQUrBOlwDNNStpN9Lc05yNRL2Og0A86orh5ef4gDxzbb6qZ3kVyScYh5nICKaBu
         DeBxzRRhs1//BUQhCBZ0FCvazItGrBieIxjRA6WkcOosI1B6qMsMCRM7aNGogh2SrDTv
         uc4s6TldKgOsloGcuL64vXpa2f8/ebpDX+Pflf59xQpPZgrHhf2TBVtbM9r3uS0GhfQ3
         tTWOTCJjYPMtQaADpHEDm8fA3LCYaQdQ/2CzmnvsoVd6UuOzHYS1IpS+ZoRxw6UVgYsI
         nP+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bpnf0MqrDUKXaYHd0cZNSK1Qdldyb8RGowVrGEDoJK8=;
        b=4vjSWnDp+PQs+c+hGHv3tdGNHDnisg1XMEUG3yOPpvBkh9rA03HVnB2g61xl/tgMki
         yZ+gx6ZiRs3LNreah3MIyBiJ4HVMiAL+21lBx0EZxHvtIWMCCQ0FucWJWljqGUAaL22r
         3p8LvgJt04MSkqN5hs6xGPqtUTEOfs60Meosz5v1VhMZoU5sd5zjUzv6GIyC6kAUdM7p
         Jk/w1IQAd39E+Eo11Atrv0rPBWARPTsbz0DMOQCktsy7tUxodn9kqMU6mjFbcaY7CYQw
         9xE92SpAWyPRyB1jfMBaaGK5AMUWE1r7PqMtHDLSOCO//XDMhtZS1/xgnVcDguLEJPPe
         bl+Q==
X-Gm-Message-State: AJIora/ySASvX00+1MxhMvs1d9QLn0fcjteUH93CFhsHyY2oPtmBop6g
        8qM83lyD9iMtju/S9Rg7Q+PQyhxlT0BhJ5vZS3wPrw==
X-Google-Smtp-Source: AGRyM1vCUM5AytM0GkClNzZtfdQPn7BNheoA2iwg5/W5l25ipEuW+MFQO86oaGMMSJ7vHP8KIT3S0d+/bu4Lj/KeBAM=
X-Received: by 2002:a92:d9cc:0:b0:2db:611:8cb9 with SMTP id
 n12-20020a92d9cc000000b002db06118cb9mr1066897ilq.55.1656655192211; Thu, 30
 Jun 2022 22:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133230.239507521@linuxfoundation.org>
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Jul 2022 11:29:40 +0530
Message-ID: <CA+G9fYsmy4bg09aq0fVRNp_iCh5oTM_+c-NBii6MiNWwBvt8MA@mail.gmail.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
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

On Thu, 30 Jun 2022 at 19:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 2c9a64b3a872fb2818d217509b16e61ba54c365e
* git describe: v5.18.8-7-g2c9a64b3a872
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.8-7-g2c9a64b3a872

## Test Regressions (compared to v5.18.8)
No test regressions found.

## Metric Regressions (compared to v5.18.8)
No metric regressions found.

## Test Fixes (compared to v5.18.8)
No test fixes found.

## Metric Fixes (compared to v5.18.8)
No metric fixes found.

## Test result summary
total: 120950, pass: 109794, fail: 546, skip: 9999, xfail: 611

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 307 total, 307 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
