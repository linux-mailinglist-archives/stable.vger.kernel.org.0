Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACA6344F12
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 19:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhCVSuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhCVSuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 14:50:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEF3C061574;
        Mon, 22 Mar 2021 11:50:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e33so9247665pgm.13;
        Mon, 22 Mar 2021 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=spKaPRG7iOmLzAUB6je6o6gX4eqaT8kjVDB+IMEVQ0Q=;
        b=V7u2H7sYkaHcgWoK4gspoi0nCKDEJuPSit/RSI0MY5NXy9w4O6eCCdUvzoTpRRdMxw
         pF8laUfLP3T1AxinpW+WK7gzHVIrdp5MKdFCw2tfwxdEqZstM9M2S7mLFC0VumMMJRvT
         dSAc0txqKdoO5U7mGeJmELfJ+jwJNv+brn/L9xWA5m01PXSmZPA67UQbuM+bxwZ+LACk
         XaszW9kAAeO904KZGRPzpxQVJLZbhSlB4PMt2Nt2Qlvd8OJQDWze0d7OkqfKl+QRRFFY
         6Qpem/GJh0CLVGd31h3EV78tK7uem+f2DPnA1ZLd3+58V93aklBVmb5S4u5KmyYRECyx
         vUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=spKaPRG7iOmLzAUB6je6o6gX4eqaT8kjVDB+IMEVQ0Q=;
        b=gMOcymr1ZgOuW1V1WnP8ekJujEc8bSIeRaYF8e3sQ8IaDpE0lpYQCmEFEzT5zA8Z94
         OrLlcaFvDthpYKP9A2fvBP1VhvcxMsCV+Ngzdxg12ScFt7HN8ftRsG26+aYzMmzXVAh4
         w9rtoE1c1FWYANr3URf799RQZYdo4si+oIWXkeJW+YHuihhKw6jgfCiAa7c6LUVwnqSZ
         gutUPGZBMv+2onBN86jAgE6GsWhuuxU6GvuQFLUdhSajz8N2jYViTxmTWOmJKeHo4cZp
         U52Zpw307p2kH7j/91flCDotiumyFAaTRDSjV0m6QzE1og4Fx0/SZX1Bc/3QbIaXoGtl
         z3sg==
X-Gm-Message-State: AOAM531elRwT/WJeDhywk2RZO1CoAjrzwuUNh29LOoUihuHA7Tkkj5rg
        jzY6q5mOhES4A2MUA8pqawyVFP/KO8w=
X-Google-Smtp-Source: ABdhPJxSXHngCTvHJ5/G7nnKH66ax9qQr13Glij5x+I8H3lvgoQCBEMO+JUGznxFllTBw+7UdfECLw==
X-Received: by 2002:a17:902:f68c:b029:e5:ca30:8657 with SMTP id l12-20020a170902f68cb02900e5ca308657mr956968plg.78.1616439015001;
        Mon, 22 Mar 2021 11:50:15 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 192sm14829205pfa.122.2021.03.22.11.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 11:50:14 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210322151845.637893645@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a076a64c-6da8-e25d-98b9-3666ce957862@gmail.com>
Date:   Mon, 22 Mar 2021 11:50:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322151845.637893645@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/22/2021 8:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc2.gz
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
