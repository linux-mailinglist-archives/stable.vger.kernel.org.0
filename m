Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94AB9F9A6
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 07:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfH1FAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 01:00:23 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46839 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfH1FAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 01:00:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id f9so1281828ljc.13
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 22:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qf5g/tYp3YFrTIzqEBilUnxPZLxUd4p7Te79zHq65DQ=;
        b=itwtnkWIWqG+1NxMjL0TcmCSJeOj/xX1vwvpmYbTf0yIf08TMYWlhLpVuN/kzjVpXz
         c54xuxP1iVa1MpONtKFpWaHIVTpWbJzR9gkJ0GhuWlxYBD8SidnNP6VDIYhB5BEMRhRI
         +/gsah0hHpwSIM0zF9YjtcWWHKga2oLbTpG+Uz6GCbhSe7u0pkYmvgSYWKMO4X3RBLzQ
         zTJfGXDFdb0Af7ASMAB0ciGQ2rEQ+3xezuIyQdHis9CSJKw4uwiX6LUA2AJkL7j05BHH
         cVkG4jy6DZyKzaYMcLgZEAikOLZe8/zpVO0JBZNPgWXYRWRw4b+j7NOhXR2U8dM7UJAz
         ZHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qf5g/tYp3YFrTIzqEBilUnxPZLxUd4p7Te79zHq65DQ=;
        b=EjjPOphMBsi2mdPm/TWI28cRFTahgkd9b10CrT1TkXqnhBlxhFolW97XEWnWJ1xaUM
         +0Wz6hWo5f8p8ZUvTOBTUqjEiIWYac6tZzTzMBydJbqpvS1fwKi4LFQ3QkGYC81Nqdcu
         Zce7T4dkgwRkhZ6fqDfGjw1Q0h0KhaG3wrOJCC/Sl5NxcVfQZxc9jWKTm9Je3OAEunq3
         zMUvUMJ4/9g0QyemSZsX2p1g2dtnJmaEo0RSt/aZ7OZdkOuXTfkfiGTFnF8tuTznJQ0/
         U0uYyZ/yJAPaTzuTPV5L+V5SlIjlDY64GZbty5QckgHlC7sg4sLZMsp9neGyA0nIsUaU
         fokA==
X-Gm-Message-State: APjAAAU1VVZ1yBg1c69jZ5xZ2gGkAkpLs/+1Na9AiGRSIRdAB+QFykzl
        2dEa6Q1katL/WoxQf7IaN0lZ4bL35OFhmgbM9FAMUw==
X-Google-Smtp-Source: APXvYqx0uanWUxL9fw4n+GU/fNME8gQB50Kpu7FBsrzLpXxZP5UcNrwnA49fDGbqmxH6IA+7KZmO+TQ2+iHHE0CETgM=
X-Received: by 2002:a2e:800a:: with SMTP id j10mr922530ljg.137.1566968420829;
 Tue, 27 Aug 2019 22:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190827072738.093683223@linuxfoundation.org>
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Aug 2019 10:30:09 +0530
Message-ID: <CA+G9fYtmHsr8XWvmSLy9QKvF37KfZ4v+T1VnRy2uhpE0HB4Ggg@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
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

On Tue, 27 Aug 2019 at 13:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.11 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.11-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 9f631715ffe68666bbe4c5f7ad0dfc1ed387e1a1
git describe: v5.2.10-163-g9f631715ffe6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.10-163-g9f631715ffe6


No regressions (compared to build v5.2.9-135-gf7d5b3dc4792)

No fixes (compared to build v5.2.9-135-gf7d5b3dc4792)


Ran 24414 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
