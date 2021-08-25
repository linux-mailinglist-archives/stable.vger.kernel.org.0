Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ED93F7EB4
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhHYWiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhHYWiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 18:38:05 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD06C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:37:19 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so927935otg.11
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MHOsNp/Hfo3pJmwpbDXaaMZDHfazyUIne/aGLJBlAg8=;
        b=NRLQFafXPKX1ofRcOxpR3N9rdfCRHLXRUhrp2xfESH9c9kC98wZvGSYnYdq0ZH1r03
         NF51WZERL1HG8y4ccA5HIVxCZYJLIg+9m1sj6Zr7DSKIY5oumcH6vD2D1UA2IzqKQHJy
         2Sz0GJUgPXiTZgdhlJS3W9ClkP1JXw7CH7+II=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MHOsNp/Hfo3pJmwpbDXaaMZDHfazyUIne/aGLJBlAg8=;
        b=DmvEMLLbuofuP+7PDyPk3mqG1Sn9M4gbH4f4ubgWv6W3YmTGoHQI8ADQ8ZvaQ7DWev
         Ekj8zZpDULk+Uvy3mseHG8Q7Q1v/9xRkduig+AptSbO+uiE4DfxJHvZt250J+m9CH/6W
         kJl1obz87a1YDT/B7dB0NWTN8RbWxU5zWbAEZHe+KQKMKln3IT/QjldfDhIMMGpdMn16
         Bk+8ithuctu5f55yjFP00sd0MIqM7MY3yanye58pVlX7N56p0dqUrpKuXYYPnzayABgL
         b/kNN2oCCMSCqjgZnSVEGHtx9nXsr4EwLlduGOOOW41m04IFbh4MAWtU7b7YfcQ4Co1k
         wCHA==
X-Gm-Message-State: AOAM530El15kypHjqdegg+BNh9MMAJZ5ms52JmE8kC9W4FWCcFuvRHzU
        zCk/iNXTXgZWLYzDIwKSA1tz8w==
X-Google-Smtp-Source: ABdhPJzh1ERGwtf+75Ned2Oo4eEIfFnD8JGM1Wsq3y6z+8Qk8bAmt/HOgKgKD7ZR1Su5VX7tFGi0ZA==
X-Received: by 2002:a9d:6347:: with SMTP id y7mr580413otk.241.1629931038759;
        Wed, 25 Aug 2021 15:37:18 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n17sm225020otl.32.2021.08.25.15.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 15:37:18 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/43] 4.9.281-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824170614.710813-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9c595594-8771-8d3d-bf53-fe27455448eb@linuxfoundation.org>
Date:   Wed, 25 Aug 2021 16:37:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/21 11:05 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:06:11 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.9.y&id2=v4.9.280
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
