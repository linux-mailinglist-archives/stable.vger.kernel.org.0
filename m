Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8DC3AA6B0
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhFPWmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhFPWmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:42:22 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337C8C061574;
        Wed, 16 Jun 2021 15:40:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x22so351207pll.11;
        Wed, 16 Jun 2021 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=167NdGo7hmLGcseOsLWm0OWWXPQ1w4fQkJN5dg3sDyg=;
        b=GYnxZgSXFs+lGjHM8tQJZ/UMKOa6WOvDIueimC0NPhX7kbYe6e6EkXWNGb3LMMPXtc
         G843P2zk4QbH7EbcTi+xIpBWqsEDkgzwQb2X0vH1CnKF1Gw/D2GQRuYdaYJ+EcCfU8kD
         +noVwIJ9qMD+cT1s/KTyi/ZfL9Qzntt13qglpg6YMqP0p8tMhE9NLvVr/nUwkYqmSa02
         IVX+0h/XwCmKNhTsADzh9E0l1W2tdcECOyc/+vsJuphAi39EK6FImT+cWGATIY2io8XM
         o4CMe+iTJabaVZutQFLkRj9Y9V5PJ099eEOX30Utxp3BSYImRT252LQajB+3KxSbRQvA
         Qqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=167NdGo7hmLGcseOsLWm0OWWXPQ1w4fQkJN5dg3sDyg=;
        b=kWYhzq3kMSjT1gAximldfE/aiMyZMtv/VJtfP36T/WrL9E38qO3JU4QsWzwM8HlrIk
         /fHeCN3BKmXjbK4uPVTRsZ1YX8aNTjlWPMj+PZD3nM/PcydkqnxcdAYW2rG4XmIMI/9Q
         cQCJmUkIwbeG8lTxbOLrAOlfu9Guw2Qt2/4AyMAXc3LwxdHOpl8j0HoxO6sTk4DSsVkA
         kHPiOiRnFAysbwx47AQp8czxrNMr4UQ2Rco1dKV/9ARRoXtIMrs1YDm2T8HQdkN5Ne4F
         C9/MuMqPpD4ruu1vnFaUrYbQD8JJ7BY9IMxhSGqcNs20whf5YTg9JZCahp7YbTPLwqvO
         qR5g==
X-Gm-Message-State: AOAM532oBDHYezKGWr2Se40zD3qA/ATgzUkCSoPz7uCkwR09rPEJy0qr
        QP9KN7y7vYjOnmZpIqGEmpF0U4RJR+8=
X-Google-Smtp-Source: ABdhPJyExffEZ3VPvQts7/O0ih9mif1nfcY0MMWOZ4XAEcCF7MQsHKamPx86heKr2wcYRcD6sJQtoA==
X-Received: by 2002:a17:902:74cb:b029:116:a305:62bf with SMTP id f11-20020a17090274cbb0290116a30562bfmr1736878plt.78.1623883214301;
        Wed, 16 Jun 2021 15:40:14 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x4sm3108302pfc.150.2021.06.16.15.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 15:40:13 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/38] 5.10.45-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210616152835.407925718@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <83f68b49-315e-c50f-2b61-be4bf0101e32@gmail.com>
Date:   Wed, 16 Jun 2021 15:40:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/16/2021 8:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
