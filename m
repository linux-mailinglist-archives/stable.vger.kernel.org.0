Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440543AF61B
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 21:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFUT3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 15:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFUT3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 15:29:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9986C061574;
        Mon, 21 Jun 2021 12:26:47 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id k6so14425244pfk.12;
        Mon, 21 Jun 2021 12:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9l6rg8q9d5JzpEsVprXSFzoUPa7OMMNvgwRpIscpeIU=;
        b=eZHjNrqWEq3GaUzqaj3NwBv0ZIInmrlqZbmSRImmeFTd+r0Ht9VoI57xP24fcXjgxI
         Za3HQKyDIaukoq/3vjWNLBdPCMGY2tosTbADTagoz+R9BIanyJyYVa/VQVBAxWNJ5noG
         jNtEdUMiJAjgjRa9izWkC378RDO4VOx0QcoGydGAm5w6mlq5BEYO4+aRiOgWRR86pPts
         D9D76ftqpTpGs2/ZdLMJwyh7cHiz0o+GALn2m0f5CY51mdodpKvDLPDV4RFMOQUJ4EcW
         32dgdwnXX592ZI0T5nYRZfzzXTA+s+8JIjOb0RcrTxAsBLZe1+sEaVzHRJ2nyVQ01YZH
         hCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9l6rg8q9d5JzpEsVprXSFzoUPa7OMMNvgwRpIscpeIU=;
        b=JA8FyVFxVReOxpp59pbcjL6KoHghc3SxnfjxqQrKFKBOU3z89G8eLjiU2ptM2gf4B0
         PWQ1D1V9bGLn1Ep/pYSz3ghE+09oj8AfvAchTx0zI4cQT4o7n13ljhiLRuFY030XrT/6
         Yb1EypSP8DR2N4yD0KL5uf9BT6FCGuKa/d61N8bIe5LXU9YgtiVCqf6rnDtT5GazqD+F
         YKIVtY5XwnciVprQYkNW/enMTX81ooExnZNWWF+bMfocPOK6C7rRTzza8mat74hwXK7p
         u6868IWkCOySHNgqK7tLddJMDaPv/mIUG+FJ/eVycRg+gHInUjP2FwJLpODhMQg/Td1R
         Gr8Q==
X-Gm-Message-State: AOAM532YflWRHyGo0CdOjiZIgf4kgQ/pjSukvGA1LGIhPKZK4etc49Y4
        sS+iLfRmcX2jS5o7bEvJIZc6qc9hhyU=
X-Google-Smtp-Source: ABdhPJyd6ytocvUJ7rZoeTppBHik0jE5q+m8uHe/XOMZ8JM9uqiSdKr0mpG7XVYb33XrgccKB0JMoA==
X-Received: by 2002:a65:584c:: with SMTP id s12mr76404pgr.309.1624303607075;
        Mon, 21 Jun 2021 12:26:47 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9sm18185pjx.13.2021.06.21.12.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 12:26:46 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210621154911.244649123@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11f42c64-2e8b-9b22-2564-a6a1fa27d57b@gmail.com>
Date:   Mon, 21 Jun 2021 12:26:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 9:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
