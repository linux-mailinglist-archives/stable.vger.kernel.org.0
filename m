Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716E5489FBB
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbiAJS6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 13:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240453AbiAJS6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 13:58:45 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB813C06173F;
        Mon, 10 Jan 2022 10:58:44 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso1308067pjg.4;
        Mon, 10 Jan 2022 10:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wF3SgCv1cIoLJ6rY9JoBRgFUWRC1J+ruObbhJIkZHtA=;
        b=UVLUNeoM2W7xW3dpXsiLkNJJ2avfx2WyYxh6HWSzeKspVr2DTfNjvWVEQh/iPjhG5b
         8bs05Idpdazomh42XNUrjOutx4LZWc4wkA5kxl+5TOiw3odaAYnvgvlKtBxu2eAEUlVw
         572Zs4reSJe7PR9gMlmhHdwGVPYTfyaoLRqfsqgNnEfLHgXIorne6BFHhgt6VVxzrjFQ
         2Fy+IAvFgLQrhlrXsI75EUvEgxvNf7ZeGhKzVaTp7Ku8FmHPpurQg7KM7uyU4U4yHaPI
         Q2OX2+If2cI1pgZ0UE33+kvxSJjSem0R40XyFPb2Rjd9Flik5ZtD30Tnl5YoO6W3ETlB
         6J6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wF3SgCv1cIoLJ6rY9JoBRgFUWRC1J+ruObbhJIkZHtA=;
        b=Ab7vHU5lczSud4UHXRgI2BSxIap/ipQq83PeyPIhNuyY/wol8tyOHVuZgB7sqPWddP
         WPSfje5mxnuWE9VAQxCr26N0BJVrbqUzHoYh4VPfYAq6giqW/iXnsRlwzZw22+nLs0EF
         GcV038nAD4ljiQeCOZrH2Sfu/UfF7HQiWvL1ABsbesn5xDblmNzGClRk+vyXwlZmcIFV
         IpfgJ6luz3TGbLaVq9iaGN509xVoF1CUggFjTzsgmoOzecMwDu61zW1gccrEzQd3qFWf
         VVU8dFTEZn57cyB7iE/r/QXEHgBDteSZqtKOAHnDV/DUF/S35VFxk46ltI66dTGB4Rtc
         wyPQ==
X-Gm-Message-State: AOAM530WU8rrpXCKo7uMX8pSjRaDZSKVjeYqq0KDg6n2snQ8Foqm4MZ8
        ino98SZ5xeVM8ab4G77/31NPZtaJmFw=
X-Google-Smtp-Source: ABdhPJyqHcRlnfhq83v2mll8oVHVcLVaTUcLK5qAmyYV99QUZSJ0iAscUYIKCLLyekdF3FBNinXFNg==
X-Received: by 2002:a63:7f4d:: with SMTP id p13mr920574pgn.29.1641841123992;
        Mon, 10 Jan 2022 10:58:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a1sm7943862pfv.99.2022.01.10.10.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 10:58:43 -0800 (PST)
Subject: Re: [PATCH 4.9 00/21] 4.9.297-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220110071812.806606886@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <15bc6df1-129b-dbba-a365-e99aa273fcaf@gmail.com>
Date:   Mon, 10 Jan 2022 10:58:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/22 11:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.297 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.297-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
