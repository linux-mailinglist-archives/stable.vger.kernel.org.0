Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632A11CBF9C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEIJH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726885AbgEIJH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 05:07:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55033C05BD09
        for <stable@vger.kernel.org>; Sat,  9 May 2020 02:07:24 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id o14so3130787ljp.4
        for <stable@vger.kernel.org>; Sat, 09 May 2020 02:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pmogMLXEFzBZh/UBEh5xbOyIzPd7i3nbXVs8GZ0LqC8=;
        b=FR11I4ZioL0L7xWLsQ83RLH26X6X+PYqZFZFCbDFwo4adZgB/e+dRK41Ebt9s1m1Lg
         2+DV8H3bRxCzQAKAxusKdyiWZHOXA5v4PipXrzCIr8yTr28tErEu6W3Pqz4rYve1GurL
         z44xibFBxowfwJVB4bTpR1VDc7zr19AV3JMiUJNQ9xVUN8vRb+FaBDN0b3h0pVa6ssOR
         TuQ+xhVqtMlreXKQ4O7sfhtwFuBzIny9V9JNA9IiVuMpAbjj9nEzBGT9w68iUMIixT/T
         RqBqZF7vkzon3ulQYEH8YZ+dp5tUtpWV9Lx9/BhEn/KbKaLvyZrE6oifTzeB52N4d7et
         OCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pmogMLXEFzBZh/UBEh5xbOyIzPd7i3nbXVs8GZ0LqC8=;
        b=dW7Gj6R3VevG/AfOs/18/Aqmw9TQFmOO/LnxAK/yskr38iTT9A8v3PgLyiRmL2P+U7
         HQ2xskndBPsvB2FaZFqlw1lAekWHl6NwzssLjUjfn6zjM4CYTBeom/1FrmK1qAjSJPDP
         9akzlpvKzD560Ngz9n1z5tRAkPEFEwJVYzYexxinY9H9yl2lK86rKPRbGbnfnnJ/tvLk
         6JdsOEJZzXmlYZ40rSzi1kyFm+C2IGHuotqyn8WHg7bOcNj5WcHFDlccb4tYVarEFxpG
         FwI9GYaD2b+W4XqIW+AM1n31uodfnOF2dzNDnr3xI/TcS7m8KdNj4945BQdpbbHgu5Bx
         e15Q==
X-Gm-Message-State: AOAM533SRiAYOBqGY4ZnhsSbwLsAPd8Wu4jt5pSVLQMd9c8ZI0Yue5kN
        zccRs2nvlbkOWjAqutbI/orXLLEu3PZfnVyMIGGzeg==
X-Google-Smtp-Source: ABdhPJxA9Mlsp07wg1HB2afmaFNQkN41PZAhhEBBlyBRqAZqg3gzYNqIm35fdW4QyB0fzAYHIpTzj/DDFIQ5bLpTytA=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr4303411lji.73.1589015242675;
 Sat, 09 May 2020 02:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200508123034.886699170@linuxfoundation.org>
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 14:37:10 +0530
Message-ID: <CA+G9fYsTawTQA8R8Wpkh+xzRKEE4+AbSxYbMQPrsc0uVzdOiDg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.122-rc1 review
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

On Fri, 8 May 2020 at 18:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.122 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.122-rc1.gz
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

kernel: 4.19.122-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7ad26f9477088e4d47b22647fb90e2cb53f1c9c2
git describe: v4.19.121-33-g7ad26f947708
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.121-33-g7ad26f947708

No regressions (compared to build v4.19.121)

No fixes (compared to build v4.19.121)

Ran 30008 total tests in the following environments and test suites.

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
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
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
* perf
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
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
