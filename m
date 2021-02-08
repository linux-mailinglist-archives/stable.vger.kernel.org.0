Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8537F3140CB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 21:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhBHUph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 15:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhBHUog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 15:44:36 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330D3C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 12:43:44 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o7so9542896ils.2
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 12:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=807lxy1fYZaU0OxFWMzgZCdayMWMKzd8L2WDBpZVTMY=;
        b=aDVSDmwP9uP1GA8PNHtbI/ALs2TPNfefwKiMwGfoQgcXVcS7DbAU0JrgGCzpIc+hh4
         2eOZEJ6gclKzN8gaILOixUFPR2+aB6/BoBhc8lPcG+NKALcKpHRwj7YCdQWXP2LkdyYe
         9Ob7O7RMCvhcLzzeDh+XEcYQZ/r64PEVN7VxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=807lxy1fYZaU0OxFWMzgZCdayMWMKzd8L2WDBpZVTMY=;
        b=HtpS34w+GHSYUODH77Fu8Hzn3RQJ+F1vk6ruiaQHd8zqNSKcJQ0bGm5IXP6w3souZ6
         Nf4qs9gF7FbTtQl3PHwSvQ/h9YZbFXv+mHePA2M5jYtNFkctckxGfcEowbDVAhmFHJkK
         WjK3KBvNOMmP3wglAAeGnHQlgPQLROEApAwoTtZDyLvaJ6KWVIb6/GMLsBKVWlL/LpYR
         7TRNzBCD8RZqKWgKKP03RMIUtsFzkilQOZTBNG1JnyNtqdPMaO+Wqxiot4Fe/niwav8S
         JZA77xpzR/V/0XAf91RV+vS8/sIdjZWaE3oDe6FPvORleWV73kLjhr1mY+P5u7dN9VoT
         FDrQ==
X-Gm-Message-State: AOAM531NPummevxTUEr30FdUmyHaOmRvyjiHvy7eboMe4r79ZibA5sjy
        lGuhix2VUSCszPezPJy4Qn7X9Q==
X-Google-Smtp-Source: ABdhPJyvAqvZEF+1/i5WJsS4TeAG9ffvNNTWPGRlHUrabfeglPU4ZaHQVJBndNVyCPwLjADNoRhmjg==
X-Received: by 2002:a92:c265:: with SMTP id h5mr16418423ild.225.1612817023687;
        Mon, 08 Feb 2021 12:43:43 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c19sm9298144ile.17.2021.02.08.12.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 12:43:43 -0800 (PST)
Subject: Re: [PATCH 4.4 00/38] 4.4.257-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6a64f222-59c3-f6a6-50ac-ac95e6591b36@linuxfoundation.org>
Date:   Mon, 8 Feb 2021 13:43:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/21 8:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.257 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.257-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
