Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F0A207520
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403992AbgFXOBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391062AbgFXOBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 10:01:06 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E428C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 07:01:06 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y13so1325276lfe.9
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 07:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=txAQaxbTCMLo8x/+VG8IbEhFhSU5w166AKvUL10WpzU=;
        b=nCp7a5HcgIUlFf75HKyQfQgq+wlGBvm48Kvsh1VneHiH4d59er8QEZEJP+PtudAXz3
         NUf3R3/ME+60d93sJr/U0J9keJLAH1XSeFNRf/uJqb+aeq8yIXDAH082LWuh1kXFcSuc
         45/EEs4aHxpzVfu0m7I4yiJ+6FuivyPiVK1g0L6R5CTbKKFoVwi5i2EQZpyn+sk/3mko
         15aMpgNpCVUG9ZTXeY4NUk3ZQU2fdLnnqgVLoiiIJ67tcr4kP5+a1e9nMQOeHpwi+X2v
         NWTqHRktpBwCt5hSW7HhWwJPs8w1fLeeCjJdTZTEJ1UTFpzTIZQI0Sl1pygFcJnIyAlZ
         8ygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=txAQaxbTCMLo8x/+VG8IbEhFhSU5w166AKvUL10WpzU=;
        b=opjF8cMCUuP4DBh0+mm4p9WQicMMkBmEswEnquZH0Xf5lMAJQwdujVvxKzzpNlz6a3
         +9lb3RYkrGw7RzSL31bi+A/i9UUnlpPtLwg812VbDdupPpZzdWkgoNWxwOC+KXhA27u8
         ixxSjZBTyAg7pTjKbFre20cg2eOgEZgWJ5jnqRd++n5E6hYdxpjsHE1XLz+ssKkhTwoF
         oNQ/5CHQFKAj23JJeEdFsuYfxBI6zLsHKI4a1yeO5tO4aAM2RWDzyQ2rxiqY2LMXqq01
         S/b0K8RTALyw+uGWaIaewW8ZA7bGNhlunL0bNxPysTYGkk/Osr2Huj2RZpY/k2o7OjY/
         Ecng==
X-Gm-Message-State: AOAM533af+lErdE3WKhQ1JKjiOzuBXyNcSTFTXY1OsovcVzK/wgVYGT9
        C+kbSqZpvFScryVChvwLOVT63rkvu/GT8vHHeWciYQ==
X-Google-Smtp-Source: ABdhPJxRHCgryN28ag9fEQT7zXllZ1PRtu0A1X9BXy038Szqr4/3TXTkrTEHaWX33k5G5pbdjY8OmnBz/IM506eC79k=
X-Received: by 2002:ac2:5325:: with SMTP id f5mr15440767lfh.6.1593007264743;
 Wed, 24 Jun 2020 07:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200624055901.258687997@linuxfoundation.org>
In-Reply-To: <20200624055901.258687997@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Jun 2020 19:30:52 +0530
Message-ID: <CA+G9fYvz0P+M2j-xuAATQScmXgz=gJOXJdHGdPdsC0KveNO6zQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/203] 4.19.130-rc2 review
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

On Wed, 24 Jun 2020 at 11:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.130 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Jun 2020 05:58:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.130-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.130-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: f12dcdbf9d549ca30275420a0c7f1c27ba80bf23
git describe: v4.19.129-204-gf12dcdbf9d54
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.129-204-gf12dcdbf9d54

No regressions (compared to build v4.19.128-266-g7e6addf7237f)

No fixes (compared to build v4.19.128-266-g7e6addf7237f)

Ran 31466 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* kvm-unit-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--
Linaro LKFT
https://lkft.linaro.org
