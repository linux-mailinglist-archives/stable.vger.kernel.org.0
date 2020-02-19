Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820F2163A53
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 03:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgBSCjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 21:39:18 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46231 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgBSCjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 21:39:18 -0500
Received: by mail-lf1-f66.google.com with SMTP id z26so16069618lfg.13
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 18:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=60VIe0tObFe5ZoC97rjmVnguUIDOMQa1br+X3tRbe10=;
        b=UHca1o/SHo7SCNMRYI5uY8DaMu5GNllMTWkGXc5MS7P+s59msv88R2RviPw2CrOdtu
         CBYu4sbldJnVT1FZ4EGw/g0beAcwJZibwEdKWreHa7YxWkDE+ddKocoIZ9UR7ShdnQVZ
         d0rJP2X2GMfBDkIsJTqnqbDLsagB+KbZGkN4sIy6+SQyvunqj6whX/S3KiHe+CCAuSUe
         V8V6ErHKDlLBVBklt76W8/t2SyUb3RxNGmYwe/GRHBAp/LmO2TRDnCr8tJNL5x5W3OeH
         aN2WCvS1jho5+x6IQlq90GqSRdcEHfB7aS4FipQh2m0FegTyCBpi43myQ0pZrYyZekNQ
         3Baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=60VIe0tObFe5ZoC97rjmVnguUIDOMQa1br+X3tRbe10=;
        b=sADgdM0fzVR6breRGdq8xn5DDT6/V1eLWxE92shIWDujmr8mRQOfk9HsrmkhywxqzD
         0i9ScNLR+SgqXwINLQpOoaa5scLUq41QilUCi+zZ9UxCseLDT1/f7wr6yEH+7xNUDW4r
         wARq0msFbYNEadH3rTitv+Iis7O3i+MN4u7fLPvjvalzvizTn4FRPtVXyvw1Q4DkpMLP
         hZtwiuHrAMm44TSo++lApbLsr7LeZQ9A+tKf8N12cEohXwZLTbNHwahdjRvVVCMmeDRe
         e0yqPX+skHqQc9K6vHPxPZUanGl6em5rFtpIoANQb9mrGoSvunqSPDv5ehMWT31P5BoF
         DiNg==
X-Gm-Message-State: APjAAAVgYRTvYRG4C03Ko8zbu74pipxCVNMxVKIfGqcXyyqPOBMO00gV
        knYq9+yNhIGBkwgdTmCCPMQm7QxTtuWWg8RsjdnpXA==
X-Google-Smtp-Source: APXvYqzJM6Bp8/duZfOtgIHDfdILC0e0bJjneyJsmVwnnJSvPRPpbhC+jzIEaDDX+lRvrEHkDYny86gzlmRYtk6cP2U=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr11383861lfn.74.1582079955688;
 Tue, 18 Feb 2020 18:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20200218190418.536430858@linuxfoundation.org>
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Feb 2020 08:09:04 +0530
Message-ID: <CA+G9fYsdcDkYdinGRW+0dtEz-qojZi67dsbnuiOF1=LiWKaUYw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/38] 4.19.105-stable review
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

On Wed, 19 Feb 2020 at 01:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.105 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.105-rc1.gz
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

kernel: 4.19.105-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 85265e81d664e50b5da918dbdf02b5bbb926b2ea
git describe: v4.19.104-39-g85265e81d664
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.104-39-g85265e81d664

No regressions (compared to build v4.19.104)

No fixes (compared to build v4.19.104)


Ran 23734 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088
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
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
