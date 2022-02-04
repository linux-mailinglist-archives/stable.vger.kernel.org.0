Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE724A9EC1
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 19:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiBDSPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 13:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiBDSPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 13:15:25 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEFFC061714;
        Fri,  4 Feb 2022 10:15:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k17so5866838plk.0;
        Fri, 04 Feb 2022 10:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KL1xeRlYrEyKiQpWUpJFu1HEcEQuRgRLLu/ees9x/jY=;
        b=B6qbq0LSmC+RnYxT47RXfAuOrHQrre5oUmy/S4/JW/3XjTjQIMcyMo8I1jO/d7ygsO
         AeWH8bd52LINCdTlzUC29gwhdj6EhNMXqS77OrNefl/7kfuBGBZjd9JZQ1gc5hPQnfcZ
         ExOMH7tEUvPR5VwrgR1tdR7GDSV+3l6M2xAFWruj+XaBiHgsdob4IinDFidoX1s9R6RP
         ZSar+NQjod98XsF5CC9yoHu8uKfYZJscBmLR0KTqS4xPjuYWKkpsqWCfkRABRAQ6J/BB
         OdcZXkvoV41Q+2XiclshyUSlJCSSby5GTk9ost2ZTdFABawSqZK/CszuJwO6U95soqDl
         oZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KL1xeRlYrEyKiQpWUpJFu1HEcEQuRgRLLu/ees9x/jY=;
        b=Jz8163+t9jrrn0iu3MUZDkZ4ZSjs15kY2GygZC+DRsHRnWFCI26DfvG2d1jQSSNhOh
         jLvOd9Vc8LavjoYY8zlMtfdmq5MlhwJc51NhQ5BJcG7jodFBurQ9mejCVp1leDOU94cm
         sB7yw3KI5FVrYESV2kdmkaiIO38C5cPpD2oMtSMLioDz8mGf8kd1hdFzQ5n6QlgtUxl5
         6BrhMM7DpfRdi9SVddvB2GADdxXGXYa1X5j+E34KCuSzDjEhPrrG00OaHXtb9s5v8BWI
         HVGjie8bHepUgi/1LT0k1kcheo2dS6i6WqtkAegWF6lIhVX2I4hF4NfIO2+jrJVgWXKy
         vqHg==
X-Gm-Message-State: AOAM530gSA6sBjwQ83uljzffJhEKYrAyA0zjO5MJDHi2PJ3b7Zo3ybeX
        wlgKZCOhwhyou62ojxmbSSY=
X-Google-Smtp-Source: ABdhPJzIZ3jxWQrH3knxOOrWNP8PQG/02Mw+Qr6RiUwKBk5cCpTdFpMmFYqYjRnYu5sy4b+xwl1cQA==
X-Received: by 2002:a17:902:ea08:: with SMTP id s8mr4522469plg.95.1643998524554;
        Fri, 04 Feb 2022 10:15:24 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id md18sm2754165pjb.9.2022.02.04.10.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 10:15:24 -0800 (PST)
Message-ID: <dec345c8-24de-55e9-09ac-b1da3f5f68b1@gmail.com>
Date:   Fri, 4 Feb 2022 10:15:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220204091917.166033635@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/4/2022 1:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
