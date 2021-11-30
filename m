Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB68462968
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhK3BHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhK3BHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:07:04 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D87C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:03:46 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id x6so23756160iol.13
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ub8y2t6CvoWMMXL1SGmN4XQr4X7Aiu40uy05RxrBVYo=;
        b=JLxMn9RIg9DVen50YD9OJ8uTaf/Zv32uIT+xhmowlYAssutOE7PeZldeZtNYyKRRJF
         0q/d6FZ2wampMwlOStx43G+PJ0s5/0ona19n19CYTwET0/rFDv4pox6WbRdGXfCWjojh
         890a+bm+TawB/180ubwIH1g7FhZ/M/TszJXJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ub8y2t6CvoWMMXL1SGmN4XQr4X7Aiu40uy05RxrBVYo=;
        b=xKNri/250pFx5OUlU35WdpbFcH8EeI/n0Y8lOMUyx1o9BGHEgU73+1QEhUHlB20kYJ
         UyuJy9gmoMIh6hFoBLMjwHlEDQFXFdDhzP8oJBDYMaTY876DP33+vNppgXpQJDHrVT91
         IKb5XPznyyhMz4t+5RpjCixym1qnMdTxRVeCsup7uHE7LmwfpI9ofDvyz8Slf6diNgiT
         AEeqVxzGpfGum73fz+/AhY9NXg7Uwe54ydPo7c5nA66TqNAcgzllQ/9hzghK6fHQjZrY
         pP/00AV5NJ5yjoQ4obaE2khH6VGoyGHmB5hq37r6nekBbh3BO81w4d3a1cqwFzrfkuqm
         eKMg==
X-Gm-Message-State: AOAM530pZxYYA34xcnpD31KZJ7Re1eXvy5pw6Wk4ydyvQdP+m5TOJPyW
        Pc7Ah479xQ7+9K1PzhOVMgydNmOwX1Ilnw==
X-Google-Smtp-Source: ABdhPJxzKZel7RToshHbtSXYVhU0BewSja8jSUE++YKfspqxG7JezEL2Kf5IVNq8ZYGtvfBTKfC2jA==
X-Received: by 2002:a05:6602:2b94:: with SMTP id r20mr1286666iov.97.1638234225485;
        Mon, 29 Nov 2021 17:03:45 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s3sm8745381ilv.69.2021.11.29.17.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 17:03:45 -0800 (PST)
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1fdb90eb-87d4-2625-42fd-1f21a6a30f07@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 18:03:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/21 11:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.163-rc1.gz
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
