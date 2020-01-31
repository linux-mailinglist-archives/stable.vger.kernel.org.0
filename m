Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0758114EEAB
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 15:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAaOm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 09:42:26 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39780 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbgAaOmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 09:42:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id o15so1807768ljg.6
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 06:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KmAMgO7snmBdaMdDatYopdjy+MP/IMsumQXInEYVh4w=;
        b=KjMBerQaVAXONzfNRPbs7dngTkES59JtpxJbE+0YYW0Mx/ZKXvrAljR6UR/fyEnNCn
         w0ec1mTdtkxFhA+91IX4WD+OkYdMMe4bvqpIy2mCRPe6hoHIa0uWs7RCixkwaS3MTm+P
         WhTdMsXE2tTx4HJq7JQOjKjNQSJKSo7o9y5Qp3O6E2EIPSCRi1i9RZgmf6DkeesfiPZU
         uJgGW0pYyotjUYWPSIsW8Gye1IZdKFKoCwkT96qBzo8EygcMdDzFD2UorxXYhEgPtFLS
         j91FHLpkAM54p/TmFoPPkqEml12UNLyZLNEBuEO6jVHgZYNRAgJkzuMCdiso5IjmUm3h
         okIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KmAMgO7snmBdaMdDatYopdjy+MP/IMsumQXInEYVh4w=;
        b=U02qtQX8pjCepVPl5SaD2ZW4CemGkebdll9KIbtP697pGlYnjh0spmQHgasc530Jyz
         nSbUi+RsYcoN2eN4UVI9PxHWNWaoPjfYpzQn8NUqO524nkSHM+++zzUN8plPxzL9ApWJ
         zyhR5jHox4OgKSc7Mh86Px0rfdwM0a75vcEpYBYWc9dwisKJd/WxnCZsBIXWGZXsLVzh
         fjQQYS/WyGN6JVldQjZMdFikjcZAZ7N1KISuI74gI2XppTk3IqNudOzr+2TUoF5czKHJ
         546zsCLA2sgIi70cyTIjJi3xCKRf3RDgzQTTXaJzXil0cE/W99ledOSfvQ7ybUj1jnEV
         qfXQ==
X-Gm-Message-State: APjAAAWz+fVNtSlSaA+k7D0UUsgBjzGR3hu8VaEY/2O7bLFp6br2Hp0f
        WSVKe9WqbVEyKiB+/WDccvIGdGEofIvZlGc/h1UTIw==
X-Google-Smtp-Source: APXvYqzyvw+DF+WQZ3fn+XitjkVnt4aq84KynA0f8nLosrCmUxdjX71Dbjpx0sayQSZOlzM8MxHZObjaZZ3xZrAJyZU=
X-Received: by 2002:a05:651c:1072:: with SMTP id y18mr6336321ljm.243.1580481740153;
 Fri, 31 Jan 2020 06:42:20 -0800 (PST)
MIME-Version: 1.0
References: <20200130183613.810054545@linuxfoundation.org>
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 31 Jan 2020 20:12:09 +0530
Message-ID: <CA+G9fYt13PZ+mhhkO39DEztsOzcF7AxfQydqNCd=Gd1C4iYwiQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/110] 5.4.17-stable review
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

On Fri, 31 Jan 2020 at 00:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.17 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.17-rc1.gz
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

kernel: 5.4.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 1bde1c513887dd7bac46be466f1cd06fe3a64292
git describe: v5.4.16-111-g1bde1c513887
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.16-111-g1bde1c513887

No regressions (compared to build v5.4.16)

No fixes (compared to build v5.4.16)

Ran 23227 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libgpiod
* ltp-commands-tests
* ltp-containers-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
