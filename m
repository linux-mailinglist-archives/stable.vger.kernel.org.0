Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD8536C5A
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiE1Knf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 06:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiE1Knd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 06:43:33 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3E61006
        for <stable@vger.kernel.org>; Sat, 28 May 2022 03:43:31 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i11so11694515ybq.9
        for <stable@vger.kernel.org>; Sat, 28 May 2022 03:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FbgL72emwjP0xFH7kSpMeslFMM3tXDvdjSR6cJF1QR4=;
        b=H8o4HooNfrZHzNUv5J+fWn2aJ4xsmowNFjnzGmKDX3G30modZJvffRMt8F9Mm/Xu65
         pxTpDXcNeUns1+AznJgli2zV50FnJf/XstZTQ3KbgMlciZkKytqFysdIBUu2uTI89sJq
         gpzxH3d5BMxhxVDL+UiBlGRKzmYsDDtWFFD67kXdQ9K2+sjbxVQFgNMSi7DiKriyD0Ht
         wSM2HaZFuPC62toKkgsPotbKI4/hG2w5W1AXs/38QWliZXMYEN/11Kotx0uA3R/w6oPw
         jMOol7M21+0PrXPX7nA3dWC1fnZGn818IcGxZvN2hj3dvkvQynssaHrfH/z0CuEMK10o
         EgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FbgL72emwjP0xFH7kSpMeslFMM3tXDvdjSR6cJF1QR4=;
        b=V+bEIL3/d6FDnCE054zsV6bpC+P7KqGeKpufkZqRuVsTzbwskGye3vQqU3o9ae1sLg
         CK1oxuG7tnpgYnyyyWsKUbFcGOuIhyxb33O5CwgJwnv7Epa5A4G7PGYKgXDv9Qlr164s
         b2vuSNGeVS5JgFNI3oEf5ehVkundnwb6sW8tLC8NHlCQU4LvtorfIOdcERwA70SCGWB4
         BTWU/x58aYLaH9mx3eIYPx9WJPYXAnFBtdpENlWV4gKv2issQCBM8a5Xunju+9sEB0Jv
         jfsvscyuCdWl+qDcH3ZdYGE2CLhKX2FnMj9aIBxAx1zJX7yAX/lRHcQTpWjUUuT4dtfV
         WL7w==
X-Gm-Message-State: AOAM532ZrmnYpGoHVWdiN8RScGm8N8wCWo4P+3LZn8jwGTqCeLJ2as0B
        QV5cXLuWvlgRu7vnSI3aisdyE3wn2+OBM/SBKkor6A==
X-Google-Smtp-Source: ABdhPJymza40t/XWPE+jUyMPMa+tZAWpftjVAfoqkW2WANAqdZzVEU7NO8UkQHiv7mMSHlScng0InaZSo9vR81CVzUY=
X-Received: by 2002:a25:7c87:0:b0:655:f062:e8c5 with SMTP id
 x129-20020a257c87000000b00655f062e8c5mr16479078ybc.603.1653734610841; Sat, 28
 May 2022 03:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220527084819.133490171@linuxfoundation.org>
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 28 May 2022 16:13:19 +0530
Message-ID: <CA+G9fYt8Ly04LmyKgF=j18w3BGk+6uREqJZgGMN77xQAFpcUcA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/111] 5.17.12-rc1 review
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

On Fri, 27 May 2022 at 14:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.12 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 May 2022 08:46:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: 118948632858649db5531086bb74e586db579fbf
* git describe: v5.17.11-112-g118948632858
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.11-112-g118948632858/

## Test Regressions (compared to v5.17.11)
No test regressions found.

## Metric Regressions (compared to v5.17.11)
No metric regressions found.

## Test Fixes (compared to v5.17.11)
No test fixes found.

## Metric Fixes (compared to v5.17.11)
No metric fixes found.

## Test result summary
total: 97605, pass: 84424, fail: 334, skip: 12047, xfail: 800

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 40 passed, 4 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
