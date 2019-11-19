Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D11102BDD
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 19:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKSSp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 13:45:29 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44923 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKSSp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 13:45:28 -0500
Received: by mail-yw1-f65.google.com with SMTP id p128so7665835ywc.11
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n3QQWfM+2/3SKmpoDbV5y5lk3O6h7i41cgHTX8w97ZM=;
        b=YwCMX0MUrerr2z1fhDl+9kN/5yNqSf+NnmkuojTSD3/3VBu6RyKxd431ImktRVh/0U
         stuZ6WOG6x+IckvYQ0ja/C1FDZA+gEXGTVqQzCvufTsPv3+bDn1c/HsrGDqXPz4pu+jE
         dR1xAeRCYb5Ua/bLcd0cgWOGigi7pmWWiBpUoa7bIQFLxKrUvUFXCsGCasyUugY9A8St
         ymY6BV8iplwqw73PCz8ktcsVY+EN3ZZIC5BxHKvz17CFYS1j3xr0LLGs/qsFFRZKRUkF
         QsGLchXhr86NZ9xQu3nfBBjJMPPUYUmxJrKNaWoxkMqoaco3DuySmh1pZliZuZfz0p+o
         8+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=n3QQWfM+2/3SKmpoDbV5y5lk3O6h7i41cgHTX8w97ZM=;
        b=kddUnFvNj3eoN0HjKYBtm8amWA9c7NMlpLZUzQALTveaTz0vDzc1i8tusq6k9JuH1i
         zkTpSfwOiWxAvP+oB/oe2VYgY5QmCI3m8pjo4VZVSWoUi54fgABe6cbT6URgH1It958s
         X2H/sKjagY1Tiy81r9YYId43XaOateQYxEzwzHdYnOWUVKu/6pUDFb3YgqJY1eGx0g7O
         qf4ks5BfDXZvyuM45CU/S16J4YaRmhmFs4FEZMWne2lwyZPmGsT7HnT6AUajA1YJH2Dg
         3bnXGyIjeKbO7pTezdpXwZF+T/hEEgL07Llvm7kQuqnW0J+gzQjbx48TPGJFyttWHaWV
         duQw==
X-Gm-Message-State: APjAAAWLNKxiS8bEK+whiuEUotCQYdVSG9/z8cRTVO25ws1qBSnGayo2
        Es1QL0mi6iCVJLOWYBhVy6mvWw==
X-Google-Smtp-Source: APXvYqzfodfw1xn+xEbJ7wmRHKb7xmj7cCT9PcBYeJJXmwiFKuyZjtwD6HqbEEcFikS+OVdk5oSZrA==
X-Received: by 2002:a0d:eb85:: with SMTP id u127mr25916166ywe.402.1574189126177;
        Tue, 19 Nov 2019 10:45:26 -0800 (PST)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id g71sm12369834ywe.90.2019.11.19.10.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 10:45:25 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:45:24 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
Message-ID: <20191119184524.v7b5mkopvv2zunpc@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20191119050946.745015350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:19:20AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.3.y
git commit: 6d539b8f097b64486da01863c6ae6e21b1003af7
git describe: v5.3.11-50-g6d539b8f097b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.11-50-g6d539b8f097b

No regressions (compared to build v5.3.11)

No fixes (compared to build v5.3.11)

Ran 34194 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

-- 
Linaro LKFT
https://lkft.linaro.org
