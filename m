Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21D82791F5
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 22:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgIYUUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgIYUSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 16:18:53 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742CC0610D3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:02:04 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id v20so4041350oiv.3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yPWUmplzl0JEFZ6wTsaLsRULKnL6cmReWmOzfl9wStg=;
        b=H0XLLB7ai21FKXztzG6oRk3OWu8Wgz+E8zpkIQotVbmVSjOm7e3J2dlh8zIIpj8AaG
         6eX3ds89FL/W+7p696HVWSB3Q6ltHYZTkh2Vhd5hBOq85YIuuz407nnufKAX3z/TWYsH
         Whgr/lS8Lz4K3vrT1q6wjEjI6C8w0OhM2VRxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yPWUmplzl0JEFZ6wTsaLsRULKnL6cmReWmOzfl9wStg=;
        b=N8R7M6PE/DufU+wlEqkQc8PAMHR8+LIwCC8k4mjPbiQGt/Q45S+ahCPkCedTAR+rp0
         Wklt2Dftv7ARnbX2PMGK3L54uZxAcF/p134vLir3gZpeMkXMFViu1heTwuEszUcVPFbQ
         psho2FEiocixaQ6vTTfmdYXAbLuemhiCrfoFokY/1mxy+c5LsTlcdNJ7+c/yA/DDWPVT
         2NiKsLzhsmp/MUmtuIHCcO1cKp3VopG9dGC1czDGwoXEWcNqmKWzXhVhYDbMzG4jAOv9
         /jFPA8Ev7RLLdz6tZmbxQotBFyGk71OzbQk3jTmiDy7iRtDrDagTi+SNYNIJYOfor3b/
         XSJA==
X-Gm-Message-State: AOAM532aE22LBGxIc/abQHMfbkAkGQiXdk/hzXZgMyuQTmmO/9OsUkRh
        a/BnuSzLsBdrwJc70shnhNaiYQ==
X-Google-Smtp-Source: ABdhPJzkxSjBb4L2PanG2Uay3xcIoAygUQMF46kpamWYG6B7PV519d8BAIiV/OnHTszDcbbUP3B81g==
X-Received: by 2002:aca:f05:: with SMTP id 5mr112012oip.173.1601064123563;
        Fri, 25 Sep 2020 13:02:03 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p8sm43429oot.29.2020.09.25.13.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:02:02 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/43] 5.4.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d7e1c0fd-4247-5ecb-9cd7-d1ab383e1f78@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 14:02:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/20 6:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.68 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
