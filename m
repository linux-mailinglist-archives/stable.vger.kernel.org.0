Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756751A170
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 18:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfEJQ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 12:27:46 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:40594 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfEJQ1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 12:27:46 -0400
Received: by mail-it1-f195.google.com with SMTP id g71so10135794ita.5
        for <stable@vger.kernel.org>; Fri, 10 May 2019 09:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dwsQYTgRQ8BYL9lrVKDZnIaHxE5TwPvQtNVTe6VpCdg=;
        b=rgvp/g01rzulkRL3t7YHZVubsFTgMJksr9jvMPY+t1w3Qdzt92Iy2IzcrZJvZVdU4D
         z0qsfZ8n6Lh5qif/nQmACSQRcCZxMYORuyJ7eVv5Qc0ZmrLhJylfoqGfa1P0VGQwsYP4
         kZYBRFYirehv1oz2bmSueR603vBEd2yKyZcI79OBF2eCy21pbTqJS+htt0fCnTPlxsrp
         qURWwJVMQ3/I+K0gqfKIQ9UOc9/C6bxaUQhQBq2+PIwxznppQojzfeGN9g4y5dFgVRPn
         wRHNv3my8lhwKfKbWIJDiCwI2XcPbuQu9IMuAwMHBuCsqbrYhCG0dGfPa586XE3S2XdN
         2gkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=dwsQYTgRQ8BYL9lrVKDZnIaHxE5TwPvQtNVTe6VpCdg=;
        b=ocU6dcoBifml8Tg8HsIylEnXeB17dEbsVXCoX1OpidqhlKZeRK425VEqlTIFzOw4O7
         6Iw/SdPQbIUlC383XQ7XXNBa7rqxOKWrt/fBw3LpSH4aoFzsuZ87WcmG3IZoddpBSLDh
         lyI7S3k9p3U3KXUHj/Kf0lmGT/fE3VVjnuvlTlyPJRtdgYdzTyNlcOo6ubqNqmcckNyi
         2AFoJ23Cr0WW/ljhvqVctwc10z4s1BTVO8j/MrejFFeu1owwECEDrj6q6y9Ydv3C3DPO
         PXlW7oYPTQ4dnBPvCvi6NgXj4utfd2Uoa2ulkfccUqamGnt4J3dCT45RcmAGsYj8UAIl
         3RAw==
X-Gm-Message-State: APjAAAVFPOFz6nx7bL2KQDmO47YJQSUb7NRn4W8F5D04XfYkxzc36wHl
        XMN5D0whMAAyPFerslcuKNQ25Q==
X-Google-Smtp-Source: APXvYqzrZHrVx0W2YeZtFelykIMUeX3nCZZxOp2ooGYqxvaxFDrEVwSkJ9B0DqIcvLSML4IbRqKXVg==
X-Received: by 2002:a24:1cc4:: with SMTP id c187mr8576782itc.107.1557505665599;
        Fri, 10 May 2019 09:27:45 -0700 (PDT)
Received: from localhost (c-73-24-4-37.hsd1.mn.comcast.net. [73.24.4.37])
        by smtp.gmail.com with ESMTPSA id e84sm2465744ita.12.2019.05.10.09.27.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 09:27:44 -0700 (PDT)
Date:   Fri, 10 May 2019 11:27:43 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
Message-ID: <20190510162743.3m2psuvcugfqyt44@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20190509181250.417203112@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 08:42:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.1-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.1.y
git commit: e4f05f7add176a1379bcd3e582b0ca615cf58000
git describe: v5.1-31-ge4f05f7add17
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/build/v5.1-31-ge4f05f7add17

No regressions (compared to build v5.1)

No fixes (compared to build v5.1)

Ran 23855 total tests in the following environments and test suites.

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
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

-- 
Linaro LKFT
https://lkft.linaro.org
