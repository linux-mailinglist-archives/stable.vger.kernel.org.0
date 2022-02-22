Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B434BF249
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 07:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiBVGz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 01:55:29 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiBVGz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 01:55:28 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7251D1111A6
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 22:55:03 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v186so39114619ybg.1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 22:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kZ+z7z5jkXrVOgWExbRH8CnuhmCJH6zCkVtZPJfQyF8=;
        b=b/1GzdEp9juhNotzf7IjR9vSCN8XW7D8zTFdOIK9Q07kYMqNwtBG5NBgsrVxtajxvt
         6g+qOo8/EOYOuhjsnaqMpho+c/fJEG+pScQ3ILJsSUdq/TUOYQvBOZhWsEWxjhsFGbX+
         f8TiVWblYBXT4ooryjYLIubZQo/lAt0zikFYCjUICTcCht+AiZ8yQdIK/F4k5XrOwroU
         V3jU4VPbhEmRqUihpY4mFvwdw1qeBjr5yKEOL4z9ZQCexXLUot3R2alKaW6DfDYA6TbG
         0mzFZumpZvgh6u4hcIL4gu3zUH1lCiv8mmM9w45zT2xs1LaMt5Z74nsHYQ7nCujTXDoS
         WDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kZ+z7z5jkXrVOgWExbRH8CnuhmCJH6zCkVtZPJfQyF8=;
        b=oVIEMulgDjih8+ORjXFFi+4hQd+j8mbggkt7wSWDP4UxCwHLSx5RgQqk7NqV5PFwVQ
         T6Toasgk8ArKhK3tHl36xHF4T/CAMtPIu97F/6DMGWt7PbaYCb2l4EkFToyzmGms+gKo
         PtXU81iTvFhITV75TGHIA1pxUPvo0OIf8UeuBjj3HGjoLUdAJqewYO0hAiMDzBu6ApJn
         lQbl7KRrRBLZgpekApGx+Pj+eGy+JmXP4imULoYriX0wclb2MMr/uuEz4VPmE+8tUZa8
         CNlz3Iml9d9L/Zsk818xQJosWyscIfNJsJ/B2ehY9WrcT9wrPTgDz5MF3lYYRee2OaLt
         O7SA==
X-Gm-Message-State: AOAM5339BZ2G2VVrwenWT8UDnccWPvCeiHJ4ZO/IEua0ob71LVkqyWYc
        9Jykq//zOqPeDbj390i0oQu3rOMAFEVfF4k+r3BcBQ==
X-Google-Smtp-Source: ABdhPJyshg9nNZA/OGCbZRmV8tsQQ2L61yFht0DUghUx1haGVPWzRMReaRq86jxtRHLA7kxMMps7EUEmN/wiz6SsiVQ=
X-Received: by 2002:a05:6902:284:b0:624:1c25:cda1 with SMTP id
 v4-20020a056902028400b006241c25cda1mr21281601ybh.480.1645512902488; Mon, 21
 Feb 2022 22:55:02 -0800 (PST)
MIME-Version: 1.0
References: <20220221084915.554151737@linuxfoundation.org>
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 12:24:51 +0530
Message-ID: <CA+G9fYvXCoyAK6iwr+sjt28Va3vWA7dsmWTAbou1T6x+mKd2=A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/80] 5.4.181-rc1 review
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

On Mon, 21 Feb 2022 at 14:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.181 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.181-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
arm and arm64 build warnings:
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:637:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  637 |                 rc =3D rc =3D PTR_ERR(ctx);
         |                 ~~~^~~~~~~~~~~~~~~~~~~

## Build
* kernel: 5.4.181-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 04ffc48b9c61bf5eb49daca8b489e326d6aed975
* git describe: v5.4.180-81-g04ffc48b9c61
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
80-81-g04ffc48b9c61

## Test Regressions (compared to v5.4.180)
No test regressions found.

## Metric Regressions (compared to v5.4.180)
* arm, build warnings
* arm64, build warnings
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:637:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  637 |                 rc =3D rc =3D PTR_ERR(ctx);
      |                 ~~~^~~~~~~~~~~~~~~~~~~


## Test Fixes (compared to v5.4.180)
No test fixes found.

## Metric Fixes (compared to v5.4.180)
No metric fixes found.

## Test result summary
total: 88681, pass: 75229, fail: 519, skip: 11581, xfail: 1352

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 32 passed, 8 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
