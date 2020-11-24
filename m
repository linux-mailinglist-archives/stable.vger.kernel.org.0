Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00302C1ECA
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 08:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgKXHVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 02:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730003AbgKXHVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 02:21:23 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588B4C0613D6
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 23:21:23 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so26985499ejm.0
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 23:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJ2fCqwl0eySHe3jwo+Hw3BwyNEcJk8739SIICPAssI=;
        b=OFDWI7MvlouDqI/Q5bMFuEtpfKtNa7xUw+VI2RR2B+RDR7H5MRH+SCIXULOX02ppZ8
         Iq17ZdG4e8yoLBErqe9ykQ61jhXSafdJpw9dRQexxNAu0iaFCdYOuZ5piOaiPVVWTGf0
         e6TAg8Bh55HUtweA+grxOsawebdJcUY6Hbfp3t0KroESOAb8C2rV4FfF+x3pd5C5AFzn
         GiYe0kNj4Z+MHiiwGXq2XtypSkyWCfPOumzKfc7pVv3sYAs5p5pTcOxl8yOJ41+DAahO
         0vt/d1WYACZmFlkJVuMutaLFVQEJNUNSrf30s5wzWooyH3mBHTKQ68R4mscXLfyEhaPW
         C+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJ2fCqwl0eySHe3jwo+Hw3BwyNEcJk8739SIICPAssI=;
        b=NzTlsYDVKXkimp9eaODjxltg5RZLHU7zjCLzP+wJUfQ3WeRbHe9kklVYAS+Y6b1418
         QmUqAlEzH+r21z+0if7ykiDzt59HrV8uUL1ibm7uuW8dwjMdd56qryuwM21jAiq1m5rV
         SlSn1OROhVlhbgkHEIYUSKxCTMTCf8UzXb//hcr36O5Sj1We2BT7ENNJV2xFWwBMVQTu
         j5eyJ1918jbs65JtXjqixr/lOjfHsSKpV7+twjKqK+4EJH/A7MG6dWH7J+LUP6+DBiDC
         JV37WASneU53kU2NWxB84gPVX5YmaED5lqiFzrpfAJDj9wJPsTioZIZI0eRKGvkrVIw3
         Rhbw==
X-Gm-Message-State: AOAM531LGq8PFn+8llY8UAfqRFJ7WkZBwqEwXUGdJ/bg+RHg2doGpb3+
        VrtpcUu3E+FIlu/JDGl9u1hlB6SL3fy7N7rPnbb/CA==
X-Google-Smtp-Source: ABdhPJx7xDsX4OWoaMTMsbRiwhwu5oJ9YwqqdPwcixgx7Vi/H4WDPf81zb1RKvq3ECkUPIq1j8B/S0LE9zbvxifb1f8=
X-Received: by 2002:a17:906:bd2:: with SMTP id y18mr2821967ejg.503.1606202481868;
 Mon, 23 Nov 2020 23:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20201123121805.028396732@linuxfoundation.org>
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Nov 2020 12:51:10 +0530
Message-ID: <CA+G9fYvnEr79wGM5w7YawUco4_nUyBgO_EiTvbuH+9et3F+VSg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/60] 4.14.209-rc1 review
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

On Mon, 23 Nov 2020 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.209 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.209-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.209-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: c3391de31d51a6a479f081994040a5fb99b29c9b
git describe: v4.14.208-61-gc3391de31d51
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.208-61-gc3391de31d51

No regressions (compared to build v4.14.208)

No fixes (compared to build v4.14.208)

Ran 41581 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-kasan
- mips
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
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* igt-gpu-tools
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-mm-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
