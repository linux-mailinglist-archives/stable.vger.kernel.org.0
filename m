Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CCF14C56A
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 05:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgA2EyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 23:54:14 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42361 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgA2EyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 23:54:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id y4so17003345ljj.9
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 20:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wQ8VfuzsRdwc6W5WaD4vSIVhT+tGPyOu7W6UMeJbsfU=;
        b=PYFkqJsgQL9A8Qs3TxOt1TpAUKIAVZouYloyYC93pUqcpnV7s+qBYWHhvMSIsFKH+r
         zNjXdxEeWHUuc2JgwQsOuy3aFuUIky5g6jvK8VBSROZEeXeN/d4tKJ7s2TlVK57GedOc
         a2t6BFee9VwVMOKk//UG4t2yx6YiklbV59UO2WcuOcYXfRFI3CpURqECBRfvXfHycSx5
         u6cKk7UoNxX9gMW6wTARuVsLlkXVXkMlGnDfwCMAj9ThfXjuA2bYdo+9BkRLp2GyX5Xk
         i/M+a8H0Cb4O1IZiRP6+yZCJaiB/rCSyjHrCb8kHOtgh+UwDLbQYE91VopB2QauaQd2r
         OkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wQ8VfuzsRdwc6W5WaD4vSIVhT+tGPyOu7W6UMeJbsfU=;
        b=OOWEBuAQykW+sU2dhWTax0wyt16FNFQ7pqqNJ5PhXhZtZaAX340kh0aCMPTvgiw1lG
         gIG+ojoRH3yRX/UoSzz84BGkNe7oNhDDK2cEOhab9sCsQDElyh723HdGTOsz5qLiQzRb
         nQQLZMLlh0UNqR+izr3tON7HAKoahZz4Iw+fK46u8TTysEw4AVBIupbjqCJqfFGjt++M
         V8cq0N9hOoAygf9/CXNXwXUqZSldvz1tK93vB+mFzvnsW1oq1yWTllJFwtW4l+HX/cRX
         t37xfjpuQX0YegIyoOQAr3Q1ZdHWr1IW6DjGJapEstugOOdgvNcHVu1hpkVYb5Ax8Ctj
         xOug==
X-Gm-Message-State: APjAAAUseDNtktISb1TtGyneI3q63gkMQVXmi8g2Ir1QqEALgzsDEUCv
        IJBKHmi1WWyWFCc4c9SkXekXAvy3V2qtat30Yl7t8g==
X-Google-Smtp-Source: APXvYqxtxVaxIFDmNv3MKxmuOk7A6oeox5VAq8zRzVS74T/YOe6qMD8dcV66CgslDhiUjqnI4QzQeV056prAn67XpEw=
X-Received: by 2002:a2e:95c4:: with SMTP id y4mr15340668ljh.38.1580273651756;
 Tue, 28 Jan 2020 20:54:11 -0800 (PST)
MIME-Version: 1.0
References: <20200128135809.344954797@linuxfoundation.org>
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Jan 2020 10:24:00 +0530
Message-ID: <CA+G9fYsXSYJxXmDkPUgY_0J2Rhcyu0JsaOcuPT_wKWLn5rf89g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/92] 4.19.100-stable review
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

On Tue, 28 Jan 2020 at 19:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.100 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.100-rc1.gz
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

kernel: 4.19.100-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 26d743063ae6ea030faef12264de0a0156d5452d
git describe: v4.19.99-93-g26d743063ae6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.99-93-g26d743063ae6


No regressions (compared to build v4.19.99)


No fixes (compared to build v4.19.99)

Ran 24366 total tests in the following environments and test suites.

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
* linux-log-parser
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
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
