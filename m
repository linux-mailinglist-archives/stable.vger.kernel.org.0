Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF124D98FE
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 11:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245553AbiCOKn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 06:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiCOKnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 06:43:25 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E909D50B18
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:42:13 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w16so36332276ybi.12
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RBRCr7uU3fH2EqSR20wPFAXPr+YZgFmaJIQU1dCXbTo=;
        b=rPCXyFW0SHffEjZMJ0XzLDitIuQ7XPV9QSZi6hwMPcDhlPo5titQDw7NSt3ptUMfN6
         7cPDaILbXfud1BxuI/5P7BHpT1v7T/fzOdUAW/ZEos+Jwg77rMDHvvZ+tG8dvF4lTOVI
         zn4BLo3rt1WDJZXjAqQOcLmywJabZwBjO96FZE/ZUBrVuvE3+a+gt5qOBpCH/1mfUa2s
         UjXBh+EsbocCuBP0iHn/9SPdRhyeXXdAHLjJVyiVQpGNKgiKZVwXLqVI8VTVtqcRxIQG
         JtK6/zWQ03wPdEhn1E3xodxD9DNOQfDezzFE3wK/8y96JmoBVs6Fc52Q4PYiZSYAmNlF
         Gq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RBRCr7uU3fH2EqSR20wPFAXPr+YZgFmaJIQU1dCXbTo=;
        b=yUPkHcr/9DX/pKfYrE8gMkcSuXRQDmdgicxISJ9ll8o/6Yl20l+mitPjaa6tOa5iJ4
         69nL+QEWQwDTesq3tThAj/o4f5i3eIq80diqPHtpSJSYEmOZEwxCgw9zesi4fdRm45wW
         GEM63wjVRPCKo++DWoIQS51lIEUPshtoLMlfSCqK0A812SvFK5oltUWX+aIma5HffMBe
         fFxLJvr8UJz/1JcuBOyBKazDiP6JR5rZwxH3NaQwtcZNApyY3XhBgejlHITgFLeB3Ouc
         +iiogE95MtRiyNUzE5HAPFuWQvhsl5u3dYCxUVnDBdoN9Pytz9Dtzue6alZbJ3zNRQM+
         1acw==
X-Gm-Message-State: AOAM530krBtlJtw+0hBqbjvk0aad7XXlTduXlQ4O0h8cihiarnb0V5w6
        iregglxh+/k8KFZWbxNiagMR4zgQbbN7twvD++CYzYkUKZK5kQOc
X-Google-Smtp-Source: ABdhPJxH0m13HNNng/1lAujC9fenSYRd8ear6D9D3g3nBRtXjBqHuOPDP7r5b1IcQcZ7WIbbrcQL7pE+ZyPsCZVY/AY=
X-Received: by 2002:a25:da91:0:b0:628:aa84:f69e with SMTP id
 n139-20020a25da91000000b00628aa84f69emr24168258ybf.603.1647340933051; Tue, 15
 Mar 2022 03:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220314145911.396358404@linuxfoundation.org>
In-Reply-To: <20220314145911.396358404@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 16:12:01 +0530
Message-ID: <CA+G9fYsPHS1qPe3tw6=D_7NRarKUt-qXh0WbSUK=bit8nMVV5g@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/19] 4.9.307-rc2 review
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

On Mon, 14 Mar 2022 at 20:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.307 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 14:59:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.307-rc2.gz
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
* kernel: 4.9.307-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: f465fd2bef70fa2dfa05105a4b87c13fa5fc2b0e
* git describe: v4.9.306-20-gf465fd2bef70
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
06-20-gf465fd2bef70

## Test Regressions (compared to v4.9.306)
No test regressions found.

## Metric Regressions (compared to v4.9.306)
No metric regressions found.

## Test Fixes (compared to v4.9.306)
No test fixes found.

## Metric Fixes (compared to v4.9.306)
No metric fixes found.

## Test result summary
total: 42966, pass: 34737, fail: 239, skip: 7273, xfail: 717

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

--
Linaro LKFT
https://lkft.linaro.org
