Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9A201D55
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 23:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgFSVye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 17:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgFSVyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 17:54:32 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0415C0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:54:31 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 97so8453507otg.3
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 14:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tjHcE/5M9O22uKlxZwubGkeEUmI4Cm1526N7egEPkQQ=;
        b=SGGyApQtKHtPpBHllsG1s2yJWmtmeoZ5ybblICA58bzr0lOT9kYrov3/sA3V/i9qHw
         hw5COvL8Pf6JoRZrHfiaQIW63/qQhXLwyTsyNnz4ikoFe97w+PU9Biy9aQg7bVPNIKtk
         fTUVwXs50/4xGAejaP8lKxZmFNe4dMUEgaKd1ISuQFLFFwVPygKgjDsFoLVaFf3Ar/Ai
         RzIm3WTYQxfwjZxZxW6I8px0t4mRwCCEFvUd2vIXeUi13n+PO63vTLq68zFOVq8t9OLE
         Use8WBCzOWhiFAJ9aNl67bZ8sfGSzwKhvKn1kpmCDCbqKELfih4qps9oo96Fy4SS8ayf
         c53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tjHcE/5M9O22uKlxZwubGkeEUmI4Cm1526N7egEPkQQ=;
        b=XL/rcaFwvkOlq8wRbIuF0wIHWIUoePDDSSjcDS15ekhrxQEnaxo6AYmV4+85zlXDau
         sq4dbd0fByX/dKFMa/ob1DH6800J4sbfyHgEb4DBN36nyd9KtUisV5werTb56Aj6ueL7
         jHrKyiLcRsRCB0etP2ZL8A/rCJF0ZNXfRCKxl0SQXnb7mpi5Gf0GZXyMocTkoPQcww0K
         f+ZTdEwSOi/arEDwDwOSy7nD1CVQMTfG5iIEorKAq3QPQ8ZmonPWkix43WcCWTp7QYLD
         hgCjqmTAa4O9MKaEIRh4tpSxj5MYl3nMeY5GrxlTlyl2r5Zf7TivQN1ZGQp4mbj17uB6
         Q1Qg==
X-Gm-Message-State: AOAM531Qa0PmGuTvczECEK776ze5mYA1zUneKKaKXt+dbUEl+Q1dw1on
        bj/gKmgjmByoTjMcmNdN/cCLxQ==
X-Google-Smtp-Source: ABdhPJxzIHFQ9eT/XpZJWPsNHVvYm/18siWW2A/USl9dpUrjZMyNnXTipR4nDwVlgVT2/b2vTul4fA==
X-Received: by 2002:a9d:631a:: with SMTP id q26mr4765793otk.220.1592603671027;
        Fri, 19 Jun 2020 14:54:31 -0700 (PDT)
Received: from [192.168.17.59] ([189.152.177.49])
        by smtp.gmail.com with ESMTPSA id j89sm1636939otc.72.2020.06.19.14.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 14:54:30 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/261] 5.4.48-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20200619141649.878808811@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <4c81037d-9c54-4d71-dd52-8e9825710a6a@linaro.org>
Date:   Fri, 19 Jun 2020 16:54:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 6/19/20 9:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.48 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.48-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.4.y
git commit: 1b895c62ebf44a0852908c0f7ce05f53006fddf0
git describe: v5.4.46-394-g1b895c62ebf4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.46-394-g1b895c62ebf4

No regressions (compared to build v5.4.47)

No fixes (compared to build v5.4.47)

Ran 32839 total tests in the following environments and test suites.

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
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kvm-unit-tests
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
