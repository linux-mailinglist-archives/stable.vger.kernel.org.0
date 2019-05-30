Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8B130024
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 18:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfE3QXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 12:23:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39858 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfE3QXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 12:23:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id e27so1259804lfn.6
        for <stable@vger.kernel.org>; Thu, 30 May 2019 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bv/mFS9CC6/OZ/sIVUU6SKDdjsoPp5A94OH9TBp6UhM=;
        b=BkdDO99xutRVm5tNbNa8Wa5ly1F0R4muVc4vMChVGCo4Vz9krnJyUk+4iPUssg+eCE
         CeTOPxO74MSKtGc95NPzy0zBMi7IGAZBEU0MBzpcsGX/BW5N1LATR1hhLBfR2Pmivvmu
         tfUjD9pYQuyT0zz1VsA0/mmikEFMSmc6vGdMdbG09DWksgMwwfs6GPGw4x/NJB/J2OF9
         scY+5YgzwNitlAgj4tLRjNgY+OfauR1G0YSIzH3wgPF0cD1VB7tv0fzZSl4S2qc3+ux3
         cYQ1cVMG18WaOVU8rUI/Cprtfpnp3eoZA1CrmOo64rXLI2WJ0eZ45iUfSCj1CASN+5ex
         thlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bv/mFS9CC6/OZ/sIVUU6SKDdjsoPp5A94OH9TBp6UhM=;
        b=ASb94SCDZVa7Jw41APPOw+yaBpPSlTWOOXLtBCj8UznhJtd3NxUX+FAlKeXzcI7TU0
         TlhNavauJaXjRkv1reatt4RR4mM7V4zzyzxeFYZdKhTURbtG8golSggMQqvnCLinxsur
         Vc7IukFxbIxCJVFUFYgT0Enk63aU2Z0Xsgseagb/Oq8d4mDHMbFwgphwAl8EO3qEN+xi
         kjQYbZv4VIGQMlTEpxCZgUrebqmRYW6h5dB6OQisKy/naMbAssJNVaPm5zx3tFxka0eo
         kyQpBwFi5HBWyBgW7OG9aCNFEqlVuvfErqLvUxjn+qpoI8nRW5LnTszIyQWXdQRBO0c9
         vLOQ==
X-Gm-Message-State: APjAAAUn2UF133Yyg43EezjAHoU7EGNDgLeoKpdpY4iK+RAqJ00xFRiY
        48HuyOtHz9hHvi4XzLS3OD2/0su+CUm8AVHD4VtlnQ==
X-Google-Smtp-Source: APXvYqyiLBLHtmBQOOHYewT3ZYon7PZYdDbyDEU1ogRqdFPpk4e+V7xsfzmfCWw/FAuhGvNPOC/kYzjxGQ4yLYH7FIg=
X-Received: by 2002:a19:ed0c:: with SMTP id y12mr2477008lfy.191.1559233424779;
 Thu, 30 May 2019 09:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030540.363386121@linuxfoundation.org>
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 30 May 2019 21:53:33 +0530
Message-ID: <CA+G9fYtW1E+jOKaU3qnhdwa63r1t7i04uMAcigWAUjVmDss6Pg@mail.gmail.com>
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
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

On Thu, 30 May 2019 at 08:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.0.20 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.0.20-rc1.gz
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

kernel: 5.0.20-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.0.y
git commit: 79c6130942fe2bc8d8cc92c526e93cce6a068262
git describe: v5.0.19-347-g79c6130942fe
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/bui=
ld/v5.0.19-347-g79c6130942fe

No regressions (compared to build v5.0.19)

Fixes (compared to build v5.0.19)

Ran 22805 total tests in the following environments and test suites.

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
* ltp-cpuhotplug-tests
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
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
