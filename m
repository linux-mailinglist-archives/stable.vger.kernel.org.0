Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C991B56BB
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 09:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDWHyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 03:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgDWHyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 03:54:04 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191D5C03C1AF
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 00:54:04 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j14so3963252lfg.9
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 00:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4UEOdXwxEm6LM9DNvnfZm1b3ROrLaqHjn0hz9sIJcG0=;
        b=HSnjqWp/6qALA+mTUDwmajzvAkmImFFkRkVElj1CcoJnHeBkUqmj8M269JuUj7VxwP
         IE9WFiYC2WVF51462BBD5QcmrMpiJDvBGyY+nds/loi04iOEB/39HrWg6weyIOY+mwCW
         mBucRmf/Fh8xf6Q5ZKPOLnGKtCwqvjl7Y7nTfAfiT/BB/cjlXhXS5oMJeV9Jga1Zkc2M
         NxVcPXgtJs/k6+6AhqrEgl4TUEtUTut+q7cVRm44M2RHRYgfK5ZEqHdSx205CUG6gTlh
         eNkmMsa9VkySIOuKNGSsQpcfGpZXeaH+Pq0wBEkG2cZSoorSDDeUL/xXxqcXM+nSaiXL
         A5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4UEOdXwxEm6LM9DNvnfZm1b3ROrLaqHjn0hz9sIJcG0=;
        b=UATlNogGYyx5DhjERjTafrUXbnccJ89F2RWxljklvkmpNeenWjZGDeAll388XCydNM
         ygioMy7f785Av4i5VnnC3Fo6WLIBeQ6kW/DGoeVxWZh/HI2y3rF8sv0kvAzVkcbqCkel
         DC2FpNlxD86MXWQcVZoUt+ho7w6/h0bJqHqxVysCXVmJnXqt8F7OxtcrAD0Tw4mubkKE
         ZPgWQ5zGrZrYpRm8mdLuBGMEET90R5Bk44fnbJ64WMrNNElrvO1VdpWnBkJEvz5jGgGk
         O8c30hJGp2Xmv9LnTKXqsvvhWtXWcvObgKhs/X0tYyz/JHcIW/0d1wAOrMRW3K37pCKX
         LoMQ==
X-Gm-Message-State: AGi0PuagasesK1mfKvNiWpfXDEiNFumrvw8PkvBjiVHJhn8ahIsuTbEX
        KtuQvqZY7wReopw2veokpybv9M9940hBaQ4Kn21WMw==
X-Google-Smtp-Source: APiQypKrl1JJiWs2QGieTdGaz/MFZsBlr4BPgyd5GnMJ1EmOHaWBJt7et4F+l23ntDj8Wl8ea9hRxWe0kRUpzTtYHvw=
X-Received: by 2002:ac2:4da7:: with SMTP id h7mr1565819lfe.95.1587628442305;
 Thu, 23 Apr 2020 00:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200422095031.522502705@linuxfoundation.org>
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 13:23:50 +0530
Message-ID: <CA+G9fYvzMkSyzQzsBeHgc1ps9s_SDnU3qz8fAXEwD-U=8xDNiQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/118] 5.4.35-rc1 review
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

On Wed, 22 Apr 2020 at 15:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.35 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.35-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 186764443bf32f12e07093aaff52dd4a25231781
git describe: v5.4.34-119-g186764443bf3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.34-119-g186764443bf3

No regressions (compared to build v5.4.34)

No fixes (compared to build v5.4.34)

Ran 37179 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* kvm-unit-tests
* libgpiod
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* v4l2-compliance
* spectre-meltdown-checker-test
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
