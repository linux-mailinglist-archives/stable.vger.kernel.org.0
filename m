Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505F24735F7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbhLMUbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbhLMUb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:31:27 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B75C06173F
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:26 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id t9-20020a4a8589000000b002c5c4d19723so4451538ooh.11
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=deKBr0LFoKPX4TjZtCSnouZiCvMty0dcKoc4aq9X93o=;
        b=TIPndPq8h/a3wocqzKobbwtmpxchO9McvvpT9SpPY5cGW0CeXW2RRBfAnU6MfUk2jW
         KrLcDyTs07DBUcv4qn2+LclATc/hbyCOMaTbWBwQ7fG+GQ9CtvUy4BH0LFGnjqbpMQ5L
         bMEKY4Vvo7PYZbGK1Y0JwW/SqT+rSdOn/lsNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=deKBr0LFoKPX4TjZtCSnouZiCvMty0dcKoc4aq9X93o=;
        b=JclJYG2pAaTtEFUbtIo8G30/mj5l8yQ/5ZXkr7uGZu4gkQ68BPJ6j03b6x/8Bt1GYx
         A8oP/9YlqkqOVRlBGBqVYArnk6fp0UtXGwBLVI5aQFPTlPSUsKYIg1u3j+Sp32vWnRWy
         3DfHsRaxqWXQV3V1biQBLEvTw4Ad45yzx18tAlKwexH87CVjJr4iSAvQuULtVf/U/Abo
         hKUOmC1vShpFKrm8JHvb3Rhnna0/p0zcfW9vapk46VygrRiA3NpWu86AqMlthgYSPz3P
         U2TS8kb+61xNTX0CZlbu07IOLWOMPuGpowUHL3F9nEksrk5IpAvlQoiVUnTOdG2pviM+
         oTgQ==
X-Gm-Message-State: AOAM530yDqJ/ia/Ze4KKva7byfGYLM1Bjiq7FhW/S9aAQjCxNrmwWW2c
        39kjQhyLgefyFSJPbim0kta02g==
X-Google-Smtp-Source: ABdhPJxcGmSRVnMQlMEXwzojRy52+Lb0yGIRbQNo1oW6pNe9HmnDaTzSBbGX/V2wxQGtRmYY+VUXeA==
X-Received: by 2002:a4a:9292:: with SMTP id i18mr521275ooh.90.1639427486265;
        Mon, 13 Dec 2021 12:31:26 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m22sm2534142ooj.8.2021.12.13.12.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:31:26 -0800 (PST)
Subject: Re: [PATCH 4.9 00/42] 4.9.293-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f10d5090-4966-dc8d-bf71-30dd9b312d94@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:31:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.293 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
