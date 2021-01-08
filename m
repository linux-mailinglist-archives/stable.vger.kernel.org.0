Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8C2EEAC9
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbhAHBMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbhAHBMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:12:10 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5878AC0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:11:30 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id b24so8267708otj.0
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qEiNByeSj9Pr5DDd9k9y2iFT9KZJKvYEWcKP+eRjuMM=;
        b=d1yzBSOCuJ3YT1ZAy2bSeetRCbAYUMHEKuxx9L5FS92dP49aXeQrVqECFYCmT8cpel
         D3pXnyw+KOoL9iz170M6uDXpGI0C6WpNS6FEL8fEvWizPXAEZdhIh3Jzk03/3d43sHAI
         uKaz3DEV48ukVtgKNM2R2HyXJ/o6ubF8rxigU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEiNByeSj9Pr5DDd9k9y2iFT9KZJKvYEWcKP+eRjuMM=;
        b=W4rKWlOmqmpZrF44pXEG78YEvZZTjObr8dmS4AGOMPe/5cgoqxM312gXOXqyUlgMIK
         KUgvtUE5Nb2H8lAKGbhE2zZt8hxWqmIPYbnszxjw3YFo6NNqpUuVdLZTHHG1qLhX17Ih
         Q6Ge5YqiLNekoplu+zFOx+ACO2m1H92CfOhPljvP6otVKWBNh5WvUHYc6UU3RCzyLJR0
         jgzH1zGN6LyeG8lPzmWR9C8nPHdnALidzOU+FGwC+g++BUDjji5QQxJmW1ic6Wn4SclU
         Kfz2gF1esRPZjgl+5oFXMQEcCfp7fQT6XDBCMW9DdxwTro7BZhub6UotSHy+WKwXTfi8
         DxMQ==
X-Gm-Message-State: AOAM530/Q+AJ3lbD2RVnAIWnu7NnjecP+oDWIlVPDe2rvo16kduPW0Cz
        AjSdU59VVunVVQuDvLrtm6aQqg==
X-Google-Smtp-Source: ABdhPJyJfMNFiVEXnGNrRiT2L4z5Uv6xCOiWlTObz59vfv2BbD7iIppO3Q3F+TWZQvj/PNkVx40Chg==
X-Received: by 2002:a05:6830:1011:: with SMTP id a17mr899649otp.97.1610068289810;
        Thu, 07 Jan 2021 17:11:29 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m3sm1505841ots.72.2021.01.07.17.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 17:11:29 -0800 (PST)
Subject: Re: [PATCH 5.4 00/13] 5.4.88-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6def1bfe-3e29-c06a-e990-f562d0f3bfdc@linuxfoundation.org>
Date:   Thu, 7 Jan 2021 18:11:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 7:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.88 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.88-rc1.gz
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
