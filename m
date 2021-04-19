Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243C0364CF2
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhDSVRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhDSVRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:17:54 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B27AC06174A;
        Mon, 19 Apr 2021 14:17:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso3442701pjs.2;
        Mon, 19 Apr 2021 14:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nZGH/+R2bjGXnYZJJMVfpMliqsozIDJwqDmAJgDa4+Q=;
        b=cJUY8PH0MEF/5la9vCHS8Vusq+6Y8rT0oLEnVVYLwxwxEXFsb4ZFDY/3FqBs4o+h8l
         6ABa4e7heaDnHUVB15ouKscWhkjSZB3PM8bUZbXG9hgqWNwZCJg87hGfm3OS6zSu0vPE
         sSKe7eECAfaWwRQB3+gwAc8Jl3dk1IIEiHiA4E/ejrucaQVWmYvoyCvlVghi+oBNf9VA
         i2ksTvJjx7Ln1785T3guzwzMW2FW6Snch8A5FZRNO14BYD6oQs++30bFhH/QWoaYuZvL
         +0bz1r+AeAr7meFS4dtthn/clyrj9w8v8yIc0jjDhHKp79E+lyCjlNNkZuM+akoHj8yw
         MU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nZGH/+R2bjGXnYZJJMVfpMliqsozIDJwqDmAJgDa4+Q=;
        b=UTnb/KLcsiesxveUXUGWLBq5pM0GPbkcGzlXtmvz7si9Gjh31UdiWWnQ7OhuizRU0E
         QkqmmiELCcE9h/BBH10hPB/3bsz8/7cU42NO7gU+NKBKpvUvqZ2k/oou420tRH2+trGy
         8JQbiRuq4f8HQAQMW3lmnEeTPZHftUZuMzWJgL0Dsa5SoUy1YC5WUtlcUfgZCzDbPHYc
         cHryXzqYWmrGsUivCCDvKKx/xI3XxOVig3UXSZcKYn85CmAlyBTWSPX2ktVgOCv8Ujr9
         3+VJSA4CmR+SCR/uca4Zt7uRb8bLvyUErvc29NtxhZ3qLcpnaufspnQoPAeN5bOAk94G
         9Jwg==
X-Gm-Message-State: AOAM533U4U0CD84PyRH8Ersxo27UH91pMOpyWwfqRD2YcRI0VWs03/nF
        iC8RsNLXpmQTpyvYaltaq+2iHqTmaI8=
X-Google-Smtp-Source: ABdhPJxB3YyxN570vKcD0QotYEMluzAjfKR4Ar8NxhoztRqOvGLebKwlz8jVKhHWE61ipVXAVnYRAw==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr225899pjb.0.1618867043167;
        Mon, 19 Apr 2021 14:17:23 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q13sm13643274pgp.37.2021.04.19.14.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 14:17:22 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/73] 5.4.114-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210419130523.802169214@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <354c9e86-e300-a7f8-622e-b5bbd30ffda1@gmail.com>
Date:   Mon, 19 Apr 2021 14:17:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/19/2021 6:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.114 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
