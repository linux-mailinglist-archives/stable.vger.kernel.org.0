Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785E02D0D58
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 10:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgLGJrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 04:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgLGJrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 04:47:41 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AB9C0613D1
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 01:47:00 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b73so12965800edf.13
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 01:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nh8hmJxQmwGFKjIJpdn8QfXbazqpO8ZVQJAcoMlQ+3o=;
        b=VNKKV4Fly/daUxewGdtMaBZQ3fo5sOW0ocbXzN6TrjTXhToq3hpHiiGoAZUmsQ4SIV
         IRBqAx1kcTdaPTKV3LXqS81IP4XzpDKoicUCe/282i82pvW5uEStjqQlvb1GYeEnhhq8
         IEyENnFrFnku0OSJFb6OPWtjtaEbi7DPuucIeEy9IoK1t66W0bADcmNq66j6VIhqM6C8
         zYM1oCKvCtNh/r+8goR2quYyQf9pb3LqncA9NWtqyJGam5COz2SpxCAaIo7CsMo/KIEn
         ztpdnZka7o0zxFFkSgTB9AdDHH62hZpkfbnOClyS+eyXruK1jN2PwqSAKeL+d058UfN5
         QlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nh8hmJxQmwGFKjIJpdn8QfXbazqpO8ZVQJAcoMlQ+3o=;
        b=PFTqbrm0tgyzBwb3d/4rHDin9hGEKYAa12WW2e4t+a3DoycJTrXsHZrws15agv+lxB
         aeFRSbNswG2LkotahoPSDnrdgJFj+uOM5gZYQVgpjda3xdRpKjOscp1sdipHd2X8lbJ9
         Vo5bi5kHBR6kXI5jq4Px2kXiauqok3Ms3zMs39w/uycYoRSKZkBKp1Ku1xR/APbT2eGF
         55EGoje++GdUO7ok2g8HXC02Hs4Hs0JJdtsCTWFsI3wSyb/4Is6qo/FwL6MVUJDWf6sj
         v07cx87Y3zGgLqV0E3id7NZQRr9S04KKaCEndqkkuHkgHGc2iOx5thMuuFwhjZelqXJ5
         vb+Q==
X-Gm-Message-State: AOAM531XGsFHz20fXdnwy+MIsD/BdUjKWvs9WH0LSfd921jv2WyxesjD
        3ug42kr+BkLVInvt6CUEzYSFVOygp9THZoNuuQ7ngA==
X-Google-Smtp-Source: ABdhPJzytcBIbxeErCX98lt+bmjf0polBe3qHxsOL8Xewcp2KpuP5PRo8B85e7gd/4P0iLWTCYGrRYSaohcf8g8ew9U=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr12675680edw.52.1607334419167;
 Mon, 07 Dec 2020 01:46:59 -0800 (PST)
MIME-Version: 1.0
References: <20201206111555.787862631@linuxfoundation.org>
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Dec 2020 15:16:47 +0530
Message-ID: <CA+G9fYv++q-swaWAgWifNvoLjMENOgeowwisVEy5Re5CgGSt7Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.162-rc1 review
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

On Sun, 6 Dec 2020 at 17:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.162 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.162-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.162-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 35a4debf26a46be2487f7401acf73ae8b7a4a3f1
git describe: v4.19.161-33-g35a4debf26a4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.161-33-g35a4debf26a4

No regressions (compared to build v4.19.161)

No fixes (compared to build v4.19.161)

Ran 42661 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* kselftest
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
