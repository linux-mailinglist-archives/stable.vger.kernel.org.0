Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA933C67F2
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 03:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhGMBRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 21:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhGMBRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 21:17:38 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB6FC0613E9
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:14:49 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id p12-20020a05683019ccb02904b7e9d93563so8771529otp.13
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w5fuKXjD5exY2sQw3ry9Eee8PiX/OiSILoIjdd1zuUo=;
        b=f8z+Q4mvrnq2FTejbPWeeya3k+OIhbkCSvEJOLZLYeRPOj8h7VLXkU1KdgEnxcMVeA
         eWVy90QH582D9VcBFYR91whYBS9Y9mcUgA5ZZEVyrQiZ84ltSoBq0gSgpBQIA1/Gy7s7
         /ha+gobZJ1P+YU7tMtub/MHcfSwg+ojvVQXMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5fuKXjD5exY2sQw3ry9Eee8PiX/OiSILoIjdd1zuUo=;
        b=jWlwwJT6Y82+j/tLYBZth3NfXI2pV5rM+TlEepAjD8jdYd5ynVbKwrgs3Xyao60QCk
         SkLnd8BWjCXkDszMhLEO2UNgtbQgfat7+qg1U/jABvGEz2FXZVyLEIic4SrK57PE+kIh
         PK2O7gD5vFx3O6xJUAhulE15Pqez6ccDMw9cjqKsYpT1qvd2rhjpozKFBIur7kZTVqTf
         0yUzgJWa4SRkfBWx8gOFauRqGmMzqhBZqCsW1Vlv9ZpkcmE9WfMmMZkJvOODKMYjGECF
         b9aCeV5P+Xu/kyACdD+VC2v2ReoFnlqYYqQ58DuPpfUoFQCAE2k3VR+rR3fUiWVoVffm
         0UeA==
X-Gm-Message-State: AOAM531Cr54FSsUrnwxEJ50GpwQxwkmdZsJDz+RUstPW5l7/Fu/5AIM7
        k7u/tSSiFsnVidbiXDeXBg+hQQ==
X-Google-Smtp-Source: ABdhPJzJ7GYHKJVRuj+Lhcr0wl9g6Glzy9aRm8z8dm0Oe0Bs3J3KZHZGDVj35PaNAJf4ibJLlmyAZw==
X-Received: by 2002:a9d:d04:: with SMTP id 4mr1460109oti.251.1626138888711;
        Mon, 12 Jul 2021 18:14:48 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y18sm3429515oiv.46.2021.07.12.18.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 18:14:48 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210712184735.997723427@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <893782aa-e7a6-6c29-03b9-0d53ea63d60b@linuxfoundation.org>
Date:   Mon, 12 Jul 2021 19:14:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/21 12:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc2.gz
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

