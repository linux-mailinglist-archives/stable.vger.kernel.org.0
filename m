Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3387E2F2AC1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 10:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbhALJFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 04:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732924AbhALJFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 04:05:41 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9681EC061786
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 01:05:00 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id p22so1415692edu.11
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 01:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GoAiwBdR+UGEXfQO8x9rGvtN4+dxjG923uz351HDy5E=;
        b=ptJhqmISzOF6rULF5tl5alqrxmyjzx5T/019SB2adHJBObHLEjfyql5TMpclirA4z1
         YhP7+IKRHWGaut8tNzdSGCXO9jY6Gd3zoOv/KVQnUZW6lETA2K9uFgoYLx772N/V9m1Q
         C+jHCRgXOU/vLSXxOjvRcJQYt2mDBvx1mXMVAO8qUkbViBt30mhTI3nWLJagxhzR186I
         SAs+S1j3LA1zZuchcrmXb/pugQOlsbXRyuaDJR3QUGXnQGFTZVn02+8w2GGE7i15gwmn
         n5JDUZv5PSsARhObpU2wHiuKUdncwNRiPwOhFN1l+1+z51YpZdeprKh/uNK4LmID9xfV
         5T/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GoAiwBdR+UGEXfQO8x9rGvtN4+dxjG923uz351HDy5E=;
        b=rmvDP8FLu5alDIRgqxhz6q5aDBqMmTk7K4U9o6VZWh88BcIO2N83pUGk9l0QLKxNdq
         QdDJ/av5KSHDc9bd6CbZawS6yC9ZXaaGYbG0v8LEPMZ/JgKfO0yPPyHfvEqHcUqWzfhr
         GHoWoyu6O8jcPyhAfj28Rzwf9rnDh/QFjHHnglsFLxyD/THKuOeSFH8Tj8hnRKzRMWl5
         lkvoY4ZNiuFPAQjb8PKWawu6Pzs6jyAcHBrLX2B679j6q+mXoYXKAtQkyBFMGC0ELXvC
         ng1HRn0SGH0i6hNtVfqJhR0JeeVCSt77WF1k2e2JjwVj8KQXT5kXUze8IQa7bf/qGOGp
         D/yg==
X-Gm-Message-State: AOAM530X4wEa7bMVnmHKBwf5fjg5B/eWsoESaiH3K6SU2RCIpJk9+Vih
        Aj6zzhdhRFWx6Nam9KEwOLRmmDvjdTR3s2Usqxmcsg==
X-Google-Smtp-Source: ABdhPJzTkzYTwiTZ/Vehniftw3kPi5NGTy0f3BM4G6gt/ItFeRawleBuYgujW9PeE6r+D5fTtx8VcgWUR75+wm9EH/U=
X-Received: by 2002:aa7:d75a:: with SMTP id a26mr2516183eds.230.1610442298267;
 Tue, 12 Jan 2021 01:04:58 -0800 (PST)
MIME-Version: 1.0
References: <20210111130032.469630231@linuxfoundation.org>
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jan 2021 14:34:47 +0530
Message-ID: <CA+G9fYtKASrXpZ6cwK=_N1MKWVd9-RACRr2KWhVL=h2nKQ+QSg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/38] 4.4.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.251 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.251-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.251-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: b73dabb6d370f0b223b72488743b94e360f52d94
git describe: v4.4.250-39-gb73dabb6d370
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.250-39-gb73dabb6d370


No regressions (compared to build v4.4.250)

No fixes (compared to build v4.4.250)


Ran 22095 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* ltp-controllers-tests
* install-android-platform-tools-r2600
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.251-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.251-rc1-hikey-20210111-893
git commit: 0306c0e77586309f1eb65162c5844c9fdf2154b5
git describe: 4.4.251-rc1-hikey-20210111-893
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.251-rc1-hikey-20210111-893


No regressions (compared to build 4.4.250-rc2-hikey-20210107-890)


No fixes (compared to build 4.4.250-rc2-hikey-20210107-890)

Ran 1768 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
