Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DB12EEE4D
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 09:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbhAHIF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 03:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbhAHIF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 03:05:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F19C0612F4
        for <stable@vger.kernel.org>; Fri,  8 Jan 2021 00:05:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r5so10235356eda.12
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 00:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Atajo8HaPEKiXZm7M6+JE8PBoYDz2cNucLtvXibvdrs=;
        b=AOsZgUvwq1YSOQSWlGWsrqFJIGyWnfariWqgZx6oEZiBWojpYtLyxBs9qjkJdICBGq
         Ko0ZdK4YwQ5RY8ITy+8P5CTxhYREX/RkBviPDbsfndlmxrNk9Xy/ZufXBN4HTCqqWEC3
         7GeYzDOZwXivBSlLO8hxxuRtPqZ04r9mlkPArfksjOImg7BuLsMkEdh/Zdty3Uowh3Kl
         GzVyWYL6Y6uR/2pG6VOp4hyuwIzsYG//ciC8ahmbrbyZi2yiZe94OmqnGijDmAFBeSWI
         hzDJJ571+x09Qw6SwH6ACR0m8y6TyEBkrgoda7qdYH51EduhWQRqoIcOs544RpeJECsf
         JiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Atajo8HaPEKiXZm7M6+JE8PBoYDz2cNucLtvXibvdrs=;
        b=F/VJL6G7aWjon0F2mbbbTMJpP8YxdeYsAVYpOKrH3Rl732gzQ1okVyWLTNObJmccw0
         Aee5Wol0HLUj1kth/Qr32vzbyZj36sFDT2X2y9FSUNPWndzBB3UOi46BDfTS+s7X7AAd
         Qhwa0IRgRAdrm2v4vQM4P6rFROPOjA2+3Eo/ELtsUALTtl4iA08G+8uSfWe7htbRVQS0
         M52iP8zEQCOiwhNgLSe+Gnv0x9T+WBnBlcOPVRnOccVxrtTyX6MEgRciJKntjEfEU3G2
         +m+n427yOvvhKkJlsZIQxwqav8P1aygTmvpCGLOTeq4/In8aGaRT2wLYe76ntGu2TlCs
         6qIw==
X-Gm-Message-State: AOAM532hDVeHL4NaX/xPNyOs5d3BzY+EW6Tam4vX2nJw2gZUQIdd9PLC
        4RlgofU7gdoXKYwbYmXkA2jCEkaMJJY+IJJcYP6bYQ==
X-Google-Smtp-Source: ABdhPJyCo02c1/s+P20L2pDkxng0edhzcjQdFBfGLoCn/2usI+ZCBLcqjHUULLFP3xU856uVYYJMsnARKEGEghKqcDk=
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr4312763edb.221.1610093115244;
 Fri, 08 Jan 2021 00:05:15 -0800 (PST)
MIME-Version: 1.0
References: <20210107143049.179580814@linuxfoundation.org>
In-Reply-To: <20210107143049.179580814@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 13:35:03 +0530
Message-ID: <CA+G9fYuiHsgXm_t=OKtLoGzKWaAayYc4ZkzxTRNyWV0+t8Gusw@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jan 2021 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.250 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.250-rc2.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.250-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 5d125190fbcb91543f08ead66d1f2bd0912d9b04
git describe: v4.4.249-21-g5d125190fbcb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.249-21-g5d125190fbcb


No regressions (compared to build v4.4.249)


No fixes (compared to build v4.4.249)

Ran 25650 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* perf
* install-android-platform-tools-r2600
* fwts


Summary
------------------------------------------------------------------------

kernel: 4.4.250-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.250-rc2-hikey-20210107-890
git commit: d26a3aae50f8d14d34c2230ff5c295362cf56063
git describe: 4.4.250-rc2-hikey-20210107-890
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.250-rc2-hikey-20210107-890


No regressions (compared to build 4.4.250-rc1-hikey-20210104-888)


No fixes (compared to build 4.4.250-rc1-hikey-20210104-888)

Ran 1758 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
