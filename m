Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A8B41B3BD
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbhI1QYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241662AbhI1QYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 12:24:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BFCC06161C;
        Tue, 28 Sep 2021 09:23:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23-20020a17090a591700b001976d2db364so3243448pji.2;
        Tue, 28 Sep 2021 09:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wAY3/JWg2wbXJxCRk/+67tG4BaraBIPavuBFme6tVEQ=;
        b=WdD2fQMQ4yQqLhkndIhwcFvm28lW6pOc9aRY2mdmuLh6kuoSQ+gquLZFvcP1DBe8nB
         QcIRprCdYkYjg/zd9SmxvXVHjnqKr+7y7grilB0DQYEk92LIaqZIEpqzOYsnScN0+IUr
         HjBbMUUaM76wx0988U28Pu/wxikUEPkrvV3OLoLs75PUMRnz7ZQsAI1A/6uPcHMVKn2T
         4n4rzJwi09MGC7Ywe1iwHjsoaJjrbCgacHuIZLDT8kabb7SToa7+vS47JqY50qj2nyFo
         XsGewgvYjBotUeGZlbOTzmJXK+XxTjUYB2X/xL6YlkReiHABm1IcoftQpOM7MyNsch6o
         uEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAY3/JWg2wbXJxCRk/+67tG4BaraBIPavuBFme6tVEQ=;
        b=hbQOk9fk/aVblrkRZfOQIY+YX7Qs74jJlbu2tOGT7MURdg+lvMnznIvZd71xIRqGZe
         d6nkjq/hHHeIJX2tCq1Ky+zW5NlZZc8cKISwnaTSwumnLaZH9e55+TPaadC+6eUP8H4N
         L7N5I2B/JL741CZvjv8uWnL+gJwftxAg7BgWQdfCitjgmPAv8GRIhiBfAYulEa28H2wd
         h1FhH9oyG1YLtASzr4vQU0lGExrsAaIyzf0mJMgj78FMR9W07KH2U38muPOpUZ3JTfmi
         H7Xu2yQsNXZR4E80E0edLLulW5EASjaLfSy3CokKEicw+/+asp32RZjHsO/+U4QaZV1U
         S+3g==
X-Gm-Message-State: AOAM531UUMnGuJyWVGasLJrZkcALNWo2cD2SyPAaqN68AWrmt2+xShiC
        3t2PjuTrd+NVErcbbAcWmNLPXy1Yj1M=
X-Google-Smtp-Source: ABdhPJy/9Uy/Br/pHc64+APndSUOnX5oGTCdbZF/7XFtBYKQyNFZalc1cRiT+sEtPm1r3Bp4wE+eGg==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr827904pjf.86.1632846180413;
        Tue, 28 Sep 2021 09:23:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m10sm3003134pjs.21.2021.09.28.09.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:22:59 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/102] 5.10.70-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210928071741.331837387@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <afc197dc-f79e-8afd-92ad-0986307dfa8a@gmail.com>
Date:   Tue, 28 Sep 2021 09:22:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210928071741.331837387@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/28/21 12:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
