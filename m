Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728401EB5F8
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 08:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFBGrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 02:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgFBGrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 02:47:25 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6C8C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 23:47:25 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n23so449581ljh.7
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 23:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PZ8MhVicGRsxzC9BimTXZzesSszOqn+avAqT4sSAbOo=;
        b=OUcjZ789QS0RrQPt9rXejvQQkGj+FXXb95hS5D2DQMKb8qjFYC1Gj84fh5hmZ/TMP2
         R90wsAJ2PV2KNwrCgJlQJNnnGKjcT2ttcEcqfgt7qtGnQ8/EbP8wP7qdbNWy7fiC77F/
         UWQ/AYRTB8/YsogumFGLqx2eOfR9gKsayAZ6nM1xamDuVBS844PXn2aB2pzADG51sR8z
         3khNWCSTcP54TYnMm8uteCRvLcSAJ9TifaN1+Ajxl0VIGuj7HM9+5w5tpdbhgn3pme6g
         oAJBJdezG3sD82L92aZvmTXdN3yMsBHBpmBElAUMAk1kTlQDI1KkAKPcwDoA8jsIvCg8
         4r/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PZ8MhVicGRsxzC9BimTXZzesSszOqn+avAqT4sSAbOo=;
        b=tRk87uffVbTwqYSs2jc+acws1vNAXd620jorQ3bKqeNen2rBBuVK5dWoInSAJ8VP11
         t5E//h659eblcO94IhI2aGjrlDTHKNgbhF36qlcwKDI2p3YnpMKK/G6rh3Y0u7c+DzL6
         LcXzz5mIYgE0M6JKVWUqVBO5w1LDZCSPbMuudDR2whKS+wUTs2JUKDT3ersXMN6g8CTP
         PTdUS0f6qfS2Ljm7Sy+2qW+StwrQoHYQXsiseAFiqsCDcXjxCE98quANVPteGKjAbT30
         Nlj3xPugSq+n7ReF4r+fErad934FW//VwzAH5CoKe5DpqLeijYyW+m3AlnB0CUe8+Y2a
         PsKg==
X-Gm-Message-State: AOAM532BpZvA8tQ7fDUMJpWzeirHhCx8+VDQQcIg6XvQt5xLQ8hCZnOa
        IBNuhu3TThYqbEc1C/9HLKJTVnKZbK8GHWsnsWIz73tZ+tpERg==
X-Google-Smtp-Source: ABdhPJyhCZrx4BBmx0/0ZetQbArk3BnkRJZ5ox0YM1+bxijpfOdKIZZyn7UMtzo2Up4wYGLkoDk+m3Q3oBGdO+xsozs=
X-Received: by 2002:a2e:911:: with SMTP id 17mr260510ljj.411.1591080443350;
 Mon, 01 Jun 2020 23:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200601174048.468952319@linuxfoundation.org>
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 12:17:11 +0530
Message-ID: <CA+G9fYv3EaXtER=C6nuQjq9WCv_f39vsgHkc5USU348gyRw=2g@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/177] 5.6.16-rc1 review
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

On Mon, 1 Jun 2020 at 23:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.16 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Jun 2020 17:38:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: c72fcbc7d224903b8241afc1202a414575c1e557
git describe: v5.6.15-178-gc72fcbc7d224
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.15-178-gc72fcbc7d224

No regressions (compared to build v5.6.15)

No fixes (compared to build v5.6.15)

Ran 31253 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* kselftest/net
* kselftest/networking
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
