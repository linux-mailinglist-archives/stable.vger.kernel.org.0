Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEB12C1E8A
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 07:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgKXG4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 01:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgKXG4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 01:56:03 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAA5C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 22:56:02 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so21121245ejb.13
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 22:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mBJZ0wwdLwaZ1wTyKtUWo60nHJLkJ5lKlr3wNetCMDw=;
        b=aP2KLJfagkQB6OY0pj1daVZTnoqOdgM8gfxf/Aod00LNf9RXL7XN0/VFBybRmOhdmR
         XA/XCudfirllEm1mNwd/HMtFu6n8W+2o5X83qLabY0FzrRFHDJpIC8H+E6Qb0YIRMz7u
         wroQNk3fWdTROHAyZfKGEBpq+cYJfoyhATdXJWPZrXU30vaVTo4tYvkGm0Lih7o3ooGk
         XjAsI2dLGVuaaKCVqtTGSJ+bjjW72i3Xrlf4/SQeXevtlQIXx8cF58SgADXpR7OzlE/t
         nClwXY7uJfK7FoOwNpasSn6Kt7P4grUW+tAxy/cTUD9frlKwwcDvPb1yKRq/rirb59RR
         PQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mBJZ0wwdLwaZ1wTyKtUWo60nHJLkJ5lKlr3wNetCMDw=;
        b=VBZ0jvQXLbJZm4g/9s0jEwMRvHm3SbNjO0X4BlvMejXDGmOE02gyjRxO/3FaKBc5x5
         jnFEN4sruyx3sBZOuuu8ezksC6dpFd5RXXgFMELV1wnzAZcurlj7yk/s+XXxko8zdBPE
         9QxBjfcE/RD/8qwNLYpWN9o6FcOI0VADS5Dr78eb0Sigw0TveTLuvv2e3BnmSA9vZcJs
         zYyjllshT4NMRuKdD2l7AnPpst2SgLqspL/v9mJ5Gjm1wg0YuI5OPtFfQ7zvVMxzo5sX
         TXqCCfLdsAs/I2Stnq8ezO93mUWJeNa3wMcZQwdTXwIRYUejEIFwZRgZNocJRJKYdPCc
         JbWw==
X-Gm-Message-State: AOAM530azI5N7FyHFIChnxVsFYiE90AcJNp6ppY6TJ5nwfecCFL3WpgZ
        ElSdZ8KW1yHYWdRW1HgAK40+zQExbofNFcg8g5u8uMOjrSr1pJTO
X-Google-Smtp-Source: ABdhPJwF7ny4yZX0pI3tx5wLq6hNBaOjwLfFwHr5ojc+rIvAleiCW+xSIA199fP/dPd2fr5EL5vHslfqWHwcw7Dzie4=
X-Received: by 2002:a17:906:bd2:: with SMTP id y18mr2746034ejg.503.1606200961345;
 Mon, 23 Nov 2020 22:56:01 -0800 (PST)
MIME-Version: 1.0
References: <20201123121809.285416732@linuxfoundation.org>
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Nov 2020 12:25:50 +0530
Message-ID: <CA+G9fYuPHg7x1FzsqniqmAdN+x1f+KY1a52ZsdCMuqyy7y1jgA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.160-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Nov 2020 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.160 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.160-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.160-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 6f94b70fe8f995a6d337b163e35735f9dc957ef7
git describe: v4.19.159-92-g6f94b70fe8f9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.159-92-g6f94b70fe8f9

No regressions (compared to build v4.19.159)

No fixes (compared to build v4.19.159)


Ran 44060 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* network-basic-tests
* kselftest
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
