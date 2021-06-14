Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F123A6EF1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhFNT2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbhFNT2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:28:43 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59E6C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:26:39 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id k21-20020a4a2a150000b029024955603642so2916083oof.8
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bbqqsqw7O7e5a2YkESptEdi5Nub7IA78eU9ImFG+KU4=;
        b=fCXINgSa+WiMwxMluAC/NJbOz+Ogyx/hM28S0WBW6NOWHqx7zXcnfd432PO+Un/7jz
         iA0KXNL9qkrYPblbpDXbPRmAPhIOE4Pxtj344VpwaaLEwrAkieGdwL7XSZ3hegGdHy0h
         dVAUsPeKt4VIcAh2+ktAHAP+hk0y8d/P3XfQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bbqqsqw7O7e5a2YkESptEdi5Nub7IA78eU9ImFG+KU4=;
        b=CRGeneC3g7ORxhFFGRWSyHe1Ma7MGGo19youukF8quMk8WrLHcM5su5JgKNBGbtbhf
         1WIGnUYQKpniOkAEcS1gw0hYkuSL5JItbc6LlRC44r+sLHav3YhKwAI0Tb5RGnyVW4T/
         L6m4TaEmWcLTHoHacvX5G1O1okKVuMDNBrRjbm2GOrQUjH69vXPiDmF6myzLQEViuNyF
         64KWWjBBgtCI/3W6MVcXA8+oU569BRRw2EAwdv7cCsPBkXgA1DSG0ozxbaBM1TguUQM3
         RgXk9LS9CtsHifhkYREVGAOQfbvKNI8sZ9WHtkrIXSG2EdlIH6P+ZkSs/E+Hs618zJcw
         5fEA==
X-Gm-Message-State: AOAM530DkSXbbXdb/yUN2++5HS6O5fRT1ErsizP/TZNhbLaMAOx0XJzq
        748QNvKprLXWEK6G5QtkPWK9Sw==
X-Google-Smtp-Source: ABdhPJysbH4C13m3a4dmwNlSuHZh8tAuonnH3Y8nHj+wuXWgTBsZG3NWJGZPOYYBtCSkjmzXYn782g==
X-Received: by 2002:a4a:8802:: with SMTP id d2mr12358985ooi.28.1623698799317;
        Mon, 14 Jun 2021 12:26:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b22sm2832493oov.31.2021.06.14.12.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:26:38 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/173] 5.12.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c63fbc15-a90e-d033-5879-084db3c313cb@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 13:26:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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

