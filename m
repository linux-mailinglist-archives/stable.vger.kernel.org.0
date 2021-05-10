Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE261379A5E
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhEJWtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEJWtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:49:09 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4DFC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:48:04 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id w6-20020a4a9d060000b02901f9175244e7so3812379ooj.9
        for <stable@vger.kernel.org>; Mon, 10 May 2021 15:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nXDiOD6FS2QgUBLRfCpt2/uv9F17SdmkBwWNRwmru5Y=;
        b=BPmR2yHSGG/nLuv402u0vKb0JU2qqSNNX3PhvngJo0IpvPc9n8GCieuO7tf2JdXB88
         sBtuWmFMGhXg8iogd+KS11T4Pzkx88fCj0f+rAm0Cck5iV87/N7mANFULMD2BDXVQATM
         2i36wm5xBwoVwLMhwx+hYY3qtpKqyrG+UfjHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nXDiOD6FS2QgUBLRfCpt2/uv9F17SdmkBwWNRwmru5Y=;
        b=YPkRV0IotJ54cCPmmUsU3gG6q8SD8Z1Kw5kZVqzSZhzwDDuVQwoMj7g54hETaO0xZj
         WGRC7QDEbtmyubd2f3Do8x0zqEyEUmszSw84qndRE1VFo2tcBNIcxt8jNuQAR9n9ocUw
         bCi/C8BXoXARc2WAQLAUJ6jQ+yVWQUVq0fHXV3R62Gm8G2y2RjQm8z1zYGcRXO7rtoW5
         Mnk9iSmSPgXZgRnhbt/kA0Dx4O3NjnnVeDsY19BttB8bxY0YupGJ+SNXSkB+luAULw3O
         WXkHzbSnECRdNgIw0/nKgtrHq1vj9/WI8g9te3rsyAYRxt9M7lZFfmIkdRdhcycofAXn
         CifQ==
X-Gm-Message-State: AOAM530EgItQNmozg9mW3GcGx2e4ZSWMkFY2qANN3aBfLV8sGINID8Z+
        i1h4yH6fiVMZvHtKTJVoMGH6OQ==
X-Google-Smtp-Source: ABdhPJygFW5jPZZbuqmbpeV4pT6I/uC1MkJ52VitIdzh4m/oQ05mpI5eGlRRJOP3fGBowrRg6ePM7g==
X-Received: by 2002:a4a:e548:: with SMTP id s8mr20898592oot.63.1620686883535;
        Mon, 10 May 2021 15:48:03 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 7sm722530oti.30.2021.05.10.15.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:48:03 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
Date:   Mon, 10 May 2021 16:48:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.20 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and doesn't boot. Dies in kmem_cache_alloc_node() called
from alloc_skb_with_frags()

I will start bisect.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

