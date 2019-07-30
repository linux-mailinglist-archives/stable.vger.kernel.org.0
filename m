Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2DC7A1A8
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 09:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfG3HNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 03:13:53 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39301 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbfG3HNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 03:13:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so60989447ljh.6
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 00:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=euGPPD1eIvXtOUX5549+IyFWsRravUw6eFS+OtoISr0=;
        b=ijLP+t6eEZQmZYQSDPixEPzwg90AqCFV7x0fu/8Ao60sEiRGe/jbGuBzcYHXncanHi
         uPvk4zTz01kbLNDvkCQrXEYrmiVBWLBOgc5kShTLw1DO2xiTyrrDpllzWztZYCfZdG/z
         ETeq/mZ1ALIkqQ2cEE9Hg/zHANP1R8BdQB8kQQiVJvqCOK2t51pMoCGbYGSV3l9ByMMB
         UQCHF8d4yISs/T1BQHY2hoUWiPKTeKb2C8gtbKmK0XH47MAb1e+7ZXqseAGasDCwG2Ce
         QT0FEIcdOkAhEzrYqSwdJbuJs4q5O5OMLAOMw5vHbw0rWl5M5P+TJRbBX4ZrPdldV0jG
         fY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=euGPPD1eIvXtOUX5549+IyFWsRravUw6eFS+OtoISr0=;
        b=I8NAMwB29Jmj2BUedmXmS2fGnshqZIoMhtIcXCMtxXH0E7iKwqv5CnW8RbNva/F91I
         7t4uPChRjZ8L11yDmdK0S0pJzXNtEzQiX26NyEYMFcpsy52bWGe3TmaOrtXfw81FdI4/
         lSG6Vh1T117a3S+y/SO+pq9nD+TM0xtVWGCJf28J8jlqFBNFFjk/iUSW5cA09CI79ING
         y8L65MK0T5oTj840ZW4rDnHmymu1m2jWuv5lZz57vYFxvjjw+XWBG5qCLhEMXAQfW4Cp
         BihF5yyQF4jmW9/ZpWX9Ldcp0295cgglk2IHAy7E11VNYFUbwrHx27zO9RWl2zmec4pH
         lBjg==
X-Gm-Message-State: APjAAAUtkCCemqkUsAZ9+LWn7h6cnYLlFUYH4ccqbkeVlUcBYtjVugtN
        XV65Nk+NCuW+J3VIwb4ZrvNajr7xFqY8keKsBCrptoSAH3s=
X-Google-Smtp-Source: APXvYqxx1SG3uBUNOLIUP0C3cmO79sWI54VvoAkAXxELSEFMicLE3rCXzoHnKehJ/vw6gkxvnc3U/RkH2+HEfzwlacg=
X-Received: by 2002:a2e:b0f0:: with SMTP id h16mr36380851ljl.21.1564470827752;
 Tue, 30 Jul 2019 00:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190729190820.321094988@linuxfoundation.org>
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Jul 2019 12:43:36 +0530
Message-ID: <CA+G9fYuin5m8Rzc4_YF5tvjwsBN4=GXnkgmpD8-7U5fwcTnb7Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/293] 4.14.135-stable review
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

On Tue, 30 Jul 2019 at 00:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.135 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.135-rc1.gz
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

kernel: 4.14.135-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: f6ba73a2e356d3f40ed298dbf4097561f2cd9973
git describe: v4.14.134-294-gf6ba73a2e356
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.134-294-gf6ba73a2e356


No regressions (compared to build v4.14.134)

No fixes (compared to build v4.14.134)

Ran 22754 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
