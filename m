Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B190939B94
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 09:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfFHHxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 03:53:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39778 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFHHxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 03:53:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so3653999ljh.6
        for <stable@vger.kernel.org>; Sat, 08 Jun 2019 00:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Pqk+lXxU86kZ9oYraVTFXD6mbFjqz99eGBECERKMNOI=;
        b=nfNjn86cdG20PfveMZVjqj/Br5T07Ns4NtAJlopIScnNkOZNk0LF/+VkwXyUU6pKGJ
         D/vyF49XeNlTzRZu2xFS7mRXZ65Fp4HCkdtBHaT1XGTPBayuxOMj39/roEoYT2ynR1HN
         JYmCZKJPe71uN4pnWKHqrXGJ+Y7IL6UytIsgDmlco9GZhwvrzhWTfrCNWUBBc2WKPF5i
         ab6Qj7uDKAtGe1FzZL4rvG45m+eob9+fieMkDFcJF9fA8JnZLN57J5cj0hMbEUpDaO3b
         MiY0yOIFoPFT55tTNOp+1fHCqtYhY4bO7hL7D+3bFlXWLwViutc68uEGvX9jHADu9cjB
         l10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Pqk+lXxU86kZ9oYraVTFXD6mbFjqz99eGBECERKMNOI=;
        b=jwWnQdi7hhNjPwbNpcRI7gMQGpEDgcbpA1iZ3vZBw0sBcoq1y9BkOC03nD1ru4ud/v
         AKJOybnYqnrKtG45xscN4iQuYt7AmTwXZcVI7FEB7CfN4ghFA5LluCHwVpY1ZVHwzcG2
         SJEhdCAVg0qXRrOXdpVOpV0fV0fUmPDPlyvWrVpEJxZSITPkTgT+K/8q/gitTA4a7Afq
         c/OVo6YfBVLHqOuzORX5wWt5kTEAYgB1U9DZy8S3S6KucRms/U3OgchSL01wZeyDGYBt
         9f2TS/734kslRG0b35jTS6EMsQNYIk6oA/p1ctTE4zoqWJrRd/8mMibwhDCN8chgQSWd
         RM6A==
X-Gm-Message-State: APjAAAWPel/0yr++iMa42EKeOZBzxmLQloLU0EHpo4MN8luugdUYoZSI
        ZNxx4GiFSXNeFOw+PLzH7yKjvtgnerqp3vsU8jWsF/JeJ1w=
X-Google-Smtp-Source: APXvYqxVZxYCe2kpIXKiAEb0VeTVpaAEQ436dTJy3Ph5BLNc7PD8dkP60lHH7EdxLiZA8ZgvFOATxtJTdjejjnft1ig=
X-Received: by 2002:a2e:5d46:: with SMTP id r67mr1118988ljb.187.1559980412624;
 Sat, 08 Jun 2019 00:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153848.669070800@linuxfoundation.org>
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Jun 2019 13:23:21 +0530
Message-ID: <CA+G9fYubpCfuMw4MWTn+zwwfO9Zs=xbxEiLA+NTvWoDPXqJYig@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/73] 4.19.49-stable review
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

On Fri, 7 Jun 2019 at 21:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.49 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 09 Jun 2019 03:37:11 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.49-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
selftest sources version updated to 5.1
Following test cases reported pass after upgrade
  kselftest:
    * bpf_test_libbpf.sh
    * net_ip_defrag.sh

Few kselftest test cases reported failure and we are investigating.
    * bpf_test_tcpnotify_user
    * net_reuseport_addr_any.sh
    * net_xfrm_policy.sh
    * timestamping_txtimestamp.sh
    * tpm2_test_smoke.sh
    * tpm2_test_space.sh
    * ...

LTP version upgrade to 20190517
New test case tgkill03 is an intermittent failure reported on qemu devices.
Following test cases reported failures and we are investigating
    * ioctl_ns05
    * ioctl_ns06
    * aio02
    * acct01

Summary
------------------------------------------------------------------------

kernel: 4.19.49-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: e035459ea269bd7043037d4ed2b25358a4fa0e0f
git describe: v4.19.48-74-ge035459ea269
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.48-74-ge035459ea269

No regressions (compared to build v4.19.48)


Fixes (compared to build v4.19.48)
------------------------------------------------------------------------
  kselftest:
    * bpf_test_libbpf.sh
    * net_ip_defrag.sh

Ran 20538 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-fs-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
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
