Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA51C2027
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgEAV5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAV5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:57:23 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD44C061A0E
        for <stable@vger.kernel.org>; Fri,  1 May 2020 14:57:23 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g10so4875930lfj.13
        for <stable@vger.kernel.org>; Fri, 01 May 2020 14:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KGuexZNqPHV3dntCrXwQZ2auyrf9pRqMIkxfRiVn9II=;
        b=SZhtW7JV+EBI/uxojnefb+fmuqki8Woz9mk0GTuBQsV/0mktoSnt32y9ETxT7K8Ec6
         PHv4AGeDWtE0+4QY148a6kO3oBBBiRRiqt8WSeEhMgr9lIkZNDAB9aHRjeJlJ3UFRh3/
         9Jheq5FqIQZR9Iu7Q3VVdo5tW+/tulm7Qkndi+1cAtC+R7xQxobjXzvEGdMVLTgbTmSb
         dapnOYN3uNDrkB9bSpo54Tj5SE22nJel47WPhQKYo7jdJW2Q7hPGLz3UHaWsWL20XnR1
         32a3WF/I+ISVfhIbCBjd4miu3o4XbRDAeVZu7T3fvqzkcshbVBpv1Ym4zsgfhHyVkNka
         npzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KGuexZNqPHV3dntCrXwQZ2auyrf9pRqMIkxfRiVn9II=;
        b=DkzRdHeUQUZHvfPe10rjhJRKgGUJFkuLsjZJkCL4iBz7EwoeNNr1hibp3Eg0uImZ5K
         EXLH1QsudGguX5gYkQRZSHLdoR8KA/4nffAGC2Cu2pSDrfxNKfm6cMZs6rReKDvXJDXQ
         gGC7ecM9/2fUq82ZDA0KSRW4aSaHBYd2kh5a32fRBhZ4NqFJFr4C2yDBxFtuAQJaqohJ
         MBKvzcSleDk/yAOZFKWDIn1uZ75zZV/eUQ6X/sStKORX58Z2D+cQRluUHHLkGWmhKS0U
         cIZo4JTEse6HHNfW5b6vyPzuQHKj3vjwZGhesqnBrcNgt+Gn0qWSxnbR1BCGzl8Ehhrf
         HA8g==
X-Gm-Message-State: AGi0PuYXtWSGa/rf9letZVK+Ykyck9JjTKN5w9G/r536+5/dLMKT6Jek
        aeo1I56t5pJVcmqPcyDhA9J6Giq3h3NoJhVHeAC1Tg==
X-Google-Smtp-Source: APiQypKyPY3bAbzKvc/nN8LXnGAiFBMuT6Byla4A5Ehp1B1/aotfPcTge9LOFYyj4QvRE7y3v+RdwX53K/fs3v5cGjc=
X-Received: by 2002:a19:4883:: with SMTP id v125mr3702840lfa.95.1588370241750;
 Fri, 01 May 2020 14:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200501131543.421333643@linuxfoundation.org>
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 03:27:09 +0530
Message-ID: <CA+G9fYu-6s+r+tm0sJUbz7CWKeOTExKOBDk_CG3n=0VS77HQkA@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/106] 5.6.9-rc1 review
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

On Fri, 1 May 2020 at 19:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.9 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 96c73ff08986f85d4e1a21194ad522aa17e936a7
git describe: v5.6.8-107-g96c73ff08986
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.8-107-g96c73ff08986

No regressions (compared to build v5.6.8)

No fixes (compared to build v5.6.8)

Ran 28522 total tests in the following environments and test suites.

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
* libgpiod
* linux-log-parser
* ltp-cve-tests
* perf
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* network-basic-tests
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
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
