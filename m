Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330B4522BE7
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 07:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiEKFvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 01:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbiEKFuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 01:50:54 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F361165B5
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:50:52 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id s30so1917165ybi.8
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i/cmIo8hUUQB29G/bFPFhyTqE0aa42/t3jwUy676e7s=;
        b=PEKY1QODat+pSynvEbn5vudpvOgJ5UivB3aa+dBsz9LwnspE0wvsCD1rBSfssX0SQN
         Hw2o96HEoJljKYWdPKnc/NITeXpfTtdzwDIVXp8Ra2rM/Niozak1TFwtLqDZ7HXR84ri
         BmOGm4QmQaPxPtcGYGqg3QB5/e5uXGOmjm3pL/wkZtGBEL+DxEecco476rp01W7vKdfs
         c8vcz9owwW2hFSoDmQa1TSrZMOCQQJrIa3/Ii9ThCnldZKsuAXFcQHXu43xDEgFzWfJ4
         5xNfQDCHNcfZ2ai5Y3SchsZdltYaziqo+IsHiFUbu3aDBwkU5zuDF8xsV4EfFR1/WuLc
         bEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i/cmIo8hUUQB29G/bFPFhyTqE0aa42/t3jwUy676e7s=;
        b=CctbDNhmHfDSRRWIop/o7QzkRfyegLzkaE8lJky4AcDd2R/0JXm/vb6AvAV8/ssAGL
         fHzv/0oHy+aksQOQhAcPkZebG8a5BNcTo1H3QS2sawG2uQVTMqMg7A1i1099IoWv4eUt
         lYra6To18OpQ+6k7uY9fq57W7vABjKzmA6CzW/G0W1qAXkzUxvYyzm277GV5jML81hFm
         XJeUi6WdHsVjJ8GwGSbKLZrTDtbKRxnOmGZ0cPhwAKsxWDBgjr73EktkOJW3K/emUyPx
         Vij1WYEj3wtnMiFJSaSxjD6jj6iGrjrr6LofaqUh73zJC9LD4pvr90AIO/V4BlwlSgdR
         WTug==
X-Gm-Message-State: AOAM533LMAswVSCq92O9dz58tArzoQIrCjTTTOt60nNVcv8jqt55r0G2
        v9VI8jrKFE5tzCXh5DfcLJ1VCmY2ZLT5V7dYD0rvUg==
X-Google-Smtp-Source: ABdhPJyle61m8Y26NS30DOixvoiCtG0BEYxkH5OFZr2v1bKtkdITdjswXJueiMdAwp+DVsOQje0HWXSOUNhFPrqBe0c=
X-Received: by 2002:a25:8045:0:b0:64a:8419:28d3 with SMTP id
 a5-20020a258045000000b0064a841928d3mr20430735ybn.494.1652248251303; Tue, 10
 May 2022 22:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130732.861729621@linuxfoundation.org>
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 11:20:39 +0530
Message-ID: <CA+G9fYukXF8L0bFG4tzWT8SeLW+Z9JjNgL5K9kQnO1Q0pkF9FA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 at 18:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.115 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.115-rc1.gz
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
* kernel: 5.10.115-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: b2286cf7a6972650a6163f327d11695fa11ef6c9
* git describe: v5.10.113-201-gb2286cf7a697
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.113-201-gb2286cf7a697

## Test Regressions (compared to v5.10.113-3-gbc311a966773)
No test regressions found.

## Metric Regressions (compared to v5.10.113-3-gbc311a966773)
No metric regressions found.

## Test Fixes (compared to v5.10.113-3-gbc311a966773)
No test fixes found.

## Metric Fixes (compared to v5.10.113-3-gbc311a966773)
No metric fixes found.

## Test result summary
total: 97056, pass: 82218, fail: 649, skip: 13165, xfail: 1024

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
