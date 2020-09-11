Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE3B2675EC
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 00:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgIKWcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 18:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgIKWbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 18:31:55 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6132C061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:31:52 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i17so10954050oig.10
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KcL7Atn1TT0RHvb3HOyYFB2hEM1Jyfn2XyvB0Ephdq8=;
        b=BDfXMnBFfWwdXqDx+C+4miLuLmx4sKVOhZWq3vCSvEpwLti6YkZCLlhedFymyARKi2
         TLMHc0Y0HvgK/HjADCIFxLns/nPNYEbuR/sE2YtCXwWm8bH5v4B1qfvso/4717IuLMMZ
         hqRLGm1sPgplysMrV4syFJc5/H+2yRYMGq7zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KcL7Atn1TT0RHvb3HOyYFB2hEM1Jyfn2XyvB0Ephdq8=;
        b=APrFJeH6xbfqNjaZOoAn5Vvx76Tw0reihUAP/yvvDuBuHj3bBGVWFKS0xumR610j1Y
         cwzjleMPpNv3o++iPE3Hnap6qpieBo/jUo0d0Jg/s1blvUItWjfXXaAvBm+QyCz8JYnS
         MzU6atQ9XvFNevv2azhgEWSfvx3teDSh7TZb185fY4I8YZSDv76Vv59HZKeZZ04U73jK
         q9YrV0BoWBKJWt668gQqN88vNcZEh3Xr1xCGk+Puxx4+VkY9ac11TYnDj3Kc25skdzuo
         pSBgcm0WTTTFGZ+cFoWr+cCKsKrk+8SIlQX03V78kHB5+G9gpD5mcSGLQYqKDaBtucIU
         b3iw==
X-Gm-Message-State: AOAM532NH7WrQ1KESTG4pIDwtIA3a+FZv+KgypIrMLSh2OEmM4OeLLGE
        gyvSGaDYkV2IxTwaIBHHNXoiXw==
X-Google-Smtp-Source: ABdhPJy/gNm6TmsGJ0uH9pKpKLm+koQVS9S24cWyuOqkxLchmOgPKp0tnUdWy0g1gIEKMfbpMn5SMA==
X-Received: by 2002:aca:da06:: with SMTP id r6mr2575457oig.88.1599863512325;
        Fri, 11 Sep 2020 15:31:52 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z5sm572813otp.16.2020.09.11.15.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:31:51 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/71] 4.9.236-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7ea50854-1513-015c-6b47-f74026068709@linuxfoundation.org>
Date:   Fri, 11 Sep 2020 16:31:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/20 6:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.236 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.236-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

