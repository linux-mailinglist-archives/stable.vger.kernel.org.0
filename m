Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2332D1300C8
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 05:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgADEfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 23:35:41 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41433 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgADEfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 23:35:41 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so33102785lfp.8
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 20:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GgJWXyNQ2t/WuGozMvzM0PAmQF6D37v+J0alq5lK21U=;
        b=nFBFNpJgzDWFDSWCOY8Oa/tRrrCr732zUza2+b8KvFE1WedtG0+fHIIia9eJGOVocY
         dyddTEHerYYAn9jek0hHHvMPdawsdjIEr+dmzhCyfGyY55dhul3SCQHyPd7GEEkS8fVV
         DfI9j+tuv0gwg8dR8Rwc7wcTlKEwqc6P5Espc5EcPkNyKisdxYpJrZgTc9YxPZh0mwKR
         h5rne9xIq0WuUs/kBRVyF8aXh9WEx4wQe1z6OZCt4Lg/Cb5tWVTis0xOaMuKWgPSSti2
         pKPDCyzgwhndyfZnPybNQbgqy8OQ5f15e0qY3AAaxOJ0cfSxfMpRixB6JIhbSyjxVb4T
         IJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GgJWXyNQ2t/WuGozMvzM0PAmQF6D37v+J0alq5lK21U=;
        b=J6IzO3FJmAMd1Yq5Wbq/ETt5sB2oRxSdPECtWFRwyLeyX3iCl6S8/jUbJ6JVfoo5oD
         XeBzgK1u5znM3YpwilG5dyVIz/a6mZiY9y00yaC7ViYkSD8Xo+vEarfZX5ZAdFtWelRL
         omXzWpR7rx5PcputhbILms7rWhWm4nhf1kTTyREkh+5mBNNibnt0tMJ8CgDkLt1KreoJ
         5tS9RjIAhkJDbCgAbjJoxu/H9Jkw7G+YkHW9JisksW9rYFCqOFD4dwyM1BDh53uVahtl
         quz7nDTwbWOovA751jmA50ZChY58KtxdKdDJrr1z7nkCUd4oN48lIa18C19Sk0VL/fVy
         OEGg==
X-Gm-Message-State: APjAAAXy0B3GFWBrK886fvGov3lhR3apl1S5sRYvw7ZYGbvtX0o3HvUt
        CMj46fyD7VaKRWH4KlWUYtWpDWIxpz9BgDLr/UV2MQ==
X-Google-Smtp-Source: APXvYqwmjgHDCTbZ0WsNs8wo/CuaBUekruJlOAJp59zFh1YZZCmvJGl3+3a8T5mdbh83h55sRrcU+PvyIjYSuYVU1PQ=
X-Received: by 2002:a19:5057:: with SMTP id z23mr50920474lfj.132.1578112538972;
 Fri, 03 Jan 2020 20:35:38 -0800 (PST)
MIME-Version: 1.0
References: <20200102220546.618583146@linuxfoundation.org>
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Jan 2020 10:05:27 +0530
Message-ID: <CA+G9fYs-GnWRzSLjuja6ROyr93G3DVg_7-f2uXTOu1PBP6dxAA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/137] 4.4.208-stable review
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

On Fri, 3 Jan 2020 at 04:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.208 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jan 2020 22:02:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.208-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 8eb04883f217f38b78d9fc0ef9044a5259b5e815
git describe: v4.4.207-138-g8eb04883f217
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.207-138-g8eb04883f217


No regressions (compared to build v4.4.207)


No fixes (compared to build v4.4.207)

Ran 19877 total tests in the following environments and test suites.

Environments
--------------
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kselftest
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.208-rc1-hikey-20200101-645
git commit: 45aaddb4efb9c8a83ada6caeb9594f7fc5130ec3
git describe: 4.4.208-rc1-hikey-20200101-645
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.208-rc1-hikey-20200101-645


No regressions (compared to build 4.4.208-rc1-hikey-20200101-644)


No fixes (compared to build 4.4.208-rc1-hikey-20200101-644)

Ran 1568 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
