Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9747334A44
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhCJV73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 16:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhCJV65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 16:58:57 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A9CC061756
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 13:58:57 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z13so19652101iox.8
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 13:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ou8t2644clBJEFCW8xgVuPgTcW8tsILaR00wXEKb658=;
        b=T0lqgYv8sRA4rVC80yotgtAVVlztll+UQ43Zoo16CGQXp4HC8IgW+/+MxSE4heVjjr
         q3zEsAEG44nJ9ZdbOJZ/wKwdPHCjViazptKJM8Kx09EpxPDpsJW23LSAXOaoDn2CN+vK
         yIUlLWkzXuH9Qr6K76PZv/QRx7xWlPCeSbdQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ou8t2644clBJEFCW8xgVuPgTcW8tsILaR00wXEKb658=;
        b=ChNbHrMkb+Epwlwtdjbw7BEhGeDWGQvv1xEUwW6Otbuj5B0c5fosQrewky6GdRdy2n
         Xx6K3ls1WJrnbsF4t3XLxfyyi7J1fLhBY14UELo10HWQBEr4MFzZo8YLI/ErT6mA7gOK
         jcLc4qOxPwOwUolBmbMHIG0hImIDX6ypE5hEoMfa9HxevVcF9tyyuyOy/GISHzQOVOfx
         43BBoWlvGD6kSbvBkatKXzeJnyIIFKf98NxrUPg8KlA0W1nXC10ZUxXq87zvIz26nYGA
         YeWiVS8tGHD8vuxitn8x9B0E+yd7feEVPG5Zy35DkIbYIatCdS5cCDpg5d1KDUkfeDY0
         zYVA==
X-Gm-Message-State: AOAM5301O/Tm6pE3O6ZvlnfyxQZxLs7bwB4MWPWG2lYN1EAvHP1eda+E
        N+n1p72BCY9uvFpN4h+N1l3JmQ==
X-Google-Smtp-Source: ABdhPJxfxh5cM3jQ4efUr+mJ/67fqF77BKs9szq61w4mUtQb1fOMAYvHL1ZxOsXS+ruJKhpgY1s8gg==
X-Received: by 2002:a5d:9e47:: with SMTP id i7mr4026297ioi.104.1615413536364;
        Wed, 10 Mar 2021 13:58:56 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a14sm292226ilj.39.2021.03.10.13.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 13:58:56 -0800 (PST)
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310182834.696191666@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c40e2e70-5907-19d4-c917-9dd835d0747f@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 14:58:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 11:29 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
