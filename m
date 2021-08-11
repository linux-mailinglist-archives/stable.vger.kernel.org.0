Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6043E9AD6
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 00:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhHKWVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 18:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbhHKWVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 18:21:02 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE61C061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:20:38 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so5285413otl.1
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aa5xJRw1QAPbyZ/ewtMuNqZfuZMoN2uMDlkGv7HDM2M=;
        b=D/3OYhFA0l+yYIFmZvk9DbrhT950ye/RVqhsbTW7ILaQtsW2jqO4i2nFrO4ZYpGSRn
         xOpL74L6UGA94deZVuhiz3yJnPKRqoLYB58bDrayqyWNtPIKwLPBkPJ+QQoPO5CYhMsJ
         IANsJOlpCC2xRvi2HA8nfvauLJVCCOIGjfd/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aa5xJRw1QAPbyZ/ewtMuNqZfuZMoN2uMDlkGv7HDM2M=;
        b=KuUEo6hoRdh0R5FFPJoyrWcrlnKlX8hkVoprQ4hI9+3NzKcAZIutNW0G0hWimr67mx
         yP4JGE72vj3gVzQw+RmljTxuqVISvaDHzSY6Z5ibB3Pp/40e6YUno/rYBZwrcXSc+iV4
         mkiF6JxWDLBLEddEFizwUukv7j7P2dxRZfcGtAYbaSeing0aO8hN0/3S+dFIixWPRqZJ
         61fIS3YRw+7703b5xPL7VbK+xD3FHp9ht1b1uXlg4Ek+/myj6Kv/l0Y4+K3je5Sh4a+k
         /i9EXidvFZXnfCTuE1kly2C+Zuum7W8pVgz2RQFknLMKppkGdFQBa4sfncA2NVHdN34z
         7wNg==
X-Gm-Message-State: AOAM5300PEqb3ta8gOaJqIcxkyL1+ZI1RH29rK76sQraLM2AWWYusSBb
        M7fMe25h8t2E0GTavO3zhZQLVwxYxvIVlg==
X-Google-Smtp-Source: ABdhPJwzeQo6SSGMV9d/qMDULl9DGYIjVHyKsolX0R8n/9l/JcLvQXbmSgKJeEKgCyIXz3dF5nPRQw==
X-Received: by 2002:a05:6830:40c2:: with SMTP id h2mr946160otu.56.1628720438130;
        Wed, 11 Aug 2021 15:20:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l67sm204669otl.3.2021.08.11.15.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 15:20:37 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/175] 5.13.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c7085eda-4ab7-3e48-575b-c21c95381752@linuxfoundation.org>
Date:   Wed, 11 Aug 2021 16:20:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/21 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
