Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE10F41764F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbhIXN4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbhIXN4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 09:56:52 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8876C061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:55:18 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id v10so14446967oic.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 06:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HgMsMM12ambgjasVHiwyMyFy+XML39ZEZewyFh9rPw4=;
        b=qRhMKtVK8ucMXnLTDuWt9+oa8HmAZU3NpzuLxZI2oEqYMj9np3rh/NL6x6Xmty4KB6
         g70481O46js8+1ODJb50/9WjOraE4VUDheZcEpGuu+crkRxsknirDDynfPqlHaAOUda2
         KaBi+M6y0GlyeFokX09QZe2oXnnBldGwnJ2+hNjuM65GKp9/50oAfdYBSVnhJ7YgYlyQ
         N6RzsrarCUHZpfUVr4v/QZmhKiz7nyyWYM608C36cnlB2TDKrJisYQ+/RrLkHMvy9ZGi
         /W2BwR1wy9y06jTx/CuERf+LVB8dp3+uASEdwy7Ds2vw7/XtIC3Ra8bVKOeZHhn1FxO6
         Akww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HgMsMM12ambgjasVHiwyMyFy+XML39ZEZewyFh9rPw4=;
        b=kKEBp7fot8lNaIFC4HfgBMxu5Ir1mbjtKQ2Osh8r+++maG/aEk4fvcLAgjuVEG6ddJ
         Xs4iVY3P8NlGUelzj3He+81x0coPdRhRjDZ81f86CfTDWX+YpnxAf6yncOa1OGfTyzxy
         6rKU86EzHiyz9V3ytwMGCWd8lrU59BfxBgM/0tHrxOuBcBphyWKwrvrctQJHhxLFMUjZ
         STE1JhU54tSOOterEtUE/I36eX7TUkWilq1gsRFiN3SiCXjKXRbaVfyHFEV4I1enQKqU
         HoKePYwBCb+JLL25z5YVyOODIhUF4vnuPMKto1OCq88haGcL/yi4G2Th4zFFHENKzEkb
         CvGw==
X-Gm-Message-State: AOAM532ixcNwC1JyveFR2iVOxJJtmlNmqZV4ZDCZAi3AyQC54/DM1kuD
        QmU/dp9J0cb511UlHm9sgwQsdmiDu+JbOdm53JQ=
X-Google-Smtp-Source: ABdhPJxMUWVvrysy6yHMhSZN34dYLdW4eACOQNZUynEuyE89yHiGF60SvMJfXidFDNd/tp9fgihDhA==
X-Received: by 2002:a05:6808:1187:: with SMTP id j7mr1571141oil.135.1632491717550;
        Fri, 24 Sep 2021 06:55:17 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id a24sm955776otq.42.2021.09.24.06.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 06:55:17 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/27] 4.14.248-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210924124329.173674820@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <4bd73a4e-e606-0054-e4b1-9d6c89a81186@linaro.org>
Date:   Fri, 24 Sep 2021 08:55:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.248 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
