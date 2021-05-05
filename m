Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B27F3749DE
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEEVGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhEEVGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 17:06:17 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9999EC061763
        for <stable@vger.kernel.org>; Wed,  5 May 2021 14:05:19 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id r13so2017214qvm.7
        for <stable@vger.kernel.org>; Wed, 05 May 2021 14:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oLDf7tFkG6ZgzhHYjct9YVhN62bQhTHvfjJslCgHbC0=;
        b=bxHK8twdKxEWzaWIZD49pKSwgDPouCetvlujH9i80nQOwrHMTbeD+vIDSoHEmnoQC1
         tyt5kCzN3y8ekrf4RWmdue8cf1jr/NxvNGgFIFSWt1hp0wAH2XaBi5VCsdygwuc94RE0
         NoNGThep3VDSR1NOBchLk8/Oge4ztWbAt9URA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oLDf7tFkG6ZgzhHYjct9YVhN62bQhTHvfjJslCgHbC0=;
        b=s97qjgNWEGw1MX+hBubblCAN+5WGT0f8+qaDz9yC4qMoJK7w8fzwFwt9YDKcO3mrF/
         nAvwZRjDbxx0Eesjb5xc8+KhBgcWIPSMotsgAcDj7Tu3rocMiWL2LLESh7cCVKX1GfNr
         V2CIAbnQarUapwUVpjdpuxTZF8pQ8lbwR8qXygeTAoe05e34BEfX6iez/6wiaW9pNbyf
         GcCAd9U9SnY3biK/kjgWsOQxpdsA/IlZRX5UEeCRbcA5zzUgcVNFxMS2hBDhR8Hg4Bfn
         jYwxWRBD9Z2zDmHNNknMFyki1efm5PiDEqWxTOQ4Cs5BOmI5RcggpGOESVm4JBKRWf75
         2Ifg==
X-Gm-Message-State: AOAM532d/mC+p46X6Fzi8I07yFwl2r8XjNNr788aq4rOu22aJl9p6aOn
        ng1vQzOXObUsOR5QRhdNu8CNng==
X-Google-Smtp-Source: ABdhPJyxgiSf+h87h38R0rMeazpMepKPfLSQkbEXIHjPYqLCLDZUFH3hxTvV41ZO71lAE7ewJoZLDQ==
X-Received: by 2002:a0c:8e49:: with SMTP id w9mr651929qvb.35.1620248718496;
        Wed, 05 May 2021 14:05:18 -0700 (PDT)
Received: from [192.168.151.33] (50-232-25-43-static.hfc.comcastbusiness.net. [50.232.25.43])
        by smtp.gmail.com with ESMTPSA id e5sm372521qtg.96.2021.05.05.14.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 14:05:17 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a86fd760-b17f-aead-f3f3-496ffd167c8c@linuxfoundation.org>
Date:   Wed, 5 May 2021 17:05:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 8:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
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

