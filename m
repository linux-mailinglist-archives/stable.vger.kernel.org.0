Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7584D1C9E
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbiCHP7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbiCHP6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:58:30 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C794950458
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 07:57:12 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id u61so38638388ybi.11
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 07:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ivli1yNVzu/BVQSOyUimOD2b+2+dda9CCsU8uGTbCP0=;
        b=p2+11DZVCYoklN8jXeZDOZDTzL2R4ogOloB6z+XmLWAjmm/2RoT2clIoFp5OCU4Zee
         IjK5hIxKDmYG6Dp7KvfWlYi070k9IKnbgXjc9mwswDkhQW/8TdlrWozMZtqeEyV8JYg0
         xABORydvDRXWd6xLMTAlI8JY0TBDAIVqAYBvMwOLrEmaEIr0OEH1RLrsjboQxYRYDE+F
         4Mncch8obm8tcpqzgFF5Xg9+5EwvtAsdoJwDJ0l//Yg/3Nan2cwnhuz4BZxqKulMT/Wv
         PuRk52VaragZ0JSXD1FOXsHtR3AMLmnq2eDturyzipCPSfRKCcQD9QHr20NT+0Yc/vDT
         lh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ivli1yNVzu/BVQSOyUimOD2b+2+dda9CCsU8uGTbCP0=;
        b=VuvmZCiAi93V5blUWod3Dvxs9TMMZ10A9+5pcVPJoNTJAdJIggRFMd1ZAml/qhkkfO
         BiY+jR9C1pij71ktYtqa72AweIIwUuldZahiVPIuQS+8AvdrCtVzOCdldVqZ2Qt+y/hx
         RJEdMSkyJYGgB9LmQZHz25WMoIKtlhPS/rYsg284EcuzMSU1/xgaE67SN5PKSSi/nIM6
         GeyKRkYDmkk9FQ7AW0An/aS3ZmEVXjHWGfhZ/6qh6M0kN4onNonWxCXF5Cw1DHvstShV
         PKzSqDKG5l9C/SlfhN+PWxzwj+Ha8KVthwXzjaLyrZPB/tGCszVdv6/NsLLFegqGYd4p
         9fMA==
X-Gm-Message-State: AOAM532HW/7M2Hc3Q7Wvhh/J/p9/2PKVm9SDHirjHilE3qS6zpGaZetg
        x1fRGaPJTOzbkkLDBYIX7S1JtiypTAGT8WoaQBb7Nw==
X-Google-Smtp-Source: ABdhPJx/rcTLADrrZkKd1h2AAzSOPSiR8P/0H3/GDYIp9prodoFVvS4LRsIiR8GdqldgX0UsTGU5Tek4hH3cKRkUS8M=
X-Received: by 2002:a25:338b:0:b0:610:a221:af23 with SMTP id
 z133-20020a25338b000000b00610a221af23mr12964910ybz.474.1646755031807; Tue, 08
 Mar 2022 07:57:11 -0800 (PST)
MIME-Version: 1.0
References: <20220307091634.434478485@linuxfoundation.org>
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 21:27:00 +0530
Message-ID: <CA+G9fYs3GP9oMpadARzT6b8iFj69Qs0wT5XbFzbd7wK=_dXe+Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/32] 4.9.305-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Mar 2022 at 14:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.305 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.305-rc1.gz
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

## Build
* kernel: 4.9.305-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: d3c7ac3bc77206ec467f48bf73c25596bcb22bc8
* git describe: v4.9.304-34-gd3c7ac3bc772
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
04-34-gd3c7ac3bc772

## Test Regressions (compared to v4.9.304-28-gdc7cbaf71913)
No test regressions found.

## Metric Regressions (compared to v4.9.304-28-gdc7cbaf71913)
No metric regressions found.

## Test Fixes (compared to v4.9.304-28-gdc7cbaf71913)
No test fixes found.

## Metric Fixes (compared to v4.9.304-28-gdc7cbaf71913)
No metric fixes found.

## Test result summary
total: 80795, pass: 63818, fail: 895, skip: 13595, xfail: 2487

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-bpf
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
