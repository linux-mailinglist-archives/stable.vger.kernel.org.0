Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3F40ED4E
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhIPW12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhIPW12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:27:28 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694D5C061574;
        Thu, 16 Sep 2021 15:26:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j6so7305593pfa.4;
        Thu, 16 Sep 2021 15:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6+JaY039DlaFbi+21JP19lSDodq4tvysqsCfKLRO2M=;
        b=UJJ3AnKrEDzNFhezYT1L2sw/eGnrs64PUIl6se1MxMEMbJThgmxzIDoVal61cTMZY9
         qXarRJ01L8PxGqXb7skSdkj0JrXOxZJAKWFo2MhjlJomHrjKOZQy5zPmu7QrkZLpBa1t
         F6jVl6FBmmevJxG80WRXMSkdBLP+IDkeyW19QGVR1XYbURcyxCBccM0g+uAZZiHV9oal
         JYrl1DbXVPmjSHDqQIRSkBktuSS3Lbk8eRgwKxql/Jcl0nDj/3ZESxKGjjpKK07iNxRL
         JWk9Oy29JJ29JrK5UFisUFufX/Bce/zX+fWecQIg7xtYMO9KKxy8tQ4GzKXbkV7h+vEh
         IcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6+JaY039DlaFbi+21JP19lSDodq4tvysqsCfKLRO2M=;
        b=wYN3MKVPD2xbSdURwO232YEtipFxrz5dospDdToMbYm4sRd3nmJwOoTpy74VwICkpH
         t+IOIyj2hVDKCxEOTDAcQlzFPr9JiDqfaXmzgxlOsVtrxxTjjmdYutgdvEARofWJQKtL
         5N2GFbOyw1mNxQwGVdqRP6lQlND3dID481Rico0+/E/xkUWnAQYzff3pIioUPyEs5lN8
         FVSG25iqGSOuAW6gYnjnbHu54KAH8xyuXqXsBvpVuwUAO4Q++FxXuV1y2gLvNc7jfaho
         VByggLX5kFx+JC06SWjP+tMGHbv/YT0ao6C9KodarplFO53Vnh4Ous0VajrnDUAEzkbr
         3Rog==
X-Gm-Message-State: AOAM532bl/g98wAUIjX2zT4KA3TVLKyymWPrQtdDsrtM/Ewdo+Og5SOF
        sKiAeH2qYan+ljb1dDtOSuPKyg7wpMc=
X-Google-Smtp-Source: ABdhPJz71CJd0hE1eLVEU03SUBWilT2c8lM+TZBjzT2Ynap5Pu4JOGMz9LN3bG3PIm8OzUH4h6AmzA==
X-Received: by 2002:a62:7508:0:b0:43d:d9cf:1f95 with SMTP id q8-20020a627508000000b0043dd9cf1f95mr7228343pfc.4.1631831166277;
        Thu, 16 Sep 2021 15:26:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d15sm8460694pjw.4.2021.09.16.15.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 15:26:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210916155753.903069397@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <582ff14f-983a-d774-a528-cb17b92f8d61@gmail.com>
Date:   Thu, 16 Sep 2021 15:26:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/21 8:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
