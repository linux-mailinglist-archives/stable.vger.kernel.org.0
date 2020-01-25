Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1739149451
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 11:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAYKXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 05:23:06 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38830 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgAYKXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 05:23:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id r14so2909937lfm.5
        for <stable@vger.kernel.org>; Sat, 25 Jan 2020 02:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cg6yf7Xg2bJ6bjO85SSw53ECgULPwUTExuYpSHY8p/0=;
        b=nvHFIm/9DDj/w0idcoFsxyLE3HhmgnhMFFYuSboc88fwAGfMxZwk9CPXXFUrdNumWD
         OAs3m2FukpCdiYeVcd4TrPZJGI9A3SGG8vIxlcL1HH7balPK5/KxYzLDZp8U7CCcLRKx
         /y4HToarp+7zKC1I1OjuSP+iRTyh/3NZeD78DIMdVZwEM0VmxYh3VE5MeME9jYwI/VCl
         GQhmlnOSPxK+WAvMHulEKPv1hoIGZhmRFGRvPbYvxB2PEuJzpBdVjy9odFrVQM2ZCaVa
         hvZY+nFBCV21/hwcEzrtAkpe86fW5nsaX1SH84wsJ190qok1Z6o/3ScfBMiXS3Hws9wg
         ugug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cg6yf7Xg2bJ6bjO85SSw53ECgULPwUTExuYpSHY8p/0=;
        b=H43GfsRnMCQn0Ui+4/7pYTrr1YvdDWonesOYBuIzaOO5yvmVHO9tvG7JwggdiUpHn4
         Vlv/5W9D8/B9EsoK1F2jBUQXB/sOszQMAKW4x5wRNdIiV/P5GJBXtztWerRephCkVK9b
         qbHStD3Be3lN8TPYwo88UszhCN1Iv3AZtNzNCn3kfN2KrLzPENurdGprnTy4zTnJvl/r
         y0sa8tSfCWlxbVSUr3W4udRVDmsh8CK2kH5euy04MOR1rY3iImA/BrAONia2xc3pmQF3
         epM7chbNwqcXid9le5N9rdzr4ygYghaycYwUzNA/Or3RPtsqgNYIN4HGMdcMU7IAFe28
         fsxQ==
X-Gm-Message-State: APjAAAVRwLyZAzZe4zq3UDxQriWhgPYjV+T8WdgDUWQmj2BjY0Rurful
        GdjV1Pz4G2i0jQamsBOjChytWJHkVCeC0FzQmlwoTg==
X-Google-Smtp-Source: APXvYqwJ/ugFa53nnI+4+a4+LVBX8n+5970S/tTWvtc2SNYizZe89o+mfaT86iEtFM0zARv/7RvEMgDRGz/+NRg5ypY=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr3479868lfc.6.1579947784234;
 Sat, 25 Jan 2020 02:23:04 -0800 (PST)
MIME-Version: 1.0
References: <20200124092806.004582306@linuxfoundation.org>
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jan 2020 15:52:52 +0530
Message-ID: <CA+G9fYtCQv-eW3y0ySDmazcCDNXHfLuTcCXWj8kj3y0W_HWyVg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/102] 5.4.15-stable review
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

On Fri, 24 Jan 2020 at 15:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.15 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

rc2 test results report.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.15-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 5b29268443c010e77bd281f8439188f03c4cdf7c
git describe: v5.4.14-102-g5b29268443c0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.14-102-g5b29268443c0

No regressions (compared to build v5.4.14)

No fixes (compared to build v5.4.14)

Ran 25632 total tests in the following environments and test suites.

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
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
