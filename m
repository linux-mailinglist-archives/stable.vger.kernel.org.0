Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697F6217F1D
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 07:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgGHFae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 01:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbgGHFae (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 01:30:34 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A8CC08C5DC
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 22:30:33 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d17so37946542ljl.3
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 22:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pjfcbpQ6qlNIl6a+q1As3kDpc6/H3HtR3c0f6GQ/eQM=;
        b=OMVZOszTAYenxDFWn64N4YbyYKC5bxDxhFmh+3jtYRF6riJrPuYqpkuGED2BmvUJju
         FtuzjgxM8gxmjAfLpjsSaVPU35ol0vYIhYrI2C8nMeR/EzQ6EG+Dreu9tAyzRyl1OsXD
         uEb/mEvjpZvzxoNqTdHM9+4TZ4QS47XUyyb+GhFB/HGZlbm54xm7N4UQLgEUJOebd7ct
         MJgMuydVn3ObeKuATJ0i1kRSAhbve4SAoTenvQBqmayF90ugNvIYOlYIRgoG1hnVw8WN
         a4kPDwRJR0Qnn1eoZYRVa6T258oqRoL0bmQKumDIo3/Vw9qlxtM6J1PltqJHXc0x9Bi9
         aAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pjfcbpQ6qlNIl6a+q1As3kDpc6/H3HtR3c0f6GQ/eQM=;
        b=M3WuBib8zg6499mAg5aYKoQE1Rw+/YNfoDaTYV8K2f9ACcYKqJXi0G3inwxr8pL/6E
         PBIDBnHu+lFZwLmLTRQNUb7LS4wEK6Lq5taEz+xw9PgxkOuIp+OH0T4m5irWizynZZ/F
         /rgXjf7vLC8yuM6ARXo56CQ7kz2eSMVmESZ37asYh/NUAe2F0lSzBO7GXgn4VvkfL+2h
         va1oM6cmbXArVmYOZdiQq5RDiNHK6JABeJiT03VK8wJXilQHm4C6UQeWlx+Yq6K2WCat
         8VFgJoKu9nlbbsgmwhtqDmo4YA+qSUnDm+v6C/KdLPsqqbbYPpRahtXbNG8+CwmYPIIx
         nt6w==
X-Gm-Message-State: AOAM530IVZZvpXBdtgJmpzfBNtb9g+K/hhbwe/3vyCnowyUleEamY8uj
        H54YqcU2DAMMAWc4YXr4L61C3ehpN7WTDOFeHmHh3g==
X-Google-Smtp-Source: ABdhPJyv6wNkut4gvmrXhE0h3DLfRwAd9I9chL2cKFjhP8p/GyGn3zAdVRT2swcYKt1Zh5eXtKURQIfTh3d3l7b5o0w=
X-Received: by 2002:a2e:9857:: with SMTP id e23mr29696616ljj.411.1594186232162;
 Tue, 07 Jul 2020 22:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200707145752.417212219@linuxfoundation.org>
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jul 2020 11:00:20 +0530
Message-ID: <CA+G9fYt03DDfX_p9D2SwGi+kzauDAbSWz+EpGVS7Sy680OrCaQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
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

On Tue, 7 Jul 2020 at 20:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.51 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.51-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.51-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 47d410b54275a08dfc16b90353866ac1f783c0aa
git describe: v5.4.49-240-g47d410b54275
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.49-240-g47d410b54275

No regressions (compared to build v5.4.49)

No fixes (compared to build v5.4.49)

Ran 35614 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
