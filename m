Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A605C4735E7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242872AbhLMU2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241121AbhLMU2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:28:52 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE98C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:28:52 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso18700287ots.6
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W/8wQ2VxtcdvM2j3p0ed3VDz3mdIlc5tJEKhVL4QjQA=;
        b=XyHU1kkXDJMdbca9ks8bO83Hp6tRv0p2pNHpoBkZi8V8mVpVk7oR2+lBaF5j8fQkEL
         dCaB6WqZgllIpx/5JjSpsiCdrqUpsogy4DWCj05eYBV9g4IJHPp+iwOXCFd/tKL3fUhN
         0k5tBFQxCzM0g7+ZB2HVto3WeREZMVFnVHRe4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W/8wQ2VxtcdvM2j3p0ed3VDz3mdIlc5tJEKhVL4QjQA=;
        b=GqiXuZDTDnT+sPYFzkMoFa/muLoHnr7Za89ES6iBlvjZ61GSbmmaBLFoYVgRDGUtDP
         AykQ7MPV5ylqz88JXj2awxZHnqnXXDREQC+2i8xpXK258frq0lt35YccnRHTlgoA0LIz
         BZemz+SbMk9Q/NXuMpQaIOIR9njzkMSTZiIZGBAvylwEMKNI2B9H3G9bASTxN+s3FHpd
         N7T76lpGiga41+UjHWIAF6vHT+yDDTul3K6cW4Oa1bIQpXxwFDnyn11qsonZ63Xdrux0
         i93MZEuovW7c8AhtiJ+BQbY6EmxTXfFrJTamEcJWZPmaAag18VNdBP3Gur+6P5PxRmH+
         hAfQ==
X-Gm-Message-State: AOAM531MGMSxwLVSeLX+72MQcWYJYxD2PE929XsdkrrsIoUM3BMHXADg
        hF71j46kxsU7oYwgbrpZAoII3jUCFXHscw==
X-Google-Smtp-Source: ABdhPJz4Jp2hzol3CDE72JitHkndebrYboNEeRiXGZzqvPzo5odPpx3ZdJ4INvAMZL1XwGHvl2X0+w==
X-Received: by 2002:a9d:d08:: with SMTP id 8mr713457oti.334.1639427332051;
        Mon, 13 Dec 2021 12:28:52 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u6sm3060226oiu.34.2021.12.13.12.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:28:51 -0800 (PST)
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fa89e60f-a2ca-e0d3-ea72-64b3e61463f5@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:28:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.165-rc1.gz
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
