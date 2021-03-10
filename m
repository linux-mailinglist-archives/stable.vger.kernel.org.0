Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0747C334ACF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhCJWCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbhCJWBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:01:50 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F5C061756
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:01:50 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id f20so19636351ioo.10
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3cP7P+yaSZll8Aff9ty5g2D35+pxtgQDDxTDTmOEYgg=;
        b=PuMwMmd78vULTh6oO14V/Ss3gJlNSNS0U6ju/rYR671Ns3dPWZWdKU8JWBv81cQm1K
         QEkdhysrMSl+yFgH4MA3WBTRvgc5tSYC8KEjvcjOhzdkqkjiSlLMLwiu3WVTgUMxhMkC
         yWxEFqnwvORfE9VBYVXNj3mHqB22NywvYx4rU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3cP7P+yaSZll8Aff9ty5g2D35+pxtgQDDxTDTmOEYgg=;
        b=pFqDkIfseU+y5AMOQCvISygYARj64jkOH29AnL0tH0QZ4oVMzpcel3kJl6jMFgUcmn
         oXr5sgSYqAcPpzzLBBbakScAEnmOuBTFRBXXIWFycwjMSQWZ9M/J2t2gnw+iAFHLMoOd
         VhfxyfFWhfAb0UJWWUVDdaA/yJ1b55xzfLrHC34+XGQkghouGLLdgKte9vFJ3T1EZ1dh
         SrSlEGXDf14OUOBN8BUfxr9onTyqCe5f/WDJwY2RuDQssB23Zwt7lMAcPokDq+jiiMGY
         C8Xo7yOYMODEQNSnHp2f5mLk5pFcJ5IgvAe6NYiaSavJxJZ4OQ7QV9Ob3Fk/WHba/qtr
         dbtA==
X-Gm-Message-State: AOAM532cSP+hFjiTT69wG2+bp+EaGhhRXLKKK4KBwMRFGGyPqlUJ7CTW
        a07WFeaLbRpn43iTotoC2uxJQQ==
X-Google-Smtp-Source: ABdhPJxNxAKjK/e5ReM+AhU30wkxHnicffEyWGJIL8cfK1HSBz6wjHoZMhLJ582yWUk0obhKsIcEZw==
X-Received: by 2002:a02:cb48:: with SMTP id k8mr629706jap.52.1615413709830;
        Wed, 10 Mar 2021 14:01:49 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 128sm393274iov.1.2021.03.10.14.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:01:48 -0800 (PST)
Subject: Re: [PATCH 4.4 0/7] 4.4.261-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <387a12a0-6161-2b79-5087-10873775d18d@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 15:01:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 6:25 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.4.261 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
