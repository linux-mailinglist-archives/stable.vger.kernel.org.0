Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7852C67180D
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 10:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjARJnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 04:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjARJnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 04:43:07 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A003676E3
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:58:56 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id i185so35012545vsc.6
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBkTbFF9aWlMGtV+OPGHuf+HNY2wlnat0pDhkhBjc88=;
        b=q/4nsWsMhxCZhEedY6SE87FQhU76ETSz8iZHj7SSitYii6hz2Q5oV0U/n+FkhmezpQ
         UhMz09BHcsg4rUQe6eHBeGOuhvxQ3kPBQJMjMxLer1p1+lyZyMuAAjztLMjBUw8BADKJ
         kEuKMETYF5mZYKN+1xI6UJc4wtURU9jqW7VyE2Iu5gDUbaW2ezKZgkfye00hNgMHGtGT
         +MJ6wKW+gwiwADZLdLi1QadSvc/8tkjE0cQbBjjs2Zdy8SMSrv2UJHY5YRUI1MyF7Ncm
         NDdYNpnfwki2xZvSTYOpQC32nmA2q2EKEAritXmodJSIeNfqBicaIzerRsU8MScy55PT
         STgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBkTbFF9aWlMGtV+OPGHuf+HNY2wlnat0pDhkhBjc88=;
        b=0pZMYfyayBjxTSOTOXUBTBBtbNvrfwqPvN+dLG10JK+cpaglF1iE3Ph8LSvX0grEnb
         zKlRSEq0yFevn6LvOV84DyrpKmga7JT/7lK2eL3vBdyXgSoAPyuWkuwwgna6awpvvNjQ
         FIelS1htXD5BbAMABYHJ+Dakwd2MCF6s98lrTPfwqlwXxyHPLT4Bg4ydqIycVRcm+QRR
         ZOPca1LiahOetJI4W+Jfj8KidjALvBgNwJBjlPktzT+OE2lrkLWd5+y0Hb5btZZixK1f
         lMPCKuypL/pAEE7N6PzcPTQm94xsH2Ye4fqbuc/nFJDAfK2vdjhndKHp+/wAE0/iyNTK
         5HaQ==
X-Gm-Message-State: AFqh2kp1aeo+e1iAqFTFSC8hcqlzGxYh8tTVaak58h3P6y+uvZbpajQF
        LfilRSNGHkdh/duj58hHdskcZV6bwTBSQOfo6YkTWg==
X-Google-Smtp-Source: AMrXdXsyNEMyAZsS8fjeKKM+rIp55VKD4Emx6DelbC6BqI5a72ndd9EcJS9Pbz70s7rrpyTc+lzBteSrt9PtSUeqnvY=
X-Received: by 2002:a05:6102:4425:b0:3c8:c513:197 with SMTP id
 df37-20020a056102442500b003c8c5130197mr817879vsb.9.1674032335895; Wed, 18 Jan
 2023 00:58:55 -0800 (PST)
MIME-Version: 1.0
References: <20230117124624.496082438@linuxfoundation.org>
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Jan 2023 14:28:45 +0530
Message-ID: <CA+G9fYvbxa=vH+Er4m3i=OgiwKtOCRr=uExCjDs3tnpxMmeeXg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
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

On Tue, 17 Jan 2023 at 18:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.270-rc2.gz
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
* kernel: 4.19.270-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 2738270a87607b0fe9d198d07d8866c75892149a
* git describe: v4.19.269-478-g2738270a8760
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.269-478-g2738270a8760

## Test Regressions (compared to v4.19.269)

## Metric Regressions (compared to v4.19.269)

## Test Fixes (compared to v4.19.269)

## Metric Fixes (compared to v4.19.269)

## Test result summary
total: 112688, pass: 84899, fail: 3443, skip: 23978, xfail: 368

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 316 passed, 7 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 47 passed, 6 failed

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
