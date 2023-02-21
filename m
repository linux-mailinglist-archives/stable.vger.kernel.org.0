Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E5069DB9F
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 09:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjBUIEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 03:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjBUIEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 03:04:09 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6713DC0
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 00:04:07 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id u5so2088148vkl.4
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 00:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676966647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmfqPmpMWyaMOcuYahSH/dCv2pAEW8+BXkyBTQ15vt0=;
        b=oMIiqrvOFzGZlxiCakUf/YAbSwsGpp5dp7Fjk/ebmejBIv6llCgF6JFEMdaYGds+Jw
         NoPRMv7pDthBtfifjrrs7aLB9LqHzWfwvWHVKqNWY0iZ/sUtGx4ppgpmYxf7bszfNrsH
         dd+/hiI0hibMXLQuUROjl25CBDeM5pPstFbYgzvTK5C0irp4DpmTFtSRMneFc+gZm+0S
         SbMspbTXQWtDJO0oiquH8jl7IRKfA9/g1muBlYX5P+0rXN/fk+MVbIWj6rH8jLvRw4h7
         O/BDL5GEpkJIdpNl6+iD89EGUkPOcvdygdtiUxGYNEtKfEfSoaqkgOmufsSmII8MayyJ
         hupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676966647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HmfqPmpMWyaMOcuYahSH/dCv2pAEW8+BXkyBTQ15vt0=;
        b=yasmdsfKvpbNMGW2yo86bVUzZ84aeWhwpKMt0GCB9Xqks67xCN/tY/EcSTlDPIHVeb
         PmAAzOYWEnHrv34XdFKw2BxXSCeTMjTHCvpFqRggX5NM0+ARqIrP6vbKIf+rVwaIzv6C
         oovPNqH3nkYKseY7QS1BfyZXx2l99CJ/iLcylq8BPHKkHKjPdPylVKXOIJUR3R8ylYPc
         r+043bjaoFfxW22gp2THL9mkGvsOjSEroR/Thqu4KfAZMrj37OhJ7n3VBAJfcfOX7/0n
         yh6qyOIKvT+5oz2OX8HhtD7yqK51gy/6pvPidIp1LvXe+jG40UuKHYGRvomkh1gslH+z
         p0fw==
X-Gm-Message-State: AO0yUKVANQxZg+zT/rcdKDOQsv8UmilouwC0T+22bG4npiDWmAXCBNid
        SE5fY2r3kWMfgRRqBiUI83+3Uam8UlxEIGGs5c3YFw==
X-Google-Smtp-Source: AK7set8yw25wraGSsxotVN40tBfgg33dL0WV5vojf1INXxEKrrvzXg7y3UeuYDxKCrT2dXOHll6aSF8wF7mpeGdEoVw=
X-Received: by 2002:a1f:2305:0:b0:40e:eec8:6523 with SMTP id
 j5-20020a1f2305000000b0040eeec86523mr316005vkj.43.1676966646867; Tue, 21 Feb
 2023 00:04:06 -0800 (PST)
MIME-Version: 1.0
References: <20230220133549.360169435@linuxfoundation.org>
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 13:33:55 +0530
Message-ID: <CA+G9fYuYzuHXG9+MZofYziim-nXq6TCUtJ-GdoE5Jue-P1cQqg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Feb 2023 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.169-rc1.gz
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
* kernel: 5.10.169-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 7d11e4c4fc56eb25c5b41da93748dbcf21956316
* git describe: v5.10.168-58-g7d11e4c4fc56
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.168-58-g7d11e4c4fc56

## Test Regressions (compared to v5.10.168)

## Metric Regressions (compared to v5.10.168)

## Test Fixes (compared to v5.10.168)

## Metric Fixes (compared to v5.10.168)

## Test result summary
total: 156525, pass: 130423, fail: 3439, skip: 22346, xfail: 317

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 11 passed, 5 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
