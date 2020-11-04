Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698912A61A9
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKDKdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbgKDKdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:33:43 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C01C061A4A
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 02:33:43 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v4so21927464edi.0
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 02:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AFuwAHyzJz2urGkTV9BtTopzwKIo5qssfclcXvzk9k8=;
        b=kV0ihyKgIZHqomZhPyAzXmRLM4e2YdZjGG2C7CElIj19ORsIg4VaZIi/2dDd0XM4X5
         bcKTVHc2iyQ1S80Aa+W8yE7Il4Erkvx9Vkml32LarC3jqrBk0KEQI10mt3iohYtQuBJO
         pJAZVSq2pMvjL8tjS+WeMxyxBGcfBbbZwj9yM+VmvGxtTNH6apR4lGiW7rpUv6G8G2Mr
         ejNv4JHuskeZscOOiBhCITzzU0TW1U2euMLc6C0z0XnHrtjDYyPyqDl6nZ5Zje/H4OUx
         ZuVJYB0SQ0P9ctysZEEo4l/q+3lJfw1gvXE6d+eooF1+EYJMvqVAd1M2rYvniHQTxG4u
         r5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AFuwAHyzJz2urGkTV9BtTopzwKIo5qssfclcXvzk9k8=;
        b=GupCskLm33CKOxrbyFJhrz7j8tEZ5ooJSGgTeWLZWvTpU3cdzvZdQpufLEMthvTyB3
         wy+TeggfLfiBLzrpSRoosWXNvjTlIDDKCm5QWnBVZ6qoIJcxj+BS3sqdNj/trhDnoSdL
         aybdoNAgnN/S+sPaNcnwl/rl5/g1LqvF6tXqUfLwK+UwRWLm9aAV57/kSZGjzYLBaEiM
         px/+52kTm9NRU5VnjFnEUu6bc9CY6yDViIH3fqyBQG1xaG60CuveouqFOr3ah6dSl6WH
         Qx/cNwhpYORQ0p2ab0Sf9SmCHWGkc3/Cv7vU6xSwCsAYO042eFfsQu8dSTBkejBYSa0l
         UE3A==
X-Gm-Message-State: AOAM532IAYJgnrEweAr5orcx+ykt2XZxfh1j+NTh4cmgH+XsFEnht3b9
        /wXWtFeWfBe4iJarRhVVsS422A9DBYgAOdpEFfDwoA==
X-Google-Smtp-Source: ABdhPJzAEkgbQe/XkxRmeJElwgHaaXzHwRCSdRIGacdhwFhT8tUmDVb0Ei3pr25nG7rpHX6xg4EtNmGSvq+L6cFf6qc=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr27228629edb.52.1604486021904;
 Wed, 04 Nov 2020 02:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20201103203232.656475008@linuxfoundation.org>
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Nov 2020 16:03:30 +0530
Message-ID: <CA+G9fYuxp4Uu0bXOshqpJPHpL97LzU1O1KKKbyVuN4+jzLukZA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/191] 4.19.155-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Nov 2020 at 02:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.155 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.155-rc1.gz
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

kernel: 4.19.155-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d404293c76537ecf3e7724c90c5f61f7e8844f01
git describe: v4.19.154-192-gd404293c7653
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.154-192-gd404293c7653

No regressions (compared to build v4.19.154)

No fixes (compared to build v4.19.154)

Ran 31713 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- nxp-ls2088
- qemu-arm64-kasan
- qemu-x86_64-kasan
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-cve-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
