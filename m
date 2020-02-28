Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D869172F92
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbgB1Duc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:50:32 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44682 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730736AbgB1Duc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:50:32 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so1698143ljj.11
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 19:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PViNmrTZ4hjqF/LWHkWDjhiCPF00XzEuHwQhWDhjXLo=;
        b=k+WIxfd+LNuA4z7q6e827jCAzYJNUlSFhXYQAR5tyH4HCXGapSfpYu5f+5OOhFikJG
         W4WVk57It7+Y8E208AC5THzcdYD71iiCUws5LrH1WaihvxF3H8i5yuInl/VmGtuLI65j
         yVohHQIxeB5lcJrh1pR7XPkF0Rm8gRZ1nRh2kIE+XWBNHjWsBkw/1pTZMlJtHgfZ5y4U
         Y7gZl68jnftWDDNjDYpZ+n+d2hnZGL3zdpA29XchGiptrfxk4Q3N+vjQ+emFzN4RnFxW
         RdxRTMWRdZ/HxJRD7ZPhPwSrhYVPziK9FYxzePaXJPwbddxuWh8ssISxej+PY8EtxQLE
         DLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PViNmrTZ4hjqF/LWHkWDjhiCPF00XzEuHwQhWDhjXLo=;
        b=m4eaNgCk1yoB52zBgD6aBF7v4n0E5aNwBBP3iGFA/QFSl+JiZUluffL/UqcRupJAs+
         2Qg7vtxXZ/YZD6ibDRnH9GrfEBNAnTXcWPi7K11Xvs0Lhy8rrTt8kaWoE3pQyBbfRspj
         LlLuBFLZE45nEAmRr/1xcdTri+Ovpjs6AcBHoN17JWPESEmNbZ4srvUtrrQIS4wWTEp7
         FEz5xk/yHkspTsDvMn9sUf99tsBDEbmwqtitcOQLUwATW0n0uVqEKLOsIWsfZ+QqI3ED
         FQ8foMlumyXwv0J5korM6kNefQbKmb3XN4JOF7C7muX9n9GnLYndqAHj2nEb6SCZiqkx
         3vyA==
X-Gm-Message-State: ANhLgQ2UJfW0IOFni/js/gDiO6yTn/DuNBsNFkn5MrhxBeWpuWAJKkoV
        HdqHHcW9skEEj+6SS66EIIEXXc7SIGHyDsPQ+tg+2g==
X-Google-Smtp-Source: ADFU+vv3GU37vpmAFRxL1JJzGTxhNMMpyyDcg68b2PFrAwZb5yVNO8DqnbAZ0B7T9IKeyjXlqNyI9lENGwUyw15JHTg=
X-Received: by 2002:a05:651c:1072:: with SMTP id y18mr1468231ljm.243.1582861829448;
 Thu, 27 Feb 2020 19:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20200227132232.815448360@linuxfoundation.org>
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Feb 2020 09:20:18 +0530
Message-ID: <CA+G9fYsJyqW95UU-KKNqQOQVSVNaBF9ZyNps+vbxHUtJ1S==gg@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
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

On Thu, 27 Feb 2020 at 19:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.7 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 986ea77a7c4444449bba2f289b959786acef45cd
git describe: v5.5.6-151-g986ea77a7c44
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.6-151-g986ea77a7c44

No regressions (compared to build v5.5.6)

No fixes (compared to build v5.5.6)

Ran 29362 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
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
* ltp-crypto-tests
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
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
