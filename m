Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5E6453997
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhKPSvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhKPSvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:51:48 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B90C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:48:50 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id m11so166264ilh.5
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 10:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XJYyW0Tci3TNUklb/cOKPQPCUm07aFn/D+Bmcf4Xiik=;
        b=KYCUEeos6u91Sdb7DYix0wv5XEuVuCKEWhtPxSYKzrPTGth7aQTLk6GbQYQ7hFwyk0
         Os3uWQZk7XG1BmtWy+qvNwJAFcRfBFkPqOCL500I4+Jl0w2HyUahJq3w8lU8tFD4Opq/
         0riKM4/nv54s8VibLkQLQL0GduD12A0k5paBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XJYyW0Tci3TNUklb/cOKPQPCUm07aFn/D+Bmcf4Xiik=;
        b=NCcyumYb6awCGnu86u6ad4j8dlCj9MEdjU4IwIhTw2qTREXiNIkOFUzmNA22Ui5yDo
         JdZStW/W7WpH8GpwW6BE0V+Xz2iYUAjUAJkTYgJMF2rtgzuRfG+I/sUEGdqCV5St2A5e
         x8TarWp2gCItcKLc0LuvgixhPb7JR1U96TJQ9os2zQRICeEh5TsGRQt9bROsZPuwAZRh
         PJ+tj/BY/ODA6mT5ZgJt/JqZx6cCYoqNQCZNcB0K4r4tL4NBOzTqu4aexdXXSwqwSgcV
         d+UyIDb/3v70AjeIBQTsNouhOp6kKdmVHpaEjhDJGvCmymwYWpPDJK5YsacFW/GVlsYe
         mkeA==
X-Gm-Message-State: AOAM531QOdhaivmQ11G4MnleQ7Txo2BK2qwKDCUgVOMAObdjiGqYGG5S
        +K0zZ60ecqtrwAji98alp02JhA==
X-Google-Smtp-Source: ABdhPJx/l8dn5l1voX/EoTWc+IyR6n8EeL26XzkgYFwpQzMK3V/zH29LYAPkohMijYMSA44Q9lDfHQ==
X-Received: by 2002:a05:6e02:1c0e:: with SMTP id l14mr6011915ilh.8.1637088530261;
        Tue, 16 Nov 2021 10:48:50 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f2sm12688529ilu.54.2021.11.16.10.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 10:48:50 -0800 (PST)
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211116142545.607076484@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1efe8c52-e2fd-a834-75a2-092b2d16c7cd@linuxfoundation.org>
Date:   Tue, 16 Nov 2021 11:48:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 8:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc2.gz
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
