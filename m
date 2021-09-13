Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CFF409AB2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhIMReK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbhIMReK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:34:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8209DC061574;
        Mon, 13 Sep 2021 10:32:54 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f65so9519602pfb.10;
        Mon, 13 Sep 2021 10:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=7hvNpGBwPO+Az8BZhVNmi7/8xqiNXdXyDIhTpZcUsFc=;
        b=QVEKEDy2tEFcufZMnGR8xpHQYRt1ADgg2D4ZeBZcUHNaZSv9DrjsNuY9l1wN5F6YWz
         8Urs3AcMayBmO78lQRiP+8ruVSOv1pKCKejhngHGQ1LNgGMP22+u+qAhRKgpnJVWArSj
         3wozxLyMfQqv9zmZhM19z5t8A71Ars5PNTEx16InAxdLZLdL59S8R0QwTl1AqHJnM2CJ
         87zULw3DxeXkQLtN53enTz+Os9PvZ1PXSDJp4W5MQsZgnR55h07tVMegeY12wLLjG+b3
         jeYuEI/5dz44lN6P0csdVrby1Jr8XbkGwCHdYG7bNdi8gFduRHAtPxwtUQclD7pCjdli
         DyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=7hvNpGBwPO+Az8BZhVNmi7/8xqiNXdXyDIhTpZcUsFc=;
        b=cSrqY0GF5xBpGl/zNl9fou6eTXXWnBd7dg8SeeZH6ONV9iv/DMn8uwFmpyASSAvYFs
         2zixtTkYDrWq+lU5jVJJnbEKgN6AvTsvn77zqOlx5UFmKSFMqu1dCqybvYi76k88nIMe
         wBRoKNeyTxn3VSOSqz6wpc2M4BHGokMArX0A9CsUv1Qxg/3PcFJ2u2Xf6OV2zGwjHhKd
         i5LEt4uRbLEBIXbRShANPkMzM6/bsBFLuhQmbvswJ8+n1jQyKoSoknKagJq7pQUS4FMQ
         ERCreO8W3cp5/38TOrsEcZKicErFN8junrnl/tAXWduXpt30DN1ZwlZQ1NW8rq5+Nnjj
         o4ww==
X-Gm-Message-State: AOAM532TuDVFUrSYIPjGSlxf4lGZ03CASr1+EtY5y+PZ1CooXnRCL4cX
        RXFN/Er7eeNEayqT9FJax0JgKKTeGYw=
X-Google-Smtp-Source: ABdhPJxbDzYYc5ZWgSx1M7eLr3WEyO0mdNwo7qEOr7muhYV3+BRnV5xiMqsfS0VesLaFAx0AT5iqoQ==
X-Received: by 2002:a05:6a00:787:b0:405:700b:69ce with SMTP id g7-20020a056a00078700b00405700b69cemr630522pfu.50.1631554373957;
        Mon, 13 Sep 2021 10:32:53 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id c133sm7738037pfb.39.2021.09.13.10.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:32:53 -0700 (PDT)
Message-ID: <bb5ef571-fdda-f5e3-952e-6ba424de969b@gmail.com>
Date:   Mon, 13 Sep 2021 10:32:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210913131100.316353015@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/13/2021 6:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
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

