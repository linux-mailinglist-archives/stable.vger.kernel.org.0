Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D91445C17
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 23:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhKDWZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 18:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhKDWZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 18:25:35 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C3AC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 15:22:56 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y73so8686769iof.4
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 15:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c9bAOOnl9NNdQEJ5ZvJD4+B0PzGqd9dO3fVJ9g3jpGg=;
        b=XFsfHbgvM1babk1FYIVBbuBtlPZ+F4b4lf5uk6fOwt9XVjqsWJK7jhJUMzxcSFNi22
         w+gdp/Y32L2KydsUhcPUBkrmFbVv2Bht3GWmAnUGlDq5aCtvNHz99gkMNGz/SgI/tRsc
         nLTQ8lgl5c1XFRWZVH7AyIVqQpnSq4URv6AeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c9bAOOnl9NNdQEJ5ZvJD4+B0PzGqd9dO3fVJ9g3jpGg=;
        b=nqBrBH8QFk+WDJMro4FF5zP91lGFSMHV7atEbq7OzF7eLhuJh1L1rrU9RXXtTCNUkb
         ffG5yLMt388fXefMOdTQRrD+uJAmzaBMg4EfbB+B8XHk5EfPcKa5ak2dzj1tbarXNThf
         Pmy0uRQaZdO+JuJ9Y5qfD+U/I4w350VBQYGAnc3LLH624ZyfEjDPOhdwciwDuGYBW0Pt
         wQ3QuDyISrqTJWmxFSBu0fwfYfOvs+tgDp4P7x/nqUFRb14VeaiMTMaZbt/eFRjkPNb6
         nk7i7OmcepOQHCl52YyrvgtAz67a+zrKQHKTFhnmr29mnsdaYNEgMugMsp8wUEsEHz8A
         AB4w==
X-Gm-Message-State: AOAM5312qWZn9khS00k3aFGhHI6lIeDTpPQbUZYeTnEtQLUMPp1lcGG5
        czANcSaCyCjeZq7L5UphVx/BdA==
X-Google-Smtp-Source: ABdhPJyoit5q/PKjLuTdxalq8GBVmBt8nHUL7kkUuydhUbJkxo4VZrJLbcZrRDmwsO0e/WFC1EOuTg==
X-Received: by 2002:a02:bb0d:: with SMTP id y13mr5715542jan.139.1636064576095;
        Thu, 04 Nov 2021 15:22:56 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s12sm3093358iol.30.2021.11.04.15.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 15:22:55 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/9] 5.4.158-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211104141158.384397574@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <51281478-0f3e-94e5-484c-5251b00349fe@linuxfoundation.org>
Date:   Thu, 4 Nov 2021 16:22:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.158 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
