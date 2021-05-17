Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5713B386B1C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 22:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhEQUSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 16:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237507AbhEQUSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 16:18:16 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604E0C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:16:59 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h6so7156616ila.7
        for <stable@vger.kernel.org>; Mon, 17 May 2021 13:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fDQTNaQmAXFNwN76z6d0dvXjcYPHqqxGBKpJxNqD/DQ=;
        b=EG98P0gmuTNxCqd3/01WOeAhqMcIkxKVOWstf6h55Csp/hFo+Iv3rmeGP8JKFzNHJP
         7HqhL3y4qSYPKp2DQg9twjJQiBmufrFvNmb/9/ZLVWckDyTD6BzzSzH+fLBrDxvWRU3J
         le9t1ss4TYy9rAeLyN4fuc86wInQZ3lfgzBbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDQTNaQmAXFNwN76z6d0dvXjcYPHqqxGBKpJxNqD/DQ=;
        b=NI+yRDE1KCel+BKDFm7aB6M6qxNCIH+769NXe7pHpRS1J8sGprRR/ydm3TfP1it3L7
         7TIrJ/p7iZPjXvj2ANqpMvCq9yfDkMQMNrrhZau9n/pz4LYc7jgxEPz9VILmHQ2MB6Z7
         DpfjZJz92d4zONF5cx7HaWIhDdNZlnhMclbLG/crNJlpn0uoLMcGvmgfilGHofo8vsvY
         Dga/lmrkRK+34iYcouWd82QkWpH6/CQNkVHwlycmb9ESZr4wb0BINgSVSu3CyfS2bUXv
         6OoepnNTBpi2rVw21H33gcWaH4tSp2lekDdWHfjZUgzTyDH/XY6CL75vcCKalm2IlgWM
         qnZg==
X-Gm-Message-State: AOAM532RZiGHUF7Q8ggoOz5ZMjFunais6e6pdXN8goeAw0AmIMlnuNmJ
        XC2Os9T0MB8tVAQWqst3iSH6JA==
X-Google-Smtp-Source: ABdhPJxtb8QeIoO3IB50Q43v/C6DbMLsuqPnLWzXrbCzctyGwdG/f4wWrFTzEa9MeZlNQ7YiTYMdjA==
X-Received: by 2002:a92:d110:: with SMTP id a16mr1237752ilb.84.1621282617907;
        Mon, 17 May 2021 13:16:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s17sm9108635ilq.26.2021.05.17.13.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 13:16:57 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fc3b9880-32c0-99ba-90a5-cc2303cb67e8@linuxfoundation.org>
Date:   Mon, 17 May 2021 14:16:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/21 7:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
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
