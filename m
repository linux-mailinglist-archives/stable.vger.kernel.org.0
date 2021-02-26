Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB38325BA3
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 03:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZCZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 21:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBZCZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 21:25:00 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B160C06174A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:24:20 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id v8so3158882ilh.12
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 18:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bSwPBgYWrX1t8PvpRAiY8sEs2R5CFx/xK13GgwFJYkI=;
        b=N4Qk35pr7esoEA7JFHtA+sAzcSjPoPmiN9V1k240d0dr1+1IrSOPPCCiZRo9GLXABm
         cBKyPHeY9LoPkxf1cGuVtcUqV6Gu59oEWScDbQOa+dzSagZXVfrdkK0uUb2FW01ydj9I
         2MamwFtHfxLdNNOigkAFvq9FnMCdBY/tb/bCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSwPBgYWrX1t8PvpRAiY8sEs2R5CFx/xK13GgwFJYkI=;
        b=r85/eopLhjkvXD83X8i8Vkr1hqD1UPxrxzwgT2W9YoXxxKHsfN5CGGcV3rTHW9hGDe
         acsNxkZpjlGEJF9MtLC6F/olG//u3lKxkJ8YrYhYT1gQl0ko7ZkFatBTRqOzHhHtWXPR
         tEQtljZCuX1a6KP0vrNk08dQnOS8kxup5LC2tutD6JZ8ApPpU6ZkvUHd/jIzjlLNNVR6
         zrer81JPOZ/E5/uhDHfNUfzcgNyzJcex8XQAG4waQzKETurX1EUhEUqnxtTUNOp/RnfC
         bnpucZI77byT+SVHsDV26JPFMhA7B7pt61U05NtbbpWXGq6/b6n7AZuXMi7i4m3W953A
         UMQA==
X-Gm-Message-State: AOAM531rTB00auXziQ39cfUcF1RZr5QZJh0Rxdjp/AyiPSFCErihDix+
        AvlGyst5a/abCp4pOxAaQhT3cA==
X-Google-Smtp-Source: ABdhPJzko9LTVlFTArRNo/SBYyV9WiPuAmPVkpSJi8Uqw90Ik/5olkEjjLvOxI6UTvZgOjI3wnbzDg==
X-Received: by 2002:a05:6e02:1a49:: with SMTP id u9mr592216ilv.140.1614306259317;
        Thu, 25 Feb 2021 18:24:19 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u14sm3959497ilv.0.2021.02.25.18.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 18:24:18 -0800 (PST)
Subject: Re: [PATCH 5.11 00/12] 5.11.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5f94d678-89f6-ed24-3ab9-a7d109dedf84@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 19:24:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/25/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.2 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

