Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8753E1EBFEB
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBQ0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgFBQ0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 12:26:31 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C149AC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 09:26:30 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x22so6542567lfd.4
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zz7fhoTM9QdHAuOJqfvKMHbuIuwima0BEOw44sB2Lw8=;
        b=nMe1g6IIHJMCm7agcZhbi88PN9tZigbmBS+dW8ccOf/MvTzbXVXkZJoDldzhus1lPH
         pVMYG7UfYKrxJgkbOPMmlG5WMIlvtEljOoBaUm6+VSDeuU3FSEq17BNil2CnqtmvV5pl
         VugAUASmgGmZIADGrIqgshcL4/f3jOSJWAyGcZygo5o55vGR6iJv9kJGVhPZ5BbaZEtm
         miLDVpW8t1tw/rI4VFEfrbJc8tZFzmhYPWpSWcMheTFakUSxtoYSlCNX4fV4Rdjb13P0
         HkOJYHRRXDPUAf7swg/FmZTAkgtuzfe/sVcVVmPILs4UatoxHPoSDKGN54f33w2ksXqX
         0bSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zz7fhoTM9QdHAuOJqfvKMHbuIuwima0BEOw44sB2Lw8=;
        b=e58C13Ylxqbdmvy8Oy3CXJQHqWLndZauJ6OcW22GBPVu0IA6XvtDgdoZDAK3ORZQvh
         V46aIvCDM30KRmnLN2St1X+67ibDPTmIDbt3qr1xyVwRMIgB0Q2FLwUNjjDhEt0r0wNH
         mLeqy9YezoIESXxUVpKCB91e3wuWFFhzX4lDZJwMci7jxYozDNLMqkXoqO//PPMNlbma
         lVWYiyJZoZgb+Q3B7PRYk3TlqTai428QPalrVWMOzaTL8IEGh21yogtlsObWBZ81W+no
         7iOOt+Zg9oCCgd+Esag1ewPZzOR2HqVM/BETeSKwWdopubt9awSP3Zz2ij088QbHFoM/
         /CPw==
X-Gm-Message-State: AOAM5329fB6HPKAhWf/TTfTMTKSn3g7Anwewle7F5PUFUEsADS9iYAGK
        ak07pUWa/cmuMQ3PrMqBeUxFJ2ZUcGTg3MbFw5Xs0A==
X-Google-Smtp-Source: ABdhPJzWp+hDdyYu66xB5+uDupO8bu8PKKwwmBhpKgNFT4R0wzQSvIIwDXbtCjXZKi//eLRufEIdjDNn/7OZIj4TqLc=
X-Received: by 2002:ac2:55b2:: with SMTP id y18mr104403lfg.55.1591115188968;
 Tue, 02 Jun 2020 09:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200602101934.141130356@linuxfoundation.org>
In-Reply-To: <20200602101934.141130356@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 21:56:17 +0530
Message-ID: <CA+G9fYsPS4W5tyH2y6i2M-FrQ+A8tU61GUjLQ+KBW-_Rbb4_Rw@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/174] 5.6.16-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Jun 2020 at 15:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.16 release.
> There are 174 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.16-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 4ceaad0d95e7a56ea839541b0e825af93e4817d9
git describe: v5.6.15-175-g4ceaad0d95e7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.15-175-g4ceaad0d95e7

No regressions (compared to build v5.6.15)

No fixes (compared to build v5.6.15)

Ran 32298 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* kvm-unit-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* network-basic-tests
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* ltp-ipc-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
