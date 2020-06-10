Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B441F4E01
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 08:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgFJGRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 02:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgFJGRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 02:17:45 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B70FC03E96B
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 23:17:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a25so995020ljp.3
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 23:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0hZiLWuye+wxKL58SzimuieV9qECyFNrT6vpBHkRdfo=;
        b=BgLC2n+1Ax249jZ2gfeFMxALlDrkcvCQZabKsEG+D6DJRmosIYsRieHIq3VHuzoi3B
         r/LMddGdRz73Uv+t4XUXBKqPM8c00QUBpAoLwprhqSDnmpd+BLeqpzsSf50qnv55I38Y
         iue6KR5s7oFB008+IJfsysCS75DagQTXwM+YRjypT1jU4ZTeO2FgeC5QPqV7ivTb/1CI
         CLY9wvjfnlBySMump/MJJL/aMuZbbAgqyjz0+2I42kKjpg8bKH4JB+qDAR1RvqphSMeG
         cK7mdjVz19wQFIwmnocFegyCTf0uJxe1eLagMjBdkZ3Bp59fzhI70w0QHGdAiGu4qegR
         NzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0hZiLWuye+wxKL58SzimuieV9qECyFNrT6vpBHkRdfo=;
        b=Uyz+mqZSTg/UoZw48WuwE0/mBMg4uj+9SwRSmvW77wWqPH8c6+quHNt5EldLioV3ZR
         nO9DaP4SzezBQnCRrzHCMpYTa6jOSRKw9y1ZEAo/tbGeoGO5cW0hIphbXyGbCsDP1ho3
         xXNzLR+oaBIqi32hV0ijGHg/idhHEbcYbnalZweF8ci0eEE6fThuuKLpcQbYxWQ2LBaA
         D3u18CNiH0AFKU0mY7KYpdT7bp450AXD9Zb5BYEj95ks/gD0KqlHf6LRaRGvivFmfe/l
         8Mh5rAmJJMwt+h66bUr5DCqSp6HiYsl04rvbLKEdlNBojwBYdDF9E1kGqoasePUh2tOw
         /tyQ==
X-Gm-Message-State: AOAM533PquBdmV4ADA3wYHMgBTQ++zexBxRF6bVteNXmsDwXKDHwBN3N
        nMmMuX1QVSOzshdwf5cGRBMTTnYliQobiyLoeQRszlQvpON8Gg==
X-Google-Smtp-Source: ABdhPJx8f3dW0vVguVq1E86iAg5Y653WpMlRP/3/wGu35t+t5y/R8dH6w96A2FJP9cqKMT2pazLfFKfH3Da2t0EU6Iw=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr872556ljj.102.1591769861837;
 Tue, 09 Jun 2020 23:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200609174149.255223112@linuxfoundation.org>
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Jun 2020 11:47:30 +0530
Message-ID: <CA+G9fYurJXfpg7QfsxxRPSFhG2cNkU-zA=VM==1b4E8bmjxecg@mail.gmail.com>
Subject: Re: [PATCH 5.7 00/24] 5.7.2-rc1 review
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

On Tue, 9 Jun 2020 at 23:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.2 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jun 2020 17:41:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 00f7cc67908be43cf52f961c4c880108b00d68e8
git describe: v5.7.1-25-g00f7cc67908b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.1-25-g00f7cc67908b

No regressions (compared to build v5.7-15-g676bb83805a9)

No fixes (compared to build v5.7-15-g676bb83805a9)


Ran 36794 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libgpiod
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
