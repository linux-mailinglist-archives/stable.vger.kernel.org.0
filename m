Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D88A47B615
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhLTXRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhLTXRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:17:16 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0381C06173E
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:17:16 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id l5so8798951ilv.7
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkKTZwjGv+E+2YV3rBBwTInOpGSt9+q6t1w3G1bJ9gg=;
        b=Acu9QfFo0HXk2mgGeTBIWVhBOkeAanSSceZgOopLzOyfUdhI05F87edEgVijU1mVHp
         4mv5mhh06+eLdnk4S7JWwGHXer/+6hil5FnPKTPE4ILMjlJTibIbFNEb89UEmKClJwTh
         FZO4GRJath0ekyPr6Rg3UjQfRIhfATuVTYG6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkKTZwjGv+E+2YV3rBBwTInOpGSt9+q6t1w3G1bJ9gg=;
        b=F4yasI40A01PH5BDyMTcPqBcegnEuRjoyBHN6gy5xWt5NHiuziX05dpMNRED8x/G2B
         SN6/M7efm+azC0x9GYylX5tArP8ZneNqeKs1sNQUnUfb7+XL1SLLnIX4BPJEKt/S68cN
         WJjjKJ5EUeOa99ZtMEDixz7gwnyEIydgFlWl0A2agIRAHkYVQdHZxeJhu7ZZX18vriQS
         ceLnBjhxdn7nZYIb2xg+ZGKOUzBnEzgI+0xODj8os/1RKI/RsoL5RIOwWk/y0Jiu5NbN
         9i5dn9wcQUC2HnU93rhvZIjUalaMLKlbQjDf2Fwss68eP/aipgzeBBbPRfioVKIxHgtc
         kJtQ==
X-Gm-Message-State: AOAM531bKeR1HQbJw5Mao4tKm0kbtgAGDUE//yW5njJAzpCon5Rc9hbk
        s7GHD9JycxC4X8yYjg654oDRGQ==
X-Google-Smtp-Source: ABdhPJx7PTU86F+TTjcgd1/UPrdwyhRVuuK8yIWg724kswzOoEcRNnkmDsSr/DjkpySIoMb/p4w6yQ==
X-Received: by 2002:a05:6e02:12c4:: with SMTP id i4mr143256ilm.201.1640042235976;
        Mon, 20 Dec 2021 15:17:15 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l12sm6686209iow.23.2021.12.20.15.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:17:15 -0800 (PST)
Subject: Re: [PATCH 5.15 000/177] 5.15.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8c321ca0-e160-e3f9-210a-df5c74c9eb3f@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:17:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.11 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
