Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1001691C1
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 21:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBVUWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 15:22:05 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42048 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgBVUWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 15:22:05 -0500
Received: by mail-yb1-f193.google.com with SMTP id z125so2628618ybf.9
        for <stable@vger.kernel.org>; Sat, 22 Feb 2020 12:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WF/taxHO5mO9I+FJiZjs5FsIp79ox0Ft/ivjLSTaWKs=;
        b=HuweLRVGDRI8r0C10fAHdGGVougCtw1f/r0eYm0amyLMZTt+vwhdZPYBGwP+hzMzbA
         7mSqG228PilXAAtNXnl/JAsZANvfyqkrZWe7hXiPVSrF7Z3MAWW2pZlXrAzYLZadSxeY
         TEbzNAje+Dv9YShGmXOywNjlT1cr66zrE7Ewri42yajabWrs81KxqjjwDu3rPhSLGHf7
         sfxeD5occMYcjdqCrehs918UB61KmY7FagELhqaBKkJuzeFBfWudWKOO6Wr9aAZl94pO
         t2qYdnMJKuWmSsl2CNf3T5iytpTUNoUjNox5sMnla2le3zK3iMnfdEJlR36HMMC1KTqC
         FUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=WF/taxHO5mO9I+FJiZjs5FsIp79ox0Ft/ivjLSTaWKs=;
        b=Wn4/PIlOZRdUDXXy1/jk8D/ycOzxZi1Sn22uFte6VtSEL9R86Tb4HXIWyu8mrGxJdo
         hodjdwhCp1Y2RKOXIPSNCghTcUKPBrkYtbuosc7vc+0SNgr7peh6BahmckjyYgDZDCMX
         LV88f+tJESNE2gRbJmUFWdXSIBSCToPNTL4TAb4HAjLemsmVUZ6UZL+5ePBxiAMzysY9
         dbrDae9aHsCLMzQYvVuPM4gZFnqH5cSHNIuAtXU2f2xk8wUnQyRx80AZmz3SAl9ZE80B
         vqLgCWY2w+7mgBHDtj0E7ctGzg3bDpfzvic0GL66WeXBFvXDre2HYnlHbfkqJlosLoE4
         qatQ==
X-Gm-Message-State: APjAAAXvo7Lf62TicummEY8dZKgqDJyBe06RHNvQYiXLhMm70ASU7GQu
        FI4KNuazf57CXjwI9xQPs7/Ykg==
X-Google-Smtp-Source: APXvYqz7JrTIOPLybvSGqQb5txZOKuWuy4IQLa2hhbHEzJUe0lUrDm1whTxOwmalWnTiCpvM+L6jLg==
X-Received: by 2002:a25:d797:: with SMTP id o145mr39696351ybg.276.1582402922110;
        Sat, 22 Feb 2020 12:22:02 -0800 (PST)
Received: from localhost (c-75-72-120-152.hsd1.mn.comcast.net. [75.72.120.152])
        by smtp.gmail.com with ESMTPSA id o13sm3218121ywo.20.2020.02.22.12.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 12:22:01 -0800 (PST)
Date:   Sat, 22 Feb 2020 14:22:00 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
Message-ID: <20200222202200.nnfekjhar4uct6pc@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20200221072402.315346745@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:35:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.6 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.5.y
git commit: 84fa24740caac8ddcd3e74bcf958f1c21f7a99b1
git describe: v5.5.5-400-g84fa24740caa
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/build/v5.5.5-400-g84fa24740caa


No regressions (compared to build v5.5.5)

No fixes (compared to build v5.5.5)

Ran 29706 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

-- 
Linaro LKFT
https://lkft.linaro.org
