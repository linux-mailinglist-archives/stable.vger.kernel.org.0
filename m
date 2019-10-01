Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5374CC2B7F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 03:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfJABFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 21:05:43 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40191 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfJABFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 21:05:42 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so43383389iof.7
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 18:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wMRHIPp7mfeyTiFlVggtdtiFiaP3szLB+NN0xipbC+g=;
        b=K2euUYOM3zN1HM140ESnggI0jM5w7rTkAuIqFZJUTNo5fESbnAT9eIJE9G5yF+fCMn
         8is0omF+fxcvWZaBZBh/sfFidHCxaCnxMtS6sXID/BkqWDmuNSrMFH7l3hTfXoJcSe/9
         p7QvLZDSmRcNC2DDvbb1QCbfC77ZFKIOVRAHr8cpaEd02EPvybH2DnYXi6C68QI0yvsA
         vKLlVtEva9H9QqbBxBaFvUyXgV6t00aDf5FjnHe4dfeCkBqJIQskrWnESgaVkNf1GR3x
         TMMyF5s3xnXbgHrFM9oajUw8gCKzSfLfZnq02XKxT37TIljsnSxgRMLQ0/poP5otXUyq
         TqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=wMRHIPp7mfeyTiFlVggtdtiFiaP3szLB+NN0xipbC+g=;
        b=XyBBsNxk+739wZ5RHUlQgKL3sw2ilF+oI6G4wz/J01zbvhqOALtG/YXMuMieNHCZsb
         Bo/y2K2ftV9j1cgpy2kZbSFsMAYKSkZsUtihr4N1F0Gm9X5Vtv9A56vJMZRAZ92XvDCF
         E9hEtcxxOOEgSK7bSRlTtXQslYVaLQH0VsxERnawBcmVephycwHgqckEsZaneWJaLxyj
         ldTc6oS/vLxm4+kc293Trwlf2zri8AefhtO/Uoz4pT/RSMVhPWIuDcqsjkHCXtMqrKPS
         yxwPhuRHAqZ3OrCqtRII93ye7/oHKdxSkEBukZ9oXcxwT0o+IPHClYHx1KYiIZD1jEQV
         oaHA==
X-Gm-Message-State: APjAAAX+CkjA97C3V2odhGLeD62bEGGOQ5/PNjCvsNIzaY2g9A9nwBFB
        6i2CIDZCBk1voCWMZB0ZaqO5rQ==
X-Google-Smtp-Source: APXvYqw52sHtLwdVsG30YPjm8tiMJ0WimmBku1bm5mOIFmrcsZDJLCCoqDvtuWgLh5gD7h2grbrz9Q==
X-Received: by 2002:a6b:e50b:: with SMTP id y11mr17917956ioc.161.1569891940239;
        Mon, 30 Sep 2019 18:05:40 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id 80sm6807172iou.13.2019.09.30.18.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 18:05:39 -0700 (PDT)
Date:   Mon, 30 Sep 2019 20:05:38 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/63] 4.19.76-stable review
Message-ID: <20191001010538.mjjos24hhprbebdd@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20190929135031.382429403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:53:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.76 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.76-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: b52c75f7b9785d0d0e6bf145787ed2fc99f5483c
git describe: v4.19.75-64-gb52c75f7b978
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.75-64-gb52c75f7b978

No regressions (compared to build v4.19.75)

No fixes (compared to build v4.19.75)

Ran 23641 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

-- 
Linaro LKFT
https://lkft.linaro.org
