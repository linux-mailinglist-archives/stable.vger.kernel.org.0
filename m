Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D144A188EE3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQUWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:22:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41114 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgCQUWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:22:10 -0400
Received: by mail-lf1-f68.google.com with SMTP id u26so6130872lfu.8
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 13:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EdMXPbO8zSOEulSWNJSHIe0WVwdpQxRK/F6PIs8+nw4=;
        b=w+O5kaucR7+KHOXBI6Ds3VVyyKM8T5i60xPnhOxsr2pi+JOOa73Vkx9rbjKOQnWTRq
         T9peWdJ4zYvNGbmwHnwoVLyWzXXpsdzihZUMOd3TzSA4U4IZDXS0e3mCNyz7li6j05kt
         Tc/UVQz7CpAvnQVzef9+df3s8hdPGWDIjWr8yLA+dyxzgkpW43QnOflFkBN7mP5vsB/T
         SUWCrhGNht6Fjge/l7utK+OzCO138piQ548D10V5DKkunAxpcXixe1NfHg0utSnsZabx
         pnPybtKnrpF8XICO3CW4ux1orTK10CncX+ccjpzweOX5n+7Tv/VyIU+ArnhA8YIoapM4
         f4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EdMXPbO8zSOEulSWNJSHIe0WVwdpQxRK/F6PIs8+nw4=;
        b=ly1zHf4qhIeBkKwIlSsEsY5FLWysVpIMxwik4LKphGSWTmPOI6tL1/xQGQHYewGdjN
         XEGFrqUmWsrabdsvzepAnsm41OQ1/pZzGe70EH6TRCMkAn7FyA7cFIvWbwNCT2Z+otuM
         wo2LvpnZawnwphTZvV2KKke9yz+IXhZ3DTU6/A3UvrIbYtIevTv7e0JKX406Y+iulwkp
         sQwnHWt90AIYvbeSoE7uFucIOSmvdDs+68e+qCTC3E0Ko/OgQnDXMlyIGdtRHxP3YtrE
         K1gytdWu+phzkY3wugmDYjvOWI47QTW8x++8mDFvo8xZ8TiM0Nk/gA2UXnPIY2yLozKi
         BU1g==
X-Gm-Message-State: ANhLgQ0YaYe10mVi6y1JpyasI8qLLsGVehea0AVR9skKUrH/Tva7dCVH
        mA71NpSdvvzJ6cCA4iiMkbwrm7JRihR52DRymtoPhw==
X-Google-Smtp-Source: ADFU+vsqrqY5XaH1UaQ1opW1FSoMww78T+n7siei0d8Rc5gl3j9VqaydmtiCg45O3uYL9SVwbipWuXT+CCxhGzYVyDA=
X-Received: by 2002:a05:6512:511:: with SMTP id o17mr664988lfb.74.1584476528137;
 Tue, 17 Mar 2020 13:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200317103326.593639086@linuxfoundation.org>
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Mar 2020 01:51:56 +0530
Message-ID: <CA+G9fYsNxuHUFmPwOn9JmJN+-NM1TF-io8SnSs+XehCB+vrTEw@mail.gmail.com>
Subject: Re: [PATCH 5.5 000/151] 5.5.10-rc1 review
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

On Tue, 17 Mar 2020 at 16:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.10 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.10-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 97969bd1700945fbc9ef82238f6a2d5a390e5b4d
git describe: v5.5.9-152-g97969bd17009
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.9-152-g97969bd17009

No regressions (compared to build v5.5.9)

No fixes (compared to build v5.5.9)

Ran 25803 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* install-android-platform-tools-r2800
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-commands-kasan-tests
* ltp-containers-kasan-tests
* ltp-cve-kasan-tests
* ltp-fs-kasan-tests
* ltp-ipc-kasan-tests
* ltp-math-kasan-tests
* ltp-sched-kasan-tests
* ltp-syscalls-kasan-tests
* kvm-unit-tests
* ltp-crypto-tests
* ltp-open-posix-tests
* network-basic-tests

--=20
Linaro LKFT
https://lkft.linaro.org
