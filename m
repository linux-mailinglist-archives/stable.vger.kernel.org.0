Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB31453AF0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhKPUbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhKPUbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 15:31:18 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DBDC061570;
        Tue, 16 Nov 2021 12:28:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 200so214055pga.1;
        Tue, 16 Nov 2021 12:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MM08HeeM0WW4wvSJTAanSXHVRaCn/t8mr2R+iHSWSFE=;
        b=d5mThjLxudqSgPWDZBGvkI8jk7XN2GsLcJE8FB7Gq/1n16MmfiXn5bc+dcsRpyFocV
         M3G2HeTCKtGnkeEYZRLs175z9yuuuDg9waVcjNmUSffcx7eGkSUpzgvUQMoTDoGbZ6Hg
         rXEgqVjH8rnKiv2cf1nj3Ve3CDSKSOj4eW7urHnNnZ1h1SN5/pfa4LZXVn3tT/75BkBq
         IxN3s9vRQEip+8ACENZYZOZQxW70EX2dnsG6ilRa22BEoOjxfvH4KsxaZA+uUF/ARcZ1
         BylbohwAgQQddA1e20qMRfoj1K+q5gUQbaTcMW0m1co+WQsvoMkoEvew5VgOYjqVSdbF
         Bs5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MM08HeeM0WW4wvSJTAanSXHVRaCn/t8mr2R+iHSWSFE=;
        b=wWNwXjIdL3dhI3j92/Ezo0rgfTvEhxZJGqaKzcvxVkbcup7xuDNjwEUG3nTx2vn69K
         Dx4jqrGOiYCyVlpYNIoCFv0HSxzRgitHPjlnBz0pga5zHLA7toOaMETHIJpSY1mJINdG
         YbAnan6wHe2poiVaC8viXwSXtWOxzN2QHAzy3LooNgEnjXhHxafPnI2dxl1mEVH7uCEl
         7jSluX9rRA9XX0RIiOimWoiQKwd/6NQgUaUDDEfPLHom+EijjMOhgCnjFvsUS1Y7Gb38
         CBEyqZFQEHQbllqYNGsvNBdsjZxuiZL/SfVl+bYeRpTGXBxGKjB8+5/H5LsoQO088BKx
         kaiw==
X-Gm-Message-State: AOAM531vW4kLGvp4iBNb1HwztSMjjih4Oykmz/p7WRXvku414G4teSnC
        YcM0tT7JPMd9exzJnV3BxZZ0OXGuHEI=
X-Google-Smtp-Source: ABdhPJxfW3oRAXFdjkuiWVh8054XccX7yiDtLDHSnYVQg2j19VQrbACL5jWo47qfaj3HdfqP+1VBFg==
X-Received: by 2002:a65:40c2:: with SMTP id u2mr1222840pgp.309.1637094500146;
        Tue, 16 Nov 2021 12:28:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k5sm2573729pgt.49.2021.11.16.12.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:28:19 -0800 (PST)
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211116142631.571909964@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d74d7fbf-a6bf-045e-b3ed-46ed37025f79@gmail.com>
Date:   Tue, 16 Nov 2021 12:28:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
