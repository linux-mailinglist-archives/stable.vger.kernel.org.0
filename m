Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0402B207A02
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 19:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405398AbgFXRO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 13:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405396AbgFXRO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 13:14:56 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718CC061795
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 10:14:55 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u25so1706011lfm.1
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZsgvS5eYmAYqLEt5t2pg0zXr4rjMsOpUQ+Mv09+uT9U=;
        b=dhgOe/AfuCTgrAfOIsnP6QsDThWL6LWP4gkVPBkQ0HFQ0nDvQ285cmUbwrZ3C9WLMG
         mIczaM0yf99jOmLzxoU/WLZrnwvn1vDWUr32fCofsBRaHUVGxMcThMl/KOLgEYcGGeoC
         QqN5X2mmWiZnfx1Knp+2flbKuhDgbdgdyG5SdOQwe5gT7S6B2CBeCdmaO7xng6CSiVJh
         TpLD9nguElZUSUV3a7GRDZC9TBdHqUPHCoaH0vCSEIiObO1LSm49FjcHJoz7DSlSCZod
         Fek/XQxxIIp2yiXD/fA7A6jLRpE7ah9cJSlPOnbxRJtevgWspgb5mkf/r5b0/n7psewz
         rkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZsgvS5eYmAYqLEt5t2pg0zXr4rjMsOpUQ+Mv09+uT9U=;
        b=ofIKR9FhJfgGnNa1DEPM/X/NGJPG7ED1RdXDCe1+OO8g8A1sHGwJPtLnse1H4lWmpK
         Y0O5xGub7uAuQS98Iwcx/wr13t38uRuZd+pUmHA+HyRJ7o/D+71asvsOQCQuh7Q+bTOT
         DeIOnafrnh0YI5zpT1YwU3PxWUuDHf9pGaB7ehH4pVQV0qp3ckQEME6mApGQKmaFQfVH
         sAL46Iq65veCzSvVYjDRcdAv5e/s7DepnOPbIRtMqQrrUnjbZyK6otL3+q7Cu5CCM+K5
         lzfnsqXm28PR52aB+8zlAyQpBZzAz13YobVUP3TJr19dO+r5XoNW34sJFFl+I9ZOY9QJ
         U/Ow==
X-Gm-Message-State: AOAM531hquxVOGJDBG06IramBaEQHNpXXDWlUbRvVAeHsHA5G4tw9JzZ
        ebdW3xFopX0azRXzmzBGSUvUtzh34DqNwG6K5C7H1K6K63zK3A==
X-Google-Smtp-Source: ABdhPJxbz97BjBqquUp6Rq5IB5nZBfqi6aY0GZayWZabh02gMNVJdHAYiJp0Z5KR+tq5aXJtj753l37jdG9LtnUF9Vk=
X-Received: by 2002:ac2:5226:: with SMTP id i6mr16122581lfl.55.1593018893879;
 Wed, 24 Jun 2020 10:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200624055849.358124048@linuxfoundation.org>
In-Reply-To: <20200624055849.358124048@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Jun 2020 22:44:42 +0530
Message-ID: <CA+G9fYsaT3_5vZHaDF+oJgcyE3a5gUrXQptO+HgPb5yQpzEZJw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/135] 4.14.186-rc2 review
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

On Wed, 24 Jun 2020 at 11:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Jun 2020 05:58:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.186-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.186-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 1c6114e2593492f39e02c775d117c95d86f9ae83
git describe: v4.14.185-136-g1c6114e25934
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.185-136-g1c6114e25934

No regressions (compared to build v4.14.184-191-ge26bcff6a5af)

No fixes (compared to build v4.14.184-191-ge26bcff6a5af)

Ran 30986 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kvm-unit-tests
* ltp-cve-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest/net

--=20
Linaro LKFT
https://lkft.linaro.org
