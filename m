Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE3178B21
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 08:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgCDHLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 02:11:35 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34523 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgCDHLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 02:11:34 -0500
Received: by mail-lj1-f194.google.com with SMTP id x7so797520ljc.1
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 23:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BkShX9uib5LS4O/94TFjeey0LtALuEzZwdV2AGz19E4=;
        b=eDVUqJlXZaE2wkabJp1K0swqlFrhxl//dn2T+IhnJFYcS8IZ1Ki0YgmMiSHVXDQdl8
         VLPSO2+hlNliud9dhY3ELWj6AnDn03ezin1XWYrmWsEqMDiVHvKbQaKyZ8T/Drl6Sb8c
         yU51hUVvrqjOEOwqc2kqS5JLav2cyZZdCgAixsECXQRzNPNQnc8mNbQrjyQw8GUpi65W
         wPHc/16U30cUcND8uTHeFzTuHFnY6gRtUKMUvg0+BQla/NweFWN2evWvpsGJvbaQT3/b
         Gl1ur9G7x+H1uxjGmk0qkqgSvJcbB2v4Q9Hr8O28t3mk1xOIHOH6b1xuu4OuGm/GL2sc
         ghLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BkShX9uib5LS4O/94TFjeey0LtALuEzZwdV2AGz19E4=;
        b=YoyH8/xpkM7MdYsgjrp6YK42a0nI8kBjLE6FuLVmNLFaPtvDrac0xrBMwmCT6os5Y3
         lKjRmMNwXmL8WDDWk+iEyQQ+n97lVTCpfsIm1Vbbgwrtq/LOuYIFmJUDeStrLc3IqfhQ
         7PeIEtMHBicG+GvXcbNjGcuMgw7cN+3Eoc/oj5nKmhe7GkRyjGqLW++N+vtzWT04Cnhe
         Zhnen5ztRkqwXTYg3upPn9UchieB2uaGAdsRdXRD0etQ8yxREmARDnyWBtAa3e5a8VHQ
         wrmtO+6G8i7e+uMozNkMp/HMLnksqIq0NSo4c6H1r1zC0z8oMdknqt4vW7s5NgGRR4fN
         pT2A==
X-Gm-Message-State: ANhLgQ1OQm4QlYWkcfYuo2NB/vOWgUh9Ty7n6YhR/fTaVin4S2AEw6iF
        hfhWM97zIBdTaLFXRsZnyrL1ZLWavL6zuCc1nfU9Ag==
X-Google-Smtp-Source: ADFU+vtQc6oT66du5+UtSOsQ0o/1vy03B5D8v3DkYovN7F5ry0wZ1uGfdZc+trrwPfxxSdnTXIjGTcJ366xoLQObM+A=
X-Received: by 2002:a2e:9008:: with SMTP id h8mr1063593ljg.217.1583305891247;
 Tue, 03 Mar 2020 23:11:31 -0800 (PST)
MIME-Version: 1.0
References: <20200303174302.523080016@linuxfoundation.org>
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Mar 2020 12:41:20 +0530
Message-ID: <CA+G9fYs1FaUUURiMFw_jXxec_Us38WetyrOXpSn92sRtUVCbQA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/152] 5.4.24-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Mar 2020 at 23:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.24 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Mar 2020 17:42:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on x86_64 and i386.

Test failure output:
CVE-2017-5715: VULN (IBRS+IBPB or retpoline+IBPB+RSB filling, is
needed to mitigate the vulnerability)

Test description:
CVE-2017-5715 branch target injection (Spectre Variant 2)

Impact: Kernel
Mitigation 1: new opcode via microcode update that should be used by
up to date compilers to protect the BTB (by flushing indirect branch
predictors)
Mitigation 2: introducing "retpoline" into compilers, and recompile
software/OS with it
Performance impact of the mitigation: high for mitigation 1, medium
for mitigation 2, depending on your CPU

ref:
https://github.com/speed47/spectre-meltdown-checker
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.23-153=
-g1254e88b4fc1/testrun/1264789/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/spectre-mel=
tdown-checker-test/CVE-2017-5715

Summary
------------------------------------------------------------------------

kernel: 5.4.24-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 1254e88b4fc1470d152f494c3590bb6a33ab33eb
git describe: v5.4.23-153-g1254e88b4fc1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.23-153-g1254e88b4fc1

Regressions (compared to build v5.4.23)
------------------------------------------------------------------------

i386:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

x86:
  spectre-meltdown-checker-test:
    * CVE-2017-5715

No fixes (compared to build v5.4.23)

Ran 27633 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* linux-log-parser
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-crypto-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-64k-page_size-tests
* ltp-crypto-kasan-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-pty-64k-page_size-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ltp-nptl-kasan-tests
* ltp-pty-kasan-tests
* ltp-securebits-kasan-tests

--=20
Linaro LKFT
https://lkft.linaro.org
