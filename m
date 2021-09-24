Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2262417681
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346547AbhIXOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 10:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346601AbhIXOFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 10:05:15 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63906C061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:03:42 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c6-20020a9d2786000000b005471981d559so13246870otb.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aUgpOTiDZvmTt76rxn5uAHPl/PYL5YtAG3nPL4v6R4I=;
        b=pYEOV8rBhKHTrn2MMLLjEa1mvTL6aPzOps1NySmMq39iqqPyu0iyNK9HskM2Jw8Wat
         8ertCtRqg2RgJ+3wjve09MzNtyowqpmugvA+RJujmA55T27GH+vXJBEBi+LoF68rlqaN
         0pHxrzSaysBCHnLQ6nLU+0LRb40RYXLH/HpVozRAaRUMXmqJ3HQSNHqDcsKbgW+UNVMM
         OAdD5CIMA85JyHOa7eJ4SMw6VbyYwnYhX14ihVeLD2HtwCeVd+2yMAobZOmlTBNjtavQ
         YKCBYMQspZJe44IxaACoL9b7A9nMip+768RAFjakji0TDlnDidNxL/cFrLPUFQ9vgiBF
         1ozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUgpOTiDZvmTt76rxn5uAHPl/PYL5YtAG3nPL4v6R4I=;
        b=QAWCoPn1EPKasWKiOjuTps4cUblDM3S1buhTdHi3dC9JlG5o4jSuc4h+8DgGq7z/JU
         xW364ivo/dVVTiY11K39mwMxFSsQbd+Q0VccblDyfzr0m0okkQ/w3EDJNfX/HUP0WaRz
         tDxp3uwWECsEx1Z3/f2BMl3IQfqbiieQa2q+iz047Ebk7SYJWV4kfVmRNbzGn3ZDMkk8
         K5JYvn4KeMTWCUrz8Lxv2S+OPcXcQNgg/HEiMdcmRCnZYep+xzDsl/x+GrgUOSOF2XVr
         HIOc5Bf+vGnFTHyQM9WvNSFK2kJvhrhXLo9tz4oV3cxrWgJ4cOi/uwtw2nRFJbhdr96B
         bMuA==
X-Gm-Message-State: AOAM531LuK9oycUrIYyUMkbI4aaxODsO2TRUlgBi36aN4Ooe7PvMpWMH
        rQ71JHrAzkLaqD7eWrY5Jlwb5g==
X-Google-Smtp-Source: ABdhPJxihmj/baI1dfiWXKGYqaj6BKzU44/ljSROQw3S0is+k7ZP74uyRvek26GLN3jSfPvcvRa3bg==
X-Received: by 2002:a9d:7dca:: with SMTP id k10mr4171342otn.54.1632492221584;
        Fri, 24 Sep 2021 07:03:41 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id i4sm2058617otj.9.2021.09.24.07.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:03:40 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/50] 5.4.149-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210924124332.229289734@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <e23f6b4d-1ddb-d9bf-8ee7-16fe40532330@linaro.org>
Date:   Fri, 24 Sep 2021 09:03:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected.

While building mxs_defconfig for arm with GCC 8, 9, 10 and 11, the following error was encountered:

   /builds/linux/arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declaration specifier [-Wduplicate-decl-specifier]
     285 | static const struct gpio const tx28_gpios[] __initconst = {
         |                          ^~~~~
   /builds/linux/drivers/pwm/pwm-mxs.c: In function 'mxs_pwm_probe':
   /builds/linux/drivers/pwm/pwm-mxs.c:164:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
     164 |                 return dev_err_probe(&pdev->dev, ret, "failed to reset PWM\n");
         |                        ^~~~~~~~~~~~~
         |                        device_reprobe
   cc1: some warnings being treated as errors
   make[3]: *** [/builds/linux/scripts/Makefile.build:280: drivers/pwm/pwm-mxs.o] Error 1

The same problem is seen withs Clang 10, 11, 12, 13 and nightly:

   /builds/linux/drivers/pwm/pwm-mxs.c:156:10: error: implicit declaration of function 'dev_err_probe' [-Werror,-Wimplicit-function-declaration]
                   return dev_err_probe(&pdev->dev, ret, "failed to reset PWM\n");
                          ^
   /builds/linux/drivers/pwm/pwm-mxs.c:156:10: note: did you mean 'device_reprobe'?
   /builds/linux/include/linux/device.h:1565:25: note: 'device_reprobe' declared here
   extern int __must_check device_reprobe(struct device *dev);
                           ^
   1 error generated.
   make[3]: *** [/builds/linux/scripts/Makefile.build:262: drivers/pwm/pwm-mxs.o] Error 1

This is also seen in other branches (from 4.4 to 5.4). To reproduce this build locally:

   tuxmake \
     --target-arch=arm \
     --kconfig=mxs_defconfig \
     --toolchain=gcc-11 \
     --runtime=podman \
     config default kernel xipkernel modules dtbs dtbs-legacy debugkernel headers

or:

   tuxmake \
     --target-arch=arm \
     --kconfig=mxs_defconfig \
     --toolchain=clang-13 \
     --runtime=podman \
     config default kernel xipkernel modules dtbs dtbs-legacy debugkernel headers

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
