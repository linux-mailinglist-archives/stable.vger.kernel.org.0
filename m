Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E646AB27
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343494AbhLFWCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbhLFWCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:02:12 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60077C0613F8
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:58:43 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id m6so24064162oim.2
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7CrEpXCNkAvkSCUG09v6c7Ryqzfm3lHSW9ddBRVii9I=;
        b=CriUkTIIO6uDuPWQgOgCxDaDTy6/iY/3Q+sTV2kBvLDYUV/ZoqSBQqca6rLWIGahGk
         pr5kgyyMWNOxC/sv0TVVQNj/g8WEAqnNJcCCxr5KZ7BCADAgHsFJHTkAcrWf/opKhcrv
         JfkuyecqfXwe+6l6E09NGb7aM3Rm7B8wRny6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CrEpXCNkAvkSCUG09v6c7Ryqzfm3lHSW9ddBRVii9I=;
        b=02WbtoqHo30F18ZQbdk1iwX2GWRv6hEsCTRcG2f15gWy1qx1ioipA/Ap5XZRmVgs63
         Lsi7pnycCwzoB951zMhodAArUC2OG/saxm3asZ2wpmtpkghsHeunZJMWK+AVcNk+WVkk
         QS8J8pGMxELLCNgrSUINEqqacBRKvxSqw7+IDJ0f5JRn1WKKoE1315ARGi1/wgJ/Ikg7
         LCkjiINDxtE4bo4aNUH76JLA0cWqdNdNmsOcXA8CjnC3RFsC6Gcl1+R9aFnzmpb+T3D1
         J7vDVkOViLeQbtiwEt6MLNfE5LW1I8JYpO1Hnj9fUlMO55/gI5HaFBOKVds/+z7lwwKF
         R4Rw==
X-Gm-Message-State: AOAM532kUk/fAU5PKPSrefX8cBFhKJ6F4v+YNMW+ujz33L9hOJ5p37Ez
        MfGaMg4OAWSetUAM9w9Vjff04bY/LLpQQA==
X-Google-Smtp-Source: ABdhPJwci9UpA7E9LFQSaZtzpCSFhjjapPss3ks3vY4+MZSoIu3BfnXXgst1zOekRYqWPmI6MmJPNw==
X-Received: by 2002:a05:6808:1381:: with SMTP id c1mr1371184oiw.129.1638827922756;
        Mon, 06 Dec 2021 13:58:42 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id bb8sm2953804oib.9.2021.12.06.13.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:58:42 -0800 (PST)
Subject: Re: [PATCH 4.4 00/52] 4.4.294-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cf166d73-357d-fa3c-6092-5ebcdcf7d51b@linuxfoundation.org>
Date:   Mon, 6 Dec 2021 14:58:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 7:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.294 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.294-rc1.gz
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
