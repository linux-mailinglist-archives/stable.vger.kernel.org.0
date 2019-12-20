Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC8127555
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 06:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfLTFdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 00:33:35 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45533 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfLTFdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 00:33:35 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so6015977lfa.12
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 21:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ngk7MR82Kujt41YTaxo9DCoXoeevZw1Ny5DAOv5vUYs=;
        b=gyomviufSEIGGtqYI2ZexwCvjiMMuL4wBewTCLtq1FlhthpLWIYvf1M1+B6a0Fk3yl
         9TFnEv7qsJfhPUY60VoMthEPPJCwEQAygIkfMeJ/I9kEZUL4rNiL3/kg4Bqjcxe/ZNjr
         b+f4ntctttnx0mTUd8Do5HYa5b7pWtcsid3OEF+EBXaDMTJEP0BiUTVBY2OjCLE0dZ2W
         M5mwdknXqssZbq7eXmmlCVQCP+P+V7JDvKh7ABGuGUg8PUhrwTcrbTHHqsbOq5AKQTOu
         lKp91H2F35uUmZ3TxoAQ5SN+1nQF81S0mXggNtoxTe+aBmODVflzCEfo0x0E+/BkrdV1
         4q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ngk7MR82Kujt41YTaxo9DCoXoeevZw1Ny5DAOv5vUYs=;
        b=PyTiyAwfPi3GCeU84ZzuZHIeQ/2H6hEAv2bU4YJEI7LmeN56Rj4cq/mAHpJboe+j7V
         ltmu/x3urLg1JLvJkpjWDiDmOfzbDURfNQZA0gwJEzJU3Ucq/0IXZTBIQqcD4to08rSb
         6+nnQtNRb9ZqjJU2YZdzWH7BO020N7vkSOs/oPbzbCjNY0KlP9kZeNrws8s8de6N7LVz
         Gze/HW8xpnbAXg+UJHyznyRsJySobzacxC9YGefZ/KlEMWzqpFfqie7A2YBQyEk+HPSV
         Mu436NXRMy+5s7okMUB6LgkLcRxEcqb5qVtTsJ/NMMZAc//kDGiRa6fmcI5frxgATDH0
         7TFg==
X-Gm-Message-State: APjAAAU0HeMB2K1v0ls0AdcGVDqaHoCYqIYFt8x7yHJV87HlVUoIVKvI
        zO6MEJ06PjQJ3bA8icnxigq6GDlrUozpmaOsmuq5fQ==
X-Google-Smtp-Source: APXvYqyH4vro5ctW+OuCVlO1JYgUQuiWnHhnKN6KUZxqq2i6G6rao+6RI+KttPApFqgcxTXVnyvutjo90vAwpg1FWvo=
X-Received: by 2002:ac2:54b4:: with SMTP id w20mr7822856lfk.67.1576820012993;
 Thu, 19 Dec 2019 21:33:32 -0800 (PST)
MIME-Version: 1.0
References: <20191219183214.629503389@linuxfoundation.org>
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Dec 2019 11:03:21 +0530
Message-ID: <CA+G9fYuoeWKys-sY1RcuJ9sHQF_5n6VFJ5ATfEQ_rfj1RXb=bQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/199] 4.9.207-stable review
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

On Fri, 20 Dec 2019 at 00:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.207 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.207-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.207-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: c87cf142499122d38d7dc3cb92c9e9072d646591
git describe: v4.9.206-200-gc87cf1424991
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.206-200-gc87cf1424991


No regressions (compared to build v4.9.206)

No fixes (compared to build v4.9.206)


Ran 23314 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* linux-log-parser
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* libhugetlbfs
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
