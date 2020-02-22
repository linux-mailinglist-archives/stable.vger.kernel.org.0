Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B841691C4
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 21:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgBVUaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 15:30:09 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44617 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgBVUaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 15:30:08 -0500
Received: by mail-yw1-f68.google.com with SMTP id t141so3289088ywc.11
        for <stable@vger.kernel.org>; Sat, 22 Feb 2020 12:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pANl/cm25p8F7Lt7z5k41FBh3oTmXfWPQ7SyjpUDE8Q=;
        b=uzwZMXsZ1fOemjV1cTeEtqu2Pximz+vGvTZVICFgZmdLJ6WaqZ5ECT8yhqvj5ZIl07
         Q4biIGn/bg+v8fwT/LP9u53pbs+3MFKRTHZBMCIqGAyGco3VC86Wpcy9lLyhfNvai7V1
         U/Hfw1fmdHFMXKfk0l88pbUYQ5601tPNa1HXSWdfeMJDoLUoCXfKnWveMo9D6etvwcGi
         giqEJXn8Z2q0AtrP0KFvhqDV0Xg+G5dWf/6lw1akWUDgtD6DGzNMS6UxMF/rtfs1aIDG
         VrWjgrszll6A0CM5iq9FWWgLmb35lNgCkSnv0qL3VJOEkmE8i39JNHkXELs1Lpy4M6sO
         Ta1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=pANl/cm25p8F7Lt7z5k41FBh3oTmXfWPQ7SyjpUDE8Q=;
        b=Mrv6K2dNrz4AS+eloZd/UiLNd+4UWeOQ8rB6bEOu4k2tB/YKoweCtGfXSzio/zjks9
         tWL/fyoDabkt5nN2U9ar1LuQROGWRc+Qa3/j8RFkVmcZ/k9N/htZTblwdg7/UaZtt/V+
         pC/w88durgsYl0d86FofkNWuQJ2HeWVqcd/UUS+8j/+RW/qIoLdvo8NjztX0+dIK8crf
         gAmOzj+O8rAZf2LJOOOg6IlD2wFdjo9Qz9/y8kdA0a9FBhDZgoaShxazEe7Jgb4cmQEG
         DQa5zWWKs3YBLszVEoLqcvNWywSeAQPYNyLD8ZCt4UuK1EwS0FDKrwzTLQbr0F9FLQyt
         nQRg==
X-Gm-Message-State: APjAAAXgpN/VXDJ2mC0zbmCuQLAa1f1sBnnNvEtXWHQ5uIkl8MoTb2SH
        4d+xqtBvMrop72tvVdxI+Xbgww==
X-Google-Smtp-Source: APXvYqzzaO8D9fokNAtf0hXUAlkdIik9A2Frknot08xibcIOGDViuUDGqKYawE8vDmpbfKFo3eY5Aw==
X-Received: by 2002:a81:49d2:: with SMTP id w201mr36607726ywa.123.1582403407405;
        Sat, 22 Feb 2020 12:30:07 -0800 (PST)
Received: from localhost (c-75-72-120-152.hsd1.mn.comcast.net. [75.72.120.152])
        by smtp.gmail.com with ESMTPSA id m15sm3028600ywh.78.2020.02.22.12.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 12:30:06 -0800 (PST)
Date:   Sat, 22 Feb 2020 14:30:05 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200222203005.b6ahcn2h3bu2tiyb@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20200221072349.335551332@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:36:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
Regression detected - no results for 32-bit arm due to build failure
reported at
https://lore.kernel.org/lkml/529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com.

No regressions on arm64, x86_64, and i386.


Summary
------------------------------------------------------------------------

kernel: 5.4.22-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.4.y
git commit: bae6e9bf73af8cae01e99a54d0bedee266637ff8
git describe: v5.4.21-345-gbae6e9bf73af
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.21-345-gbae6e9bf73af

Regressions (compared to build v5.4.21)
------------------------------------------------------------------------

x15:
  build:
    * build_process


No fixes (compared to build v5.4.21)

Ran 25765 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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
* ltp-fs-tests
* network-basic-tests
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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

-- 
Linaro LKFT
https://lkft.linaro.org
