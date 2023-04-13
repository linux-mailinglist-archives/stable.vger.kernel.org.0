Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A645B6E0FCD
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjDMOTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 10:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjDMOTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 10:19:19 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED88AD10
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 07:19:17 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id y17so13549743vsd.9
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 07:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681395557; x=1683987557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JMq6toJf1p8+FJqvO30zeMEqgB6/3hHtzaX5I/xQvk=;
        b=r22ARAT1GI2yPifSGfXJABpXDqZDcFJ9GWQF/LOrx67vf3wFFk1b/eijrl/pjzusLh
         UumKBTMJW4p+IfSbXMyi/o/JQUpQ4F370k5nb1PBzAfC/0VZDn5061PHoSbrnQy0/B8W
         ym4bsT701/uqHsUY+ZR6BlHQMS9t3w2VC6j+s5RWuM/AGLQhBizkNyydphgdfDIExw4A
         siVnA6bsFMd8/PnMY+0EWU5+XmMoU0ZXo4Os/91dpqNhlQPOXuAsz+rSviqPpr38tHaL
         idQLZmLMB3WhPMXHkUMqvr3vYrcv0Zi13y4tH8+cE7zzE0GqDQd5jb2jWBIV0McbUp8g
         YYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681395557; x=1683987557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2JMq6toJf1p8+FJqvO30zeMEqgB6/3hHtzaX5I/xQvk=;
        b=iYqRiEKnDBccQN6RprVtW2TWamqHnlba5KGNwHKtdDiSRbUM1hGyKSY7xA7QKI7lJa
         qmksr7ixZwrf7J8mmtys5RFWAodOskOllRZW6u6N2vw3n3eNoPxFEHOf9x4rzr099o2I
         MS9BP+CKknxaO3ClEDZBJabpNZc0sZlllA04sUl4dkgkILtxrsD4h5JvM3U4wrLqignC
         eQwnVcQ4ooZgf4FtmuDMWI7Cfa6QX0jPY/BAg+NVT5sZxvQ6YDAK6MdKZ7L2GD7DEdWR
         BFaK4K06p/NZsaC8amn9CQv8/2rTEXJTmJB0VQHRnTtNVXcc+uMzZ0KKdR5K4eaeGyud
         MJKw==
X-Gm-Message-State: AAQBX9fTb0H3RFrRWPu8QKBY1blrWyQIpP4LJbZjXQG0JLfzH3/vOstM
        wdQNwR+sUHIbcfDAggT3lAahe1ebpALAp6iVIR5ajQ==
X-Google-Smtp-Source: AKy350Yjdj4XSrnhhqvpL7qdBXV9QQCtGim6VlAApbROCfLl6IiNZ0PzlrC98EE5i/ex+leZjuqlXcwDm5SwVL+tm7Q=
X-Received: by 2002:a67:e109:0:b0:425:d255:dd38 with SMTP id
 d9-20020a67e109000000b00425d255dd38mr1404691vsl.1.1681395556644; Thu, 13 Apr
 2023 07:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230412082823.045155996@linuxfoundation.org>
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 Apr 2023 19:48:54 +0530
Message-ID: <CA+G9fYsnf3Q-45h_hyLkfsVKEFkXqcox1kAW9OppV-yAM2YiEg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
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

On Wed, 12 Apr 2023 at 14:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.107-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.107-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 415a9d81c640534731472ca364ec9cb77008a8e0
* git describe: v5.15.105-194-g415a9d81c640
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.105-194-g415a9d81c640

## Test Regressions (compared to v5.15.105)

## Metric Regressions (compared to v5.15.105)

## Test Fixes (compared to v5.15.105)

## Metric Fixes (compared to v5.15.105)

## Test result summary
total: 126997, pass: 105591, fail: 3746, skip: 17417, xfail: 243

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 114 passed, 1 failed
* arm64: 43 total, 41 passed, 2 failed
* i386: 33 total, 30 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

## Test suites summary
* boot
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
* kselftest-net-mptcp
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
