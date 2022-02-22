Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A604BFAEC
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 15:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiBVOaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 09:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiBVOaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 09:30:24 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576D4149946
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 06:29:59 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2d07ae0b1c0so175799047b3.2
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 06:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ex7IMBlE4ONDpsQe5AW/htxkuLyXiLoSJUGFoz3TYiA=;
        b=RAbSzio6CQUMlZvch5mL0Vyahb0A4DtHPl5lgYT7GKPaAWbjvQt30z0mO0btZf4AUY
         0bkr+PWx2m3HeK600X0usYZLjK1SG//3pNsp3hQxcq9AiP4L5hJ8mjELqO40RmHUi6zX
         q0j8RZr92RoklahyrT7o5HUjASqOCDSGCR48O3Aofzh8dIamZiCCjvX6/rfRiplBk6iR
         FdnV/lJBT6uenm9MsIQl3dfRhid0BCXBHE4Ax4UuqKS+GZqmH/Qr/Id4/Yi2hXToi6po
         r5yMgNF1ue05zPgBBDbjbBDFY2xWoqhG1qMnTLcyWFIanRGKcYu/sWFPkjUcVrzPn9w3
         47Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ex7IMBlE4ONDpsQe5AW/htxkuLyXiLoSJUGFoz3TYiA=;
        b=U74LyQv6jCLsAYpHbjB5kilopcHCelk+gji1vafVxy9yNAmb05gSVN1YCPmlOJyJwV
         SPtUli9Uv2uHBCBKcQMebq7APd+cqgsnczerWYipFmCSUdH58X3DHDFrJ9Y/DU+c12Ku
         c7W2aUJ3kIF4+FEIiZcecW0lTm+ZvxM3/ERyLnJURTjcBNwjdKhvVNKU/fa3i4R3fQWT
         LGui3NNN9HzqT14FWBePjUxL1TTcSxRjqMmsDAlVhFXcG2xRAHl1ozsvdrCJcjUEBjDP
         hDuDECWf0cIyPo/xlWQBu0lCFP6H0Z9pSNLYTK7tXcOxBT7cmmnEuo0kB+JX06oKwwI2
         yQiQ==
X-Gm-Message-State: AOAM532R4PkkzA05vKkF1oL0MUY66+sNYCPL9KU7SKmCPq9ilwB7H5tU
        2U530+ldmfE/1Y6ERsTw+B9o4wHNHYbSVlqknjMe1NHLDMSPOQ==
X-Google-Smtp-Source: ABdhPJx4ijkW7EXThE7IEUkuoMX94fseTVCvyL5IB0jVI7NHFnm8gUlDuA7v0EB1SpUWMQV6fGMeZ8hrRuUQP8TDxTU=
X-Received: by 2002:a81:1008:0:b0:2d6:58bf:80d5 with SMTP id
 8-20020a811008000000b002d658bf80d5mr23462032ywq.441.1645540198361; Tue, 22
 Feb 2022 06:29:58 -0800 (PST)
MIME-Version: 1.0
References: <20220221084908.568970525@linuxfoundation.org>
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 19:59:47 +0530
Message-ID: <CA+G9fYuXOjvWhfxP7tCP+K764kC2nFMwO5mDzHtrEGFzEprBtw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
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

On Mon, 21 Feb 2022 at 14:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.303-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
This build warning found on all architectures,

> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Do not report writeback errors in nfs_getattr()

fs/nfs/inode.c: In function 'nfs_getattr':
fs/nfs/inode.c:693:1: warning: label 'out' defined but not used [-Wunused-l=
abel]
  693 | out:
      | ^~~


## Build
* kernel: 4.9.303-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 6686f147d38ff2b3ffc43718976bb9ff43c5fcc5
* git describe: v4.9.302-34-g6686f147d38f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
02-34-g6686f147d38f

## Test Regressions (compared to v4.9.302-27-ge4a64678c410)
No test regressions found.

## Metric Regressions (compared to v4.9.302-27-ge4a64678c410)
Build warning found on all architectures
fs/nfs/inode.c: In function 'nfs_getattr':
fs/nfs/inode.c:693:1: warning: label 'out' defined but not used [-Wunused-l=
abel]
  693 | out:
      | ^~~

## Test Fixes (compared to v4.9.302-27-ge4a64678c410)
No test fixes found.

## Metric Fixes (compared to v4.9.302-27-ge4a64678c410)
No metric fixes found.

## Test result summary
total: 55842, pass: 45907, fail: 274, skip: 8635, xfail: 1026

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 2 total, 1 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 30 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
