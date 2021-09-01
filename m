Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233133FE4DB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhIAVYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 17:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344252AbhIAVYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 17:24:32 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6BAC061757
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 14:23:35 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id s16so710714ilo.9
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q1LfVOA2zbYulHqfsZyGdjn4c/2ecw9j1MvJIO3DIlI=;
        b=eRRssz1TyyeDLBqZSl/989Lm93UxHFqqqSQvlEuB0lorYSU//U9ongjFyeN6n/vOaB
         QDHOZNuFfzovUUyUn4GJySIVvyQz85RlJWeYG0N9LGvnyGAecY8gcO60qgKX0YkmD8m/
         ElrUUu9qPeXOR0QJFZYlmA+lPqS5+78/F9FRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q1LfVOA2zbYulHqfsZyGdjn4c/2ecw9j1MvJIO3DIlI=;
        b=bP1uURvFt5UaWHIlVWVag4jEiQ4tbvTOiAFS8omJskuz83p5hGE1WqFsfRrUvb3Ndz
         T5vSCvOLlrUgtTueBpezhKwW5dcYmJ/rxaZzWZvTsANPzV+zKGqbWR1279J6I8+Tz29V
         byBNRWt2s+mvg7L4LTiB8dGwAde7pimNEMK9J8LpPDW3alyPp/IH4LlUCZgCaYY/uexg
         jx+826L+ML8plDYT5aEyQEoYCLxKH5ysqoPYTSLWaqN9qTxpzyy79L/yAXCnHqSKJ0VP
         Pz0lPb6YY87Mh3kvxqKi8NmASOy6fa6Cbttcul/w1aJqQWpFcoa0DYfQM6CIbSgAgfDW
         RcRw==
X-Gm-Message-State: AOAM531pZRwg8jKHmSoT1CEcSHYa0GQ+3X+/2HnWNzR7Xmxf8gwJcb+f
        VSL65wZPS44xy6MEZhXKzXSBUw==
X-Google-Smtp-Source: ABdhPJyasgYMyDc10Y02NFEGlMWyKwt1AFCL7hWokduMw8pArVCBcgViSq/2xVb2BjLBqM641djpbQ==
X-Received: by 2002:a92:ce86:: with SMTP id r6mr1074924ilo.170.1630531414833;
        Wed, 01 Sep 2021 14:23:34 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c4sm459964ioo.2.2021.09.01.14.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:23:34 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/33] 4.19.206-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ada79071-be64-08e1-fc4c-e9f690553cdb@linuxfoundation.org>
Date:   Wed, 1 Sep 2021 15:23:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/21 6:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.206 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.206-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

