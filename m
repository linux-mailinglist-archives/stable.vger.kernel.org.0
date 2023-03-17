Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20C16BDF08
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCQCsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQCsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:48:43 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB064E3B0
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:48:40 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id v48so2484086uad.6
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679021320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYp3m8qSQa5jXzR5wJFnI7z+muhy6wYlNR657/7Bnzg=;
        b=ycu67eqcQEPgZswh2Cw/GXk31IUlyBm+M3+fkuMlB4e7MI6+UATgkJMbbYegOYFapi
         BmqHChU/RV4zmv0sAxenIy+3ZY/fFI/72dQBIDmtfX0MzxO0G0xzqFll48mRAT1zM4/C
         5FYxe6jBmtKecVvtBK/ArWu/xqxIQyrA1SZgQcntjNzxIVX0T2S2lxP1+kliwp7qRDnW
         nps2tGSlAaoHFT+0bVwQCouCt/DEJf6z8AXZvnYmXgPR+mZLUGG7iS5FxQlPqC/gFRVi
         vZV6Fibifj6T9UqvUgn3izcUygbfTv2XWWn+DMlekXfnN9yz0nYPrHykyBOJIWjW7/TY
         uCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BYp3m8qSQa5jXzR5wJFnI7z+muhy6wYlNR657/7Bnzg=;
        b=rIaIY6+RW+s76FBr+UwCARQCQYBww3pPm/WQtWPKNS8UX/mDWyRb4YhD5BS4dRzbu0
         Py+yTRjr/eZLxnRpMPZexp4A2ZuCuL+7tbdgWqk3+mSn8A20Qb6hUA1jh8WwHKXJQWh4
         z19sjbCEedD+RsY40C0cTo+5IvZQTCmbGgpLMm+OOaNGHjgr7u36181xpq1PYyYlLGti
         aXZbTULGinSB6T1KoA4YTk14pFxL1QKN+fUgLHvzrVxOw4ohJ1sGUhoP7Ch8wPGjWkhN
         6aFhE6ySyelFEICkGcLCSKTz74yaGmp/+cCP7jHp8a7GFM77IK4zYSyUqtSyxg0lOxvI
         kRsw==
X-Gm-Message-State: AO0yUKXnOJCgLtWNxJJGwRnlpHaISt9RNZSNNyr/9F4Fx+JyrQFQlQuq
        BQERO3IJ+n4d/F+kP3Zg0XePDkePXAumk1zD3GKhCA==
X-Google-Smtp-Source: AK7set97lVkSZa2tyXvZpdqEKZCD/CoIOD+RSGe4K+VNXilfJn+/bnGbfxki6kJj/BghsJXL2d7EVUztTmFJDUNUO1Q=
X-Received: by 2002:a1f:a913:0:b0:435:bf4b:848b with SMTP id
 s19-20020a1fa913000000b00435bf4b848bmr942018vke.0.1679021319962; Thu, 16 Mar
 2023 19:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230316083335.429724157@linuxfoundation.org>
In-Reply-To: <20230316083335.429724157@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Mar 2023 08:18:28 +0530
Message-ID: <CA+G9fYviF4qnLe+i1a3VnwsWWwcENYxH--2WbLSMDkZL-0Y-RA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Mar 2023 at 14:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.310 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.310-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.310-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 12379b7d143a8f0f07b4c069202ed684212ecacc
* git describe: v4.14.308-25-g12379b7d143a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.308-25-g12379b7d143a

## Test Regressions (compared to v4.14.308)

## Metric Regressions (compared to v4.14.308)

## Test Fixes (compared to v4.14.308)

## Metric Fixes (compared to v4.14.308)

## Test result summary
total: 72731, pass: 62239, fail: 2894, skip: 7289, xfail: 309

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
