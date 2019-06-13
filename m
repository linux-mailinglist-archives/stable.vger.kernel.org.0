Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1225344ADF
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfFMSjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 14:39:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37990 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbfFMSjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 14:39:25 -0400
Received: by mail-lf1-f65.google.com with SMTP id b11so15880053lfa.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 11:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zhnffrfz5nZyBtxW2a41/tZfwftWpsUjhwz59SaODwM=;
        b=HN5Dr4rfiwkuocy9IH0pR3iqpRySJLbDADNeiPg+mqttfLSuaDn/53bA4h0oKBwtMt
         DYRXn0yQ5hOCxnNmDId7Z82uELL8s+dbY5OlG9tymy1d5NpNZ5dUjKZh7lbpb7g3aiHC
         ds3PCK0BmhJjDsk2YXlEtQcX0Rm11cRe+6RxwYCBnpKoYGJ1retDOdFN7EsaE2pbcbxN
         402AynkRh/4U0d3sgec+8sh5WMq3k1TptJt0IjjtooL5lKXSCdShDW1PqHfUAyNdtRW0
         qoqrT2z6UJiWOSLV9FqgqMGXJ7QzWze3QE2iOKwOzvA4SFlDQHSgGxOp25C6+/SerrwC
         hy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zhnffrfz5nZyBtxW2a41/tZfwftWpsUjhwz59SaODwM=;
        b=JCfWOXsKj0XM0+iJ0iS1AWMWKhxFoC3WIcx3gHzs9DrG/vM+cNrJyyjtFqpWVvLVrO
         Gs/bqy5DEEToXKf+NgESNdlyVmaPA5soepX/eun75yKr35QCLC6a8YwT9GIKTVvcVWiG
         mwQ8Z+SEvBMOIGfnuEswubFVcc43/J9/Oh5INuJJi4SKzbxBK0iLuSa37h7pDxy2ydHC
         jSl7ZgTCQNQo2zz6K7+zc9aIjyMcMBegTk2uWJod7R3XZHRQutiCL1sgGlRFHW1LQnWO
         Cy55sVbQH5g9wKrN+sbA1SagZE40TO7jX2Vfn2mlLGGZN2H5gr335J1qZf6vjUsz7V34
         tuNQ==
X-Gm-Message-State: APjAAAWGWF55ovcCiJUUh4Kam+MgQypCLUycHynH9U44P0p+ZaBDn3iz
        WJDzbH+Tynd7vtonpXvRCYx84ykqvUEZeeXp9l78KQ==
X-Google-Smtp-Source: APXvYqwB8ibiY25D7G0qqULRnpwIt8vPiRMqv8qmvd6Z14aIpEOYlpUfksjAxOqiNTXnxdmOyydTdiESfikz8uTJycQ=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr2201932lft.132.1560451163907;
 Thu, 13 Jun 2019 11:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190613075652.691765927@linuxfoundation.org>
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Jun 2019 00:09:12 +0530
Message-ID: <CA+G9fYsRq=DyOWhhPq3axyhLVBWLp7-3QZ3p5dSScR06ar5SZg@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
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

On Thu, 13 Jun 2019 at 14:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.10 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
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

kernel: 5.1.10-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: b7eabc3862b8717f2bcc47f3f3830ec575423c8c
git describe: v5.1.9-157-gb7eabc3862b8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.9-157-gb7eabc3862b8

No regressions (compared to build v5.1.8-72-g2df16141a2c4)

No fixes (compared to build v5.1.8-72-g2df16141a2c4)

Ran 23163 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
