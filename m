Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF149BF99
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 00:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiAYXfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 18:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiAYXfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 18:35:17 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EF5C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:35:17 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id i1so12215158ils.5
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v5uItbLy2dNckIENJgQr6Gy//H+2b3w8aM/UfSPItD0=;
        b=DOSOSxxSU/iFt1DMzyD9v3XyoqYB3hyn18iZMxKRGmH6L2kVcaq1APN1OLfRQh2bHb
         yVpKEEvdgEw1S3NA8+K5fbJBHfIPE4NQH/lYU+jSIZEFIntW1zDU2LHXcPgnEKtEGA2l
         tMaNbkl64/BHGiDhHIdJLqx0lhSowLCp93WTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5uItbLy2dNckIENJgQr6Gy//H+2b3w8aM/UfSPItD0=;
        b=y2ve+IuIZlq29O8bkmeEne22oEDP6k+xkztabwXyqRF8R+NeiOXaxdI2gNZVHB2c2m
         AQn87Loy36IKe4YP2COPrSuFgiUWJfO3wMWe5NO8hE7McGjrV57ADVPA0MTn+NRuMd7X
         niILLGYhabyN4ce8vuoztvFQ8GJmukELIw1X3ZkGqirp3v4CSENUV+h/5w74A+wb51z+
         /tarr2pIixpVpHhA8aesa2EYncmELfMNd8hc9XKIR0wFBr7HLFx0eDdz9vRc7W2T9+3v
         AKvwuMLXkFu71s73A9zLettc3E1K+0yietOuClyHUoM56Yxm/ag/FpsWUGMbbjVFxGmg
         +Cwg==
X-Gm-Message-State: AOAM531yd7h70+ECJEq2TUuOJlSaiw6iLp2p+wVDHt6I5DbiUKHw9IB1
        HE4obRUEP8O5qq+EeoyTLSE4Uw==
X-Google-Smtp-Source: ABdhPJxWEGnDS1UoX54hiGsITPNXkvNmUT1riGw+sFUOt+f5WIbvq9clOksWzuv82FpVe5vIwa1atQ==
X-Received: by 2002:a05:6e02:1073:: with SMTP id q19mr12839539ilj.49.1643153716896;
        Tue, 25 Jan 2022 15:35:16 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:4ef8:d404:554b:9671? ([2601:282:8200:4c:4ef8:d404:554b:9671])
        by smtp.gmail.com with ESMTPSA id a6sm716492ilk.6.2022.01.25.15.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:35:16 -0800 (PST)
Subject: Re: [PATCH 5.4 000/316] 5.4.174-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220125155315.237374794@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <382fe443-eb06-8eb6-d104-a59bb090b088@linuxfoundation.org>
Date:   Tue, 25 Jan 2022 16:35:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220125155315.237374794@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 9:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc2.gz
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
