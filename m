Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C984E427274
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhJHUra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhJHUra (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:47:30 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1CAC061755
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:45:34 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id t4so13484931oie.5
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kExSLxFCzGRNQT0A8GUDahEcKucmfYYxMh1vk9rQ3Eg=;
        b=FzNYbXbGfibE4o+SyCtHXlB0Kzl+lRGE+7RTBdNUAc1wsdG5kVFnBrEvns1smX4GPv
         3/XgJiWB5d9hhwHToycmkj+rM6sZK9XD9CrFUJKp9cwXceWtOQZL4sDoTUsyFFSGd17Y
         BsYACqQ8JGD3bcEf/iAQaw3D7OkZ4bQCOI2og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kExSLxFCzGRNQT0A8GUDahEcKucmfYYxMh1vk9rQ3Eg=;
        b=hKOxwOE8qlbZaXOs3ODLOU+3F9vFyWhDYsXDIUWV2+2J0FtWJPi2PhJ5hRzQTSlveZ
         P1/uBytUFecZBf+PoBlqr0KtL8FbhAqjJTW4oSByEhqzvmemF2/sRYd3Eia4DHj3F2WS
         9ap9iIbyihxUhXB94NvDWq94BfWKTepS2TKY7HwiKUXpqTegqoyFYT6ZKhCPlsNju6N8
         Xenepq2ezDvtqMd8R9PrjY3eNuPJt/F3szVEGL+6m0zKALhWE3AHMToOFhCkhm48zU7E
         pbVRM3jePV/l2SmZj9yTlHy9RpWwrdaT42dUn9qa/YZFhcsFrzZWqGIi/t3nihMGd7xl
         GLmQ==
X-Gm-Message-State: AOAM531GiQrvaMufV4jASC5fBIlicGo0e/3HarQStmycJmuZF6CYALUN
        EXfBF6tQf3+UmF3j1MedKH4fxQ==
X-Google-Smtp-Source: ABdhPJx+vERtutZ2HAWH36HX0c6r9TCGotwvWB/6KVAaLC2CYakDOeo2/AhvMRqoMW82jLUymU/m1w==
X-Received: by 2002:aca:b3c3:: with SMTP id c186mr14623719oif.100.1633725934018;
        Fri, 08 Oct 2021 13:45:34 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a13sm109080oiy.9.2021.10.08.13.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:45:33 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/48] 5.14.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <26a66ea7-89e7-9734-773a-b53a6dcccafe@linuxfoundation.org>
Date:   Fri, 8 Oct 2021 14:45:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

