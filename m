Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB324328AE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJRVBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhJRVBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:01:53 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D815C061745
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:59:42 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r134so17867088iod.11
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JLUcl8p8Hqm8iT+oO9PaiWigqfpfxjhf8KSs3ceuVh8=;
        b=WFGjbecRVNThvQVvL1bWfKE1yS+SM+IRrLljAPxv2Wjym/Hswx2kGL4/JDuxOX57GN
         fSq2+EE11bICEQoyHOlzPTnA7alZOHARAeGcphOMKofgUqRSYIuA2JkVGEd7aPUr81A0
         b1MMusa0SbIszrjeEP0DwbweS22SfVDZf11PI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JLUcl8p8Hqm8iT+oO9PaiWigqfpfxjhf8KSs3ceuVh8=;
        b=WpKeipKpqtl/i3M51rIVWJyP+HTJGTwoYiIb8vYMKBRLzVNSURof76iAhH0LnAWQOf
         ukX+Bt/7iTckNCo96HTeoLT3CljAL6uEEMKRUkLqFNd8UPugC7ImvswU/TSbeiGVdaBy
         KdbmmiWq4CsHz24y0hULF53TGF3W8aMfaR4m67wOfDtnPWVtePYeg4nkqzQZDyr8NX7h
         BUAiow17K5QIhkAvu3aDM6UJA1UBleCnhibIOZ343KO9TFWZIiJ28UC7rRB8cOYwABdE
         +tD3gaSKysINFo4z+ACdnFGn0nZbz+MJv4jiumOeCj/AHHIxzi+1l4NlaYWObHc9bLsY
         HvDw==
X-Gm-Message-State: AOAM530mprq0hjCxw2zAmsJImlcOlettxfcLdQNp3SIm6B8Zrd+TEpeA
        Hx/v79Tugc2amKFf9NAIjy0xYA==
X-Google-Smtp-Source: ABdhPJyfwHUU1IszZM3oawT8H7lX9gLMXBi5u/AzqIgDqI3DmPEVpFZsDzOfuRZCmj2x4NGW4H8L4w==
X-Received: by 2002:a6b:db0d:: with SMTP id t13mr15934449ioc.149.1634590781722;
        Mon, 18 Oct 2021 13:59:41 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c17sm7390257ils.55.2021.10.18.13.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 13:59:41 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/68] 5.4.155-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211018143049.664480980@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4a0d0414-3c39-f460-d37b-816cbff0f48e@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 14:59:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211018143049.664480980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 8:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc2.gz
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
