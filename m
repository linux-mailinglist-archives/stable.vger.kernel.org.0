Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDF84B1446
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiBJRcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:32:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiBJRcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:32:15 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9060B2647
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:32:16 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id bt13so17634689ybb.2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SXrIU0KF7XQbWElHa5+P1F1VqOxsWYp0GX5PTkvqWDA=;
        b=IKsCT5qEat5N1zAbDiBeTk5+CvLoBm7v7lFksnZcBLU2YmD/pmN7e1vpko/hSYsL8S
         XFryVF1kDyohLcORJ5R5Q3anyra60YPgScW3mYToKIjSWOSmpICzfyCU2DzbsSDxvn4r
         EhC3Gx3FCFXAD+xRBhuIYAV/u6es9Ds96kFHA1+y38j247IiWZbc6lkrj88MqEtIQLq9
         JPpDMST1R4GEFfmOTlJtb+sd+jBfoLQSEUogJpcPY3MlrUpsxRhppclBU1aQCaH7BsLU
         uPA60qiZhsUN+JQnVU+8Rv+RmOx5170F1X8IukLHjQiTY8+dBTtWPQAbaov+noeMOHM9
         P5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SXrIU0KF7XQbWElHa5+P1F1VqOxsWYp0GX5PTkvqWDA=;
        b=UjWgAsCT+wDVBomh5fLMJLFWN7NWqV6HiFf4Aml6L8VEvOsOcIs87ZlqUGzd/xbRt0
         wVOdUTcqF34KUmL/I7aIIjx+FJDkajpZl/ySPCWC0D2PLZtibBUmuZAxnGO6bWnq9xri
         ze521HUXv9C5ROfQqz+km/8TmSJLHKYOKcM0KIm9F2mzIf+i0iu0++2Q9kuZl1Uwx6fw
         VMQrEdP6Tun0kxYqn7XahmjOuRGR/QmJ6Da/GxuGNzmGLZ+/Za2eB1CAPN2mxwi6RGgl
         p3N2l4dSC8T+SN1dI7Kj/Zixjz4T/UvKCE4dKOEmybgohkixl1+GfJHfBWxtN8AB8kBr
         I6Ew==
X-Gm-Message-State: AOAM531WwpbZVejKkmbkpP3QUoxSwD8xwm4kQ0PqwaP5XKLTNGT4v+FY
        Lr5svzqO5cgyjASH/E6qz99rRbpHbhyPZWe9sUcmtA==
X-Google-Smtp-Source: ABdhPJwOA96Lsd+Sfqv1ezk7PWbVHc7qqldIHtgqpu424xlt5qxZU7CJHZx1Vnu8yEhgGlqthn+gTm68os3+UMP6RMk=
X-Received: by 2002:a25:6b45:: with SMTP id o5mr8012071ybm.704.1644514335602;
 Thu, 10 Feb 2022 09:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20220209191247.830371456@linuxfoundation.org>
In-Reply-To: <20220209191247.830371456@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 23:02:04 +0530
Message-ID: <CA+G9fYsU-QiGaMywK59ASF0+jrk+Vt+3QWRA738KxgRZfVX5Gg@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/2] 4.9.301-rc1 review
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

On Thu, 10 Feb 2022 at 00:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.301 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.301-rc1.gz
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
* kernel: 4.9.301-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 2b86ebafad46c4f70ed4fbe3a0aff9c3e9b61763
* git describe: v4.9.299-52-g2b86ebafad46
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
99-52-g2b86ebafad46

## Test Regressions (compared to v4.9.299-49-gfa39f098578a)
No test regressions found.

## Metric Regressions (compared to v4.9.299-49-gfa39f098578a)
No metric regressions found.

## Test Fixes (compared to v4.9.299-49-gfa39f098578a)
No test fixes found.

## Metric Fixes (compared to v4.9.299-49-gfa39f098578a)
No metric fixes found.

## Test result summary
total: 54263, pass: 45234, fail: 188, skip: 7979, xfail: 862

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
