Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E13506750
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 10:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350240AbiDSJAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 05:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350239AbiDSJAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 05:00:52 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D0726575
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 01:58:08 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id h8so29782823ybj.11
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 01:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uWhCip3fDG+TKfDmUA9mehz6Jb3Xj61Z8RdZMlRGon0=;
        b=iDcuFfwBYw9X3d9HgY5iw1gY5PHiqyUz9JBw2zZdRma71kKPpUZz0A073IqA3rHUBP
         sA9f4K96C4YwGXHh2fQGQONjOCOSUqC4hjIre3CG4Nz9WJ9htyp2mj/U6duMMSG3RoXD
         th6MCk+aAL7C4XFf1t1skOf53huJk7xCQNcG0/3v6N7WaSoiDJu/+DGJ3tM16GexES9n
         iUak44zKRRamCHIBRWXm+JuLABWzmNV8yB16o/9XIQF9+7dd+rQ0a01+34chFeqtVofg
         oCHZHTuupSBkjR/kox4y3wKR35gdbR1DA2chrSzAgSIWi0N4UVoDiL096hNcdtKukEyI
         wrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uWhCip3fDG+TKfDmUA9mehz6Jb3Xj61Z8RdZMlRGon0=;
        b=AuSLgfy6AXU82DiE0yJsk4muV+J/O61NauOs7L6fFFW+KFN7mXa2xlCx8N2CJbpGF1
         +Fl788vwRTbUYz0/lIoTdwBJT+ed3n2WBww18XIRo3KQxTuxNOS00QLVuY2CV8fwdqVT
         Tlla37h1RvA14BdIqrdqXnv4THZphHJBp36J+qIgbLWuZnHCaD4GAnds2V77PupB34QZ
         fvmX46cGA8EMf5zRmgTFkTgawa4d82sSVyGspad4KXm6s1HVUSpgyOC5xg9qlev8Wrxh
         3arhewfh86ECZ/FFyG5ikt0LBfs7C+pIrlTifI73tvPxMYBNZf9FsMCVEpJKA2TUhByG
         qowQ==
X-Gm-Message-State: AOAM532gFKc8HKmWNN8fdZzR3L2kKnQ8ra9I6QgXdkT0sPuJke1P3c36
        v4eeE6soQ5B2GzPk6vvpiIuIU0Db+atY6s5KWJeccQ==
X-Google-Smtp-Source: ABdhPJzE/mHSTlzY9FXXPUOZ7ZDCq4E5Vu5+G5BSF/gHwXlGTgo7NddRvJ/KZcHlHvHIcWDKItyqs9abojVR1wru6jY=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr14266932ybn.494.1650358687447; Tue, 19
 Apr 2022 01:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121127.127656835@linuxfoundation.org>
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Apr 2022 14:27:56 +0530
Message-ID: <CA+G9fYtWXBGS_Dysadq3SsXfZeEbj+VQQOXwwfLBNA4cXkvotQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
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

On Mon, 18 Apr 2022 at 18:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.239-rc1.gz
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
* kernel: 4.19.239-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 6124afa49867cbf9d4266132d020c7bfd11b768d
* git describe: v4.19.238-33-g6124afa49867
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.238-33-g6124afa49867

## Test Regressions (compared to v4.19.237-258-g1376b0e9d231)
No test regressions found.

## Metric Regressions (compared to v4.19.237-258-g1376b0e9d231)
No metric regressions found.

## Test Fixes (compared to v4.19.237-258-g1376b0e9d231)
No test fixes found.

## Metric Fixes (compared to v4.19.237-258-g1376b0e9d231)
No metric fixes found.

NOTE:
kernel deadlock warning on x86 with kselftest merge configs still noticed
this was reported yesterday from the previous stable rc review [1].
This needs to be bisected.

[   18.504172] WARNING: inconsistent lock state
[   18.508451] 4.19.238 #1 Not tainted
<>
[   18.691758]  Possible unsafe locking scenario:
[   18.691758]
[   18.697689]        CPU0
[   18.700137]        ----
[   18.702586]   lock(&(&xprt->transport_lock)->rlock);
[   18.707562]   <Interrupt>
[   18.710184]     lock(&(&xprt->transport_lock)->rlock);
[   18.715335]
[   18.715335]  *** DEADLOCK ***
[   18.715335]
[   18.721270] 2 locks held by kworker/u12:3/60:
[   18.725633]  #0: (____ptrval____)
((wq_completion)\"rpciod\"){+.+.}, at: process_one_work+0x1e0/0x6c0
[   18.734711]  #1: (____ptrval____)
((work_completion)(&task->u.tk_work)){+.+.}, at:
process_one_work+0x1e0/0x6c0

[1] https://lore.kernel.org/stable/CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=3DpbQV0=
kDfbOX-rXu5Rw@mail.gmail.com/

## Test result summary
total: 83824, pass: 67955, fail: 882, skip: 13136, xfail: 1851

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
