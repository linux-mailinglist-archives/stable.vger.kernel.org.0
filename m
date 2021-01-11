Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72752F24DB
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 02:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404161AbhALAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 19:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404176AbhAKXl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 18:41:56 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC91C06179F
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:41:16 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id f132so429426oib.12
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 15:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DxYrBJpzsTdpCByMlubd+zVD3VF017W+hAmhZMV80Cc=;
        b=a0tSDinUzyGLUdtYVRMKC4u7GO14DYqrjuasJK/0xVI3QavqBnhBjgFbWKkcM63xcF
         BTxggTyb+ssXEWHFcJoS8IAFxOSYxn67ng5ZXiLdFB1QJ+bpTkJrBZnwJkNmBWjuSu91
         0fD54ruhsG/ynTkZ5ntl8COmatmZ4RXdttHbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DxYrBJpzsTdpCByMlubd+zVD3VF017W+hAmhZMV80Cc=;
        b=ARcmQcagwa+upJUUnE4AJPC9M8+E/VWS73GIoQhsakIpl4sWK/8pxW+p5kRWfS524p
         Sg5YlaeczPFZ93cqU/qnkQ6Ket9YDVPQdUu+EUvHNYfFoyyHZ4fs6cP1+gYwhzKPbASI
         /92uRQIOu/teTGV8hx1htYNxSE4PWXCcy1J3+V9wEsEUjhQ5B6pUP9F98U1PpTAfGzd1
         cjdy9Z7cht9P6x1IFwFkCc6pelqFxiVI+6Ok8OsC2hU8bKtGUKVKpCGkhTE8pXfBQ7jS
         woXXJTBq7QuJMw10DVeNAdaFzh79SQzJmXF6jRxZpOa8jzoBBF1Z/t6aWFW7j09vMCw2
         ou3w==
X-Gm-Message-State: AOAM530+woOyggQYbW5jNgzDPrerd3pXYprxqPLtFbVTWIkHWPLQn9OM
        rHDBGkrV7nZWbp+1GI7/R9k8UA==
X-Google-Smtp-Source: ABdhPJyRrXzc4mH6hqhnKZYXg0y1KFDAIPAvMPIRRSnaddNEqDgfNKpVTkQDWxUeC79c3a1NwhwXgg==
X-Received: by 2002:aca:474b:: with SMTP id u72mr759324oia.114.1610408475768;
        Mon, 11 Jan 2021 15:41:15 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 8sm294009oii.45.2021.01.11.15.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 15:41:15 -0800 (PST)
Subject: Re: [PATCH 4.4 00/38] 4.4.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9a2f41e9-6da8-fdd9-a0e0-d2c68900fe0e@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 16:41:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 6:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.251 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.251-rc1.gz
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

