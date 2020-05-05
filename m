Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321CB1C5B7D
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEEPfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729336AbgEEPfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:35:15 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8D9C061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 08:35:15 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id l19so2072937lje.10
        for <stable@vger.kernel.org>; Tue, 05 May 2020 08:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZAA7onJRPzZjOTBQ9x3ajcbhIJAzkJ5I/J+jTuQ6Q2k=;
        b=E97CcwnJoQaWV6oA4UNCFfR3iGM9N7GMOtrF7Z8NZseCnvGZ1XoEc39IlimdrqV3sr
         Jkbwry7o484iTCPcczKikLU+FulNIGgt/IHOxwCJKojkNmNYUbZM01VjMBtHP/04I+uQ
         X5zzLXbn7p1fUf4kVf+wHRCo+ZhmTYZehCp7oad6Az005kGNjfRgAOdgj09e2EWXqg7P
         a0uzcZM/aLFEbvDVhtyeGyi61vWpC3Gf5QozbKrCbwB+rJsR1z0HJ86CAlqvdtPty4Kf
         qxyFa3pGTaVU5QJ3cnXpxPt9h2qIdjf69DxSnCxixQ+C+xcVTXwTFKht1E2HrVj/uY8U
         P6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZAA7onJRPzZjOTBQ9x3ajcbhIJAzkJ5I/J+jTuQ6Q2k=;
        b=Lc8bQjPLU95Csdn409TCZDwUpQJcyTcoGt1i9OeYf4AbEh3uEryIVvaW8a+1EZQTnf
         3shgIWWx3gqT+VhXgoH1Y6GkPm+5XH9CjFjY455kiVfd/PsNXw4G+V3ncTq1dN5BN7lJ
         0nMtSw0M0H+uHlT2kA0L4guNkisyQ9Q7+JmUsGdNNthEaoszhNKDcUXytPK8afG1s+Vb
         wMRQMrD/R8o22x5yoOG8HKaeC7mo15J3tflGIteXw/lCGqE04g5JCjZJAQnoHZRGUvOS
         fm+noZ//lwHfXvazbvM3tL/+LQLM0nhZllh07n1EbsaZpnA3eGM7wBHAU89Oe51plbeC
         ncYg==
X-Gm-Message-State: AGi0PuZEeaLBpxqsijYu0J5yJZQMivR6hsi+lVfRFTu8RPcdXHeaPlag
        YKKDkSVNTa89yVNa6LGHbCHRqb6bpH0hKigc/6MW/Q==
X-Google-Smtp-Source: APiQypLDoWYmW4L26SDbyERJjIZ2DuJK2gWx85BAOQiZuPUtk8T4uqvnKdZi0zoVn+YVKnNsmihG6a84YQ8CsLN2JBI=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr2201549lji.73.1588692913181;
 Tue, 05 May 2020 08:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165442.494398840@linuxfoundation.org>
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 21:05:01 +0530
Message-ID: <CA+G9fYuvxY=67EPMOHuYQEkFHELHq0fODx4ZPw_Fi9QgRymhqQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/26] 4.14.179-rc1 review
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

On Mon, 4 May 2020 at 23:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.179 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.179-rc1.gz
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

kernel: 4.14.179-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 6d39cf91974673a74d6d976ecc107e43bb5c3eb4
git describe: v4.14.178-27-g6d39cf919746
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.178-27-g6d39cf919746

No regressions (compared to build v4.14.178)

No fixes (compared to build v4.14.178)

Ran 28789 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
