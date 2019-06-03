Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900B13375D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFCR7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:59:44 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35309 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFCR7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 13:59:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id h11so17146547ljb.2
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 10:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mH6+A+NS7QW3MyGOuaPV+dA+RYHBYZ5EuSKnn5qVj2U=;
        b=nVn2G+1tQkkcW+z1EmPJ3bLoLvOlW0/5qi6r2uYA+XL4fjTvz/MNabAMIfNCV2arMW
         KyQQvVxDkzRCCd97KS52Z9mgSSG746lES/hfLejANyv7gpVWQzWHv+7h0cuef1x4Kb5B
         yu0Ekb3a9SsZr4l3GniFR/o2J/4qITTE0ZBkgWphbxxiYPGLK2jqQ6wyc/tAi4G0bmRV
         YAOG0YrKEmgD5MG9anKRHvDz+PaMUgPD4vnzrilu+BVmS19xIMzPpelcGLLuizqimouT
         e/jOiwg/svgaFN33XFNt2xuScMZJ5N2Tt6SKqdkv/q5xKXaua0lBDjAu2dCd9flE0jQc
         RVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mH6+A+NS7QW3MyGOuaPV+dA+RYHBYZ5EuSKnn5qVj2U=;
        b=D16UVXZxHPdfJ3hRGTXGxUIEeSz4YeehIj1/qoQOoofJyh+SQHpDuUibzjG+ubpTPr
         x23r2/RLC0gxSc1xof4llK4o21yI2Qr4501xZiZmN9sg4keSV4mhWU/7Rf9+DvicHCTU
         xq0c4ZJqtj1G3ah4TMW8IvodYupd9HqvS96eBfU/7H/40iMbIfT4KOgoAwTF1kJJiqJD
         sqlLavbII6g8/4rFh33u0B4/6YPRhhlnFP0XYolzbMsynvyojMIMBuET2Tm/LJqNCY7e
         1oTi3IPXyneZHHvVftvmkSIjvLImmyF6tQDJeItLonqwq8Kzt4+2H/C6fpjuVk1S/lYl
         9QVA==
X-Gm-Message-State: APjAAAUgUWJ7GqHFK++CopHLqa0CpMdZUysYuPpXFnifFT/y56gPiUc+
        WAiXsw679hXaA3pSR1+0OmzTCq0sh8dvyDuiDU1GxN/vdmA=
X-Google-Smtp-Source: APXvYqx35gBKnFOjVzN955g9DU4bF9xDah5c4OrnvnpZGU50luEaoyMVEUm7lgNlo0nN0UXgQQcoKc5378/z/5/Pdtw=
X-Received: by 2002:a2e:1510:: with SMTP id s16mr5667671ljd.19.1559584782456;
 Mon, 03 Jun 2019 10:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190603090520.998342694@linuxfoundation.org>
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 3 Jun 2019 23:29:31 +0530
Message-ID: <CA+G9fYv3o4a=b66523jojw_JUFB9zV4+1wgyBWxyoKyfHsv3KA@mail.gmail.com>
Subject: Re: [PATCH 5.0 00/36] 5.0.21-stable review
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

On Mon, 3 Jun 2019 at 14:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note, this is going to be the LAST 5.0.y kernel release.  After this one,=
 it is
> end-of-life, please move to 5.1.y at this point in time.  If there is any=
thing
> wrong with the 5.1.y tree, preventing you from moving to 5.1.y, please le=
t me
> know.
>
> This is the start of the stable review cycle for the 5.0.21 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 05 Jun 2019 09:04:48 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.0.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.0.21-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.0.y
git commit: 9866761971edf6312f8144e0b73e8e831883a461
git describe: v5.0.20-37-g9866761971ed
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/bui=
ld/v5.0.20-37-g9866761971ed

No regressions (compared to build v5.0.20)

No fixes (compared to build v5.0.20)

Ran 25132 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
