Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5BF47B620
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 00:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhLTXSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 18:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhLTXSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 18:18:49 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC1C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:18:49 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id b187so15384857iof.11
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 15:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4B4SpmhHdx32X53AjRVhtZIKXk5wDvradjqSsrhDOgI=;
        b=Q8zVjjmunIoMGwz6yF3kRubQW3ZhM5k0KDvYc2oJJU3kdmMnuisN3povwfgAy8whhA
         7iYiqnE7SQj9nAk077x3PwUTMXkbUeuS4KVqR5aXegJnbKcW0eVIxwRGmLqrKpY4bbH8
         LMK/lRmPu/FQjRyxOLlVae4iU9x7hRYZQFGmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4B4SpmhHdx32X53AjRVhtZIKXk5wDvradjqSsrhDOgI=;
        b=Gryk8i9dm+h3tdXb1OzzFitgsUb8D9p80TMJn+XsrhXD53ekHGkxgHT5V4EBmvSubY
         jpHY+G7+mn50YH2k5CE5hWTFsotuTQTSgNvR3fFs6Kq5huy4hctggNUJsh/REJBRxtxW
         Supo2ve4vY9HjWPCcA+8pmuRxubQNnqZ/kuPdbFVOV/K3GFlRmcxxr2ebp369uDlZJD/
         NS5wpcke/5/UfFbhl4NTTXtBqg28oUjz2Q6HUdg//3lUX7AvYzgFr3yJCAGWpJfXbd9u
         Vk5bI/q8Tfv3pwgSPnS0+lO7tY7TgQPpJva4ogjNqheulJTuvxba+3/dE+wCZADda1OE
         DCqg==
X-Gm-Message-State: AOAM530o4nOyz9qDE6Kx6+pJSUyZZ0kWZJoZAPNt0r6ceTYDTcICzpSa
        u+WNqyAvw9BX6EtlvjQtdhRq5A==
X-Google-Smtp-Source: ABdhPJyFWAmyaqDsuuJsjaj/5uQ1MKXqNUg/C/yrD1PA7pWrKwWy3oCnFwQ1UBvKuAJaRwTNCcfsvQ==
X-Received: by 2002:a05:6638:11c5:: with SMTP id g5mr290612jas.47.1640042328765;
        Mon, 20 Dec 2021 15:18:48 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g8sm12120644ilf.75.2021.12.20.15.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 15:18:48 -0800 (PST)
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <55c3b5d2-f84b-a58a-deec-862fd39200e8@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 16:18:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/20/21 7:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
