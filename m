Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3241763B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346185AbhIXNwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346466AbhIXNv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:51:59 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEBEC061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:50:24 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso13138726otv.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sV48vw6IGcklWlbZIMl7FtX9z0T8teXN1HpyIu8i14Y=;
        b=hVazJjBI2vd2tVbUtrb1neOgJi7sHqSNkXAjm7bkHX+s+3kAY0M5kOw7ImmU0cSLfX
         IK7ZaGcKhrDOsv8Wtbp+We/x0ahwJM13jLfihrDG0Vs9gySlONjrDHeUqBt91VgjAGZM
         zvwnswrSkRH3btYmKzZqM2/1/243IgtM6q6DJOJTRGcvEcnhbJwKleqolYT8+NHgEQQm
         kYdA1LtAlGvutfm1K+5ulg35zL55C+ZDN/x8e8PtLjg5W6Zj7ZR3ElR02b9tv6g+hVrr
         sJv0GNu7VSVvTcq3g6j6gG9MnmozAgpi5hFxHx7B+lhTOnFe2DOb32PJjH+eZq826BW1
         SvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sV48vw6IGcklWlbZIMl7FtX9z0T8teXN1HpyIu8i14Y=;
        b=UuXBPEx8D1tsM8vzOijHkp6zQeVfM2Ysl53oK3inLazQXBiRhli4QPRAnHB8MSJp5e
         eg+9FDip8ibuw04Gwykkhz9iHXqYDSuO6TJGudYhUEeARJSMWdyG8wxBzLWqqfqTsACS
         lMh6Uc3sU4oi6bgCsPqGOYWhC7FrrfSkyw7Lqiy/A37EKZ+SM0T7RlawrbnuwSeFee9s
         487wbU+JbiBFjyGPzh/MtFJOzhUEPozt34WoupllmxFdCd2iLZOTPbArbl/5s60dOsWL
         eoagIk9Ud3uPgCbKT5wWLnaz7ellOetAiOoKlokvdRA2P2Pa7gZJ3uZ0IBI7sNFKNM6T
         W/JA==
X-Gm-Message-State: AOAM533YN0iXhlBLzY3BIdoJ53uON1wSdoGAWiclx+LwmfDymm//QftN
        XV95EzKCG40I+0Bj2kCFEPvPEnvWQzE5Dmr58mM=
X-Google-Smtp-Source: ABdhPJxCYVrRHdxpr631i085QY22e+9JoSprHypM05PMHQ86XTbakTpALxVLafCEWh03nqxr9XyKVg==
X-Received: by 2002:a9d:6a95:: with SMTP id l21mr4114113otq.330.1632491423185;
        Fri, 24 Sep 2021 06:50:23 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id 9sm2084286oir.10.2021.09.24.06.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 06:50:22 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/23] 4.4.285-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210924124327.816210800@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <eab2f99b-8be2-2ca3-27de-d98cb36b327c@linaro.org>
Date:   Fri, 24 Sep 2021 08:50:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.285 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.285-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected.

While building mxs_defconfig for arm, the following error was encountered:

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
