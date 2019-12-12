Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442F711C521
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfLLFH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:07:57 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37866 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfLLFH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:07:57 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so648643lfc.4
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 21:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ak24EqfuSoiTkrHNDMRZ49rWPQkrtzEZ+p//LwAqXXo=;
        b=LeX1J7Ja6UGDEi3w0X9Jvy5W5G9UqKV1VT5p7kMAW+nowPqheO4eWjfYev1P5c0zCw
         F3SIBJyiqO7V8aJzrfBLXtApIHE1+aH+25Gh2ocEzCXvatnZSxq3c/drSEjzrXvtpgof
         83EAWN8aFluwDCLW75KAXgUiWKFbnYBP/oGM3AL0C+/vCptF+Z9mQZhvTyyFPhzq7Iu+
         ojngLjeXL+k/76DDmqmxJuKvCLppSuuv6e/K5xG6a3i8esWLFblASVcTGyZl4OpDKJDD
         BTvlXvzKPPiPjPTDBh6vdTC5APAYOmo1/ZcQ7HhdPAWUQ5o44qkjBB6ZuD7XjrBSu3p1
         YbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ak24EqfuSoiTkrHNDMRZ49rWPQkrtzEZ+p//LwAqXXo=;
        b=U4IVTx5gyAibZjpzQzT1PQgFuZuHTo7fiRQ8LE1zkxhgO+MbS8oBmiPCmAaxhvs+n/
         hsLvq9Fs1Oc1BhQ9WkbUk3DW8eEICm9440q3JCvyLibRQRCwsKskAJoNnQOeYzWwdYZJ
         oud0AMv+vEWkzAJ2sF2+zUhnxj+E1agK6r7mvkLj2+d2EEbOZbPR4+hLFzRcvM+6pI5h
         gDONo/SENzxKvMk0WTVt/WkVDcaJaybzdcrun2/3U2rdudMdKDSfnzrS42+CEZNTPXnF
         hKa1ki5AjOU5sHIC/tu/DgA9k6knUFNH1MjTb/x7rWkMOaq1jlhxlGOvEENoFN8nszon
         QeOg==
X-Gm-Message-State: APjAAAXa+caqH2USHGHDz0LYVbcXWLyxts9WuZsAutVZ7uayVceeROhn
        Y5mQM987wwmLUo6larRx1Z6SGPNXsLIGAR4XXFwi/Q==
X-Google-Smtp-Source: APXvYqxKr+PWrP0+p0uZOFggLzKbVSAt1wVrRNXMtNFHYtl/+ZajN3jLbQnSWoAQQRdoUeARYZkWF8nGAwAoi70qEdE=
X-Received: by 2002:ac2:4a91:: with SMTP id l17mr4507584lfp.75.1576127274729;
 Wed, 11 Dec 2019 21:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20191211150339.185439726@linuxfoundation.org>
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 12 Dec 2019 10:37:43 +0530
Message-ID: <CA+G9fYvpRtUDaNRpbCO9RKEFG_0qF=FWYjiy575RqFzg8YkhkA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
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

On Wed, 11 Dec 2019 at 20:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.89 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.89-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.89-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 62dbca0959b37287a49ac6a949578849d490df83
git describe: v4.19.88-244-g62dbca0959b3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.88-244-g62dbca0959b3


No regressions (compared to build v4.19.88)

No fixes (compared to build v4.19.88)

Ran 22458 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
