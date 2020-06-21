Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E79202936
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 09:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgFUHBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbgFUHBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jun 2020 03:01:42 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88109C061795
        for <stable@vger.kernel.org>; Sun, 21 Jun 2020 00:01:41 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x18so15857259lji.1
        for <stable@vger.kernel.org>; Sun, 21 Jun 2020 00:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KHr1gp6Btg7DJpS+pSe7hta7Bi0KomE+d/TFeAgietk=;
        b=NakNQkYjKC4D/k2lbmuK2XGZILQBQxAT7yKEG0OYpsCiH6NdwVv1sNfv1jq8W28q/o
         Z7uyxqnkFvzL7RtlspY62HN43t9zOftITvl5w5zlUKz/vKN2aD9uG2s/KValJcBZaqbt
         qVajf/R1aINrS8hGDN8pxOwikJoIcgBr54g6Fazbq/mi/URimXCFEsPMgYjf6yDhS9z7
         Z+5Xlfu71wduuCaQsU/YliSNJ+NnKQV/x+1qVtgdZjfeVzP4CWoq1m6/w94jJ2+rJBkP
         7J88mUyO9IVXFq93bIt2wZS85uPMLQx/NvHwugfqTcU3M7Mp4YetIi5+qLCMKvU3Uvs7
         lMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KHr1gp6Btg7DJpS+pSe7hta7Bi0KomE+d/TFeAgietk=;
        b=VN4ursSLQslh5uv3hwWRQZtTd7ksYEdjIxiPDLKO8zJ0HKZDZnjSpfszB7kixjiBod
         oNLgu2MTV0Je0JpauTjx/iUeaBpK7dN0ZzjWSOqCTh6LOuAXdADggVAqEGjKQNIYaMKd
         EQ/IoOx69SVb7EGk3wFgOz/mKaqMh7R8BDlcyf/FW0VfkrTbnqGLHqjrKHBJwSXnk5tC
         qVD3sj9AhI9wlM7BO/t2abfQ3+eX0wZFqlXyTsdtBf1XfuM2NnU4LvagP7Eq8i3yO1DS
         ZGq3X6RCJV9cVcGRwR6CbxI6TnSZ0rTf7A7h/LhmQaJQR7eGGOYjj4Ymm5dZaMu4d93+
         hDcw==
X-Gm-Message-State: AOAM531ihC1PWyh15JDdPv4hbKQHA24MLpPpF9rbDwmcR1DbjeqHa3tX
        XLPtl14n7t0wyj6elcVXlditWkwbiTqXQT/OOjjUdko3502QHg==
X-Google-Smtp-Source: ABdhPJw1+AmDgBvrgrNkASVNCYOj/kJ0ubE4TMNN6Gvf6inji0MIODodXC4dLiyeNS9tHMnIjOGCx+GHy7P5/paeYyw=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr5500237ljj.102.1592722899749;
 Sun, 21 Jun 2020 00:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200620082215.905874302@linuxfoundation.org>
In-Reply-To: <20200620082215.905874302@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 21 Jun 2020 12:31:27 +0530
Message-ID: <CA+G9fYuSj4+WhsL7pjnFUDOG3t34rKH05FBK-Rbe3K+zqQmxMg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/259] 5.4.48-rc2 review
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

On Sat, 20 Jun 2020 at 13:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.48 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 22 Jun 2020 08:21:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.48-rc2.gz
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

kernel: 5.4.48-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: a9a8b229b1885e33c4e18d074b51ed2de006fb62
git describe: v5.4.47-260-ga9a8b229b188
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.47-260-ga9a8b229b188


No regressions (compared to build v5.4.46-392-ga9a8b229b188)

No fixes (compared to build v5.4.46-392-ga9a8b229b188)

Ran 33942 total tests in the following environments and test suites.

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
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* v4l2-compliance
* kselftest
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* kvm-unit-tests
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
