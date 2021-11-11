Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7737D44DBF0
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 20:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhKKTIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 14:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbhKKTIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 14:08:35 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED72C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:05:46 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id o4so13273240oia.10
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 11:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zgLTXQx7XG/RE5Vcfjt6iMhkt2uyh7BJTQm8WaPiLqs=;
        b=V4t0l2bmHB/VNzIsY5n5XApZALL5FUrVvb+kxuxTG919PxGmvGWTKOKfYmKnsw+AJ7
         amqZ74C2B+p3Hp3rbTpGQI92jiLzO3LQ4LM4xig1S6IZy3ng5NIWx0OpNJKAiTwPrRac
         Xqi//I6zzMP3IgyMDIXmIxjqcKrYXpSGvBwW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zgLTXQx7XG/RE5Vcfjt6iMhkt2uyh7BJTQm8WaPiLqs=;
        b=114g4xfj2bn9LjO8YUwm0F3923P/PyziDpnWxDGoDwctokz3ijgA1C1N85C/cLrwvd
         +qtyFyksOZUyCXPKQyicX2PB0GPmk4JpDGwVrh16fSvIrg7z9GV2CZtqpXKj2rK1jWgp
         ImxYWiFN21r7A5i3moL0JmhkGxUpaCC+tI/1uwIYy7KGXj2ZcGk0PHG8QwG9HP7zvpoD
         4uN7WJ8uOCu5GyZMAW0jumqXkUstm5jMjP/PsU9jC/Kc9d3rhPzwBWewV6ODlAlxdME9
         46ZzeDQq0PhWOVp/dzYf6PbnUznB9Jqa/ZtjIJXiQDkXUG3mPuR1mR1GD/ZHDsXA5cvt
         Ys/Q==
X-Gm-Message-State: AOAM530A8Xtdc6U3kQ4FHawsIy4yVLXoKB3UXiavLvLSK/41jrJY3syu
        z14+2HiTLr9ZewaFvlG19r5cUQ==
X-Google-Smtp-Source: ABdhPJwaoW+DJZCxHDZHtIBzQnUmdHQZCji++QHMchGbdK1UfDC5DN7DKsliz58arQ8lFVVpF+MtPg==
X-Received: by 2002:aca:c0d6:: with SMTP id q205mr7967604oif.14.1636657545928;
        Thu, 11 Nov 2021 11:05:45 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 9sm816052oij.16.2021.11.11.11.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 11:05:45 -0800 (PST)
Subject: Re: [PATCH 4.19 00/16] 4.19.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182001.994215976@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e110e979-1b8f-cfe2-b947-53a821ea2314@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 12:05:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.217 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.217-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
