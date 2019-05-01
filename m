Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAD510576
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 08:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfEAG1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 02:27:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44446 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEAG1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 02:27:34 -0400
Received: by mail-lf1-f68.google.com with SMTP id h18so12407517lfj.11
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 23:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dzm4zghPHgy0zEn2cLtSgFxZC88oT3myi6wWsLQwn5M=;
        b=qpcTg3+KqhqkDGb+iGg+JnRB03XssHdca5/8OGluAOxTrjz0kZNilD7VipUIzdvhPs
         1p2bKMuymujnnYR3AXKTnm3w2pBu8bnwRq6EWP+MC3MwPYiRnpmcTN4ywhXiKEYMwFRy
         uYPTiWqS4z12eycdaRofS3yR1wiBhH3ojmKFWM7D1DINvW475AR9eARza7TpBF+GVHiZ
         59PfXLnCJCZ/yY1uIjiIja88Xs1rryE4teCtghrlrXJ1d+YzsZBnsK8X05ujprevBfqt
         EFr4usUmY+QmDRqt4j5OHqjkitCH3pCBX/+UvHOEeDKi2XfsaAD5hmj1oHsyo+Qc5EJu
         LA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dzm4zghPHgy0zEn2cLtSgFxZC88oT3myi6wWsLQwn5M=;
        b=aOzsG6FrPWxdoci/skU1XaP/OkCE7Bz8c7oDwBtekuA0//fZmnZ0HCVZKe6+Y5YFiN
         u4rjm80iTUb/wfBG5HXx+PZiQGZf/Q+CRYQBggezyRCdj32sAmLqwSsEooA65UvmI6nl
         LQt+pmzyx/qZcgW6coL+KjsFH19r4oWc+6341CwcekHJ3+ze8l133b9uUugtNziqBLDl
         gJLxAeeeNuDvcYsmt5Vh6czyvDCka6M/b/JI63/i6LM66YQgP6ntK9AvLMu8hBQR9Wa7
         eTYSkPPGtuNTlcJnhjcbjU3kq2oWDLTZ1MpaITb4f4GDI5SuqTUd9yEYwaaEcZX6fIif
         05fA==
X-Gm-Message-State: APjAAAXvBIukjeYeEwSOSxzJLOcEDEf2E5vCxD1gWk2K7uEOS4qLQTyh
        dqG7DAJWexR7+F0Lj4mGsXyurZASnSQRorBAMFEf8Q==
X-Google-Smtp-Source: APXvYqzPq9RimoaBMRncwlJYaHz31pfM3hP17Pcu3n0BLA1W7ruAJj0HcyveNNBvD5oFLLctMrax/rSf4E5iQ3i17WM=
X-Received: by 2002:ac2:4a89:: with SMTP id l9mr10118545lfp.60.1556692052879;
 Tue, 30 Apr 2019 23:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190430113608.616903219@linuxfoundation.org>
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 May 2019 11:57:21 +0530
Message-ID: <CA+G9fYv60oqvt+PTEdEi8-B_riM2_WwQWXoZz1fOa_OsQYzSnw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
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

On Tue, 30 Apr 2019 at 17:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.38 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 02 May 2019 11:34:55 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.38-rc1.gz
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

kernel: 4.19.38-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: f0b5b3d18a2fd4e0a223ff2ef04d4d1f435d19f2
git describe: v4.19.37-101-gf0b5b3d18a2f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.37-101-gf0b5b3d18a2f

No regressions (compared to build v4.19.37)

No fixes (compared to build v4.19.37)

Ran 25050 total tests in the following environments and test suites.

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
* ltp-timers-tests
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
