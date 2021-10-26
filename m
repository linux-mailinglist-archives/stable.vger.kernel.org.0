Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8704843B7E9
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhJZRLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbhJZRLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:11:22 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11157C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:08:58 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id u13so17016958edy.10
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qCd7R32fnniXdlIAcpkZUDMU6nES+blfXibgQwBeFfE=;
        b=PNVEORwix3jGXAq/di7wx1XCFAiv5HJVtDNm4w2xZE5VBcSeFAZQG3E1C4QCLhURRV
         IiSiT71/H9HVBoIFJwBRsgeZaQnKnw7AD2LCKahIEGTU9Cfx2DP91MWS8e9XVQGDIiJo
         AvQQvZ/VMKR8dLUWCnW0iEvywPEG86YzsChXnKeHh/ljOi0yiqd0nqi617BDHwUIfq1T
         LyeGeAePdPgx2k0F/2rqx4EtO4SlL3YUlQ7jtJY3AUqDeJxWDnJh/UAv3ZVUW7qPKria
         3x+YnoRFslfR1K0wF78EkdUWCNNV/oICHSkVdsuS/Nnrow+r8peFG4DTWMvZKBv/aDK2
         nTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qCd7R32fnniXdlIAcpkZUDMU6nES+blfXibgQwBeFfE=;
        b=1kN+G7OnqhckTvyMi0eMApSXeK1fHyJu5kN7ZkFjrOFSrec6E6WirNiNIq1aE/lELm
         VJma3OI5lKuvk8MKaS5FChHBA1QCj6VeuHELS+cLSR8ZMwm0o0eg5sahv36pt6I50T7a
         V8nQsIEwiA3m4ZppIPKu2r5QHkmCMLC+XGefN8ttet26Z/HdrdTOwVD0EtcP61X/z8rL
         fwdjFs3QePRd5cOvNvTjWU8D8WvNFacbaKc+HUk3myrEsTF0vmanOaQmFoeFfazhBR1G
         Fj9VF+50UCJc0KWidpIxKtHrgaHMF1UH8RVnUcjqAbRZwNQCgLzo9DBzu/4Q7XuguH2Z
         rFAw==
X-Gm-Message-State: AOAM530nCyr+z5FE+ZadTbt0W+BtJfPuxeQ1bCzrTOGw7F8M2X/5oMys
        uBy66qeKYYHSH7KMxxKie8oS/JJz4eKrL/FmcpB2wg==
X-Google-Smtp-Source: ABdhPJwW14K+ib9gu+ZFk7+uWz7H5S4aQtjbRLpLJVjBjbhLHstYHlu3gR/YivB85sE/P+h7nXu9PNnPuu/PzDejHv8=
X-Received: by 2002:a17:907:7fa7:: with SMTP id qk39mr5058503ejc.384.1635268083956;
 Tue, 26 Oct 2021 10:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211025190928.054676643@linuxfoundation.org>
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Oct 2021 22:37:52 +0530
Message-ID: <CA+G9fYtaSe=PrPFLZaoFw1Ama_dC2RF3CO1CZsOjBWEGyBr3Zg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/44] 4.4.290-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Oct 2021 at 00:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.290 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.290-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.290-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: 7d5d802dae8e729d00633b6608b2183074cd1cba
* git describe: v4.4.289-45-g7d5d802dae8e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
89-45-g7d5d802dae8e

## No regressions (compared to v4.4.289)

## No fixes (compared to v4.4.289)

## Test result summary
total: 43390, pass: 34733, fail: 191, skip: 7460, xfail: 1006

## Build Summary
* arm: 128 total, 128 passed, 0 failed
* arm64: 33 total, 33 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 17 total, 17 passed, 0 failed

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
* kselftest-livepatch
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

--
Linaro LKFT
https://lkft.linaro.org
