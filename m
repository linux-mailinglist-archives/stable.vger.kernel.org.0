Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A840B38B91B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 23:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhETVpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 17:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhETVpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 17:45:22 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FA2C061761
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:43:59 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s7so2048354iov.2
        for <stable@vger.kernel.org>; Thu, 20 May 2021 14:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1A1p8wxcqgkCGRzgXg9Z3bfKxbw/WkU2sJz0crshkMo=;
        b=R+i31MfFD5/De76av2drW60fwsQF3hYf9xkxtv1DIDnttM1q7HGBmq6DfvbO7A+Sjj
         y6mFeQWh02jKo4zv/VM/wCf5XZAPSHDFy0Q1RvGo7nZfo7RK1hGNob+hbStvdlGBt33C
         a1rFQNndFuHnmiNuuYa48xLdrIQg4PHiyhKgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1A1p8wxcqgkCGRzgXg9Z3bfKxbw/WkU2sJz0crshkMo=;
        b=JSMfuvSH1MNcQSMR+kIqylDE0DP3AO8RCVBvchdkIoQFuAaBvsrzm1+UwgDJdqc8wM
         sYoVO6pHZoMJtZAx4xHx/oFkZwlLG2OCou6Nl2y0nbVw+pulXiB8OMlOxN5aHbScyQcO
         msauA94tdIchu4EsZe4Z2t5aDlCL8l2y0Dz66Q6vrrV6v0wjIj6F5Br5Lc8ZqFSWMa96
         bP05KTvw6fYF/f1sHLDjUF8sorp68QvsxHnYiHDqAY6AMIXYoYQmz2ioLaDXWq7gtmRi
         pxk99uFMhiPNQdhFobIm8pDEVaUTgADGV61GS2iIUDDxSykdT1sOvd6tlhh0C4NsR6/T
         708g==
X-Gm-Message-State: AOAM532fA2y3B2UJfKLQFabeA8pURPAB7q72VmUDRwdX2Ex8oRBfHLKr
        /82/EzXTVobBtI3gev19qd11wTvvKXaWKw==
X-Google-Smtp-Source: ABdhPJzVBE+iOJ9hND8REK5+FiKRlk5816BqVFJIMhHjKO4FY4Pw7AyzhzP/Z3azwnAdNc1eJ4QEyg==
X-Received: by 2002:a6b:8e04:: with SMTP id q4mr7797963iod.54.1621547039022;
        Thu, 20 May 2021 14:43:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f11sm4620527iov.9.2021.05.20.14.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 14:43:58 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210520152240.517446848@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6c505aa0-8cad-2084-8e54-8d229d050931@linuxfoundation.org>
Date:   Thu, 20 May 2021 15:43:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/21 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc2.gz
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
