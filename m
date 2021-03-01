Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E637329415
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhCAVq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbhCAVol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:44:41 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DCAC0617A7
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 13:44:01 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id a7so19435790iok.12
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 13:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sq973GXnxonVqs7o59SCDe9kUa1tHJX4sSXdLEk5IFU=;
        b=RUWcerz7q2K7w+AxtJNcjcSnvnpu4TIGjjVoY0jDDzciqXVHoMKKp/wB3lHvqC2iYn
         L4VUzD9YBUQQv8C7SxFSuzcM3xa2LVk+2naeAbwy4s4GG8o2et6Fbh8WswpepS3vPNBH
         rVrOq0wpSldlI/2TAb/qsyRxAETt+dJwvFNFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sq973GXnxonVqs7o59SCDe9kUa1tHJX4sSXdLEk5IFU=;
        b=oyzVVM0TmisgtkgTJQCNq08+/B4nWK7MKjv8YlVkfiBC9Q5Q/lNFvds2CDQsJhvC6L
         ym31xPYbKaBI4S9mb6giJ2z4KsYX/WrmA5lXBZ4z2oP18sSyX1uykVvqUWMZtRvqpPR9
         ZksL/rUexeJaa1F1w7lcLo5jqwNe5Uesv1wVrsoinT8la388x/viIGqD2oazwyQ55f7c
         vRLBjFoIxbJ3GYJ8olKGgYmZXLUdd07EQaRV1rPFqeSbuU4T83ZOoEIhLZg9U1XZhEOQ
         CKeIqUIc/V0qJqynybGocVASW9wiyhSDVrvf3Jk/Rw85L6xdRoryg1oN0jBO2WgECcOQ
         FnJQ==
X-Gm-Message-State: AOAM531ue2ZWAG1/CUPPqpnk36ExRQL3ub42jx2oiFIzwbVGSYjObYI6
        VbWSMkAGzvGBMjSnpCZHQwsW8A==
X-Google-Smtp-Source: ABdhPJyNJe7NsbxysLUjyaL84haRGQgaLejOLyHUcm4jC0YLE+O3zhnjLe6TLeHOf5fRZgAFYpUxWA==
X-Received: by 2002:a02:3e16:: with SMTP id s22mr18475180jas.72.1614635040943;
        Mon, 01 Mar 2021 13:44:00 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k10sm4662617iop.42.2021.03.01.13.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:44:00 -0800 (PST)
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210301193642.707301430@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a2483945-2983-54ca-45b0-a617288c6001@linuxfoundation.org>
Date:   Mon, 1 Mar 2021 14:43:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 12:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
