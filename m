Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0819364EF6
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 02:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhDTAJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 20:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhDTAJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 20:09:11 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E28BC061763
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 17:08:39 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b9so6958846iod.13
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 17:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yfflnTcBAf3hap17KSPMtzJsiq+2OM5h/mj1jR5RjV0=;
        b=CogEjtJOeXNcjegOTgn7luG/GxSl6aA6ztKEmPo2yEYR2xgDo8s1JoPrDgvoqkXqSh
         hhTXQE1UaMsQkYQ76H5wLVH+Ys/aeyhnBH9XNNzh/1feQIFuwP4F4zto4ZFLJ+x2LoHI
         fUvy8GpThB633pRQ1ofmXSMCjwxSP9v4aP6NA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yfflnTcBAf3hap17KSPMtzJsiq+2OM5h/mj1jR5RjV0=;
        b=RiF/CxyjZQSGXTXJIPRWsq+hjsBK1c6HCmWeDKxlcXZREB2vUDnxuWSHJCN9PvWrrR
         eUOvOXBfkfNgIu+RGT8iJKeAFUhj0nXilkPbaLSKCGKdEoM8j1yuLHjUAoz6MGWYACnB
         lRqZalIIn1Nw3e/fYE9NuWsTX+pn+xFZPNMYgCH7cmuD4ntTKr0KHhg7YuJ+K7chzNDy
         SkNQ1joyFQhorHSgsQ3UuTptsOs5+xHILoJwAbKsGRFxPpFP8ACygz4ncuM7qjWPunP+
         iDyNMAocV6ntRUCxNQce1P0s2cN0j65+u7pgQAH2YXxo0wnp9Qd/8f6JYMg9JoHmJBS5
         0P5g==
X-Gm-Message-State: AOAM533dWBvZH3j729am2OxohA53mzHRZJb2OzN0xWjqqOlGQ/7S+6Qr
        9FB4FlFTrOfiNx3pT/yyWPl+HQ==
X-Google-Smtp-Source: ABdhPJxYTv4/6SJWUNtHroJyZT3JKXoC08xAcoho55X0gsIp56lvmtVaKyM6mBWyC7ZfbkfnOF0OiQ==
X-Received: by 2002:a02:340c:: with SMTP id x12mr2589978jae.64.1618877318926;
        Mon, 19 Apr 2021 17:08:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k17sm7626810ioa.44.2021.04.19.17.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 17:08:37 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0b9f7979-e72f-490e-6aaa-f0085846f294@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 18:08:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/21 7:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
