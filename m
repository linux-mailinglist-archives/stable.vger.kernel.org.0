Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E0CBF55
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbfJDPhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 11:37:10 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35197 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389620AbfJDPhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 11:37:10 -0400
Received: by mail-io1-f65.google.com with SMTP id q10so14523578iop.2
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=61RpgwL7/R1sDbvjhbs0LvC6HUOeFFz1jcmm8BZDVlc=;
        b=Xs4Gqsz8SlsMf7ApnRq0StVZUOS15sCCveSPFcot/QetMQunNvFr0+8WBMTf2HIWiN
         GPuylnMpDE73c9BLFG1Mk5BRK/ZE0SGxJipwi/ed/Wgqf/Iklxk6h16KodSDdiZScStt
         UVjJBsPGtBhpA4MAzeuzn4+OhXFwzSLIUcwlm6EC19s0iB8E8vzo7B0HRWfki1gXxn/C
         //U4NgNXD1oDQs7Dc6R8yf9NJoyWLi3JHc/8V7yvcBtt1wP8EhJq4cs2opRwwy/yQXN8
         SC1qkuYIAXw47X+6160PtVu6wVCm8b/PLTdUjBHQdVljD2Issk/f1lbCRUBKkGn/mTSn
         8snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=61RpgwL7/R1sDbvjhbs0LvC6HUOeFFz1jcmm8BZDVlc=;
        b=HPDnascT4DTmwfW+JtorQ6pr+hW+oZ+N+qZsNUmryGKA2fcJSXcLO5YKu5Lu74m6Yl
         kERxbSZiBgIN8F/CTwEq3Lv0fS4LEsHJmXC62jME52kwGiWVCfFn3AdfmKqXLd74Sfyy
         YeiWBxLleTCgAWpp4iUx1zDzE+W/EWmaSrN880ayqJ9ObYt8gyt0bTtiMTR4hsVbmvYW
         GciqBqC+AarU7mlNPpPltli8zUKaI89r7jmRomtfephMqQ9kWyBNDx23jENN28QFwHpq
         mHrsxgwzAfWBw/736/6ZDdRi0bAiTthv/6hMdSTOtvv/D3GVcUmj/hzHbnbbKC7k3z6F
         0aZA==
X-Gm-Message-State: APjAAAXbpCjIIqVNqamEGzoH2xyskO6s57cEiSzZGDFmR7CqZg2WqroS
        X4rQCWFCcbHJdJHY8bfzXojg2Q==
X-Google-Smtp-Source: APXvYqxqtQxaC0MdACf8tghDfSP2Bve0+FVwqYpfghftsbtb4VSTI7EhBrGYR4exRaairYEbgP/z0w==
X-Received: by 2002:a5d:85cc:: with SMTP id e12mr4871518ios.243.1570203429249;
        Fri, 04 Oct 2019 08:37:09 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id g8sm2046809ioc.0.2019.10.04.08.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:37:08 -0700 (PDT)
Date:   Fri, 4 Oct 2019 10:37:07 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
Message-ID: <20191004153707.m3bzk2wiyw4tn6vq@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20191003154540.062170222@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:49:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.4 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.3.y
git commit: c9adc631ac5f1d6ac4ead2332f2a82c4e199852d
git describe: v5.3.2-346-gc9adc631ac5f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.2-346-gc9adc631ac5f

No regressions (compared to build v5.3.1-26-g5910f7ae1729)

No fixes (compared to build v5.3.1-26-g5910f7ae1729)

Ran 25592 total tests in the following environments and test suites.

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
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

-- 
Linaro LKFT
https://lkft.linaro.org
