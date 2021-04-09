Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC835A7F5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhDIUjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbhDIUjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:39:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26371C061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 13:39:18 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e186so7220334iof.7
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 13:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FGfX5TmqBx32OBvwAjpKaY+KA4LiepNY7Un7Dew26tA=;
        b=WltMpC4qUtPUa1/kLe8yfI/2GtcaaTm0ODsC03X/ZtFkMVf6dgtOjEaALNAIneAF5E
         Kzuoh36XmB1pcsHLA+Umj46oTao+3hn9n4Nte72wXQcaySDdqo/sE2pSV0cleSLP0kQ6
         NkyJgRl5qoLibaopYits37RkFYn2ybZHEKXX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGfX5TmqBx32OBvwAjpKaY+KA4LiepNY7Un7Dew26tA=;
        b=SChEGPuyAWRcL4iZNBKATpX+6NrjsJupKv67+TZNBXg5nKYiupoFKGAx6XBl8TvLXU
         MaqIzZwY9p1b9mKs0nlTnPpk+Nlck+6k/DRItqvRcPrPfWyCukl1tDSHNnJCV4/MceYv
         NPZffptY+31NNNNzjKlvqLoCnUCwjuHRvvzA2HBMVd9olrzaPmvlz67urRshz0AyO/50
         Hqnr/CwYUretLgTIAAk9oGnMrJ57jHBSE6809fA1I8F/bzRiRGltHu4u+3KLhj7MbzBK
         urPm7FQTsSQJ03sikdfQ/rY7UIELYJ0gXpSHV/pIOWbe9rGnIJwcMQ8VHjv/8NroQ/PN
         ol1A==
X-Gm-Message-State: AOAM530EAh+a13V4BxDUiZOvWAFztpSOwN2xPQlVbPCvavD16QevXmu9
        2Leny8uywqTCjaC17Z6xLbBWmQ==
X-Google-Smtp-Source: ABdhPJyO+/53JyP7yFDOi6MndCyH+AKchtR0CX73iuood2fncvaXZZV0oP+bGccnduKMcuKQTwnUmQ==
X-Received: by 2002:a6b:fe13:: with SMTP id x19mr12993757ioh.73.1618000757689;
        Fri, 09 Apr 2021 13:39:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g12sm1537584ile.71.2021.04.09.13.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:39:17 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/23] 5.4.111-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210409095302.894568462@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <92f275a3-77a8-71c3-ddf4-c0e647d7724d@linuxfoundation.org>
Date:   Fri, 9 Apr 2021 14:39:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.111 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.111-rc1.gz
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
