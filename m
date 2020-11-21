Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36F52BBE9B
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 12:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgKULNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 06:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgKULNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 06:13:00 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1862C061A4A
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:12:58 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a15so12179268edy.1
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P5vHvdUoWhYAs5cSrnvPwGGcOljN0xSOLxbRb4b9UYM=;
        b=rPOhtzZjOn3wSOAQS/9+eJ5lQr3Ymg+IrcnKq1u1AWkfB9qMI1uaQxXGV0hIjKDXVu
         2DDjyKGFaHeLIV8j0pG3M6TFawrutGSJloQNQ7JnQzFeDEPjyIq+zflwBhXX7dlmbsLe
         A/eBvmDzqM1BUTQ50yeFcsrypSEFF/Qdq9j1/yHNhcAmAHIlXarScWPzE5lwpj+brSYg
         ZJSEQgv+sFaohdBihZskZhJArEI7fuyS7hYhyGnlg1vZ0+2f5dbyV38qacUTdW5macfo
         dejyPyGECZnGvRreQ0CUqBK0YV+LDQWRriRlYB2BK9fXl1YsS1bEVBBT8SEvBqRykxky
         imyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P5vHvdUoWhYAs5cSrnvPwGGcOljN0xSOLxbRb4b9UYM=;
        b=tz+JE6HEYBtuUahKV+rbWETTn8y0PsL6xeqn0ZjQyyCsP1tZ2W0qZeAGoHkpO7tgMP
         JrO6aRdNJyEkCDmpy7QFBhsYd+vEbKziOMmt6LSdL5cJAwNu6UuoRp3ZMElNvRExyibD
         8nCNVPOH13NKaW+Xrf/aPfMENg5LjavceEskdTXo7y9yDq0oSTT354LnyMYn3PML5Sut
         NLt8UzI9C4HTmC3eHeydNZ2pIf2M/9f2CujUM610pQX+redCdSaW3YaLdIvWVTHJChfV
         CN+klw0LL1Z4BU7tMWUwNxH9qeKb9p0RefIVMDqv8xzB6wbOwIczaq6FohFHkEvQnqLZ
         TKGA==
X-Gm-Message-State: AOAM533T7BM0OwL0IBpOlmefEf6H2p7fZptV5y1T7LpHvIJPkq/7KUmZ
        TzuBWYMUK+CgIGXwPb14K6ACO21Aj/dtoHlSZNTwAJQlv9uFGB1B
X-Google-Smtp-Source: ABdhPJy6hmsTRqH7tZsib+6sa5lPVt4Kni+8dfi57Gpx8+Lpy0Bzn/YmhDib4BbRTfcgexPRZMsPS8vmgGhBSd2hs9A=
X-Received: by 2002:aa7:df81:: with SMTP id b1mr38358069edy.365.1605957177396;
 Sat, 21 Nov 2020 03:12:57 -0800 (PST)
MIME-Version: 1.0
References: <20201120104541.168007611@linuxfoundation.org>
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Nov 2020 16:42:45 +0530
Message-ID: <CA+G9fYuFoJqZrQJn9bqd1U9YZnr1x+2acsLYCay=99QGGjd6mQ@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 at 16:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.10 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
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

kernel: 5.9.10-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 861b379f08830cebd80999babf94973e831999c2
git describe: v5.9.9-15-g861b379f0883
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.9-15-g861b379f0883

No regressions (compared to build v5.9.9)

No fixes (compared to build v5.9.9)

Ran 49372 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15
- x86
- x86-kasan

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
* ltp-crypto-tests
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
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* kselftest

--=20
Linaro LKFT
https://lkft.linaro.org
