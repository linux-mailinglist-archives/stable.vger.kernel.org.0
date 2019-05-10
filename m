Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC460199D7
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 10:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfEJIqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 04:46:02 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45385 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfEJIqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 04:46:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so4365189lja.12
        for <stable@vger.kernel.org>; Fri, 10 May 2019 01:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/7KuvorsOq0kwSMfoZ0xez4TAmMJrwzjBA0BflDBnqY=;
        b=TPWyj+bol6+mu2lUdOtyol+rc4oKet/7yxsgjy2WCz4O1ejvVYVf4Qla8ZDT7JLGi0
         2aWJpC5bXLoFPXWWnsOfNp1HeVMQItieByh00FsRlsubNojZ/6uC8RJGKjgHi838G4PL
         Um90YgU6IH8+wMqmdH7N/v4ebsC7GcrQDnbsGh0XtfW7G2M511RrQcwxuEH9EGkHtSxA
         1H6LKMc0GVk7dPmjQnZMOL93pF431oQujTpU+Eil7CE7xHpZMJh8+TRjfK5rEG9hGeyD
         Ld9StdnD2/Cmqq6utAL2iOx8qlz7oG1WRKLQofVozqwOwVunoB9KHuZzQ7s9tBcUQ6QR
         e+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/7KuvorsOq0kwSMfoZ0xez4TAmMJrwzjBA0BflDBnqY=;
        b=dJK5nqVKipkutEnCBv1ZjH+rRvpNGdkO8jDCZC2gPdDfc61Jw88fkQsOff6NWddSTP
         ymRYT0JFq3A8HfgPi3ikO8aPVzRLcxh6JumSclPNtxbULfpk5z6Fctv6jKfLRTQbGzRa
         8uO5ChhQAtELHPcOevuhCnBAI12031QcF7Dgta2cwsb3UqoRcqGik4ZUkvVe2j7VqrXM
         6scJveVdv/lLAtHzJoAtgMAqZXi5D+bKxY5iH5pLL8+lulr4+a9AJT0RKYFQHNkT+AVQ
         ZIP32FwC2IWRweSE6JuNVAsXjw0WagfyAU/LE5e+4AobPMP8HUFxsokAMESQCMaLILVG
         xmdg==
X-Gm-Message-State: APjAAAVB3A7Ud01ooypB8jCtFVLIHso6ubZwgfx4GbQuQZApvQYYv3yS
        u0FBO9LBMYW1PAKRqQ9YbG/Fn+fagaC/JW76B3YzISWVL/g=
X-Google-Smtp-Source: APXvYqzOkfL35cKRpi0Ajvx/JGvyBCRS5w99p+MDvxwaBRtvobjVmQLCI/d9t0a1ATWP6zOm0/Ery4ngcIIbAEY/hU4=
X-Received: by 2002:a2e:9193:: with SMTP id f19mr4982668ljg.111.1557477960404;
 Fri, 10 May 2019 01:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190509181252.616018683@linuxfoundation.org>
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 May 2019 14:15:49 +0530
Message-ID: <CA+G9fYsXQS3vhfjmqnrN9yZqujKnvKugEVaKLVR0=3=N5A8dhA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/42] 4.14.118-stable review
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

On Fri, 10 May 2019 at 00:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.118 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 11 May 2019 06:11:15 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.118-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.118-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: fd7dbc6d8090b210573e19d5a50f7772ec4b1977
git describe: v4.14.117-43-gfd7dbc6d8090
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.117-43-gfd7dbc6d8090

No regressions (compared to build v4.14.117)

No fixes (compared to build v4.14.117)

Ran 23536 total tests in the following environments and test suites.

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
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
