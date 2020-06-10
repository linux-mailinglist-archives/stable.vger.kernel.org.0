Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7851F5488
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 14:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFJMW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 08:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgFJMW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 08:22:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A122C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 05:22:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z9so2168920ljh.13
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 05:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nXCz1ikPs5SUZ7bBHCgz1YNMvzk/jWfLOTt8iV/R7HU=;
        b=zbMnvAudhTNt3umbISgu7r0KCqmisDAmJjsWJrGeunN/+MvoQDkcpyBUKzQtY7EL0u
         8849lGZLUS3+vRHscbh6ZpbSpxlmImMPHJzQCKBli0jH2cUnNh2+qiNw7jCpRZBUWqMd
         HhAQL2NL2c4elTYF0znQeOd5lD5bG1A80/RjaxAwwdjOF51L3dkad3WkbeBljjxy++1w
         xlsZ30qxUcXvYzp/u3gU6fMax9eWvCzuoermibg9dxyjkwN9WYIS7AMZAF3KjFf6Ttmj
         oMnHjcG7UqayfHXv5h8uwF/PLGHVGGFdjZujZAQb0lZ/2DCQRpzCWJig/BHe8L+j7tCM
         alnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nXCz1ikPs5SUZ7bBHCgz1YNMvzk/jWfLOTt8iV/R7HU=;
        b=X5eYYYdWK5VBDO7uZbJk10CHO/hkivIYfpNNkDsHgzq5F3MxHuhBPEi6j9QsUZj/rM
         q1aO/IFinfK9ErqOSN5UunjL2L5AgavYJ4cDSYYOYXAa1FSOfFqNglpXrpLAawq4W9zm
         f5mVF0PBtIR0wcHsQcBFpdMXkTqtfrhhFNeQpNbxeK5fbCp9rh4YZzwWnsuWjYUgkQOU
         IHEEsJFqVuMyhxV3dFZiBbnLerjDmU1MiZWJdb9wHt8YAwOA/nycH8X7oIu17s/C6TJE
         mrpxzAqO9dqBPK8PhM7sSxLOuY8ZnfTjH50vZxikjNWGyqYwS712CVp1iZSy+Nk47CO/
         GgSA==
X-Gm-Message-State: AOAM532V3stEm9ZG5xMKApSdxLl9RpzjRZAifcCDoms9L7cwNQhLfeGM
        aIXF8uLtdILgFjP5NAmq/gCmcZeK5iW3ZMdQ5VA6yQ==
X-Google-Smtp-Source: ABdhPJwDkn1WiZTE86h/ajzWx0MwKheL0zJo1WcgtpXekqptbPEqPCfCX2urtmAgy+6WKC0gIcRtSiMH2B35HOpeNFE=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr1674101ljp.266.1591791744293;
 Wed, 10 Jun 2020 05:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200609190211.793882726@linuxfoundation.org>
In-Reply-To: <20200609190211.793882726@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Jun 2020 17:52:12 +0530
Message-ID: <CA+G9fYto-j6-_ddO5Jb7-BtUykz5ofPAWtqAetWLoXiqT1RNXg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
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

On Wed, 10 Jun 2020 at 00:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.227 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.227-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.227-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 61ef7e7aaf1df32b9a53dda1cdde0caff1293c17
git describe: v4.4.226-37-g61ef7e7aaf1d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.226-37-g61ef7e7aaf1d

No regressions (compared to build v4.4.226)

No fixes (compared to build v4.4.226)

Ran 19926 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

Summary
------------------------------------------------------------------------

kernel: 4.4.227-rc2
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.227-rc2-hikey-20200609-744
git commit: 4ec7bf05c50a96f516df037f490178044c7fba39
git describe: 4.4.227-rc2-hikey-20200609-744
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.227-rc2-hikey-20200609-744


No regressions (compared to build 4.4.227-rc1-hikey-20200607-742)


No fixes (compared to build 4.4.227-rc1-hikey-20200607-742)

Ran 748 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
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
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
