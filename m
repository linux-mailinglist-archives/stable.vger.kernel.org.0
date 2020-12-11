Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68A72D6FC4
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 06:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393915AbgLKFcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 00:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391822AbgLKFcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 00:32:24 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B321C0613D3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 21:31:43 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id q16so8032485edv.10
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 21:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hImzJTG1TeCVrpQ/62s06BDvZxebz7cWjIsblYCekcY=;
        b=D2OVUxOTYW2vrneBuP16BMRldWA7mGoJaSofbOud/EqKktRwaJO+1AWlsI29F5h7t4
         QTJRG6kD3Rn+LJyBkwKMYSnKVObjAoZcULI22ck/thIo90946vmbAnVTcU843s0g6+Gp
         s0onylD8cyJJmU20ZEzeyUGY+oq0k+/LX9JkquwCqanTk7msoWie+S0Mo1XVw/8GuMzj
         E1f2hc9dDUudqOlHaPr4SkiyILOzYfDC+evktHOZcl3r+fkWKH6E8+sZLssicu9j+m9F
         cax1M/FGIY0PZfJGLpRgIGUCFTra5O25mLVXBLjcxSvB48tAZxxWyhkdQacJtX2/4MAs
         MDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hImzJTG1TeCVrpQ/62s06BDvZxebz7cWjIsblYCekcY=;
        b=IDsazrSjIe/jaQ+ZXOT4+EqsLcZL/WSAD3gzCLyjbVLZqEA8gAuKutL1lkb5pTgwgF
         wFbvM27fCXGKlfMwtqwWoLMaC+CUJBKKu1njrUBkzcbNksp+bAepPcSEX/HKA6YdXUB8
         AZhKcs16BKMUfUiLRQFmM3ijEMEws65Wk8oqasnpgV9QPxahA5NwVmlF81jOy4hrLbbS
         wbjS0FnRXHzqAbA7/aMUqPidFTRwR1FcgEHd+akSOIok7p03kvyFnbnpukzsznG+wtxj
         ZWAxNa/IsTug286w7E3fs4kV0HMPAQ19e1r0RxzXJkFwTau9PxO3iXZQftqXncpQTX08
         XHuQ==
X-Gm-Message-State: AOAM530tTFriSA2ddSm3fyK747O4piQAwfmXGtL5NxOCsVi0JS2Gvvau
        y2KXE1jOxt2+7ZVCdTTocIMN/HRVC2X11cjb3y2JHw==
X-Google-Smtp-Source: ABdhPJxjZHloKSP+HbWEKPjm0y4AaYXmEIOng4aiKxjXCoQpfuuKGyGgTt1fkbhXviGjAQzfofQgNHpbAHPgdKTDzKE=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr10045293edw.52.1607664702500;
 Thu, 10 Dec 2020 21:31:42 -0800 (PST)
MIME-Version: 1.0
References: <20201210142606.074509102@linuxfoundation.org>
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Dec 2020 11:01:31 +0530
Message-ID: <CA+G9fYv-gar22WM8sdTSTmnda8+4ysyR2Lbdk0vFBwk2Hp2qGg@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
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

On Thu, 10 Dec 2020 at 20:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.14 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.14-rc1.gz
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

kernel: 5.9.14-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 81beabff31a7c60d2065f5711ffda6d97776a728
git describe: v5.9.13-77-g81beabff31a7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.13-77-g81beabff31a7

No regressions (compared to build v5.9.13)

No fixes (compared to build v5.9.13)

Ran 57691 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- parisc
- powerpc
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
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-fcntl-locktests-tests
* kunit
* rcutorture
* fwts
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
