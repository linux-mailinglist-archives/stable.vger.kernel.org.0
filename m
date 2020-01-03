Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2D12F48D
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 07:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgACG0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 01:26:55 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42997 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgACG0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 01:26:53 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so31237278lfl.9
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 22:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wOVOz9Gn7KckluVBWiiDt4GgfxybQGuD44AvfO6vHPs=;
        b=pX2BgkCohlLQQgu5leAMkeALm5KjNCR3F+MpX+JTU6SjGH5ezaAlcC1uTuksZlrG38
         ZW5tdbCD7gsqeDJbEuLsbO2nrInck7bQuvt7UvAvp5DhGp8QGwvj81ZU11wbbu4TbzCI
         d9Ygr02C5Ts1pSzAQTRlRH8ko8j+4OKPS0tN9JZVLa4FSGdJWCWzAIQJb5WgNYFPIrE3
         2FBwwPPcOh5MJpRM4L9EuxHCBT+swwyCr/idtlFT8OyQX5zcX5XexvONuphJzXt1eSMN
         ZdPN0UqWQWUnYApS8ZwrkOJwKaye+Oxf48oP88qAKrj6tWdMqc5z4lhqlsmR5CtiexeF
         kqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wOVOz9Gn7KckluVBWiiDt4GgfxybQGuD44AvfO6vHPs=;
        b=XdU5YxIHGc1dbJ06LOckBXyue2SD8kKvV4zVtii4oeb/RcwlIw7YlU8BgPJ2dQLBch
         cxv4cs2rRQ8JdFbBF5QP98ZIT5IErGi/lterSXefPyxsiOZxPAp3+be10ftIz/XcanNN
         KplbIqiGo5PrVvUbO86mqgoZUHNFlp+o3I+x5cCPDqAwl6Es0Pd+e596r1rhxvZZvos8
         C47Y9QdWDDMGngBx5IViWs8BmtDxKz75k5l6PsbIVrmtXFBSCF8SEfIXCuwELXEf2Idu
         DeJ2YQSdvCB/NkwHuzAtDC1lM0v5gvFZGrso2vBKCzKHMRWAvzsVtzmlCSGQahZHxrQp
         XmhA==
X-Gm-Message-State: APjAAAU63LjRronRBDT823WNpK3xTW2t+V7Ll1JuC4af2J1Qb9A8PS3n
        yj4b5aVMFtwYWArMqJJ2O9OEooHD6zYYLZ6skONMKQ==
X-Google-Smtp-Source: APXvYqzbX2/87WU2jLhQhucIBj3UeYqsr9LagZnqGQqt+tk8FgiLzZyvAfmKTwT4etIm8ZeYLSV3KD/cCgPj9+ymLys=
X-Received: by 2002:a19:8a06:: with SMTP id m6mr46200766lfd.99.1578032810731;
 Thu, 02 Jan 2020 22:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20200102220546.960200039@linuxfoundation.org>
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Jan 2020 11:56:39 +0530
Message-ID: <CA+G9fYuVZuVqohqgvNyrXYt6__hesvNqp5Q9cuHX6_22opnRAw@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/171] 4.9.208-stable review
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

On Fri, 3 Jan 2020 at 03:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.208 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jan 2020 22:02:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.208-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.208-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: ea0b96c2917ea73aa7b141bc3b5be3b157aea5c7
git describe: v4.9.207-172-gea0b96c2917e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.207-172-gea0b96c2917e


No regressions (compared to build v4.9.207)

No fixes (compared to build v4.9.207)

Ran 21320 total tests in the following environments and test suites.

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
* perf
* ltp-cve-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk

--=20
Linaro LKFT
https://lkft.linaro.org
