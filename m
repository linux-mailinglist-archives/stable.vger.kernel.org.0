Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98D141765E
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbhIXN7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhIXN7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:59:33 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4B8C061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:58:00 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso13168751otv.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1RcBO3ZwhRNQkUwWNcFC7SDhJcoyZAxAM430ZrG87ms=;
        b=rrBBzseRPWIWqPREa3EHzm4fUrYBTti+FuqgMmysyOmazXKbAdX+iIHoUEw3fSpck/
         ksSYrOSbX2/X/3GQ2YtFfvok5xwlURxtQEXrtD+dpSny+4oubqqucb9Fe4kTSOfbORXE
         RfVMYL2USHgwlwMn8Nsy62wWaNVZpj14yQAV+EkzjpsGj1pXLcbCllcKJFdG9y8iGY+P
         ZSDatBymPS+HFv6lMxNoxCJHlNUhcZuDjKdMDk5EFeYlSjudcsMG4bKEHf/SWPnDmNZS
         JTvncV5uC/xkauDY9pplhvtNw5DXhZ3AB9Pdcm9IPWncXgXWmNifUZ6x0OuWtKtWhbG1
         U28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1RcBO3ZwhRNQkUwWNcFC7SDhJcoyZAxAM430ZrG87ms=;
        b=prFNUpwVqi01pg1/5RCNyNsCTsgL0uafwBG9W/+19PwtXMzxYF6Z39GDaSfxN2v+fn
         m7eW6oHcSEsvztKSM0d0dzQ3qH86L8vuvL4cmnx67IykO8Cqsv5BJHAn6hUSFnEXz+ia
         RVlomPFGMbQpyn8E/GfiXS4oshNqT4sy9q8PKmhicp43Ka+VUAukl0aJNFxdo4Kg5SLx
         UWctNRxghn+Z+LX8E4CmK/9Emb89UnjR464+MqXCyXu6A8TAAucIfs58VagUZtMzLYPS
         CaYApeGZkQAZlCJF7vj4eCJVXgFnBTsGkCYgztGhEhWjy+3TU7AnM4O0oLfYhpv3OZdJ
         PGsg==
X-Gm-Message-State: AOAM530t2Bhevbf9CLkMBS7o3mMM3EoOD4n08jhE5XWWx6vOqsAOy2/S
        40xyJeXXivOkFbLT1/+hd/5jZDYBWO9UNC90HmI=
X-Google-Smtp-Source: ABdhPJydKy3JnZHwlx58C/M9tbjbC9mXQ2MOWBPDY3sQOikfhnSRVyfkCcgPDg+2eB6jFPeg9MJKRA==
X-Received: by 2002:a05:6830:1557:: with SMTP id l23mr2778759otp.154.1632491879751;
        Fri, 24 Sep 2021 06:57:59 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id d23sm2146304ook.47.2021.09.24.06.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 06:57:59 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/34] 4.19.208-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210924124329.965218583@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <05f5f22f-f83d-cce1-3d40-a8bdb030472b@linaro.org>
Date:   Fri, 24 Sep 2021 08:57:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.208 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

This is also seen in other branches (from 4.4 to 5.4). To reproduce this build locally:

   tuxmake \
     --target-arch=arm \
     --kconfig=mxs_defconfig \
     --toolchain=gcc-11 \
     --runtime=podman \
     config default kernel xipkernel modules dtbs dtbs-legacy debugkernel headers

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
