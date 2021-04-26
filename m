Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0723F36B748
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 18:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhDZQzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 12:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZQzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 12:55:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D374FC061574;
        Mon, 26 Apr 2021 09:54:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so22498225pjl.5;
        Mon, 26 Apr 2021 09:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2+IAvSoeBWxgcWgRt3QxR0C+botObZO5J3Ulb3j1CKY=;
        b=oTHiAXRwiJY5j7IcFGJQYDSwCcq1rmmluC8+B5xHdA8PrON+dLxyzr++IGI9rlXOFx
         MEjVSaxxmyLRllbfPuho5aCqmtsPP4w5PWbf5px8pTR5bqLuyFFbFqbSMATmYMD3jKP8
         noZnWkYgqiZHB6g+HAq7DLHXR0jnRHgop0n6ONnAm7jMJQ5Uu4BC7IdtV+tDQoq2Xo7W
         5ERQJP4iGjm4WitS1hIN2SSCyhYJ0R5tyXXyX09eEQHowZiNe7UBegmccSf/D0XthnKU
         IIurO1RskNMTssDuV3PNW7gjL3YnPW9dCje92JZNYSMdaaAZuXu7nglRHvhD9l0GUVeX
         tRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+IAvSoeBWxgcWgRt3QxR0C+botObZO5J3Ulb3j1CKY=;
        b=WCbLWXOEf1P6M97AI2hie/rJ7s9pwcA3lDxp/NjGlpk4yKOZQdF7wJtel7cwYqh2lB
         ZrgL4UN1snSxL8ZpaPmq6aYHdrd9/YijlDzeagg46q/G0geKE/xu6i0/7HxZuXFCd/TS
         5ydcMt5/Ip057N1NfnrheAcqCK88XB7tqXxKWy1RRCVRhpEVgGn3dUO+wwL35cpiBMhb
         YLJxNTcBimFG65X4aeSkE798vXH+rO32uln0A77JzTv38JTtxp4x7GPSLi71876salWU
         Fhugy67cYIUAwvM/eDrFb739ypTGDV7t80RrwXqjeRSQbXl/Ix/LubFvuYVsRhDJer2O
         8yGw==
X-Gm-Message-State: AOAM533Qt5mwkqBMmh5tgpfHA30epK1ckdVtux/5toAy680QZFvFJgzQ
        3KaFg4bl1PYGwm8ASt6hmiVdOozoo9g=
X-Google-Smtp-Source: ABdhPJyMaRD6K8JJljYbDQKqncGv+8nWMukl48ygi5VHN1tYUDPPa8zMbF181bI197uSImyEyqHAJg==
X-Received: by 2002:a17:902:ea0e:b029:ec:7cd0:9106 with SMTP id s14-20020a170902ea0eb02900ec7cd09106mr19327441plg.9.1619456072937;
        Mon, 26 Apr 2021 09:54:32 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w124sm242290pfb.73.2021.04.26.09.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 09:54:32 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210426072818.777662399@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <67106ed7-55a9-c6e2-333f-3896dd375ce2@gmail.com>
Date:   Mon, 26 Apr 2021 09:54:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 12:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
