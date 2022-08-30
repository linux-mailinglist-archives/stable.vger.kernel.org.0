Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF35A5930
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 04:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiH3CPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 22:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH3CPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 22:15:21 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2E92AC53
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:15:20 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11e9a7135easo11155469fac.6
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 19:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9SZoIoCxsXWhZoZ+2NLQxVQf52Wk1iyc/2gpqOYGvaw=;
        b=qFlWJjlwWv6lVMdd/ND1ojFtSsBq0ENhUoduHaWd7+XrXMg9k5dsEivFc42KqOTACW
         wSDnV5gpw2Jb+3RTkE7ObItdmSHqOq+YvpztmdEHv5eDw2fzTBkf8e1Nn5rXct/fmrB7
         a8WhWV1DpeITJie/OUqqXjHQRXgDsG/3cuqXOqVbbZsABGBoGZqa/wfhGs5nfhNAZSY2
         dWKF+rXwGyxP8KIpJzx7fGsKs2WfpKzqbarc3j9Ns0v0v09rjoBOcpIkxkjSEV9/AVvg
         1DbiFeuwlURZysGA+gGi7FJ+5tb11xsXn0O7s9dAQA9uW9BnSs0K+CpXcDhgNajTq+u3
         hb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9SZoIoCxsXWhZoZ+2NLQxVQf52Wk1iyc/2gpqOYGvaw=;
        b=QbnxI5GyfO8GC3KM3p0QUAulACcZgedzvtxHgsB2pelXeka4wv+cqO8E3Xuc928gcl
         /vMhklpwKneWZE1msu6rXECPcCBOCNyJYj0xymY2bR+ronr0x0PHaCiOpXPdMftDP4YB
         fskEGeBaKzeT0W4ZQXMqzNkLWH1OkyQr2Ywzkcb46KVxq9WDHSMK60IWfsbuRR9s5H8n
         fNffMT/Z7K3BxvenS8rPRV9NkRrAlzvuTJc46BfblsgGrgK0hxmyqVeUwALRcL8vqn4K
         1Mxpeb/O3fdpntZNqROYZJLtSeNkcXqP2yCTZjl2CpC9FUPXZkqlZZWZOj5qVAPHKOXw
         P+sw==
X-Gm-Message-State: ACgBeo3Bnbr/o9qDYIP+xClmShNnT5o7Q2v4iXJsHYDuA25BCIc6nnUV
        68xzX0CIjr0if7JfzyWOhg/7WA==
X-Google-Smtp-Source: AA6agR4YAnK0KCl+FiH9Lchzr3i037cqc95zHn36fpMKVntmQgPg7uxq4/5p3ar8aXzNLUgcNixZ3g==
X-Received: by 2002:a05:6808:1153:b0:344:a3be:c58d with SMTP id u19-20020a056808115300b00344a3bec58dmr8215977oiu.285.1661825719208;
        Mon, 29 Aug 2022 19:15:19 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.147])
        by smtp.gmail.com with ESMTPSA id x43-20020a056870332b00b0010d5d5c3fc3sm2979780oae.8.2022.08.29.19.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 19:15:18 -0700 (PDT)
Message-ID: <fc410d8d-b0ce-1c16-a54f-a1da29b2ccf0@linaro.org>
Date:   Mon, 29 Aug 2022 21:15:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220829105804.609007228@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 29/08/22 05:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.64-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 881ab4a7404df537a02c17ade40cb8c7510b5ff0
* git describe: v5.15.63-137-g881ab4a7404d
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.63-137-g881ab4a7404d

## No test regressions (compared to v5.15.63)

## No metric regressions (compared to v5.15.63)

## No test fixes (compared to v5.15.63)

## No metric fixes (compared to v5.15.63)

## Test result summary
total: 104529, pass: 92369, fail: 635, skip: 11206, xfail: 319

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 65 passed, 3 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 58 passed, 3 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
