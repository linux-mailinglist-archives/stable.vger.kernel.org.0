Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B751A5D2D
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 09:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgDLH2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 03:28:45 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35726 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgDLH2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 03:28:45 -0400
Received: by mail-lf1-f66.google.com with SMTP id r17so4277923lff.2
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 00:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/ZcAHoOOBMZ8adBm6iXUvbbzB7r+AYB7tVVj7nCRf8U=;
        b=n2Yx0bs5Qm4OyyaQCGplrG5Rf7KHCudd5jxrTagKJWgWJkxHf7rwqJa24yCIWnYgCa
         28Q2i2LSr24oFyJls3tkA/sPyH7Y6KlbC+ARBCI4vqNrwRyIcQbwvMqKS8eKPMaxgBZw
         Q2QJkknRVnb0fwza97YVu1Zsk01wmHm0l3jHzhHNEkN+vT4kFyqSGaqI0F+kEDmyGhvk
         9xE+x1gjQcTSZS4jcvSjEnaVJaW1rnTDC/txnUAEjZlnsI2hoBad/w6hn67P1nj0dJK9
         WIinlTkIc2vkAlCPDCuujRok7uKQz6WSIXyjq+b52IGMQ6up+0GIpXSX3S97jirGdnQJ
         HxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/ZcAHoOOBMZ8adBm6iXUvbbzB7r+AYB7tVVj7nCRf8U=;
        b=A7tQgDjP+b9A8QLy8sdM4DUT90x8nEUj6FVqKEhlhfnmBAP/vb1cc7XquErNo8Xn2Z
         vU8bIYoD/oh0q54Su25ReWIOk6S7VJGWTDLfs90frZzAZ8dG0w3mLWwoqon8WAdDbKu5
         x616KH+QZWZIHRCDkkYjPv+Fv3QCytIxvKksYFA4ngHOYCrWGIQdRedAiMindy1JnAct
         acpWDGEh91MC1wvTeVNytTxURWW6jNa4rsVss4yjoItyjuDqQ3rAl7O+L2DZGMf+iQP6
         6rZOOnweFfSt/+SPQCuq2+FRjn2tv6S6zFMAHxTQD1NYVd0dFkAJBMCaUP2zxt5s2XEt
         ggAQ==
X-Gm-Message-State: AGi0PuYGcDx0e9a+DUaNpXq1+1jz/OT2rw1kTLLwLpnZouY8f1Wnih3N
        E5S4O8W1cvIfYlKjwrBBDpD48HI0tXvfJR8kpSaicojEuCg=
X-Google-Smtp-Source: APiQypKVC5Y4JyQjHUhH3pWsWQHnCXlDMNJWdPj3/t+7BXPCOL4WbqeAqw9GWGVuurTeQP++dLvfxC1icLkPxLIj+WI=
X-Received: by 2002:a19:c64b:: with SMTP id w72mr7126295lff.82.1586676524043;
 Sun, 12 Apr 2020 00:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115504.124035693@linuxfoundation.org>
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 12:58:32 +0530
Message-ID: <CA+G9fYtKpO0OabwO3ss1KJYyKRbsnaWAfXKALyWu53So+=tUDQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/41] 5.4.32-rc1 review
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

On Sat, 11 Apr 2020 at 17:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.32 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.32-rc1.gz
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

kernel: 5.4.32-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: f163418797b9310a9eb4a73c3d0214a7cb415a12
git describe: v5.4.31-42-gf163418797b9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.31-42-gf163418797b9


No regressions (compared to build v5.4.30-54-g6f04e8ca5355)

No fixes (compared to build v5.4.30-54-g6f04e8ca5355)

Ran 27945 total tests in the following environments and test suites.

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
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* kselftest
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* kvm-unit-tests
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
