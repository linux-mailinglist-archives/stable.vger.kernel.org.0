Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D07646A540
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 19:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhLFTAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbhLFTAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:00:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035B5C061746;
        Mon,  6 Dec 2021 10:57:23 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 137so11385931pgg.3;
        Mon, 06 Dec 2021 10:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bfzyvS1ix/DTBqjMqEY2OsdvRUE5E4TG0ClFeP5PeYU=;
        b=Wtpe4qCBuEBbnH0an2/woxt3OxrFQ7b3Lr6U43ig6+gR/IMQy1LpLmwxiCjMeQteZM
         A3RgwkRllq7ujszuNiPZN+WbhktUdb7dzKMBQPUvNyaQVdEWhlekgIU6xOsUweOeu9K7
         aAudFKSvCAGuA3nBDo+7gBV95CS8aATaeHwOj/eDgAXMeQrJGYTcGH2OtF/Qb9yXT8aj
         rEWG9wxCoBt1P0ny99wSOXbQ6HFmEaqk8ZW5uMT71seXnFNkFDfuhUARD4GDK8uFPgGU
         nOQqDTk+hWIkicj/y0db1qinrAIOpChhjuKSvLvwCoL/AcFm+BCcy78bmSHLvmQRuUWC
         QZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bfzyvS1ix/DTBqjMqEY2OsdvRUE5E4TG0ClFeP5PeYU=;
        b=5cX6C56zlgYmwkr01lr4GjKln/SzQZMA5uh7mgIGGtIU36RXdP97TMkvuvge6MZfjN
         gPHMNsiqxwLRZowYAlWFqTfBaVX5q2eQe90bLRmIn2FpgMD/GHX92iI+fz8cT3li+7Vq
         1EVrPCI2VMo8JhqzNIw8HFu62BvNHanKuAwQBvy5YC6XzHcYVjGW9nGensYlDWkVTQru
         wEAl5dzYHbx5P+QYQZEweLdof4g8waJmkqDP0DSszRgf6HeEt5wFi2NvH1axUVUOkHGT
         9J8WRkab9RY+cM0IrojlTXBZB5hz8P8Wy5+JZwjamm+Rhp05x+8jm9fGxaXF/kgzXW/D
         y7mA==
X-Gm-Message-State: AOAM530S3jPUeM3pKOb3VEU4pc5TpXlHlbw39Yq84/cDcDS6Ci8JwNiF
        zLDv8XlXMB2s9xCMJGbZXUDV8f49vuE=
X-Google-Smtp-Source: ABdhPJyZVAnm5LwwW2YSyXH3tkpTtCbN/OOU9BH5vguD8AtzoDddhXQi8BxDJIR97TGdns49jYJxjg==
X-Received: by 2002:a63:9:: with SMTP id 9mr20120442pga.91.1638817042140;
        Mon, 06 Dec 2021 10:57:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b16sm4291197pgi.36.2021.12.06.10.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 10:57:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/70] 5.4.164-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211206145551.909846023@linuxfoundation.org>
Message-ID: <b4fd2b8c-cc44-ff11-2588-1d7a32155d84@gmail.com>
Date:   Mon, 6 Dec 2021 10:57:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 6:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.164 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
