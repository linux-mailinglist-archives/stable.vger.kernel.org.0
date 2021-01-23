Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA830136E
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 06:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhAWFpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 00:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbhAWFpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 00:45:13 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E788C0613D6
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 21:44:33 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gx5so10690150ejb.7
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 21:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C1FkqSVdUp86BGo34rPmbxiZC87sPHgJINf/6EMrIQo=;
        b=T/wzNdNQPi0//AXQvAzyguJen1OXhblZHX7NYcSADgrATGVoIkVyIXPIiJMTG8TrLN
         FJIQsoYJdl5dmTJpSLKtJLDLOmcpts7gv32QM54RauewzMbmhRyPTn90n7RVCQgI6Ce2
         3ymAE8/rrJK7B5JIOce55PoRX03UFEvbNQw+hiZ6rt+rj/AcfGK+bQphIcIsx/0IAYHu
         mdP+cTCankvt33Axv01usL5sOFtv+DQ6/tzCjLDf/Z8kCDDDjb+qOq/Jyvew+Wx30lTh
         z0l/HtSp6LI1TVSpNkWVnERhmiKnA7bny9o7AyvEKDmO6GDcHY+6Y625qsZBNJIP462O
         UWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C1FkqSVdUp86BGo34rPmbxiZC87sPHgJINf/6EMrIQo=;
        b=G8SSxinfAkeTInYJR+/ToM6aOe82z9oMRk7GwEg9gm41o71rzi174FuqNMtbOtPS4u
         UDHjnfZDbW6mthfwQCDXTiwjo7DAxQ+dAQdoc+SF0hOcDa3//kgGDHxyqwc7wEU56WyI
         jkP9jSAb9C7lhHKC+5qZI2yDAgNLpvgbCH8vtnFueuxqNhBaRVLhaPKrj63rTyJ+OFl+
         HPTA98Ayqc4B8hiMZBR+qbQHpVlF3sXKgBtyEPnTrHNPn3X/GjcbsRvVD5+M3CQFGgib
         D5JPgbtjzuTi1L3nKhFSMdHQsoFLBr/vSNf+/o/C88sMittw6HE7Q+CL9F0y4rOcBcbW
         TrCQ==
X-Gm-Message-State: AOAM531dabuKzI8R830rQi1VN91FOT4aLlhQCuoixNkRLvT+zdtGMLGr
        VIkZdvBvisHLbWhaETAOYTNajUbOh4GEi5TgH5CmkQ==
X-Google-Smtp-Source: ABdhPJwo9wUcYnAnnIkblMsqLk3JHJSbkfWKkKeCE+kwYmuhPLQbFaMHQ67uNn1Kap2TZITMmtIUI40bie5iF4slPzQ=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr223395eju.375.1611380671786;
 Fri, 22 Jan 2021 21:44:31 -0800 (PST)
MIME-Version: 1.0
References: <20210122135735.652681690@linuxfoundation.org>
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 11:14:20 +0530
Message-ID: <CA+G9fYun4MY72zD1SUPRktJdbXsotqi0G-a=cvdAk-8kOo_dwQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
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

On Fri, 22 Jan 2021 at 19:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.10 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.10.10-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 402284178c914c87fd7b41bc9bd93f2772c43904
git describe: v5.10.9-44-g402284178c91
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.9-44-g402284178c91


No regressions (compared to build v5.10.9)


No fixes (compared to build v5.10.9)

Ran 55124 total tests in the following environments and test suites.

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
- qemu-x86_64-kcsan
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
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-sched-tests
* ltp-tracing-tests
* fwts
* kselftest
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* ltp-controllers-tests
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
