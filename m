Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8614073C5
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 01:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhIJXTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 19:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhIJXTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 19:19:02 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC49C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:17:51 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id b4so3677207ilr.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 16:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AZZxOT/dHoIwpR1vFcEmPLq9AxVxoEt+GZF6KYf+Vpg=;
        b=Duv6BGs7HS4LByiqM5BUQPl5fxTUQ0ONfxSKcbtd6xqQcr6wStJv+WbsuNxS8Xk32d
         ZEUiRmpXX7IBW5x9T7CLM7tLxsGH1TQfKik23WuMDZWdzPLLynzU8P1QxYzLujnH6PMX
         PNof2a9rWIIgaEi+yzn1g+RBpDFa5X0klBn/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZZxOT/dHoIwpR1vFcEmPLq9AxVxoEt+GZF6KYf+Vpg=;
        b=4Rt3bE7PDkBwHGyetdRJdfE6BDNttApIHbMQN9qj9FjoS6fH/yaXaA/I1W65ZO+grF
         xzKTTYBhOOOwO4l47c349fzjHU2SHV2fB+4X7CH/eRfzigDD3sgF8PuB1/gn0JNz2Vva
         wJdBcB3KQvMn7SEw6xHyLAvUGry2mbvZsJ8zy7QCRVAyUuiAXUC9Li50HfaScLphq1Nc
         nq850tCyEtMDnXdoe8e7I/A5bUpv5bcK96NmuzWjVh8D56yZkYuBL/mj9taPQsGIpMH1
         wMlO9lVIH4xdoBF5u36xImwPPLU1qyO1tchRdVU7a1USoTLbk4+EFyyWYqpvvJMtzaqB
         d8zw==
X-Gm-Message-State: AOAM5308c/xOGLvg4+/PFPEkGW2/WHI984UlTTxZHQQjdlKNundsADF/
        BUzDWlqxrxbN1siFTgJDUPP7Qw==
X-Google-Smtp-Source: ABdhPJx2d2DStmKeakjVHLuVur8H+4E+5sy7aRKRyJGHYHoTEOHFGBQ7RnJE9wIYpem392+MioeKpg==
X-Received: by 2002:a05:6e02:1d06:: with SMTP id i6mr73741ila.113.1631315870641;
        Fri, 10 Sep 2021 16:17:50 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g23sm71139ioc.8.2021.09.10.16.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 16:17:50 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/22] 5.13.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <204b4caf-b897-6cb6-ad69-85117d6b13cf@linuxfoundation.org>
Date:   Fri, 10 Sep 2021 17:17:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/21 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.16 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.16-rc1.gz
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
